/*
 @author: ideawu
 @link: https://github.com/ideawu/Objective-C-RSA
*/

#import "JSRSA.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#include "pem.h"

#define kChosenDigestLength CC_SHA1_DIGEST_LENGTH  // SHA-1消息摘要的数据位数160位


@interface JSRSA()
+ (NSData *)getHashBytes:(NSData *)plainText;
@end

@implementation JSRSA

/*
static NSString *base64_encode(NSString *str){
	NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
	if(!data){
		return nil;
	}
	return base64_encode_data(data);
}
*/

NSString *base64StringWithData(NSData *signature)
{
    int signatureLength = [signature length];
    unsigned char *outputBuffer = (unsigned char *)malloc(2 * 4 * (signatureLength / 3 + 1));
    int outputLength = EVP_EncodeBlock(outputBuffer, [signature bytes], signatureLength);
    outputBuffer[outputLength] = '\0';
    NSString *base64String = [NSString stringWithCString:(char *)outputBuffer encoding:NSASCIIStringEncoding];
    free(outputBuffer);
    return base64String;
}

NSData *dataWithBase64String(NSString *base64String)
{
    int stringLength = [base64String length];
    const unsigned char *strBuffer = (const unsigned char *)[base64String UTF8String];
    unsigned char *outputBuffer = (unsigned char *)malloc(2 * 3 * (stringLength / 4 + 1));
    int outputLength = EVP_DecodeBlock(outputBuffer, strBuffer, stringLength);
    
    int zeroByteCounter = 0;
    for (int i = stringLength - 1; i >= 0; i--)
    {
        if (strBuffer[i] == '=')
        {
            zeroByteCounter++;
        }
        else
        {
            break;
        }
    }
    
    NSData *data = [[NSData alloc] initWithBytes:outputBuffer length:outputLength - zeroByteCounter];
    free(outputBuffer);
    return data;
}


static NSString *base64_encode_data(NSData *data){
	data = [data base64EncodedDataWithOptions:0];
	NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return ret;
}

static NSData *base64_decode(NSString *str){
    
	NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
	return data;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
	// Skip ASN.1 public key header
	if (d_key == nil) return(nil);
	
	unsigned long len = [d_key length];
	if (!len) return(nil);
	
	unsigned char *c_key = (unsigned char *)[d_key bytes];
	unsigned int  idx	 = 0;
	
	if (c_key[idx++] != 0x30) return(nil);
	
	if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
	else idx++;
	
	// PKCS #1 rsaEncryption szOID_RSA_RSA
	static unsigned char seqiod[] =
	{ 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
		0x01, 0x05, 0x00 };
	if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
	
	idx += 15;
	
	if (c_key[idx++] != 0x03) return(nil);
	
	if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
	else idx++;
	
	if (c_key[idx++] != '\0') return(nil);
	
	// Now make a new NSData from this buffer
	return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

//credit: http://hg.mozilla.org/services/fx-home/file/tip/Sources/NetworkAndStorage/CryptoUtils.m#l1036
+ (NSData *)stripPrivateKeyHeader:(NSData *)d_key{
	// Skip ASN.1 private key header
	if (d_key == nil) return(nil);

	unsigned long len = [d_key length];
	if (!len) return(nil);

	unsigned char *c_key = (unsigned char *)[d_key bytes];
	unsigned int  idx	 = 22; //magic byte at offset 22

	if (0x04 != c_key[idx++]) return nil;

	//calculate length of the key
	unsigned int c_len = c_key[idx++];
	int det = c_len & 0x80;
	if (!det) {
		c_len = c_len & 0x7f;
	} else {
		int byteCount = c_len & 0x7f;
		if (byteCount + idx > len) {
			//rsa length field longer than buffer
			return nil;
		}
		unsigned int accum = 0;
		unsigned char *ptr = &c_key[idx];
		idx += byteCount;
		while (byteCount) {
			accum = (accum << 8) + *ptr;
			ptr++;
			byteCount--;
		}
		c_len = accum;
	}

	// Now make a new NSData from this buffer
	return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}

+ (SecKeyRef)addPublicKey:(NSString *)key{
	NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
	NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
	if(spos.location != NSNotFound && epos.location != NSNotFound){
		NSUInteger s = spos.location + spos.length;
		NSUInteger e = epos.location;
		NSRange range = NSMakeRange(s, e-s);
		key = [key substringWithRange:range];
	}
     
	key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
	
	// This will be base64 encoded, decode it.
	NSData *data = base64_decode(key);
	data = [JSRSA stripPublicKeyHeader:data];
	if(!data){
		return nil;
	}

	//a tag to read/write keychain storage
	NSString *tag = @"RSAUtil_PubKey";
	NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
	
	// Delete any old lingering key with the same tag
	NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
	[publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
	[publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
	SecItemDelete((__bridge CFDictionaryRef)publicKey);
	
	// Add persistent version of the key to system keychain
	[publicKey setObject:data forKey:(__bridge id)kSecValueData];
	[publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
	 kSecAttrKeyClass];
	[publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
	 kSecReturnPersistentRef];
	
	CFTypeRef persistKey = nil;
	OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
	if (persistKey != nil){
		CFRelease(persistKey);
	}
	if ((status != noErr) && (status != errSecDuplicateItem)) {
		return nil;
	}

	[publicKey removeObjectForKey:(__bridge id)kSecValueData];
	[publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
	[publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
	[publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	
	// Now fetch the SecKeyRef version of the key
	SecKeyRef keyRef = nil;
	status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
	if(status != noErr){
		return nil;
	}
	return keyRef;
}

+ (SecKeyRef)addPrivateKey:(NSString *)key{
//	NSRange spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
//	NSRange epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
//	if(spos.location != NSNotFound && epos.location != NSNotFound){
//		NSUInteger s = spos.location + spos.length;
//		NSUInteger e = epos.location;
//		NSRange range = NSMakeRange(s, e-s);
//		key = [key substringWithRange:range];
//	}
//     
//	key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//	key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//	key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//	key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];

	// This will be base64 encoded, decode it.
	NSData *data = base64_decode(key);
	data = [JSRSA stripPrivateKeyHeader:data];
	if(!data){
		return nil;
	}

	//a tag to read/write keychain storage
	NSString *tag = @"RSAUtil_PrivKey";
	NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];

	// Delete any old lingering key with the same tag
	NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
	[privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
	[privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
	SecItemDelete((__bridge CFDictionaryRef)privateKey);

	// Add persistent version of the key to system keychain
	[privateKey setObject:data forKey:(__bridge id)kSecValueData];
	[privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)
	 kSecAttrKeyClass];
	[privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
	 kSecReturnPersistentRef];

	CFTypeRef persistKey = nil;
	OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
	if (persistKey != nil){
		CFRelease(persistKey);
	}
	if ((status != noErr) && (status != errSecDuplicateItem)) {
		return nil;
	}

	[privateKey removeObjectForKey:(__bridge id)kSecValueData];
	[privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
	[privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
	[privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];

	// Now fetch the SecKeyRef version of the key
	SecKeyRef keyRef = nil;
	status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
	if(status != noErr){
		return nil;
	}
	return keyRef;
}

/* START: Encryption & Decryption with RSA private key */

+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
	const uint8_t *srcbuf = (const uint8_t *)[data bytes];
	size_t srclen = (size_t)data.length;
	
	size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
	void *outbuf = malloc(block_size);
	size_t src_block_size = block_size - 11;
	
	NSMutableData *ret = [[NSMutableData alloc] init];
	for(int idx=0; idx<srclen; idx+=src_block_size){
		//NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
		size_t data_len = srclen - idx;
		if(data_len > src_block_size){
			data_len = src_block_size;
		}
		
		size_t outlen = block_size;
		OSStatus status = noErr;
		status = SecKeyEncrypt(keyRef,
							   kSecPaddingPKCS1,
							   srcbuf + idx,
							   data_len,
							   outbuf,
							   &outlen
							   );
		if (status != 0) {
			NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
			ret = nil;
			break;
		}else{
			[ret appendBytes:outbuf length:outlen];
		}
	}
	
	free(outbuf);
	CFRelease(keyRef);
	return ret;
}

+ (NSString *)encryptString:(NSString *)str privateKey:(NSString *)privKey{
	NSData *data = [JSRSA encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] privateKey:privKey];
	NSString *ret = base64_encode_data(data);
	return ret;
}

+ (NSData *)encryptData:(NSData *)data privateKey:(NSString *)privKey{
	if(!data || !privKey){
		return nil;
	}
	SecKeyRef keyRef = [JSRSA addPrivateKey:privKey];
	if(!keyRef){
		return nil;
	}
	return [JSRSA encryptData:data withKeyRef:keyRef];
}

+ (NSData *)decryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
	const uint8_t *srcbuf = (const uint8_t *)[data bytes];
	size_t srclen = (size_t)data.length;
	
	size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
	UInt8 *outbuf = malloc(block_size);
	size_t src_block_size = block_size;
	
	NSMutableData *ret = [[NSMutableData alloc] init];
	for(int idx=0; idx<srclen; idx+=src_block_size){
		//NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
		size_t data_len = srclen - idx;
		if(data_len > src_block_size){
			data_len = src_block_size;
		}
		
		size_t outlen = block_size;
		OSStatus status = noErr;
		status = SecKeyDecrypt(keyRef,
							   kSecPaddingNone,
							   srcbuf + idx,
							   data_len,
							   outbuf,
							   &outlen
							   );
		if (status != 0) {
			NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
			ret = nil;
			break;
		}else{
			//the actual decrypted data is in the middle, locate it!
			int idxFirstZero = -1;
			int idxNextZero = (int)outlen;
			for ( int i = 0; i < outlen; i++ ) {
				if ( outbuf[i] == 0 ) {
					if ( idxFirstZero < 0 ) {
						idxFirstZero = i;
					} else {
						idxNextZero = i;
						break;
					}
				}
			}
			
			[ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
		}
	}
	
	free(outbuf);
	CFRelease(keyRef);
	return ret;
}


+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey{
	NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    NSData *data = dataWithBase64String(str);
	data = [JSRSA decryptData:data privateKey:privKey];

	NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return ret;
}

+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey{
	if(!data || !privKey){
		return nil;
	}
	SecKeyRef keyRef = [JSRSA addPrivateKey:privKey];
	if(!keyRef){
		return nil;
	}
	return [JSRSA decryptData:data withKeyRef:keyRef];
}

/* END: Encryption & Decryption with RSA private key */

/* START: Encryption & Decryption with RSA public key */

+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey{
	NSData *data = [JSRSA encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] publicKey:pubKey];
	NSString *ret = base64_encode_data(data);
//    NSString *ret = base64StringWithData(data);

	return ret;
}

+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey{
	if(!data || !pubKey){
		return nil;
	}
	SecKeyRef keyRef = [JSRSA addPublicKey:pubKey];
	if(!keyRef){
		return nil;
	}
    NSData * encrypteData = [JSRSA encryptData:data withKeyRef:keyRef];
    return encrypteData;
}

+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey{
	NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
	data = [JSRSA decryptData:data publicKey:pubKey];
	NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return ret;
}

+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey{
	if(!data || !pubKey){
		return nil;
	}
	SecKeyRef keyRef = [JSRSA addPublicKey:pubKey];
	if(!keyRef){
		return nil;
	}
	return [JSRSA decryptData:data withKeyRef:keyRef];
}

/* END: Encryption & Decryption with RSA public key */

/* START: Sign with RSA private key */

+ (NSData *)getHashBytes:(NSData *)plainText {
    
    CC_SHA1_CTX ctx;
    uint8_t * hashBytes = NULL;
    NSData * hash = nil;
    
    // Malloc a buffer to hold hash.
    hashBytes = malloc( kChosenDigestLength * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, kChosenDigestLength);
    // Initialize the context.
    CC_SHA1_Init(&ctx);
    // Perform the hash.
    CC_SHA1_Update(&ctx, (void *)[plainText bytes], [plainText length]);
    // Finalize the output.
    CC_SHA1_Final(hashBytes, &ctx);
    
    // Build up the SHA1 blob.
    hash = [NSData dataWithBytes:(const void *)hashBytes length:(NSUInteger)kChosenDigestLength];
    if (hashBytes) free(hashBytes);
    
    return hash;
}
/**********MD5
+ (NSData *)getHashBytes:(NSData *)plainText {
    CC_MD5_CTX ctx;
    uint8_t * hashBytes = NULL;
    NSData * hash = nil;
    
    hashBytes = malloc( kChosenDigestLength * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, kChosenDigestLength);
    CC_MD5_Init(&ctx);
    CC_MD5_Update(&ctx, (void *)[plainText bytes], [plainText length]);
    CC_MD5_Final(hashBytes, &ctx);
    
    hash = [NSData dataWithBytes:(const void *)hashBytes length:(NSUInteger)kChosenDigestLength];
    if (hashBytes) free(hashBytes);
    
    return hash;
}
 **********/

+ (NSData *)signData:(NSData *)data privateKey:(NSString *)privKey{

    if(!data || !privKey){
        return nil;
    }
    SecKeyRef keyRef = [JSRSA addPrivateKey:privKey];
    if(!keyRef){
        return nil;
    }
    
    size_t signedHashBytesSize = SecKeyGetBlockSize(keyRef);
    uint8_t* signedHashBytes = malloc(signedHashBytesSize);
    memset(signedHashBytes, 0x0, signedHashBytesSize);
    
    //begin:SHA1WithRSA 的 数据加签
    size_t hashBytesSize = CC_SHA1_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA1([data bytes], (CC_LONG)[data length], hashBytes)) {
       
        return nil;
    }

    SecKeyRawSign(keyRef,
                  kSecPaddingPKCS1SHA1,
                  hashBytes,
                  hashBytesSize,
                  signedHashBytes,
                  &signedHashBytesSize);

    NSData* signedHash = [NSData dataWithBytes:signedHashBytes
                                        length:(NSUInteger)signedHashBytesSize];

    if (hashBytes)
        free(hashBytes);
    if (signedHashBytes)
        free(signedHashBytes);
    
    return signedHash;
    /*******begin:using SHA256 with RSA
        size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
        uint8_t* hashBytes = malloc(hashBytesSize);
        if (!CC_SHA256([data bytes], (CC_LONG)[data length], hashBytes)) {
            return nil;
        }
    
        SecKeyRawSign(keyRef,
                      kSecPaddingPKCS1SHA256,
                      hashBytes,
                      hashBytesSize,
                      signedHashBytes,
                      &signedHashBytesSize);
    
        NSData* signedHash = [NSData dataWithBytes:signedHashBytes
                                            length:(NSUInteger)signedHashBytesSize];
    
        if (hashBytes)
            free(hashBytes);
        if (signedHashBytes)
            free(signedHashBytes);
        
        return signedHash;
     ********end:using SHA256 with RSA*/

     /*******begin:SHA1WithRSA 的 数据加签
    uint8_t* signedBytes = NULL;
    OSStatus sanityCheck = noErr;
    NSData* signedHash = nil;

    signedBytes = malloc( signedHashBytesSize * sizeof(uint8_t) ); // Malloc a buffer to hold signature.
    memset((void *)signedBytes, 0x0, signedHashBytesSize);
    
    sanityCheck = SecKeyRawSign(keyRef,
                                kSecPaddingPKCS1SHA1,
                                (const uint8_t *)[[JSRSA getHashBytes:data] bytes],
                                kChosenDigestLength,
                                (uint8_t *)signedBytes,
                                &signedHashBytesSize);
    
    if (sanityCheck == noErr)
    {
        signedHash = [NSData dataWithBytes:(const void *)signedBytes length:(NSUInteger)signedHashBytesSize];
    }
    else
    {
        return nil;
    }
    
    if (signedBytes)
    {
        free(signedBytes);
    }
    return signedHash;
    ********end:using SHA1 with RSA*/
    
    /*******begin:MD5WithRSA 的 数据加签,有问题，不能使用
    size_t hashBytesSize = CC_MD5_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_MD5([data bytes], (CC_LONG)[data length], hashBytes)) {
        return nil;
    }
    NSLog(@"signstatus is %s",hashBytes);

    OSStatus status = SecKeyRawSign(keyRef,
                  kSecPaddingPKCS1MD5,
                  hashBytes,
                  hashBytesSize,
                  signedHashBytes,
                  &signedHashBytesSize);
    NSLog(@"signstatus is %d",status);

    NSData* signedHash = [NSData dataWithBytes:signedHashBytes
                                        length:(NSUInteger)signedHashBytesSize];

    if (hashBytes)
        free(hashBytes);
    if (signedHashBytes)
        free(signedHashBytes);
    
    return signedHash;
     ********end:using MD5WithRSA 数据加签*/

}
/* END: Sign with RSA private key */

/* START: Verify with RSA public key 
 
  plainData:用于签名的数据
  signature:待验证的数据
 */
+(BOOL) verifyData:(NSData*)plainData sign:(NSData*)signature publickey:(NSString *)pubKey
{
    if(!plainData || !signature || !pubKey){
        return NO;
    }
    SecKeyRef keyRef = [JSRSA addPublicKey:pubKey];
    if(!keyRef){
        return NO;
    }
    
    size_t signedHashBytesSize = SecKeyGetBlockSize(keyRef);
    const void* signedHashBytes = [signature bytes];
    
    //begin:using SHA1 with RSA
    size_t hashBytesSize = CC_SHA1_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA1([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return NO;
    }

    OSStatus status = SecKeyRawVerify(keyRef,
                                      kSecPaddingPKCS1SHA1,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);
    
    return status == errSecSuccess;
    
    /*******begin:using SHA256 with RSA
    size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return NO;
    }

    OSStatus status = SecKeyRawVerify(keyRef,
                                      kSecPaddingPKCS1SHA256,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);

    return status == errSecSuccess;
    *********end:using SHA256 with RSA*/
    
    /********begin:using SHA1 with RSA
    size_t hashBytesSize = kChosenDigestLength;
    uint8_t* hashBytes = malloc(hashBytesSize);
    
    OSStatus status = SecKeyRawVerify(keyRef,
                                      kSecPaddingPKCS1SHA1,
                                      (const uint8_t *)[[JSRSA getHashBytes:plainData] bytes],
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);
    
    return status == errSecSuccess;
     ********end:using SHA256 with RSA*/
    
    /********begin:using MD5 with RSA 有问题，不能使用
    size_t hashBytesSize = CC_MD5_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_MD5([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return NO;
    }

    OSStatus status = SecKeyRawVerify(keyRef,
                                      kSecPaddingPKCS1MD5,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);

    return status == errSecSuccess;
    **********end:using MD5 with RSA*/
}

/* END: Verify with RSA public key */

+(NSString *)base64EncodeData:(NSData *)data {
    if (data == nil) {
        return nil;
    }
    return base64_encode_data(data);
}

+(NSData *)base64Decode:(NSString*)string {
    if (string == nil) {
        return nil;
    }
    return base64_decode(string);
}

+ (NSString*)urlEncodedString:(NSString *)string
{
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    
    return encodedString;
}

+ (NSString *)urlDecodeFromString: (NSString *)input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@""
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0,
                                                      [outputStr length])];
    
    return[outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - instance method
+ (JSRSA *)sharedInstance
{
    static JSRSA *rsaUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rsaUtil = [[JSRSA alloc] init];
    });
    return rsaUtil;
}

- (id)init {
    self = [super init];
    if (self) {
        [self rsaint];
    }
    return self;
}

- (void)rsaint {
//    _publicKey = [MyAABBUtil sharedMyAABBUtil]->UIImageData2;


    _publicKey = @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDpByYAMyB1+ScfLk2CEEyZcfWZSF244pa0ono4W1GdJFnHTZfVk1QN3JKYpJsnW2VKZr6ZhgjxAWklOgQzajPcMR0zLdfNQvPoAM6Ttldz4tD1XJPdY8jtvjF2h66FudCsnkDyWiR4i32LzujDd0CCN7dcm2KfJlaWfvIBvV/7QIDAQAB-----END PUBLIC KEY-----";
    _privateKey = @"";
    //
//    _privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKWypCIrkowE7zyd/YITojloYlBf2NNeisO96519Iq2zb/mL+KkIujryuXiCw9jDOM/l5/kglMrRd3Out+Sfl3YYJUDuf+M3euWqN9LLXDYPgmoxS2oSFFCvsp+h9ltkGc86iiJ6lGG35bQP2sgBx4ssPlQ+my1niU8Jba388bSFAgMBAAECgYBQ+Beenv4wr+ScEXQk0SVPukN4lS2mNCfI+RCe19xPV0Tbg9uR9jLSxXN+gR/k15j2dplBsvsilPMzM2inLplbEV0hhl7lOpFZzvRd8e0HiFhh84SOvOQDY1L/+qyCUVZJVp5iwt2S7vGGqCtC0g3mbaDPoTUVo/DKzw00jGxUYQJBANnO7qAkxUyfhj221KGbhNZI/Lgd9+/rsDWNmeVQlkt9iDqdZpue6eA2pXemIX5pz/ptBoLvGq2sLq5PECzyjf0CQQDCwI0o+1S1/VXQGssg7YSA45acKYC8BDiYeEZij+AFNGzRpKKZxS3xsRtKg9g7Vi5nhImdOephoBBo3mXX2wMpAkEArPH43EQWPZ81cm9oKuJX+eZ+dJunMWRNyFglaMYycMK+lvxAazUls5jwji7lzYCrWceUMgc1gc2ES3gP+gCm6QJATbnjnLOSP3/4O7I119Jzy60JcxHtWxykKdX24WdilTEzLQh0DMLxb0CsD7VHG4dtxcrT0XhH3uavJet84gV64QJBANAIPAlR/E4mM5OMETTioxMKYLGXH6XwNY23X/qogUsLbvwxWcy0etUEg6bqW1jnqehfxlb7S2tzpgrhLnqk+Fs=";

}

#pragma mark - use method



@end

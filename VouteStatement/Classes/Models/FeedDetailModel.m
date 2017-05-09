//
//  FeedDetailModel.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/28.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "FeedDetailModel.h"
#import <NSObject+YYModel.h>
@interface FeedDetailModel ()<YYModel>

@property  (nonatomic,assign,readwrite)BOOL haveContent;

@end
@implementation FeedDetailModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"all_vote":@"all_vote",
             @"circle_hash":@"circle.hash",
             @"joined":@"circle.joined",
             @"circle_name":@"circle.name",
             @"comment":@"comment",
             @"desc":@"description",
             @"feed_hash_name":@"hash",
             @"left_option":@"left_option",
             @"live_time":@"live_time",
             @"pic":@"pic",
             @"right_option":@"right_option",
             @"share_desc":@"share.desc",
             @"share_link":@"share.link",
             @"share_pic":@"share.pic",
             @"share_title":@"share.title",
             @"title":@"title",
             @"voted":@"voted",
             @"commentCount":@"comment"};
}
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    FeedDetailModel *model = [super modelWithDictionary:dictionary];
    if ([NSString isBlankString:model.pic]) {
        model.imageHeigth = 0.0f;
    } else {
        model.imageHeigth = (SCREEN_WIDTH-20)*9/16.0f;
    }
    if ([NSString isBlankString:model.desc]) {
        model.contentHeight = 0;
    } else {
        model.contentHeight = STRING_SIZE_FONT(SCREEN_WIDTH-20, model.desc, 14).height;
    }
    if ((model.imageHeigth + model.contentHeight) >1.0f) {
        model.haveContent = YES;
    } else {
        model.haveContent = NO;
    }
    return model;
}
//- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
//    
//    if (self = [super initWithDictionary:dictionary]) {
//        
////        NSString * content =@"agjlakdfjlkajlkgjsdlkfjdksjflkdsjflkdsjlkjlkajglkjdslkgjflkdsjalkgjldskjgflkdsajflkjadslkfjldskaflkdsajfldskajglkjdslfjldsafjldsajfldsajfldasjlfkjsadlkfjlsdakjflkadsjfoqjerpqejrkewqjlkqjtlekjlrkejqlrkjleqwrlkeqwrlkejlfksdmlfkcmlkxczjlkfjldksajflkdsmflkcxmlkvczjlkjlfkadsjflkdsafjaslkfjaslkfjsaldkfjsdlakfdsaflkadfjadlsfjalsdkfjaldsfjaldskfjalsdkjfaldskadlsfjadslkfjasdflksadjfsdklafjadlkfjasldkfjdaslkfjadsklfjaldskjfadklsj,fsdfghjklkjhgfdfghjkjhgffghjhvcvgygvgvbhjbhjhbhjhbhjhbnhjnjnj";
//
//        NSString * content = dictionary[@"description"];
//        content = [NSString isBlankString:content] ? @"" :content ;
//        self.content = content;
//        
//        CGFloat height = STRING_SIZE_FONT(SCREEN_WIDTH-20, content, 14).height;
//        
//        self.contentHeight = height;
//    }
//    return self;
//}

@end

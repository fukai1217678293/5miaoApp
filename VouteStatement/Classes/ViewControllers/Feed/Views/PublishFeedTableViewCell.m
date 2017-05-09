//
//  PublishFeedTableViewCell.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/27.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "PublishFeedTableViewCell.h"
#import "LimitLengthTextField.h"
#import "LimitLengthTextView.h"
NSString * const PublishFeedTableViewCellTypeTitle = @"PublishFeedTableViewCellTypeTitle";
NSString * const PublishFeedTableViewCellTypeCircleInput = @"PublishFeedTableViewCellTypeCircleInput";
NSString * const PublishFeedTableViewCellTypeLasthourInput = @"PublishFeedTableViewCellTypeLasthourInput";
NSString * const PublishFeedTableViewCellTypeDescInput = @"PublishFeedTableViewCellTypeDescInput";
NSString * const PublishFeedTableViewCellTypePointOptionInput = @"PublishFeedTableViewCellTypePointOptionInput";

@interface PublishFeedTableViewCell ()<UITextViewDelegate>

@property (nonatomic,strong)LimitLengthTextField *titleInputView;
@property (nonatomic,strong)UIView  *circleInputView;
@property (nonatomic,strong)UIView *lastHourInputView;
@property (nonatomic,strong)UIView *desInputView;
@property (nonatomic,strong)UIView *pointOptionInputView;

@end

@implementation PublishFeedTableViewCell

+ (instancetype)loadCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    PublishFeedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[PublishFeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if ([reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeTitle]) {
            [self.contentView addSubview:self.titleInputView];
        }
        else if ([reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeCircleInput]) {
            [self.contentView addSubview:self.circleInputView];
            UIButton *desCircleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            desCircleButton.backgroundColor = [UIColor clearColor];
            desCircleButton.frame = CGRectMake(SCREEN_WIDTH-45, (65-17)/2.0f, 17, 17);
            [desCircleButton setImage:[UIImage imageNamed:@"icon_tishi.png"] forState:UIControlStateNormal];
            [desCircleButton addTarget:self action:@selector(desCircleAction:) forControlEvents:UIControlEventTouchUpInside];
            desCircleButton.userInteractionEnabled = YES;
            self.accessoryView = desCircleButton;
            UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_quanzi.png"]];
            logoImageView.frame = CGRectMake(10, 10, 12, 12);
            [self.contentView addSubview:logoImageView];
            
        }
        else if ([reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeLasthourInput]) {
            [self.contentView addSubview:self.lastHourInputView];
        }
        else if ([reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeDescInput]) {
            [self.contentView addSubview:self.desInputView];
        }
        else if ([reuseIdentifier isEqualToString:PublishFeedTableViewCellTypePointOptionInput]) {
            [self.contentView addSubview:self.pointOptionInputView];
        }
    }
    return self;
}
- (void)configDataWithPublishModel:(PublishFeedModel *)feedModel keywords:(id)keyword {
    if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeTitle]) {
        self.titleInputView.text = [feedModel valueForKeyPath:keyword];
    }
    else if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeCircleInput]) {
        LimitLengthTextView *textView = [_circleInputView viewWithTag:1000];
        textView.text = [feedModel valueForKeyPath:keyword];
    }
    else if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeLasthourInput]) {
//        UIButton *leftOptionButton = [_circleInputView viewWithTag:1500];
//        UIButton *rightOptionButton = [_circleInputView viewWithTag:1501];
        
    }
    else if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeDescInput]) {
        LimitLengthTextView *textView = [_desInputView viewWithTag:1200];
        NSString *desKeyword =(NSString *)[(NSArray *)keyword objectAtIndex:0];
        NSString *imageKeyword =(NSString *)[(NSArray *)keyword objectAtIndex:1];
        textView.text = [feedModel valueForKeyPath:desKeyword];
        UIButton *photoButton = [_desInputView viewWithTag:1201];
        UIImage *image = (UIImage *)[feedModel valueForKeyPath:imageKeyword];
        if (image) {
            [photoButton setImage:image forState:UIControlStateNormal];
        }
    }
    else if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypePointOptionInput]) {
        LimitLengthTextField *leftOptionView = [_pointOptionInputView viewWithTag:1300];
        LimitLengthTextField *rightOptionView = [_pointOptionInputView viewWithTag:1301];
        NSString *leftKeyword = [(NSArray *)keyword objectAtIndex:0];
        NSString *rigthKeyword = [(NSArray *)keyword objectAtIndex:1];
        [leftOptionView setText:[feedModel valueForKeyPath:leftKeyword]];
        [rightOptionView setText:[feedModel valueForKeyPath:rigthKeyword]];
    }
}
- (void)configPlaceholder:(id)placeholder minLimitLength:(id)minlimits maxLimitLength:(id)maxlimits {
    if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeTitle]) {
        _titleInputView.placeholder = placeholder;
        _titleInputView.minLimit = [minlimits intValue];
        _titleInputView.maxLimit = [maxlimits intValue];
    }
    else if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeCircleInput]) {
        LimitLengthTextView *textView = [_circleInputView viewWithTag:1000];
        textView.placeholder = placeholder;
        textView.maxLength = [maxlimits intValue] ?  [maxlimits intValue]:MAXFLOAT;
        textView.minLength = [minlimits intValue];
    }
    else if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeLasthourInput]) {
        
    }
    else if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeDescInput]) {
        LimitLengthTextView *textView = [_desInputView viewWithTag:1200];
        textView.placeholder = placeholder;
        textView.maxLength = [maxlimits intValue];
        textView.minLength = [minlimits intValue];
    }
    else if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypePointOptionInput]) {
        LimitLengthTextField *leftOptionView = [_pointOptionInputView viewWithTag:1300];
        LimitLengthTextField *rightOptionView = [_pointOptionInputView viewWithTag:1301];
        NSString *leftMinlimit = [(NSArray *)minlimits objectAtIndex:0];
        NSString *leftMaxlimit = [(NSArray *)maxlimits objectAtIndex:0];
        NSString *leftPlaceholder = [(NSArray *)placeholder objectAtIndex:0];
        NSString *rightMinlimit = [(NSArray *)minlimits objectAtIndex:1];
        NSString *rightMaxlimit = [(NSArray *)maxlimits objectAtIndex:1];
        NSString *rightPlaceholder = [(NSArray *)placeholder objectAtIndex:1];
        leftOptionView.minLimit = [leftMinlimit intValue];
        leftOptionView.maxLimit = [leftMaxlimit intValue];
        leftOptionView.placeholder = leftPlaceholder;
        rightOptionView.minLimit = [rightMinlimit intValue];
        rightOptionView.maxLimit = [rightMaxlimit intValue];
        rightOptionView.placeholder = rightPlaceholder;
    }
}
- (void)configTextChangedHandle:(TextChangedHandle)handle keywords:(id)keywords {
    if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeTitle]) {
        _titleInputView.textDidChangedHandle = ^(id inputView,NSString *text){
            handle(text,(NSString *)keywords);
        };
    }
    else if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeCircleInput]) {
        LimitLengthTextView *textView = [_circleInputView viewWithTag:1000];
        textView.textDidChangedHandle =  ^(id inputView,NSString *text){
            handle(text,(NSString *)keywords);
        };
    }
    else if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeLasthourInput]) {
        
    }
    else if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeDescInput]) {
        LimitLengthTextView *textView = [_desInputView viewWithTag:1200];
        textView.textDidChangedHandle =  ^(id inputView,NSString *text){
            handle(text,[(NSArray *)keywords objectAtIndex:0]);
        };
    }
    else if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypePointOptionInput]) {
        LimitLengthTextField *leftOptionView = [_pointOptionInputView viewWithTag:1300];
        LimitLengthTextField *rightOptionView = [_pointOptionInputView viewWithTag:1301];
        NSString *leftKeyword = [(NSArray *)keywords objectAtIndex:0];
        NSString *rigthKeyword = [(NSArray *)keywords objectAtIndex:1];

        leftOptionView.textDidChangedHandle = ^(id inputView,NSString *text){
            handle(text,leftKeyword);
        };
        rightOptionView.textDidChangedHandle = ^(id inputView,NSString *text){
            handle(text,rigthKeyword);
        };
    }
}

- (void)hourSelectAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    UIButton *selectedOneItem = [sender.superview viewWithTag:1500];
    UIButton *selectedTwoItem = [sender.superview viewWithTag:1501];
    selectedOneItem.selected = !selectedOneItem.selected;
    selectedTwoItem.selected = !selectedTwoItem.selected;
    BOOL isSelectLeft = selectedOneItem.isSelected;
    if (self.didClickedHourSelectAction) {
        self.didClickedHourSelectAction(isSelectLeft);
    }
}
- (void)desCircleAction:(UIButton *)sender {
    if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeCircleInput]) {
        if (self.didClickedDesCircleAction) {
            self.didClickedDesCircleAction(sender);
        }
    }
}
- (void)photoAction:(UIButton *)sender {
    if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeDescInput]) {
        if (self.didClickedSelectImageAction) {
            self.didClickedSelectImageAction(sender);
        }
    }
}
#pragma mark -- UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([self.reuseIdentifier isEqualToString:PublishFeedTableViewCellTypeCircleInput]) {
        if (self.textInputDidEndEditingHandle) {
            self.textInputDidEndEditingHandle(textView);
        }
    }
    return YES;
}
#pragma mark -- getter
- (LimitLengthTextField *)titleInputView {
    if (!_titleInputView) {
        _titleInputView = [[LimitLengthTextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 50)];
        _titleInputView.borderStyle = UITextBorderStyleNone;
        _titleInputView.backgroundColor = [UIColor whiteColor];
        _titleInputView.textColor = [UIColor colorWithHexstring:@"333333"];
        _titleInputView.font = [UIFont systemFontOfSize:17];
    }
    return _titleInputView;
}
- (UIView *)circleInputView {
    if (!_circleInputView) {
        _circleInputView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-74, 65)];
        _circleInputView.backgroundColor = [UIColor clearColor];
        LimitLengthTextView *textView = [[LimitLengthTextView alloc] initWithFrame:_circleInputView.bounds];
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor colorWithHexstring:@"333333"];
        textView.font = [UIFont systemFontOfSize:15];
        textView.tag = 1000;
        textView.delegate = self;
        [_circleInputView addSubview:textView];
        
      
    }
    return _circleInputView;
}
- (UIView *)lastHourInputView {
    if (!_lastHourInputView) {
        _lastHourInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        _lastHourInputView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, SCREEN_WIDTH-50, 20)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor colorWithHexstring:@"dfdfdf"];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = @"话题几个小时后删除？";
        [_lastHourInputView addSubview:titleLabel];
        
        CGFloat width = 70;
        CGFloat height =30;
        CGFloat origin_y = titleLabel.bottom+10;
        CGFloat interval_x = 80;
        for (int i = 0; i < 2; i ++) {
            UIButton *hourSelectbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            hourSelectbtn.frame = CGRectMake(25+i*(interval_x +width),origin_y , width, height);
            hourSelectbtn.tag = 1500+i;
            [hourSelectbtn setTitle:i == 0 ? @"8小时" : @"24小时" forState:UIControlStateNormal];
            [hourSelectbtn setTitleColor:[UIColor colorWithHexstring:@"bbbbbb"] forState:UIControlStateNormal];
            [hourSelectbtn setTitleColor:[UIColor colorWithHexstring:@"fd3768"] forState:UIControlStateSelected];
            [hourSelectbtn setImage:[UIImage imageNamed:@"icon_xzdark.png"] forState:UIControlStateNormal];
            [hourSelectbtn setImage:[UIImage imageNamed:@"icon_xzlight.png"] forState:UIControlStateSelected];
            [hourSelectbtn addTarget:self action:@selector(hourSelectAction:) forControlEvents:UIControlEventTouchUpInside];
            hourSelectbtn.titleLabel.font = [UIFont systemFontOfSize:11];
            hourSelectbtn.selected = i;
            hourSelectbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            hourSelectbtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
            [_lastHourInputView addSubview:hourSelectbtn];
        }
    }
    return _lastHourInputView;
}
- (UIView *)desInputView {
    if (!_desInputView) {
        _desInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        [_desInputView setBackgroundColor:[UIColor whiteColor]];
        
        LimitLengthTextView *textView = [[LimitLengthTextView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 90)];
        textView.tag = 1200;
        textView.backgroundColor = [UIColor clearColor];
        textView.font = [UIFont systemFontOfSize:15];
        [_desInputView addSubview:textView];
        
        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        photoBtn.frame = CGRectMake(10, textView.bottom+10, 95, 80);
        [photoBtn setImage:[UIImage imageNamed:@"icon_addtupian.png"] forState:UIControlStateNormal];
        [photoBtn addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchUpInside];
        photoBtn.tag = 1201;
        [_desInputView addSubview:photoBtn];
    }
    return _desInputView;
}
- (UIView *)pointOptionInputView {
    if (!_pointOptionInputView) {
        _pointOptionInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _pointOptionInputView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *vsImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-35)/2.0f, 5, 35, 35)];
        [vsImageView setImage:[UIImage imageNamed:@"icon_vssmall.png"]];
        [_pointOptionInputView addSubview:vsImageView];
        
        LimitLengthTextField *leftOptionView = [[LimitLengthTextField alloc] initWithFrame:CGRectMake(15, 0, vsImageView.left-25, 45)];
        leftOptionView.textAlignment = NSTextAlignmentCenter;
        leftOptionView.font = [UIFont systemFontOfSize:14];
        leftOptionView.textColor = [UIColor colorWithHexstring:@"333333"];
        leftOptionView.tag = 1300;
        [_pointOptionInputView addSubview:leftOptionView];
        
        LimitLengthTextField *rightOptionView = [[LimitLengthTextField alloc] initWithFrame:CGRectMake(vsImageView.right+10, 0, vsImageView.left-25, 45)];
        rightOptionView.textAlignment = NSTextAlignmentCenter;
        rightOptionView.font = [UIFont systemFontOfSize:14];
        rightOptionView.textColor = [UIColor colorWithHexstring:@"333333"];
        rightOptionView.tag = 1301;
        [_pointOptionInputView addSubview:rightOptionView];
        
    }
    return _pointOptionInputView;
}
@end

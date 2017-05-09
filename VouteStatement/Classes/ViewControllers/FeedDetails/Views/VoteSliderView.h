//
//  SliderView.h
//  Demo
//
//  Created by 付凯 on 2017/2/10.
//  Copyright © 2017年 付凯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,SliderViewFilterState) {
    SliderViewFilterStateShowAll = 0,
    SliderViewFilterStateShowLeft,
    SliderViewFilterStateShowRight
};

extern NSString * const VoteSliderFilterViewStatusDidChangedNotificationName;

@interface VoteSliderView : UISlider


@end


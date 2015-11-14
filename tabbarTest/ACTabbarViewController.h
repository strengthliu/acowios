//
//  tabbarViewController.h
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ACMessageViewController.h"
#import "ACDiscoverViewController.h"
#import "ACPlusViewController.h"
#import "ACFriendsViewController.h"
#import "ACMeViewController.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : 0)
#define addHeight 88


@protocol ACTabbarDelegate <NSObject>

-(void)touchBtnAtIndex:(NSInteger)index;

@end

@class ACTabBarView;

@interface ACTabbarViewController : UIViewController<ACTabbarDelegate>

@property(nonatomic,strong) ACTabBarView *tabbar;
@property(nonatomic,strong) NSArray *arrayViewcontrollers;
@end




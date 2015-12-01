//
//  ACViewController.h
//
//  Created by lucifer on 15/11/14.
//  Copyright © 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACViewDelegate.h"

@interface ACViewController : UIViewController

/**
 *  默认代理
 */
@property(nonatomic,weak) id<ACViewDelegate> delegate;

/**
 *  这个view的tag
 */
@property (readonly, copy) NSString *__nonnull tag;


@property (copy) NSArray *__nonnull subtags;


@end

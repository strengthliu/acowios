//
//  ACViewController.m
//  tabbarTest
//
//  Created by lucifer on 15/11/14.
//  Copyright © 2015年 Kevin. All rights reserved.
//

#import "ACViewController.h"
#import "ACViewDelegate.h"

@protocol ACViewProtocol <NSObject>

+ (NSString*) getNibName;
+ (NSString*) getTag;

@end

/**
 每个View都有自己的TAG，有自己的构造。
 */
@interface ACViewController () <ACViewProtocol>

@end


@implementation ACViewController

- (id)initByTag:(NSString*)tag {
    
    if (self = [super init]) {
        self->_tag = tag;
    }
    return (id)self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
//    if(self.delegate ==nil)
//        self.delegate = [[ACViewDelegate alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  PlusViewController.m
//  tabbarTest
//
//  Created by lucifer on 15/11/13.
//  Copyright © 2015年 Kevin. All rights reserved.
//

#import "ACPlusViewController.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@interface ACPlusViewController ()
- (IBAction)finishSession:(id)sender;

@end

@implementation ACPlusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

// 点结束，返回到message页面。
- (IBAction)finishSession:(id)sender {
    NSLog(@"plusvc self.view: %p", self.view);

    UIView* currentView = [self.view.superview viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];

//    [currentView removeFromSuperview];
//    [sender.superview remove:sender];
//    [self.view.superview removeFromSuperview];
    [self.view removeFromSuperview];
    // 这里
//    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
//    [currentView removeFromSuperview];
    
}
- (IBAction)test:(UIButton *)sender {
    NSLog(@"test in plus");
}
@end

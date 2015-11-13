//
//  PlusViewController.m
//  tabbarTest
//
//  Created by lucifer on 15/11/13.
//  Copyright © 2015年 Kevin. All rights reserved.
//

#import "PlusViewController.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@interface PlusViewController ()
- (IBAction)finishSession:(id)sender;

@end

@implementation PlusViewController

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

- (IBAction)finishSession:(id)sender {
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    
}
@end

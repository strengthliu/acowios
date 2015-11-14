//
//  MeViewController.m
//  tabbarTest
//
//  Created by lucifer on 15/11/14.
//  Copyright © 2015年 Kevin. All rights reserved.
//

#import "ACMeViewController.h"

@interface ACMeViewController ()


@end

@implementation ACMeViewController

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


- (IBAction)configButtonClicked:(UIButton *)sender {
    NSLog(@"click button in Me.");
}
@end

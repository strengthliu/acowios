//
//  MeViewController.m
//  tabbarTest
//
//  Created by lucifer on 15/11/14.
//  Copyright © 2015年 Kevin. All rights reserved.
//

#import "ACMeViewController.h"
#import "ACMyCharacterViewController.h"

@interface ACMeViewController (){
    SCRecorder *_screcorder;
}


@end

ACMyCharacterViewController *meView;
@implementation ACMeViewController

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


- (IBAction)configButtonClicked:(UIButton *)sender {
    NSLog(@"click button in Me.");
    meView = [[ACMyCharacterViewController alloc] initWithNibName:@"ACMyCharacterViewController" bundle:nil];
    meView.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height+50);

//    [meView presentedViewController];
    [self.view addSubview:meView.view];

}



@end

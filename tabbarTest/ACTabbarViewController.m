//
//  tabbarViewController.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "ACTabbarViewController.h"
#import "ACTabBarView.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@interface ACTabbarViewController ()

@end

@implementation ACTabbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGFloat orginHeight = self.view.frame.size.height- 60;
    if (iPhone5) {
        orginHeight = self.view.frame.size.height- 60 + addHeight;
    }
    _tabbar = [[ACTabBarView alloc]initWithFrame:CGRectMake(0,  orginHeight, 320, 60)];
    _tabbar.delegate = self;
    [self.view addSubview:_tabbar];
    
    _arrayViewcontrollers = [self getViewcontrollers];
    [self touchBtnAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchBtnAtIndex:(NSInteger)index
{
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    

    NSDictionary* data = [_arrayViewcontrollers objectAtIndex:index];
    
    UIViewController *viewController = data[@"viewController"];
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    if(index == 2){
        viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
        [self.view insertSubview:viewController.view aboveSubview:_tabbar];
        
    } else {
    viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height- 50);
    
    [self.view insertSubview:viewController.view belowSubview:_tabbar];
    }

}

-(NSArray *)getViewcontrollers
{
    NSArray* tabBarItems = nil;
    
    ACMessageViewController *message = [[ACMessageViewController alloc]initWithNibName:@"ACMessageViewController" bundle:nil];
    
    ACDiscoverViewController *discover = [[ACDiscoverViewController alloc]initWithNibName:@"ACDiscoverViewController" bundle:nil];
    
    ACPlusViewController *plus = [[ACPlusViewController alloc]init];
    
    ACFriendsViewController *friends = [[ACDiscoverViewController alloc]initWithNibName:@"ACFriendsViewController" bundle:nil];

    ACMeViewController *me = [[ACDiscoverViewController alloc]initWithNibName:@"ACMeViewController" bundle:nil];

    tabBarItems = [NSArray arrayWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", message, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", discover, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", plus, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", friends, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", me, @"viewController",@"主页",@"title", nil],

                   nil
                   ];
    return tabBarItems;
    
}

@end

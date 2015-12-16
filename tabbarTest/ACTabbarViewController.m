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

/**
 *  tab按钮点击事件。
 *
 *  @param index <#index description#>
 */
-(void)touchBtnAtIndex:(NSInteger)index
{
//    self.view.backgroundColor = [UIColor redColor];
    // 根据view的tab，取出view实例
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
//    currentView.backgroundColor = [UIColor cyanColor];
    
//    NSLog(@"self.view: %p", self.view);
//    NSLog(@"currentView: %p", currentView);

    if(index !=2)// 如果不是plus，当前视图移出父视图。因为plusView是覆盖在最上面的，移走后，要显示移入前的视图，所以不能把原视图移出。
        [currentView removeFromSuperview];
//    NSLog(@"self.view: %p", self.view);
    
    // 根据点击按钮的index，从视图组中，取出对应的视图数据
    NSDictionary* data = [_arrayViewcontrollers objectAtIndex:index];
    
    // 取出对应的视图实例
    UIViewController *viewController = data[@"viewController"];
    // 修改将要显示视图的tag
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    
    // 如果点击的是+
    if(index == 2){
        // 设定视图frame的大小
        viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
        // 插入
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
//    message.view.backgroundColor = [UIColor darkGrayColor];

    ACDiscoverViewController *discover = [[ACDiscoverViewController alloc]initWithNibName:@"ACDiscoverViewController" bundle:nil];
//    discover.view.backgroundColor = [UIColor darkGrayColor];
    
    ACPlusViewController *plus = [[ACPlusViewController alloc]initWithNibName:@"ACPlusViewController" bundle:nil];
//    plus.view.backgroundColor = [UIColor darkGrayColor];
    
    ACFriendsViewController *friends = [[ACFriendsViewController alloc]initWithNibName:@"ACFriendsViewController" bundle:nil];
//    friends.view.backgroundColor = [UIColor darkGrayColor];
    
    ACMeViewController *me = [[ACMeViewController alloc]initWithNibName:@"ACMeViewController" bundle:nil];
//    me.view.backgroundColor = [UIColor darkGrayColor];

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

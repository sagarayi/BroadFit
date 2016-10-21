//
//  TabBarController.m
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 20/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "TabBarController.h"

#import "ChallengesView.h"
#import "SlideViewController.h"
#import "CalendarViewController.h"
#import "SignIn.h"
#import "TabBarController.h"
@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    
    

    // UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.window=self.view.window;
   // _menuView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];

     UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    

    
    SlideViewController *menuController=[storyBoard instantiateViewControllerWithIdentifier:@"tableView"];
    CalendarViewController *calendarController=[storyBoard instantiateViewControllerWithIdentifier:@"Calendar"];
    SignIn *sign=[storyBoard instantiateViewControllerWithIdentifier:@"Login"];
    menuController = [menuController initWithViewControllers:@[self,calendarController,sign]
                                               andMenuTitles:@[[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"], @"Calendar",@"Signout"]];
    
    

    //TabBarController *tabBarController = [storyBoard instantiateViewControllerWithIdentifier:@"ChallengesController"];
  //  window = self.view.window;
    
//    self.menuView.window.rootViewController = menuController;
//    window.rootViewController = menuController;
//    self.view.window.rootViewController = menuController;

//   self.view.window.backgroundColor = [UIColor whiteColor];
  //  [self.view addSubview:self.menuView];

  
//    window.rootViewController = menuController;
//
//    window.backgroundColor = [UIColor whiteColor];
//     [window makeKeyAndVisible];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

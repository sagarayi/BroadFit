//
//  TabBarController.m
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 20/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "BFTabBarController.h"
#import "CalendarViewController.h"
#import "ChallengesView.h"
#import "BFSlideViewController.h"
#import "SignIn.h"
#import "BFTabBarController.h"
#import "EventCreationViewController.h"
#import "ConnectionHandler.h"
#import "AllParticipantsViewController.h"
@interface BFTabBarController ()
@property BOOL admin;
@end

@implementation BFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    ConnectionHandler *connection=[[ConnectionHandler alloc]init];
    connection.delegate=self;
    [connection isAdmin:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
    
}

-(void)setMenuItems
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    // Create Components of the slider
    SignIn *sign=[storyBoard instantiateViewControllerWithIdentifier:@"Login"];
    BFSlideViewController *menuController=[storyBoard instantiateViewControllerWithIdentifier:@"tableView"];
    CalendarViewController *calendarController=[storyBoard instantiateViewControllerWithIdentifier:@"Calendar"];
    AllParticipantsViewController *allParticpants = [storyBoard instantiateViewControllerWithIdentifier:@"AllParticpants"];
    EventCreationViewController *eventCreator=[storyBoard instantiateViewControllerWithIdentifier:@"EventCreation"];
    // Check if Logged in user is admin or not
    if(_admin)
        menuController = [menuController initWithViewControllers:@[self,calendarController,eventCreator,allParticpants,sign]
                                                   andMenuTitles:@[[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"], @"Calendar",@"Create Event",@"All Participants",@"Signout"]];
    else
        menuController = [menuController initWithViewControllers:@[self,calendarController,sign]
                                                   andMenuTitles:@[[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"], @"Calendar",@"Signout"]];
    
    window.rootViewController = menuController;
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    

}
-(void)adminStatus:(BOOL)result
{
    _admin=result;
    [self setMenuItems];
}
-(void) viewWillAppear:(BOOL)animated
{
    UINavigationController *navContoller = self.navigationController;
    NSLog(@"navController :%@",navContoller);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

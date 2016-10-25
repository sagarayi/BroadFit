//
//  TabBarController.h
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 20/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFTabBarController : UITabBarController
@property UIView *menuView;

-(void)adminStatus:(BOOL)result;

@end

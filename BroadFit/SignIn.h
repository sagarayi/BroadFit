//
//  SignIn.h
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Firebase/Firebase.h"
#import "AllChallengesViewController.h"
#import "ConnectionHandler.h"

@interface SignIn : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property UIWindow * window;

- (IBAction)signIn:(id)sender;

- (void) signInFailed:(NSString *)error;
- (void) signInSuccessful;

@end

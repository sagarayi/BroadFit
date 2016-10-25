//
//  SignUp.h
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Firebase/Firebase.h"
#import "ConnectionHandler.h"
#import "Protocol.h"
@interface SignUp : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property UIActivityIndicatorView *activityIndicator;
- (IBAction)signUp:(id)sender;
- (void) failedToSignUp:(NSString *)error;
- (void) signUpSuccessful;

@end

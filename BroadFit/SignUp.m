//
//  SignUp.m
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "SignUp.h"

@interface SignUp ()

@end

@implementation SignUp

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void) viewDidAppear:(BOOL)animated{
//    
//    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userID"] != nil)
//    {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//        UIViewController * challengesViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChallengesController"];
//        [self presentViewController:challengesViewController animated:YES completion:nil];
//        
//    }
//}

// Call the connection handler to signUp the user

- (IBAction)signUp:(id)sender {
 
    NSDictionary *user = @{
                           @"emailID" : _emailIdTextField.text,
                           @"password" : _passwordTextField.text,
                           @"username" : _usernameTextField.text
                           };
    ConnectionHandler *connectionHandler = [ConnectionHandler sharedInstance];
    connectionHandler.delegate = self;
    [connectionHandler signUpWithData:user];

}


// Delegate returned by connection handler indicating signUp failed

- (void) failedToSignUp:(NSString *)error{
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"SIGNUP FAILED"
                                message:error
                                preferredStyle:UIAlertControllerStyleAlert
                                ];
    UIAlertAction *addOK = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action) {}
                            ];
    [alert addAction:addOK];
    [self presentViewController:alert animated:YES completion:nil];
    
}

// Delegate returned by connection handler indicationg login successful, sign In the user automatically

- (void) signUpSuccessful{
    
//    NSString *username = [[_emailIdTextField.text componentsSeparatedByString:@"@"] objectAtIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:_usernameTextField.text forKey:@"UserName"];
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"SIGNUP SUCCESSFUL"
                                message:@"Welcome"
                                preferredStyle:UIAlertControllerStyleAlert
                                ];
    UIAlertAction *addOK = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action)
                            {
                                
                                [[NSUserDefaults standardUserDefaults] setObject:[FIRAuth auth].currentUser.uid forKey:@"UserID"];
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChallengesController"];
                                [self presentViewController:viewController animated:YES completion:nil];
                                

                            }];
    [alert addAction:addOK];
    [self presentViewController:alert animated:YES completion:nil];

   
}



@end

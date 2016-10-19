//
//  SignIn.m
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "SignIn.h"
#import "TabBarViewController.h"
@interface SignIn ()

@end

@implementation SignIn

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userID"] != nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChallengesController"];
        [self presentViewController:viewController animated:YES completion:nil];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Call the connection handler to sign the user In

- (IBAction)signIn:(id)sender {
    
    
    NSDictionary *user = @{
                           
                           @"emailID" : _usernameTextField.text,
                           @"password" : _passwordTextField.text
                           };
    ConnectionHandler *connectionHandler = [ConnectionHandler sharedInstance];
    connectionHandler.delegate = self;
    [connectionHandler signInWithData:user];

}

// Delegate returned by connection handler, indicating failure during sign In Process

- (void) signInFailed:(NSString *)error{
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"LOGIN FAILED"
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

// Delegate returned by connection handler, indicating success during sign In Process

- (void) signInSuccessful{
    
    NSString *userID = [FIRAuth auth].currentUser.uid;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userID forKey:@"userID"];
    [defaults synchronize];
 
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"LOGIN SUCCESSFULL"
                                message:@"WELCOME"
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *addOK = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action) {
                                
                                
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChallengesController"];
                                [self presentViewController:viewController animated:YES completion:nil];
                                
                            }];
    
    [alert addAction:addOK];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
@end

//
//  SignIn.m
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "SignIn.h"
#import "TabBarViewController.h"
#import "CalendarViewController.h"
@interface SignIn ()

@end

@implementation SignIn

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userID"];
    _usernameTextField.delegate=self;
    _passwordTextField.delegate=self;
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userID"] != nil)
//    {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//        UIViewController * challengesViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChallengesController"];
//        
//        [self presentViewController:challengesViewController animated:YES completion:nil];
//        
//    }
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIResponder *nextResponder=[textField.superview viewWithTag:101];
     if(textField.tag == 100)
    {
        [nextResponder becomeFirstResponder];
    }
    else  if(textField.tag == 101)
    {
        [textField resignFirstResponder];
        [self signInUser];
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


// Call the connection handler to sign the user In

-(void)signInUser
{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.alpha = 2.0;
    _activityIndicator.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
    
    [_activityIndicator startAnimating];
    [self.view addSubview:_activityIndicator];
    NSDictionary *user = @{
                           
                           @"emailID" : _usernameTextField.text,
                           @"password" : _passwordTextField.text
                           };
    
    ConnectionHandler *connectionHandler = [ConnectionHandler sharedInstance];
    connectionHandler.delegate = self;
    [connectionHandler signInWithData:user];

}
- (IBAction)signIn:(id)sender {
    
    [self signInUser];
   
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
    [_activityIndicator stopAnimating];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}

// Delegate returned by connection handler, indicating success during sign In Process

- (void) signInSuccessful{
    [_activityIndicator stopAnimating];
    NSString *userID = [FIRAuth auth].currentUser.uid;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userID forKey:@"userID"];
    [defaults synchronize];
    NSString *username = [[_usernameTextField.text componentsSeparatedByString:@"@"] objectAtIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"UserName"];

    
                                
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChallengesController"];
    [self presentViewController:viewController animated:YES completion:nil];

    
    
}
@end

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
    _usernameTextField.delegate=self;
    _emailIdTextField.delegate=self;
    _passwordTextField.delegate=self;
}
-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = TRUE;
}
-(void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = FALSE;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 1000)
    {
        [[textField.superview viewWithTag:1001] becomeFirstResponder];
    }
    else  if(textField.tag == 1001)
    {
        [[textField.superview viewWithTag:1002] becomeFirstResponder];
        
    }
    else  if(textField.tag == 1002)
    {
        [textField resignFirstResponder];
        [self signUpUser];
    }
    return YES;
}
// Call the connection handler to signUp the user
-(void)signUpUser
{
    NSDictionary *user = @{
                           @"emailID" : _emailIdTextField.text,
                           @"password" : _passwordTextField.text,
                           @"username" : _usernameTextField.text
                           };
    ConnectionHandler *connectionHandler = [ConnectionHandler sharedInstance];
    connectionHandler.delegate = self;
    [connectionHandler signUpWithData:user];

}
- (IBAction)signUp:(id)sender {
    [_activityIndicator startAnimating];
    [self.view addSubview:_activityIndicator];

    [self signUpUser];
}
// Delegate returned by connection handler indicating signUp failed

- (void) failedToSignUp:(NSString *)error{
    
    UIAlertController *signUpFailAlert = [UIAlertController
                                alertControllerWithTitle:@"SIGNUP FAILED"
                                message:error
                                preferredStyle:UIAlertControllerStyleAlert
                                ];
    UIAlertAction *okButton = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action) {}
                            ];
    [signUpFailAlert addAction:okButton];
    [self presentViewController:signUpFailAlert animated:YES completion:nil];
    
}

// Delegate returned by connection handler indicationg login successful, sign In the user automatically

- (void) signUpSuccessful{
    [_activityIndicator stopAnimating];
    [[NSUserDefaults standardUserDefaults] setObject:[FIRAuth auth].currentUser.uid forKey:@"UserID"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChallengesController"];
    [self.navigationController pushViewController:viewController animated:NO];
}



@end

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag=textField.tag+1;
//    UIResponder *nextResponder=
    

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
 
    [self signUpUser];
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

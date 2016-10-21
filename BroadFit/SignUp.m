//
//  SignUp.m
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "SignUp.h"
#define kEmail "email"
#define kPassword "password"
@interface SignUp ()

@end

@implementation SignUp

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated{
    
//    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userID"] != nil)
//    {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//        UIViewController * challengesViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChallengesController"];
//        [self presentViewController:challengesViewController animated:YES completion:nil];
//        
//    }
}

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
    
//    NSString *userID = [FIRAuth auth].currentUser.uid;
//
//    [defaults setObject:userID forKey:@"userID"];
//    [defaults synchronize];
//    NSString *username =_usernameTextField.text ;
//    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"UserName"];
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"SIGNUP SUCCESSFUL"
                                message:@"Please sign in to continue using the app"
                                preferredStyle:UIAlertControllerStyleAlert
                                ];
    UIAlertAction *addOK = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action)
                            {
//                                [self performSegueWithIdentifier:@"SignUSuccess" sender:self];
                                [defaults setObject:_emailIdTextField.text forKey:@kEmail];
                                [defaults setObject:_passwordTextField.text forKey:@kPassword];
//                                UIViewController *controller = [self.navigationController.childViewControllers lastObject];
                                [self.navigationController popViewControllerAnimated:TRUE];
//          SignUSuccess                      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//                                UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChallengesController"];
//                                [self presentViewController:viewController animated:YES completion:nil];
                                

                            }];
    [alert addAction:addOK];
    [self presentViewController:alert animated:YES completion:nil];

   
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"SignUSuccess"])
    {
        UINavigationController *navController = segue.destinationViewController;
        NSArray *childViewControllers = navController.childViewControllers;
        
        SignIn *signIn=[childViewControllers lastObject];
        if([signIn isKindOfClass:[SignIn class]])
        {
            signIn.usernameTextField.text=_emailIdTextField.text;
            signIn.passwordTextField.text=_passwordTextField.text;
        }
    }
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }

*/

@end

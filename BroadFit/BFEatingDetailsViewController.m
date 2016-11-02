//
//  BreakfastDetailsView.m
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "BFEatingDetailsViewController.h"
#import "FirebaseConnectionHandler.h"
#import "QuartzCore/QuartzCore.h"
@interface BFEatingDetailsViewController ()

@end

@implementation BFEatingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _yesButton.layer.cornerRadius = 25;
    _noButton.layer.cornerRadius = 25;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)no:(id)sender {
    [self submitBreakfastDetails:@"NO"];

}

- (IBAction)yes:(id)sender {
    [self submitBreakfastDetails:@"YES"];
}
- (void) submitBreakfastDetails:(NSString *)status{
    NSString *message;
    if([status isEqualToString:@"YES"])
            message = @"You had breakfast today";
    else
            message = @"You did not have breakfast today";
    UIAlertController *submitDataAlert = [UIAlertController
                                          alertControllerWithTitle:@"SUBMIT EATING BREAKFAST DETAILS"
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert
                                          ];
    UIAlertAction *okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   FirebaseConnectionHandler *handlerObject = [[FirebaseConnectionHandler alloc]init];
                                   [handlerObject updateChallengeDetails:@"Eating" and:[NSArray arrayWithObjects:@"Breakfast", nil] with:[NSArray arrayWithObjects:status, nil]];
                                   [self.navigationController popViewControllerAnimated:YES];
                               }
                               ];
    UIAlertAction *cancelButton = [UIAlertAction
                                   actionWithTitle:@"CANCEL"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {}
                                   ];
    [submitDataAlert addAction:okButton];
    [submitDataAlert addAction:cancelButton];
    [self presentViewController:submitDataAlert animated:YES completion:nil];
  
}
@end

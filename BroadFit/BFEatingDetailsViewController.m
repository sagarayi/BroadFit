//
//  BreakfastDetailsView.m
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "BFEatingDetailsViewController.h"
#import "ConnectionHandler.h"
@interface BFEatingDetailsViewController ()

@end

@implementation BFEatingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self.navigationController button]
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)no:(id)sender {
    [self submitBreakfastDetails:@"NO"];
}

- (IBAction)yes:(id)sender {
    [self submitBreakfastDetails:@"YES"];
}
- (void) submitBreakfastDetails:(NSString *)status{
    
    ConnectionHandler *handlerObject = [[ConnectionHandler alloc]init];
    [handlerObject updateChallengeDetails:@"Eating" and:[NSArray arrayWithObjects:@"Breakfast", nil] with:[NSArray arrayWithObjects:status, nil]];
    [self.navigationController popViewControllerAnimated:YES];
}
@end

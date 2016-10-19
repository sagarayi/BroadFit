//
//  BreakfastDetailsView.m
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "BreakfastDetailsView.h"
#import "ConnectionHandler.h"
@interface BreakfastDetailsView ()

@end

@implementation BreakfastDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)previousDate:(id)sender {
}

- (IBAction)nextDate:(id)sender {
}
- (IBAction)no:(id)sender {
}

- (IBAction)yes:(id)sender {
    
    ConnectionHandler *handlerObject = [[ConnectionHandler alloc]init];
    [handlerObject updateChallengeDetails:@"Eating" and:[NSArray arrayWithObjects:@"Breakfast", nil] with:[NSArray arrayWithObjects:@"YES", nil]];
}
@end

//
//  UserChallenges.h
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 13/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableCell.h"
#import "BFWalkDetailsViewController.h"
#import "BFEatingDetailsViewController.h"
#import "BFDrinkDetailsViewController.h"
@interface BFMyChallengesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) NSMutableDictionary *myChallenges;
@property UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSString *challengeCellTitle;
@property NSString *eventName;
- (void) didFetchChallenges:(NSDictionary *)challenges;
- (void) didRecieveEventName:(NSString *)eventName;

@end

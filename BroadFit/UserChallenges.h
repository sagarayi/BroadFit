//
//  UserChallenges.h
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 13/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableCell.h"
#import "WalkingDetailsView.h"
#import "BreakfastDetailsView.h"
#import "DrinkingDetailsView.h"
@interface UserChallenges : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) NSMutableDictionary *myChallenges;
@property UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSString *challengeCellTitle;

- (void) didFetchChallenges:(NSDictionary *)challenges;

@end

//
//  ChallengesView.h
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionHandler.h"
#import "TableCell.h"

@interface AllChallengesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *challengeCellImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *challengeImage;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (strong,nonatomic) NSDictionary *challenges;
@property (weak, nonatomic) NSString *challengeCellTitle;
@property UIWindow * window;


@property UIActivityIndicatorView *activityIndicator;
@property NSString *individualChallengeSelected;
@property NSString *EventName;

- (IBAction)join:(id)sender;
- (IBAction)options:(id)sender;

- (void) challengesRecieved:(NSDictionary *)challenges;


@end

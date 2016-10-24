//
//  AllParticipantsViewController.h
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 21/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface AllParticipantsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSString *eventName;
@property (strong,nonatomic) NSMutableDictionary *allUsers;
@property (weak, nonatomic) IBOutlet UITableView *participantsTable;
@property NSArray *allChallengesInEvent;
@property NSMutableDictionary *usersInChallenge;
@property NSMutableDictionary *eachUser;

- (void) didFetchUsers:(NSDictionary *)users;

@end

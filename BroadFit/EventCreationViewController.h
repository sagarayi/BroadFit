//
//  EventCreationViewController.h
//  BroadFit
//
//  Created by sagar ayi on 21/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionHandler.h"
@interface EventCreationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *eventName;
@property (weak, nonatomic) IBOutlet UITableView *challengesChooser;
@property (weak, nonatomic) IBOutlet UIButton *startDateButton;
@property (weak, nonatomic) IBOutlet UIButton *endDateButton;
- (IBAction)resetButton:(id)sender;

@property UIImage *tickImage;
@property NSArray * challengeNames;
@property BOOL hideImage;
@property NSMutableArray* challengesSelected;
@property NSString *startingDate;
@property NSString *endingDate;

-(void)didFinishFetchingChallenges:(NSDictionary*)listOfChallenges;
- (IBAction)createEvent:(id)sender;
- (IBAction)setStartDate:(id)sender;
- (IBAction)setEndDate:(id)sender;

@end

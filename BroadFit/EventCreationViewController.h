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
@property UIActivityIndicatorView *activityIndicator;


@property UIImage *tickImage;
@property NSArray * challengeNames;
@property BOOL hideImage;
@property NSMutableArray* challengesSelected;
@property NSString *startingDate;
@property NSString *endingDate;
@property NSString *nameOfTheEvent;
@property NSInteger numberOfChallenges;
@property NSArray* imageList;
@property NSDictionary* challengeId;


- (void)didFinishFetchingChallenges:(NSDictionary*)listOfChallenges;
- (void)didFetchImages:(NSDictionary*)images;
- (IBAction)createEvent:(id)sender;
- (IBAction)setStartDate:(id)sender;
- (IBAction)setEndDate:(id)sender;
- (IBAction)resetButton:(id)sender;
@end

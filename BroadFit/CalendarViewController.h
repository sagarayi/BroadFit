//
//  CalendarViewController.h
//  BroadFit
//
//  Created by sagar ayi on 18/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *detailTable;
@property UIActivityIndicatorView *activityIndicator;
@property (strong,nonatomic) NSArray *myChallenges;
- (IBAction)getChallengeDetails:(id)sender;
- (void) didFetchChallenges:(NSDictionary *)challenges;
@end

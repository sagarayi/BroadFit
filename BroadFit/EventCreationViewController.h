//
//  EventCreationViewController.h
//  BroadFit
//
//  Created by sagar ayi on 21/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCreationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *eventName;
@property (weak, nonatomic) IBOutlet UISwitch *challengeChooser;
@property (weak, nonatomic) IBOutlet UITableView *challengesList;
- (IBAction)createEvent:(id)sender;

@end

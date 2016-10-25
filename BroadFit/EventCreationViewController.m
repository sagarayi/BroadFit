//
//  EventCreationViewController.m
//  BroadFit
//
//  Created by sagar ayi on 21/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "EventCreationViewController.h"

@interface EventCreationViewController ()


@end

@implementation EventCreationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tickImage=[UIImage imageNamed:@"tick"];
    _hideImage=YES;
    _startingDate=@"";
    _endingDate=@"";
    _numberOfChallenges=0;
    _eventName.delegate=self;
    _challengesSelected=[[NSMutableArray alloc]init];
    self.challengesChooser.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.challengesChooser.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    _imageList=@[@"drinking",@"eating",@"sleeping",@"walking"];
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.alpha = 1.0;
//    _activityIndicator.center = CGPointMake(self.view.frame.size.width-50, self.view.frame.size.height-50);
    
    [self.challengesChooser addSubview:_activityIndicator];
    ConnectionHandler *connection=[[ConnectionHandler alloc]init];
    connection.delegate=self;
    [connection fetchListOfChallenges];
    [_activityIndicator startAnimating];
    [connection fetchImages];
    // Do any additional setup after loading the view.
}

-(void)didFinishFetchingChallenges:(NSDictionary*)listOfChallenges
{
    [_activityIndicator stopAnimating];
    [_activityIndicator removeFromSuperview];
    _challengeNames = [listOfChallenges allKeys];
    _challengeId=listOfChallenges;
    [self.challengesChooser reloadData];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)didFetchImages:(NSDictionary *)images
{
    _imageList=[images allValues];
}
-(void)presentDatePickerAlert:(NSString*)title
{
    CGRect pickerFrame = CGRectMake(0, 50, 270, 100);
    UIDatePicker *datePicker=[[UIDatePicker alloc]initWithFrame:pickerFrame];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Start Date"
                                                                   message:@"\n\n\n\n\n\n\n\n"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton=[UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action)
                             {
                                 NSDateFormatter *formatter= [[NSDateFormatter alloc]init];
                                 [formatter setDateFormat:@"dd-MM-yyyy"];
                                 if([title isEqualToString:@"Start Date"])
                                 {
                                     
                                 _startingDate=[formatter stringFromDate:[datePicker date]];
                                 [_startDateButton setTitle:_startingDate forState:UIControlStateNormal];
                                 [_startDateButton setEnabled:NO ];
                                 }
                                 else
                                 {
                                     _endingDate=[formatter stringFromDate:[datePicker date]];
                                     [_endDateButton setTitle:_endingDate forState:UIControlStateNormal];
                                     [_endDateButton setEnabled:NO ];
                                 }
                             }];
    UIAlertAction *cancelButton=[UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert.view addSubview:datePicker];
    [alert addAction:okButton];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)createEvent:(id)sender
{
    
    NSDateFormatter *formatter= [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *currentdate=[formatter stringFromDate:[NSDate date]];
    NSDate *todaydate=[formatter dateFromString:currentdate];
    NSDate *startDate=[formatter dateFromString:_startingDate];
    NSDate *endDate=[formatter dateFromString:_endingDate];
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Error" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    [alert addAction:okButton];
    if([_eventName.text isEqualToString:@""] )
    {
        alert.message=@"Event name cannot be empty";
    }
    else if(_numberOfChallenges == 0)
    {
        alert.message=@"Select atleast one challenge";
    }
    else if([_startingDate isEqualToString:@""])
    {
        alert.message=@"Set Starting date";
    }
    else if([_endingDate isEqualToString:@""])
    {
        alert.message=@"Set Ending date";
    }
    else if([startDate compare:endDate]==NSOrderedSame)
    {
       alert.message=@"Starting and Ending dates cannot be same";
        [self resetDateButton:_startDateButton with:@"Start date"];
        
    }
    else if ([startDate compare:endDate]==NSOrderedDescending)
    {
        alert.message=@"Ending date cannot be earlier than starting date ";
        [self resetDateButton:_endDateButton with:@"End Date"];
    }
    else if ([startDate compare:todaydate]==NSOrderedAscending)
    {
        alert.message=@"Starting date cannot be earlier than today";
        [self resetDateButton:_startDateButton with:@"Start Date"];
    }
    else if ([endDate compare:todaydate]==NSOrderedAscending)
    {
        alert.message=@"Ending date cannot be earlier than today";
        [self resetDateButton:_endDateButton with:@"End Date"];
    }
    else
    {
        ConnectionHandler *connection=[[ConnectionHandler alloc]init];
        connection.delegate=self;
        [connection addEventDetails:_eventName.text containing:_challengesSelected from:_startingDate till:_endingDate with:_imageList and:_challengeId];
        alert.title=@"Success";
        alert.message=@"Event created";
        [self resetButton:nil];
    }
    [self presentViewController:alert animated:YES completion:nil];
        
}
-(void)resetDateButton:(UIButton*)button with:(NSString*)title
{
    [button setEnabled:YES];
    [button setTitle:title forState:UIControlStateNormal];
    
}
- (IBAction)setStartDate:(id)sender
{
    [self presentDatePickerAlert:@"Start Date"];
}

- (IBAction)setEndDate:(id)sender
{
    [self presentDatePickerAlert:@"End Date"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_challengeNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"detailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image=_tickImage;
        
        
    }
    cell.textLabel.text = _challengeNames[indexPath.row];
    cell.imageView.hidden=_hideImage;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    _hideImage=!_hideImage;
    cell.imageView.hidden=_hideImage;
    if(!cell.imageView.hidden && ![_challengesSelected containsObject:[_challengeNames objectAtIndex: indexPath.row]])
    {
        [_challengesSelected addObject:[_challengeNames objectAtIndex: indexPath.row]];
        
        _numberOfChallenges++;
        _hideImage=YES;
    }
    else if(cell.imageView.hidden && [_challengesSelected containsObject:[_challengeNames objectAtIndex: indexPath.row]])
    {
        [_challengesSelected removeObject:[_challengeNames objectAtIndex: indexPath.row]];
       
        _numberOfChallenges--;
        _hideImage=NO;
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)resetButton:(id)sender
{
    [self resetDateButton:_startDateButton with:@"Start date"];
    [self resetDateButton:_endDateButton with:@"End date"];
    _eventName.text=@"";
    _startingDate=@"";
    _endingDate=@"";
    _hideImage=YES;
    _numberOfChallenges=0;
    [_challengesSelected removeAllObjects];
    [self.challengesChooser reloadData];
}
@end

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
    _numberOfChallenges=0;
    _challengesSelected=[[NSMutableArray alloc]init];
    self.challengesChooser.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.challengesChooser.separatorStyle = UITableViewCellSeparatorStyleNone;
    ConnectionHandler *connection=[[ConnectionHandler alloc]init];
    connection.delegate=self;
    [connection fetchListOfChallenges];
    // Do any additional setup after loading the view.
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
        
}

- (IBAction)setStartDate:(id)sender
{
    [self presentDatePickerAlert:@"Start Date"];
}

- (IBAction)setEndDate:(id)sender
{
    [self presentDatePickerAlert:@"End Date"];
}

-(void)didFinishFetchingChallenges:(NSDictionary*)listOfChallenges
{
    _challengeNames = [listOfChallenges allKeys];
    [self.challengesChooser reloadData];
    
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
        cell.imageView.hidden=_hideImage;
    }
    cell.textLabel.text = _challengeNames[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    _hideImage=!_hideImage;
    cell.imageView.hidden=_hideImage;
    if(!cell.imageView.hidden && [_challengesSelected containsObject:[_challengeNames objectAtIndex: indexPath.row]])
    {
        [_challengesSelected addObject:[_challengeNames objectAtIndex: indexPath.row]];
        _numberOfChallenges++;
    }
    else if(cell.imageView.hidden && [_challengesSelected containsObject:[_challengeNames objectAtIndex: indexPath.row]])
    {
        [_challengesSelected removeObject:[_challengeNames objectAtIndex: indexPath.row]];
        _numberOfChallenges--;
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
    [_startDateButton setEnabled:YES];
    [_endDateButton setEnabled:YES];
    [_startDateButton setTitle:@"Start Date" forState:UIControlStateNormal];
    [_endDateButton setTitle:@"Start Date" forState:UIControlStateNormal];
    _eventName.text=@"";
    _startingDate=@"";
    _endingDate=@"";
    _hideImage=YES;
    _numberOfChallenges=0;
    [self.challengesChooser reloadData];
    
    
}
@end

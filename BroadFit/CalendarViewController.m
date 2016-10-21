//
//  CalendarViewController.m
//  BroadFit
//
//  Created by sagar ayi on 18/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "CalendarViewController.h"
#import "ConnectionHandler.h"
@interface CalendarViewController ()
@property NSMutableArray* names;
@property NSMutableDictionary* details;
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _details=[[NSMutableDictionary alloc]init];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    self.detailTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.detailTable.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)getChallengeDetails:(id)sender {
    
    [_details removeAllObjects];
    NSString * uid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.alpha = 1.0;
    _activityIndicator.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
    [_activityIndicator startAnimating];
    [self.view addSubview:_activityIndicator];
    ConnectionHandler * connection=[[ConnectionHandler alloc]init];
    connection.delegate=self;
    [connection fetchMyChallenges:uid];
    
    
    
}

- (void) didFetchChallenges:(NSDictionary *)challenges
{
    if(challenges == NULL || [challenges isKindOfClass:[NSNull class]])
    {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"NO EVENTS"
                                    message:@"No events joined yet"
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *addOK = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
                                {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                
                                }];
        [alert addAction:addOK];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd-MM-yyyy"];
        NSString * currentDate=[formatter stringFromDate:_datePicker.date];
        _names = [NSMutableArray arrayWithArray: [[challenges objectForKey:@"challenges enrolled"]allKeys]] ;
        NSMutableDictionary *challengesEnrolled = [challenges objectForKey:@"challenges enrolled" ] ;
        NSArray *allItems=[challengesEnrolled allKeysForObject:@""];
        
        for(int i=0;i<[allItems count];i++)
        {
            [challengesEnrolled removeObjectForKey:allItems[i]];
            [_names removeObject:allItems[i]];
          
        }
        
        
        for( NSString* challenge in _names)
        {
            
            NSDictionary *currentDateItems = [[challengesEnrolled objectForKey:challenge]objectForKey:currentDate];
            if( currentDateItems!= nil)
            {
                [_details setObject:currentDateItems forKey:challenge];
            }
        }
        
        if([_details count]== 0)
        {
            _names = nil;
            [_details removeAllObjects];
            [_detailTable reloadData];
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"NO EVENTS ON"
                                        message:[NSString stringWithFormat:@"%@ ",currentDate]
                                        preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *addOK = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
            {
                [alert dismissViewControllerAnimated:YES completion:nil];
                
            }];
            [alert addAction:addOK];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            [_detailTable reloadData];
        }
        [_activityIndicator stopAnimating];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_names count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = [_names objectAtIndex:section];
    NSArray *sectionDetails = [_details objectForKey:sectionTitle];
    return [sectionDetails count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_names objectAtIndex:section];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"detailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
        cell = [[TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
 
    NSString *sectionTitle = [_names objectAtIndex:indexPath.section];
    NSDictionary *sectionDetails = [_details objectForKey:sectionTitle];
    
    NSString *detailTextValue = @"";
    NSString *detailTextKey = @"";
    if([sectionDetails isKindOfClass:[NSDictionary class]])
    {
        int index = 0;
        for(id key in sectionDetails) {
            if(index == indexPath.row)
            {
                detailTextValue = (NSString*)[sectionDetails objectForKey:key];
                detailTextKey = (NSString*)[[sectionDetails allKeysForObject:detailTextValue]objectAtIndex:0];
                break;
            }
            index++;
            // do something with key and obj
        }
    }
    else if([sectionDetails isKindOfClass:[NSArray class]])
    {
        NSLog(@"Array");
    }
    
  
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@",detailTextKey,detailTextValue];
    //
    return cell;
    
}


@end

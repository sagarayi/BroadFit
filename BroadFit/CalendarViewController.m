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
@property NSArray* names;
@property NSMutableDictionary* details;
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _details=[[NSMutableDictionary alloc]init];
    
    [self.datePicker addTarget:self action:@selector(datePickerChanged) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)datePickerChanged
{
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
//                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//                                    UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChallengesController"];
//                                    [self presentViewController:viewController animated:YES completion:nil];
                                }];
        [alert addAction:addOK];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd-MM-yyyy"];
        NSString * currentDate=[formatter stringFromDate:_datePicker.date];
        _names = [[challenges objectForKey:@"challenges enrolled"]allKeys];
        for( NSString* challenge in _names){
            if([[[challenges objectForKey:@"challenges enrolled" ] objectForKey:challenge]objectForKey:currentDate] != nil)
             [_details setObject:[[[challenges objectForKey:@"challenges enrolled"]objectForKey:challenge]objectForKey:currentDate] forKey:challenge];
            
            
        }
        if([_details  count]== 0)
        {
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
                                    //                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                    //                                    UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChallengesController"];
                                    //                                    [self presentViewController:viewController animated:YES completion:nil];
                                }];
        [alert addAction:addOK];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [_detailTable reloadData];
    }
//        ConnectionHandler * connection=[ConnectionHandler new];
//        connection.delegate=self;
//        NSString * uid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
//        [connection fetchUserChallengeDetails:currentDate with:uid and:challenges];
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
//    if(indexPath.row < ([_names count]-1)){
        NSLog(@"%ld",(long)indexPath.row);
       // NSDictionary * individualChallenge=[_details objectForKey:[_names objectAtIndex:indexPath.row]];
        //NSArray *detailKeys = [individualChallenge allKeys];
//        for(int i=0;i<[individualChallenge count];i++)
//        {
            //cell.textLabel.text= [NSString stringWithFormat:@"%@:%@",detailKeys[indexPath.row],[individualChallenge valueForKey:detailKeys[indexPath.row]]];
//        }
//    NSString *sectionTitle = [_names objectAtIndex:indexPath.section];
//    NSArray *sectionDetails = [_details objectForKey:sectionTitle];
//    NSString *detail = [sectionDetails objectAtIndex:indexPath.row];
//    cell.textLabel.text = detail;
//    
    return cell;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

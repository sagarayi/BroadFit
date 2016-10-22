//
//  EventCreationViewController.m
//  BroadFit
//
//  Created by sagar ayi on 21/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "EventCreationViewController.h"

@interface EventCreationViewController ()
@property UISwitch * switchView;
@property NSInteger cellNumber;
@end

@implementation EventCreationViewController
@synthesize switchView,cellNumber;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"detailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"SwitchCell"] autorelease];
        cell.textLabel.text = @"I Have A Switch";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:NO animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:and:) forControlEvents:UIControlEventValueChanged];
        
    }
    
    
    cell.textLabel.text = @"hi";
    cellNumber=indexPath.row;
    //
    return cell;
    
}
-(void )switchChanged:(id)sender and:(NSInteger*)rowNumber
{
//    NSLog(@"State is : %@ in index:%ld ",(switchView.on) ? @"ON":@"OFF",(long)cellNumber);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"State is : %@ in index:%ld ",(switchView.on) ? @"ON":@"OFF",indexPath.row);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)createEvent:(id)sender {
}
@end

//
//  AllParticipantsViewController.m
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 21/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "AllParticipantsViewController.h"
#import "FirebaseConnectionHandler.h"
@interface AllParticipantsViewController ()

@end

@implementation AllParticipantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.participantsTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.participantsTable.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.participantsTable.layer.cornerRadius = 10;
}
-(void)viewDidAppear:(BOOL)animated
{
    _allUsers = [[NSMutableDictionary alloc]init];
    _usersInChallenge = [[NSMutableDictionary alloc]init];
    _eachUser = [[NSMutableDictionary alloc]init];
    __block UITextField *eventText;
    UIAlertController *acceptEventAlert = [UIAlertController
                                           alertControllerWithTitle:@"ENTER EVENT"
                                           message:@"Enter the event name"
                                           preferredStyle:UIAlertControllerStyleAlert];
    [acceptEventAlert addTextFieldWithConfigurationHandler:^(UITextField *eventNameField){
        eventNameField.placeholder = @"EventName";
        eventText=eventNameField;
        
    }];
    UIAlertAction *okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action){
                                   _eventName =[ [acceptEventAlert textFields][0] text];
                                   if(_eventName == NULL || [_eventName isKindOfClass:[NSNull class]] || [_eventName isEqualToString:@""]){
                                       
                                       [self presentViewController:acceptEventAlert animated:YES completion:nil];
                                       
                                   }else{
                                           [eventText resignFirstResponder];
                                           [self fetchUsers];
                                           [self fetchChallenges];
                                   }
    }];
    UIAlertAction *cancelButton = [UIAlertAction
                               actionWithTitle:@"CANCEL"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action){
                                                                }];
    [acceptEventAlert addAction:okButton];
    [acceptEventAlert addAction:cancelButton];
    [self presentViewController:acceptEventAlert animated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) fetchChallenges {
    
    FirebaseConnectionHandler *handler = [[FirebaseConnectionHandler alloc]init];
    handler.delegate = self;
    [handler fetchAllChallenges:_eventName];
}

- (void) challengesRecieved:(NSDictionary *)challenges{
    if(challenges == NULL || [challenges isKindOfClass:[NSNull class]]){
        [_participantsTable setHidden:TRUE];
        UIAlertController *noParticipantsAlert = [UIAlertController
                                                  alertControllerWithTitle:@"NO PARTICIPANTS"
                                                  message:@"No participants have joined yet"
                                                  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *acttion){
                                       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                       UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChallengesController"];
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       [self presentViewController:viewController animated:NO completion:nil];
                                       }];
        [noParticipantsAlert addAction:okButton];
        [self presentViewController:noParticipantsAlert animated:YES completion:nil];
    }else
        _allChallengesInEvent = [[challenges objectForKey:@"Challenges"]allKeys];
}
- (void) fetchUsers{
    
    FirebaseConnectionHandler *handler = [FirebaseConnectionHandler sharedInstance];
    handler.delegate = self;
    [handler fetchAllUsersForEvent:_eventName];
}
- (void) didFetchUsers:(NSDictionary *)users{
    int index = 0;
    for(NSString *user in users){
        
        if([[[users objectForKey:user] objectForKey:@"Event Enrolled"] isEqualToString:_eventName]){
            [_allUsers setObject:[users objectForKey:user] forKey:[NSString stringWithFormat:@"%d",index]];
            index ++;
        }
    }
    [self addUsersToChallenge];
}
- (void) addUsersToChallenge{
    for(NSString *challenge in _allChallengesInEvent){
        _eachUser = [NSMutableDictionary new];
        for(NSString *user in _allUsers){
            NSString *username = [[_allUsers objectForKey:user]objectForKey:@"username"];
            NSArray *userChallenges = [[[_allUsers objectForKey:user]objectForKey:@"challenges enrolled"]allKeys];
            for(NSString *eachUserChallenge in userChallenges){
                if([eachUserChallenge isEqualToString:challenge]){
                    [_eachUser setObject:@"" forKey:username];
                }
            }
        }
      [_usersInChallenge setObject:_eachUser forKey:challenge];
    }
    [_participantsTable reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_allChallengesInEvent count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 8, 320, 20);
    myLabel.textColor = [UIColor whiteColor];
    myLabel.font = [UIFont boldSystemFontOfSize:18];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    [headerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-section"]]];
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = [[_usersInChallenge allKeys]objectAtIndex:section];
    NSArray *sectionRows = [[_usersInChallenge objectForKey:sectionTitle] allKeys];
    return [sectionRows count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[_usersInChallenge allKeys] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ParticipantsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    NSString *sectionTitle = [[_usersInChallenge allKeys] objectAtIndex:indexPath.section];
    NSArray *sectionDetails = [[_usersInChallenge objectForKey:sectionTitle]allKeys];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.textLabel.text = [NSString stringWithFormat:@"        %@",sectionDetails[indexPath.row]];
  return cell;
}
@end



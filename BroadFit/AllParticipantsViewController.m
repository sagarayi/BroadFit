//
//  AllParticipantsViewController.m
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 21/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "AllParticipantsViewController.h"
#import "ConnectionHandler.h"
@interface AllParticipantsViewController ()

@end

@implementation AllParticipantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
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
       // eventNameField.delegate=self;
        
    }];
    UIAlertAction *okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action){
                                   _eventName =[ [acceptEventAlert textFields][0] text];
                                   [eventText resignFirstResponder];
                                   [self fetchUsers];
                                   [self fetchChallenges];
    }];
    [acceptEventAlert addAction:okButton];
    [self presentViewController:acceptEventAlert animated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) fetchChallenges {
    
    ConnectionHandler *handler = [[ConnectionHandler alloc]init];
    handler.delegate = self;
    [handler fetchAllChallenges:_eventName];
}

- (void) challengesRecieved:(NSDictionary *)challenges{
    
    _allChallengesInEvent = [[challenges objectForKey:@"Challenges"]allKeys];
}
- (void) fetchUsers{
    
    ConnectionHandler *handler = [ConnectionHandler sharedInstance];
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
            NSString *username = [[_allUsers objectForKey:user]objectForKey:@"Username"];
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
    int index = 0;
    for(NSString *challenge in _allChallengesInEvent){
        NSArray *participantsInChallenge = [_usersInChallenge objectForKey:challenge];
        if([participantsInChallenge count] == 0)
            index ++;
    }
    if(index == [[_usersInChallenge allKeys]count]){
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
                                     //  [self.navigationController pushViewController:viewController animated:NO];


        }];
        [noParticipantsAlert addAction:okButton];
        [self presentViewController:noParticipantsAlert animated:YES completion:nil];
    }else{
        [_participantsTable setHidden:FALSE];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_allChallengesInEvent count];
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
    // int serialNumber = indexPath.row + 1;
    cell.textLabel.text = [NSString stringWithFormat:@" %@",sectionDetails[indexPath.row]];
  return cell;
}

@end



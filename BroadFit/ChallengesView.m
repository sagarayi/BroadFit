//
//  ChallengesView.m
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "ChallengesView.h"
#import "BFSlideViewController.h"
#import "CalendarViewController.h"
#import "SignIn.h"
#import "BFTabBarController.h"
@interface ChallengesView ()

@end

@implementation ChallengesView
- (void)viewDidLoad {
    [super viewDidLoad];
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.alpha = 1.0;
    _activityIndicator.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
    [_activityIndicator startAnimating];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.joinButton setHidden:YES];
    _eventAvailabilityStatus = NO;
    [self.view addSubview:_activityIndicator];
    ConnectionHandler *connectionHandler = [ConnectionHandler sharedInstance];
    connectionHandler.delegate = self;
    [connectionHandler areEventsAvailable];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self initialSetup];


}
- (void) initialSetup{
   
    //FETCH ALL CHALLENGES
   
    if(_eventAvailabilityStatus){
        ConnectionHandler *connectionHandler = [ConnectionHandler sharedInstance];
        connectionHandler.delegate = self;
        [connectionHandler fetchAllChallenges:_EventName];
    }
   
}
- (void) didRecieveEventAvailability:(BOOL)status{
    
    if(status == NO){
        _eventAvailabilityStatus = NO;
        UIAlertController *noEventsAlert = [UIAlertController
                                            alertControllerWithTitle:@"NO EVENTS"
                                            message:@"No events yet.."
                                            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okActionButton = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action){}];
        [noEventsAlert addAction:okActionButton];
        [self presentViewController:noEventsAlert animated:YES completion:nil];
    
    }else{
        _eventAvailabilityStatus = YES;
        [self fetchEventName];

    }
}
- (void) fetchEventName{

    //Fetching all active events
    ConnectionHandler *connectionHandler = [ConnectionHandler sharedInstance];
    connectionHandler.delegate = self;
    [connectionHandler fetchActiveEvents];

}
- (void) didRecieveActiveEvent:(NSString *)activeEvent{
    
    _EventName = activeEvent;
    NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    ConnectionHandler *handler = [ConnectionHandler sharedInstance];
    handler.delegate =self;
    [handler didUser:userID enrollTo:_EventName];

    
}
- (void) userHasNotEnrolled:(BOOL)status{
    if(status == NO){
        
        NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
        NSString *alertTitle = [NSString stringWithFormat:@"ACTIVE EVENT:%@",_EventName];
        [[NSUserDefaults standardUserDefaults]setObject:_EventName forKey:@"Eventname"];
        UIAlertController *enrollToEventAlert = [UIAlertController
                                                 alertControllerWithTitle:alertTitle
                                                 message:@"Press Ok To enroll to event"
                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okActionButton = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action){
                                             ConnectionHandler *handler = [ConnectionHandler sharedInstance];
                                             [handler enroll:userID forEvent:_EventName];
                                             [self initialSetup];
                                             
                                             
                                         }];
        UIAlertAction *cancelActionButton = [UIAlertAction
                                             actionWithTitle:@"CANCEL"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction *action){}];
        [enrollToEventAlert addAction:okActionButton];
        [enrollToEventAlert addAction:cancelActionButton];
        [self presentViewController:enrollToEventAlert animated:YES completion:nil];
    }else{
        [self initialSetup];

    }

    
}
- (void) viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    [[[self.navigationController navigationBar] topItem] setTitle:@"Challenges"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Delegate from connection handler, returning all available challenges in the event

- (void) challengesRecieved:(NSDictionary *)challenges{
    
    _challenges = [challenges objectForKey:@"Challenges"];
    [self cacheImages:_challenges];
    [_activityIndicator stopAnimating];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.challengeImage.image=[UIImage imageNamed:@"walking"];
    [self.joinButton setHidden:NO];
    [_tableView reloadData];
}
- (void) viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillDisappear:animated];
}

// Caching the images and challenge detials for further use

- (void) cacheImages:(NSDictionary *)allChallenges{
    NSArray *challeneges = [allChallenges allKeys];
    NSMutableArray *challengeImages = [NSMutableArray new];
    for( id eachChallenege in challeneges ){
        NSString *imageName = [[allChallenges objectForKey:eachChallenege]objectForKey:@"image"];
        [challengeImages addObject:imageName];
        [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:eachChallenege];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_challenges count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tableCell";
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *keys=[_challenges allKeys];
    // Create cell if it is nil
    if (cell == nil) {
        cell = [[TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    _challengeCellTitle = [keys objectAtIndex:indexPath.row];
    cell.challengeName.text = _challengeCellTitle;
    NSString *participants = [ NSString stringWithFormat:@"%@",[[_challenges objectForKey:cell.challengeName.text] objectForKey:@"Participants"]];
    cell.numberOfParticipants.text = participants;
    NSString *imageName = [ NSString stringWithFormat:@"%@",[[_challenges objectForKey:cell.challengeName.text] objectForKey:@"image"]];
    cell.thumbimage.image = [UIImage imageNamed:imageName];
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *keys=[_challenges allKeys];
    [_joinButton setTitle:@"Join" forState:UIControlStateNormal];
    _individualChallengeSelected = [keys objectAtIndex:indexPath.row];
    NSString *imageName = [ NSString stringWithFormat:@"%@",[[_challenges objectForKey:_individualChallengeSelected] objectForKey:@"image"]];
    _challengeCellImage.image = [UIImage imageNamed:imageName];
    static NSString *cellIdentifier = @"tableCell";
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // Create cell if it is nil
    if (cell == nil) {
        cell = [[TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Join a challenge
    NSString *userID = [[NSUserDefaults standardUserDefaults]valueForKey:@"userID"];
    FIRDatabaseReference *rootRef= [[FIRDatabase database] reference];
    FIRDatabaseReference *ref = [[[rootRef  child:@"Users" ]child:userID ] child:@"challenges enrolled"];
    // Check if already joined or yet to join
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot  *snapshot) {
        id data = snapshot.value;
        if(snapshot.value != NULL && ![snapshot.value isKindOfClass:[NSNull class]]&& snapshot.value[_individualChallengeSelected] != NULL && ![data isKindOfClass:[NSNull class]]){
            cell.numberOfParticipants.text = [NSString stringWithFormat:@"%d" ,([cell.numberOfParticipants.text intValue]+1)];
            [_joinButton setTitle:@"Joined" forState:UIControlStateNormal];
            [_joinButton setEnabled:FALSE];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UIViewController *viewController = nil;
            if([_individualChallengeSelected isEqualToString:@"Walking"]){
                viewController = [storyboard instantiateViewControllerWithIdentifier:@"WalkingController"];
            }else if([_individualChallengeSelected isEqualToString:@"Eating"]){
                viewController = [storyboard instantiateViewControllerWithIdentifier:@"EatingController"];
            }
            else if([_individualChallengeSelected isEqualToString:@"Drinking Water"]){
                viewController = [storyboard instantiateViewControllerWithIdentifier:@"DrinkingController"];
            }else if([_individualChallengeSelected isEqualToString:@"Sleeping"]){
                    viewController = [storyboard instantiateViewControllerWithIdentifier:@"SleepingVC"];
            }
            [ref removeAllObservers];
            [self.navigationController pushViewController:viewController animated:YES];

        }else{
            
            [_joinButton setTitle:@"Join" forState:UIControlStateNormal];
            [_joinButton setEnabled:TRUE];

        }
    }];

}

- (IBAction)join:(id)sender {
    
   if(_individualChallengeSelected == NULL){
        UIAlertController *selectChallengeAlert = [UIAlertController
                                                   alertControllerWithTitle:@"SELECT A CHALLENGE"
                                                   message:@"Select a challenge to Join"
                                                   preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action){}];
        [selectChallengeAlert addAction:okButton];
        [self presentViewController:selectChallengeAlert animated:YES completion:nil];
    }else{
        
        ConnectionHandler *connectionHandler = [ConnectionHandler sharedInstance];
        NSString *userID = [[NSUserDefaults standardUserDefaults]valueForKey:@"userID"];
        [connectionHandler joinChallenge:_individualChallengeSelected forUser:userID];
        [connectionHandler setNumberOfParticipants:_EventName has:_individualChallengeSelected setValue:1];
    }
}

@end

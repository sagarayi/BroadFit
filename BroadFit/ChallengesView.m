//
//  ChallengesView.m
//  BroadFit
//
//  Created by Shrinidhi Kodandoor on 05/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "ChallengesView.h"
#import "SlideViewController.h"
#import "CalendarViewController.h"
#import "SignIn.h"
@interface ChallengesView ()

@end

@implementation ChallengesView
- (void)viewDidLoad {
    [super viewDidLoad];
    

    //FETCH ALL CHALLENGES
    ConnectionHandler *connectionHandler = [ConnectionHandler sharedInstance];
    connectionHandler.delegate = self;
    _EventName = @"Summer Challenges";
    [connectionHandler fetchAllChallenges:_EventName];
    
    
    //ADD ACTIVITY INDICATOR
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.alpha = 1.0;
    _activityIndicator.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
    [_activityIndicator startAnimating];
    [self.view addSubview:_activityIndicator];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    

    SlideViewController *menuController=[storyBoard instantiateViewControllerWithIdentifier:@"tableView"];
    CalendarViewController *calendarController=[storyBoard instantiateViewControllerWithIdentifier:@"Calendar"];
    SignIn *sign=[storyBoard instantiateViewControllerWithIdentifier:@"Login"];
    menuController = [menuController initWithViewControllers:@[self,calendarController,sign]
                                               andMenuTitles:@[[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"], @"Calendar",@"Signout"]];
    
    
    self.window.rootViewController = menuController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Delegate from connection handler, returning all available challenges in the event

- (void) challengesRecieved:(NSDictionary *)challenges{
    
    _challenges = [challenges objectForKey:@"Challenges"];
    [self cacheImages:_challenges];
    [_activityIndicator stopAnimating];
    [_tableView reloadData];

    
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
    _individualChallengeSelected = [keys objectAtIndex:indexPath.row];
    NSString *imageName = [ NSString stringWithFormat:@"%@",[[_challenges objectForKey:_individualChallengeSelected] objectForKey:@"image"]];
    _challengeCellImage.image = [UIImage imageNamed:imageName];
    
    // Join a challenge
   
    NSString *userID = [[NSUserDefaults standardUserDefaults]valueForKey:@"userID"];

    
    FIRDatabaseReference *rootRef= [[FIRDatabase database] reference];
    FIRDatabaseReference *ref = [[[rootRef  child:@"Users" ]child:userID ] child:@"challenges enrolled"];
    
    // Check if already joined or yet to join
    
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot  *snapshot) {
        id data = snapshot.value;
        
        if(snapshot.value != NULL && ![snapshot.value isKindOfClass:[NSNull class]]&& snapshot.value[_individualChallengeSelected] != NULL && ![data isKindOfClass:[NSNull class]]){
            
                    [_joinButton setTitle:@"Joined" forState:UIControlStateNormal];

                    }else{
                           [_joinButton setTitle:@"Join" forState:UIControlStateNormal];
            
                    }
    }];

}

- (IBAction)options:(id)sender {
    
    
}
- (IBAction)join:(id)sender {
    
   
    if(_individualChallengeSelected == NULL){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"SELECT A CHALLENGE" message:@"Select a challenge to Join" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *addOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [alert addAction:addOK];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        ConnectionHandler *connectionHandler = [ConnectionHandler sharedInstance];
        NSString *userID = [[NSUserDefaults standardUserDefaults]valueForKey:@"userID"];
        [connectionHandler joinChallenge:_individualChallengeSelected forUser:userID];
    }}


@end

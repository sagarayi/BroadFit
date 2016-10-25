//
//  UserChallenges.m
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 13/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "UserChallenges.h"
#import "ConnectionHandler.h"
@interface UserChallenges ()

@end

@implementation UserChallenges


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"MY CHALLENGES";
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    ConnectionHandler *connectionHandler = [ConnectionHandler sharedInstance];
    connectionHandler.delegate = self;
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [connectionHandler fetchMyChallenges:userID];
    [[[self.navigationController navigationBar] topItem] setTitle:@"My Challenges"];
    //ADD ACTIVITY INDICATOR
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.alpha = 1.0;
    _activityIndicator.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
    [_activityIndicator startAnimating];
    [self.view addSubview:_activityIndicator];

}

- (void) didFetchChallenges:(NSDictionary *)challenges{
    if(challenges == NULL || [challenges isKindOfClass:[NSNull class]]){
        
        UIAlertController *noEventsAlert = [UIAlertController
                                    alertControllerWithTitle:@"NO CHALLENGES"
                                    message:@"No Challenges joined yet"
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
                                {
                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                    UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChallengesController"];
                                    [self presentViewController:viewController animated:NO completion:nil];
                                }];
        [noEventsAlert addAction:okButton];
        [self presentViewController:noEventsAlert animated:YES completion:nil];
    }else{
    
        _myChallenges = [challenges objectForKey:@"challenges enrolled"];
        [_activityIndicator stopAnimating];
        [_tableView reloadData];
   }
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillDisappear:animated];
}
- (void) viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_myChallenges count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ChallengeCell";
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *keys=[_myChallenges allKeys];
    if (cell == nil) {
        cell = [[TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    _challengeCellTitle = [keys objectAtIndex:indexPath.row];
    cell.challengeName.text = _challengeCellTitle;
    cell.thumbimage.image = [UIImage imageNamed:[[NSUserDefaults standardUserDefaults] valueForKey:_challengeCellTitle]];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *keys=[_myChallenges allKeys];
    
    NSString *individualChallengeSelected = [keys objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *viewController = nil;

    if([individualChallengeSelected isEqualToString:@"Walking"])
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"WalkingController"];
    else if([individualChallengeSelected isEqualToString:@"Eating"])
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"EatingController"];
    else if([individualChallengeSelected isEqualToString:@"Drinking Water"])
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"DrinkingController"];
    else if([individualChallengeSelected isEqualToString:@"Sleeping"])
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"SleepingVC"];
    [self.navigationController pushViewController:viewController animated:YES];


}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        ConnectionHandler *handler = [ConnectionHandler sharedInstance];
        [handler deleteChallenge:[[_myChallenges allKeys]objectAtIndex:indexPath.row] forUser:[FIRAuth auth].currentUser.uid];
        [handler setNumberOfParticipants:@"Event1" has:[[_myChallenges allKeys]objectAtIndex:indexPath.row] setValue:-1];
        NSString *challengeSelected = [[_myChallenges allKeys]objectAtIndex:indexPath.row];
        [_myChallenges removeObjectForKey:challengeSelected];
        [_tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
        if([[_myChallenges allKeys]count]==0){
            UIAlertController *noEventsAlert = [UIAlertController
                                                alertControllerWithTitle:@"NO CHALLENGES"
                                                message:@"No Challenges joined yet"
                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                           UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChallengesController"];
                                           [self presentViewController:viewController animated:NO completion:nil];
                                       }];
            [noEventsAlert addAction:okButton];
            [self presentViewController:noEventsAlert animated:YES completion:nil];
            
            
        }
        [_tableView reloadData];
        
    }
}

@end

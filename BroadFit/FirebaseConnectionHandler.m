//
//  ConnectionHandler.m
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 07/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "FirebaseConnectionHandler.h"
#import "BFSlideViewController.h"
#import "CalendarViewController.h"
#import "AllParticipantsViewController.h"
#import "BFTabBarController.h"
#define kAllChallenges "AllChallenges"
static FirebaseConnectionHandler *instance;
@implementation FirebaseConnectionHandler

+ (id) sharedInstance{
    
    if(instance == nil){
        instance = [[FirebaseConnectionHandler alloc]init];
    }
    return instance;
}

- (void) fetchActiveEvents{
    __block NSDictionary *allEvents = [[NSDictionary alloc]init];
    __block NSString *activeEvent = [[NSString alloc]init];
    __block BOOL enrollFlag = false;
    FIRDatabaseReference *reference = [[[FIRDatabase database]reference]child:@"Events"];
    FIRDatabaseQuery *query=[reference queryOrderedByKey];
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        allEvents = snapshot.value;
        NSArray *eventsArray = [allEvents allKeys];
        for(NSString *event in eventsArray){
            
            NSString *startDate = [[[allEvents objectForKey:event]objectForKey:@"EventDetails"]objectForKey:@"StartDate"];
            NSString *endDate = [[[allEvents objectForKey:event]objectForKey:@"EventDetails"]objectForKey:@"EndDate"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSDate *currentDate = [NSDate date];
            [dateFormatter setDateFormat:@"dd-MM-yyyy"];
            NSDate *startDateFromString = [[NSDate alloc] init];
            startDateFromString = [dateFormatter dateFromString:startDate];
            NSDate *endDateFromString = [[NSDate alloc]init];
            endDateFromString =[dateFormatter dateFromString:endDate];
            if([currentDate compare:startDateFromString] == NSOrderedAscending)
                enrollFlag = false;
            if([currentDate compare:endDateFromString] == NSOrderedDescending)
                enrollFlag = false;
            enrollFlag = true;
            activeEvent = event;
            
        }
        if(enrollFlag == true){
            if([self.delegate respondsToSelector:@selector(didRecieveActiveEvent:)])
                [self.delegate didRecieveActiveEvent:activeEvent];
        }
    }];

    
    
}

- (void) signUpWithData:(NSDictionary *)user{
        [[FIRAuth auth] createUserWithEmail:[user objectForKey:@"emailID"]
                               password:[user objectForKey:@"password"]
                             completion:^(FIRUser * _Nullable User, NSError * _Nullable error) {
                                 if (error) {
                                     if([self.delegate respondsToSelector:@selector(failedToSignUp:)])
                                         [self.delegate failedToSignUp:error.localizedDescription];
                                }else{
                                     [[FIRAuth alloc]signInWithEmail:[user objectForKey:@"emailID"]
                                                           password:[user objectForKey:@"password"]
                                                           completion:^(FIRUser *userdetails , NSError * error)
                                                                {
                                                                    [self addUsername:user];
                                                                    
                                                                    if([self.delegate respondsToSelector:@selector(signUpSuccessful)])
                                                                            [self.delegate signUpSuccessful];
                                                                }];
                                     
                                     }
                             }];
    
    
}
- (void) addUsername:(NSDictionary *)user{
    FIRDatabaseReference *ref = [[FIRDatabase database]reference];
    NSString *uid = [FIRAuth auth].currentUser.uid;
    [[[[ref child:@"Users"]child:uid]child:@"username"]setValue:[user objectForKey:@"username"]];
    

    }
- (void) fetchAllUsersForEvent:(NSString *)eventName{
    
    FIRDatabaseReference *reference = [[[FIRDatabase database]reference]child:@"Users"];
    [reference observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if([self.delegate respondsToSelector:@selector(didFetchUsers:)])
            [self.delegate didFetchUsers:snapshot.value];
    }];
    
}

- (void) signInWithData:(NSDictionary *)user{
    [[FIRAuth auth] signInWithEmail:[user objectForKey:@"emailID"]
                           password:[user objectForKey:@"password"]
                           completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                             if (error) {
                                 if([self.delegate respondsToSelector:@selector(signInFailed:)])
                                     [self.delegate signInFailed:error.localizedDescription];
                             }
                             else{
                                 if([self.delegate respondsToSelector:@selector(signInSuccessful)])
                                     [self.delegate signInSuccessful];
                             }
                            [FIRAnalytics logEventWithName:kFIREventLogin parameters:nil];
                             
                         }];

}

- (void) joinChallenge:(NSString *)challenge forUser:(NSString *)userID{
    
    FIRDatabaseReference *ref = [[FIRDatabase database]reference];
    [[[[[ref child:@"Users"] child:userID] child:@"challenges enrolled"]child:challenge]setValue:@""];
    
}

-(void)setNumberOfParticipants:(NSString*)eventName has:(NSString*)challengeName
{
    FIRDatabaseReference *reference=[[[[[[FIRDatabase database]reference]child:eventName]child:@"Challenges"]child:challengeName]child:@"Participants"];
    FIRDatabaseQuery *query=[reference queryOrderedByKey];
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot)
     {
         NSString* numberOfParticipants=snapshot.value;
         numberOfParticipants=[NSString stringWithFormat:@"%ld",[numberOfParticipants integerValue]+1];
         [reference setValue:numberOfParticipants];
     }];
}
-(void)fetchImages
{
    FIRDatabaseReference *references=[[[FIRDatabase database]reference]child:@"Images"];
    FIRDatabaseQuery *query=[references queryOrderedByKey];
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot)
     {
         NSDictionary *images=snapshot.value;
         if(self.delegate && [self.delegate respondsToSelector:@selector(didFetchImages:)])
         {
             [self.delegate didFetchImages:images];
         }
     }];
}

- (void) enroll:(NSString *)userID forEvent:(NSString *)eventName{
    
    FIRDatabaseReference *reference = [[[[FIRDatabase database]reference]child:@"Users"]child:userID];
    [[reference child:@"Event Enrolled"]setValue:eventName];
    
}
- (void) fetchAllChallenges:(NSString *)eventName{
    
    FIRDatabaseReference *rootRef= [[[[FIRDatabase database] reference]child:@"Events"]child:eventName];
    FIRDatabaseQuery *query = [rootRef queryOrderedByChild:@"Challenges"];
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary *challenges = snapshot.value;
        if([self.delegate respondsToSelector:@selector(challengesRecieved:)])
            [self.delegate challengesRecieved:challenges];
    }];
}

- (void) fetchMyChallenges:(NSString *)userID{
    
    FIRDatabaseReference *rootRef= [[[[FIRDatabase database] reference]child:@"Users"]child:userID];
    FIRDatabaseQuery *query = [rootRef queryOrderedByChild:@"challenges enrolled"];
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary *challenges = snapshot.value;
        if([self.delegate respondsToSelector:@selector(didFetchChallenges:)])
            [self.delegate didFetchChallenges:challenges];
    }];
    
}


- (void) storeToFirebase:(NSDictionary *)walkingDetails{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"dd-MM-yyyy";
    NSString *today = [format stringFromDate:[NSDate date]];
    FIRDatabaseReference *rootReference = [[[[[[[FIRDatabase database]reference]child:@"Users"]child:[FIRAuth auth].currentUser.uid]child:@"challenges enrolled"]child:@"Walking"]child:today];
    [[rootReference child:@"Calories Burnt"] setValue:[walkingDetails objectForKey:@"calories"]];
    [[rootReference child:@"Duration"] setValue:[walkingDetails objectForKey:@"duration"]];
    [[rootReference child:@"Number Of Steps"] setValue:[walkingDetails objectForKey:@"steps"]];
    [[rootReference child:@"Distance"] setValue:[walkingDetails objectForKey:@"distance"]];

}

-(void)isAdmin:(NSString *)userID
{
    __block NSString *uid;
    FIRDatabaseReference *ref=[[[FIRDatabase database]reference]child:@"Admin"];
    FIRDatabaseQuery *query=[ref queryOrderedByKey];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot){
             uid=snapshot.value;
             if(self.delegate && [self.delegate respondsToSelector:@selector(adminStatus:)])
             {
                 if([uid isEqualToString:userID])
                     [self.delegate adminStatus:true];
                 else
                     [self.delegate adminStatus:false];
             }
             
             
         }];
        
    });
    
        
}

-(void)updateChallengeDetails:(NSString*)challengeName and:(NSArray*)detailName with:(NSArray*)detailValues
{
    NSString * userID= [FIRAuth auth].currentUser.uid;
    NSDateFormatter * format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateToday=[NSDate date];
    NSString * currentDate=[format stringFromDate:dateToday];
    FIRDatabaseReference *reference=[[[[[[[FIRDatabase database]reference ]child:@"Users"]child:userID]child:@"challenges enrolled"]child:challengeName]child:currentDate];
    for(int i=0;i<[detailName count];i++)
    {
        [[reference child:[detailName objectAtIndex:i]]setValue:[detailValues objectAtIndex:i]];
    }
    
}

-(void)setNumberOfParticipants:(NSString*)eventName has:(NSString*)challengeName setValue:(int)quantity
{
    FIRDatabaseReference *reference=[[[[[[[FIRDatabase database]reference] child:@"Events"]child:eventName]child:@"Challenges"]child:challengeName]child:@"Participants"];
    FIRDatabaseQuery *query=[reference queryOrderedByKey];
     __block NSString *numberOfParticipants;
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot)
    {
        if(![snapshot.value isKindOfClass:[NSNull class]] && snapshot.value != NULL){
            numberOfParticipants = snapshot.value;
            numberOfParticipants=[NSString stringWithFormat:@"%ld",[numberOfParticipants integerValue]+quantity];
            [reference removeAllObservers];
            [reference setValue:numberOfParticipants];
           
        }
    }];
    
}
-(void)fetchListOfChallenges
{
    FIRDatabaseReference *reference=[[[FIRDatabase database]reference]child:@kAllChallenges];
    FIRDatabaseQuery *query=[reference queryOrderedByKey];
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot)
     {
         if(![snapshot.value isKindOfClass:[NSNull class]] && snapshot.value!=NULL)
         {
             NSDictionary* listOfChallenges=snapshot.value;
             if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishFetchingChallenges:)])
             {
                 [self.delegate didFinishFetchingChallenges:listOfChallenges];
             }
         }
             }];
}

-(void)addEventDetails:(NSString*)eventName containing:(NSArray*)challenges from:(NSString*)startDate till:(NSString*)endDate with:(NSArray*)imageList and:(NSDictionary*)challengeId
{
    FIRDatabaseReference *reference=[[[[[FIRDatabase database]reference]child:@"Events"]child:eventName]child:@"Challenges"];
    for(int i=0;i<[challenges count];i++)
    {
        [[[reference child:challenges[i]]child:@"Id"]setValue:[challengeId objectForKey:challenges[i]]];
        [[[reference child:challenges[i]]child:@"Participants"]setValue:@"0"];
        [[[reference child:challenges[i]]child:@"Winner"]setValue:@""];
        if([challenges[i] isEqualToString:@"Drinking Water"])
        {
            [[[reference child:challenges[i]]child:@"image"]setValue:@"drinking"];
        }
        else if([challenges[i] isEqualToString:@"Eating"])
        {
            [[[reference child:challenges[i]]child:@"image"]setValue:@"eating"];
        }
        else if([challenges[i] isEqualToString:@"Sleeping"])
        {
            [[[reference child:challenges[i]]child:@"image"]setValue:@"sleeping"];
        }
        else
        {
            [[[reference child:challenges[i]]child:@"image"]setValue:@"walking"];
        }
    }
    reference=[[[[[FIRDatabase database ]reference] child:@"Events"]child:eventName]child:@"EventDetails"];
    [[reference child:@"EndDate"]setValue:endDate];
    [[reference child:@"Name"]setValue:eventName];
    [[reference child:@"StartDate"]setValue:startDate];
    [[reference child:@"Winner"]setValue:@""];
}
- (void) deleteChallenge:(NSString *)challenge forUser:(NSString *)user{
    
    FIRDatabaseReference *reference = [[[[[FIRDatabase database]reference]child:@"Users"]child:user]child:@"challenges enrolled"];
    [[reference child:challenge] removeValue];
    
    
}

- (void) fetchEventName:(NSString *)userID{
    FIRDatabaseReference *reference = [[[[[FIRDatabase database]reference]child:@"Users"]child:userID]child:@"Event Enrolled"];
    FIRDatabaseQuery *query=[reference queryOrderedByKey];
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot)
     {
         NSString *eventName = snapshot.value;
         if(self.delegate && [self.delegate respondsToSelector:@selector(didRecieveEventName:)])
         {
             [self.delegate didRecieveEventName:eventName];
         }
     }];
}
- (void) areEventsAvailable{
    
    FIRDatabaseReference *reference = [[[FIRDatabase database]reference]child:@"Events"];
    FIRDatabaseQuery *query=[reference queryOrderedByKey];
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary *eventList = snapshot.value;
        if(eventList == NULL || [eventList isKindOfClass:[NSNull class]]){
            if([self.delegate respondsToSelector:@selector(didRecieveEventAvailability:)])
                [self.delegate didRecieveEventAvailability:NO];
        }else{
            if([self.delegate respondsToSelector:@selector(didRecieveEventAvailability:)])
                [self.delegate didRecieveEventAvailability:YES];
        }
  
    }];

    
}
- (void) fetchUserName{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    FIRDatabaseReference *reference = [[[[[FIRDatabase database]reference]child:@"Users"]child:uid]child:@"username"];
    FIRDatabaseQuery *query=[reference queryOrderedByKey];
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSString *username = snapshot.value;
            if([self.delegate respondsToSelector:@selector(didfetchUserName:)])
                [self.delegate didfetchUserName:username];
     
    }];
    
    
    
    
}
- (void) didUser:(NSString *)userID enrollTo:(NSString *)eventName{
    
    FIRDatabaseReference *reference = [[[[[FIRDatabase database]reference]child:@"Users"]child:userID]child:@"Event Enrolled"];
    FIRDatabaseQuery *query=[reference queryOrderedByKey];
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary *eventName = snapshot.value;
        if(eventName == NULL ||[eventName isKindOfClass:[NSNull class]]){
            if([self.delegate respondsToSelector:@selector(userHasNotEnrolled:)])
                [self.delegate userHasNotEnrolled:NO];
        }else{
            if([self.delegate respondsToSelector:@selector(userHasNotEnrolled:)])
                [self.delegate userHasNotEnrolled:YES];
        }
    }];
}
@end

//
//  ConnectionHandler.m
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 07/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import "ConnectionHandler.h"
#import "CalendarViewController.h"
static ConnectionHandler *instance;
@implementation ConnectionHandler

+ (id) sharedInstance{
    
    if(instance == nil){
        
        instance = [[ConnectionHandler alloc]init];
        
    }
    return instance;
    
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
                                                                        if([self.delegate respondsToSelector:@selector(signUpSuccessful)])
                                                                            [self.delegate signUpSuccessful];

                                                                }];
                                     
                                     
                                 }

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
- (void) fetchAllChallenges:(NSString *)eventName{
    
    FIRDatabaseReference *rootRef= [[[[FIRDatabase database] reference]child:@"Events"]child:@"Event1"];
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
    FIRDatabaseReference *reference=[[[[[[[FIRDatabase database]reference] child:@"Events"]child:@"Event1"]child:@"Challenges"]child:challengeName]child:@"Participants"];
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

- (void) deleteChallenge:(NSString *)challenge forUser:(NSString *)user{
    
    FIRDatabaseReference *reference = [[[[[FIRDatabase database]reference]child:@"Users"]child:user]child:@"challenges enrolled"];
    [[reference child:challenge] removeValue];
    
    
}
@end

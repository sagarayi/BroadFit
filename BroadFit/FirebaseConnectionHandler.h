//
//  ConnectionHandler.h
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 07/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Firebase/Firebase.h"
#import "Protocol.h"
#import "SignIn.h"
#import "SignUp.h"
#import "BFMyChallengesViewController.h"
#import "EventCreationViewController.h"
@interface FirebaseConnectionHandler : NSObject<FirebaseOperations>{
    
    id <FirebaseOperations> _delegate;
    
}
@property (strong,nonatomic) id delegate;
+ (id) sharedInstance;
- (void) signUpWithData:(NSDictionary *)user;
- (void) signInWithData:(NSDictionary *)user;
- (void) fetchAllChallenges:(NSString *)eventName;
- (void) joinChallenge:(NSString *)challenge forUser:(NSString *)userID;
- (void) fetchMyChallenges:(NSString *)userID;
- (void) storeToFirebase:(NSDictionary *)walkingDetails;
- (void)updateChallengeDetails:(NSString*)challengeName and:(NSArray*)detailName with:(NSArray*)detailValues;
- (void)fetchListOfChallenges;
- (void)setNumberOfParticipants:(NSString*)eventName has:(NSString*)challengeName setValue:(int)quantity;
- (void) deleteChallenge:(NSString *)challenge forUser:(NSString *)user;
- (void)addEventDetails:(NSString*)eventName containing:(NSArray*)challenges from:(NSString*)startDate till:(NSString*)endDate with:(NSArray*)imageList and:(NSDictionary*)challengeId;
- (void)fetchImages;
-(void)isAdmin:(NSString *)userID;
- (void) fetchAllUsersForEvent:(NSString *)eventName;
- (void) fetchActiveEvents;
- (void) areEventsAvailable;
- (void) enroll:(NSString *)userID forEvent:(NSString *)eventName;
- (void) didUser:(NSString *)userID enrollTo:(NSString *)eventName;
- (void) fetchEventName:(NSString *)userID;
- (void) fetchUserName;
@end

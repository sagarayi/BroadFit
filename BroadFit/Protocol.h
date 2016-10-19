//
//  Protocol.h
//  BroadFit
//
//  Created by Radhika Ravindra Kulkarni on 07/10/16.
//  Copyright © 2016 Broadsoft. All rights reserved.
//

#ifndef Protocol_h
#define Protocol_h

@protocol FirebaseOperations <NSObject>

@optional

- (void) signUpWithData:(NSDictionary *)user;
- (void) signInWithData:(NSDictionary *)user;
- (void) fetchMyChallenges:(NSString *)userID;


@end

#endif /* Protocol_h */

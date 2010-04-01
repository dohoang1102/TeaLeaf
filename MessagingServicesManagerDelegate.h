//
//  MessagingServicesManagerDelegate.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 01/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol MessagingServicesManagerDelegate

-(void)receivedMessage:(NSString *)message fromServiceInstanceNamed;

/*
 Implement the MGTwitterEngineDelegate methods, just as the AppController in the demo project does. These are the methods you'll need to implement:
 - (void)requestSucceeded:(NSString *)requestIdentifier; 
 - (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error; 
 - (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)identifier; 
 - (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)identifier; 
 - (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)identifier;
 */

@end

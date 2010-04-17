//
//  MessagingServicesManagerDelegate.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 01/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol MessagingServicesManagerDelegate

-(void)messageSendSucceeded:(NSString *)requestIdentifier;
-(void)messageSendFailed:(NSString *)requestIdentifier withError:(NSError *)error;
-(void)receivedMessage:(NSString *)message fromServiceInstanceNamed:(NSString *)serviceInstanceName;


@end

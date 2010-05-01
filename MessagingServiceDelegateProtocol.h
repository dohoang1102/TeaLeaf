//
//  MessagingServiceDelegateProtocol.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 01/05/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol MessagingServiceDelegateProtocol

-(void)messageSendSucceeded:(NSString *)requestIdentifier;
-(void)messageSendFailed:(NSString *)requestIdentifier withError:(NSError *)error;
-(void)receivedMessage:(NSString *)message fromServiceInstanceNamed:(NSString *)serviceInstanceName;


@end

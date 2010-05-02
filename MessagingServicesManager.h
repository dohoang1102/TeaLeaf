//
//  MessagingServicesManager.h
//  TeaLeaf
//
//  Keeps array of messaging service instances
//		-dispatches messages to them
//		-receives messages from them
//
//
//  Created by Richard Turnbull on 31/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MessagingServiceDelegateProtocol.h"

@class MessagingService;

@interface MessagingServicesManager : NSObject <MessagingServiceDelegateProtocol> {
	
	NSMutableArray							*messagingServices;
	id <MessagingServiceDelegateProtocol>	delegate;

}

@property (assign, nonatomic, readwrite) id <MessagingServiceDelegateProtocol> delegate;
@property (retain, nonatomic, readwrite) NSMutableArray *messagingServices;

-(id)initWithDelegate:(id <MessagingServiceDelegateProtocol>)theDelegate configArray:(NSArray *)configArray;

-(NSArray *)sendTextMessage:(NSString *)messageText;
-(NSString *)sendTextMessage:(NSString *)messageText usingMessagingServiceNamed:(NSString *)serviceName;

-(NSArray *)sendAttachment:(NSData *)attachment;
-(NSString *)sendAttachment:(NSData *)attachment usingMessagingServiceNamed:(NSString *)serviceName;


@end

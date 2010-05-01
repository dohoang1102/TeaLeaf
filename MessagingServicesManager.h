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

@interface MessagingServicesManager : NSObject {
	
	NSMutableArray							*messagingServices;
	id <MessagingServiceDelegateProtocol>	delegate;

}

@property (assign, nonatomic, readwrite) id <MessagingServiceDelegateProtocol> delegate;
@property (retain, nonatomic, readwrite) NSMutableArray *messagingServices;

-(id)initWithDelegate:(id <MessagingServiceDelegateProtocol>)delegate config:(NSArray *)configArray;
-(void)sendAttachment:(NSData *)attachment;
-(void)sendAttachment:(NSData *)attachment usingMessagingService:(MessagingService *)messagingService;
-(void)sendMessageText:(NSString *)messageText;
-(void)sendMessageText:(NSString *)messageText usingMessagingService:(MessagingService *)messagingService;


@end

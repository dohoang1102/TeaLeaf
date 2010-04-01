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
@class MessagingService;


@interface MessagingServicesManager : NSObject {
	
	NSMutableArray	*serviceInstances;
	id				delegate;

}

@property (assign, nonatomic, readwrite) id delegate;
@property (retain, nonatomic, readwrite) NSMutableArray *serviceInstances;


-(id)initWithDelegate:(id)delegate config:(NSDictionary *)configDictionary;
-(void)startServiceInstance:(MessagingService *)serviceInstance;
-(void)stopServiceInstance:(MessagingService *)serviceInstance;
-(void)startAllServiceInstances;
-(void)stopAllServiceInstances;
-(void)sendAttachment:(NSData *)attachment;
-(void)sendAttachment:(NSData *)attachment usingServiceInstance:(MessagingService *)serviceInstance;
-(void)sendMessageText:(NSString *)messageText;
-(void)sendMessageText:(NSString *)messageText usingServiceInstance:(MessagingService *)serviceInstance;


@end

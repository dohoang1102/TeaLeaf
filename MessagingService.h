//
//  MessagingService.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 31/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MessagingServiceDelegateProtocol.h"

//
// Base class for each messaging service (twitter, web, etc)
//

@interface MessagingService : NSObject {
	
	NSDictionary							*configDictionary;
	id <MessagingServiceDelegateProtocol>	delegate;

}
	
@property (copy, nonatomic)		NSDictionary							*configDictionary;
@property (assign, nonatomic)   id <MessagingServiceDelegateProtocol>	delegate;
@property (readonly, nonatomic)	NSString								*serviceName;
@property (readonly, nonatomic)	NSString								*serviceType;

-(id)initWithDelegate:(id <MessagingServiceDelegateProtocol>) aDelegate config:(NSDictionary *)aConfigDictionary;

-(NSString *)sendTextMessage:(NSString *)textMessage;
-(NSString *)sendAttachment:(NSData *)attachment; 

-(NSString *)newRequestID;

@end

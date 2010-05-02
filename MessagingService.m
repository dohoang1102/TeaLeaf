//
//  MessagingService.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 31/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "MessagingService.h"
#import "NSString+UUID.h"
#import	"Globals.h"


@implementation MessagingService
@synthesize configDictionary;
@synthesize delegate;
@dynamic serviceName, serviceType;


-(NSString*)serviceName
{	
	return [[[self.configDictionary objectForKey:serviceNameKey] retain ] autorelease];
}


-(NSString*)serviceType
{
	return [[[self.configDictionary objectForKey:serviceTypeKey] retain ] autorelease];
}

-(id)initWithDelegate:(id <MessagingServiceDelegateProtocol>) aDelegate config:(NSDictionary *)aConfigDictionary;
{
	if (self = [super init]) {
		self.configDictionary = aConfigDictionary;
		//NSLog (@"created service:%@, of type:%@", self.serviceName, self.serviceType);
		self.delegate = aDelegate;
	}
	
	return self;
}

-(void)dealloc
{
	self.configDictionary = nil;
	[super dealloc];
}


-(NSString *)sendTextMessage:(NSString *)textMessage
{
	NSLog(@"Error - sendTextMessage needs to be overidden in a subclass");
	return nil;
}

-(NSString *)sendAttachment:(NSData *)attachment; 
{
	NSLog(@"Error - sendAttachment needs to be overidden in a subclass");
	return nil;
}

-(NSString *)newRequestID
{
	NSString *requestID = [NSString stringWithNewUUID];
	
	NSLog(@"requestID = %@", requestID);
	
	return requestID;
}

@end

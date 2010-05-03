//
//  MessagingServicesManager.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 31/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "MessagingServicesManager.h"
#import "NSString+UUID.h"
#import "MessagingService.h"
#import "Globals.h"

#pragma mark Declare private methods
@interface MessagingServicesManager()

//-(void)create


@end

#pragma mark -

@implementation MessagingServicesManager

@synthesize delegate;
@synthesize messagingServices;



-(id)initWithDelegate:(id <MessagingServiceDelegateProtocol>)theDelegate configArray:(NSArray *)configArray
{
	self = [super init];
	if (!self) {
		return nil;
	}
		
	// set the delegate
	self.delegate = theDelegate;
		
	// create the service instances
	self.messagingServices = [NSMutableArray arrayWithCapacity:1];
	
	// create our Messaging Service instances
	for (NSDictionary *configDictionary in configArray)
	{
		// get type
		NSString *serviceType = [configDictionary valueForKey:serviceTypeKey];
		
		// construct classname
		NSString *className = [serviceType stringByAppendingString:@"MessagingService"];
		
		// get the class itself
		Class theClass = NSClassFromString(className);
		
		MessagingService *messagingService = [[theClass alloc] initWithDelegate:self config:configDictionary];
		
		
		[self.messagingServices addObject:messagingService];
		[messagingService release];
	}
	
	return self;
}

-(void)dealloc
{
	self.delegate = nil;
	self.messagingServices = nil;
		
	[super dealloc];
}



//
// Send the message to all message services and return an array of the request ID's
-(NSArray *)sendTextMessage:(NSString *)messageText
{
	//NSString *requestID;
	NSMutableArray *requestIDs = [[NSMutableArray alloc] initWithCapacity:3];
	for (MessagingService *ms in self.messagingServices)
	{
		NSString *requestID = [ms sendTextMessage:messageText];
		[requestIDs addObject:requestID];
		
	}
	
	return [requestIDs autorelease];
}


-(NSString *)sendTextMessage:(NSString *)messageText usingMessagingServiceNamed:(NSString *)serviceName;
{
	for (MessagingService *ms in self.messagingServices)
	{
		if ([ms.serviceName isEqual:serviceName]) {
			NSString *requestID = [ms sendTextMessage:messageText];
			return requestID;
		}
	}
	NSLog(@"service name:%@ not found", serviceName);
	return nil;
}

-(NSArray *)sendAttachment:(NSData *)attachment
{
	return nil;
}

-(NSString *)sendAttachment:(NSData *)attachment usingMessagingServiceNamed:(NSString *)serviceName
{
	return nil;
}

//
// delegate methods
//
-(void)messageSendSucceeded:(NSString *)requestIdentifier
{
	//NSLog(@"Calling delegate");
	[self.delegate messageSendSucceeded:requestIdentifier];
}

-(void)messageSendFailed:(NSString *)requestIdentifier withError:(NSError *)error 
{	
	[self.delegate messageSendFailed:requestIdentifier withError:error];
}

-(void)receivedMessage:(NSString *)message fromServiceInstanceNamed:(NSString *)serviceInstanceName
{
	[self.delegate receivedMessage:message fromServiceInstanceNamed:serviceInstanceName];
}




@end

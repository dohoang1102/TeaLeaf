//
//  MessagingServicesManager.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 31/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "MessagingServicesManager.h"
#import "NSString+UUID.h"
#import "Globals.h"

#pragma mark Declare private methods
@interface MessagingServicesManager()

-(void)create


@end

#pragma mark -

@implementation MessagingServicesManager

@synthesize delegate;
@synthesize messagingServices;



-(id)initWithDelegate:(id <MessagingServicesManagerDelegate>)delegate config:(NSDictionary *)configArray
{
	if (!self = [super init]) {
		return nil;
	}
		
	// set the delegate
	self.delegate = delegate;
	
	// create the service instances
	self.messagingServices = [NSMutableArray arrayWithCapacity:1];
	
	// create our Messaging Service instances
	for (NSDictionary *d in configArray)
	{
		// get type
		NSString *serviceName = [configDictionary valueForKey:serviceNameKey];
		
		// construct classname
		NSString *className = [serviceType stringByAppendingString:@"MessagingService"];
		
		// get the class itself
		Class *class = NSClassFromString(className);
		
		// make the object, and stick it in the dictionary
		MessagingService *messagingService = [[class alloc] initWithConfig:configDictionary];
		
		[self.messagingServices addObject:messagingService];
		[messagingService release];
	}
}

-(void)dealloc
{
	self.delegate = nil;
	self.messagingServices = nil;
	
	
	[super dealloc];
}


-(void)sendAttachment:(NSData *)attachment
{
}
-(void)sendAttachment:(NSData *)attachment usingMessagingService:(MessagingService *)messagingService
{
}
-(void)sendMessageText:(NSString *)messageText
{
}
-(void)sendMessageText:(NSString *)messageText usingMessagingService:(MessagingService *)messagingService
{
}

@end

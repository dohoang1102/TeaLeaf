//
//  MainController.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 01/04/2010.
//  Copyright 2010 Swandrift Consulting Ltd. All rights reserved.
//

#import "MainController.h"
#import "Globals.h"
#import	"MyLocationManager.h"
#import "MessagingServicesManager.h"
#import "ConfigurationDataManager.h"

//Private methods

@interface MainController ()

-(void)startStopStolenBehaviour;
-(NSArray *)parseMessage:(NSString *)message;

@end


@implementation MainController

@dynamic isStolen, logLocation, takePictures, password;

#pragma mark constructors

-(id)init
{
	if (self = [super init])
	{

		// read in configuration and use it to instantiate msm
		msm = [[MessagingServicesManager alloc] initWithDelegate:self
													 configArray:[ConfigurationDataManager readMessagingConfig]];
		
		// read in state
		state = [[ConfigurationDataManager readPreferences] retain];
		
		// kick off stolen / not stolen behaviour
		[self startStopStolenBehaviour];
		
	}
	
	return self;
}


-(void)dealloc
{
    [locationManager release];
	locationManager = nil;
	
	[msm release];
	msm = nil;
	
	[state release];
	state = nil;
	
	[super dealloc];
}


#pragma mark Accessors

-(BOOL)isStolen
{
	return [[state valueForKey:@"isStolen"] boolValue];
}

-(void)setIsStolen:(BOOL)value
{
	if (self.isStolen != value) {
		[state setObject:[NSNumber numberWithBool:value] forKey:@"isStolen"];
		[ConfigurationDataManager writePreferences:state];
		[self startStopStolenBehaviour];
	}
}

-(BOOL)logLocation
{
	return [[state valueForKey:@"logLocation"] boolValue];
}


-(void)setLogLocation:(BOOL)value
{
	if (self.logLocation != value) {	
		[state setValue:[NSNumber numberWithBool:value] forKey:@"logLocation"];
		[ConfigurationDataManager writePreferences:state];
	}
}


-(BOOL)takePictures
{
	return [[state valueForKey:@"takePictures"]boolValue];
}


-(void)setTakePictures:(BOOL)value
{
	if (self.takePictures != value) {
		[state setValue:[NSNumber numberWithBool:value] forKey:@"takePictures"];
		[ConfigurationDataManager writePreferences:state];
	}
}


-(NSString *)password
{
	return [state valueForKey:passwordKey];
}


//
// Main Event Loop
//
-(void)run
{
	//TODO: need to respond gracefully to SIGTERM
	BOOL runLoopShouldRun = YES;
		
	// runloop
	do
    {
        // Start the run loop but return after each source is handled.
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, YES);
		
		//NSLog(@"RunLoop Result: %d",result);
		
    }
    while (runLoopShouldRun);
}


//
// private methods
//
-(void)startStopStolenBehaviour
{
	if (self.isStolen) {
		locationManager = [[MyLocationManager alloc] initWithDelegate:self];
		NSLog(@"starting stolen behaviour");
	}
	else {
		[locationManager release];
		locationManager = nil;
		NSLog(@"stopping stolen behaviour");
	}

}


//
// takes a string and returens all the words in an array
//
-(NSArray *)parseMessage:(NSString *)message
{
	NSMutableArray *words = [NSMutableArray arrayWithCapacity:3];
	NSCharacterSet *spaces = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSString *word;
	
	// Get all words in the message in an array
	
	NSScanner *scanner = [NSScanner scannerWithString:message];
	
	[scanner setCharactersToBeSkipped:spaces];
	
	while (![scanner isAtEnd]) {
		[scanner scanUpToCharactersFromSet:spaces intoString:&word];
		NSLog(@"word: |%@|", word);
		[words addObject:word];
	}
	
	if ([words count])
	{
		return words;
	}
	else
	{
		return nil;
	}	
}

#pragma mark Delegate methods

-(void)messageSendSucceeded:(NSString *)requestIdentifier
{
	NSLog (@"messageSendSucceeded, Request ID:%@", requestIdentifier);
	
}


-(void)messageSendFailed:(NSString *)requestIdentifier withError:(NSError *)error
{
	NSLog(@"Message send failed (Request ID:%@). Error:%@", requestIdentifier, error);
}


-(void)receivedMessage:(NSString *)message fromServiceInstanceNamed:(NSString *)serviceInstanceName
{
	
	NSLog(@"received message:|%@| from service instance %@", message, serviceInstanceName);
	
	// parse
	NSMutableArray *words = [NSMutableArray arrayWithArray:[self parseMessage:message]];
	
	// do nothing if now words returned
	if (!words)
	{
		return;
	}
	
	// do we have a password?
	NSInteger passwordIndex = [words indexOfObject:[self password]];
							   
	if (passwordIndex == NSNotFound)
	{
		NSLog(@"Incorrect or missing password. No action taken");
		return;
	}
							   
	// we will only consider the word just after the password so we remove from array, and check the first object

	[words removeObjectAtIndex:passwordIndex];
	
	if ([words count] < 1)
	{		
		NSLog (@"No keyword supplied. No action taken %d", [words count]);
		return;
	}
	
	NSString *actionKeyword = [words objectAtIndex:0];
	
	// check stolen
	if ([actionKeyword isEqualToString:stolenKeyword])
	{
		NSLog(@"we have just be told we are stolen");
		self.isStolen = YES;
	}
	else
	{
		NSLog(@"no valid keyword supplied. No action taken");
	}
			
}


-(void)locationDidChange:(NSString *)location
{
	NSArray *requestIDs = [msm sendTextMessage:location];
	
	NSLog (@"Sending location change:%@, request ID's:%@", location, requestIDs);
}


@end

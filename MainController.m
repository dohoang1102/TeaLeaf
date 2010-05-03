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

@end


@implementation MainController

@dynamic isStolen, logLocation, takePictures;


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
	}
	else {
		[locationManager release];
		locationManager = nil;
	}

}

//
// delegate methods:
//
-(void)messageSendSucceeded:(NSString *)requestIdentifier
{
	NSLog (@"messageSendSucceeded, requestID:%@", requestIdentifier);
	
}

-(void)messageSendFailed:(NSString *)requestIdentifier withError:(NSError *)error
{
}

-(void)receivedMessage:(NSString *)message fromServiceInstanceNamed:(NSString *)serviceInstanceName
{
	NSLog(@"received message:%@ from service instance %@", message, serviceInstanceName);
	
	
	// parse message
	
	// is it a state change?
	
	
}

-(void)locationDidChange:(NSString *)location
{
	NSArray *requestIDs = [msm sendTextMessage:location];
	
	NSLog (@"Sending location change:%@, request ID's:%@", location, requestIDs);
	
}




@end

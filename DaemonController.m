//
//  DaemonController.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 10/01/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//


// TO DO
// Signal handlers so we can restart etc
// Own log file
// proper root access

// NEXT STEP
// get it to respond to stolen message and report as such by posting normal messages to twitter

#import "DaemonController.h"
#import	"MGTwitterEngine.h"
#import	"ConfigurationFileManager.h"
#import "Globals.h"

//private methods
#pragma mark private methods
@interface DaemonController()
-(void)installDirectMessagesTimer;
-(void)parseTwitterDirectMessage:(NSString *)message;
-(void)invokeStolenMode;
@end
#pragma mark -


@implementation DaemonController

#pragma mark constructors, destructors, getters, setters
- (id) init
{
	self = [super init];
	if (self != nil) {
		twitter = [[MGTwitterEngine alloc] initWithDelegate:self];		// get a twitter instance
		configuration = [[ConfigurationFileManager alloc] init];		// get the configuration
		
	}
	return self;
}


- (void) dealloc
{
	[twitter dealloc];
	[configuration dealloc];
	[super dealloc];
	
}

#pragma mark configuration and execution

-(void)configure
{
	
	
	//set username and password for twitter
	[twitter setUsername:configuration.twitterUsername password:configuration.twitterPassword];
	
	// install timer which will check for direct messages
	[self installDirectMessagesTimer];
	
	// if we are stolen, then we must behave as such
	if (configuration.isStolen)
	{
		[self invokeStolenMode];
	}
	
}

// Sets up runloop to run for 10 seconds, drains pool, and restarts if all ok

-(void)run
{
	runLoopShouldRun = YES;	
	
	// runloop
	do
    {
		// Set up an autorelease pool 
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
        // Start the run loop but return after each source is handled.
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, YES);
		
		//NSLog(@"RunLoop Result: %d",result);
		[pool drain];
		
    }
    while (runLoopShouldRun);
	
}

#pragma mark Timer Callbacks

// Callback for checkForTwitterDirectMessagesTimer.
-(void)checkForDirectMessages:(NSTimer *)timer
{
	NSLog(@"checking for direct messages");
	
	NSString *requestID = [twitter getDirectMessagesSinceID:0 startingAtPage:0];
	
	NSLog(@"requestID: %@", requestID);
	
}

-(void)tasksWhenStolen:(NSTimer *)timer
{
	// TO DO - finish
	
	/*
	 get current IP
		log
		tweet
	 
	 get current location
		log
		tweet
	 
	 Take a photo
		log
		tweet
		
	 
	 */
	
	// TO DO for now, we just tweet
	
	
}


#pragma mark twitter delegate methods
- (void)requestSucceeded:(NSString *)requestIdentifier
{
	NSLog(@"request: %@ succeeded", requestIdentifier);
}

- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error
{
	NSLog(@"requestFailed:%@ withError:%@", requestIdentifier, error);
}


- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)identifier 
{
	//	NSLog(@"statusesReceived:%@ forRequest:%@", statuses, identifier);
	//	NSLog(@"statusesReceived: forRequest:");	
}


- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)identifier
{	
	// if no messages received then do nothing (unlikely);
	if (![messages count])
	{
		NSLog(@"in directMessagesReceived, but no messages. doing nothing." );
		return;
	}

	// only the last message is important
	// need to extract the last direct message posted (max id)
	long long	latestMessageID = -1;
	int			currentMessageID;
	int			latestMessageIndex = -1;
		
	for (NSDictionary *message in messages)
	{
		currentMessageID = [[message valueForKey:@"id"] longLongValue];
		if (currentMessageID > latestMessageID)
		{
			latestMessageID = currentMessageID;
			latestMessageIndex = [messages indexOfObject:message];
		}
	}
	NSDictionary *lastMessage = [messages objectAtIndex:latestMessageIndex];
	
	// Extract the text of this message
	NSString *messageText = [lastMessage valueForKey:@"text"];
	
	// parse the message	
	[self parseTwitterDirectMessage:messageText];
	
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)identifier
{
	NSLog(@"userInfoReceived:%@ forRequest:%@", userInfo ,identifier);
}


#pragma mark private methods

// first check we have an authentic message.
// then update relevent state variables based on keywords
-(void)parseTwitterDirectMessage:(NSString *)messageText
{
	NSRange range = {0,0};
	
	// is the authentication keyword here?
	range = [messageText rangeOfString:configuration.directMessageKeyword];
	if (range.location != NSNotFound)
	{
		NSLog(@"auth keyword found. we can act on command");
	}
	else {
		NSLog(@"auth keyword not found. ignoring");
		return;                                     // do nothing
	}
	
	// check for keyword "stolen"
	range = [messageText rangeOfString:kRBTStolenKeyword options:NSCaseInsensitiveSearch];
	if (range.location != NSNotFound)
	{
		if (configuration.isStolen)
		{
			NSLog(@"Already in stolen mode. Doing nothing");
		} else 
		{
			NSLog(@"We are stolen. Invoking Stolen Mode");
			
			// needs to be persistant, so save this
			configuration.isStolen = YES;
			[configuration save];
			[self invokeStolenMode];
		}

		
	}
}

// Find out how often we should check for private messages, 
// then intall a timer firing at this interval
// TODO - make this re-entrant
-(void)installDirectMessagesTimer
{
	
	checkForTwitterDirectMessagesTimer = [NSTimer scheduledTimerWithTimeInterval:configuration.timeIntervalToCheck
																		  target:self 
																		selector:@selector(checkForDirectMessages:) 
																		userInfo:nil 
																		 repeats:YES];
	
	
	[[NSRunLoop currentRunLoop] addTimer:checkForTwitterDirectMessagesTimer forMode:NSDefaultRunLoopMode];
	
}

-(void)invokeStolenMode
{
	
	// stolen mode needs to be persistant, so 
	// install a new timer

}
		
	
	
@end

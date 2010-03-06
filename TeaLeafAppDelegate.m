//
//  TeaLeafAppDelegate.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 10/01/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "TeaLeafAppDelegate.h"
#import "ConfigurationFileManager.h"
#import "Globals.h"


@implementation TeaLeafAppDelegate

@synthesize window;
@synthesize twitterUsernameField;
@synthesize twitterPasswordField;
@synthesize directMessageKeywordField;
@synthesize timeIntervalToCheckField;
@synthesize configurationFileManager;
@synthesize isStolenCheckBox;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSLog(@"in applicationDidFinishLaunching");
	
	// Get the configuration
	self.configurationFileManager = [[ConfigurationFileManager alloc] init];
	
	// populate the text fields
	[self.twitterUsernameField setStringValue:self.configurationFileManager.twitterUsername];
	[self.twitterPasswordField setStringValue:self.configurationFileManager.twitterPassword];
	[self.directMessageKeywordField setStringValue:self.configurationFileManager.directMessageKeyword];
	[self.timeIntervalToCheckField setIntValue:self.configurationFileManager.timeIntervalToCheck];
	
	[self.isStolenCheckBox setState:(self.configurationFileManager.isStolen ? NSOnState : NSOffState)];

	
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
	[self save:nil];  // hacky - change this
}

-(void)dealloc
{
	self.configurationFileManager = nil;
	[super dealloc];
}


-(IBAction)save:(NSButton *)sender
{
	self.configurationFileManager.twitterUsername = [self.twitterUsernameField stringValue];
	self.configurationFileManager.twitterPassword = [self.twitterPasswordField stringValue];
	self.configurationFileManager.directMessageKeyword = [self.directMessageKeywordField stringValue];
	self.configurationFileManager.timeIntervalToCheck = [self.timeIntervalToCheckField intValue];
	
	if (NSOnState == [self.isStolenCheckBox state]) {
		NSLog (@"on");
		self.configurationFileManager.isStolen = YES;
	} else {
		NSLog(@"off");
		self.configurationFileManager.isStolen = NO;
	}

	
	[self.configurationFileManager save];
}
@end

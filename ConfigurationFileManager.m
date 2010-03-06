//
//  ConfigurationFileManager.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 10/01/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "ConfigurationFileManager.h"
#import "Globals.h"


@implementation ConfigurationFileManager



@synthesize twitterUsername;
@synthesize twitterPassword;
@synthesize directMessageKeyword;
@synthesize timeIntervalToCheck;
@synthesize isStolen;

// returns a URL of the configuration directory
-(NSURL *)configurationDirectoryURL
{
	NSFileManager *fm = [NSFileManager defaultManager];	
	
	// Get application support directory
	NSURL *URL =  [fm URLForDirectory:NSApplicationSupportDirectory 
							 inDomain:NSLocalDomainMask
					appropriateForURL:nil
							   create:NO
								error:NULL];
	
	// Add the applicatin specifion file component, and the file name
	URL = [URL URLByAppendingPathComponent:kRBTApplicationSupportDirectory];
	
	return URL;
}

// returns a URL of the configuration file
-(NSURL *)configurationFileURL
{
	NSURL *URL = [[self configurationDirectoryURL] URLByAppendingPathComponent:kRBTConfigurationFile];
	
	return URL;
}


// returns a dictionary with the contents of the config file
-(NSDictionary *)configurationFileAsDictionary
{
	return [NSDictionary dictionaryWithContentsOfURL:[self configurationFileURL]];
}


-(id)init
{
	if (self == [super init])
	{
		
		// Get the URL of the configuration as a string
		NSString *URLPath = [[self configurationFileURL] path];
		
		// Does this file exist? if yes, then populate the properties, else fill with defaults
		NSFileManager *fm = [NSFileManager defaultManager];
		if ([fm fileExistsAtPath:URLPath])
		{
			NSDictionary *dict = [self configurationFileAsDictionary];
			self.twitterUsername		= [dict valueForKey:kRBTTwitterUsernameKey];
			self.twitterPassword		= [dict valueForKey:kRBTTwitterPasswordKey];
			self.timeIntervalToCheck	= [[dict valueForKey:kRBTTimeIntervalToCheckKey] intValue];
			self.directMessageKeyword	= [dict valueForKey:kRBTDirectMessageKeywordKey];
			self.isStolen				= [[dict valueForKey:kRBTIsStolenKey] boolValue];
		} 
		else {
			self.twitterUsername = @"<enter name>";
			self.twitterPassword = @"<enter password";
			self.timeIntervalToCheck = 1;
			self.directMessageKeyword = @"<enter passcode>";
			self.isStolen = NO;
		}
	}
	return self;
}
-(void)dealloc
{
	self.twitterUsername = nil;
	self.twitterPassword = nil;
	self.directMessageKeyword = nil;
	
	[super dealloc];
}

-(void)load
{
}

-(void)save
{

	// Does the configuration directory exist ? if not then create.
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *appSupportDir = [[self configurationDirectoryURL] path];
	
	if (![fm fileExistsAtPath:appSupportDir]) 
	{
		// Create it
		NSError *error;
		if (![fm createDirectoryAtPath:appSupportDir withIntermediateDirectories:YES attributes:nil error:&error ]) 
		{
			NSLog(@"Failed to create app support directory:%@", error);

		}
	}
	
	// Create a dictionary from the properties and write to file
	NSMutableDictionary  *dict = [NSMutableDictionary dictionaryWithCapacity:4];
	[dict setObject:self.twitterUsername forKey:kRBTTwitterUsernameKey];
	[dict setObject:self.twitterPassword forKey:kRBTTwitterPasswordKey];
	[dict setObject:self.directMessageKeyword forKey:kRBTDirectMessageKeywordKey];
	[dict setObject:[NSNumber numberWithInt:self.timeIntervalToCheck] forKey:kRBTTimeIntervalToCheckKey];
	[dict setObject:[NSNumber numberWithBool:self.isStolen] forKey:kRBTIsStolenKey];
	
	[dict writeToURL:[self configurationFileURL] atomically:YES];
			
}



@end

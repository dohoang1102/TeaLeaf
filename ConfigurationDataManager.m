//
//  ConfigurationDataManager.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 03/05/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "ConfigurationDataManager.h"


@implementation ConfigurationDataManager

//
// supplies some default preferences if no file found
//

//
// returns a URL of the configuration directory
//
+(NSURL *)configurationDirectoryURL
{
	NSFileManager *fm = [NSFileManager defaultManager];	
	
	// Get application support directory
	NSURL *URL =  [fm URLForDirectory:NSApplicationSupportDirectory 
							 inDomain:NSLocalDomainMask
					appropriateForURL:nil
							   create:NO
								error:NULL];
	
	
	// Add the application specifion file component, and the file name
	URL = [URL URLByAppendingPathComponent:@"TeaLeaf"];
	NSString *path = [URL path];
	
	if (![fm fileExistsAtPath:path]) 
	{
		// Create it
		NSError *error;
		//TODO:  Errorcheck should throw an alert box
		if (![fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error ]) 
		{
			NSLog(@"Failed to create app support directory:%@", error);
			
		}
	}
	
	
	return URL;
}

//
// returns a URL of the configuration file
//
+(NSURL *)configurationFileURL
{
	NSURL *URL = [[self configurationDirectoryURL] URLByAppendingPathComponent:@"MessagingConfig.plist"];
	
	return URL;
}

// returns a URL of the configuration file
+(NSURL *)preferencesFileURL
{
	NSURL *URL = [[self configurationDirectoryURL] URLByAppendingPathComponent:@"Prefs.plist"];
	
	return URL;
}


+(NSMutableDictionary *)defaultPreferences
{
	
	NSNumber *yes = [NSNumber numberWithBool:YES];
	NSNumber *no = [NSNumber numberWithBool:NO];
	NSMutableDictionary *d = [NSMutableDictionary dictionaryWithObjectsAndKeys:no, @"isStolen", 
							  yes, @"logLocation", 
							  yes, @"takePictures", 
							  nil];
	return d;						  
	
}



//
// returns the preferences as an autoreleased Mutable Dictionary, or defaults if no config file found
//
+(NSMutableDictionary *)readPreferences;
{
	//TODO: error checking
	NSMutableDictionary *d = [NSMutableDictionary dictionaryWithContentsOfURL:[self preferencesFileURL]];
	if (d == nil) {
		NSLog(@"no preferences file");
		d = [self defaultPreferences];
	}
	return d;
}

+(NSMutableArray *)readMessagingConfig;
{
	// read configuration from the MessagingConfig.plist
	NSMutableArray *configArray = [NSArray arrayWithContentsOfURL:[self configurationFileURL]];
	//TODO: error checking
	
	//NSLog(@"loaded array:%@", configArray);
	
	return configArray;
	
}	


+(BOOL)writePreferences:(NSDictionary *)preferencesDictionary
{
	NSURL *url = [self preferencesFileURL];
	BOOL success = [preferencesDictionary writeToURL:url atomically:YES];
	
	//TODO: better error checking - need sheet
	if (success) {
		NSLog(@"App preferences written to :%@", [url path]);
	}
	else {
		NSLog(@"error writing preferencences file");
	}
	return success;
}

+(BOOL)writeMessagingConfig:(NSArray *)configArray
{
	
	//TODO: check return values and throwe error if NO 
	
	BOOL success = [configArray writeToURL:[self configurationFileURL] atomically:YES];
	if (success) {
		NSLog(@"App configuration written to :%@", [[self configurationFileURL] path]);
	}
	else {
		NSLog(@"error writing config file");
	}
	
	return success;
}




@end

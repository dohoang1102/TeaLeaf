//
//  ServiceConfigController.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 19/03/2010.
//  Copyright 2010 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "ServiceConfigController.h"
#import "Globals.h"

@implementation ServiceConfigController

@synthesize configDictionary;
@synthesize readDirectoryTextField;
@synthesize	sendDirectoryTextField;
@synthesize objectController;

@dynamic	serviceName, serviceType;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (![super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
		return nil;
	
	self.configDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
	
	return self;
}

-(id)init
{
	NSLog(@"init needs to be overidden in a subclass. return nil");
	return nil;
}

-(void)dealloc
{
	self.configDictionary = nil;
	[super dealloc];
}

-(void)setServiceName:(NSString *)aServiceName
{
	NSLog(@"setting service name to %@", aServiceName);	
	if ([aServiceName isEqual:nil]) {
		[self.configDictionary setNilValueForKey:serviceNameKey];
	}
	else {
		[self.configDictionary setObject:aServiceName forKey:serviceNameKey];
	}
}

-(NSString*)serviceName
{

	return [[[self.configDictionary objectForKey:serviceNameKey] retain ] autorelease];
}
	
-(void)setServiceType:(NSString *)aServiceType
{
	NSLog(@"setting service type to %@", aServiceType);	
	if ([aServiceType isEqual:nil]) {
		[self.configDictionary setNilValueForKey:serviceTypeKey];
	}
	else {
		[self.configDictionary setObject:aServiceType forKey:serviceTypeKey];
	}
}

-(NSString*)serviceType
{
	
	return [[[self.configDictionary objectForKey:serviceTypeKey] retain ] autorelease];
}


//-(IBAction)chooseReadDirectory:
//{
//	
//}
//-(IBAction)chooseSendDirectory:(NSButton *)sender;

-(IBAction)chooseDirectory:(NSButton *)sender;
{
	// 1 is the read from dir, 2 is the send to dir
	
	// get a chooser box and configure
	NSOpenPanel *panel = [NSOpenPanel openPanel];

	[panel setAllowsMultipleSelection:NO];
	[panel setCanChooseFiles:NO];
	[panel setCanChooseDirectories:YES];
	NSInteger result = [panel runModal];
	
	if (result == NSOKButton)  {
		
		
		NSURL *chosenDirectory = [[panel URLs] objectAtIndex:0];
		
		
		// 1 is the read from dir, 2 is the send to dir
		switch ([sender tag]) {
		case 1:
				
				//[self.readDirectoryTextField setStringValue:[chosenDirectory path]];
				// set the configDictionary. th user interface fields are bound to it
				[self.configDictionary setObject:[chosenDirectory path] forKey:directoryToReadFromKey];
				
			break;
		case 2:
				//[self.sendDirectoryTextField setStringValue:[chosenDirectory path]];
				[self.configDictionary setObject:[chosenDirectory path] forKey:directoryToSendToKey];

			break;
			
		default:
			NSLog(@"unkown control - am expecting a choose button");
			break;
		}
	}
	
}

@end

//
//  TeaLeafAppDelegate.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 10/01/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "TeaLeafAppDelegate.h"

@interface TeaLeafAppDelegate(PrivateMethods)

-(void)createNewConfigView:(NSString *) serviceName type:(NSString *)type;

@end


@implementation TeaLeafAppDelegate

@synthesize window;
@synthesize daemonStartButton;
@synthesize viewBox;
@synthesize serviceConfigViews;
@synthesize messagingConfig;
@synthesize newConfigViewSheet;
@synthesize serviceTypePopup;
@synthesize serviceNameField;
@synthesize serviceTypes;




- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSLog(@"in applicationDidFinishLaunching");
	
	
	// load all the service types from a plist in the bundle and stick in an array
	NSBundle *thisBundle = [NSBundle mainBundle];
	NSURL *serviceTypesURL = [thisBundle URLForResource:@"ServiceTypes" withExtension:@"plist"];	
	self.serviceTypes = [NSArray arrayWithContentsOfURL:serviceTypesURL];	
	NSLog(@"serviceTypes=%@",self.serviceTypes);
	
	
	// register for notification when the selection changes in the table
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self 
		   selector:@selector(configViewTableSelectionChanged:) 
			   name:NSTableViewSelectionDidChangeNotification
			 object:self];
	
	// read configuration from the MessagingConfig.plist file into the messagingConfig array
	
	// loop this array. Instantiate a viewCntroller of the correct type,
	// from the config, we set the config dictionary
	// and display it in the box
	
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	self.serviceTypes=nil;
}

-(void)dealloc
{
	
	[super dealloc];
}


#pragma mark add and remove views
-(IBAction)addView:(id)sender 
{
	// drop the panel asking for a name, and a type
	// instantiate a view
	// add it to the array, release it
	// add it to the box
	
	[NSApp beginSheet:self.newConfigViewSheet
	   modalForWindow:self.window 
		modalDelegate:nil
	   didEndSelector:NULL
		  contextInfo:NULL];
	
	
}
								
// called when a button in the newConfigView is pressed
-(IBAction)stopSheet:(NSButton *)whichButton
{
	
	

	
	if ([[whichButton title] isEqualToString:@"Create"]) {
		[self createNewConfigView:[self.serviceNameField stringValue] 
							 type:[self.serviceTypePopup titleOfSelectedItem]]; 
	} 
	else if ([[whichButton title] isEqualToString:@"Cancel"]) {
			NSLog(@"Cancel button pressed from sheet");
	}
	else {
		NSLog (@"something odd happened");
	}

	[self.newConfigViewSheet orderOut:self];
	[NSApp endSheet:self.newConfigViewSheet];
		
}


-(IBAction)removeView:(id)sender 
{
	
}
	

-(void)configViewTableSelectionChanged:(NSNotification *)note
{
	// swap out the views
	
}

-(IBAction)apply:(id)sender
{
	// save changes to config file
}


-(IBAction)revert:(id)sender
{
}

-(IBAction)close:(NSButton *)sender {}

#pragma mark configViewTable datasource methods;

-(id)tableView:(NSTableView *)aTableView
	objectValueForTableColumn:(NSTableColumn *)aTableColumn
	row:(NSInteger)rowIndex
{
	return [serviceConfigViews objectAtIndex:rowIndex];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [self.serviceConfigViews count];
} 

#pragma mark NSApplication delegate methods

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)app
{
	return YES;
}

#pragma mark NSApplication private methods

-(void)createNewConfigView:(NSString *) serviceName type:(NSString *)type
{
	NSLog(@"will create a view named: %@ of type: %@", serviceName, type);
}

@end

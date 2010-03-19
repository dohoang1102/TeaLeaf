//
//  TeaLeafAppDelegate.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 10/01/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "TeaLeafAppDelegate.h"
#import "ManagingServiceConfigController.h"



@interface TeaLeafAppDelegate(PrivateMethods)

-(void)createServiceConfigView:(NSString *) serviceName type:(NSString *)type;

@end


@implementation TeaLeafAppDelegate

@synthesize window;
@synthesize daemonStartButton;
@synthesize viewBox;
@synthesize serviceConfigControllers;
@synthesize messagingConfig;
@synthesize servicesTable;
@synthesize newConfigViewSheet;
@synthesize serviceTypePopup;
@synthesize serviceNameField;
@synthesize serviceTypes;




- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	//NSLog(@"in applicationDidFinishLaunching");
	
	// do some initialization
	self.serviceConfigControllers = [NSMutableArray arrayWithCapacity:10];
	
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
	self.serviceTypes = nil;
	self.serviceConfigControllers = nil;
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
		[self createServiceConfigView:[self.serviceNameField stringValue] 
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
	NSLog(@"in tableView:objectValue...blah");
	// Not sure if we can do this: we actually have a subclass of
	// NSViewController
	ManagingServiceConfigController *service = [self.serviceConfigControllers objectAtIndex:rowIndex];
	
	return [service serviceName];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	NSInteger count = [self.serviceConfigControllers count];
	NSLog(@"no of rows:%i",count);
    return count;
} 

#pragma mark NSApplication delegate methods

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)app
{
	return YES;
}

#pragma mark NSApplication private methods

-(void)createServiceConfigView:(NSString *) serviceName type:(NSString *)type
{
	NSLog(@"will create a view controller named: %@ of type: %@", serviceName, type);
	
	// instantiates a new view controller.
	
	// if service type = '`type', then the class name is 
	// 'TypeServiceConfigController'
	NSString *className = [NSString stringWithString:@"ServiceConfigController"];
	NSString *viewControllerName = [type stringByAppendingString:className];

	Class vcClass = NSClassFromString(viewControllerName);
	
	ManagingServiceConfigController *vc = [[vcClass alloc] init];
	
	// TO DO error check	
	vc.serviceName = serviceName;
	
	NSLog(@"vc: %@", [vc description]);
	
	// put it into the array
	
	[self.serviceConfigControllers addObject:vc];
	[vc release];
	
	NSLog(@"vc array: %@", self.serviceConfigControllers);
	
	// and update the table
	[self.servicesTable reloadData];
	
}

@end

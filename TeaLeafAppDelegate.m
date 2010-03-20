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
-(void)destroyServiceConfigView:(NSUInteger)index;
-(void)displayViewController:(ManagingServiceConfigController*)viewController;
-(void)dumpDictionaryOfCurrentlySelectedController;


@end


@implementation TeaLeafAppDelegate

@synthesize window;
@synthesize daemonStartButton;
@synthesize viewBox;
@synthesize serviceConfigControllers;
@synthesize messagingConfig;
@synthesize servicesTable;
@synthesize removeButton;
@synthesize newConfigViewSheet;
@synthesize serviceTypePopup;
@synthesize serviceNameField;
//@synthesize arrayController;
@synthesize serviceTypes;
@synthesize currentConfigController;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	//NSLog(@"in applicationDidFinishLaunching");
	
	// do some initialization
	self.serviceConfigControllers = [NSMutableArray arrayWithCapacity:10];
	
	// load all the service types from a plist in the bundle and stick in an array
	NSBundle *thisBundle = [NSBundle mainBundle];
	NSURL *serviceTypesURL = [thisBundle URLForResource:@"ServiceTypes" withExtension:@"plist"];	
	self.serviceTypes = [NSArray arrayWithContentsOfURL:serviceTypesURL];		
	
	// register for notification when the selection changes in the table
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self 
		   selector:@selector(configViewTableSelectionChanged:) 
			   name:NSTableViewSelectionDidChangeNotification
			 object:nil];
	
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

	//TODO: validate name against existing names 
	[self.newConfigViewSheet orderOut:self];
	[NSApp endSheet:self.newConfigViewSheet];
	
	// clear out the name field in the sheet
	[self.serviceNameField setStringValue:@""];
		
}


-(IBAction)removeView:(id)sender 
{
	
	// get the currently selected item
	NSUInteger index = [self.servicesTable selectedRow];
	NSLog(@"tableviewselected index: %qu", index);
	[self destroyServiceConfigView:index];
	
}

// Notification method called by servicesTable when selection changed
-(void)configViewTableSelectionChanged:(NSNotification *)notification
{
	
	//TODO: ERROR CHECK
	NSInteger selectedItemIndex = [self.servicesTable selectedRow];
	
	NSLog(@"in note, selection index=%d", (int)selectedItemIndex);
	
    if (selectedItemIndex == -1) {
		[self displayViewController:nil];
	}
	else {
		// Get the associated view
		ManagingServiceConfigController *managingSCC = [self.serviceConfigControllers objectAtIndex:selectedItemIndex];
		
		[self displayViewController:managingSCC];
		
	}

	// set the status of the add button
	if ([self.serviceConfigControllers count] == 0) {
		[self.removeButton setEnabled:NO];
	} 
	else {
		[self.removeButton setEnabled:YES];
	}
		
}

-(IBAction)apply:(id)sender
{
	[self dumpDictionaryOfCurrentlySelectedController];
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
	ManagingServiceConfigController *service = [self.serviceConfigControllers objectAtIndex:rowIndex];
	
	return [service serviceName];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	NSInteger count = [self.serviceConfigControllers count];
    return count;
} 

#pragma mark NSApplication delegate methods

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)app
{
	return YES;
}

#pragma mark NSApplication private methods

// instantiates a new view controller and puts in into the array iVar
-(void)createServiceConfigView:(NSString *) serviceName type:(NSString *)type
{
	
	// if service type = '`type', then the class name is 'TypeServiceConfigController'
	NSString *className = [NSString stringWithString:@"ServiceConfigController"];
	NSString *viewControllerName = [type stringByAppendingString:className];

	Class vcClass = NSClassFromString(viewControllerName);
	
	ManagingServiceConfigController *vc = [[vcClass alloc] init];
	
	//TODO: error check	
	vc.serviceName = serviceName;
		
	// put it into the array
	[self.serviceConfigControllers addObject:vc];
	[vc release];
		
	// and update the tableView
	[self.servicesTable reloadData];
	
	// make the table view select this last item.
	// will kick off an NSTableViewSelectionDidChangeNotification for us, 
	// which we will use to load the view into the box
	NSUInteger index = [self.serviceConfigControllers count] - 1;
	NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
	[self.servicesTable selectRowIndexes:indexSet byExtendingSelection:NO];
	
	//NSLog(@"create: array is now:%@", self.serviceConfigControllers);
}

// destroys an existing view controller, and reomves from the array
-(void)destroyServiceConfigView:(NSUInteger)index
{
	// remove from the array
	//NSLog(@"removing object at index %qu", index);
	[self.serviceConfigControllers removeObjectAtIndex:index];
	
	//NSLog(@"destroy: array is now:%@", self.serviceConfigControllers);
	
	[self.servicesTable reloadData];
	
	
}

// set the box's view this one
-(void)displayViewController:(ManagingServiceConfigController*)viewController
{
	NSLog (@"displaying view controller:%@", viewController);
	NSView *view = [viewController view];
	
	[self.viewBox setContentView:view];
	
	// set the currentclyViewController iVar	
	self.currentConfigController = viewController;

}
// for debug - dumps the config dict of the currently selected controller view;

-(void)dumpDictionaryOfCurrentlySelectedController
{
	NSDictionary *c = self.currentConfigController.configDictionary;
	NSLog(@"currentConfigDictionary:%@", c);
	
	
}
@end

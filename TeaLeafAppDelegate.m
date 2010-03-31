//
//  TeaLeafAppDelegate.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 10/01/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "TeaLeafAppDelegate.h"
#import "ManagingServiceConfigController.h"
#import	"PreferencesController.h"


@interface TeaLeafAppDelegate(PrivateMethods)

-(void)createServiceConfigView:(NSString *) serviceName type:(NSString *)type config:(NSMutableDictionary *)configDict;
-(void)destroyServiceConfigView:(NSUInteger)index;
-(void)displayViewController:(ManagingServiceConfigController*)viewController;
-(NSURL *)configurationDirectoryURL;
-(NSURL *)configurationFileURL;
-(NSURL *)preferencesFileURL;
-(NSMutableDictionary *)defaultPreferences;
-(void)writeConfiguration;
-(void)writeMessagingConfig;
-(void)writePreferences;

-(void)readConfiguration;
-(void)readPreferences;
-(void)readMessagingConfig;

@end


@implementation TeaLeafAppDelegate

@synthesize window;
@synthesize daemonStartButton;
@synthesize viewBox;
@synthesize serviceConfigControllers;
//@synthesize messagingConfig;
@synthesize servicesTable;
@synthesize removeButton;
@synthesize newConfigViewSheet;
@synthesize serviceTypePopup;
@synthesize serviceNameField;
//@synthesize arrayController;
@synthesize preferencesController;
@synthesize preferencesDictionary;
@synthesize serviceTypes;


//@synthesize currentConfigController;

-(id)init
{
	// do some initialization
	if (self = [super init]) {
		self.serviceConfigControllers = [NSMutableArray arrayWithCapacity:1];
		//self.preferencesDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
	}
	
	return self;
}	


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	//NSLog(@"in applicationDidFinishLaunching");
		
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
	
	[self readConfiguration];
	
		
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
	// write to file
	[self writeConfiguration];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
}

-(void)dealloc
{
	self.serviceTypes = nil;
	self.serviceConfigControllers = nil;
	self.preferencesController = nil;
	self.preferencesDictionary = nil;
	
	[super dealloc];
}


#pragma IBAction methods
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
								 type:[self.serviceTypePopup titleOfSelectedItem] 
							   config:nil]; 
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

-(IBAction)apply:(id)sender
{
	[self writeConfiguration];
	// save changes to config file
}


-(IBAction)showPreferences:(id)sender
{
	// lazy load the PreferencesController
	if (!self.preferencesController) {
		PreferencesController *pC = [[PreferencesController alloc] init];
		self.preferencesController =  pC;
		[pC release];
		// We have a dictionary (self.preferencesDictionary), and so does the config controller.
		// The config controller will be responsible for maintaining this.
		// the setter method in the Prefs Controller has option (retain) 
		// So actually, we can simply give it our version, and it is the same object in both self, and prefs controller
		self.preferencesController.preferencesDictionary = self.preferencesDictionary;
	}

	[self.preferencesController showWindow:self];
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



- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	NSInteger count = [self.serviceConfigControllers count];
    return count;
} 

#pragma mark NSApplication delegate methods
//TODO: this work, but when the last windo is close, it does not call the applicationWillTerminate
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)app
{
	return YES;
}

#pragma mark NSApplication private methods

// instantiates a new view controller and puts in into the array iVar
// if a config Dictionary is passed, then initilize with it. otherwise (nill passwd)
// we just set the name.
-(void)createServiceConfigView:(NSString *) serviceName type:(NSString *)type config:(NSMutableDictionary *)configDict 
{
	
	// if service type = '`type', then the class name is 'TypeServiceConfigController'
	NSString *className = [NSString stringWithString:@"ServiceConfigController"];
	NSString *viewControllerName = [type stringByAppendingString:className];

	Class vcClass = NSClassFromString(viewControllerName);
	
	ManagingServiceConfigController *vc = [[vcClass alloc] init];
	
	//TODO: error check	
	// Initialise with ready made confif if we have some. otherwise, just set the name.
	
	if (configDict) {
		vc.configDictionary = configDict;
	} else {
		vc.serviceName = serviceName;
	}

		
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
	//self.currentConfigController = viewController;

}

-(void)readConfiguration
{
	[self readPreferences];
	[self readMessagingConfig];
}

//TODO: This needs reading from a plist in the app main bundle
-(NSMutableDictionary *)defaultPreferences
{
	
	NSNumber *yes = [NSNumber numberWithBool:YES];
	NSNumber *no = [NSNumber numberWithBool:NO];
	NSMutableDictionary *d = [NSMutableDictionary dictionaryWithObjectsAndKeys:no, @"isStolen", 
																			   yes, @"logLocation", 
																			   yes, @"takePictures", 
																			   nil];
	return d;						  
	
}

-(void)readPreferences;
{
	//TODO: error checking
	NSMutableDictionary *d = [NSMutableDictionary dictionaryWithContentsOfURL:[self preferencesFileURL]];
	if (d == nil) {
		NSLog(@"no preferences file");
		d = [self defaultPreferences];
	}
	self.preferencesDictionary = d;
}

-(void)readMessagingConfig;
{
	// read configuration from the MessagingConfig.plist
	NSArray *configArray = [NSArray arrayWithContentsOfURL:[self configurationFileURL]];
	//NSLog(@"loaded array:%@", configArray);
	
	// loop this array. Instantiate viewControllers of the correct type,
	NSString *serviceType;
	NSString *serviceName;
	for (NSMutableDictionary *d in configArray)
	{
		serviceName = [d objectForKey:@"serviceName"];
		serviceType = [d objectForKey:@"serviceType"];
		
		//TODO: May need to change this as it reloads table view each time
		[self createServiceConfigView:serviceName type:serviceType config:d];
		
	}
}	

-(void)writeConfiguration
{
	[self writePreferences];
	[self writeMessagingConfig];

}

-(void)writePreferences
{
	NSURL *url = [self preferencesFileURL];
	BOOL success = [self.preferencesDictionary writeToURL:url atomically:YES];

	//TODO: better error checking - need sheet
	if (success) {
		NSLog(@"App preferences written to :%@", [url path]);
	}
	else {
		NSLog(@"error writing preferencences file");
	}
}

-(void)writeMessagingConfig
{
	//NSURL *configFile = [self configurationFileURL];
	
	// construct an array of all the config dictionaries
	NSMutableArray *configArray = [NSMutableArray arrayWithCapacity:[self.serviceConfigControllers count]];
	for (ManagingServiceConfigController *c in self.serviceConfigControllers)
	{
		[configArray addObject:c.configDictionary];
	}
	
	//TODO: check return values and throwe error if NO 
	
	BOOL success = [configArray writeToURL:[self configurationFileURL] atomically:YES];
	if (success) {
		NSLog(@"App configuration written to :%@", [[self configurationFileURL] path]);
	}
	else {
		NSLog(@"error writing config file");
	}

	
}

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

// returns a URL of the configuration file
-(NSURL *)configurationFileURL
{
	NSURL *URL = [[self configurationDirectoryURL] URLByAppendingPathComponent:@"MessagingConfig.plist"];
	
	return URL;
}

// returns a URL of the configuration file
-(NSURL *)preferencesFileURL
{
	NSURL *URL = [[self configurationDirectoryURL] URLByAppendingPathComponent:@"Prefs.plist"];
	
	return URL;
}

@end

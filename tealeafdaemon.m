//
//  tealeafdaemon.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 10/01/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "MainController.h"

// Main

int main (int argc, const char * argv[]) 
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// Start a Controller
	MainController *controller = [[MainController alloc] init];
	
	[controller run];	
	[controller dealloc];
	
	DLog(@"exiting");	
	
	[pool release];
	
    return EXIT_SUCCESS;
	
}

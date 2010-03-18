//
//  FileServiceConfigController.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 14/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "FileServiceConfigController.h"


@implementation FileServiceConfigController

@synthesize configDictionary;

-(id)init
{
	if (![super initWithNibName:@"FileServiceConfigView" bundle:nil])
		return nil;

	[self setTitle:@"Configuration for File"];
	
	return self;
}
	
@end

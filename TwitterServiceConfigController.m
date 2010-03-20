//
//  FileServiceConfigController.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 14/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "TwitterServiceConfigController.h"

@implementation TwitterServiceConfigController


-(id)init
{
	if (![super initWithNibName:@"TwitterServiceConfigView" bundle:nil])
		return nil;

	[self setTitle:@"Configuration for Twitter"];
	
	self.serviceType = @"Twitter";
	
	return self;
}
	
@end

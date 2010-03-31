//
//  MessagingService.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 31/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "MessagingService.h"
#import	"Globals.h"


@implementation MessagingService
@synthesize configDictionary;
@dynamic serviceName, serviceType;


-(NSString*)serviceName
{
	
	return [[[self.configDictionary objectForKey:serviceNameKey] retain ] autorelease];
}


-(NSString*)serviceType
{
	
	return [[[self.configDictionary objectForKey:serviceTypeKey] retain ] autorelease];
}



@end

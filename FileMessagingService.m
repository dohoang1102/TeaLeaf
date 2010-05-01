//
//  FileMessagingService.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 31/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "FileMessagingService.h"
#import "Globals.h"

/*
 extern NSString * const directoryToReadFromKey;
 extern NSString * const directoryToSendToKey;
 
 */ 

@implementation FileMessagingService
@dynamic directoryToReadFrom;
@dynamic directoryToSendTo;


#pragma mark accessors
-(NSString *) directoryToReadFrom
{
	return [[[self.configDictionary valueForKey:directoryToReadFromKey] retain] autorelease];
}

-(NSString *) directoryToSendTo
{
	return [[[self.configDictionary valueForKey:directoryToSendToKey] retain] autorelease];
}


#pragma mark base class overrides


//
// Creates file in the correct directory with filename <RequestID>.txt
// TODO: make this multithreaded

-(NSString *)sendTextMessage:(NSString *)textMessage
{
	NSError *error;	
	NSString *requestID = [self newRequestID];
	
	// Get a request ID and make it a filename with txt extennsion
	NSString *file = [[self newRequestID] stringByAppendingPathExtension:@"txt"];
	
	// get the full path
	NSString *fullPath = [self.directoryToSendTo stringByAppendingPathComponent:file];
	
	BOOL success = [textMessage writeToFile:fullPath atomically:YES 
								   encoding:NSUnicodeStringEncoding 
									  error:&error];
	if (!success) {
		// call the delegate
		[self.delegate messageSendFailed:requestID withError:error];
	} else {
		[self.delegate messageSendSucceeded:requestID];
	}
	
	return requestID;

}
	
	
-(NSString *)sendAttachment:(NSData *)attachment; 
{
	return nil;
}


@end

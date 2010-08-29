//
//  FileMessagingService.m
//  TeaLeaf
//
//  Created by Richard Turnbull on 31/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import "FileMessagingService.h"
#import "Globals.h"

//private methods
@interface FileMessagingService ()

- (void)initializeEventStream;
- (BOOL)fileIsText: (NSString *)path;

@end

//
// called when stuff happens in the directory we care about
void fsevents_callback(ConstFSEventStreamRef streamRef,
                       void *userData,
                       size_t numEvents,
                       void *eventPaths,
                       const FSEventStreamEventFlags eventFlags[],
                       const FSEventStreamEventId eventIds[])
{
    FileMessagingService *fms = (FileMessagingService *)userData;
	
	//NSLog(@"Something changed in %@", fms.directoryToReadFrom);
	
	size_t i;
	for(i=0; i<numEvents; i++){
        [fms processInboundMessage:[(NSArray *)eventPaths objectAtIndex:i]];
		
	}
	
}


@implementation FileMessagingService
@dynamic directoryToReadFrom;
@dynamic directoryToSendTo;

-(id)initWithDelegate:(id <MessagingServiceDelegateProtocol>)aDelegate config:(NSDictionary *)aConfigDictionary
{
	self = [super initWithDelegate:aDelegate config:aConfigDictionary];
	
	if (!self)
	{
		NSLog(@"error calling superclass initializer");
		return nil;
	}
	
	// set up a watch on the directory to read from
	
	[self initializeEventStream];
	
	return self;
}

-(void)dealloc
{
	FSEventStreamStop(stream);
    FSEventStreamInvalidate(stream);
	FSEventStreamRelease(stream); 
	
	[super dealloc];
}

#pragma mark accessors
-(NSString *) directoryToReadFrom
{
	return [[[self.configDictionary valueForKey:directoryToReadFromKey] copy] autorelease];
}

-(NSString *) directoryToSendTo
{
	return [[[self.configDictionary valueForKey:directoryToSendToKey] copy] autorelease];
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
								   encoding:NSASCIIStringEncoding 
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

//
// sets up the callback to be called when stuff changes in a directory
//
- (void) initializeEventStream
{
    NSString *myPath = self.directoryToReadFrom;
    NSArray *pathsToWatch = [NSArray arrayWithObject:myPath];
    void *appPointer = (void *)self;
    FSEventStreamContext context = {0, appPointer, NULL, NULL, NULL};
    NSTimeInterval latency = 1.0;
	
	stream = FSEventStreamCreate(NULL,
	                             &fsevents_callback,
	                             &context,
	                             (CFArrayRef) pathsToWatch,
	                             kFSEventStreamEventIdSinceNow,
	                             (CFAbsoluteTime) latency,
	                             kFSEventStreamCreateFlagUseCFTypes 
								 );
	
	FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	FSEventStreamStart(stream);
	//NSLog(@"event stream initialized for path:%@", myPath);
}

//
// Takes a file path, reads each file in it, and streams the contexts to the delegate
//
- (void) processInboundMessage:(NSString *)messagePath
{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray *contents = [fm contentsOfDirectoryAtPath:messagePath error:NULL];
	NSString* fullPath = nil;
	NSError *error = nil;
	
	for(NSString* node in contents) {
		fullPath = [NSString stringWithFormat:@"%@/%@", messagePath, node];
		if ([self fileIsText:fullPath]) 
		{
			NSString *messageText = [NSString stringWithContentsOfFile:fullPath 
															  encoding:NSASCIIStringEncoding 
																 error:&error];
			if (error) {
				DLog(@"error reading file:%@",error);
				return;
			}
			[self.delegate receivedMessage:messageText fromServiceInstanceNamed:self.serviceName];
					
		}
		// delete the file
		
		error = nil;
		[fm removeItemAtPath:fullPath error:&error];
		
		if (error)
			DLog(@"error deleting file:%@",error);
		}
					
}

- (BOOL)fileIsText: (NSString *)path
{
    NSWorkspace *sharedWorkspace = [NSWorkspace sharedWorkspace];
    return [sharedWorkspace type:[sharedWorkspace typeOfFile:path error:NULL] conformsToType:@"public.text"];
}

	

@end

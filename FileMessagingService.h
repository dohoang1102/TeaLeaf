//
//  FileMessagingService.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 31/03/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MessagingService.h"

@interface FileMessagingService : MessagingService {

}


@property (readonly, nonatomic) NSString *directoryToReadFrom;
@property (readonly, nonatomic) NSString *directoryToSendTo;


@end

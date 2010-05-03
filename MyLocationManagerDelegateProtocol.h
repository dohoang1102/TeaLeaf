//
//  MyLocationManagerDelegateProtocol.h
//  TeaLeaf
//
//  Created by Richard Turnbull on 03/05/2010.
//  Copyright 2010 Swandrift Consulting Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol MyLocationManagerDelegateProtocol


-(void)locationDidChange:(NSString *)location;


@end

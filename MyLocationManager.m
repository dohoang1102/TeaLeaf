//
//  MyLocationManager.m
//  CoreLocTest
//
//  Created by Richard Turnbull on 18/12/2009.
//  Copyright 2009 Swandrift Consulting Limited. All rights reserved.
//

#import "MyLocationManager.h"

@interface MyLocationManager()

- (double)latitudeRangeForLocation:(CLLocation *)aLocation;
- (double)longitudeRangeForLocation:(CLLocation *)aLocation;
	
@end


@implementation MyLocationManager
@synthesize delegate;

-(id)initWithDelegate:(id)theDelegate;
{
	if (self = [super init])
	{
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		
		self.delegate = theDelegate;
		
		[locationManager startUpdatingLocation];
		
	}
	
	return self;
}

-(void)dealloc
{
	[locationManager stopUpdatingLocation];
	[locationManager release];
	self.delegate = nil;
	[super dealloc];
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	//NSLog(@"in locationManager:didUpdateToLocation:fromLocation");
	// Ignore updates where nothing we care about changed
	//if (newLocation.coordinate.longitude == oldLocation.coordinate.longitude &&
//		newLocation.coordinate.latitude == oldLocation.coordinate.latitude &&
//		newLocation.horizontalAccuracy == oldLocation.horizontalAccuracy)
//	{
//		return;
//	}

	NSString *locationURLString = [NSString stringWithFormat:URL_TEMPLATE, 
								  newLocation.coordinate.latitude,
								  newLocation.coordinate.longitude,
								  [self latitudeRangeForLocation:newLocation],
								  [self longitudeRangeForLocation:newLocation]];
	
	
	[self.delegate locationDidChange:locationURLString];
	
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	DLog(@"Location manager failed with error: %@",[error localizedDescription]);
}

#pragma mark Private methods
- (double)latitudeRangeForLocation:(CLLocation *)aLocation
{
	const double M = 6367000.0; // approximate average meridional radius of curvature of earth
	const double metersToLatitude = 1.0 / ((M_PI / 180.0) * M);
	const double accuracyToWindowScale = 2.0;
	
	return aLocation.horizontalAccuracy * metersToLatitude * accuracyToWindowScale;
}

- (double)longitudeRangeForLocation:(CLLocation *)aLocation
{
	double latitudeRange =
	[self latitudeRangeForLocation:aLocation];
	
	return latitudeRange * cos(aLocation.coordinate.latitude * M_PI / 180.0);
}


@end

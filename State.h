//
//  state.h
//  GerryManderData
//
//  Created by Jason  Melbourne on 11/23/12.
//  Copyright 2012 GravityCode.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface State : NSObject {
	NSString * name;
	int numDistricts;
	int numCompDistricts;
	int numDemDistricts;
	int numRepDisctricts;
	int numCompDemDistricts;
	int numCompRepDisctricts;
	long demVote;
	long repVote;
	NSMutableArray * districtResults;
	float gerryResult;
}

@property (retain) NSString * name;
@property (assign) int numDistricts;
@property (assign) int numCompDistricts;
@property (assign) int numDemDistricts;
@property (assign) int numRepDistricts;
@property (assign) int numCompDemDistricts;
@property (assign) int numCompRepDistricts;
@property (assign) long demVote;
@property (assign) long repVote;

@property (retain) NSMutableArray* districtResults;

-(id) initWithName:(NSString *) stateName;
-(void) readStateData;
-(void) gerryManderValue;

@end

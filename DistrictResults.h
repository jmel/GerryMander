//
//  DistrictResults.h
//  GerryManderData
//
//  Created by Jason  Melbourne on 11/23/12.
//  Copyright 2012 GravityCode.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DistrictResults : NSObject {
	long demVote;
	long repVote;
	int districtNum;
	char party;
}
@property (assign) long demVote;
@property (assign) long repVote;
@property (assign) int districtNum;
@property (assign) char party;

@end

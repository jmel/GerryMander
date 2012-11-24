#import <Foundation/Foundation.h>
#import "State.h"
#import "DistrictResults.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    NSArray * stateNames=[NSArray arrayWithObjects:@"alabama",@"alaska",@"arizona",@"arkansas",
						  @"california",@"colorado",@"connecticut",@"delaware",@"florida",
						  @"georgia",@"hawaii",@"idaho",@"illinois",@"indiana",@"iowa",
						  @"kansas",@"kentucky",@"louisiana",@"maine",@"maryland",
						  @"massachusetts",@"michigan",@"minnesota",@"mississippi",@"missouri",
						  @"montana",@"nebraska",@"nevada",@"new-hampshire",
						  @"new-jersey",@"new-mexico",@"new-york",@"north-carolina",
						  @"north-dakota",@"ohio",@"oklahoma",@"oregon",@"pennsylvania",
						  @"rhode-island",@"south-carolina",@"south-dakota",@"tennessee",
						  @"texas",@"utah",@"vermont",@"virginia",@"washington",
						  @"west-virginia",@"wisconsin",@"wyoming",nil];

	NSLog(@"number of states= %i",[stateNames count]);
//	float fractionDistricts;
//	float fractionCompDistricts;
//	float fractionVote;
	
	NSString * filename=[NSString stringWithFormat:@"/Users/jmel/objectiveC/GerryManderData/gerrymanderState.txt"];
	NSString * filenameDistrict=[NSString stringWithFormat:@"/Users/jmel/objectiveC/GerryManderData/gerrymanderDistrict.txt"];
	[[NSFileManager defaultManager] createFileAtPath:filename contents:nil attributes:nil];
	[[NSFileManager defaultManager] createFileAtPath:filenameDistrict contents:nil attributes:nil];
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filename];
	NSFileHandle *fileHandleDistrict = [NSFileHandle fileHandleForWritingAtPath:filenameDistrict];
	
	NSString *hdr =[NSString stringWithFormat:@" # Created by Jason Melbourne November 24 2012, Data from Politico \n # Col 1: state: State \n # Col 2: seatTot: Total Seats \n # Col 3: seatDem: Dem Seats \n # Col 4: contSeatTot: Contested Seats \n # Col 5: contSeatDem: Contested Dem Win \n # Col 6: contVoteTot: Contested Vote Tot \n # Col 7: contVoteDem: Contested Dem Vote \n"];
	[fileHandle writeData:[hdr dataUsingEncoding:NSUTF8StringEncoding]];
	[fileHandle writeData:[@"state	seatTot	seatDem	contSeatTot	contSeatDem	contVoteTot	contVoteDem \n" dataUsingEncoding:NSUTF8StringEncoding]];
		
	NSString *hdrDist =[NSString stringWithFormat:@" # Created by Jason Melbourne November 24 2012, Data from Politico \n # Col 1: state: State \n # Col 2: district: district number \n # Col 3: party: Held by Party \n # Col 4: demVote: Democratic Vote \n # Col 5: repVote: Republican Vote \n "];
	[fileHandleDistrict writeData:[hdrDist dataUsingEncoding:NSUTF8StringEncoding]];
	[fileHandleDistrict writeData:[@"state	district	party	demVote	repVote \n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	for (NSString * stateName in stateNames){
		State * state=[[State alloc] initWithName:stateName];
		
		[state readStateData];
//		[state gerryManderValue]; 
		
//		fractionDistricts=(float)state.numDemDistricts/(float)state.numDistricts;
//		fractionVote=(float)state.demVote/(float)(state.demVote+state.repVote);
//		fractionCompDistricts=(float)state.numCompDemDistricts/(float)state.numCompDistricts;
		
		NSString *str = [NSString stringWithFormat:@"%@ %4i %4i %4i %4i %10lld %10lld \n",
						 [state.name stringByPaddingToLength:20 withString:@" " startingAtIndex:0],
						 state.numDistricts, state.numDemDistricts, 
						 state.numCompDistricts, state.numCompDemDistricts, 
						 state.demVote+state.repVote,state.demVote];
		NSLog(@"%@",str);
		[fileHandle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
		
		
		for (DistrictResults * results in state.districtResults){ 
			NSString *str2 = [NSString stringWithFormat:@"%@ %4i    %c %10lld %10lld \n",
							  [state.name stringByPaddingToLength:20 withString:@" " startingAtIndex:0],
							  results.districtNum,results.party,
							  results.demVote,results.repVote];
			NSLog(@"%@",str2);	
			[fileHandleDistrict writeData:[str2 dataUsingEncoding:NSUTF8StringEncoding]];
		}			  
		[state release];
	}
	[fileHandle closeFile];
	[fileHandleDistrict closeFile];
	
    [pool drain];
    return 0;
}

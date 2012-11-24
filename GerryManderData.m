#import <Foundation/Foundation.h>
#import "State.h"

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
	float fractionDistricts;
	float fractionCompDistricts;
	float fractionVote;
	
	NSString * filename=[NSString stringWithFormat:@"/Users/jmel/objectiveC/GerryManderData/gerrymander_state.dat"];
	[[NSFileManager defaultManager] createFileAtPath:filename contents:nil attributes:nil];
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filename];
	
	NSString *hdr =[NSString stringWithFormat:@" #1 State \n #2 Total Seats \n #3 Dem Seats \n #4 Rep Seats \n #5 Fraction Dem \n #6 Contested Seats \n #7 Contested Dem Win \n #8 Contested Rep Win \n # Fraction Contested Dem Win \n #9 Contested Dem Vote \n #10 Contested Rep Vote \n #11 Contested Dem Fraction Vote\n"];
	[fileHandle writeData:[hdr dataUsingEncoding:NSUTF8StringEncoding]];
		
	
	for (NSString * stateName in stateNames){
		State * state=[[State alloc] initWithName:stateName];
		
		[state readStateData];
//		[state gerryManderValue]; 
		
		fractionDistricts=(float)state.numDemDistricts/(float)state.numDistricts;
		fractionVote=(float)state.demVote/(float)(state.demVote+state.repVote);
		fractionCompDistricts=(float)state.numCompDemDistricts/(float)state.numCompDistricts;
		
		NSString *str = [NSString stringWithFormat:@"%@ %4i %4i %4i %5.2f %4i %4i %4i %5.2f %10lld %10lld %5.2f \n",
						 [state.name stringByPaddingToLength:20 withString:@" " startingAtIndex:0],
						 state.numDistricts, state.numDemDistricts, state.numRepDistricts,fractionDistricts,
						 state.numCompDistricts, state.numCompDemDistricts, state.numCompRepDistricts,fractionCompDistricts,
						 state.demVote+state.repVote,state.demVote,state.repVote, fractionVote];

		NSLog(@"%@",str);
		[fileHandle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
		

		[state release];
	}
	[fileHandle closeFile];
	
    [pool drain];
    return 0;
}

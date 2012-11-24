//
//  state.m
//  GerryManderData
//
//  Created by Jason  Melbourne on 11/23/12.
//  Copyright 2012 GravityCode.com. All rights reserved.
//

#import "State.h"
#import "DistrictResults.h"

@implementation State

@synthesize name;
@synthesize numDistricts;
@synthesize numCompDistricts;
@synthesize numRepDistricts;
@synthesize numDemDistricts;
@synthesize numCompRepDistricts;
@synthesize numCompDemDistricts;
@synthesize demVote;
@synthesize repVote;

@synthesize districtResults;

-(void) dealloc
{
	[name release];
	[districtResults release];
	
	[super dealloc];
} // dealloc 


-(id) initWithName:(NSString *) stateName
{
	if (self = [super init]){
		self.name = stateName;
		self.districtResults=[NSMutableArray array];
		self.numCompDistricts =0;
		self.demVote=0;
		self.repVote=0;
	}
	return self;
} // end initWithName

-(void) readStateData
{
	NSURL * stateURL=[NSURL URLWithString:[NSString stringWithFormat:
										   @"http://www.politico.com/2012-election/results/house/%@/",self.name]];
		
	NSError *error=nil;
	NSStringEncoding *enc=nil;
	
	NSString *electionResultsString = [NSString stringWithContentsOfURL:stateURL
											   usedEncoding:enc 
													  error:&error];
	NSXMLDocument *document = [[NSXMLDocument alloc] initWithXMLString:electionResultsString
															   options:NSXMLDocumentTidyHTML
																 error:&error];
	
	NSXMLElement *rootNode = [document rootElement];
	NSString * xpathDistricts=@"//tbody[@id]";
	NSString * xpathComps=@"tr";
	NSString * xpathVote=@"td[@class='results-popular']";


	
	NSArray * districtNodes=[rootNode nodesForXPath:xpathDistricts error:&error];
	
	self.numDistricts=[districtNodes count];
	
	int c = 1;
	for (id districtNode in districtNodes){
		NSArray * compNodes=[districtNode nodesForXPath:xpathComps error:&error];
		DistrictResults * voteResults=[[DistrictResults alloc] init];
		NSRange range = [[[compNodes objectAtIndex:0] stringValue] rangeOfString:@"Dem"];
		if (range.length != 0){
			self.numDemDistricts ++;
			voteResults.party='D';
		} else {
			self.numRepDistricts ++;
			voteResults.party='R';
		}

		if ([compNodes count] >= 2) {
			self.numCompDistricts ++;
			if (range.length != 0){
				voteResults.demVote=[[[[[[[compNodes objectAtIndex:0] nodesForXPath:xpathVote error:&error] objectAtIndex:0] childAtIndex:0] stringValue] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
				voteResults.repVote=[[[[[[[compNodes objectAtIndex:1] nodesForXPath:xpathVote error:&error] objectAtIndex:0] childAtIndex:0] stringValue] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
				self.numCompDemDistricts ++;
			} else {
				voteResults.repVote=[[[[[[[compNodes objectAtIndex:0] nodesForXPath:xpathVote error:&error] objectAtIndex:0] childAtIndex:0] stringValue] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
				voteResults.demVote=[[[[[[[compNodes objectAtIndex:1] nodesForXPath:xpathVote error:&error] objectAtIndex:0] childAtIndex:0] stringValue] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
				self.numCompRepDistricts ++;
			}
		}
		voteResults.districtNum=c;
		[self.districtResults addObject:voteResults];
		self.demVote+=voteResults.demVote;
		self.repVote+=voteResults.repVote;
		[voteResults release];
		c++;
	}	
} // end readStateData	
		


@end

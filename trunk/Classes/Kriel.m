//
//  Kriel.m
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 06. 19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Kriel.h"


@implementation KrielStage

-(id) init
{
	self = [super init];
	if (self != nil)
	{
		isTouchEnabled = YES;
		
		//Load sprite images
		floorGrp[0] = [[Sprite spriteWithFile:@"floor_1.png"] retain];
		floorGrp[1] = [[Sprite spriteWithFile:@"floor_2.png"] retain];
		
		[self read:0];
	}
	
	return self;
}

-(void) read: (int)stageNum
{
	// read stage data with the given stage number.
	FILE* file;
	
	file = fopen("STAGE.DAT", "rb");
	if(file)
	{
		fseek(file, stageRowSize * stageColSize * stageNum, SEEK_SET);
		
		for(int i=0; i<stageColSize; i++)
		{
			for(int j=0; j<stageRowSize; j++)
			{
				stage[j][i] = getc(file);
			}
		}
		
		fclose(file);
	}
	
	// draw stage
	for (int i=0; i<stageColSize; i++)
	{
		for (int j=0; j<stageRowSize; j++)
		{
			;
		}
	}
	
}


@end // end of KrielStage

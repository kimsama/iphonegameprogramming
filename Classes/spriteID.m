//
//  spriteID.m
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 10. 24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "spriteID.h"


@implementation spriteID

@synthesize resourceID;


-(id) init	
{
	self = [super init];
	
	if(self)
	{
        NSArray *values = [NSArray arrayWithObjects: 
						   @"floor_1.png", // 0
						   @"block_1.png", // 1
						   @"hero_left1.png", // 2
						   @"slime1.png",  // 3
						   @"knight1.png", // 4
						   @"ghost1.png",  // 5
						   @"stick.png",   // 6
						   @"sword.png",   // 7
						   @"cross.png",   // 8
						   @"princess.png",// 9
						   @"key1.png",    // 10
						   @"close.png",   // 11
						   @"arrow_up0_0.png",  // 12
						   @"arrow_down0_0.png", // 13
						   @"arrow_left0_0.png", // 14
						   @"arrow_right0_0.png", //15
						   nil ];
		
		NSArray *keys = [NSArray arrayWithObjects:	
		        0, // #define IMG_FLOOR		
             	1, // #define IMG_BLOCK 
            	2, // #define IMG_HEROUP 
          	    17, // #define IMG_HERODOWN 
          	    18, // #define IMG_HEROLEFT 
            	19, // #define IMG_HERORIGHT    
				2, // #define IMG_HERO 
				3, // #define IMG_SLIME
             	20, // #define IMG_SLIME1
            	21, // #define IMG_SLIME2 
				4,  // #define IMG_KNIGHT
            	22, // #define IMG_KNIGHT1
            	23, // #define IMG_KNIGHT2
				5,  // #define IMG_GHOST 
            	24, // #define IMG_GHOST1 
           	    25, // #define IMG_GHOST2  
		    	6,  // #define IMG_STICK	
				7,  // #define IMG_SWORD
				8, // #define IMG_CROSS
			    9, // #define IMG_PRINCESS
				10, // #define IMG_KEY
				11, // #define IMG_EXIT
        	    26, // #define IMG_CLOSEEXIT  
         	    27, // #define IMG_OPENEXIT  
				12, // #define IMG_UP 
                13, // #define IMG_DOWN 
                14, // #define IMG_LEFT  
                15, // #define IMG_RIGHT 
				28, // #define IMG_KING
			    29, // #define IMG_LOGO	
						 nil];
	    
		// Create dictionary for resouce id.
		resourceID = [NSDictionary dictionaryWithObjects:values forKeys:keys];
	}
	
	return self;	
}

@end

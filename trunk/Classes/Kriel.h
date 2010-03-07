//
//  Kriel.h
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 06. 19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

typedef char byte;

@interface KrielStage : Layer {

	enum  {
	    stageRowSize = 16,
	    stageColSize = 11
	};
	
	// array which represents stage
	byte stage[stageRowSize][stageColSize];
	
	// stage images
	Sprite *floorGrp[2];
}

-(void)read: (int)stageNum;

@end

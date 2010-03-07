//
//  ActorSprite.h
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 08. 14.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

/**
 @class ActorSprite
     
 A class handles actor. Actor is defined a sprite which has animations.
 A animation xml file consists of more than one animation element and each of the  
 animation can have any number of sprite. 
 
 Actor animation XML file structure:
 
 [animation name 1]
     [x]
     [y]
     [w]
     [h]
 
 [animatin name 2]
     ...
 
 (repeat)
 
 */
@interface ActorSprite : CocosNode {
	
	/// container which contains actor's animations.
	NSMutableDictionary *animationDictionary;

	// temparay frame count
	int frameCount;
	// total number of frames of which currently specified animation
	int numCurrentAnimationFrameCount;
	// animation name which is currently displayed
	NSMutableString *currentAnimationName;
	// default animation name
	NSMutableString *defaultAnimationName;
	
	AtlasSpriteManager *mgr;
	AtlasSprite *defaultSprite;
	id curAction;
	
}

@property (readwrite) int numCurrentAnimationFrameCount;

-(id) Load:(NSString*)xmlFilepath withImage:(NSString*)imgFilename;

-(void) setDefaultAnimation:(NSString*) animationName;

@end

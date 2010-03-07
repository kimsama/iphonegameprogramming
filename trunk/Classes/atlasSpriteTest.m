//
//  atlasSpriteTest.m
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 08. 20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "atlasSpriteTest.h"

//#import "AnimationFactory.h" 

@implementation AnimationFactory 

@synthesize rectSize; 

- (id) initWithSizeRect: (CGSize) newSize andSpriteManager: (AtlasSpriteManager *) manager
{ 
	self = [super init]; 
	if (self != nil) { 
		rectSize = newSize; 
		tilesPerLine = manager.atlas.texture.contentSize.width / 
		newSize.width; 
	} 
	return self; 
} 

- (id<CocosAnimation>) createAnimationStartingAtFrame:(int) startFrame 
								   withNumberOfFrames:(int) numberOfFrames andName: (NSString *) name 
										 andFrameRate: (float) frameRate{ 
	int frames[numberOfFrames]; 
	for (int i=startFrame,j=0;i<numberOfFrames+startFrame;i++,j++) 
	{ 
		frames[j]=i; 
	} 
	return [self createAnimationWithFrames: frames withNumberOfFrames: 
			numberOfFrames andName: name andFrameRate: frameRate]; 
} 

- (id<CocosAnimation>) createAnimationWithFrames: (int[]) frames 
							  withNumberOfFrames: (int)numberOfFrames 
										 andName: (NSString *) name andFrameRate: (float) frameRate{ 
	AtlasAnimation *anim= [AtlasAnimation animationWithName:name 
													  delay:frameRate]; 
	for(int i=0;i<numberOfFrames;i++) { 
		int x= frames[i] % tilesPerLine; 
		int y= frames[i] / tilesPerLine; 
		[anim addFrameWithRect: CGRectMake(x * rectSize.width, y * 
										   rectSize.height, rectSize.width, rectSize.height) ]; 
	} 
	return anim; 
} 

@end 

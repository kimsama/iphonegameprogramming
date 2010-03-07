//
//  atlasSpriteTest.h
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 08. 20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h" 


@interface AnimationFactory : NSObject { 
	CGSize rectSize; 
	int tilesPerLine; 
} 

- (id) initWithSizeRect: (CGSize) newSize andSpriteManager: 
(AtlasSpriteManager *) manager; 
- (id<CocosAnimation>) createAnimationStartingAtFrame:(int) startFrame 
								   withNumberOfFrames:(int) numberOfFrames andName: (NSString *) name 
										 andFrameRate: (float) frameRate; 
- (id<CocosAnimation>) createAnimationWithFrames: (int[]) frames 
							  withNumberOfFrames:(int) numberOfFrames andName: (NSString *) name 
									andFrameRate: (float) frameRate; 
@property(readonly) CGSize rectSize; 
@end 

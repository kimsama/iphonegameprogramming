//
//  ActorSprite.m
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 08. 14.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ActorSprite.h"
#import "atlasAnimationXmlParser.h"


@implementation ActorSprite

@synthesize numCurrentAnimationFrameCount;


//-----------------------------------------------------------------------------
/**
 */
-(id) init
{
	self = [super init];
	
	if (self)
	{
		frameCount = 0;
	}
	
	return self;
}

//-----------------------------------------------------------------------------
/**
 */
-(void) dealloc
{
	[mgr release];
	
	// dealloc all animations
	[currentAnimationName release];
	[defaultAnimationName release];
	
	[super dealloc];
}

//-----------------------------------------------------------------------------
/**
     Load xml file and image file then create AtlasAniamtion animations.
 */
-(id) Load:(NSString*)xmlFilepath withImage:(NSString*)imgFilename
{
	// file path should not be null.
	NSAssert ([xmlFilepath length] != 0, @"Invalid Path.");
	
	// parse sprite xml file
	NSError *error = nil;

	atlasAnimationXmlParser *xmlParser = [[atlasAnimationXmlParser alloc] init];
	[xmlParser parseXMLWithFile:xmlFilepath parseError:&error];

	
	mgr = [AtlasSpriteManager spriteManagerWithFile:imgFilename capacity:100];
	
	// FIXME: hardcoding with tag!!!
	//[self addChild:mgr z:0 tag:1];
	AnimationElement *element = nil;
	FrameElement *frame = nil;
	
	element = [xmlParser.spriteArray objectAtIndex:0];
	frame = [element.frameArray objectAtIndex:0];
	
	defaultSprite = [AtlasSprite spriteWithRect:CGRectMake(frame.x, frame.y, frame.w, frame.h) spriteManager:mgr];
	[mgr addChild:defaultSprite];
	
	
	animationDictionary = [[NSMutableDictionary alloc] init];
	
	int numAnimations = xmlParser.spriteArray.count;
	
	
	for (int i=0; i<numAnimations; i++)
	{
		element = [xmlParser.spriteArray objectAtIndex:i];

		AtlasAnimation *anim = [[AtlasAnimation alloc] initWithName:element.animationName delay:element.delay];
		
		// for each of frames...
		for (int j=0; j<element.frameArray.count; j++)
		{
			frame = [element.frameArray objectAtIndex:j];

		    [anim addFrameWithRect:CGRectMake(frame.x, frame.y, frame.w, frame.h)];
		}
		
		//creaete action which associates with the animation.
		id action = [Animate actionWithAnimation:anim];
		
		// use first animation for default action.
		if (i==0)
		{
			curAction = [[action copy] autorelease];
		}
		//add created animations to the animation list.
		[animationDictionary setObject:action forKey:element.animationName];
		
		// add the created animation
		//[self addAnimation:anim];
	}
	
	[defaultSprite runAction:curAction];
	
	//[self schedule: @selector(tick:) interval:0.1];

	
	return mgr;
}

//-----------------------------------------------------------------------------
/**
 */
-(void) setDefaultAnimation:(NSString*)animationName
{
	if (defaultAnimationName != nil)
		[defaultAnimationName release];
	
	[defaultAnimationName initWithString:animationName];
}

//-----------------------------------------------------------------------------
/**
    Use this to change animation.
 */
-(void)setCurrentAnimation:(NSString*)animationName
{
	// first, get AtlasAnimation from the dictionary
	id action = [animationDictionary objectForKey:animationName];
	
	[defaultSprite runAction:action];
	
	/*
	AtlasAnimation *anim = [self animationByName:animationName];
	
	// get frame count from NSArray which contains all its animation frames.
	self.numCurrentAnimationFrameCount = [anim.frames count];
	
	[currentAnimationName release];
	[currentAnimationName initWithString:animationName];
	 */
}

//-----------------------------------------------------------------------------
/**
     Update animation. (internally called with the specified tick)
 */
/*
-(void) tick: (ccTime) dt
{
	
	//reset frame counter if its past the total frames
	if(frameCount > self.numCurrentAnimationFrameCount) frameCount = 0;
	
	//Set the display frame to the frame in the walk animation at the frameCount index
	[self setDisplayFrame:currentAnimationName index:frameCount];
	
	//Increment the frameCount for the next time this method is called
	frameCount = frameCount+1;
}
*/

@end

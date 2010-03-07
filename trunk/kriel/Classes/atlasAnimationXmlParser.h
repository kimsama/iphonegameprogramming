//
//  atlasAnimationXmlParser.h
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 06. 22.
//  Copyright 2009 Kim Hyoun Woo. All rights reserved.
//

#import <Foundation/Foundation.h>

//------------------------------------------------------------------------------
/**
    @class AnimationElement
 
    (c)2009 Kim Hyoun Woo
 */
@interface AnimationElement : NSObject
{
	NSString *animationName;
	
	int delay;
	
	NSMutableArray *frameArray;
}

@property (copy, readwrite) NSString *animationName;
@property (readwrite) int delay;
@property (copy, readwrite) NSMutableArray *frameArray;

@end

//------------------------------------------------------------------------------
/**
 @class FrameElement
 
 (c)2009 Kim Hyoun Woo
 */
@interface FrameElement : NSObject
{
	int x, y;
	int w, h;
}

@property (readwrite) int x;
@property (readwrite) int y;
@property (readwrite) int w;
@property (readwrite) int h;

@end


//------------------------------------------------------------------------------
/**
    @class atlasAnimationXmlParser
 
    It read its animation information from the given xml.
 
	(c)2009 Kim Hyoun Woo
 */
@interface atlasAnimationXmlParser : NSObject {
	
	// temparal element's name.
	NSMutableString *currentElementName;
	
	// <key> elements name
	NSMutableString *currentKeyElementValue;
	
	// element's value such as 'xxx.png', x, y or some interger numbers.
	NSMutableString *currentIntElementValue;
	
	NSMutableString *tempAnimName;
	
	// number of frames for this animation
	int tempNumFrames;
	
	// dealy value
	int tempDelay;
	
	// position and size of the given frame.
	int tempX;
	int tempY;
	int tempW;
	int tempH;
	
	// contains temparary frames
	NSMutableArray *tempFrameArray;
	
	// Array whcih contains parsed sprite info.
	NSMutableArray *spriteArray;
	
	AnimationElement *currentAnimationElement;
}

@property (copy, readwrite) NSMutableArray *spriteArray;

-(void) parseXMLWithFile:(NSString*) fileName parseError:(NSError **)error;

@end

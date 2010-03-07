//
//  ImageLoader.h
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 06. 22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//------------------------------------------------------------------------------
/**
    @class SpriteElements
 
    (c)2009 Kim Hyoun Woo
 */
@interface SpriteElement : NSObject
{
	NSString *fileName;
	
	int x,y;
	int w,h;
}

@property (copy, readwrite) NSString *fileName;
@property (readwrite) int x;
@property (readwrite) int y;
@property (readwrite) int w;
@property (readwrite) int h;

@end


//------------------------------------------------------------------------------
/**
    @class ImageLoader
 
    Load atlas image and it read its information from the given xml.
 
	(c)2009 Kim Hyoun Woo
 */
@interface ImageLoader : NSObject {
	
	// temparal element's name.
	NSMutableString *currentElementName;
	
	// <key> elements name
	NSMutableString *currentKeyElementValue;
	
	// element's value such as 'xxx.png', x, y or some interger numbers.
	NSMutableString *currentIntElementValue;
	
	// an image file which for a Sprite
	NSMutableString *currentImagefilename;
	
	int tempX;
	int tempY;
	int tempW;
	int tempH;
	int tempOffsetX;
	int tempOffsetY;
	
	// Array whcih contains parsed sprite info.
	NSMutableArray *spriteArray;
}

@property (copy, readwrite) NSMutableArray *spriteArray;

-(void) parseXMLWithFile:(NSString*) fileName parseError:(NSError **)error;

@end

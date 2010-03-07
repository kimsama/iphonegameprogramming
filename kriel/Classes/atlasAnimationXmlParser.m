//
//  ImageLoader.m
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 06. 22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "atlasAnimationXmlParser.h"

#define MAX_SPRITE_NUM  100

@implementation AnimationElement

@synthesize animationName;
@synthesize delay;
@synthesize frameArray;

@end

@implementation FrameElement

@synthesize x;
@synthesize y;
@synthesize w;
@synthesize h;

@end


@implementation atlasAnimationXmlParser


@synthesize spriteArray;

//------------------------------------------------------------------------------
/**
 */
-(id) init
{
	self = [super init];
	if (self)
	{
	    ;
	}
	
	return self;
}

//------------------------------------------------------------------------------
/**
     Parsing the givn .xml file which contains atlas image data information.
 */
-(void) parseXMLWithFile:(NSString*) fileName parseError:(NSError **)error
{
	NSString *path = [[NSBundle mainBundle] bundlePath];
	
	NSString *dataPath = [path stringByAppendingPathComponent:fileName];
	
	// read xml file.
	NSData *xmlData = [[NSData alloc] initWithContentsOfFile:dataPath];
	
	if (xmlData)
	{
		// Initialize sprite array.
		spriteArray = [NSMutableArray arrayWithCapacity:MAX_SPRITE_NUM];

	    // create xml parse with the given xml data.
	    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	    [parser setDelegate:self];
	
	    [parser parse];
	
        NSError *parseError = [parser parserError];
        if (parseError && error) 
	    {
            *error = parseError;
        }
	
	    [parser release];
	}
	else
		NSLog(@"%@ file does not exist.\n", dataPath);
}

//------------------------------------------------------------------------------
/**
     Start of the element.
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
    namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
    }
	
	currentElementName = [elementName copy];
	
	// actually parsing elements. 
	// Nothing to do here at the moment.
	/*
    if ([elementName isEqualToString:@"dict"]) 
	{
	}
	
    if ([elementName isEqualToString:@"key"]) 
	{
	}
		
	if ([elementName isEqualToString:@"integer"])
	{
	}
	*/
}

//------------------------------------------------------------------------------
/**
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
    namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{     
    if (qName) 
	{
        elementName = qName;
    }

    if ([elementName isEqualToString:@"anim"]) 
	{
		
		// make a Sprite and add it to SpriteManager
		if (tempW != 0 && tempH != 0)
		{
            // create sprite element and speicify with the parsed data.
			AnimationElement *spr = [[AnimationElement alloc] init];
			spr.animationName = tempAnimName;//currentKeyElementValue;
			
			spr.delay = tempDelay;
	
			/*
			for(int i=0; i<tempNumFrames; i++)
			{
				FrameElement *frame = [tempFrameArray objectAtIndex:i];
				[spr.frameArray addObject:frame];
			}
			*/
			spr.frameArray = [tempFrameArray copy];
			
			[spriteArray addObject:spr];
			
			// release tempFrameArray
			/*
			for (int i=0; i<tempFrameArray.count; i++)
			{
				FrameElement *frame = [tempFrameArray objectAtIndex:i];
				[frame release];
			}
			*/
			[tempFrameArray removeAllObjects];
            
			// reset temp width and height of the sprite.
			tempNumFrames = tempDelay = tempX = tempY = tempW = tempH = 0;
		}
		
		// reset
		currentKeyElementValue = nil;
		
	}
	
	if ([elementName isEqualToString:@"name"])
	{
		tempAnimName = currentKeyElementValue;
	}
	
    if ([elementName isEqualToString:@"key"]) 
	{
		// key value is image file name for a Sprite.
		//if([[currentKeyElementValue pathExtension] isEqualToString:@"png"])
		//{
			//currentImagefilename = currentKeyElementValue;
		//	currentKeyElementValue = nil;
		//}
	}
	
    if ([elementName isEqualToString:@"numframes"]) 
	{
		// key value is image file name for a Sprite.
		//if([[currentKeyElementValue pathExtension] isEqualToString:@"png"])
		//{
		//	currentImagefilename = currentKeyElementValue;
		//	currentKeyElementValue = nil;
		//}
		tempNumFrames = [currentIntElementValue intValue];
		
		tempFrameArray = [NSMutableArray arrayWithCapacity:MAX_SPRITE_NUM];
	}
	
    if ([elementName isEqualToString:@"delay"]) 
	{
		//tempDelay = [currentIntElementValue intValue];
		currentAnimationElement.delay = [currentIntElementValue intValue];
		
	}
	
	if ([elementName isEqualToString:@"integer"])
	{
		
		if ([currentKeyElementValue isEqualToString:@"x"])
		{
			tempX = [currentIntElementValue intValue];
		}
		else
		if ([currentKeyElementValue isEqualToString:@"y"])
		{
			tempY = [currentIntElementValue intValue];
		}
		else
		if ([currentKeyElementValue isEqualToString:@"w"])
		{
			tempW = [currentIntElementValue intValue];
		}
		else
		if ([currentKeyElementValue isEqualToString:@"h"])
		{
			tempH = [currentIntElementValue intValue];
			
			// add the frame to frameArray in the sprite element
			FrameElement *frame = [[FrameElement alloc] init];
			frame.x = tempX;
			frame.y = tempY;
			frame.w = tempW;
			frame.h = tempH;
			
			[tempFrameArray addObject:frame];
			
		}
		else
			NSLog(@"Unknwon key.\n");
		
		currentIntElementValue = nil;
	}	
}

//------------------------------------------------------------------------------
/**
     Retrieves and stores temparary key and its integer values.
     Those values are lately used for creating AtlasSprite.
 */
-(void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string
{
	// deals with string values.
	if ([currentElementName isEqualToString:@"name"] || 
		[currentElementName isEqualToString:@"key"])
	{
		if (!currentKeyElementValue)
			currentKeyElementValue = [[NSMutableString alloc] initWithString:string];
		else
		{
			// ignore any newline characters or tabs.
			NSRange range = [string rangeOfString:@"\n\t" options:NSCaseInsensitiveSearch];
			
			if (range.location == NSNotFound)
			{
				currentKeyElementValue = [string copy];
			}				
		}
	}
	// deals with integer values.
	else 
	if ([currentElementName isEqualToString:@"numframes"]||
		[currentElementName isEqualToString:@"delay"] ||
		[currentElementName isEqualToString:@"integer"])
	{
		//currentIntElementValue = string;
		if (!currentIntElementValue)
			currentIntElementValue = [[NSMutableString alloc] initWithString:string];
		else
		{
			// if the string contains any '\n' or '\t', do just skip
			NSRange range = [string rangeOfString:@"\n\t" options:NSCaseInsensitiveSearch];
			if (range.location == NSNotFound)
			{
				currentIntElementValue = [string copy];
			}
		}
	}
}

//------------------------------------------------------------------------------
/**
 */
-(void)dealloc
{
	for (int i=0; i<self.spriteArray.count; i++)
	{
		AnimationElement *sprEle = [self.spriteArray objectAtIndex:i];
		[sprEle release];
	}
	
	[super dealloc];
}

@end

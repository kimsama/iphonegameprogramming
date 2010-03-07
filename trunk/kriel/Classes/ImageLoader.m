//
//  ImageLoader.m
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 06. 22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ImageLoader.h"


@implementation SpriteElement

@synthesize fileName;
@synthesize x;
@synthesize y;
@synthesize w;
@synthesize h;

@end

@implementation ImageLoader


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
		spriteArray = [NSMutableArray arrayWithCapacity:100];

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

    if ([elementName isEqualToString:@"dict"]) 
	{
		// make a Sprite and add it to SpriteManager
		if (tempW != 0 && tempY != 0)
		{
            // create sprite element and speicify with the parsed data.
			SpriteElement *spr = [[SpriteElement alloc] init];
			spr.fileName = [currentImagefilename copy];
			spr.x = tempX;
			spr.y = tempY;
			spr.w = tempW;
			spr.h = tempH;
			
			[spriteArray addObject:spr];
            
			// reset temp width and height of the sprite.
			tempX = tempY = tempW = tempH = 0;
		}
		
		// reset
		currentKeyElementValue = nil;
		currentImagefilename = nil;
	}
	
    if ([elementName isEqualToString:@"key"]) 
	{
		// key value is image file name for a Sprite.
		if([[currentKeyElementValue pathExtension] isEqualToString:@"png"])
		{
			currentImagefilename = currentKeyElementValue;
			currentKeyElementValue = nil;
		}
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
		}
		else
		if ([currentKeyElementValue isEqualToString:@"offsetX"])
		{
			tempOffsetX = [currentIntElementValue intValue];
		}
		else
		if ([currentKeyElementValue isEqualToString:@"offsetY"])
		{
			tempOffsetY = [currentIntElementValue intValue];
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
	if ([currentElementName isEqualToString:@"key"])
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
	else 
	if ([currentElementName isEqualToString:@"integer"])
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
		SpriteElement *sprEle = [self.spriteArray objectAtIndex:i];
		[sprEle release];
	}
	
	[super dealloc];
}

@end

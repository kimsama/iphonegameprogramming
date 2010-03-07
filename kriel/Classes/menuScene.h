//
//  MenuScene.h
//  kriel
//
//  Created by Hyoun Woo Kim on 09. 06. 17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "cocos2d.h"

//-------------------------------------------------------------------------------
/**
 */
@interface MenuScene : Scene
{
	
}

@end

//-------------------------------------------------------------------------------
/**
 */
@interface MenuLayer : Layer
{

}

-(void)startGameCallback: (id)sender;
-(void)quitCallback: (id)send;

@end



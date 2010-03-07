//
//  cocos2d_appAppDelegate.h
//  cocos2d app
//
//  Created by 주세영 on 09. 07. 12.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//



#import "GostopAgent.h"
#import <UIKit/UIKit.h>




@class Sprite;
@class CGostopAgent;

//CLASS INTERFACE
@interface cocos2d_appAppDelegate : NSObject <UIAccelerometerDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIApplicationDelegate>
{
	UIWindow	*window;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@end




@interface MainGame : Layer
{
	CGostopAgent *m_Agent;
}



@end

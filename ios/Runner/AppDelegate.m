#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include "rustylib.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    
    NSString *userId = @"userId";
    NSString *defaultProviderId = @"54U6krAr-j9nQXFlsHk3io04_p0tctuqH71t7w_usgI=";
//    NymmobileGenerateKeyPair(userId, NSHomeDirectory(), defaultProviderId);
//    NymmobileStartWebsocket(userId, NSHomeDirectory());
    
    init([userId UTF8String]);
    
    if([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
    {
        NSLog(@"Multitasking Supported");
     
        __block UIBackgroundTaskIdentifier background_task;
        background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
     
            //Clean up code. Tell the system that we are done.
            [application endBackgroundTask: background_task];
            background_task = UIBackgroundTaskInvalid;
        }];
     
        //To make the code block asynchronous
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
            //### background task starts
            NSLog(@"Running in the background\n");
          
            start_ws([userId UTF8String]);
            
            //#### background task ends
     
            //Clean up code. Tell the system that we are done.
            [application endBackgroundTask: background_task];
            background_task = UIBackgroundTaskInvalid;
        });
    }
    else
    {
        NSLog(@"Multitasking Not Supported");
    }
    
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}



@end

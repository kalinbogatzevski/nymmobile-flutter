#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include "Nymmobile/Nymmobile.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    
    NSString *userId = @"userId";
    NSString *defaultProviderId = @"54U6krAr-j9nQXFlsHk3io04_p0tctuqH71t7w_usgI=";
    NymmobileGenerateKeyPair(userId, NSHomeDirectory(), defaultProviderId);
    NymmobileStartWebsocket(userId, NSHomeDirectory());
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

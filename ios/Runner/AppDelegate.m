#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include "Nymmobile/Nymmobile.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    
    NymmobileGenerateKeyPair(userId, NSHomeDirectory, defaultProviderId)
    NymmobileStartWebsocket(userId, NSHomeDirectory)
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

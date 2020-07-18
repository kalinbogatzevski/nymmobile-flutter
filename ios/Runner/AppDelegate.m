#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include "nym_mobile.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

@implementation AppDelegate

- (NSString *)getIPAddress {

    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                const struct sockaddr_in *addr = (const struct sockaddr_in*)temp_addr->ifa_addr;
                char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];

                if(!(temp_addr->ifa_flags & IFF_LOOPBACK)) {
                    if(addr->sin_family == AF_INET) {
                        if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                            address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                            break;
                        }
                    }
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    
    NSString *userId = @"xxxx";
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

            //### background task starts
            NSLog(@"Running in the background\n");
            
            run([userId UTF8String]);

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

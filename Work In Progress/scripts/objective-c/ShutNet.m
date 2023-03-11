#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self shutdownMachines];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}

- (void)shutdownMachines {
    NSMutableArray *ipAddresses = [NSMutableArray array];
    for (int i = 1; i <= 254; i++) {
        NSString *ip = [NSString stringWithFormat:@"192.168.1.%d", i];
        FILE *fp;
        char pingResult[100];
        NSString *command = [NSString stringWithFormat:@"ping -c 1 -W 1 %@", ip];
        fp = popen([command UTF8String], "r");
        if (fp == NULL) {
            printf("Failed to run command\n");
            exit(1);
        }
        while (fgets(pingResult, sizeof(pingResult)-1, fp) != NULL) {
            if (strstr(pingResult, "1 received")) {
                [ipAddresses addObject:ip];
            }
        }
        pclose(fp);
    }
    
    NSString *ipFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Ips.txt"];
    [ipAddresses writeToFile:ipFilePath atomically:YES];
    
    for (NSString *ip in ipAddresses) {
        FILE *fp;
        char pingResult[100];
        NSString *command = [NSString stringWithFormat:@"ping -c 1 -W 1 %@", ip];
        fp = popen([command UTF8String], "r");
        if (fp == NULL) {
            printf("Failed to run command\n");
            exit(1);
        }
        while (fgets(pingResult, sizeof(pingResult)-1, fp) != NULL) {
            if (strstr(pingResult, "1 received")) {
                FILE *fp2;
                char computerName[100];
                NSString *nslookupCommand = [NSString stringWithFormat:@"nslookup %@", ip];
                fp2 = popen([nslookupCommand UTF8String], "r");
                if (fp2 == NULL) {
                    printf("Failed to run command\n");
                    exit(1);
                }
                while (fgets(computerName, sizeof(computerName)-1, fp2) != NULL) {
                    if (strstr(computerName, "name =")) {
                        NSString *computerNameString = [NSString stringWithUTF8String:computerName];
                        NSString *regex = @"name = ([^\\.]+)\\.";
                        NSRange range = [computerNameString rangeOfString:regex options:NSRegularExpressionSearch];
                        if (range.location != NSNotFound) {
                            computerNameString = [computerNameString substringWithRange:[range rangeAtIndex:1]];
                            NSString *shutdownCommand = [NSString stringWithFormat:@"ssh %@ shutdown -h now", computerNameString];
                            system([shutdownCommand UTF8String]);
                        }
                    } else {
                        printf("Could not resolve computer name for IP address %s\n", [ip UTF8String]);
                    }
                }
                pclose(fp2);
            } else {
                printf("Could not connect to IP address %s\n", [ip UTF8String]);
            }
        }
        pclose(fp);
    }
    remove([ipFilePath UTF8String]);
}

@end

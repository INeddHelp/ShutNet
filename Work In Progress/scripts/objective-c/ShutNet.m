#import <Foundation/Foundation.h>
#import <NMSSH/NMSSH.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray *ipAddresses = [[NSMutableArray alloc] init];

        for (int i = 1; i <= 254; i++) {
            NSString *ip = [NSString stringWithFormat:@"192.168.1.%d", i];
            NSLog(@"Scanning %@", ip);
            NSTask *task = [[NSTask alloc] init];
            task.launchPath = @"/sbin/ping";
            task.arguments = @[@"-c", @"1", @"-t", @"1", ip];
            NSPipe *pipe = [[NSPipe alloc] init];
            task.standardOutput = pipe;
            [task launch];
            [task waitUntilExit];
            if ([task terminationStatus] == 0) {
                [ipAddresses addObject:ip];
            }
        }
        
        NSURL *fileURL = [NSURL fileURLWithPath:@"Ips.txt"];
        NSString *ipString = [ipAddresses componentsJoinedByString:@"\n"];
        [ipString writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];

        for (NSString *ip in ipAddresses) {
            NSLog(@"Shutting down %@", ip);
            NSError *error = nil;
            NMSSHSession *session = [NMSSHSession connectToHost:ip withUsername:@"username"];
            [session authenticateByPassword:@"password"];
            if (session.isAuthorized) {
                NSString *computerName = [session.channel execute:@"hostname" error:&error];
                if (error) {
                    NSLog(@"Could not resolve computer name for IP address %@", ip);
                    continue;
                }
                NSString *osName = [session.channel execute:@"uname" error:&error];
                if (error) {
                    NSLog(@"Could not determine operating system for %@", computerName);
                    continue;
                }
                if ([osName containsString:@"Windows"]) {
                    [session.channel execute:@"shutdown.exe /s /t 0" error:nil];
                } else if ([osName containsString:@"Linux"]) {
                    [session.channel execute:@"sudo shutdown -h now" error:nil];
                } else if ([osName containsString:@"Darwin"]) {
                    [session.channel execute:@"sudo shutdown -h now" error:nil];
                } else {
                    NSLog(@"Unknown operating system for %@", computerName);
                }
            } else {
                NSLog(@"Could not authenticate with %@", ip);
            }
            [session disconnect];
        }

        [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
    }
    return 0;
}

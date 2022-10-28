//
//  ISHDevice.m
//
//  Created by Hagi on 04/03/15.
//  Copyright (c) 2015 iosphere GmbH. All rights reserved.
//

#import "SMPDevice.h"
#import <sys/utsname.h>

@implementation SMPDevice

+ (NSString *)supportSummary {
#if DEBUG
    [self assertLocalizedStrings];
#endif

    NSMutableString *emailBody = [NSMutableString stringWithString:@"\n\n\n ------Info------\n"];
    UIDevice *currentDevice = [self currentDevice];

    [emailBody appendFormat:@"%@: %@\n", NSLocalizedString(@"sumup_support_email_title_locale", @"Prefix for locale in support emails"), [NSLocale autoupdatingCurrentLocale].localeIdentifier];
    [emailBody appendFormat:@"%@: %@\n", NSLocalizedString(@"sumup_support_email_title_device", @"Prefix for device category in support emails"), [self modelSpecifier]];
    [emailBody appendFormat:@"%@: %@ %@\n", NSLocalizedString(@"sumup_support_email_title_system", @"Prefix for system name/version in support emails"), currentDevice.systemName, currentDevice.systemVersion];

    NSString *v = [NSString stringWithFormat:@"%@: %@\n", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [emailBody appendString:v];

    [emailBody appendString:[self diskSpaceStatus]];

    return emailBody;
}

+ (NSString *)modelSpecifier {
    struct utsname systemInfo;

    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (NSString *)diskSpaceStatus {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:paths.lastObject error:nil];

    NSNumber *totalSize = dictionary[NSFileSystemSize];
    NSNumber *freeSize = dictionary[NSFileSystemFreeSize];

    NSByteCountFormatter *byteFormatter = [[NSByteCountFormatter alloc] init];

    byteFormatter.countStyle = NSByteCountFormatterCountStyleBinary;

    return [NSString stringWithFormat:@"%@: %@ / %@\n",
            NSLocalizedString(@"sumup_support_email_title_disk_space", @"Prefix for used/total disk space in support emails"),
            [byteFormatter stringFromByteCount:[freeSize longLongValue]],
            [byteFormatter stringFromByteCount:[totalSize longLongValue]]];
}

#if DEBUG

+ (void)assertLocalizedStrings {
    NSArray<NSString *> *stringKeys = [self allLocalizedStringKeys];

    NSBundle *bundle;
#if SUMUPUTILITIES_TESTS
    // When testing the framework itself in SumUpUtilities, the resources are not in the main bundle.
    bundle = [NSBundle bundleForClass:[self class]];
#else
    bundle = NSBundle.mainBundle;
#endif
    for (NSString *key in stringKeys) {
        NSString *localizedString = NSLocalizedStringFromTableInBundle(key, nil, bundle, nil);
        NSAssert(localizedString.length && ![localizedString isEqualToString:key], @"Missing localized string for %@", key);
    }
}

+ (NSArray<NSString *> *)allLocalizedStringKeys {
    return @[
             @"sumup_support_email_title_locale",
             @"sumup_support_email_title_device",
             @"sumup_support_email_title_system",
             @"sumup_support_email_title_disk_space",
             ];
}

#endif // DEBUG

@end

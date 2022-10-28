//
//  NSBundle+Resources.m
//  CircuitUI
//
//  Created by Anuraag Shakya on 05.07.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "NSBundle+Resources.h"
#import "CUIButton.h"

@implementation NSBundle (Resources)

+ (NSBundle *)cui_resourceBundle {
    NSBundle *rootBundle = [NSBundle bundleForClass:[CUIButton class]];
    // Align Bundle name with Podspec file for any changes
    NSString *pathForResourceBundle = [rootBundle pathForResource:@"CircuitUIResources" ofType:@"bundle"];
    return [NSBundle bundleWithPath:pathForResourceBundle];
}

@end

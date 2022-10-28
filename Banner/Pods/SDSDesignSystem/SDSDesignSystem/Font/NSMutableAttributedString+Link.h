//
//  NSMutableAttributedString+Link.h
//  SDSDesignSystem
//
//  Created by Hagi on 09.06.20.
//  Copyright © 2020 SumUp. All rights reserved.
//

#ifndef NSMutableAttributedString_Link_h
#define NSMutableAttributedString_Link_h

#import <Foundation/Foundation.h>
#import "SDSDesignPlatform.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (Link)

- (void)smp_addLink:(NSURL *)link forSubstring:(NSString *)linkText color:(__Color *)highlightColor;

@end

NS_ASSUME_NONNULL_END

#endif

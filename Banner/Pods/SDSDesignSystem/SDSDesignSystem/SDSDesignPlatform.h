//
//  SDSDesignPlatform.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 01.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSDesignPlatform_h
#define SDSDesignPlatform_h

#import "TargetConditionals.h"

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#define __Color UIColor
#define __Font UIFont
#else
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#define __Color NSColor
#define __Font NSFont
#endif

#endif

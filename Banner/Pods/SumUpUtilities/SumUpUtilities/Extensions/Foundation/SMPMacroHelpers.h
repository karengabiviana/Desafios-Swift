//
//  SMPMacroHelpers.h
//  SumUpUtilities
//
//  Created by Andras Kadar on 2/15/22.
//  Copyright © 2022 SumUp. All rights reserved.
//

static inline id SMPSafeCast(NSObject *obj, Class aClass) {
    return [obj isKindOfClass:aClass] ? obj : nil;
}

#if __has_feature(objc_arc_weak)
/// For when you need a weak reference of an object, example: `BBlockWeakObject(obj) wobj = obj;`
#define SMPBlockWeakObject(o) __weak __typeof__(o)
/// For when you need a weak reference to self, example: `BBlockWeakSelf wself = self;`
#define SMPBlockWeakSelf SMPBlockWeakObject(self)
#endif

#pragma mark -
#pragma mark HARDWARE/DEVICE INFO

#define SMP_UIDEVICE_IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define SMP_UIDEVICE_IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

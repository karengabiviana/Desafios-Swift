//
//  NSArray+Helpers.h
//  SumUpUtilities
//
//  Created by Felix Lamouroux on 20.12.13.
//  Copyright (c) 2013 iosphere GmbH. All rights reserved.
//

#import "NSArray+Helpers.h"

@implementation NSArray (Helpers)

- (id)objectAtIndexSafe:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }

    return [self objectAtIndex:index];
}

- (NSArray *)subarrayWithRangeSafe:(NSRange)range {
    return [self subarrayWithRange:NSIntersectionRange(NSMakeRange(0, self.count), range)];
}

- (NSArray *)smp_map:(NS_NOESCAPE id (^)(id))transform {
    NSParameterAssert(transform);

    NSMutableArray *mappedArray = [NSMutableArray arrayWithCapacity:self.count];
    for (id object in self) {
        [mappedArray addObject:transform(object)];
    }

    return [mappedArray copy];
}

- (NSArray *)smp_compactMap:(NS_NOESCAPE id  _Nullable (^)(id _Nonnull))transform {
    NSParameterAssert(transform);

    NSMutableArray *mappedArray = [NSMutableArray new];
    for (id object in self) {
        [mappedArray addObjectSafe:transform(object)];
    }

    return [mappedArray copy];
}

- (id)smp_firstWhere:(NS_NOESCAPE BOOL (^)(id _Nonnull))predicate {
    NSUInteger idx = [self smp_indexWhere:predicate];
    if (idx != NSNotFound) {
        return self[idx];
    }

    return nil;
}

- (NSArray *)smp_filter:(NS_NOESCAPE BOOL (^)(id obj))predicate {
    NSParameterAssert(predicate);

    NSMutableArray *mutableArray = [NSMutableArray new];
    for (id object in self) {
        if (predicate(object)) {
            [mutableArray addObject:object];
        }
    }
    return [mutableArray copy];
}

- (NSUInteger)smp_indexWhere:(BOOL (^)(id))predicate {
    NSParameterAssert(predicate);

    __block NSUInteger resultIndex = NSNotFound;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (predicate(obj)) {
            resultIndex = idx;
            *stop = YES;
        }
    }];

    return resultIndex;
}

@end

@implementation NSMutableArray (Helpers)

- (void)addObjectSafe:(nullable id)obj {
    if (!obj) {
        return;
    }

    [self addObject:obj];
}

- (void)addNonEmptyStringSafe:(nullable NSString *)str {
    if (str.length == 0) {
        return;
    }

    [self addObject:str];
}

- (void)setObject:(id)obj atIndexSafe:(NSUInteger)index {
    if (!obj || index > self.count) {
        return;
    }
    self[index] = obj;
}

@end

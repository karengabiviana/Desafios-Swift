//
//  NSArray+Helpers.h
//  SumUpUtilities
//
//  Created by Felix Lamouroux on 20.12.13.
//  Copyright (c) 2013 iosphere GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (Helpers)

/**
 *  Returns the object at a given index if index is within bounds
 *
 *  @param index an index that can be out of the receiver's bounds
 *
 *  @return the object at index or nil if not within bounds.
 */
- (nullable ObjectType)objectAtIndexSafe:(NSUInteger)index;

/**
 *  Returns a new array containing the receiving array’s elements that fall within the limits specified by a given range.
 *  Clamps the provided range to a valid range in the array's bounds.
 *  The count of the returned array may thus differ from the range's length.
 *
 *  @param range the range to extract
 *
 *  @return an (possibly empty) subarray
 */
- (nonnull NSArray *)subarrayWithRangeSafe:(NSRange)range;

/**
 Maps all objects of the array using a transform. Behaves like its Swift counterpart.

 @param transform Transform that accepts objects of the array and returns an object of any type. The transform must not be nil and also not return nil objects.
 @return New array containing the objects returned by the transform. The count will be the same as the original array.
 */
- (NSArray *)smp_map:(NS_NOESCAPE id (^)(ObjectType))transform;

/**
 Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.

 @param transform A block that accepts an element of this sequence as its argument and returns a nullable value.
 @return An array of the non-nil results of calling transform with each element of the sequence.
 */
- (NSArray *)smp_compactMap:(NS_NOESCAPE id _Nullable (^)(ObjectType))transform;

/**
 Returns an array containing, in order, the elements of the sequence that satisfy the given predicate.

 @param predicate A block that takes an element of the sequence as its argument and returns a boolean value indicating whether the element should be included in the returned array.
 @return An array of the elements that predicate allowed.
 */
- (NSArray *)smp_filter:(NS_NOESCAPE BOOL (^)(ObjectType))predicate;
/**
 Returns the first index of the array that matches the predicate or NSNotFound.

 @param predicate Predicate that accepts objects of the array and returns a boolean. The predicate must not be nil.
 @return The first index that matched the predicate or NSNotFound.
 */
- (NSUInteger)smp_indexWhere:(BOOL (^)(id))predicate;

/**
 Returns the first object of the array that matches the predicate or nil. Behaves like its Swift counterpart.

 @param predicate Predicate that accepts objects of the array and returns a boolean. The predicate must not be nil.
 @return The first object that matched the predicate or nil.
 */
- (nullable ObjectType)smp_firstWhere:(NS_NOESCAPE BOOL (^)(ObjectType))predicate;

@end

@interface NSMutableArray<ObjectType> (Helpers)

/**
 *  Adds obj if not nil
 *
 *  @param obj an object to add
 */
- (void)addObjectSafe:(nullable ObjectType)obj;


/**
 *  Adds str if not empty, that is length > 0
 *
 *  @param str a string to add if str.length > 0
 */
- (void)addNonEmptyStringSafe:(nullable NSString *)str;

/**
 *  Replaces the object at the given index in the array with the given object
 *  if index is valid and obj is not nil.
 */
- (void)setObject:(nullable ObjectType)obj atIndexSafe:(NSUInteger)index;


@end

NS_ASSUME_NONNULL_END

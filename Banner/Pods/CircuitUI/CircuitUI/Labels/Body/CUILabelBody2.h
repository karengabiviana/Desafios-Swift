//
//  CUILabelBody2.h
//  CircuitUI
//
//  Created by Florian Schliep on 12.02.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUILabel.h"
#import "CUILabelBodyVariant.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Label implementing the Body-2 style of Circuit UI Mobile.
 * Modify the `variant` property to use the different variants of the Body-2 style.
 */
NS_SWIFT_NAME(LabelBody2)
@interface CUILabelBody2 : CUILabel

@property (nonatomic) CUILabelBodyVariant variant;

/**
 * Adds a tappable link to the label at the location of the specified substring.
 * Setting the `text` property removes any previously added links.
 * Links can only be added to labels with the `CUILabelBodyVariantDefault` variant.
 * Setting the `variant` property to one not supporting links, any previously addeds link will be removed.
 *
 * @param url The URL of the link to be opened when tapped.
 * @param substring The substring to be highlighted that acts as link.
 */
- (void)addLinkWithURL:(NSURL *)url toSubstring:(NSString *)substring;

/**
 * Adds a tappable link to the label at the location of the specified substring.
 * Setting the `text` property removes any previously added links.
 * Links can only be added to labels with the `CUILabelBodyVariantDefault` variant.
 * Setting the `variant` property to one not supporting links, any previously addeds link will be removed.
 *
 * @param url The URL of the link to be opened when tapped.
 * @param substring The substring to be highlighted that acts as link.
 * @param onOpenURL The URL completion handler, which will be called once the link is opened.
 */
- (void)addLinkWithURL:(NSURL *)url toSubstring:(NSString *)substring onOpenURL:(nullable CUIURLCompletion)onOpenURL;

/**
 * Adds a tappable link to the label at the specified range.
 * Setting the `text` property removes any previously added links.
 * Links can only be added to labels with the `CUILabelBodyVariantDefault` variant.
 * Setting the `variant` property to one not supporting links, any previously addeds link will be removed.
 *
 * @param url The URL of the link to be opened when tapped.
 * @param range The range to be highlighted that acts as link.
 */
- (void)addLinkWithURL:(NSURL *)url toSubstringWithRange:(NSRange)range;

/**
 * Adds a tappable link to the label at the specified range.
 * Setting the `text` property removes any previously added links.
 * Links can only be added to labels with the `CUILabelBodyVariantDefault` variant.
 * Setting the `variant` property to one not supporting links, any previously addeds link will be removed.
 *
 * @param url The URL of the link to be opened when tapped.
 * @param range The range to be highlighted that acts as link.
 * @param onOpenURL The URL completion handler, which will be called once the link is opened.
 */
- (void)addLinkWithURL:(NSURL *)url toSubstringWithRange:(NSRange)range onOpenURL:(nullable CUIURLCompletion)onOpenURL;

@end

NS_ASSUME_NONNULL_END

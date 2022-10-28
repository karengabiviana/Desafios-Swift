//
//  CUILabel+Private.h
//  SDSDesignSystem
//
//  Created by Florian Schliep on 22.01.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUILabel.h"
#import "CUITextStyle.h"
#import "UILabel+SDS.h"

typedef NS_ENUM(NSInteger, CUILabelCase) {
    CUILabelCaseSentenceCase,
    CUILabelCaseUppercase
};

NS_ASSUME_NONNULL_BEGIN

@interface CUILabel (Private)

#pragma mark - Subclassing Hooks

/**
 * Implement this method to perform any initialization work that is
 * needed for the setup of the label.
 *
 * This is the preferred way over overriding initializers, because
 * the base class ensures `cui_commonInit` is called for all cases.
 */
- (void)cui_commonInit NS_REQUIRES_SUPER;

#pragma mark - Paragraph Styles

/**
 * Use this method to re-apply the paragraph style.
 *
 * Should be called whenever your subclasses' return
 * value of a property that affects the paragraph
 * style changes.
 */
- (void)cui_updateParagraphStyle;

/**
 * Override this to change the case of the text drawn by the label.
 *
 * Defaults to `.sentenceCase`.
 *
 * Affects the paragraph style.
 */
@property (nonatomic, readonly) CUILabelCase textCase;

/**
 * The distance in points between the bottom of one line fragment
 * and the top of the next.
 *
 * Affects the paragraph style.
 */
@property (nonatomic, readonly) CGFloat cui_lineSpacing;

/**
 * Indicator if the text needs to be underlined or not.
 *
 * Affects the paragraph style.
 */
@property (nonatomic, readonly) BOOL cui_isUnderlined;

/**
 * Indicator if the text needs to be striked through or not.
 *
 * Affects the paragraph style.
 */
@property (nonatomic, readonly) BOOL cui_isStrikethrough;

#pragma mark - Text Style Configuration

/**
 *  Use this method to re-apply the style returned in
 *  `createTextStyleConfiguration`.
 */
- (void)cui_updateTextStyle;

/**
 * This method will be called by the base class every time a new text
 * style configuration is needed.
 *
 * It is discouraged to perform any kind of caching in the implementation of this method and a new object should be returned on every call.
 *
 * Must be implemented by subclasses as the base class does not provide an implementation. Subclasses can call `cui_updateTextStyle` to indicate
 * that a new text style configuration needs to be applied (e.g., upon
 * variant changes).
 */
- (SDSTextStyleConfiguration *)createTextStyleConfiguration;

#pragma mark - Helpers

/**
 *  Subclasses that support links can use this helper to add a link
 *  to the first occurrence of the given substring, if it exists in
 *  the label's text.
 *
 *  Links have to be re-applied if the `text` property is changed
 *  or after calling `cui_updateParagraphStyle`.
 */
- (void)cui_addLinkWithURL:(NSURL *)url toSubstring:(NSString *)substring onOpenURL:(_Nullable CUIURLCompletion)onOpenURL;

/**
 *  Subclasses that support links can use this helper to add a link
 *  to the given range.
 *
 *  Links have to be re-applied if the `text` property is changed
 *  or after calling `cui_updateParagraphStyle`.
 */
- (void)cui_addLinkWithURL:(NSURL *)url toSubstringWithRange:(NSRange)range onOpenURL:(_Nullable CUIURLCompletion)onOpenURL;

@end

NS_ASSUME_NONNULL_END

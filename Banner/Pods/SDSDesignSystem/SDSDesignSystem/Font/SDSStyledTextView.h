//
//  SDSStyledTextView.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 01.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSStyledTextView_h
#define SDSStyledTextView_h

#import <UIKit/UIKit.h>
#import "SDSStyleSheet.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(StyledTextView)
@interface SDSStyledTextView : UITextView

/**
 *   Applies a text style configuration (font and colors) for the given text style as provided by the global
 *   stylesheet.
 *
 *   @note Fonts and colors will update automatically when the system's preferredContentSizeCategory changes (iOS 9 and
 *   later). If you subsequently manipulate the font or textColor properties manually, they will be overriden upon the
 *   next UIContentSizeCategoryDidChangeNotification. If you need to change the font/color manually, make sure to call
 *   stopObservingContentSizeCategoryChanges.
 *
 *   @param style The style to apply to the text view. It must be present in the global stylesheet to take effect.
 */
- (void)applyTextStyle:(SDSTextStyle)style NS_SWIFT_NAME(apply(textStyle:));

/**
 *   Applies a text style configuration (font and colors) for the given text style from the given stylesheet. See
 *   applyTextStyle: for notes and discussion.
 *
 *   @param style The style to apply to the text view. It must be present in the given stylesheet to take effect.
 *
 *   @param styleSheet The stylesheet defining the text style configuration.
 */
- (void)applyTextStyle:(SDSTextStyle)style fromStyleSheet:(SDSStyleSheet *)styleSheet NS_SWIFT_NAME(apply(textStyle:from:));

/**
 *   Stops the automatic text style updates in response to UIContentSizeCategoryDidChangeNotification after calling
 *   applyTextStyle:.
 */
- (void)stopObservingContentSizeCategoryChanges;

@end

NS_ASSUME_NONNULL_END

#endif

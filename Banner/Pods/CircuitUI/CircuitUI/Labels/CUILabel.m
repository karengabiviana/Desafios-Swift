//
//  CUILabel.m
//  CircuitUI
//
//  Created by Florian Schliep on 22.01.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUILabel+Private.h"
#import "CUISemanticColor.h"

@interface CUILabel () <UIGestureRecognizerDelegate>
@property (nonatomic) UITapGestureRecognizer *linkTapGestureRecognizer;
@property (nonatomic) NSMutableDictionary<NSString *, CUIURLCompletion> *urlCallbacks;
@end

@implementation CUILabel

@dynamic font;
@dynamic textColor;
@dynamic shadowColor;
@dynamic shadowOffset;
@dynamic attributedText;
@dynamic highlightedTextColor;
@dynamic highlighted;
@dynamic enabled;
@dynamic sds_textStyle;

#pragma mark - Instantiation

+ (instancetype)labelWithText:(NSString *)text {
    return [[self alloc] initWithText:text];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self cui_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self cui_commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self cui_commonInit];
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self cui_commonInit];
        self.text = text;
    }
    return self;
}

#pragma mark - Public API

- (NSAttributedString *)attributedString {
    NSMutableAttributedString *mutableAttrString = [[super attributedText] mutableCopy];
    [mutableAttrString addAttribute:NSFontAttributeName value:[super font] range:NSMakeRange(0, mutableAttrString.length)];
    return [mutableAttrString copy];
}

#pragma mark - Private API

- (void)cui_commonInit {
    NSAssert([self class] != CUILabel.class, @"CUILabel may not be used directly. Please use one of its subclasses.");
    [self cui_updateTextStyle];
}

- (void)cui_updateTextStyle {
    super.sds_textStyle = [self createTextStyleConfiguration];
}

- (void)cui_updateParagraphStyle {
    self.text = self.text;
}

- (BOOL)cui_isUnderlined {
    return NO;
}

- (BOOL)cui_isStrikethrough {
    return NO;
}

- (CUILabelCase)textCase {
    return CUILabelCaseSentenceCase;
}

- (void)setHyphenationFactor:(float)hyphenationFactor {
    _hyphenationFactor = hyphenationFactor;
    [self cui_updateParagraphStyle];
}

- (void)setText:(NSString *)text {
    [self setAttributedText:text ? [[NSAttributedString alloc] initWithString:text] : nil];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    NSMutableAttributedString *mutableCopy = [attributedText mutableCopy];

    switch (self.textCase) {
        case CUILabelCaseSentenceCase:
            break;

        case CUILabelCaseUppercase: {
            mutableCopy.mutableString.string = attributedText.string.uppercaseString;
            break;
        }
    }

    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineSpacing = self.cui_lineSpacing;
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.hyphenationFactor = self.hyphenationFactor;
    if (@available(iOS 14.0, *)) {
        paragraphStyle.lineBreakStrategy = self.lineBreakStrategy;
    }
    [mutableCopy addAttribute:NSParagraphStyleAttributeName value:[paragraphStyle copy] range:NSMakeRange(0, attributedText.length)];
    if (self.cui_isUnderlined) {
        [mutableCopy addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, attributedText.length)];
    }
    if (self.cui_isStrikethrough) {
        [mutableCopy addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, attributedText.length)];
    }

    [super setAttributedText:[mutableCopy copy]];
    [self disableLinkTapGestureIfNeeded];
}

#pragma mark - IB

- (void)awakeFromNib {
    [super awakeFromNib];
    [self cui_updateParagraphStyle];
}

#pragma mark - Link Handling

- (void)cui_addLinkWithURL:(NSURL *)url toSubstring:(NSString *)substring onOpenURL:(nullable CUIURLCompletion)onOpenURL {
    NSRange range = [self.text rangeOfString:substring];
    if (range.location == NSNotFound) {
        NSAssert(NO, @"Substring \"%@\" not found in \"%@\"", substring, self.text);
        return;
    }
    [self cui_addLinkWithURL:url toSubstringWithRange:range onOpenURL:onOpenURL];
}

- (void)cui_addLinkWithURL:(NSURL *)url toSubstringWithRange:(NSRange)range onOpenURL:(nullable CUIURLCompletion)onOpenURL {
    NSParameterAssert(url);

    NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithData:[url dataRepresentation] ofType:@"public.url"];
    NSMutableAttributedString *attributedString = [[self attributedText] mutableCopy];
    [attributedString addAttributes:@{
        NSAttachmentAttributeName: attachment,
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
        NSForegroundColorAttributeName: CUISemanticColor.tintColor
    } range:range];
    
    if (onOpenURL) {
        if (!self.urlCallbacks) {
            self.urlCallbacks = [NSMutableDictionary dictionary];
        }
        self.urlCallbacks[url.absoluteString] = [onOpenURL copy];
    }

    [super setAttributedText:[attributedString copy]];
    [self enableLinkTapGestureIfNeeded];
}

- (void)enableLinkTapGestureIfNeeded {
    if (self.linkTapGestureRecognizer) {
        return;
    }

    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTap:)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    self.linkTapGestureRecognizer = tapGesture;
}

- (void)disableLinkTapGestureIfNeeded {
    if (!self.linkTapGestureRecognizer) {
        return;
    }

    [self removeGestureRecognizer:self.linkTapGestureRecognizer];
    self.linkTapGestureRecognizer = nil;
    self.userInteractionEnabled = NO;
}

- (void)didRecognizeTap:(UITapGestureRecognizer *)sender {
    if (sender != self.linkTapGestureRecognizer) {
        NSAssert(NO, @"Unrecognized gesture recognizer: %@", sender);
        return;
    }

    NSURL *url = [self linkAtLocation:[sender locationInView:self]];
    if (url) {
        CUIURLCompletion urlCompletion = self.urlCallbacks[url.absoluteString];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:urlCompletion];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer != self.linkTapGestureRecognizer) {
        if ([super respondsToSelector:@selector(gestureRecognizerShouldBegin:)]) {
            return [super gestureRecognizerShouldBegin:gestureRecognizer];
        }

        return NO;
    }

    return [self linkAtLocation:[gestureRecognizer locationInView:self]] != nil;
}

#pragma mark - Link Detection

- (NSURL *)linkAtLocation:(CGPoint)location {
    NSInteger charIdx = [self characterIndexAtLocation:location];
    if (charIdx == NSNotFound) {
        return nil;
    }
    if (charIdx < 0 || charIdx > self.text.length-1) {
        NSAssert(NO, @"Invalid character index: %@", @(charIdx));
        return nil;
    }

    NSDictionary *attributes = [[self attributedText] attributesAtIndex:charIdx effectiveRange:nil];
    NSTextAttachment *attachment = attributes[NSAttachmentAttributeName];
    if (!attachment.contents) {
        return nil;
    }

    return [NSURL URLWithDataRepresentation:attachment.contents relativeToURL:nil];
}

- (NSInteger)characterIndexAtLocation:(CGPoint)location {
    NSTextStorage *storage = [self createTextStorageFromCurrentState];
    NSLayoutManager *layoutManager = storage.layoutManagers.firstObject;
    NSTextContainer *container = layoutManager.textContainers.firstObject;
    if (!layoutManager || !container) {
        NSAssert(NO, @"Missing layout manager or text container");
        return NSNotFound;
    }

    return (NSInteger)[layoutManager characterIndexForPoint:location inTextContainer:container fractionOfDistanceBetweenInsertionPoints:nil];
}

- (NSTextStorage *)createTextStorageFromCurrentState {
    CGSize size = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines].size;
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:size];
    container.lineFragmentPadding = 0;
    container.lineBreakMode = self.lineBreakMode;
    container.maximumNumberOfLines = self.numberOfLines;

    NSLayoutManager *layoutManager = [NSLayoutManager new];
    [layoutManager addTextContainer:container];

    NSMutableAttributedString *string = [[self attributedText] mutableCopy];
    // the attributed string we use doesn't have the font added explicitly, but the text storage needs to know it.
    [string addAttribute:NSFontAttributeName value:[super font] range:NSMakeRange(0, string.length)];

    // Workaround for SA-46857
    // https://sumupteam.atlassian.net/browse/SA-46857
    // This text storage created behaves strangely if the line break mode of the paragraph is not set to "word wrap" and breaks
    // the function that determines the character index of the tap location
    [string enumerateAttribute:NSParagraphStyleAttributeName
                       inRange:NSMakeRange(0, string.length)
                       options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                    usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        NSMutableParagraphStyle *mutableParagraphStyle = [(NSParagraphStyle *)value mutableCopy];
        mutableParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

        [string addAttribute:NSParagraphStyleAttributeName value:[mutableParagraphStyle copy] range:range];
    }];
    // End of workaround

    NSTextStorage *storage = [[NSTextStorage alloc] initWithAttributedString:[string copy]];
    [storage addLayoutManager:layoutManager];

    return storage;
}

@end

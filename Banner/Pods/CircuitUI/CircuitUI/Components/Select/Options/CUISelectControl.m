//
//  CUISelectControl.m
//  CircuitUI
//
//  Created by Marcel Voß on 06.09.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUISelectControl.h"

#import "CUILabelBody1.h"
#import "CUISemanticColor.h"
#import "CUIBaseSelectControl+Private.h"

@import SumUpUtilities;

@interface CUISelectControl () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation CUISelectControl

#pragma mark - Lifecycle

- (instancetype)initWithOptions:(NSArray<NSString *> *)options {
    self = [super init];
    if (self) {
        _options = [options copy];
        
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _selectedOptionIndex = NSNotFound;
}

#pragma mark - Overrides

- (CUISelectControlValidationResult * _Nullable)validationResult {
    if (!self.inputValidation) {
        return nil;
    }
    return self.inputValidation(self.selectedOptionIndex);
}

- (UIView *)createSelectionView {
    if (self.pickerView) {
        return self.pickerView;
    }

    self.pickerView = [UIPickerView new];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.backgroundColor = CUISemanticColor.backgroundColor;
    return self.pickerView;
}

- (NSString * _Nullable)selectedOptionText {
    return [self.options objectAtIndexSafe:self.selectedOptionIndex];
}

- (void)prepareToShowSelectionView {
    // set the picker view's selected row to our previously selected option
    NSInteger selectedRow = self.selectedOptionIndex == NSNotFound ? 0 : self.selectedOptionIndex;
    [self.inputView selectRow:selectedRow inComponent:0 animated:NO];
    [self didSelectOptionForIndex:selectedRow requiresCallback:self.continouslyUpdatesSelection];
}

- (void)prepareToHideSelectionView {
    NSInteger selectedRowIndex = [self.pickerView selectedRowInComponent:0];
    [self didSelectOptionForIndex:selectedRowIndex requiresCallback:YES];
}

#pragma mark - Setters/Getters

- (void)setOptions:(NSArray<NSString *> *)options {
    if ([_options isEqualToArray:options]) {
        return;
    }

    if (self.isFirstResponder) {
        NSAssert(NO, @"updating the available options is not allowed while the picker is first responder (i.e. in its expanded state).");
        return;
    }

    _options = [options copy];
}

- (void)setSelectedOptionIndex:(NSInteger)selectedOptionIndex {
    NSString *newOption = [self.options objectAtIndexSafe:selectedOptionIndex];
    if (!newOption && selectedOptionIndex != NSNotFound) {
        NSAssert(NO, @"the option does not exist within the options array.");
        return;
    }

    // we don't want to trigger a delegate call here upon setting the selected option,
    // as the integrator already knows that a new option has been selected/assigned.
    [self didSelectOptionForIndex:selectedOptionIndex requiresCallback:NO];
}

#pragma mark - Utilities

- (void)didSelectOptionForIndex:(NSInteger)rowIndex requiresCallback:(BOOL)requiresCallback {
    _selectedOptionIndex = rowIndex;

    [self validateSelectedOption];
    [self updateStyleForState];

    if (requiresCallback) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.options.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *safeTitleForRow = [self.options objectAtIndexSafe:row];
    if (!safeTitleForRow) {
        NSAssert(NO, @"invalid index for row.");
        return @"";
    }
    return safeTitleForRow;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self didSelectOptionForIndex:row requiresCallback:self.continouslyUpdatesSelection];
}

@end

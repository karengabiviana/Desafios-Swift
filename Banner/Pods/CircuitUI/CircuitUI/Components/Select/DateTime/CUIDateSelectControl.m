//
//  CUIDateSelectControl.m
//  CircuitUI
//
//  Created by Roman Utrata on 19.04.2022.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import "CUIDateSelectControl.h"

#import "CUIDateSelectControlConfiguration.h"
#import "CUILabelBody1.h"
#import "CUISemanticColor.h"
#import "CUIBaseSelectControl+Private.h"

@interface CUIDateSelectControl ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation CUIDateSelectControl

- (instancetype)initWithConfiguration:(CUIDateSelectControlConfiguration *)configuration {
    self = [super init];
    if (self) {
        _configuration = configuration;
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
    if (!_configuration) {
        _configuration = [CUIDateSelectControlConfiguration new];
    }

    [self configureDateFormatter];
    [self configureDatePicker];
}

#pragma mark - Setters/Getters

- (void)setSelectedDate:(NSDate *)selectedDate {
    [self didSetDate:selectedDate requiresCallback:NO];
}

- (void)setConfiguration:(CUIDateSelectControlConfiguration * _Nonnull)configuration {
    [self configureDateFormatter];
    [self configureDatePicker];
    [self didSetDate:_selectedDate requiresCallback:NO];
}

#pragma mark - Overrides

- (CUISelectControlValidationResult * _Nullable)validationResult {
    if (!self.inputValidation) {
        return nil;
    }
    return self.inputValidation(self.selectedDate);
}

- (UIView *)createSelectionView {
    if (self.datePicker) {
        return self.datePicker;
    }

    self.datePicker = [UIDatePicker new];
    self.datePicker.backgroundColor = CUISemanticColor.backgroundColor;
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    if (@available(iOS 13.4, *)) {
        self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    [self.datePicker addTarget:self action:@selector(valueDidChanged:) forControlEvents:UIControlEventValueChanged];
    return self.datePicker;
}

- (NSString * _Nullable)selectedOptionText {
    if (self.selectedDate) {
        return [self.dateFormatter stringFromDate:self.selectedDate];
    } else {
        return nil;
    }
}

- (void)prepareToShowSelectionView {
    if (_selectedDate == nil) {
        _selectedDate = [NSDate date];
    }
    self.datePicker.date = _selectedDate;
    [self didSetDate:_selectedDate requiresCallback:self.continouslyUpdatesSelection];
}

- (void)prepareToHideSelectionView {
    [self didSetDate:_selectedDate requiresCallback:YES];
}

#pragma mark - Actions

- (void)valueDidChanged:(UIDatePicker *)picker {
    [self didSetDate:picker.date requiresCallback:self.continouslyUpdatesSelection];
}

#pragma mark - Utilities

- (void)configureDateFormatter {
    self.dateFormatter = [NSDateFormatter new];
    self.dateFormatter.locale = _configuration.locale;
    self.dateFormatter.timeZone = _configuration.timeZone;
    self.dateFormatter.calendar = [NSCalendar calendarWithIdentifier:_configuration.locale.calendarIdentifier];
    [self.dateFormatter setLocalizedDateFormatFromTemplate:_configuration.dateFormatString];
}

- (void)configureDatePicker {
    _datePicker.locale = _configuration.locale;
    _datePicker.timeZone = _configuration.timeZone;
    _datePicker.calendar = [NSCalendar calendarWithIdentifier:_configuration.locale.calendarIdentifier];
    _datePicker.minimumDate = _configuration.minDate;
    _datePicker.maximumDate = _configuration.maxDate;
}

- (void)didSetDate:(NSDate *)date requiresCallback:(BOOL)requiresCallback {
    _selectedDate = [date copy];

    [self validateSelectedOption];
    [self updateStyleForState];

    if (requiresCallback) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end

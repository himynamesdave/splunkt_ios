//
//  BazarTextField.h
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BazarTextField : UITextField

@property (nonatomic) BOOL required;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *dateFormat;

@property (nonatomic, setter = setEmailField:) BOOL isEmailField;
@property (nonatomic, setter = setDateField:) BOOL isDateField;
@property (nonatomic, setter = setTimeField:) BOOL isTimeField;
@property (nonatomic, readonly) BOOL isValid;

- (BOOL) validate;
- (void) setDateFieldWithFormat:(NSString *)dateFormat;

/*
 Invoked when text field is disabled or input is invalid. Override to set your own tint or background color.
 */
- (void) setNeedsAppearance:(id)sender;

@end
ObjectiveModel
==============

An ActiveModel implementation for Objective-C.
ObjectiveModel validations were translated from [Ruby on Rails](https://github.com/rails/rails).


INSTALLATION
------------

ObjectiveModel is packaged as a static library. Standard TL;DR for using a static library in an Xcode project goes here.

	git clone https://github.com/f1337/ObjectiveModel.git



DOCUMENTATION
-------------

ObjectiveModel ships with an [appledoc](https://github.com/tomaz/appledoc) script which will create and install an Xcode docset for you.

	git clone https://github.com/f1337/ObjectiveModel.git
	cd ObjectiveModel
	./appledoc.sh

When the script has finished, the ObjectiveModel documentation will be available within Xcode's Organizer, just like Apple documentation.



USAGE EXAMPLES
--------------

To add ObjectiveModel validations to your model:

1. Import the ObjectiveModel headers:

		#import <ObjectiveModel/Validations.h>

2. Extend OMActiveModel:

		@interface Person : OMActiveModel @end

3. Implement one or more of the validation constraints described in the following examples.



<!-- BEGIN EXAMPLES -->

### OMAcceptanceValidator

Encapsulates the pattern of validating the acceptance of a terms of
service check box, "enter initials to accept", or similar agreement.

    @implementation Person
        + (void)initialize
        {
            [self validatesAcceptanceOf:@"termsOfService" withInitBlock:nil];
            [self validatesAcceptanceOf:@"EULA" withInitBlock:^(OMValidator *validator)
            {
                OMAcceptanceValidator *acceptanceValidator = (OMAcceptanceValidator *)validator;
                [acceptanceValidator setAccept:@"I agree."];
                [acceptanceValidator setMessage:@"must be abided"];
            }];
        }
    @end


(cf: <https://github.com/f1337/ObjectiveModel/tree/master/ObjectiveModel/Validations/AcceptanceValidator/OMActiveModel+AcceptanceValidation.h>)



### OMBlockValidator

Validates each property against the provided block.

    @implementation Person
        + (void)initialize
        {
            [self validatesEach:[NSArray arrayWithObjects:@"firstName", @"lastName", nil]
                      withBlock:^BOOL(OMBlockValidator *validator, OMActiveModel *model, NSObject *value)
            {
                NSString *stringValue = [value description];
                if ( [stringValue hasPrefix:@"z"] )
                {
                    [validator setMessage:@"starts with z."];
                    return NO;
                }
                else
                {
                    return YES;
                }
            }];
        }
    @end


(cf: <https://github.com/f1337/ObjectiveModel/tree/master/ObjectiveModel/Validations/BlockValidator/OMActiveModel+BlockValidation.h>)



### OMConfirmationValidator

Encapsulates the pattern of wanting to validate a password or email
address field with a confirmation.

    @implementation Person
        + (void)initialize
        {
            [self validatesConfirmationOf:[NSArray arrayWithObjects:@"userName", @"password", nil] withInitBlock:nil];
            [self validatesConfirmationOf:@"email" withInitBlock:^(OMValidator *validator)
            {
                [validator setMessage:@"should match confirmation"];
            }];
        }
    @end

NOTE: This check is performed only if `[person passwordConfirmation]` is not
`nil`. To require confirmation, make sure
to add a presence check for the confirmation attribute:

    [self validatesPresenceOf:@"passwordConfirmation" withInitBlock:^(OMValidator *validator)
    {
        [validator setShouldApplyValidationBlock:^BOOL (id person)
        {
            return [person hasChangedPassword];
        }];
    }];


(cf: <https://github.com/f1337/ObjectiveModel/tree/master/ObjectiveModel/Validations/ConfirmationValidator/OMActiveModel+ConfirmationValidation.h>)



### OMFormatValidator

Validates whether the value of the specified attribute is of the correct
format, according to the regular expression provided. You can require that 
the attribute matches the regular expression:

    @implementation Person
        + (void)initialize
        {
            [self validatesFormatOf:@"email" withInitBlock:^(OMValidator *validator)
            {
                OMFormatValidator *formatValidator = (OMFormatValidator *)validator;
                [formatValidator setPattern:@"\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z"];
            }];
        }
    @end

Alternately, you can require that the specified attribute does _not_
match the regular expression:

    @implementation Person
        + (void)initialize
        {
            [self validatesFormatOf:@"email" withInitBlock:^(OMValidator *validator)
            {
                OMFormatValidator *formatValidator = (OMFormatValidator *)validator;
                [formatValidator setPattern:@"NOSPAM"];
                [formatValidator setShouldMatchPattern:NO];
            }];
        }
    @end

You can also provide a block which will determine the regular
expression that will be used to validate the attribute.

    @implementation Person
        + (void)initialize
        {
            [self validatesFormatOf:@"nickName" withInitBlock:^(OMValidator *validator)
            {
                OMFormatValidator *formatValidator = (OMFormatValidator *)validator;
                [formatValidator setRegularExpressionBlock:^NSRegularExpression *(id person)
                {
                    NSString *pattern;

                    if ( [person isAdmin] )
                    {
                        pattern = @"\A[a-z0-9][a-z0-9_\-]*\Z";
                    }
                    else
                    {
                        pattern = @"\A[a-z][a-z0-9_\-]*\Z";
                    }

                    return [NSRegularExpression regularExpressionWithPattern:pattern
                                                                     options:NSRegularExpressionCaseInsensitive
                                                                       error:nil];
                }];
            }];
        }
    @end

Note: use `\A` and `\Z` to match the start and end of the
string, `^` and `$` match the start/end of a line.

cf. http://developer.apple.com/library/ios/documentation/Foundation/Reference/NSRegularExpression_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40009708-CH1-SW53


(cf: <https://github.com/f1337/ObjectiveModel/tree/master/ObjectiveModel/Validations/FormatValidator/OMActiveModel+FormatValidation.h>)



### OMMembershipValidator

Validates that the value of the specified attribute is *not* in a
particular enumerable object.

    @implementation Person
        + (void)initialize
        {
            [self validatesExclusionOf:@"username" withInitBlock:^(OMValidator *validator)
            {
                OMExclusionValidator *exclusionValidator = (OMExclusionValidator *)validator;
                [exclusionValidator setMessage:@"You don't belong here"];
                [exclusionValidator setCollection:[NSArray arrayWithObjects:@"admin", @"superuser", nil]];
            }];

            [self validatesExclusionOf:@"format" withInitBlock:^(OMValidator *validator)
            {
                OMExclusionValidator *exclusionValidator = (OMExclusionValidator *)validator;
                [exclusionValidator setMessage:@"extension %{value} is not allowed"];
                [exclusionValidator setCollection:[NSArray arrayWithObjects:@"mov", @"avi", nil]];
            }];

            [self validatesExclusionOf:@"password" withInitBlock:^(OMValidator *validator)
            {
                OMExclusionValidator *exclusionValidator = (OMExclusionValidator *)validator;
                [exclusionValidator setMessage:@"should not be the same as your username or first name"];
                [exclusionValidator setCollectionBlock:^id<OMCollection>(id person)
                {
                    return [NSArray arrayWithObjects:[person username], [person firstName], nil];
                }];
            }];

        }
    @end


(cf: <https://github.com/f1337/ObjectiveModel/tree/master/ObjectiveModel/Validations/InclusionValidator/OMActiveModel+MembershipValidation.h>)



### OMLengthValidator

Validates that the specified property or properties matches the length restrictions supplied.

    @implementation Person
        + (void)initialize
        {
            [self validatesLengthOf:@"firstName" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setMaximum:[NSNumber numberWithInt:30]];
            }];

            [self validatesLengthOf:@"lastName" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setMaximum:[NSNumber numberWithInt:30]];
                [lengthValidator setMessage:@"less than %{count} if you don't mind"]
            }];

            [self validatesLengthOf:@"fax" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setAllowNil:YES];
                [lengthValidator setMinimum:[NSNumber numberWithInt:7]];
                [lengthValidator setMaximum:[NSNumber numberWithInt:32]];
            }];

            [self validatesLengthOf:@"phone" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setAllowBlank:YES];
                [lengthValidator setMinimum:[NSNumber numberWithInt:7]];
                [lengthValidator setMaximum:[NSNumber numberWithInt:32]];
            }];

            [self validatesLengthOf:@"userName" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setMinimum:[NSNumber numberWithInt:6]];
                [lengthValidator setTooShortMessage:@"pick a longer name"];
                [lengthValidator setMaximum:[NSNumber numberWithInt:20]];
                [lengthValidator setTooLongMessage:@"pick a shorter name"];
            }];

            [self validatesLengthOf:@"zipCode" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setMinimum:[NSNumber numberWithInt:5]];
                [lengthValidator setTooShortMessage:@"please enter at least %{count} characters"];
            }];

            [self validatesLengthOf:@"smurfLeader" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setEquals:[NSNumber numberWithInt:4]];
                [lengthValidator setWrongLengthMessage:@"papa is spelled with 4 characters... don't play me."];
            }];

            [self validatesLengthOf:@"essay" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setMinimum:[NSNumber numberWithInt:100]];
                [lengthValidator setTooShortMessage:@"Your essay must be at least %{count} words."];
                [lengthValidator setTokenizer:^NSArray *(NSObject *value)
                {
                    NSString *stringValue = [value description];
                    return [stringValue componentsSeparatedByString:@" "];
                }];
            }];
        }
    @end


(cf: <https://github.com/f1337/ObjectiveModel/tree/master/ObjectiveModel/Validations/LengthValidator/OMActiveModel+LengthValidation.h>)



### OMNumericalityValidator

Validates whether the value of the specified property or properties is numeric.

    @implementation Person
        + (void)initialize
        {
            [self validatesNumericalityOf:@"age" withInitBlock:^void (OMValidator *validator)
            {
                OMNumericalityValidator *numericalityValidator = (OMNumericalityValidator *)validator;
                [numericalityValidator setGreaterThanOrEqualToNumber:[NSNumber numberWithInt:13]];
                [numericalityValidator setInteger:[NSNumber numberWithBool:YES]];
            }];
        }
    @end


(cf: <https://github.com/f1337/ObjectiveModel/tree/master/ObjectiveModel/Validations/NumericalityValidator/OMActiveModel+NumericalityValidation.h>)



### OMPresenceValidator

Validates that the specified attributes are not blank (as defined by NSObject+Blank).

    @implementation Person
        + (void)initialize
        {
            [self validatesPresenceOf:@"firstName" withInitBlock:nil];
        }
    @end

The firstName property must be defined for the object and it cannot be nil or blank.


(cf: <https://github.com/f1337/ObjectiveModel/tree/master/ObjectiveModel/Validations/PresenceValidator/OMActiveModel+PresenceValidation.h>)

<!-- END EXAMPLES -->



LICENSE
-------

Copyright © 2011-2012 Michael R. Fleet ([github.com/f1337](https://github.com/f1337)). Portions of this software were translated from Ruby on Rails ([github.com/rails/rails](https://github.com/rails/rails)), Copyright © 2004-2012 David Heinemeier Hansson.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

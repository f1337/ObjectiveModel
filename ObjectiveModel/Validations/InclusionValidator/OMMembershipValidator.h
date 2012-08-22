/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations/exclusion.rb
 * https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations/inclusion.rb
 * Ruby on Rails is Copyright © 2004-2012 David Heinemeier Hansson.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */



#import "OMValidator.h"
#import "OMActiveModel+MembershipValidation.h"



typedef enum
{
    OMMembershipValidationInclusion,
    OMMembershipValidationExclusion
} OMMembershipValidationMode;



@interface OMMembershipValidator : OMValidator



/*!
 * @brief An enumerable object of values for comparison.
 * @discussion The enumerable object must implement the <OMCollection> protocol.
 */
@property (retain) NSObject <OMCollection> *collection;



/*!
 * @brief An OMMembershipValidatorCollectionBlock which returns an enumerable
 * object of values for comparison.
 * @discussion The enumerable object must implement the <OMCollection> protocol.
 */
@property (copy) OMMembershipValidatorCollectionBlock collectionBlock;



/*!
 * @brief Specifies a custom error message.
 * @discussion If mode is set to OMMembershipValidationInclusion, the default
 * mesage is: "is not included in the list". If mode is set to
 * OMMembershipValidationExclusion, the default mesage is: "is reserved".
 */
- (NSString *)message;



/*!
 * @brief The validation mode: inclusion or exclusion.
 * @discussion OMMembershipValidationMode
 */
@property (assign) OMMembershipValidationMode mode;



@end

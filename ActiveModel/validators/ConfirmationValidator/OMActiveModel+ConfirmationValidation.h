/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
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



#import "OMActiveModel.h"



@interface OMActiveModel (ConfirmationValidation)



/*!
 * Encapsulates the pattern of wanting to validate a password or email
 * address field with a confirmation.
 *
 *   Model:
 *     class Person < ActiveRecord::Base
 *       validates_confirmation_of :user_name, :password
 *       validates_confirmation_of :email_address,
 *                                 :message => "should match confirmation"
 *     end
 *
 *   View:
 *     <%= password_field "person", "password" %>
 *     <%= password_field "person", "password_confirmation" %>
 *
 * The added +password_confirmation+ attribute is virtual; it exists only
 * as an in-memory attribute for validating the password. To achieve this,
 * the validation adds accessors to the model for the confirmation
 * attribute.
 *
 * NOTE: This check is performed only if +password_confirmation+ is not
 * +nil+. To require confirmation, make sure
 * to add a presence check for the confirmation attribute:
 *
 *   validates_presence_of :password_confirmation, :if => :password_changed?
 */
+ (void)validatesConfirmationOf:(NSObject *)properties withOptions:(NSDictionary *)options;



@end

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



@interface OMActiveModel (LengthValidation)



/*!
 *  Validates that the specified attribute matches the length restrictions supplied. Only one option can be used at a time:
 *  
 *    class Person < ActiveRecord::Base
 *      validates_length_of :first_name, :maximum => 30
 *      validates_length_of :last_name, :maximum => 30, :message => "less than 30 if you don't mind"
 *      validates_length_of :fax, :in => 7..32, :allow_nil => true
 *      validates_length_of :phone, :in => 7..32, :allow_blank => true
 *      validates_length_of :user_name, :within => 6..20, :too_long => "pick a shorter name", :too_short => "pick a longer name"
 *      validates_length_of :zip_code, :minimum => 5, :too_short => "please enter at least 5 characters"
 *      validates_length_of :smurf_leader, :is => 4, :message => "papa is spelled with 4 characters... don't play me."
 *      validates_length_of :essay, :minimum => 100, :too_short => "Your essay must be at least 100 words.",
 *                          :tokenizer => lambda { |str| str.scan(/\w+/) }
 *    end
 *  
 *  Configuration options:
 *  * <tt>:minimum</tt> - The minimum size of the attribute.
 *  * <tt>:maximum</tt> - The maximum size of the attribute.
 *  * <tt>:equals</tt> - The exact size of the attribute.
 *  * <tt>:within</tt> - A range specifying the minimum and maximum size of the
 *    attribute.
 *  * <tt>:too_long</tt> - The error message if the attribute goes over the
 *    maximum (default is: "is too long (maximum is %{count} characters)").
 *  * <tt>:too_short</tt> - The error message if the attribute goes under the
 *    minimum (default is: "is too short (min is %{count} characters)").
 *  * <tt>:wrong_length</tt> - The error message if using the <tt>:is</tt> method
 *    and the attribute is the wrong size (default is: "is the wrong length
 *    (should be %{count} characters)").
 *  * <tt>:message</tt> - The error message to use for a <tt>:minimum</tt>,
 *    <tt>:maximum</tt>, or <tt>:is</tt> violation. An alias of the appropriate
 *    <tt>too_long</tt>/<tt>too_short</tt>/<tt>wrong_length</tt> message.
 *  * <tt>:tokenizer</tt> - Specifies how to split up the attribute string.
 *    (e.g. <tt>:tokenizer => lambda {|str| str.scan(/\w+/)}</tt> to count words
 *    as in above example). Defaults to <tt>lambda{ |value| value.split(//) }</tt>
 *    which counts individual characters.
 */
+ (void)validatesLengthOf:(NSObject *)properties withOptions:(NSDictionary *)options;
+ (void)validatesSizeOf:(NSObject *)properties withOptions:(NSDictionary *)options;



@end

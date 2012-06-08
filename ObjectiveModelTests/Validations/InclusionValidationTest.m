/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/test/cases/validations/inclusion_validation_test.rb
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



#import "InclusionValidationTest.h"
#import <ObjectiveModel/Validations.h>



@implementation InclusionValidationTest



@synthesize topic = _topic;



#pragma mark - SETUP/TEARDOWN



- (void)setUp
{
    [super setUp];
    [self setTopic:[[Topic alloc] init]];
}



- (void)tearDown
{
    [self setTopic:nil];
    [Topic removeAllValidations];
    [super tearDown];
}



#pragma mark - TRANSLITERATED RoR TESTS



// def test_validates_inclusion_of_range
//   Topic.validates_inclusion_of( :title, :in => 'aaa'..'bbb' )
//   assert Topic.new("title" => "bbc", "content" => "abc").invalid?
//   assert Topic.new("title" => "aa", "content" => "abc").invalid?
//   assert Topic.new("title" => "aaa", "content" => "abc").valid?
//   assert Topic.new("title" => "abc", "content" => "abc").valid?
//   assert Topic.new("title" => "bbb", "content" => "abc").valid?
// end
// 



- (void)testValidatesInclusionOf
{
    //Topic.validates_inclusion_of( :title, :in => %w( a b c d e f g ) )
    [Topic validatesInclusionOf:@"title" withOptions:nil inArray:[NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", nil]];

    //assert Topic.new("title" => "a!", "content" => "abc").invalid?
    [_topic setTitle:@"a!"];
    [_topic setContent:@"abc"];
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];
    //assert Topic.new("title" => "a b", "content" => "abc").invalid?
    [_topic setTitle:@"a b"];
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];
    //assert Topic.new("title" => nil, "content" => "def").invalid?
    [_topic setTitle:nil];
    [_topic setContent:@"def"];
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];

    //t = Topic.new("title" => "a", "content" => "I know you are but what am I?")
    [_topic setTitle:@"a"];
    [_topic setContent:@"I know you are but what am I?"];
    //assert t.valid?
    [self assertModelIsValid:_topic];
    //t.title = "uhoh"
    //assert t.invalid?
    //assert t.errors[:title].any?
    //assert_equal ["is not included in the list"], t.errors[:title]
    //
    //assert_raise(ArgumentError) { Topic.validates_inclusion_of( :title, :in => nil ) }
    //assert_raise(ArgumentError) { Topic.validates_inclusion_of( :title, :in => 0) }
    //
    //assert_nothing_raised(ArgumentError) { Topic.validates_inclusion_of( :title, :in => "hi!" ) }
    //assert_nothing_raised(ArgumentError) { Topic.validates_inclusion_of( :title, :in => {} ) }
    //assert_nothing_raised(ArgumentError) { Topic.validates_inclusion_of( :title, :in => [] ) }
}



// def test_validates_inclusion_of_with_allow_nil
//   Topic.validates_inclusion_of( :title, :in => %w( a b c d e f g ), :allow_nil => true )
// 
//   assert Topic.new("title" => "a!", "content" => "abc").invalid?
//   assert Topic.new("title" => "",   "content" => "abc").invalid?
//   assert Topic.new("title" => nil,  "content" => "abc").valid?
// end
// 
// def test_validates_inclusion_of_with_formatted_message
//   Topic.validates_inclusion_of( :title, :in => %w( a b c d e f g ), :message => "option %{value} is not in the list" )
// 
//   assert Topic.new("title" => "a", "content" => "abc").valid?
// 
//   t = Topic.new("title" => "uhoh", "content" => "abc")
//   assert t.invalid?
//   assert t.errors[:title].any?
//   assert_equal ["option uhoh is not in the list"], t.errors[:title]
// end
// 
// def test_validates_inclusion_of_for_ruby_class
//   Person.validates_inclusion_of :karma, :in => %w( abe monkey )
// 
//   p = Person.new
//   p.karma = "Lifo"
//   assert p.invalid?
// 
//   assert_equal ["is not included in the list"], p.errors[:karma]
// 
//   p.karma = "monkey"
//   assert p.valid?
// ensure
//   Person.reset_callbacks(:validate)
// end
// 
// def test_validates_inclusion_of_with_lambda
//   Topic.validates_inclusion_of :title, :in => lambda{ |topic| topic.author_name == "sikachu" ? %w( monkey elephant ) : %w( abe wasabi ) }
// 
//   t = Topic.new
//   t.title = "wasabi"
//   t.author_name = "sikachu"
//   assert t.invalid?
// 
//   t.title = "elephant"
//   assert t.valid?
// end

@end
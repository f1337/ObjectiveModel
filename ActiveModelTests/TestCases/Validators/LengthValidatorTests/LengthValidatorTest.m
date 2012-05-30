/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/test/cases/validations/length_validation_test.rb
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



#import "LengthValidatorTest.h"
#import "OMLengthValidator.h"
#import "Topic.h"



@implementation LengthValidatorTest



#pragma mark - SETUP/TEARDOWN



- (void)tearDown
{
    [Topic removeAllValidations];
    [super tearDown];
}



#pragma mark - TRANSLITERATED RoR TESTS



- (void)testValidatesLengthWithAllowNil
{
    // Topic.validates_length_of( :title, :is => 5, :allow_nil => true )
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"equals",
                              [NSNumber numberWithBool:YES], @"allowNil",
                              nil]];

    Topic *topic;
    // assert Topic.new("title" => "ab").invalid?
    topic = [[Topic alloc] init];
    [topic setTitle:@"ab"];
    [self assertModelIsInvalid:topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];
    [topic release];

    // assert Topic.new("title" => "").invalid?
    topic = [[Topic alloc] init];
    [topic setTitle:@""];
    [self assertModelIsInvalid:topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];
    [topic release];
    
    // assert Topic.new("title" => nil).valid?
    topic = [[Topic alloc] init];
    [topic setTitle:nil];
    [self assertModelIsValid:topic];
    [topic release];
    
    topic = [[Topic alloc] init];
    [self assertModelIsValid:topic];
    [topic release];
    
    // assert Topic.new("title" => "abcde").valid?
    topic = [[Topic alloc] init];
    [topic setTitle:@"abcde"];
    [self assertModelIsValid:topic];
    [topic release];
}



- (void)testValidatesLengthWithAllowBlank
{
    // Topic.validates_length_of( :title, :is => 5, :allow_blank => true )
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"equals",
                              [NSNumber numberWithBool:YES], @"allowBlank",
                              nil]];
    
    Topic *topic;
    // assert Topic.new("title" => "ab").invalid?
    topic = [[Topic alloc] init];
    [topic setTitle:@"ab"];
    [self assertModelIsInvalid:topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];
    [topic release];

    // assert Topic.new("title" => "").valid?
    topic = [[Topic alloc] init];
    [topic setTitle:@""];
    [self assertModelIsValid:topic];
    [topic release];

    // assert Topic.new("title" => nil).valid?
    topic = [[Topic alloc] init];
    [topic setTitle:nil];
    [self assertModelIsValid:topic];
    [topic release];
    
    topic = [[Topic alloc] init];
    [self assertModelIsValid:topic];
    [topic release];

    // assert Topic.new("title" => "abcde").valid?
    topic = [[Topic alloc] init];
    [topic setTitle:@"abcde"];
    [self assertModelIsValid:topic];
    [topic release];
}



- (void)testValidatesLengthUsingMinimum
{
    // Topic.validates_length_of :title, :minimum => 5
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"minimum",
                              nil]];

    // t = Topic.new("title" => "valid", "content" => "whatever")
    Topic *topic = [[Topic alloc] init];
    [topic setTitle:@"valid"];
    [topic setContent:@"whatever"];
    // assert t.valid?
    [self assertModelIsValid:topic];
    [topic release];

    // t.title = "not"
    [topic setTitle:@"not"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["is too short (minimum is 5 characters)"], t.errors[:title]
    [self assertModelIsInvalid:topic withErrorMessage:@"is too short (minimum is 5 characters)" forKeys:[NSArray arrayWithObject:@"title"]];

    // t.title = ""
//assert t.invalid?
//assert t.errors[:title].any?
//assert_equal ["is too short (minimum is 5 characters)"], t.errors[:title]
//
//t.title = nil
//assert t.invalid?
//assert t.errors[:title].any?
//assert_equal ["is too short (minimum is 5 characters)"], t.errors["title"]
}



/* 
 def test_validates_length_of_using_maximum_should_allow_nil
 Topic.validates_length_of :title, :maximum => 10
 t = Topic.new
 assert t.valid?
 end
 
 def test_optionally_validates_length_of_using_minimum
 Topic.validates_length_of :title, :minimum => 5, :allow_nil => true
 
 t = Topic.new("title" => "valid", "content" => "whatever")
 assert t.valid?
 
 t.title = nil
 assert t.valid?
 end
 
 def test_validates_length_of_using_maximum
 Topic.validates_length_of :title, :maximum => 5
 
 t = Topic.new("title" => "valid", "content" => "whatever")
 assert t.valid?
 
 t.title = "notvalid"
 assert t.invalid?
 assert t.errors[:title].any?
 assert_equal ["is too long (maximum is 5 characters)"], t.errors[:title]
 
 t.title = ""
 assert t.valid?
 end
 
 def test_optionally_validates_length_of_using_maximum
 Topic.validates_length_of :title, :maximum => 5, :allow_nil => true
 
 t = Topic.new("title" => "valid", "content" => "whatever")
 assert t.valid?
 
 t.title = nil
 assert t.valid?
 end
 
 def test_validates_length_of_using_within
 Topic.validates_length_of(:title, :content, :within => 3..5)
 
 t = Topic.new("title" => "a!", "content" => "I'm ooooooooh so very long")
 assert t.invalid?
 assert_equal ["is too short (minimum is 3 characters)"], t.errors[:title]
 assert_equal ["is too long (maximum is 5 characters)"], t.errors[:content]
 
 t.title = nil
 t.content = nil
 assert t.invalid?
 assert_equal ["is too short (minimum is 3 characters)"], t.errors[:title]
 assert_equal ["is too short (minimum is 3 characters)"], t.errors[:content]
 
 t.title = "abe"
 t.content  = "mad"
 assert t.valid?
 end
 
 def test_validates_length_of_using_within_with_exclusive_range
 Topic.validates_length_of(:title, :within => 4...10)
 
 t = Topic.new("title" => "9 chars!!")
 assert t.valid?
 
 t.title = "Now I'm 10"
 assert t.invalid?
 assert_equal ["is too long (maximum is 9 characters)"], t.errors[:title]
 
 t.title = "Four"
 assert t.valid?
 end
 
 def test_optionally_validates_length_of_using_within
 Topic.validates_length_of :title, :content, :within => 3..5, :allow_nil => true
 
 t = Topic.new('title' => 'abc', 'content' => 'abcd')
 assert t.valid?
 
 t.title = nil
 assert t.valid?
 end
 
 def test_validates_length_of_using_is
 Topic.validates_length_of :title, :is => 5
 
 t = Topic.new("title" => "valid", "content" => "whatever")
 assert t.valid?
 
 t.title = "notvalid"
 assert t.invalid?
 assert t.errors[:title].any?
 assert_equal ["is the wrong length (should be 5 characters)"], t.errors[:title]
 
 t.title = ""
 assert t.invalid?
 
 t.title = nil
 assert t.invalid?
 end
 
 def test_optionally_validates_length_of_using_is
 Topic.validates_length_of :title, :is => 5, :allow_nil => true
 
 t = Topic.new("title" => "valid", "content" => "whatever")
 assert t.valid?
 
 t.title = nil
 assert t.valid?
 end
 
 def test_validates_length_of_using_bignum
 bigmin = 2 ** 30
 bigmax = 2 ** 32
 bigrange = bigmin...bigmax
 assert_nothing_raised do
 Topic.validates_length_of :title, :is => bigmin + 5
 Topic.validates_length_of :title, :within => bigrange
 Topic.validates_length_of :title, :in => bigrange
 Topic.validates_length_of :title, :minimum => bigmin
 Topic.validates_length_of :title, :maximum => bigmax
 end
 end
 
 def test_validates_length_of_nasty_params
 assert_raise(ArgumentError) { Topic.validates_length_of(:title, :is => -6) }
 assert_raise(ArgumentError) { Topic.validates_length_of(:title, :within => 6) }
 assert_raise(ArgumentError) { Topic.validates_length_of(:title, :minimum => "a") }
 assert_raise(ArgumentError) { Topic.validates_length_of(:title, :maximum => "a") }
 assert_raise(ArgumentError) { Topic.validates_length_of(:title, :within => "a") }
 assert_raise(ArgumentError) { Topic.validates_length_of(:title, :is => "a") }
 end
 
 def test_validates_length_of_custom_errors_for_minimum_with_message
 Topic.validates_length_of( :title, :minimum => 5, :message => "boo %{count}" )
 t = Topic.new("title" => "uhoh", "content" => "whatever")
 assert t.invalid?
 assert t.errors[:title].any?
 assert_equal ["boo 5"], t.errors[:title]
 end
 
 def test_validates_length_of_custom_errors_for_minimum_with_too_short
 Topic.validates_length_of( :title, :minimum => 5, :too_short => "hoo %{count}" )
 t = Topic.new("title" => "uhoh", "content" => "whatever")
 assert t.invalid?
 assert t.errors[:title].any?
 assert_equal ["hoo 5"], t.errors[:title]
 end
 
 def test_validates_length_of_custom_errors_for_maximum_with_message
 Topic.validates_length_of( :title, :maximum => 5, :message => "boo %{count}" )
 t = Topic.new("title" => "uhohuhoh", "content" => "whatever")
 assert t.invalid?
 assert t.errors[:title].any?
 assert_equal ["boo 5"], t.errors[:title]
 end
 
 def test_validates_length_of_custom_errors_for_in
 Topic.validates_length_of(:title, :in => 10..20, :message => "hoo %{count}")
 t = Topic.new("title" => "uhohuhoh", "content" => "whatever")
 assert t.invalid?
 assert t.errors[:title].any?
 assert_equal ["hoo 10"], t.errors["title"]
 
 t = Topic.new("title" => "uhohuhohuhohuhohuhohuhohuhohuhoh", "content" => "whatever")
 assert t.invalid?
 assert t.errors[:title].any?
 assert_equal ["hoo 20"], t.errors["title"]
 end
 
 def test_validates_length_of_custom_errors_for_maximum_with_too_long
 Topic.validates_length_of( :title, :maximum => 5, :too_long => "hoo %{count}" )
 t = Topic.new("title" => "uhohuhoh", "content" => "whatever")
 assert t.invalid?
 assert t.errors[:title].any?
 assert_equal ["hoo 5"], t.errors["title"]
 end
 
 def test_validates_length_of_custom_errors_for_both_too_short_and_too_long
 Topic.validates_length_of :title, :minimum => 3, :maximum => 5, :too_short => 'too short', :too_long => 'too long'
 
 t = Topic.new(:title => 'a')
 assert t.invalid?
 assert t.errors[:title].any?
 assert_equal ['too short'], t.errors['title']
 
 t = Topic.new(:title => 'aaaaaa')
 assert t.invalid?
 assert t.errors[:title].any?
 assert_equal ['too long'], t.errors['title']
 end
 
 def test_validates_length_of_custom_errors_for_is_with_message
 Topic.validates_length_of( :title, :is => 5, :message => "boo %{count}" )
 t = Topic.new("title" => "uhohuhoh", "content" => "whatever")
 assert t.invalid?
 assert t.errors[:title].any?
 assert_equal ["boo 5"], t.errors["title"]
 end
 
 def test_validates_length_of_custom_errors_for_is_with_wrong_length
 Topic.validates_length_of( :title, :is => 5, :wrong_length => "hoo %{count}" )
 t = Topic.new("title" => "uhohuhoh", "content" => "whatever")
 assert t.invalid?
 assert t.errors[:title].any?
 assert_equal ["hoo 5"], t.errors["title"]
 end
 
 def test_validates_length_of_using_minimum_utf8
 Topic.validates_length_of :title, :minimum => 5
 
 t = Topic.new("title" => "一二三四五", "content" => "whatever")
 assert t.valid?
 
 t.title = "一二三四"
 assert t.invalid?
 assert t.errors[:title].any?
 assert_equal ["is too short (minimum is 5 characters)"], t.errors["title"]
 end
 
 def test_validates_length_of_using_maximum_utf8
 Topic.validates_length_of :title, :maximum => 5
 
 t = Topic.new("title" => "一二三四五", "content" => "whatever")
 assert t.valid?
 
 t.title = "一二34五六"
 assert t.invalid?
 assert t.errors[:title].any?
 assert_equal ["is too long (maximum is 5 characters)"], t.errors["title"]
 end
 
 def test_validates_length_of_using_within_utf8
 Topic.validates_length_of(:title, :content, :within => 3..5)
 
 t = Topic.new("title" => "一二", "content" => "12三四五六七")
 assert t.invalid?
 assert_equal ["is too short (minimum is 3 characters)"], t.errors[:title]
 assert_equal ["is too long (maximum is 5 characters)"], t.errors[:content]
 t.title = "一二三"
 t.content  = "12三"
 assert t.valid?
 end
 
 def test_optionally_validates_length_of_using_within_utf8
 Topic.validates_length_of :title, :within => 3..5, :allow_nil => true
 
 t = Topic.new(:title => "一二三四五")
 assert t.valid?, t.errors.inspect
 
 t = Topic.new(:title => "一二三")
 assert t.valid?, t.errors.inspect
 
 t.title = nil
 assert t.valid?, t.errors.inspect
 end
 
 def test_validates_length_of_using_is_utf8
 Topic.validates_length_of :title, :is => 5
 
 t = Topic.new("title" => "一二345", "content" => "whatever")
 assert t.valid?
 
 t.title = "一二345六"
 assert t.invalid?
 assert t.errors[:title].any?
 assert_equal ["is the wrong length (should be 5 characters)"], t.errors["title"]
 end
 
 def test_validates_length_of_with_block
 Topic.validates_length_of :content, :minimum => 5, :too_short => "Your essay must be at least %{count} words.",
 :tokenizer => lambda {|str| str.scan(/\w+/) }
 t = Topic.new(:content => "this content should be long enough")
 assert t.valid?
 
 t.content = "not long enough"
 assert t.invalid?
 assert t.errors[:content].any?
 assert_equal ["Your essay must be at least 5 words."], t.errors[:content]
 end
 
 def test_validates_length_of_for_fixnum
 Topic.validates_length_of(:approved, :is => 4)
 
 t = Topic.new("title" => "uhohuhoh", "content" => "whatever", :approved => 1)
 assert t.invalid?
 assert t.errors[:approved].any?
 
 t = Topic.new("title" => "uhohuhoh", "content" => "whatever", :approved => 1234)
 assert t.valid?
 end
 
 def test_validates_length_of_for_ruby_class
 Person.validates_length_of :karma, :minimum => 5
 
 p = Person.new
 p.karma = "Pix"
 assert p.invalid?
 
 assert_equal ["is too short (minimum is 5 characters)"], p.errors[:karma]
 
 p.karma = "The Smiths"
 assert p.valid?
 ensure
 Person.reset_callbacks(:validate)
 end
 
 def test_validates_length_of_for_infinite_maxima
 Topic.validates_length_of(:title, :within => 5..Float::INFINITY)
 
 t = Topic.new("title" => "1234")
 assert t.invalid?
 assert t.errors[:title].any?
 
 t.title = "12345"
 assert t.valid?
 
 Topic.validates_length_of(:author_name, :maximum => Float::INFINITY)
 
 assert t.valid?
 
 t.author_name = "A very long author name that should still be valid." * 100
 assert t.valid?
 end
*/
@end

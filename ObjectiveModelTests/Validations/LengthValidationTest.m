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



#import "LengthValidationTest.h"
#import <ObjectiveModel/Validations.h>



@implementation LengthValidationTest



@synthesize topic = _topic;


#pragma mark - SETUP/TEARDOWN



- (void)setUp
{
    [super setUp];
    [self setTopic:[[Topic alloc] init]];
}



- (void)tearDown
{
    [_topic release];
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
    [_topic setTitle:@"valid"];
    [_topic setContent:@"whatever"];
    // assert t.valid?
    [self assertModelIsValid:_topic];

    // t.title = "not"
    [_topic setTitle:@"not"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["is too short (minimum is 5 characters)"], t.errors[:title]
    [self assertModelIsInvalid:_topic withErrorMessage:@"is too short (minimum is 5 characters)" forKeys:[NSArray arrayWithObject:@"title"]];

    // t.title = ""
    [_topic setTitle:@""];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["is too short (minimum is 5 characters)"], t.errors[:title]
    [self assertModelIsInvalid:_topic withErrorMessage:@"is too short (minimum is 5 characters)" forKeys:[NSArray arrayWithObject:@"title"]];

    // t.title = nil
    [_topic setTitle:nil];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["is too short (minimum is 5 characters)"], t.errors["title"]
    [self assertModelIsInvalid:_topic withErrorMessage:@"is too short (minimum is 5 characters)" forKeys:[NSArray arrayWithObject:@"title"]];
}



- (void)testValidatesLengthUsingMaximumShouldAllowNil
{
    // Topic.validates_length_of :title, :maximum => 10
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:10], @"maximum",
                              nil]];

    // t = Topic.new
    Topic *topic = [[Topic alloc] init];

    // assert t.valid?
    [self assertModelIsValid:topic];

    [topic release];
}



- (void)testOptionallyValidatesLengthUsingMinimum
{
    // Topic.validates_length_of :title, :minimum => 5, :allow_nil => true
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"minimum",
                              @"Y", @"allowNil",
                              nil]];

    // t = Topic.new("title" => "valid", "content" => "whatever")
    [_topic setTitle:@"valid"];
    [_topic setContent:@"whatever"];

    // assert t.valid?
    [self assertModelIsValid:_topic];

    // t.title = nil
    [_topic setTitle:nil];
    // assert t.valid?
    [self assertModelIsValid:_topic];
}



- (void)testValidatesLengthUsingMaximum
{
    // Topic.validates_length_of :title, :maximum => 5
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"maximum",
                              nil]];

    // t = Topic.new("title" => "valid", "content" => "whatever")
    [_topic setTitle:@"valid"];
    [_topic setContent:@"whatever"];
    // assert t.valid?
    [self assertModelIsValid:_topic];

    // t.title = "notvalid"
    [_topic setTitle:@"notvalid"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["is too long (maximum is 5 characters)"], t.errors[:title]
    [self assertModelIsInvalid:_topic withErrorMessage:@"is too long (maximum is 5 characters)" forKeys:[NSArray arrayWithObject:@"title"]];

    // t.title = ""
    [_topic setTitle:@""];
    // assert t.valid?
    [self assertModelIsValid:_topic];
}



-(void)testOptionallyValidatesLengthUsingMaximum
{
    // Topic.validates_length_of :title, :maximum => 5, :allow_nil => true
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"maximum",
                              @"Y", @"allowNil",
                              nil]];

    // t = Topic.new("title" => "valid", "content" => "whatever")
    [_topic setTitle:@"valid"];
    [_topic setContent:@"whatever"];
    // assert t.valid?
    [self assertModelIsValid:_topic];

    // t.title = nil
    [_topic setTitle:nil];
    // assert t.valid?
    [self assertModelIsValid:_topic];
}



- (void)testValidatesLengthUsingMinimumAndMaximum
{
    // Topic.validates_length_of(:title, :content, :within => 3..5)
    [Topic validatesLengthOf:[NSArray arrayWithObjects:@"title", @"content", nil]
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:3], @"minimum",
                              [NSNumber numberWithInt:5], @"maximum",
                              nil]];

    // t = Topic.new("title" => "a!", "content" => "I'm ooooooooh so very long")
    [_topic setTitle:@"a!"];
    [_topic setContent:@"I'm ooooooooh so very long"];
    // assert t.invalid?
    // assert_equal ["is too short (minimum is 3 characters)"], t.errors[:title]
    [self assertModelIsInvalid:_topic withErrorMessage:@"is too short (minimum is 3 characters)" forKeys:[NSArray arrayWithObject:@"title"]];
    // assert_equal ["is too long (maximum is 5 characters)"], t.errors[:content]
    [self assertModelIsInvalid:_topic withErrorMessage:@"is too long (maximum is 5 characters)" forKeys:[NSArray arrayWithObject:@"content"]];

    // t.title = nil
    [_topic setTitle:nil];
    // t.content = nil
    [_topic setContent:nil];
    // assert t.invalid?
    // assert_equal ["is too short (minimum is 3 characters)"], t.errors[:title]
    [self assertModelIsInvalid:_topic withErrorMessage:@"is too short (minimum is 3 characters)" forKeys:[NSArray arrayWithObject:@"title"]];
    // assert_equal ["is too short (minimum is 3 characters)"], t.errors[:content]
    [self assertModelIsInvalid:_topic withErrorMessage:@"is too short (minimum is 3 characters)" forKeys:[NSArray arrayWithObject:@"content"]];

    // t.title = "abe"
    [_topic setTitle:@"abe"];
    // t.content  = "mad"
    [_topic setContent:@"mad"];
    // assert t.valid?
    [self assertModelIsValid:_topic];
}



- (void)testOptionallyValidatesLengthUsingMinimumAndMaximum
{
    // Topic.validates_length_of :title, :content, :within => 3..5, :allow_nil => true
    [Topic validatesLengthOf:[NSArray arrayWithObjects:@"title", @"content", nil]
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:3], @"minimum",
                              [NSNumber numberWithInt:5], @"maximum",
                              @"Y", @"allowNil",
                              nil]];

    // t = Topic.new('title' => 'abc', 'content' => 'abcd')
    [_topic setTitle:@"abc"];
    [_topic setContent:@"abcd"];
    // assert t.valid?
    [self assertModelIsValid:_topic];

    // t.title = nil
    [_topic setTitle:nil];
    // assert t.valid?
    [self assertModelIsValid:_topic];
}



- (void)testValidatesLengthUsingEquals
{
    // Topic.validates_length_of :title, :is => 5
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"equals",
                              nil]];

    // t = Topic.new("title" => "valid", "content" => "whatever")
    [_topic setTitle:@"valid"];
    [_topic setContent:@"whatever"];
    // assert t.valid?
    [self assertModelIsValid:_topic];

    // t.title = "notvalid"
    [_topic setTitle:@"notvalid"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["is the wrong length (should be 5 characters)"], t.errors[:title]
    [self assertModelIsInvalid:_topic withErrorMessage:@"is the wrong length (should be 5 characters)" forKeys:[NSArray arrayWithObject:@"title"]];

    // t.title = ""
    [_topic setTitle:@""];
    // assert t.invalid?
    [self assertModelIsInvalid:_topic withErrorMessage:@"is the wrong length (should be 5 characters)" forKeys:[NSArray arrayWithObject:@"title"]];

    // t.title = nil
    [_topic setTitle:nil];
    // assert t.invalid?
    [self assertModelIsInvalid:_topic withErrorMessage:@"is the wrong length (should be 5 characters)" forKeys:[NSArray arrayWithObject:@"title"]];
}



- (void)testOptionallyValidatesLengthUsingEquals
{
    // Topic.validates_length_of :title, :is => 5, :allow_nil => true
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"equals",
                              @"Y", @"allowNil",
                              nil]];

    // t = Topic.new("title" => "valid", "content" => "whatever")
    [_topic setTitle:@"valid"];
    [_topic setContent:@"whatever"];
    // assert t.valid?
    [self assertModelIsValid:_topic];

    // t.title = nil
    [_topic setTitle:@"valid"];
    // assert t.valid?
    [self assertModelIsValid:_topic];
}



- (void)testValidatesLengthWithBignum
{
    // bigmin = 2 ** 30
    NSUInteger bigMin = (2 ^ 30);
    // bigmax = 2 ** 32
    // bigrange = bigmin...bigmax
    NSUInteger bigMax = (2 ^ 32);

    // assert_nothing_raised do
    // Topic.validates_length_of :title, :is => bigmin + 5
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(bigMin + 5)], @"equals", nil];
    STAssertNoThrow([Topic validatesLengthOf:@"title" withOptions:options], @"An exception should NOT have been raised.");
    // Topic.validates_length_of :title, :within => bigrange
    // Topic.validates_length_of :title, :in => bigrange
    options = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithInt:bigMin], @"minimum",
               [NSNumber numberWithInt:bigMax], @"maximum",
               nil];
    STAssertNoThrow([Topic validatesLengthOf:@"title" withOptions:options], @"An exception should NOT have been raised.");
    // Topic.validates_length_of :title, :minimum => bigmin
    options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:bigMin], @"minimum", nil];
    STAssertNoThrow([Topic validatesLengthOf:@"title" withOptions:options], @"An exception should NOT have been raised.");
    // Topic.validates_length_of :title, :maximum => bigmax
    options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:bigMax], @"maximum", nil];
    STAssertNoThrow([Topic validatesLengthOf:@"title" withOptions:options], @"An exception should NOT have been raised.");
}



- (void)testValidatesLengthUsingNastyOptions
{
    // assert_raise(ArgumentError) { Topic.validates_length_of(:title, :is => -6) }
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:-6], @"equals", nil];
    STAssertThrowsSpecificNamed([Topic validatesLengthOf:@"title" withOptions:options], NSException, NSInvalidArgumentException, @"An NSInvalidArgumentException should have been raised, but was not.");

    options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:-6], @"minimum", nil];
    STAssertThrowsSpecificNamed([Topic validatesLengthOf:@"title" withOptions:options], NSException, NSInvalidArgumentException, @"An NSInvalidArgumentException should have been raised, but was not.");
    
    options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:-6], @"maximum", nil];
    STAssertThrowsSpecificNamed([Topic validatesLengthOf:@"title" withOptions:options], NSException, NSInvalidArgumentException, @"An NSInvalidArgumentException should have been raised, but was not.");
    
    // assert_raise(ArgumentError) { Topic.validates_length_of(:title, :minimum => "a") }
    options = [NSDictionary dictionaryWithObjectsAndKeys:@"a", @"minimum", nil];
    STAssertThrowsSpecificNamed([Topic validatesLengthOf:@"title" withOptions:options], NSException, NSInvalidArgumentException, @"An NSInvalidArgumentException should have been raised, but was not.");
    
    // assert_raise(ArgumentError) { Topic.validates_length_of(:title, :maximum => "a") }
    options = [NSDictionary dictionaryWithObjectsAndKeys:@"a", @"maximum", nil];
    STAssertThrowsSpecificNamed([Topic validatesLengthOf:@"title" withOptions:options], NSException, NSInvalidArgumentException, @"An NSInvalidArgumentException should have been raised, but was not.");

    // assert_raise(ArgumentError) { Topic.validates_length_of(:title, :is => "a") }
    options = [NSDictionary dictionaryWithObjectsAndKeys:@"a", @"equals", nil];
    STAssertThrowsSpecificNamed([Topic validatesLengthOf:@"title" withOptions:options], NSException, NSInvalidArgumentException, @"An NSInvalidArgumentException should have been raised, but was not.");
}



- (void)testValidatesLengthWithMinimumAndMessage
{
    // Topic.validates_length_of( :title, :minimum => 5, :message => "boo %{count}" )
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"minimum",
                              @"boo %{count}", @"message",
                              nil]];
    // t = Topic.new("title" => "uhoh", "content" => "whatever")
    [_topic setTitle:@"uhoh"];
    [_topic setContent:@"whatever"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["boo 5"], t.errors[:title]
    [self assertModelIsInvalid:_topic withErrorMessage:@"boo 5" forKeys:[NSArray arrayWithObject:@"title"]];
}



- (void)testValidatesLengthWithMinimumAndTooShortMessage
{
    // Topic.validates_length_of( :title, :minimum => 5, :too_short => "hoo %{count}" )
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"minimum",
                              @"hoo %{count}", @"tooShortMessage",
                              nil]];
    // t = Topic.new("title" => "uhoh", "content" => "whatever")
    [_topic setTitle:@"uhoh"];
    [_topic setContent:@"whatever"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["hoo 5"], t.errors[:title]
    [self assertModelIsInvalid:_topic withErrorMessage:@"hoo 5" forKeys:[NSArray arrayWithObject:@"title"]];
}



- (void)testValidatesLengthWithMaximumAndMessage
{
    // Topic.validates_length_of( :title, :maximum => 5, :message => "boo %{count}" )
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"maximum",
                              @"boo %{count}", @"message",
                              nil]];
    // t = Topic.new("title" => "uhohuhoh", "content" => "whatever")
    [_topic setTitle:@"uhohuhoh"];
    [_topic setContent:@"whatever"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["boo 5"], t.errors[:title]
    [self assertModelIsInvalid:_topic withErrorMessage:@"boo 5" forKeys:[NSArray arrayWithObject:@"title"]];
}



- (void)testValidatesLengthUsingMinimumAndMaximumWithMessage
{
    // Topic.validates_length_of(:title, :in => 10..20, :message => "hoo %{count}")
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:10], @"minimum",
                              [NSNumber numberWithInt:20], @"maximum",
                              @"hoo %{count}", @"message",
                              nil]];

    // t = Topic.new("title" => "uhohuhoh", "content" => "whatever")
    [_topic setTitle:@"uhohuhoh"];
    [_topic setContent:@"whatever"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["hoo 10"], t.errors["title"]
    [self assertModelIsInvalid:_topic withErrorMessage:@"hoo 10" forKeys:[NSArray arrayWithObject:@"title"]];

    // t = Topic.new("title" => "uhohuhohuhohuhohuhohuhohuhohuhoh", "content" => "whatever")
    [_topic setTitle:@"uhohuhohuhohuhohuhohuhohuhohuhoh"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["hoo 20"], t.errors["title"]
    [self assertModelIsInvalid:_topic withErrorMessage:@"hoo 20" forKeys:[NSArray arrayWithObject:@"title"]];
}



- (void)testValidatesLengthWithMaximumAndTooLongMessage
{
    // Topic.validates_length_of( :title, :maximum => 5, :too_long => "hoo %{count}" )
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"maximum",
                              @"hoo %{count}", @"tooLongMessage",
                              nil]];
    // t = Topic.new("title" => "uhohuhoh", "content" => "whatever")
    [_topic setTitle:@"uhohuhoh"];
    [_topic setContent:@"whatever"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["hoo 5"], t.errors["title"]
    [self assertModelIsInvalid:_topic withErrorMessage:@"hoo 5" forKeys:[NSArray arrayWithObject:@"title"]];
}



- (void)testValidatesLengthWithTooShortAndTooLong
{
    // Topic.validates_length_of :title, :minimum => 3, :maximum => 5, :too_short => 'too short', :too_long => 'too long'
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:3], @"minimum",
                              [NSNumber numberWithInt:5], @"maximum",
                              @"too short", @"tooShortMessage",
                              @"too long", @"tooLongMessage",
                              nil]];

    // t = Topic.new(:title => 'a')
    [_topic setTitle:@"a"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ['too short'], t.errors['title']
    [self assertModelIsInvalid:_topic withErrorMessage:@"too short" forKeys:[NSArray arrayWithObject:@"title"]];

    // t = Topic.new(:title => 'aaaaaa')
    [_topic setTitle:@"aaaaaa"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ['too long'], t.errors['title']
    [self assertModelIsInvalid:_topic withErrorMessage:@"too long" forKeys:[NSArray arrayWithObject:@"title"]];
}



- (void)testValidatesLengthWithEqualsAndMessage
{
    // Topic.validates_length_of( :title, :is => 5, :message => "boo %{count}" )
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"equals",
                              @"boo %{count}", @"message",
                              nil]];
    // t = Topic.new("title" => "uhohuhoh", "content" => "whatever")
    [_topic setTitle:@"uhohuhoh"];
    [_topic setContent:@"whatever"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["boo 5"], t.errors["title"]
    [self assertModelIsInvalid:_topic withErrorMessage:@"boo 5" forKeys:[NSArray arrayWithObject:@"title"]];
}



- (void)testValidatesLengthWithEqualsAndWrongLengthMessage
{
    // Topic.validates_length_of( :title, :is => 5, :wrong_length => "hoo %{count}" )
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"equals",
                              @"hoo %{count}", @"wrongLengthMessage",
                              nil]];
    // t = Topic.new("title" => "uhohuhoh", "content" => "whatever")
    [_topic setTitle:@"uhohuhoh"];
    [_topic setContent:@"whatever"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["hoo 5"], t.errors["title"]
    [self assertModelIsInvalid:_topic withErrorMessage:@"hoo 5" forKeys:[NSArray arrayWithObject:@"title"]];
}



- (void)testValidatesLengthUsingMinimumWithUTF8
{
    // Topic.validates_length_of :title, :minimum => 5
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"minimum",
                              nil]];
    // t = Topic.new("title" => "一二三四五", "content" => "whatever")
    [_topic setTitle:@"一二三四五"];
    [_topic setContent:@"whatever"];
    // assert t.valid?
    [self assertModelIsValid:_topic];

    // t.title = "一二三四"
    [_topic setTitle:@"一二三四"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["is too short (minimum is 5 characters)"], t.errors["title"]
    [self assertModelIsInvalid:_topic withErrorMessage:@"is too short (minimum is 5 characters)" forKeys:[NSArray arrayWithObject:@"title"]];
}



- (void)testValidatesLengthUsingMaximumWithUTF8
{
    // Topic.validates_length_of :title, :maximum => 5
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"maximum",
                              nil]];

    // t = Topic.new("title" => "一二三四五", "content" => "whatever")
    [_topic setTitle:@"一二三四五"];
    [_topic setContent:@"whatever"];
    // assert t.valid?
    [self assertModelIsValid:_topic];

    // t.title = "一二34五六"
    [_topic setTitle:@"一二34五六"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["is too long (maximum is 5 characters)"], t.errors["title"]
    [self assertModelIsInvalid:_topic withErrorMessage:@"is too long (maximum is 5 characters)" forKeys:[NSArray arrayWithObject:@"title"]];
}



- (void)testValidatesLengthUsingMinimumAndMaximumWithUTF8
{
    // Topic.validates_length_of(:title, :content, :within => 3..5)
    [Topic validatesLengthOf:[NSArray arrayWithObjects:@"title", @"content", nil]
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:3], @"minimum",
                              [NSNumber numberWithInt:5], @"maximum",
                              nil]];

    // t = Topic.new("title" => "一二", "content" => "12三四五六七")
    [_topic setTitle:@"一二"];
    [_topic setContent:@"12三四五六七"];
    // assert t.invalid?
    // assert_equal ["is too short (minimum is 3 characters)"], t.errors[:title]
    [self assertModelIsInvalid:_topic withErrorMessage:@"is too short (minimum is 3 characters)" forKeys:[NSArray arrayWithObject:@"title"]];
    // assert_equal ["is too long (maximum is 5 characters)"], t.errors[:content]
    [self assertModelIsInvalid:_topic withErrorMessage:@"is too long (maximum is 5 characters)" forKeys:[NSArray arrayWithObject:@"content"]];

    // t.title = "一二三"
    [_topic setTitle:@"一二三"];
    // t.content  = "12三"
    [_topic setContent:@"12三"];
    // assert t.valid?
    [self assertModelIsValid:_topic];
}



- (void)testOptionallyValidatesLengthUsingMinimumAndMaximumWithUTF8
{
    // Topic.validates_length_of :title, :within => 3..5, :allow_nil => true
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:3], @"minimum",
                              [NSNumber numberWithInt:5], @"maximum",
                              @"Y", @"allowNil",
                              nil]];

    // t = Topic.new(:title => "一二三四五")
    [_topic setTitle:@"一二三四五"];
    // assert t.valid?, t.errors.inspect
    [self assertModelIsValid:_topic];

    // t = Topic.new(:title => "一二三")
    [_topic setTitle:@"一二三"];
    // assert t.valid?, t.errors.inspect
    [self assertModelIsValid:_topic];

    // t.title = nil
    [_topic setTitle:nil];
    // assert t.valid?, t.errors.inspect
    [self assertModelIsValid:_topic];
}



- (void)testValidatesLengthUsingEqualsWintUTF8
{
    // Topic.validates_length_of :title, :is => 5
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"equals",
                              nil]];

    // t = Topic.new("title" => "一二345", "content" => "whatever")
    [_topic setTitle:@"一二345"];
    [_topic setContent:@"whatever"];
    // assert t.valid?
    [self assertModelIsValid:_topic];

    // t.title = "一二345六"
    [_topic setTitle:@"一二345六"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    // assert_equal ["is the wrong length (should be 5 characters)"], t.errors["title"]
    [self assertModelIsInvalid:_topic withErrorMessage:@"is the wrong length (should be 5 characters)" forKeys:[NSArray arrayWithObject:@"title"]];
}



- (void)testValidatesLengthWithTokenizerBlock
{
    // Topic.validates_length_of :content, :minimum => 5, :too_short => "Your essay must be at least %{count} words.",
    // :tokenizer => lambda {|str| str.scan(/\w+/) }
    [Topic validatesLengthOf:@"content"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"minimum",
                              @"Your essay must be at least %{count} words.", @"tooShortMessage",
                              nil]
                    andBlock:^NSArray *(NSObject *value)
     {
         NSString *stringValue = [value description];
         NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:@"\\w+" options:0 error:nil];
         return [pattern matchesInString:stringValue options:NSMatchingReportCompletion range:NSMakeRange(0, [stringValue length])];
     }];
    // t = Topic.new(:content => "this content should be long enough")
    [_topic setContent:@"this content should be long enough"];
    // assert t.valid?
    [self assertModelIsValid:_topic];

    // t.content = "not long enough"
    [_topic setContent:@"not long enough"];
    // assert t.invalid?
    // assert t.errors[:content].any?
    // assert_equal ["Your essay must be at least 5 words."], t.errors[:content]
    [self assertModelIsInvalid:_topic withErrorMessage:@"Your essay must be at least 5 words." forKeys:[NSArray arrayWithObject:@"content"]];
}



// 1234 => "1234"
- (void)testValidatesLengthWithNumber
{
    // Topic.validates_length_of(:approved, :is => 4)
    [Topic validatesLengthOf:@"approved"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:4], @"equals",
                              nil]];

    // t = Topic.new("title" => "uhohuhoh", "content" => "whatever", :approved => 1)
    [_topic setTitle:@"uhohuhoh"];
    [_topic setContent:@"whatever"];
    [_topic setApproved:[NSNumber numberWithInt:1]];
    // assert t.invalid?
    // assert t.errors[:approved].any?
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"approved"]];

    // t = Topic.new("title" => "uhohuhoh", "content" => "whatever", :approved => 1234)
    [_topic setApproved:[NSNumber numberWithInt:1234]];
    // assert t.valid?
    [self assertModelIsValid:_topic];
}



- (void)testValidatesLengthWithInfiniteMaximum
{
    // Topic.validates_length_of(:title, :within => 5..Float::INFINITY)
    [Topic validatesLengthOf:@"title"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:5], @"minimum",
                              [NSNumber numberWithFloat:INFINITY], @"maximum",
                              nil]];

    // t = Topic.new("title" => "1234")
    [_topic setTitle:@"1234"];
    // assert t.invalid?
    // assert t.errors[:title].any?
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];

    // t.title = "12345"
    [_topic setTitle:@"12345"];
    // assert t.valid?
    [self assertModelIsValid:_topic];

    // Topic.validates_length_of(:author_name, :maximum => Float::INFINITY)
    [Topic validatesLengthOf:@"authorName"
                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat:INFINITY], @"maximum",
                              nil]];

    // assert t.valid?
    [self assertModelIsValid:_topic];

    // t.author_name = "A very long author name that should still be valid." * 100
    NSString *authorName = @"A very long author name that should still be valid.";
    int times = 100;
    NSMutableString *result = [NSMutableString stringWithCapacity:[authorName length] * times]; 
    for (int i = 0; i < times; i++)
    {
        [result appendString:authorName];    
    }
    [_topic setAuthorName:result];
    // assert t.valid?
    [self assertModelIsValid:_topic];
}

@end

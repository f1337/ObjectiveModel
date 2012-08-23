/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/test/cases/validations_test.rb
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



#import "BlockValidationTest.h"
#import <ObjectiveModel/Validations.h>



@implementation BlockValidationTest



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



- (void)testValidatesEach
{
    //hits = 0
    __block uint hits = 0;

    //Topic.validates_each(:title, :content, [:title, :content]) do |record, attr|
    [Topic validatesEach:[NSArray arrayWithObjects:@"title", @"content", nil] withBlock:^BOOL(OMBlockValidator *validator, OMActiveModel *model) {
        //record.errors.add attr, 'gotcha'
        [validator setMessage:@"gotcha"];
        //hits += 1
        hits = hits + 1;
        return NO;
    }];

    //t = Topic.new("title" => "valid", "content" => "whatever")
    [_topic setTitle:@"valid"];
    [_topic setContent:@"whatever"];
    //assert t.invalid?
    //assert_equal %w(gotcha gotcha), t.errors[:title]
    OMAssertModelIsInvalid(_topic, @"gotcha", [NSArray arrayWithObject:@"title"]);
    //assert_equal %w(gotcha gotcha), t.errors[:content]
    OMAssertModelIsInvalid(_topic, @"gotcha", [NSArray arrayWithObject:@"content"]);
    //assert_equal 4, hits
    STAssertTrue((hits == 4), @"should have 4 hits");
}



@end

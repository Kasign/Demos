//
//  FlyTextView.m
//  UITextView+@符号
//
//  Created by mx-QS on 2019/5/15.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyTextView.h"



@interface FlyTextView ()<UITextViewDelegate, NSLayoutManagerDelegate, NSTextStorageDelegate>

@property (nonatomic, copy) NSString   *   oldText;
@property (nonatomic, copy) NSString   *   replaceText;
@property (nonatomic, assign) NSRange      replaceRange;


@end

@implementation FlyTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        self.delegate = self;
        self.layoutManager.allowsNonContiguousLayout = YES;
        self.layoutManager.delegate = self;
        self.textStorage.delegate = self;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.layoutManager.allowsNonContiguousLayout = YES;
    }
    return self;
}

- (void)setText:(NSString *)text {
    
    NSString * oldText = self.text;
    [super setText:text];
    if (![oldText isEqualToString:text]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
    }
}

- (NSString *)text {
    
    if (![super text]) {
        return [[super attributedText] string];
    }
    return [super text];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    
    NSAttributedString * oldAttri = self.attributedText;
    [super setAttributedText:attributedText];
    if (![oldAttri isEqualToAttributedString:attributedText]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    FlyNormalLog(@"-----------shouldChange-----------\ntextView.text:%@\ntextView.text.length:%ld\ntext:%@\nreplaceRange:%@\nselectedRange%@\n",textView.text,textView.text.length,text,[NSValue valueWithRange:range], [NSValue valueWithRange:textView.selectedRange]);
    BOOL result  = YES;
    _replaceText = text;
    if (!textView.markedTextRange) {
        _replaceRange = range;
        _oldText = textView.text;
    }
    return result;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (!self.markedTextRange) {
        
        NSRange replaceRange   = _replaceRange;
        NSString * replaceText = _replaceText;
        
        if ([UIDevice currentDevice].systemVersion.floatValue < 10.0) {
            NSInteger subCount      = textView.text.length - _oldText.length;
            NSInteger rangeLength   = _replaceRange.length;
            rangeLength   = MAX(0, rangeLength + subCount);
            NSInteger rangeLocation = _replaceRange.location;
            rangeLocation = MIN(textView.text.length - rangeLength, rangeLocation);
            NSRange didReplaceRange = NSMakeRange(rangeLocation, rangeLength);
            replaceText = [textView.text substringWithRange:didReplaceRange];
        }
//        FlyNormalLog(@"\ntextViewDidChange\ntextView.text:%@\ntextView.text.length:%ld\nreplaceRange:%@\nreplaceText:%@\n----------------------",textView.text,textView.text.length,[NSValue valueWithRange:replaceRange], replaceText);
        
         FlyNormalLog(@"-----------DidChange-----------\ntextView.text:%@\ntextView.text.length:%ld\nselectedRange%@\nreplaceRange%@\n",textView.text,textView.text.length, [NSValue valueWithRange:textView.selectedRange],[NSValue valueWithRange:replaceRange]);
        
        if (textView.text.length + replaceRange.length - replaceText.length != _oldText.length) {
            FlyNormalLog(@"校验前：%ld",replaceRange.length);
            replaceRange.length = _oldText.length - textView.text.length + replaceText.length;
            replaceRange.location = textView.selectedRange.location;
            FlyNormalLog(@"校验后：%ld",replaceRange.length);
        } else {
            FlyNormalLog(@"不需要校验：%@",[NSValue valueWithRange:replaceRange]);
        }
        
        if (textView.text.length + replaceRange.length - replaceText.length == _oldText.length) {
         
        }
        
        _replaceRange = self.selectedRange;
        _oldText = self.text;
    }
   
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}

- (NSRange)markedRang {
    
    UITextPosition  * beginning   = self.beginningOfDocument;
    UITextRange     * markedRang  = self.markedTextRange;
    UITextPosition  * markedStart = markedRang.start;
    UITextPosition  * markedEnd   = markedRang.end;
    NSInteger location = [self offsetFromPosition:beginning   toPosition:markedStart];
    NSInteger length   = [self offsetFromPosition:markedStart toPosition:markedEnd];
    return NSMakeRange(location, length);
}

#pragma mark - NSLayoutManagerDelegate

- (NSUInteger)layoutManager:(NSLayoutManager *)layoutManager shouldGenerateGlyphs:(const CGGlyph *)glyphs properties:(const NSGlyphProperty *)props characterIndexes:(const NSUInteger *)charIndexes font:(UIFont *)aFont forGlyphRange:(NSRange)glyphRange NS_AVAILABLE(10_11, 7_0)
{
    
    return 0;
}


/************************ Line layout ************************/
// These methods are invoked while each line is laid out.  They allow NSLayoutManager delegate to customize the shape of line.

// Returns the spacing after the line ending with glyphIndex.
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect NS_AVAILABLE(10_11, 7_0)
{
    
    return 0.f;
}

// Returns the paragraph spacing before the line starting with glyphIndex.
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager paragraphSpacingBeforeGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect NS_AVAILABLE(10_11, 7_0)
{
    
    return 0.f;
}

// Returns the paragraph spacing after the line ending with glyphIndex.
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager paragraphSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect NS_AVAILABLE(10_11, 7_0)
{
    
    return 0.f;
}

// Returns the control character action for the control character at charIndex.
- (NSControlCharacterAction)layoutManager:(NSLayoutManager *)layoutManager shouldUseAction:(NSControlCharacterAction)action forControlCharacterAtIndex:(NSUInteger)charIndex NS_AVAILABLE(10_11, 7_0)
{
    
    return NSControlCharacterActionZeroAdvancement;
}

// Invoked while determining the soft line break point.  When NO, NSLayoutManager tries to find the next line break opportunity before charIndex
- (BOOL)layoutManager:(NSLayoutManager *)layoutManager shouldBreakLineByWordBeforeCharacterAtIndex:(NSUInteger)charIndex NS_AVAILABLE(10_11, 7_0)
{
    
    return NO;
}

// Invoked while determining the hyphenation point.  When NO, NSLayoutManager tries to find the next hyphenation opportunity before charIndex
- (BOOL)layoutManager:(NSLayoutManager *)layoutManager shouldBreakLineByHyphenatingBeforeCharacterAtIndex:(NSUInteger)charIndex NS_AVAILABLE(10_11, 7_0)
{
    
    return YES;
}
// Invoked for resolving the glyph metrics for NSControlCharacterWhitespaceAction control character.
- (CGRect)layoutManager:(NSLayoutManager *)layoutManager boundingBoxForControlGlyphAtIndex:(NSUInteger)glyphIndex forTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)proposedRect glyphPosition:(CGPoint)glyphPosition characterIndex:(NSUInteger)charIndex NS_AVAILABLE(10_11, 7_0)
{
    
    return self.bounds;
}

// Allows NSLayoutManagerDelegate to customize the line fragment geometry before committing to the layout cache. The implementation of this method should make sure that the modified fragments are still valid inside the text container coordinate. When it returns YES, the layout manager uses the modified rects. Otherwise, it ignores the rects returned from this method.
- (BOOL)layoutManager:(NSLayoutManager *)layoutManager shouldSetLineFragmentRect:(inout CGRect *)lineFragmentRect lineFragmentUsedRect:(inout CGRect *)lineFragmentUsedRect baselineOffset:(inout CGFloat *)baselineOffset inTextContainer:(NSTextContainer *)textContainer forGlyphRange:(NSRange)glyphRange NS_AVAILABLE(10_11, 9_0)
{
    
    return YES;
}


/************************ Layout processing ************************/
// This is sent whenever layout or glyphs become invalidated in a layout manager which previously had all layout complete.
- (void)layoutManagerDidInvalidateLayout:(NSLayoutManager *)sender NS_AVAILABLE(10_0, 7_0)
{
    
    
}

// This is sent whenever a container has been filled.  This method can be useful for paginating.  The textContainer might be nil if we have completed all layout and not all of it fit into the existing containers.  The atEnd flag indicates whether all layout is complete.
- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(nullable NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag NS_AVAILABLE(10_0, 7_0)
{
    
}

// This is sent right before layoutManager invalidates the layout due to textContainer changing geometry.  The receiver of this method can react to the geometry change and perform adjustments such as recreating the exclusion path.
- (void)layoutManager:(NSLayoutManager *)layoutManager textContainer:(NSTextContainer *)textContainer didChangeGeometryFromSize:(CGSize)oldSize NS_AVAILABLE(10_11, 7_0)
{
    
}


#pragma mark - NSTextStorageDelegate

// Sent inside -processEditing right before fixing attributes.  Delegates can change the characters or attributes.
- (void)textStorage:(NSTextStorage *)textStorage willProcessEditing:(NSTextStorageEditActions)editedMask range:(NSRange)editedRange changeInLength:(NSInteger)delta NS_AVAILABLE(10_11, 7_0)
{
    
    if (self.markedTextRange) {
        NSRange markedRange = [self markedRang];
        [textStorage setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:markedRange];
    }
    
//    FlyNormalLog(@"\n-----------------------------NSTextStorageDelegate Start---------------------------------");
//    FlyNormalLog(@"\n-------willProcessEditing--------\ntextStorage:%@ \n editedMask:%ld \neditedRange:%@ \n delta:%ld\n---------------------",textStorage.string,editedMask,[NSValue valueWithRange:editedRange], delta);
}

// Sent inside -processEditing right before notifying layout managers.  Delegates can change the attributes.
- (void)textStorage:(NSTextStorage *)textStorage didProcessEditing:(NSTextStorageEditActions)editedMask range:(NSRange)editedRange changeInLength:(NSInteger)delta NS_AVAILABLE(10_11, 7_0)
{
//    FlyNormalLog(@"\n-------didProcessEditing--------\ntextStorage:%@ \n editedMask:%ld \neditedRange:%@ \n delta:%ld\n---------------------",textStorage.string,editedMask,[NSValue valueWithRange:editedRange], delta);
//    FlyNormalLog(@"\n-----------------------------NSTextStorageDelegate End---------------------------------\n\n\n");
}

@end

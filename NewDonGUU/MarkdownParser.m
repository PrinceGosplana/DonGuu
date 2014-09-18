//
//  MarkdownParser.m
//  TextKitMagazine
//
//  Created by Administrator on 26.03.14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "MarkdownParser.h"

@implementation MarkdownParser
{
    NSDictionary * _bodyTextAttributes;
    NSDictionary * _headingOneAttributes;
    NSDictionary *_headingTwoAttributes;
    NSDictionary *_headingThreeAttributes;
}

- (id) init {
    if (self = [super init]) {
        [self createTextAttributes]; }
    return self;
}

// не используется
- (void)createTextAttributes {
    // 1. Create the font descriptors
    UIFontDescriptor *baskerville = [UIFontDescriptor fontDescriptorWithFontAttributes: @{UIFontDescriptorFamilyAttribute: @"Baskerville"}]; // не изсопльзуется
    UIFontDescriptor *baskervilleBold = [baskerville fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    // 2. determine the current text size preference
    UIFontDescriptor *bodyFont = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    NSNumber *bodyFontSize = bodyFont.fontAttributes[UIFontDescriptorSizeAttribute];
    float bodyFontSizeValue = [bodyFontSize floatValue];
    // 3. create the attributes for the various styles
    _bodyTextAttributes = [self attributesWithDescriptor:baskerville size:bodyFontSizeValue];
    _headingOneAttributes = [self attributesWithDescriptor:baskervilleBold
                                                      size:bodyFontSizeValue * 2.0f];
    _headingTwoAttributes = [self attributesWithDescriptor:baskervilleBold
                                                      size:bodyFontSizeValue * 1.8f]; _headingThreeAttributes = [self
                                                                                                                 attributesWithDescriptor:baskervilleBold size:bodyFontSizeValue * 1.4f];
}

- (NSDictionary *)attributesWithDescriptor: (UIFontDescriptor*)descriptor size:(float)size {
    UIFont * font = [UIFont fontWithName:@"HelveticaNeue" size:size];
//    UIFont *font = [UIFont fontWithDescriptor:descriptor size:size]; // чтобы использовать предыдущую функция раскоментировать здесь
    return @{NSFontAttributeName: font};
}

- (NSAttributedString *)parseMarkdownFile:(NSString *)path { NSMutableAttributedString* parsedOutput =
    [[NSMutableAttributedString alloc] init];
    // 1. break the file into lines and iterate over each line
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [text componentsSeparatedByCharactersInSet:[NSCharacterSet
                                                                 newlineCharacterSet]];
    for(__strong NSString* line in lines){
        if ([line isEqualToString:@""])
            continue;
        
        // 2. match the various 'heading' styles
        NSDictionary *textAttributes = _bodyTextAttributes;
        
        if (line.length > 3){
            if ([[line substringToIndex:3] isEqualToString:@"###"]) {
                textAttributes = _headingThreeAttributes;
                line = [line substringFromIndex:3];
            }
            else if ([[line substringToIndex:2]isEqualToString:@"##"])
            { textAttributes = _headingTwoAttributes;
                line = [line substringFromIndex:2];
            }
            else if ([[line substringToIndex:1]
                      isEqualToString:@"#"]) { textAttributes = _headingOneAttributes;
                line = [line substringFromIndex:1];
            }
        }
        // 3. apply the attributes to this line of text
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:line
                                                                             attributes:textAttributes];
        // 4. append to the output
        [parsedOutput appendAttributedString:attributedText];
        [parsedOutput appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
        
    }
    // 1. Locate images
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\!\\[.*\\]\\((.*)\\)"
                                                                           options:0 error:nil];
    NSArray *matches = [regex matchesInString:[parsedOutput string]
                                      options:0
                                        range:NSMakeRange(0, parsedOutput.length)];
    // 2. Iterate over matches in reverse
    for (NSTextCheckingResult *result in [matches reverseObjectEnumerator])
    {
        NSRange matchRange = [result range];
        NSRange captureRange = [result rangeAtIndex:1];
        
        // 3. Create an attachment for each image
        NSTextAttachment *textAttachment = [NSTextAttachment new];
        textAttachment.image = [UIImage imageNamed: [parsedOutput.string substringWithRange:captureRange]];
        
        // 4. Replace the image markup with the attachment
        NSAttributedString *replacementString = [NSAttributedString attributedStringWithAttachment: textAttachment];
        [parsedOutput replaceCharactersInRange:matchRange withAttributedString:replacementString];
    }
    
    return parsedOutput;
}
@end

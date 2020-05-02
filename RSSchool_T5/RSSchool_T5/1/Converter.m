#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    
    NSDictionary *codesOfСountry = @{ @"7" : @"RU", @"77" : @"KZ", @"373" : @"MD", @"374" : @"AM", @"375" : @"BY", @"380" : @"UA", @"992" : @"TJ", @"993" : @"TM", @"994" : @"AZ", @"996" : @"KG", @"998" : @"UZ" };
    
    NSMutableString *finalString = [[NSMutableString alloc] initWithString:@"+"];
    NSString *currentString = [[NSString alloc] initWithString:string];
    NSString *code = [[NSString alloc] initWithString:@""];
    NSString *codeNumber = [[NSString alloc] init];
    
    NSString *plusOrNot = [currentString substringToIndex:1];
    
    if ([plusOrNot isEqualToString:@"+"]) {
        currentString = [currentString substringFromIndex:1];
    }
    
    if ([currentString length] > 2) {
        NSString *three = [currentString substringToIndex:3];
        
        if ([codesOfСountry objectForKey:three]) {
            code = [codesOfСountry objectForKey:three];
            [finalString appendString:three];
            codeNumber = three;
            currentString = [currentString substringFromIndex:3];
        }
        
    }
    
    if ([currentString length] > 1) {
        NSString *two = [currentString substringToIndex:2];
        
        if ([codesOfСountry objectForKey:two]) {
            code = [codesOfСountry objectForKey:two];
            [finalString appendString:two];
            codeNumber = two;
            currentString = [currentString substringFromIndex:2];
        }
        
    }
    
    if ([currentString length] > 0  && [code isEqualToString:@""]) {
        NSString *one = [currentString substringToIndex:1];
        
        if ([codesOfСountry objectForKey:one]) {
            code = [codesOfСountry objectForKey:one];
            [finalString appendString:one];
            codeNumber = one;
            currentString = [currentString substringFromIndex:1];
        }
        
    }
    
    NSDictionary *structureOfNumber = @{ @10 : @" (xxx) xxx-xx-xx", @9 : @" (xx) xxx-xx-xx", @8 : @" (xx) xxx-xxx"};
    NSDictionary *countOfNumbers = @{ @"RU" : @10, @"KZ" : @10, @"MD" : @8, @"AM" : @8, @"BY" : @9, @"UA" : @9, @"TJ" : @9, @"TM" : @8, @"AZ" : @9, @"KG" : @9, @"UZ" : @9 };
    
    NSString *lastNumber = [[NSString alloc] init];
    lastNumber = [finalString substringFromIndex:[finalString length] - 1];
    
    if ([code isEqualToString:@""]) {
        
        if ([currentString length] > 12) {
            currentString = [currentString substringToIndex:12];
        }
        
        [finalString appendString:currentString];
        lastNumber = [finalString substringFromIndex:[finalString length] - 1];
    } else {
        
        if ([code isEqualToString:@"KZ"]) {
            [finalString deleteCharactersInRange:NSMakeRange([finalString length]-1, 1)];
            NSMutableString *refreshForKZ = [[NSMutableString alloc] initWithString:currentString];
            [refreshForKZ insertString:lastNumber atIndex:0];
            currentString = refreshForKZ;
        }
        
        NSNumber *count = [[NSNumber alloc] init];
        count = [countOfNumbers objectForKey:code];
        
        NSString *format = [[NSString alloc] init];
        format = [structureOfNumber objectForKey:count];
        [finalString appendString:format];
        
        if ([currentString length] > [count intValue]) {
            currentString = [currentString substringToIndex:[count intValue]];
        }
        
        while ([currentString length] > 0) {
            NSString *number = [currentString substringToIndex:1];
            currentString = [currentString substringFromIndex:1];
            lastNumber = number;
            
            NSRange range = [finalString rangeOfString:@"x"];
            
            [finalString replaceCharactersInRange:range withString:number];
            
        }
        
    }
    
    NSString *final = [[NSString alloc] initWithString:finalString];
    NSRange rangeLast = [finalString rangeOfString:lastNumber options:NSBackwardsSearch];
    NSInteger indexToCut = rangeLast.location + 1;
    final = [finalString substringToIndex:indexToCut];
    
    return @{KeyPhoneNumber: final,
             KeyCountry: code};
}
@end

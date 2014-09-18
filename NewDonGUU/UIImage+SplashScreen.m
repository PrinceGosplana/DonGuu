#import "UIImage+SplashScreen.h"

@implementation UIImage (SplashScreen)

+ (UIImage *) imageNamedCustom:(NSString *)imageName{
    NSMutableString * imageNameMutable = [imageName mutableCopy];
    NSRange retinaAtSymbol = [imageName rangeOfString:@"@"];
    if (retinaAtSymbol.location != NSNotFound) {
        
        [imageNameMutable insertString:@"-568h" atIndex:retinaAtSymbol.location];
    }else{
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            NSRange dot = [imageName rangeOfString:@"."];
            if (dot.location != NSNotFound) {
                [imageNameMutable insertString:@"-568h@2x" atIndex:dot.location];
            } else{
                [imageNameMutable appendString:@"-568h@2x"];
            }
        }
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 480.0f) {
            NSRange dot = [imageName rangeOfString:@"."];
            if (dot.location != NSNotFound) {
                [imageNameMutable insertString:@"@2x" atIndex:dot.location];
            } else{
                [imageNameMutable appendString:@"@2x"];
            }
        }
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 1024.0f) {
            NSRange dot = [imageName rangeOfString:@"."];
            if (dot.location != NSNotFound) {
                [imageNameMutable insertString:@"-Landscape@2x" atIndex:dot.location];
            } else{
                [imageNameMutable appendString:@"-Landscape@2x"];
            }
        }


    }
    NSString * imagePath = [[NSBundle mainBundle] pathForResource:imageNameMutable ofType:@"png"];
    if (imagePath) {
        return [UIImage imageNamed:imageNameMutable];
    }else{
        return [UIImage imageNamed:imageName];
    }
    return nil;
}
@end

//
//  UIView+TWLinear.m
//

#import <objc/runtime.h>
#import "UIView+TWLinear.h"

static char *key;
@implementation UIView (TWLinear)

-(void)setHeight:(int)height {
    objc_setAssociatedObject(self, &key, [NSNumber numberWithInt:height], OBJC_ASSOCIATION_RETAIN);
}
-(int)height {
    NSNumber *num = (NSNumber*)objc_getAssociatedObject(self, &key);
    if (!num) {
        return 0;
    }
    return [num intValue];
}
-(void)addSubviewLinear:(UIView *)view {
    CGRect r = view.frame;
    int height = [self height];
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               height,
                                                               r.size.width,
                                                               r.size.height)];
    [addView addSubview:view];
    height += r.size.height + r.origin.y;
    [self setHeight:height];
    [self addSubview:addView];
}

-(void)sizeToFitLinear {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self height])];
}
-(void)sizeToFitLinearWithPaddingBottom:(NSInteger)padding {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self height] + padding)];
}

@end

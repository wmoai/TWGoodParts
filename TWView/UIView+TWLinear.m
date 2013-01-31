//
//  UIView+TWLinear.m
//

#import <objc/runtime.h>
#import "UIView+TWLinear.h"

static char *kTWViewKey;
@implementation UIView (TWLinear)

-(void)twViewSetHeight:(int)height {
    objc_setAssociatedObject(self, &kTWViewKey, [NSNumber numberWithInt:height], OBJC_ASSOCIATION_RETAIN);
}
-(int)twViewHeight {
    NSNumber *num = (NSNumber*)objc_getAssociatedObject(self, &kTWViewKey);
    if (!num) {
        return 0;
    }
    return [num intValue];
}
-(void)addSubviewLinear:(UIView *)view {
    CGRect r = view.frame;
    int height = [self twViewHeight];
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               height,
                                                               r.size.width,
                                                               r.size.height)];
    [addView addSubview:view];
    height += r.size.height + r.origin.y;
    [self twViewSetHeight:height];
    [self addSubview:addView];
}

-(void)sizeToFitLinear {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self twViewHeight])];
}
-(void)sizeToFitLinearWithPaddingBottom:(NSInteger)padding {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self twViewHeight] + padding)];
}

@end

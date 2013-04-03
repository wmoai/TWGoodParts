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
    int height = [self twViewHeight];
    CGRect r = view.frame;
    r.origin.y = height + view.frame.origin.y;
    height += view.frame.origin.y + view.frame.size.height;
    view.frame = r;
    [self addSubview:view];
    [self twViewSetHeight:height];
}

-(void)sizeToFitLinear {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self twViewHeight])];
}
-(void)sizeToFitLinearWithPaddingBottom:(NSInteger)padding {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self twViewHeight] + padding)];
}


@end

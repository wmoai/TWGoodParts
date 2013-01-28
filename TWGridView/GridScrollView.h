//
//  GridScrollView.h
//  Exstamp
//
//  Created by 東郷 晃典 on 13/01/25.
//
//

#import <UIKit/UIKit.h>

@interface GridScrollView : UIScrollView

@property CGSize gridSize;

- (void)setContentSize:(CGSize)contentSize row:(int)row col:(int)col;
- (void)addSubviewWithIndex:(UIView *)view index:(NSUInteger)index;
- (void)addSubviewWithIndex:(UIView *)view index:(NSUInteger)index relativePosition:(CGPoint)relativePosition;
- (CGSize)getGridSize;

@end

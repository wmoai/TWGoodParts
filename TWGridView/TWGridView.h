//
//  TWGridView.h
//  Exstamp
//
//  Created by 東郷 晃典 on 12/11/15.
//
//

#import <UIKit/UIKit.h>

@interface TWGridView : UIView
{
    @private
    NSArray *_gridPositions;
    CGSize _gridSize;
}

@property CGSize gridSize;

- (id)initWithFrame:(CGRect)frame row:(NSUInteger)row col:(NSUInteger)col;
- (void)addSubviewWithIndex:(UIView *)view index:(NSUInteger)index;
- (void)addSubviewWithIndex:(UIView *)view index:(NSUInteger)index relativePosition:(CGPoint)relativePosition;
- (CGSize)getGridSize;
- (void)adjustHeight:(NSUInteger)usingGridCount;

@end

//
//  GridScrollView.m
//

#import "GridScrollView.h"
#import "UIView+Support.m"

@implementation GridScrollView
{
    NSArray *_gridPositions;
    CGSize _gridSize;
}

- (void)setContentSize:(CGSize)contentSize row:(int)row col:(int)col
{
    [super setContentSize:contentSize];
    _gridPositions = [self gridPositions:contentSize row:row col:col];
}

- (NSMutableArray *)gridPositions:(CGSize)frameSize row:(int)row col:(int)col
{
    NSMutableArray *positions = [NSMutableArray arrayWithCapacity:row * col];

    CGFloat gridWidth = (CGFloat)(frameSize.width / col);
    CGFloat gridHeight = (CGFloat)(frameSize.height / row);

    _gridSize = CGSizeMake(gridWidth, gridHeight);

    CGFloat originX = 0;
    CGFloat originY = 0;

    for (int i = 0; i < row; i++) {
        originY = originY + gridHeight * i;
        for (int j = 0; j < col; j++) {
            originX = originX + gridWidth * j;
            [positions addObject:[NSValue valueWithCGPoint:CGPointMake(originX, originY)]];
        }
    }

    return positions;
}

- (void)addSubviewWithIndex:(UIView *)view index:(NSUInteger)index
{
    float posX = (_gridSize.width - view.frame.size.width) / 2;
    float posY = (_gridSize.height - view.frame.size.height) / 2;
    [self addSubviewWithIndex:view index:index relativePosition:CGPointMake(posX, posY)];
}

- (void)addSubviewWithIndex:(UIView *)view index:(NSUInteger)index relativePosition:(CGPoint)relativePosition
{
    CGPoint position = [[_gridPositions objectAtIndex:index] CGPointValue];
    position.x = position.x + relativePosition.x;
    position.y = position.y + relativePosition.y;

    [view setOrigin:position];
    [self addSubview:view];
}

- (CGSize)getGridSize
{
    return _gridSize;
}
@end

//
//  TWGridView.m
//  Exstamp
//
//  Created by 東郷 晃典 on 12/11/15.
//
//

#import "TWGridView.h"
#import "UIView+Support.h"

@implementation TWGridView
{
    NSUInteger _row;
    NSUInteger _col;
}

@synthesize gridSize = _gridSize;

- (id)initWithFrame:(CGRect)frame row:(NSUInteger)row col:(NSUInteger)col
{
    self = [super initWithFrame:frame];
    if (self) {
        _row = row;
        _col = col;
        _gridPositions = [self gridPositions:self.frame.size];
    }
    return self;
}

- (void)setFrame:(CGRect)frame row:(NSUInteger)row col:(NSUInteger)col
{
    [super setFrame:frame];
    _row = row;
    _col = col;
    _gridPositions = [self gridPositions:self.frame.size];
}

- (NSMutableArray *)gridPositions:(CGSize)frameSize
{
    NSMutableArray *positions = [NSMutableArray arrayWithCapacity:_row * _col];

    CGFloat gridWidth = (CGFloat)(frameSize.width / _col);
    CGFloat gridHeight = (CGFloat)(frameSize.height / _row);
    
    _gridSize = CGSizeMake(gridWidth, gridHeight);

    CGFloat originX = 0;
    CGFloat originY = 0;

    for (int i = 0; i < _row; i++) {
        originY = originY + gridHeight * i;
        for (int j = 0; j < _col; j++) {
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

- (void)adjustHeight:(NSUInteger)usingGridCount
{
    NSUInteger usingRow = usingGridCount / _col;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _gridSize.height * usingRow);
}

@end

//
//  GEventView.m
//  CalendarDemo
//
//  Created by Glare on 13-4-19.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GEventView.h"
#import "GCore.h"
#import "GEvent.h"

@implementation GEventView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.shouldMove = YES;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.font = [UIFont systemFontOfSize:12.0];
		_titleLabel.numberOfLines = 0;
		_titleLabel.lineBreakModeG = GLineBreakByCharWrapping;
        [self addSubview:_titleLabel];
        
    }
    return self;
}
#pragma mark - Setter / Getter
- (void)setEvent:(GEvent *)event
{
    _event = event;
    
    [self layoutEvent];
}

- (void)layoutEvent {
    [self setBackgroundColor: _event.backgroundColor];
    [self drawBorderWithColor: _event.borderColor
                        width: 1.0
                 cornerRadius: 3.0];
    
    _titleLabel.text = _event.title;
    _titleLabel.textColor = _event.foregroundColor;
	_titleLabel.frame = self.bounds;
	[_titleLabel sizeToFit];    
}

#pragma mark - GMoveSpriteProtocol
- (BOOL)canMove
{
    return _shouldMove;
}

@end

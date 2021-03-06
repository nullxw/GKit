//
//  GPicker.m
//  GKitDemo
//
//  Created by Hua Cao on 13-5-31.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GPicker.h"
#import "GCore.h"
#import "GLabelCell.h"
@interface GPicker ()
<
 UITableViewDataSource, UITableViewDelegate
>

@property (nonatomic, weak) UIImageView * backgroundImageView;
@property (nonatomic, weak) UIImageView * indicatorImageView;
@property (nonatomic, weak) UIView * contentView;

@property (nonatomic, strong) NSMutableArray * componentTableViews;

@property (nonatomic, strong) NSMutableDictionary * textFontInfo;
@property (nonatomic, strong) NSMutableDictionary * textColorInfo;
@property (nonatomic, strong) NSMutableDictionary * textShadowColorInfo;
@property (nonatomic, strong) NSMutableDictionary * textShadowOffsetInfo;

@property (nonatomic, strong) NSMutableDictionary * selectedRowInfo;

@end

@implementation GPicker

#pragma mark - Setter / Getter
- (void)setBackgroundImage:(UIImage *)backgroundImage {
    
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}

- (void)setIndicatorImage:(UIImage *)indicatorImage {
    
    _indicatorImage = indicatorImage;
    self.indicatorImageView.image = indicatorImage;
    [_indicatorImageView sizeToFit];
    _indicatorImageView.center = self.innerCenter;
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    
    _contentEdgeInsets = contentEdgeInsets;
    self.contentView.frame = CGRectMake(contentEdgeInsets.left,
                                        contentEdgeInsets.top,
                                        self.width-contentEdgeInsets.left-contentEdgeInsets.right,
                                        self.height-contentEdgeInsets.top-contentEdgeInsets.bottom);
}

- (void)setSeparatorLineImage:(UIImage *)separatorLineImage {
    
    _separatorLineImage = separatorLineImage;
    for (UIView * view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [(UIImageView *)view setImage:self.separatorLineImage];
        }
    }
}

- (void)setTextFont:(UIFont *)textFont forControlState:(UIControlState)controlState {
    
    [_textFontInfo setObject:textFont forKey:GNumberWithInteger(controlState)];
}

- (void)setTextColor:(UIColor *)textColor forControlState:(UIControlState)controlState {
    
    [_textColorInfo setObject:textColor forKey:GNumberWithInteger(controlState)];
}

- (void)setTextShadowColor:(UIColor *)textShadowColor forControlState:(UIControlState)controlState {
    [_textShadowColorInfo setObject:textShadowColor forKey:GNumberWithInteger(controlState)];
}
- (void)setTextShadowOffset:(CGSize)textShadowOffset forControlState:(UIControlState)controlState {
    [_textShadowOffsetInfo setObject:NSStringFromCGSize(textShadowOffset) forKey:GNumberWithInteger(controlState)];
}

- (UIFont *)textFontForControlState:(UIControlState)controlState {

    UIFont * font = [_textFontInfo objectForKey:GNumberWithInteger(controlState)];
    if (font==nil) font = [_textFontInfo objectForKey:GNumberWithInteger(UIControlStateNormal)];
        
    return font;
}

- (UIColor *)textColorForControlState:(UIControlState)controlState {
    
    UIColor * color = [_textColorInfo objectForKey:GNumberWithInteger(controlState)];
    if (color==nil) color = [_textColorInfo objectForKey:GNumberWithInteger(UIControlStateNormal)];
    
    return color;
}

- (UIColor *)textShadowColorForControlState:(UIControlState)controlState {
    
    UIColor * color = [_textShadowColorInfo objectForKey:GNumberWithInteger(controlState)];
    if (color==nil) color = [_textShadowColorInfo objectForKey:GNumberWithInteger(UIControlStateNormal)];
    
    return color;
}

- (CGSize)textShadowOffsetForControlState:(UIControlState)controlState {
    
    NSString * size = [_textShadowOffsetInfo objectForKey:GNumberWithInteger(controlState)];
    if (size==nil) size = [_textShadowOffsetInfo objectForKey:GNumberWithInteger(UIControlStateNormal)];
    
    return CGSizeFromString(size);
}


#pragma mark -
- (void)dealloc {
    for (UITableView * tableView in _componentTableViews) {
        tableView.delegate = nil;
        tableView.dataSource = nil;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self customInitialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self customInitialize];
    }
    return self;
}

- (void)customInitialize
{
    _contentEdgeInsets = UIEdgeInsetsZero;
    _separatorLineSize = CGSizeMake(1, self.height);
    
    _rowHeight = 44;
    
    _componentTableViews = [NSMutableArray array];
    
    _textFontInfo = [NSMutableDictionary dictionary];
    [_textFontInfo setObject:[UIFont systemFontOfSize:15.0] forKey:GNumberWithInteger(UIControlStateNormal)];
    
    _textColorInfo = [NSMutableDictionary dictionary];
    [_textColorInfo setObject:[UIColor blackColor] forKey:GNumberWithInteger(UIControlStateNormal)];
    [_textColorInfo setObject:[UIColor whiteColor] forKey:GNumberWithInteger(UIControlStateSelected)];
    [_textColorInfo setObject:[UIColor grayColor] forKey:GNumberWithInteger(UIControlStateDisabled)];
    
    _textShadowColorInfo = [NSMutableDictionary dictionary];
    [_textShadowColorInfo setObject:[UIColor clearColor] forKey:GNumberWithInteger(UIControlStateNormal)];
    
    _textShadowOffsetInfo = [NSMutableDictionary dictionary];
    [_textShadowOffsetInfo setObject:NSStringFromCGSize(CGSizeZero) forKey:GNumberWithInteger(UIControlStateNormal)];
    
    _selectedRowInfo = [NSMutableDictionary dictionary];
    
    // background image view
    UIImageView * backgroundImageView = [[UIImageView alloc] init];
    [self addSubviewToFill:backgroundImageView];
    self.backgroundImageView = backgroundImageView;
    
    // content view
    UIView * contentView = [[UIView alloc] init];
    [self addSubviewToFill:contentView];
    self.contentView = contentView;
    
    // indicator image view
    UIImageView * indicatorImageView = [[UIImageView alloc] init];
    indicatorImageView.autoresizingMask = GViewAutoresizingFlexibleMargins;
    indicatorImageView.clipsToBounds = YES;
    [self addSubview:indicatorImageView];
    self.indicatorImageView = indicatorImageView;
}

- (void)reloadAllComponents
{
    // remove all subviews
    [self.contentView removeAllSubviewOfClass:[UIView class]];
    [_componentTableViews removeAllObjects];
    [_selectedRowInfo removeAllObjects];
    
    // 
    NSInteger numberOfComponents = [_dataSource numberOfComponentsInPicker:self];
    CGFloat componentX = 0;
    CGFloat componentY = 0;
    CGFloat componentWidth = 0;
    CGFloat componentHeight = self.contentView.height;
    for (NSInteger i=0; i<numberOfComponents; i++) {
        
        if (_delegate &&
            [_delegate respondsToSelector:@selector(picker:widthForComponent:)]) {
            componentWidth = [_delegate picker:self widthForComponent:i];
        } else {
            componentWidth = self.contentView.width/numberOfComponents;
        }
        
        UITableView * tableView = [[UITableView alloc] initWithFrame:
                                   CGRectMake(componentX, componentY, componentWidth, componentHeight)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.tag = i;
        tableView.rowHeight = _rowHeight;
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.contentView addSubview:tableView];
        [self.contentView sendSubviewToBack:tableView];
        
        tableView.contentInset = UIEdgeInsetsMake((componentHeight-_rowHeight)/2, 0,
                                                  (componentHeight-_rowHeight)/2, 0);
        
        if (i>0) {
            UIImageView * separatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _separatorLineSize.width, _separatorLineSize.height)];
            separatorLineImageView.image = self.separatorLineImage;
            separatorLineImageView.center = CGPointMake(componentX, componentHeight/2);
            [self.contentView addSubview:separatorLineImageView];
        }
        
        [tableView reloadData];
        
        [_componentTableViews addObject:tableView];
        
        componentX += componentWidth;
    }
    
}

- (void)reloadComponent:(NSInteger)component {
    
    [[_componentTableViews objectAtPosition:component] reloadData];
    
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    
    [self scrollComponent:component toRow:row considerSelectable:NO animated:animated];

    [self performSelector:@selector(reportPickerDidSelectRowInComponent:) withObject:GNumberWithInteger(component) afterDelay:0.3];
}

- (void)reportPickerDidSelectRowInComponent:(NSNumber *)component {
    
    if (_delegate &&
        [_delegate respondsToSelector:@selector(picker:didSelectRow:inComponent:)]) {
        NSInteger c = component.integerValue;
        [_delegate picker:self didSelectRow:[self selectedRowInComponent:c] inComponent:c];
    }
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    
    UITableView * tableView = [_componentTableViews objectAtPosition:component];
    NSInteger rowForOffset = ((self.contentView.height-_rowHeight)/2 + tableView.contentOffset.y)/_rowHeight + 0.5;
    return rowForOffset;
}

#pragma mark - Scroll

- (void)scrollComponent:(NSInteger)component toRow:(NSInteger)row considerSelectable:(BOOL)considerSelectable animated:(BOOL)animated {
    
    BOOL isSelectable = YES;
    if (_delegate &&
        [_delegate respondsToSelector:@selector(picker:selectableForRow:forComponent:)]) {
        isSelectable = [_delegate picker:self selectableForRow:row forComponent:component];
    }
    
    if (isSelectable == NO &&
        considerSelectable) {
        row = [[_selectedRowInfo objectForKey:GNumberWithInteger(component)] integerValue];
    }
    
    [_selectedRowInfo setObject:GNumberWithInteger(row) forKey:GNumberWithInteger(component)];
    
    UITableView * tableView = [_componentTableViews objectAtPosition:component];
    CGFloat offsetForRow = [self offsetForRow:row inComponent:component];
    
    [tableView setContentOffset:CGPointMake(0, offsetForRow) animated:animated];
    
    if (row==0) {
        [self scrollViewDidScroll:tableView];
    }
}

- (CGFloat)offsetForRow:(NSInteger)row inComponent:(NSInteger)component {
    
    CGFloat offsetForRow = row*_rowHeight - (self.contentView.height-_rowHeight)/2;
    return offsetForRow;
}


#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_dataSource picker:self numberOfRowsInComponent:tableView.tag];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLabelCell * cell = [self cellForTableView:tableView atIndexPath:indexPath];
    
    [self configureCell:cell inTableView:tableView atIndexPath:indexPath];
    
    return cell;
}
- (GLabelCell *)cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * CellIdentifier = @"GPickerCell";
    GLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.label.textAlignmentG = GTextAlignmentCenter;
    }
    
    BOOL isSelectable = YES;
    if (_delegate &&
        [_delegate respondsToSelector:@selector(picker:selectableForRow:forComponent:)]) {
        isSelectable = [_delegate picker:self selectableForRow:indexPath.row forComponent:tableView.tag];
    }
    
    if (isSelectable) {
        cell.label.font = [self textFontForControlState:UIControlStateNormal];
        cell.label.textColor = [self textColorForControlState:UIControlStateNormal];
        cell.label.shadowColor = [self textShadowColorForControlState:UIControlStateNormal];
        cell.label.shadowOffset = [self textShadowOffsetForControlState:UIControlStateNormal];
    } else {
        cell.label.font = [self textFontForControlState:UIControlStateDisabled];
        cell.label.textColor = [self textColorForControlState:UIControlStateDisabled];
        cell.label.shadowColor = [self textShadowColorForControlState:UIControlStateDisabled];
        cell.label.shadowOffset = [self textShadowOffsetForControlState:UIControlStateDisabled];
    }
    
    return cell;
}

- (void)configureCell:(GLabelCell *)cell inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate &&
        [_delegate respondsToSelector:@selector(picker:titleForRow:forComponent:)]) {
        cell.label.text = [_delegate picker:self titleForRow:indexPath.row forComponent:tableView.tag];
    } else {
        cell.label.text = [NSString stringWithFormat:@"%d",indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(GLabelCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self selectRow:indexPath.row inComponent:tableView.tag animated:YES];
}

- (void)scrollViewDidScroll:(UITableView *)tableView {
    
    // Visible Cells in TableView
    NSArray * indexPathsForVisibleCells = [tableView indexPathsForVisibleRows];
    for (NSIndexPath * indexPath in indexPathsForVisibleCells) {
        CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
        CGFloat centerY = CGRectGetMidY(cellRect);
        CGFloat offset = (centerY-(tableView.contentOffset.y+tableView.height/2))/_rowHeight;
        if (_delegate &&
            [_delegate respondsToSelector:@selector(picker:didScrollCell:inComponent:atOffset:)]) {
            [_delegate picker:self didScrollCell:[tableView cellForRowAtIndexPath:indexPath] inComponent:tableView.tag atOffset:offset];
        }
    }
    
    // Cells In Indicator
    BOOL isIndicatorImageViewHasCells = NO;
    for (GLabelCell * cell in self.indicatorImageView.subviews) {
        if (cell.tag == tableView.tag) {
            isIndicatorImageViewHasCells = YES;
            break;
        }
    }
    
    NSInteger numberOfIndicatorImageViewCells = (NSInteger)(self.indicatorImageView.height/_rowHeight) + 2;
    if (!isIndicatorImageViewHasCells) {
        for (NSInteger i=0; i<numberOfIndicatorImageViewCells; i++) {
            GLabelCell * cell = [self cellForTableView:nil atIndexPath:nil];
            cell.tag = tableView.tag;
            cell.label.textColor = [self textColorForControlState:UIControlStateSelected];
            cell.label.font = [self textFontForControlState:UIControlStateSelected];
            [self.indicatorImageView addSubview:cell];
        }
    }
    
    NSArray * indexPaths =
    [tableView indexPathsForRowsInRect:[tableView convertRect:self.indicatorImageView.frame
                                                     fromView:self.indicatorImageView.superview]];
    NSInteger i = 0;
    for (GLabelCell * cell in self.indicatorImageView.subviews) {
        if (cell.tag == tableView.tag) {
            if (i<[indexPaths count]) {
                NSIndexPath * indexPath = [indexPaths objectAtPosition:i];
                CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
                CGRect rectForCell =
                [self.indicatorImageView convertRect:cellRect fromView:tableView];
                cell.frame = rectForCell;
                [self configureCell:cell inTableView:tableView atIndexPath:indexPath];
                
                //
                CGFloat centerY = CGRectGetMidY(cellRect);
                CGFloat offset = (centerY-(tableView.contentOffset.y+tableView.height/2))/_rowHeight;
                if (_delegate &&
                    [_delegate respondsToSelector:@selector(picker:didScrollCell:inComponent:atOffset:)]) {
                    [_delegate picker:self didScrollCell:cell inComponent:tableView.tag atOffset:offset];
                }
                
                cell.hidden = NO;
            } else {
                cell.hidden = YES;
            }
            i++;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (decelerate==NO) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UITableView *)tableView {
    
    NSInteger rowForOffset = [self selectedRowInComponent:tableView.tag];
    
    [self selectRow:rowForOffset inComponent:tableView.tag animated:YES];
}

@end

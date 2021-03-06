//
//  GPicker.h
//  GKitDemo
//
//  Created by Hua Cao on 13-5-31.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GPickerDataSource, GPickerDelegate;

@interface GPicker : UIView

@property (nonatomic, weak) id<GPickerDataSource> dataSource;
@property (nonatomic, weak) id<GPickerDelegate> delegate;

@property (nonatomic, strong) UIImage * backgroundImage;    //背景图片, default nil
@property (nonatomic, strong) UIImage * indicatorImage;    //指示器图片, default nil
@property (nonatomic, strong) UIImage * separatorLineImage; //分隔线图片, default nil
@property (nonatomic, assign) CGSize separatorLineSize;

@property (nonatomic, assign) CGFloat rowHeight; //default 44

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets; //default zero

- (void) reloadAllComponents;
- (void) reloadComponent: (NSInteger)component;

- (void) scrollComponent: (NSInteger)component
                   toRow: (NSInteger)row
      considerSelectable: (BOOL)considerSelectable
                animated: (BOOL)animated;

- (void) selectRow: (NSInteger)row
       inComponent: (NSInteger)component
          animated: (BOOL)animated;
- (NSInteger) selectedRowInComponent: (NSInteger)component;

- (void) setTextFont:(UIFont *)textFont forControlState:(UIControlState)controlState;
- (void) setTextColor:(UIColor *)textColor forControlState:(UIControlState)controlState;
- (void) setTextShadowColor:(UIColor *)textShadowColor forControlState:(UIControlState)controlState;
- (void) setTextShadowOffset:(CGSize)textShadowOffset forControlState:(UIControlState)controlState;

@end

//////////// GPickerDataSource
@protocol GPickerDataSource <NSObject>
@required
- (NSInteger) numberOfComponentsInPicker:(GPicker *)picker;
- (NSInteger) picker:(GPicker *)picker numberOfRowsInComponent:(NSInteger)component;

@end

//////////// GPickerDelegate
@protocol GPickerDelegate <NSObject>
@optional
- (CGFloat) picker:(GPicker *)picker widthForComponent:(NSInteger)component;
- (NSString *) picker:(GPicker *)picker titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (BOOL) picker:(GPicker *)picker selectableForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void) picker:(GPicker *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void) picker:(GPicker *)picker didScrollCell:(UIView *)cell inComponent:(NSInteger)component atOffset:(CGFloat)offset; // offset, 0 is middle, negative value means top, positive value means bottom;

@end
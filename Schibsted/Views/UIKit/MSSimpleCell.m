//
//  MSRSSItemCell.m
//  Schibsted
//
//  Created by Marek Serafin on 6/6/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSSimpleCell.h"
#import "MSStyleSheet.h"
#import "UIColor+FlatUI.h"

@implementation MSSimpleCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self _setupViewElements];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self _setupAutoLayout];
}


#pragma mark - MSRSSItemCell (Private)

- (void)_setupViewElements
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_descLabel];
    
    _titleLabel.font = [MSStyleSheet defaultCellTitleFont];
    _descLabel.font = [MSStyleSheet defaultCellBigDateFont];
    
    _titleLabel.textColor = [MSStyleSheet defaultCellTitleTextColor];
    _descLabel.textColor = [MSStyleSheet defaultCellDateTextColor];
    
    _titleLabel.highlightedTextColor = [UIColor cloudsColor];
    _descLabel.highlightedTextColor = [UIColor wetAsphaltColor];
}

- (void)_setupAutoLayout
{
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-5-[_titleLabel(>=20)]-5-[_descLabel(15)]-5-|"
                                                                 options: 0
                                                                 metrics: nil
                                                                   views: NSDictionaryOfVariableBindings(_titleLabel, _descLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"|-10-[_titleLabel(>=1)]-10-|"
                                                                 options: 0
                                                                 metrics: nil
                                                                   views: NSDictionaryOfVariableBindings(_titleLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"|-10-[_descLabel(>=1)]-10-|"
                                                                 options: 0
                                                                 metrics: nil
                                                                   views: NSDictionaryOfVariableBindings(_descLabel)]];
    
}


@end

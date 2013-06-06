//
//  MSRSSItemCell.m
//  Schibsted
//
//  Created by Marek Serafin on 6/6/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSRSSItemCell.h"
#import "MSStyleSheet.h"
#import "UIColor+FlatUI.h"

@implementation MSRSSItemCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self _setupViewElements];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self _setupAutoLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if(selected) {
        _titleLabel.textColor = [UIColor cloudsColor];
        _dateLabel.textColor = [UIColor wetAsphaltColor];
    } else {
        _titleLabel.textColor = [MSStyleSheet defaultCellTitleTextColor];
        _dateLabel.textColor = [MSStyleSheet defaultCellDateTextColor];
    }
        
}

#pragma mark - MSRSSItemCell (Private)

- (void)_setupViewElements
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_dateLabel];
    
    _titleLabel.font = [MSStyleSheet defaultCellTitleFont];
    _dateLabel.font = [MSStyleSheet defaultCellBigDateFont];
    
    _titleLabel.textColor = [MSStyleSheet defaultCellTitleTextColor];
    _dateLabel.textColor = [MSStyleSheet defaultCellDateTextColor];
}

- (void)_setupAutoLayout
{
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-5-[_titleLabel(>=20)]-5-[_dateLabel(15)]-5-|"
                                                                 options: 0
                                                                 metrics: nil
                                                                   views: NSDictionaryOfVariableBindings(_titleLabel, _dateLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"|-10-[_titleLabel(>=1)]-10-|"
                                                                 options: 0
                                                                 metrics: nil
                                                                   views: NSDictionaryOfVariableBindings(_titleLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"|-10-[_dateLabel(>=1)]-10-|"
                                                                 options: 0
                                                                 metrics: nil
                                                                   views: NSDictionaryOfVariableBindings(_dateLabel)]];
    
}


@end

//
//  MSJsonItemCell.m
//  Schibsted
//
//  Created by Marek Serafin on 6/6/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSJsonItemCell.h"
#import "MSStyleSheet.h"

@implementation MSJsonItemCell

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

#pragma mark - MSJsonItemCell (Private)

- (void)_setupViewElements
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_descLabel];
    [self.contentView addSubview:_dateLabel];
    
    _titleLabel.font = [MSStyleSheet defaultCellTitleFont];
    _descLabel.font = [MSStyleSheet defaultCellSubitleFont];
    _dateLabel.font = [MSStyleSheet defaultCellDateFont];
    
    _titleLabel.textColor = [MSStyleSheet defaultCellTitleTextColor];
    _descLabel.textColor = [MSStyleSheet defaultCellSubitleTextColor];
    _dateLabel.textColor = [MSStyleSheet defaultCellDateTextColor];
}

- (void)_setupAutoLayout
{
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-5-[_titleLabel(>=20)]-3-[_descLabel(>=15)]-3-[_dateLabel(15)]-3-|"
                                                                 options: 0
                                                                 metrics: nil
                                                                   views: NSDictionaryOfVariableBindings(_titleLabel, _descLabel, _dateLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"|-10-[_titleLabel(>=1)]-10-|"
                                                                 options: 0
                                                                 metrics: nil
                                                                   views: NSDictionaryOfVariableBindings(_titleLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"|-10-[_descLabel(>=1)]-10-|"
                                                                 options: 0
                                                                 metrics: nil
                                                                   views: NSDictionaryOfVariableBindings(_descLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"|-10-[_dateLabel(>=1)]-10-|"
                                                                 options: 0
                                                                 metrics: nil
                                                                   views: NSDictionaryOfVariableBindings(_dateLabel)]];

}

@end

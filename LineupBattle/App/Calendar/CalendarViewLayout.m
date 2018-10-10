//
// Created by Anders Borre Hansen on 11/12/13.
// Copyright (c) 2013 xip. All rights reserved.
//

#import "CalendarViewLayout.h"


@implementation CalendarViewLayout

- (id)init {
    self = [super init];

    if(self) {
      self.itemSize = CGSizeMake(64.f, 90.f);
      self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
      self.minimumLineSpacing = 0.f;
    }

    return self;
}
@end

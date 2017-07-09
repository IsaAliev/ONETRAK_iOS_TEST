//
//  IASegmentedView.h
//  ONETRAK_iOS_TEST_Aliev_Isa
//
//  Created by user on 08.07.17.
//  Copyright © 2017 ISA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IASegmentedView : UIView

@property (strong, nonatomic) NSArray* percentageArray;
@property (strong, nonatomic) NSArray* colors;

- (void)revealAnimated:(BOOL)animated;
@end

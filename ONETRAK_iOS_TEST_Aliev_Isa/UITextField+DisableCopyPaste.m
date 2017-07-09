//
//  UITextField+DisableCopyPaste.m
//  ONETRAK_iOS_TEST_Aliev_Isa
//
//  Created by user on 09.07.17.
//  Copyright © 2017 ISA. All rights reserved.
//

#import "UITextField+DisableCopyPaste.h"

@implementation UITextField (DisableCopyPaste)
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if (action == @selector(paste:) || action == @selector(copy:)) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}
@end

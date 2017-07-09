//
//  IAErrorPresenter.m
//  ONETRAK_iOS_TEST_Aliev_Isa
//
//  Created by user on 09.07.17.
//  Copyright © 2017 ISA. All rights reserved.
//

#import "IAErrorPresenter.h"

@implementation IAErrorPresenter


+(void)showErrorWithMessage:(NSString*)message {
    
    UIAlertController* errorVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"") message:message preferredStyle:UIAlertControllerStyleAlert];
    [errorVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:errorVC animated:YES completion:nil];
}

@end

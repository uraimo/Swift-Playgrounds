//
//  main.m
//  ErrorHandling
//
//  Created by Umberto Raimondi on 30/10/15.
//  Copyright © 2015 Umberto Raimondi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorHandling-Swift.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        MyClass* c = [MyClass new];
        NSError* err=nil;
        [c throwAnErrorAndReturnError:&err];
        NSLog(@"Domain:%@ Code:%d Message:%@",err.domain,err.code,err.localizedDescription);
        [c callMe];

    }
    return 0;
}

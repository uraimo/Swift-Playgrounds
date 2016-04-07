//
//  CExample.c
//  SwiftAndC
//
//  Created by Umberto Raimondi on 31/03/16.
//  Copyright © 2016 Umberto Raimondi. All rights reserved.
//

#include "CExample.h"
#include <stdio.h>


void printStuff(){
    printf("Printing something!\n");
}

void giveMeUnsafeMutablePointer(int* param){
}

void giveMeUnsafePointer(const int * param){
}

void functionThatExpectsAConstCharPointer(const char * param){
}

function_type returnAFunction(){
    return &printStuff;
}

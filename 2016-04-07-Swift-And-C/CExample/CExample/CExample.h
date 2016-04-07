//
//  CExample.h
//  SwiftAndC
//
//  Created by Umberto Raimondi on 31/03/16.
//  Copyright © 2016 Umberto Raimondi. All rights reserved.
//

#ifndef CExample_h
#define CExample_h

#include <stdio.h>

#define IAMADEFINE 42

void printStuff();
void giveMeUnsafeMutablePointer(int* param);
void giveMeUnsafePointer(const int * param);
void functionThatExpectsAConstCharPointer(const char * param);

typedef void (*function_type)(void);

function_type returnAFunction();

void aCFunctionWithContext(void* ctx, void (*function)(void* ctx));

typedef struct {
    char name[5];
    int value;
} MyStruct;

char name[] = "IAmAString";
char* anotherName = "IAmAStringToo";

#endif /* CExample_h */

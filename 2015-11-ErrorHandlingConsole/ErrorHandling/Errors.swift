//
//  Errors.swift
//  ErrorHandling
//
//  Created by Umberto Raimondi on 30/10/15.
//  Copyright © 2015 Umberto Raimondi. All rights reserved.
//

import Foundation

@objc enum MyError:Int, ErrorType{
    case AnError
    case AnotherError
}


public class MyClass:NSObject{
    
    public func throwAnError() throws {
        throw MyError.AnotherError
    }
    
    public func callMe(){
        print("Someone called!")
    }
    
}
//: Playground - noun: a place where people can play
//
// See original post at http://www.uraimo.com/2015/10/29/error-handling-from-objective-c-to-swift-2-and-back/

/////////////////////////////////////
//Simple Example
enum MyError : Error{
    case AnError
    case AnotherError
    case JustAnotherError
}

func throwsError()throws ->Int {
    throw MyError.AnotherError
}

do{
    try throwsError()
}catch MyError.AnError {
    print("AnError")
}catch MyError.AnotherError {
    print("AnotherError")  //AnotherError will be catched and printed
}catch{
    print("Something else happened")
}

do{
    do{
        try throwsError()
    }catch MyError.AnError {
        print("AnError")
    }
}catch MyError.AnotherError {
    print("AnotherError")  //AnotherError will be catched and printed
}catch{
    print("Something else happened")
}


/////////////////////////////////////
// More complex example

enum MyError2 : Error{
    case GenericError
    case DetailedError(String)
    case NumericError(Int)
}

func throwsDetailedError()throws ->Int {
    throw MyError2.DetailedError("Some details here")
}

func shouldNeverThrow()throws ->Int {
    return 0
}

do{
    defer{
        //Clean up
    }
    
    try throwsDetailedError()
    var value = try! shouldNeverThrow()
    var imNil = try? throwsDetailedError()
}catch MyError2.GenericError {
    print("GenericError")
}catch MyError2.DetailedError(let message) {
    print("Error: \(message)")  //Will print Error: Some details here
}catch MyError2.NumericError(let number) where number>0{
    print("Error with id: "+String(number))
}catch{
    print("Something else happened: "+String(describing:error))
}



var convertedInt = (try? shouldNeverThrow()).map{String($0)}
convertedInt





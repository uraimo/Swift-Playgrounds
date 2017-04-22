//: [Previous - GCD](@previous)

import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true


/*: 
# OperationQueue
*/


/*:
 ### Operation Queue Basics
 */

var queue = OperationQueue()
queue.name = "My Custom Queue"
queue.maxConcurrentOperationCount = 2

var mainqueue = OperationQueue.main //Refers to the queue of the main thread

queue.addOperation {
    print("Op1")
}
queue.addOperation {
    print("Op2")
}


//: Operations

var op3 = BlockOperation(block: {
    print("Op3")
})
op3.queuePriority = .veryHigh
op3.completionBlock = {
    if op3.isCancelled {
        print("Someone cancelled me.")
    }
    print("Completed Op3")
}


var op4 = BlockOperation {
    print("Op4 always after Op3")
    OperationQueue.main.addOperation{
        print("I'm on main queue!")
    }
}

//: Dependencies between operations

op4.addDependency(op3)

queue.addOperation(op4)  // op3 will complete before op4, always
queue.addOperation(op3)

//: Operation status

op3.isReady       //Ready for execution?
op3.isExecuting   //Executing now?
op3.isFinished    //Finished naturally or cancelled?
op3.isCancelled   //Manually cancelled?

//: Cancel operations

queue.cancelAllOperations()

op3.cancel()

//: Suspend or check suspension status

queue.isSuspended = true












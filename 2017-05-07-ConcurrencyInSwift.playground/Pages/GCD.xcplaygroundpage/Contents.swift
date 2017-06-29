/*:
 
 ## All About Concurrency in Swift - Part 1: The Present Playground
 
 Read the post at [uraimo.com](https://ww.uraimo.com/2017/05/07/all-about-concurrency-in-swift-1-the-present/)
 
 */


//: [Previous - Primitives](@previous)

import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

/*:
# GCD - Grand Central Dispatch
 */


/*:
 ### Dispatch Queues
 
 A Thread pool that executes your jobs submitted as closures
 */

//: Create a new queue or use one of the default queues

let serialQueue = DispatchQueue(label: "com.uraimo.Serial1")  //attributes: .serial

let concurrentQueue = DispatchQueue(label: "com.uraimo.Concurrent1", attributes: .concurrent)

let mainQueue = DispatchQueue.main

let globalDefault = DispatchQueue.global()

let backgroundQueue = DispatchQueue.global(qos: .background)

let serialQueueHighPriority = DispatchQueue(label: "com.uraimo.SerialH", qos: .userInteractive)

//: Executing closures on a specific queue

globalDefault.async {
    print("Async on MainQ, first?")
}

globalDefault.sync {
    print("Sync in MainQ, second?")
}

DispatchQueue.global(qos: .background).async {
    // Some background work here
    
    DispatchQueue.main.async {
        // It's time to update the UI
        print("UI updated on main queue")
    }
}

//: Delayed execution

globalDefault.asyncAfter(deadline: .now() + .seconds(3)) {
    print("After 3 seconds")
}

//: Shortcut for multiple concurrent calls

globalDefault.sync {
    DispatchQueue.concurrentPerform(iterations: 5) {
        print("\($0) times")
    }
}


//: Execution with a final completion barrier

concurrentQueue.async {
    DispatchQueue.concurrentPerform(iterations: 20) { (id:Int) in
        sleep(1)
        print("Async on concurrentQueue, 5 times: "+String(id))
    }
}

concurrentQueue.async (flags: .barrier) {
    print("All 5 concurrent tasks completed")
}

//: Dispatch_once and Singletons

//: Leveraging atomic initialization property of variables
func runMe() {
    struct Inner {
        static let i: () = {
            print("Once!")
        }()
    }
    Inner.i
}

runMe()
runMe()
runMe()


//: With a proper extension to DispatchQueue

public extension DispatchQueue {
    
    private static var _onceTokens = [Int]()
    private static var internalQueue = DispatchQueue(label: "dispatchqueue.once")
    
    public class func once(token: Int, closure: (Void)->Void) {
        internalQueue.sync {
            if _onceTokens.contains(token) {
                return
            }else{
                _onceTokens.append(token)
            }
            closure()
        }
    }
}

let t = 1
DispatchQueue.once(token: t) {
    print("only once!")
}
DispatchQueue.once(token: t) {
    print("Two times!?")
}
DispatchQueue.once(token: t) {
    print("Three times!!?")
}


//: DispatchGroups, group together jobs on different queues

let mygroup = DispatchGroup()

for i in 0..<5 {
    globalDefault.async(group: mygroup){
        sleep(UInt32(i))
        print("Group async on globalDefault:"+String(i))
    }
}

//: A notification is triggered when all jobs complete or ....

print("Waiting for completion...")
mygroup.notify(queue: globalDefault) {
    print("Notify received, done waiting.")
}
mygroup.wait()
print("Done waiting.")


//: When there are no more members in the group

print("Waiting again for completion...")
mygroup.notify(queue: mainQueue) {
    print("Notify received, done waiting on mainQueue.")
}
for i in 0..<5 {
    mygroup.enter()
    sleep(UInt32(i))
    print("Group async on mainQueue:"+String(i))
    mygroup.leave()
}

//: Inactive DispatchQueue

let inactiveQueue = DispatchQueue(label: "com.uraimo.inactiveQueue", attributes: [.concurrent, .initiallyInactive])
inactiveQueue.async {
    print("Done!")
}
print("Not yet...")
inactiveQueue.activate()
print("Gone!")


//: DispatchWorkItems

let workItem = DispatchWorkItem {
    print("Done!")
}

workItem.perform()


workItem.notify(queue: DispatchQueue.main) {
    print("Notify on Main Queue!")
}

globalDefault.async(execute: workItem)

//workItem.cancel()
//workItem.wait()


//: DispatchSemaphore

let sem = DispatchSemaphore(value: 2)

// The semaphore will be held by groups of two pool threads 
globalDefault.sync {
    DispatchQueue.concurrentPerform(iterations: 10) { (id:Int) in
        sem.wait(timeout: DispatchTime.distantFuture)
        sleep(1)
        print(String(id)+" acquired semaphore.")
        sem.signal()
    }
}



//: Dispatch assertions, assertions to verify that we are on the right queue

// Uncomment to crash!
//dispatchPrecondition(condition: .notOnQueue(mainQueue))



//: [Next - NSOperationQueue](@next)

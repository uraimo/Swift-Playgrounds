// All About Concurrency in Swift: The Present Playground
//
//
//

/*:
 # Contents
 
 * [Timer and Concurrency Primitives](#Primitives)
 * [GCD- Grand Central Dispatch](#GCD)
 * [NSOperationQueue](#NSOperationQueue)
 */

import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true


/*:
# Timer and Concurrency Primitives
*/

/*: 
### Timer

 Printing a message after 5 seconds with a Timer
*/
class Handler : NSObject{
    func after5Sec(timer:Timer){
        print("Called after 5 seconds!")
        if let userInfo = timer.userInfo as? [String:String] {
            print("Invoked with param: " + userInfo["param1"]!)
        }
        timer.invalidate() //Always invalidate the current timer
    }
}

let h = Handler()

let timer = Timer.scheduledTimer(timeInterval: 5,
                                 target: h,
                                 selector: #selector(Handler.after5Sec(timer:)),
                                 userInfo: ["param1":"value1"],
                                 repeats: false)

// To stop the timer from firing
//timer.invalidate()
/*:
 ### Threads and concurrency primitives
 
 Sleeping for 2 seconds and then printing
 */

class MyThread : Thread {
    override func main(){
        print("Thread started, sleep for 2 seconds...")
        sleep(2)
        print("Done sleeping, exiting thread")
    }
}

var t = MyThread()
t.stackSize = 1024 * 16
t.start()               //Time needed to spawn a thread aroun 100us

/*:
 ### NSLock
 
 A simple lock
 */

let lock = NSLock()

class LThread : Thread {
    var id:Int = 0
    
    convenience init(id:Int){
        self.init()
        self.id = id
    }
    
    override func main(){
        lock.lock()
        print(String(id)+" acquired lock.")
        lock.unlock()
        if lock.try() {
            print(String(id)+" acquired lock again.")
            lock.unlock()
        }else{  // If already locked move along.
            print(String(id)+" couldn't acquire lock.")
        }
        print(String(id)+" exiting.")
    }
}


var t1 = LThread(id:1)
var t2 = LThread(id:2)
t1.start()
t2.start()

/*:
 ### NSRecursiveLock
 
 A lock that can be acquired multiple times by the same thread without blocking
 */

let rlock = NSRecursiveLock()

class RThread : Thread {
    
    override func main(){
        rlock.lock()
        print("Thread acquired lock")
        callMe()
        rlock.unlock()
        print("Exiting main")
    }
    
    func callMe(){
        rlock.lock()
        print("Thread acquired lock")
        rlock.unlock()
        print("Exiting callMe")
    }
}


var tr = RThread()
tr.start()

/*:
 ### NSConditionLock
 
 A lock with multiple internal sublocks related different conditions or states
 */

let NO_DATA = 1
let GOT_DATA = 2
let clock = NSConditionLock(condition: NO_DATA)
var SharedInt = 0


class ProducerThread : Thread {
    
    override func main(){
        for i in 0..<5 {
            clock.lock(whenCondition: NO_DATA) //Acquire the lock when NO_DATA
            //If we don't have to wait for consumers we could have just done clock.lock()
            SharedInt = i
            clock.unlock(withCondition: GOT_DATA) //Unlock and set as GOT_DATA
        }
    }
}

class ConsumerThread : Thread {
    
    override func main(){
        for i in 0..<5 {
            clock.lock(whenCondition: GOT_DATA) //Acquire the lock when GOT_DATA
            print(i)
            clock.unlock(withCondition: NO_DATA) //Unlock and set as NO_DATA
        }
    }
}

let pt = ProducerThread()
let ct = ConsumerThread()
ct.start()
pt.start()

/*:
 ### NSCondition
 
 A condition lock with wait/signal
 */

let cond = NSCondition()
var available = false
var SharedString = ""

class WriterThread : Thread {
    
    override func main(){
        for _ in 0..<5 {
            cond.lock()
            SharedString = "😅"
            available = true
            cond.signal() // Notify and wake up the waiting thread/s
            cond.unlock()
        }
    }
}

class PrinterThread : Thread {
    
    override func main(){
        for _ in 0..<5 { //Just do it 5 times
            cond.lock()
            while(!available){   //Protect from spurious signals
                cond.wait()
            }
            print(SharedString)
            SharedString = ""
            available = false
            cond.unlock()
        }
    }
}

let writet = WriterThread()
let printt = PrinterThread()
printt.start()
writet.start()

//: [Next - GCD](@next)


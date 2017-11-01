//: 10 Swift One Liners To Impress Your Friends
//: -----
//:
//: See original post at [https://www.uraimo.com/2016/01/06/10-Swift-One-Liners-To-Impress-Your-Friends](https://www.uraimo.com/2016/01/06/10-Swift-One-Liners-To-Impress-Your-Friends)


import Foundation


//:#1 Multiply each element of an array by 2


(1...1024).map{$0 * 2}


//:#2 Sum a list of numbers


(1...1024).reduce(0,+)


//:#3 Verify if Exists in a String


let words = ["Swift","iOS","cocoa","OSX","tvOS"]
let tweet = "This is an example tweet larking about Swift"

let valid = !words.filter({tweet.contains($0)}).isEmpty
valid //true

//Or alternatively, as suggested by @oisdk

let valid2 = words.contains(where:tweet.contains)
valid2 //true

let valid3 = tweet.split(separator:" ")
                .lazy
                .map(String.init)
                .contains(where:Set(words).contains)
valid3 //true

//:#4 Read in a File


let path = Bundle.main.path(forResource:"test", ofType: "txt")
let lines = try? String(contentsOfFile: path!).split{$0 == "\n"}
                     .map(String.init)

if let lines=lines {
    lines[0] // O! for a Muse of fire, that would ascend
    lines[1] // The brightest heaven of invention!
    lines[2] // A kingdom for a stage, princes to act
    lines[3] // And monarchs to behold the swelling scene.
}


//:#5 Happy Birthday to You!


let name = "uraimo"
(1...4).forEach{print("Happy Birthday " + (($0 == 3) ? "dear \(name)":"to You"))}


//:#6 Filter list of numbers

//Obvious implementation
extension Sequence{
    typealias Element = Self.Iterator.Element
    
    func partitionBy(fu: (Element)->Bool)->([Element],[Element]){
        var first: [Element] = []
        var second: [Element] = []
        for el in self {
          if fu(el) {
             first.append(el)
          }else{
             second.append(el)
          }
        }
        return (first,second)
   } 
} 

let part = [82, 58, 76, 49, 88, 90].partitionBy{$0 < 60}
part // ([58, 49], [82, 76, 88, 90])

//Slightly improved implementation
extension Sequence{ 
   func anotherPartitionBy(fu: (Self.Iterator.Element)->Bool)->
          ([Self.Iterator.Element],[Self.Iterator.Element]){ 
      return (self.filter(fu),self.filter({!fu($0)})) 
   } 
} 

let part2 = [82, 58, 76, 49, 88, 90].anotherPartitionBy{$0 < 60}
part2 // ([58, 49], [82, 76, 88, 90])


//This is better, but needs type hints to make it easier to evaluate or it will trigger a complexity error
var part3 = [82, 58, 76, 49, 88, 90].reduce( ([],[]), { 
   (a:([Int],[Int]),n:Int) -> ([Int],[Int]) in 
   (n<60) ? (a.0+[n],a.1) : (a.0,a.1+[n])  
}) 
part3 // ([58, 49], [82, 76, 88, 90])


//:#7 Fetch and Parse an XML web service, using https://github.com/tadija/AEXML


//Uncomment to enable, will reload on every modification

let xmlDoc = try? AEXMLDocument(xmlData: NSData(contentsOf: URL(string:"https://www.ibiblio.org/xml/examples/shakespeare/hen_v.xml")!)!) 

if let xmlDoc=xmlDoc {
    let prologue = xmlDoc.root.children[6]["PROLOGUE"]["SPEECH"]
    prologue.children[1].stringValue // Now all the youth of England are on fire,
    prologue.children[2].stringValue // And silken dalliance in the wardrobe lies:
    prologue.children[3].stringValue // Now thrive the armourers, and honour's thought
    prologue.children[4].stringValue // Reigns solely in the breast of every man:
    prologue.children[5].stringValue // They sell the pasture now to buy the horse,
}


//:#8 Find minimum (or maximum) in a List


//Find the minimum of an array of Ints 
[10,-22,753,55,137,-1,-279,1034,77].sorted().first 
[10,-22,753,55,137,-1,-279,1034,77].reduce(Int.max, min) 
[10,-22,753,55,137,-1,-279,1034,77].min()

//Find the maximum of an array of Ints 
[10,-22,753,55,137,-1,-279,1034,77].sorted().last 
[10,-22,753,55,137,-1,-279,1034,77].reduce(Int.min, max) 
[10,-22,753,55,137,-1,-279,1034,77].max()


//:#9 Parallel Processing
//:
//: Not available in Swift yet but can be built: [http://moreindirection.blogspot.it/2015/07/gcd-and-parallel-collections-in-swift.html](http://moreindirection.blogspot.it/2015/07/gcd-and-parallel-collections-in-swift.html)


//:#10 Sieve of Erathostenes


// With Side-effects
var n = 50
var primes = Set(2...n)


(2...Int(sqrt(Double(n)))).forEach{
     primes.subtract(Set(stride(from:2*$0, to:n, by:$0)))
}
primes.sorted()


// Without Side-effects
var sameprimes = Set(2...n) 

sameprimes.subtract(Set(2...Int(sqrt(Double(n)))) 
                   .flatMap{stride(from:2*$0, to:n, by:$0)}) 
sameprimes.sorted()


//:#11 Bonus: Tuple swap via destructuring


var a=1,b=2

(a,b) = (b,a)
a
b



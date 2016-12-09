#EndlessFibonacciTable

This is my solution for a problem brought up at a [try! Swift meetup](https://www.meetup.com/try_SwiftNYC/events/235937087/)

## Problem

Endlessly display the Fibonacci sequence in a table.

## Explanation

A lot of apps automatically load more data when you scroll to the bottom of a table. So when I heard this problem, it sounded like an exercise to test how you might implement just that. 

I retrieved the numbers in the Fibonacci sequence in segments, as if they were being returned by a network call that only returned the next set of objects to display.

The basic algorithm is like this

1. Load initial set of data and display it
2. If you're at the bottom of the table, go to step 3. ...Else go to step 2
3. Calculate more numbers
4. Append new numbers to the existing set of data 
5. Display data
6. Go to step 2

I made a tableView with 2 sections, one that held the data, and one to show a LoadingCell, which contains a UIActivityIndicatorView. In the delegate method `tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)`, I'm checking if I'm in the second section, then loading more results if I wasn't already. The reason for checking that I'm not currently retrieving numbers, is to avoid the possibility of calling `loadData()` when I'm already loading the data.

```swift
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            return
        }
        
        guard let loadingCell = cell as? LoadingCell else {
            return
        }
        
        loadingCell.startAnimating()
        
        if isRetrievingNumbers == false {
            loadData()
        }
    }
```

NOTE: The calculation happens so fast that by the time this method is called, the next set of objects are already rendered, so I don't think you ever see the LoadingCell

The `loadData()` method looks like this

```swift
    fileprivate func loadData() {
        
        retrieveNextFibonacciNumbers { [unowned self] (sequence) in
            self.data.append(contentsOf: sequence)
            self.tableView.reloadData()
            self.isRetrievingNumbers = false
        }
        
        isRetrievingNumbers = true
    }
```

All this is code is doing is calling a function, `retrieveNextFibonacciNumbers(_ completion: ((_ seq: [Int]) -> ())?)`, which will give you the next set of Fibonacci numbers as a parameter to a completion block that you've passed.

In that completion block, you can take that set of numbers, render it in the table, then set the `isRetrievingNumbers` flag

This pattern is common in networking, when work is done asynchronously - if you want some data from a server, you make the request, then tell it what to do with the results whenever it finishes.

Here's where the actual calculation is taking place 

```swift
    private func retrieveNextFibonacciNumbers(_ completion: ((_ seq: [Int]) -> ())?) {
        
        // Gets 12 digits at a time
      
        let first = data[data.count - 1] &+ data[data.count - 2]
        let second = first &+ data[data.count - 1]
        var seq = [first, second]
        
        var i = 0
        while i < 10 {
            let next = seq[seq.count - 1] &+ seq[seq.count - 2]
            seq.append(next)
            i += 1
        }
        
        DispatchQueue.main.async {
            completion?(seq)
        }
        
    }
```

## Integer overflow in Swift

So Swift will crash your program when there's integer overflow, did not know this before encountering this problem. From the Apple docs

> Unlike arithmetic operators in C, arithmetic operators in Swift do not overflow by default. Overflow behavior is trapped and reported as an error. To opt in to overflow behavior, use Swift’s second set of arithmetic operators that overflow by default, such as the overflow addition operator (&+). All of these overflow operators begin with an ampersand (&).

This doesn't happen in Obj-C, neither in Java nor Ruby, so the behavior caught me by surprise. Rather than properly handling the overflow to print accurate results, I just used [overflow addition](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AdvancedOperators.html#//apple_ref/doc/uid/TP40014097-CH27-ID37) to avoid the crash. After googling, looks like there's no native support for something like BigNum in Swift, but libraries like [this](https://github.com/lorentey/BigInt) exist.

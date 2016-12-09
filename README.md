#EndlessFibonacciTable

This is my solution for a problem brought up at a [try! Swift meetup](https://www.meetup.com/try_SwiftNYC/events/235937087/)

## Integer overflow in Swift

So Swift will crash your program when there's integer overflow, did not know this before encountering this problem. From the Apple docs

> Unlike arithmetic operators in C, arithmetic operators in Swift do not overflow by default. Overflow behavior is trapped and reported as an error. To opt in to overflow behavior, use Swift’s second set of arithmetic operators that overflow by default, such as the overflow addition operator (&+). All of these overflow operators begin with an ampersand (&).

This doesn't happen in Obj-C, neither in Java nor Ruby, so the behavior caught me by surprise. Rather than properly handling the overflow to print accurate results, I just used [overflow addition](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AdvancedOperators.html#//apple_ref/doc/uid/TP40014097-CH27-ID37) to avoid the crash. After googling, looks like there's no native support for something like BigNum in Swift, but libraries like [this](https://github.com/lorentey/BigInt) exist.

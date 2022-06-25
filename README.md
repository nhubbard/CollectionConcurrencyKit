# CollectionConcurrencyKit 2.0

Welcome to **CollectionConcurrencyKit**, a lightweight Swift package that adds asynchronous and concurrent versions of the standard `map`, `flatMap`, `compactMap`, and `forEach` APIs to all Swift collections that conform to the `Sequence` protocol. That includes built-in types, like `Array`, `Set`, and `Dictionary`, as well as any custom collections that conform to that protocol.

CollectionConcurrencyKit can be used to implement high-performance data processing and algorithms in a way that fully utilizes Swift's built-in concurrency system. It's heavily unit tested, fully documented, and used in production to generate [swiftbysundell.com](https://swiftbysundell.com).

## Comparison of this fork vs. the original package

The following changes have been made to this fork of CollectionConcurrencyKit:

* [JohnSundell/CollectionConcurrencyKit#7](https://github.com/JohnSundell/CollectionConcurrencyKit/pull/7) has been applied to this fork. It enhances performance over the original version of the package.
* All functions are now marked as `@inlinable` to allow the Swift compiler to inline the provided functions in performance-critical situations.
* The package now requires Swift 5.6 to build.
* The minimum platform has been raised to these versions:
	* iOS 15
	* macOS 12
	* watchOS 8
	* tvOS 15
* Linux support has been dropped; I don't develop anything in Swift on Linux, and it's difficult to maintain if I don't ever use it on Linux.
* The package layout has been changed to adopt the standard Swift package layout, most notably changing the original `Sources` folder to `Sources/CollectionConcurrencyKit` and `Tests` folder to `Tests/CollectionConcurrencyKit`.

## Asynchronous Iterations

The async variants of CollectionConcurrencyKit's APIs enable you to call `async`-marked functions within your various mapping and `forEach` iterations.

**Note**: Unlike the original package, this version does not maintain the original order at this time. The author is currently considering whether to modify the code and include the ability to preserve order.

For example, here's how we could use `asyncMap` to download a series of HTML strings from a collection of URLs:

```swift
let urls = [
	URL(string: "https://apple.com")!,
	URL(string: "https://swift.org")!,
	URL(string: "https://swiftbysundell.com")!
]

let htmlStrings = try await urls.asyncMap { url -> String in
    let (data, _) = try await URLSession.shared.data(from: url)
    return String(decoding: data, as: UTF8.self)
}
```

And here's how we could use `asyncCompactMap` to ignore any download that failed, by returning an optional value, rather than throwing an error:

```swift
let htmlStrings = await urls.asyncCompactMap { url -> String? in
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(decoding: data, as: UTF8.self)
    } catch {
        return nil
    }
}
```

Each of CollectionConcurrencyKit's APIs come in both throwing and non-throwing variants, so since the above call to `asyncCompactMap` doesn't throw, we don't need to use `try` when calling it.

## Concurrency

CollectionConcurrencyKit also includes concurrent versions of `forEach`, `map`, `flatMap`, and `compactMap`, which perform their iterations in parallel.

For example, since our above HTML downloading code consists of completely separate operations, we could instead use `concurrentMap` to perform each of those operations in parallel for a significant speed boost:

```swift
let htmlStrings = try await urls.concurrentMap { url -> String in
    let (data, _) = try await URLSession.shared.data(from: url)
    return String(decoding: data, as: UTF8.self)
}
```

And if we instead wanted to parallelize our `asyncCompactMap`-based variant of the above code, then we could do so by using `concurrentCompactMap`:

```swift
let htmlStrings = await urls.concurrentCompactMap { url -> String? in
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(decoding: data, as: UTF8.self)
    } catch {
        return nil
    }
}
```

## Included APIs

CollectionConcurrencyKit adds the following APIs to all `Sequence`-conforming Swift collections:

* Async variants that perform each of their operations in sequence, one after the other:
	* `asyncForEach`
	* `asyncMap`
	* `asyncCompactMap`
	* `asyncFlatMap`
* Concurrent variants that perform each of their operations in parallel:
	* `concurrentForEach`
	* `concurrentMap`
	* `concurrentCompactMap`
	* `concurrentFlatMap`

Both throwing and non-throwing versions of all the above APIs are included. To learn more about `map`, `flatMap`, and `compactMap` in general, check out [this article](https://swiftbysundell.com/basics/map-flatmap-and-compactmap).

## System Requirements

CollectionConcurrencyKit works on all 2021 releases of Apple operating systems (iOS 15, macOS 12, watchOS 8, and tvOS 15).

## Installation

CollectionConcurrencyKit is distributed using the [Swift Package Manager](https://swift.org/package-manager). To install it within another Swift package, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    // ...
    dependencies: [
        .package(url: "https://github.com/nhubbard/CollectionConcurrencyKit.git", from: "2.0.0")
    ],
    // ...
)
```

To add this package from Xcode, go to `File > Add Packages...` and paste the repository URL into the search bar to add it to your project.

Then, import it wherever you'd like to use it:

```swift
import CollectionConcurrencyKit
```

For more information on how to use the Swift Package Manager, check out [this article](https://www.swiftbysundell.com/articles/managing-dependencies-using-the-swift-package-manager), or [the official documention](https://swift.org/package-manager).

## Support and Contributing

This fork of CollectionConcurrencyKit, like the original package, is made freely available to the entire Swift community under the very permissive [MIT license](https://github.com/JohnSundell/CollectionConcurrencyKit/blob/main/LICENSE.md).

However, this doesn't come with any support guarantees. You may open an issue in GitHub Issues, but there is no guarantee that the author will respond to it.

Before you start using CollectionConcurrencyKit, it is highly recommended that you spend some time familiarizing yourself with the implementation, in case you run into any issues that you'll need to debug.

If you've found a bug, documentation typo, or want to add an improvement to the code itself (such as a performance improvement or new functions), then feel free to fork the repository, make your contributions, and then open a pull request to contribute it back to this repository.

If you add a new feature or improve performance, please include corresponding new unit tests (for new features) or ensure that the existing unit tests still pass after your changes are applied.

This library is considered mostly feature-complete, however I'm open to entertaining additional features or improvements if you see an opportunity to make them.

Significant thanks are in order to @JohnSundell, who originally authored this library, along with @Frizlab and @AndrewBarba, who respectively created and reviewed the task groups implementation of the concurrency functions.
# Searchable SwiftUI View

### SPM, Prove of concept on how to natively implement SearchView using SwiftUI API's


| Example Countery search app |
| --- |
| ![](Assets/gif_image.gif) |

---

- [Usage](#usage)
- [Installation](#installation)
- [Author](#author)
- [License](#license)


## Usage

```swift
import SearchView
```

Then add `SearchView` in SwiftUI `body` like:
```swift
var body: some View {
    NavigationView {
        SearchView(searchText: $searchText) {
            // Your views ..
        }
    }
}

```

## Installation

> It requires iOS 13 and Xcode 11!

In Xcode go to `File -> Swift Packages -> Add Package Dependency` and paste in the repo's url: `https://github.com/cs4alhaider/SearchView`


## Author
This POC was requested from [let groupe = Swift()](https://t.me/SwiftGroup) Telegram channel. code written by [cs4alhaider](https://twitter.com/cs4alhaider). 

## License

This project is under the MIT license. See the LICENSE file for more info.

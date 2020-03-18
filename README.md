# Searchable SwiftUI View

### Prove of concept on how to natively implement SearchView using SwiftUI API's


| Example Countery search app |
| --- |
| ![](Assets/gif_image.gif) |

---

- [Usage](#usage)
- [Installation](#installation)
- [Author](#author)
- [License](#license)


## Usage

Add `SearchView` in SwiftUI `body` like:
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

#### Drag and drop 

Just take `Searchable View` folder into your project

## Author
This POC was requested from [let groupe = Swift()](https://t.me/SwiftGroup) Telegram channel. code written by [cs4alhaider](https://twitter.com/cs4alhaider). 

## License

This project is under the MIT license. See the LICENSE file for more info.

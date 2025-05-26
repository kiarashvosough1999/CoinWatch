# CoinWatch

# Task

Create an iPhone app that will fetch the current exchange rate of Bitcoin in EUR. The app
contains 2 screens:

- [x] List screen displays the historical price of Bitcoin for the last 2 weeks, including today.
The Bitcoin price for today is realtime, and it’s updated every 60 seconds. Tapping on a
certain day navigates to the detail screen.
- [x] Detail screen displays the price of Bitcoin on that day in EUR, USD and GBP and the
user can go back to the list screen.

# Architecture & Tools

- [x] iOS 16.0
- [x] iPhoneOS
- [x] Clean(Vertical Layering)
- [x] Swift
- [x] SwiftUI With Navigation
- [x] Unit tested

# Approach

1. Used `SwiftUI` to develop the UI more faster.
2. Used `ViewModel`, as the States behind the Views were not complicated, and just needed to be seperated.
3. Used `Resolver` to handle dependency managment as it is great tools for testing and handling dependencies with minimal learning cureve and complexity.
4. Used `Clean-Architecture` to keep layer seperated and follow **seperation of concerns** with **vertical layering**.
5. Wrote several Unit Tests for Viewmodels and UseCases.

## 3th-Party Descision

`Resolver` is to handle depedency managment, of course I could write simple container, but then I should have to drill the dependencies and share them everywhere, and make it hard to manage and test in units. The library has simple APIs which are common across Injection approaches in iOS development, so it is not something new or alien for other developers and has minimum learning curve.

## Architecture Descision

I have decided to use `ViewModel` Component in order to seperate some user interface logic from `Views`, in order to test them in units, and not to depend on view on testing, also keep layers separated and let the view's concern only be rendenring with provided data. State managment is also considered to have proper states on views and actions integrated inside those state to prevent performing actions on invalid states.

vertical layering architecture(clean) is considered, to separate presentation, or anything which is scoped in business logic domain or data layer. To explain more on Vertical layering, you can consider reading this post to get an overview why I prefered to go with it:

[Vertical Layering helps a lot to get a better overview over the application. It is much easier to find things](https://markusherkommer.medium.com/horizontal-and-vertical-layers-in-software-development-4af12e54c08a)

In CoinWatch each layer is defined inside a folder to lower the complexity(instead of creating packages etc.), inside each folder you will find the layers separated. Again not to complicate the networking layer I would rathered to execute the network call directly on Repository as if I wanted to move the calls to another layer, Repository would serve no porpuse rather than an extra layer than pass data, but in real world application there should be a network layer with complicated network calls.

## How To Run

1. Install latest Xcode version.
2. Clone the project and checkout to `development` branch.
3. Open project.
4. Have your iPhone connected to your mac machine(due to a bug on my mac, I wasn't able to run it on simulator, please ensure you run the App on a real device).
5. Install the App on you machine by pushing run button and your iPhone selected as destination.

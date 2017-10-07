# JobQueue

[![CI Status](http://img.shields.io/travis/matanwrites/JobQueue.svg?style=flat)](https://travis-ci.org/matanwrites/JobQueue)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/matanwrites/JobQueue/blob/master/LICENSE.md)

Delayed JobQueue which can execute task between app launches

## Motivation
https://medium.com/@mathieutan/what-can-we-learn-from-backend-development-as-ios-developers-implementing-a-jobqueue-df8b9a5444fe

**Supported Swift Versions:** Swift 3.1

## Carthage

You can install JobQueue via [Carthage](https://github.com/Carthage/Carthage) by adding the following line to your `Cartfile`:

```
github "matanawrites/JobQueue"
```


## Todo
- Explore encoding mechanism in Swift4 http://benscheirman.com/2017/06/ultimate-guide-to-json-parsing-with-swift-4/
- Decouple Job and Executor
- Handle background task
- Add background fetch support
- Add better versioning and compability between queues and tasks


## Author

matanwrites, https://twitter.com/matanwrites


## License

JobQueue is available under the MIT license. See the LICENSE file for more info.

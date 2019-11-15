# AWS Lambda Swift docker builder

This docker image extends the [swift](https://hub.docker.com/_/swift) docker image, installing the [swift-nio](https://github.com/apple/swift-nio) dependencies for linux. It adds a file containing the linux libraries needed for execution and a bootstrap script that loads the previous library before passing execution to our code.

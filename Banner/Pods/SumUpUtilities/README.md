# SumUpUtilities

SumUpUtilities is a loose collection of utilities that is shared among multiple teams/apps/frameworks and is the successor of ISHHelpers/ISHUIElements.

## Contribution Guidelines
This repository is meant for reusable code and utilities that could be beneficial for others. If there is something that could be helpful to others, feel free to add it, but be mindful before doing so and try keep your utilities as generic as you can.

A great example for this is [`UIViewController+Children`](./SumUpUtilities/Extensions/UIViewController%2BChildController.h) or [`NSArray+Helpers`](./SumUpUtilities/Extensions/NSArray%2BHelpers.h). 

There's no strict rule limiting additions to this repository, but please be sensible about it and check whether something already exists before adding it or writing it yourself.

Also, please document everything that you're adding using code documentation, so others know how to use and and/or what something is meant for. Cover your additions with unit tests, if possible, so everyone has confidence it is safe to use, they can rely on it when using it and are comfortable making changes to the code.

## Release Process
The Pod can be updated and published using the [Update pod version](https://github.com/sumup/ios-sumuputilities/actions/workflows/update_pod_version.yml) GitHub Actions workflow.

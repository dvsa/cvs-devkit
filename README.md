# CVS Devkit


## Description

This dev tool allows to manage multiple git operations across all CVS Dev Services

## Installation


To get started locally, follow these instructions:

#### Gem Installation

Download and install rake with the following.

```
  gem install rake
```

Please follow the rake documentation on how to install the package on your machine

#### First

1. clone this repository in your project directory
1. cd into the project and run `rake clone`

## Usage


| Command | Description |
| --- | --- |
|rake help|--  display help|
|rake branch|--  display current branch of all repos|
|rake clone|--  run 'git clone' on all repos|
|rake pull|--  run 'git pull --rebase' on all repos|
|rake create_branch "BRANCH"|--  run 'git checkout -b BRANCH' on all repos|
|rake checkout_master |--  run 'git checkout master' on all repos|
|rake checkout_develop |--  run 'git checkout develop' on all repos|
|rake needs_commit|--  checks if any of the repos need a commit|

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

This tool kit is available as open source under the terms of the [MIT](https://opensource.org/licenses/MIT).















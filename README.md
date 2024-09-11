# Warehouse App

A Rails 7 application mimicing the basic functionality of a fictional warehouse inventory application. This application was created for a technical assessment exercise.

## Prerequisites

* Ruby 3.3
* Postgres 15 (or another ActiveRecord-compatible database that supports the `json` field)

This is a Ruby 3.3 application, and requires Ruby to be installed on your system. I suggest using a Ruby version manager such as [rbenv](https://github.com/rbenv/rbenv) to install Ruby if it is not already available.

## Installation

To install the application, first install the required libraries using Bundler:
```
bundle install
```

Then, prepare the database for its first use:
```
rails db:create
rails db:migrate
```

Once the application has been installed, you can start it by running:
```
rails s
```

## Usage

For information about how to use the application, please see the [Usage Docs](./docs/usage/usage_instructions.md). This documentation is intended for users of the application.

### Testing
This application is tested using RSpec. To run the rspec test suite, run the `rspec` command:

```
% rspec
.........................................

Finished in 0.74474 seconds (files took 2.81 seconds to load)
41 examples, 0 failures
```

### Code Linting
The code follows standards established in the `.rubocop.yml` file. To run an automatic check of the code, run the `rubocop` command:

```
% rubocop
Inspecting 31 files
...............................

31 files inspected, no offenses detected
```

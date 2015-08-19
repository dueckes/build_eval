# build_eval #

Because the status of continuous integration environment statuses should be easy to radiate.

## Status ##

[![Gem Version](https://badge.fury.io/rb/build_eval.svg)](http://badge.fury.io/rb/build_eval)
[![Build Status](https://travis-ci.org/MYOB-Technology/build_eval.png)](https://travis-ci.org/MYOB-Technology/build_eval)
[![Code Climate](https://codeclimate.com/github/MYOB-Technology/build_eval/badges/gpa.svg)](https://codeclimate.com/github/MYOB-Technology/build_eval)
[![Test Coverage](https://codeclimate.com/github/MYOB-Technology/build_eval/badges/coverage.svg)](https://codeclimate.com/github/MYOB-Technology/build_eval/coverage)
[![Dependency Status](https://gemnasium.com/MYOB-Technology/build_eval.png)](https://gemnasium.com/MYOB-Technology/build_eval)

## Usage ##

```BuildEval``` determines the status of builds.

Integrates with commonly used CI platforms to provide an effective status for builds of interest.

Currently supports:

* [TeamCity](https://www.jetbrains.com/teamcity/) via Basic Authentication
* [Travis CI](https://travis-ci.org/) for Open Source projects

### TeamCity Integration ###

```ruby
  require 'build_eval'

  teamcity_monitor = BuildEval.server(
    type:     :TeamCity,
    uri:      "https://some.teamcity.server",
    username: "guest",
    password: "guest" # Note: Only uses basic authentication
  ).monitor("build_1", "build_2", "build_3")
```

### Travis CI Integration ###

```ruby
  require 'build_eval'

  travis_monitor = BuildEval.server(
    type:     :Travis,
    username: "my_username"
  ).monitor("build_1", "build_2", "build_3")
```

#### Reporting Results ####

This example uses the [blinky gem](https://github.com/perryn/blinky) to show the build statuses on a USB light.

```ruby
  require 'blinky'

  light = Blinky.new.light

  loop do
    # Evaluates status of monitored builds
    results = my_monitor.evaluate 

    # Determine the overall status
    light.send(results.status.to_sym)
    # Describes the results of all builds
    puts results.to_s 
  end
```

#### Combining Results #### 

```ruby
  combined_monitor = teamcity_monitor + travis_monitor
```

## Installation ##

In your Gemfile include:

```ruby
  gem 'build_eval'
```

## Requirements ##

* Ruby >= 1.9.3

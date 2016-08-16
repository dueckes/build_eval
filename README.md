# build_eval #

Because the status of continuous integration environment statuses should be easy to radiate.

## Status ##

[![Gem Version](https://badge.fury.io/rb/build_eval.svg)](http://badge.fury.io/rb/build_eval)
[![Build Status](https://travis-ci.org/MYOB-Technology/build_eval.png)](https://travis-ci.org/MYOB-Technology/build_eval)
[![Code Climate](https://codeclimate.com/github/MYOB-Technology/build_eval/badges/gpa.svg)](https://codeclimate.com/github/MYOB-Technology/build_eval)
[![Test Coverage](https://codeclimate.com/github/MYOB-Technology/build_eval/badges/coverage.svg)](https://codeclimate.com/github/MYOB-Technology/build_eval/coverage)
[![Dependency Status](https://gemnasium.com/MYOB-Technology/build_eval.png)](https://gemnasium.com/MYOB-Technology/build_eval)

## Usage ##

`BuildEval` determines the status of builds.

Integrates with commonly used CI platforms to provide an effective status for builds of interest.

Currently supports:

* [TeamCity](https://www.jetbrains.com/teamcity/) via basic authentication
* [Jenkins](https://jenkins.io/) with no authentication
* [Travis CI Org](https://travis-ci.org/) and [Travis CI Pro](https://travis-ci.com/) with GitHub token authentication

### TeamCity Integration ###

```ruby
  require 'build_eval'

  my_monitor = BuildEval.server(
    type:     :TeamCity, # Note: TeamCity servers only support basic authentication
    uri:      "https://some.teamcity.server",
    username: "guest",
    password: "guest"
  ).monitor("build_1", "build_2", "build_3")
```

### Jenkins CI Integration ###
```ruby
  require 'build_eval'

  my_monitor = BuildEval.server(
      type: :Jenkins,
      uri:  "http://some.jenkins.server"
  ).monitor("build_1", "build_2", "build_3")
```

### Travis CI Org (travis-ci.org) Integration ###

```ruby
  require 'build_eval'

  my_monitor = BuildEval.server(
    type:     :TravisOrg,
    username: "my_username"
  ).monitor("build_1", "build_2:some_branch", "build_3") # Reports status of last build, regardless of branch, unless a branch is specified
```

### Travis CI Pro (travis-ci.com) Integration ###

```ruby
  require 'build_eval'

  my_monitor = BuildEval.server(
    type:         :TravisPro,
    username:     "my_username",
    github_token: "ABC123"
  ).monitor("build_1", "build_2:some_branch", "build_3") # Reports status of last build, regardless of branch, unless a branch is specified
```

GitHub tokens can be created in the GitHub web UI Settings page, under `Personal Access Tokens`.

#### Reporting Results ####

This example uses the [blinky gem](https://github.com/perryn/blinky) to show the net status of builds on a USB light.

```ruby
  require 'blinky'
  require 'build_eval'

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
  combined_monitor = a_teamcity_monitor + a_travis_monitor
```

### SSL Options ###

```ruby
  require 'build_eval'

  my_monitor = BuildEval.server(
    type:            :Jenkins,
    uri:             "http://some.firewalled.server",
    ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE # Configurable for non-Travis servers
  ).monitor("some_build")
```

## Installation ##

In your Gemfile include:

```ruby
  gem 'build_eval'
```

## Requirements ##

* Ruby >= 1.9.3

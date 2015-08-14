build_eval
==========

Because the status of continuous integration environment statuses should be easy to radiate.

Status
------------

[![Build Status](https://travis-ci.org/MYOB-Technology/build_eval.png)](https://travis-ci.org/MYOB-Technology/build_eval)
[![Gem Version](https://badge.fury.io/rb/build_eval.svg)](http://badge.fury.io/rb/build_eval)
[![Dependency Status](https://gemnasium.com/MYOB-Technology/build_eval.png)](https://gemnasium.com/MYOB-Technology/build_eval)

Usage
-----

```BuildEval``` determines the status of builds.

Integrates with commonly used CI platforms to provide an effective status for builds of interest.

Currently supports:
* TeamCity via Basic Authentication
* TravisCI for Open Source projects

Example integrating with TeamCity:
```ruby
  require 'build_eval'
  require 'blinky'

  teamcity_monitor = BuildEval.server(
    type:     :TeamCity,
    uri:      "https://some.teamcity.server",
    username: "guest",
    password: "guest" # Note: uses basic authentication
  ).monitor("build_1", "build_2", "build_3")

  loop do
    # Evaluates status of monitored builds
    results = monitor.evaluate 

    # Determine the overall status
    light.send(results.status.to_sym)
    # Describes the results of each build
    puts results.to_s 
  end
end
```

Example integrating with TravisCI:
```ruby
  require 'build_eval'

  travis_monitor = BuildEval.server(
    type:     :Travis,
    username: "my_username"
  ).monitor("build_1", "build_2", "build_3")

end
```

Installation
------------

In your Gemfile include:

```ruby
  gem 'build_eval'
```

Requirements
------------

* Ruby >= 1.9.3

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

It integrates with commonly used CI platforms to provide an effective status for builds of interest.

```ruby
  require 'build_eval'
  require 'blinky'

  teamcity_monitor = BuildEval.server(
    type:     :TeamCity,
    uri:      "https://some.teamcity.server",
    username: "guest",
    password: "guest"
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

Note that unsuccessful builds are 

Installation
------------

In your Gemfile include:

```ruby
  gem 'build_eval'
```

Requirements
------------

* Ruby >= 1.9.3

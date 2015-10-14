#!/bin/bash
gem uninstall build_eval
gem build build_eval.gemspec
gem install './build_eval-0.0.3.gem'
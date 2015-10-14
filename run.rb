require 'blinky'
require 'build_eval'

light = Blinky.new.light
jenkins_monitor = BuildEval.server(
    type: :Jenkins,
    uri: 'http://52.64.226.11:8080'
).monitor("github-push-detector")

loop do
	results = jenkins_monitor.evaluate 
	# Determine the overall status
	light.send(results.status.to_sym)
	# Describes the results of all builds
	puts results.to_s
end
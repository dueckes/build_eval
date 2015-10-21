require 'blinky'
require 'build_eval'

light = Blinky.new.light
jenkins_monitor = BuildEval.server(
    type: :Jenkins,
    uri: 'https://dev-idam-jenkins.cse.dev.myob.com'
).monitor("idam_dev_deploy")

loop do
	results = jenkins_monitor.evaluate 
	# Determine the overall status
	#light.send(results.status.to_sym)
	# Describes the results of all builds
	puts results.to_s
end
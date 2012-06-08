# Motion::Specwrap

The Problem:
* When running "rake spec" in your RubyMotion project, you always get an exit status of 0, irrespective of the tests passing or failing. I believe this is the case because when checking the status code, we are actually getting the Simulator's status code, despite Bacon exiting (from within the context of the simulator) with a proper code.
* This is a problem when integrating your RubyMotion app into a continuous integration workflow which uses this exit status to determine if the build passed or failed. Specifically, I've created this in order to bring RubyMotion support to OctopusCI (http://octopusci.com)
* The problem was reported on 06-06-2012 here: https://groups.google.com/forum/?fromgroups#!topic/rubymotion/1unBYE0wJ-0

As a temporary workaround, this gem does two things:
1) Bacon is made to output its exit status code to standard output, such that:
2) A wrapper script is provided which runs rake spec as normal, checks the exit status code printed by Bacon, and uses it to exit with the correct exit status code.
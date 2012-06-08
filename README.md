# Motion::Specwrap

You may use this gem if you are using a continuous integration server and wish that RubyMotion's `rake spec` command behaved as you would expect (e.g. return an exit status code that reflects your build condition)

### Usage
Add `motion-specwrap` to your Gemfile, run `bundle`, add `motion-specwrap` to your project's Rakefile.
Now you may execute `bundle exec motion-specwrap` instead of `bundle exec rake spec` in order to get a proper exit value corresponding to your tests passing or failing. Woohoo!

### The Problem
* When running "rake spec" in your RubyMotion project, you always get an exit status of 0, irrespective of the tests passing or failing. I believe this is the case because when checking the status code, we are actually getting the Simulator's status code, despite Bacon exiting (from within the context of the simulator) with a proper code.
* This is a problem when integrating your RubyMotion app into a continuous integration workflow which uses this exit status to determine if the build passed or failed. Specifically, I've created this in order to bring RubyMotion support to OctopusCI (http://octopusci.com)
* The problem was reported on 06-06-2012 here: https://groups.google.com/forum/?fromgroups#!topic/rubymotion/1unBYE0wJ-0

### The Workaround
1. Bacon is made to output its exit status code to standard output, such that:
2. A wrapper script is provided which runs rake spec as normal, checks the exit status code printed by Bacon, and uses it to exit with the correct exit status code.

### Final Remarks
I am hoping that lrz goes ahead and solves the original problem in a later patch to RubyMotion. Until then, we can use this.
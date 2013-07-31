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

### Update: July 30, 2013

I'm back on the RM scene again, setting up CI, etc.

Unfortunately it looks like HipByte's fix has regressed in that failing
specs should NOT be returning an exit status of 0.

This means this gem has again become relevant.

There were some issues with it but I've just released v1.0.0 which is a
true wrapper and does not monkeypatch anything like the previous v0.1
did.

```
minivan:baitmotion (master*) $ rake spec
     Build ./build/iPhoneSimulator-6.1-Development
      Link ./build/iPhoneSimulator-6.1-Development/baitmotion_spec.app/baitmotion
    Create ./build/iPhoneSimulator-6.1-Development/baitmotion_spec.app/Info.plist
    Create ./build/iPhoneSimulator-6.1-Development/baitmotion_spec.app/PkgInfo
    Create ./build/iPhoneSimulator-6.1-Development/baitmotion_spec.dSYM
  Simulate ./build/iPhoneSimulator-6.1-Development/baitmotion_spec.app
2013-07-30 19:25:26.772 baitmotion[42697:c07] Application windows are expected to have a root view controller at the end of application launch
Application 'baitmotion'
  - has one window [FAILED - 1.==(2) failed]

Bacon::Error: 1.==(2) failed
  spec.rb:690:in `satisfy:': Application 'baitmotion' - has one window
	spec.rb:704:in `method_missing:'
	spec.rb:315:in `block in run_spec_block'
	spec.rb:439:in `execute_block'
	spec.rb:315:in `run_spec_block'
	spec.rb:330:in `run'

1 specifications (1 requirements), 1 failures, 0 errors
minivan:baitmotion (master*) $ echo $?
0
```

That is not supposed to be 0! I will need to continue supporting this gem in the meanwhile but I have contacted HipByte about this.

---

HipByte issue for this: http://hipbyte.myjetbrains.com/youtrack/issue/RM-230

## motion-specwrap output

```
➜  baitmotion git:(master) ✗ bundle exec motion-specwrap
================================================================================
A new version of RubyMotion is available. Run `sudo motion update' to upgrade.
================================================================================

     Build ./build/iPhoneSimulator-6.1-Development
   Compile /Users/keyvan/baitmotion/build/redgreen_style_config.rb
   Compile ./spec/main_spec.rb
      Link ./build/iPhoneSimulator-6.1-Development/baitmotion_spec.app/baitmotion
    Create ./build/iPhoneSimulator-6.1-Development/baitmotion_spec.dSYM
  Simulate ./build/iPhoneSimulator-6.1-Development/baitmotion_spec.app
Bacon Output Style: :full
Application 'baitmotion'
  - has one window
 [✓] This test has passed! Good job!

  - foo
 [✗] This test has not passed: FAILED - 1.==(2) failed!
 [FAILED - 1.==(2) failed]
 BACKTRACE: Bacon::Error: 1.==(2) failed
	spec.rb:685:in `satisfy:': Application 'baitmotion' - foo
	spec.rb:699:in `method_missing:'
	spec.rb:315:in `block in run_spec_block'
	spec.rb:439:in `execute_block'
	spec.rb:315:in `run_spec_block'
	spec.rb:330:in `run'


  - foo
 [✗] This test has not passed: FAILED - 1.==(2) failed!
 [FAILED - 1.==(2) failed]
 BACKTRACE: Bacon::Error: 1.==(2) failed
	spec.rb:685:in `satisfy:': Application 'baitmotion' - foo
	spec.rb:699:in `method_missing:'
	spec.rb:315:in `block in run_spec_block'
	spec.rb:439:in `execute_block'
	spec.rb:315:in `run_spec_block'
	spec.rb:330:in `run'


  - foo
 [✗] This test has not passed: FAILED - 1.==(2) failed!
 [FAILED - 1.==(2) failed]
 BACKTRACE: Bacon::Error: 1.==(2) failed
	spec.rb:685:in `satisfy:': Application 'baitmotion' - foo
	spec.rb:699:in `method_missing:'
	spec.rb:315:in `block in run_spec_block'
	spec.rb:439:in `execute_block'
	spec.rb:315:in `run_spec_block'
	spec.rb:330:in `run'



4 specifications (4 requirements), 3 failures, 0 errors
 * motion-specwrap read the summary to exit(3)
➜  baitmotion git:(master) ✗ echo $?
3
➜  baitmotion git:(master) ✗
```

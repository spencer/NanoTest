class String
  def red; colorize(self, "\e[1m\e[31m"); end
  def green; colorize(self, "\e[1m\e[32m"); end
  def colorize(text, color_code)  "#{color_code}#{text}\e[0m" end
end

module NanoTest
  class TestFailure < StandardError; end
  module Assertions
    def assert(asserted, message="")
      Runner.assertions += 1
      asserted ? _pass : _fail(message)
    end
    
    def assert_equal(expected, actual, message="")
      assert((expected == actual), message + "\nExpected: #{expected}\nActual: #{actual}")
    end
    
    def assert_not_equal(expected, actual, message="")
      assert(!(expected == actual), message + "\nExpected: #{expected}\nActual: #{actual}")
    end

    def assert_match(expected, actual, message="")
      message ||= ""
      assert(expected =~ actual, message + "\nExpected: #{expected}\nActual: #{actual}")
    end

    def assert_true(asserted, message="")
      assert((asserted), message + "\nAsserted: #{asserted}")
    end
    
    def assert_false(asserted, message="")
      assert(!(asserted), message + "\nAsserted: #{asserted}")
    end
  end
  
 
  class TestCase
    include Assertions
    
    def setup
    end

    def teardown
    end

    def _pass
      print '.'.green
      Runner.passes += 1
    end 

    def _fail(message)
      print 'F'.red
      raise TestFailure.new(message || 'FAIL')
    end

    def _run
      begin
        _run_or_stop { setup }
        puts "\n\n#{'=' * (self.class.to_s.length.to_i)}\n"
        puts self.class
        puts "#{'=' * (self.class.to_s.length.to_i)}\n"
        puts _test_methods
        _test_methods.each do |tm|
          _run_or_stop { send(tm) }
        end
      ensure
        _run_or_stop { teardown }
      end
    end
    
    #self.inherited is a ruby callback.
    def self.inherited(klass)
      Runner.testsuites << klass.new
    end
    

    private
    
    def _test_methods
      self.class.public_instance_methods(true).grep(/^test_/)
    end
    
    def _run_or_stop
      begin
        yield
      rescue Exception => error
        _stop(error)
      end
    end

    def _stop(error)
      Runner.failures << error
    end
  end

  class Runner    
    def self.testsuites
      @testsuites ||= []
    end

    def self.testsuites=(test)
      @testsuites= test
    end
    
    def self.passes
      @passes = 0
    end

    def self.passes= (x)
      @passes = x
    end

    def self.failures
      @failures ||= []
    end

    def self.failures= (x)
      @failures = x
    end

    def self.assertions
      @assertions ||= 0
    end
    
    def self.assertions= (x)
      @assertions = x
    end 

    def self.run_tests
      @testsuites.each do |ts|
        ts._run
      end

      report_results
    end

    def self.report_results
      puts
      puts "#{assertions} assertions".green
      puts "#{failures.select {|f| f.is_a?(TestFailure) }.length} failures, #{failures.reject {|f| f.is_a?(TestFailure) }.length} errors".red
      puts
      @failures.each_with_index{| failure, index| report_failure(failure, index)} 
    end

    def self.report_failure(failure, number = 0)
      require 'pp'
      text = "#{number + 1} #{failure.message} #{(failure.class.name)}"
      puts text.to_s.red
    end
  end
end

at_exit{NanoTest::Runner.run_tests}
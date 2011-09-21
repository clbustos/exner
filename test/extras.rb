require 'TestManchas'
require 'test/unit/ui/console/testrunner'
class TC_ExnerTest < Test::Unit::TestCase
	def setup
		@a= Exner::Rorschach.new
		@a.open_file('test_manchas.txt')
		@a.procesar
	end
	def teardown
	end
end

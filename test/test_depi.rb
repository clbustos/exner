require(File.expand_path(File.dirname(__FILE__)+'/helpers_tests.rb'))

class TC_ExnerDepi < Test::Unit::TestCase
	def setup
		@a= Exner::Rorschach.new
		@a.open_file(Exner.dir_data+'/test_manchas.txt')
		@a.procesar
		@lista=@a.depi(true)
		@p=@a.depi
	end
	def test_numero
		assert_equal(3,@p)
	end
  
	def test_lista
		{
    1=>false,
		2=>false,
		3=>true,
		4=>true,
		5=>false,
		6=>false,
		7=>true
		}.each {|k,v|
			assert_equal(v,@lista[k], "Element #{k} should be #{v} but was #{@lista[k]}")
		}
	end
end


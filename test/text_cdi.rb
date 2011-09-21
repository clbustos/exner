require(File.expand_path(File.dirname(__FILE__)+'/helpers_tests.rb'))


class TC_ExnerCdi < Test::Unit::TestCase
	def setup
		@a= Exner::Rorschach.new
		@a.open_file(Exner.dir_data+'/test_manchas.txt')
		@a.procesar
		@lista=@a.cdi(true)
		@p=@a.cdi
	end
	def teardown
	end
	def test_numero
		assert(@p==2)
	end
	def test_lista
		{1=>false,
		2=>false,
		3=>true,
		4=>false,
		5=>true
		}.each {|k,v|
			assert_equal(v,@lista[k],k)
		}
	end
end


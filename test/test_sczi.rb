require(File.expand_path(File.dirname(__FILE__)+'/helpers_tests.rb'))


class TC_ExnerSczi < Test::Unit::TestCase
	def setup
		@a= Exner::Rorschach.new
		@a.open_file(Exner.dir_data+'/test_manchas.txt')
		@a.procesar
		@lista=@a.sczi(true)
		@p=@a.sczi
	end
	def teardown
	end
	def test_numero
		assert(@p==1)
	end
	def test_lista
		{1=>false,
		2=>false,
		3=>false,
		4=>true,
		5=>false,
		6=>false
		}.each {|k,v|
			assert_equal(v,@lista[k],k)
		}
	end
end


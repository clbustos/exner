require(File.expand_path(File.dirname(__FILE__)+'/helpers_tests.rb'))


class TC_ExnerScon < Test::Unit::TestCase
	def setup
		@a= Exner::Rorschach.new
		@a.open_file(Exner.dir_data+'/test_manchas.txt')
		@a.procesar
		@lista=@a.scon(true)
		@p=@a.scon
	end
	def teardown
	end
	def test_numero
		assert(@p==4)
	end
	def test_lista
		{1=>false,
		2=>false,
		3=>false,
		4=>false,
		5=>false,
		6=>true,
		7=>true,
		8=>true,
		9=>false,
		10=>false,
		11=>false,
		12=>true
		}.each {|k,v|
			assert_equal(v,@lista[k],k)
		}
	end
end

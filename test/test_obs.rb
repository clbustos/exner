require(File.expand_path(File.dirname(__FILE__)+'/helpers_tests.rb'))


class TC_ExnerObs < Test::Unit::TestCase
	def setup
		@a= Exner::Rorschach.new
		@a.open_file(Exner.dir_data+'/test_manchas.txt')
		@a.procesar
		@lista=@a.obs(true)
		@p=@a.obs
	end
	def test_numero
		assert(@p==1)
	end
	def test_lista
		{1=>true,
		2=>false,
		3=>false,
		4=>false,
		5=>false
		}.each {|k,v|
			assert_equal(v,@lista[k],k)
		}
	end
	def test_si
		assert(!@a.obs_si)
	end
end


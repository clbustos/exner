require(File.expand_path(File.dirname(__FILE__)+'/helpers_tests.rb'))



class TC_ExnerHvi < Test::Unit::TestCase
	def setup
		@a= Exner::Rorschach.new
		@a.open_file(Exner.dir_data+'/test_manchas.txt')
		@a.procesar
		@lista=@a.hvi(true)
		@p=@a.hvi
	end
	def test_numero
		assert_equal(3,@p)
	end
	def test_lista
		{1=>true,
		2=>false,
		3=>false,
		4=>false,
		5=>true,
		6=>true,
		7=>false,
		8=>false
		}.each {|k,v|
			assert_equal(v,@lista[k],k)
		}
	end
	def test_si
		assert(!@a.hvi_si)
	end
end


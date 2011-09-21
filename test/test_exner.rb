require(File.expand_path(File.dirname(__FILE__)+'/helpers_tests.rb'))

class TC_ExnerTest < Test::Unit::TestCase
	def setup
		@a= Exner::Rorschach.new
		@a.open_file(Exner.dir_data+'/test_manchas.txt')
		@a.procesar
	end
	def teardown
	end
	def test_localizacion
		assert_equal(9,@a.zf)
		assert_equal(26,@a.zsum)
		assert_equal(27.5,@a.zest)
		assert_equal({'W'=>3,'Wv'=>0,'D'=>9,'Dd'=>4,'S'=>1},@a.localizaciones)
		assert_equal({'+'=>5,'o'=>10,'v/+'=>1,'v'=>0},@a.frecuencias['dq'])
	end
	def test_determinantes_complejos
		assert(@a.complejos.size == 4)
		assert_equal(24,@a.determinantes_simples.size)
		{'M'=>5,'FM'=>3,'m'=>1,'FC'=>1,'CF'=>2,'C'=>0,'Cn'=>0, "FC'"=>0,"C'F"=>0,"C'"=>0, 'FT'=>0,'TF'=>0, 'T'=>0, 'FV'=>0, 'VF'=>0, 'V'=>0, 'FY'=>4,'YF'=>0,'Y'=>0,'Fr'=>0,'rF'=>0,'FD'=>0,'F'=>4,'(2)'=>6}. each {|k,v|
			assert_equal(v, @a.determinantes_simples[k],"Clave:"+k)
		}
	end
def test_controles
		assert_equal(16,@a.R)
		assert_equal(1.to_f/3 , @a.L)
		
		assert_equal('5:2.5',@a.EB)
		assert_equal('4:4',@a.eb)
		assert_equal(7.5,@a.EA)
		assert_equal(8,@a.es)
		assert_equal(5,@a.Adjes)
		assert(!@a.EBPer)
		assert_equal(0,@a.D)
		assert_equal(0,@a.AdjD)
		assert_equal(3,@a.sumdet('FM'))
		assert_equal(1,@a.sumdet('m'))
		assert_equal(0,@a.sumdet("C'"))
		assert_equal(0,@a.sumdet('V'))
		assert_equal(0,@a.sumdet('T'))
		assert_equal(4,@a.sumdet('Y'))
		
	end	
	def test_afectos
		assert_equal('1:2',@a.fc_cf_c)
		assert_equal('0:2.5',@a.sumc_wsumc)
		assert_equal(5.to_f/11,@a.Afr)
		assert_equal(1,@a.localizaciones['S'])
		assert_equal(0.25,@a.complj_r)
		assert_equal(0,@a.CP)
	end
	def test_interpersonal
		assert_equal(3,@a.COP)
		assert_equal(0,@a.AG)
		assert_equal(0,@a.Fd)
		assert_equal(0.25,@a.aislamiento_r)
		assert_equal('3:4',@a.h_h_hd_hd)
		assert_equal('3:1',@a.p_h_hd_p_a_ad)
		assert_equal('8:1',@a.h_a_hd_ad)
		assert_equal(5.to_f/16,@a.a_porciento)
	end
		def test_ideacion
		assert_equal('7:2',@a.a_p)
		assert_equal('4:1',@a.Ma_Mp)
		assert_equal(1,@a.intelectualizacion)
		assert_equal(0,@a.m_menos)
		assert_equal(3,@a.SumBr6)
		assert_equal(2,@a.nvl2)
		assert_equal(15,@a.SumPon6)
		# assert_equal(0,@a.mqsin)
	end
	def test_mediacion
		assert_equal(5,@a.P)
		assert_equal(10.to_f/16,@a.xmas)
		assert_equal(2.to_f/4,@a.fmas)
		assert_equal(2.to_f/16,@a.xmenos)
		assert_equal(0,@a.smenos)
		assert_equal(4.to_f/16,@a.xu)
		assert_equal(14.to_f/16,@a.xa)
		assert_equal(11.to_f/12,@a.wda)
	end
	def test_procesamiento
		assert_equal(9,@a.Zf)
		assert_equal(-1.5,@a.Zd)
		assert_equal('3:9:4',@a.w_d_dd)
		assert_equal('3:5',@a.w_m)
		assert_equal(5,@a.dqmas)
		assert_equal(0,@a.dqv)
	
	end
	def test_autopercepcion
		assert_equal(0.375,@a.autocentracion)
		assert_equal(0,@a.fr_rf)
		assert_equal(0,@a.FD)
		assert_equal(2,@a.an_xy)
		assert_equal(0,@a.mor)
	end
end


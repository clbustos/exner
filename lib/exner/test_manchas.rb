# -encoding: UTF-8
module Exner
	class TestManchas
		FRECUENCIAS=%w{localizacion dq contenidos contenidos_1 contenidos_2 determinantes ccee fqx fqf mq sqx wqx dqx wdx pares}
		attr_reader :respuestas, :laminas, :zf,:zsum, :frecuencias, :complejos, :sencillos, :msumm, :pares, :populares, :extras, :tipos_contenidos
		ZEST_FILE=''
		def initialize
			@zf= @zsum= @pares= @populares=@tipos_contenidos= 0
			@respuestas=Hash.new
			@laminas=Hash.new
			@frecuencias=Hash.new
			@complejos=Array.new
			@extras=Array.new
			FRECUENCIAS.each {|i|
				@frecuencias[i]=Hash.new
			}
			LOC_VALIDAS.each {|i|
				@frecuencias['localizacion'][i]=0;
			}
			DQ_VALIDAS.each {|i|
				@frecuencias['dq'][i]=0;
			}
			DET_VALIDOS.each {|i|
				@frecuencias['determinantes'][i]=0;
			}
			CONT_VALIDOS.each {|i|
				@frecuencias['contenidos'][i]=0;
				@frecuencias['contenidos_1'][i]=0;
				@frecuencias['contenidos_2'][i]=0;
			}
			CCEE_VALIDOS.each {|i|
				@frecuencias['ccee'][i]=0;
			}
			FQ_VALIDAS.each {|i|
				@frecuencias['fqx'][i]=0;
				@frecuencias['fqf'][i]=0;
				@frecuencias['mq'][i]=0;
				@frecuencias['sqx'][i]=0;
				@frecuencias['wqx'][i]=0;
				@frecuencias['dqx'][i]=0;
				@frecuencias['wdx'][i]=0;
			}

		end
		def _d
			@frecuencias['determinantes']
		end
		def _c
			@frecuencias['contenidos']
		end
		def _ccee
			@frecuencias['ccee']
		end
		def _f
			@frecuencias
		end
		def _l
			localizaciones
		end

		def zest
			aEst=Exner::open_zest(self.ZEST_FILE)
			aEst[@zf]
		end
		def open_stream(stream)
      stream.each_line {|linea|
        resp=Exner::Respuesta.new(self,linea)
        lam=resp.lamina
        @laminas[lam]=Array.new if @laminas[lam].nil?
        raise "no pueden existir dos respuestas con el mismo número" if @respuestas.has_key?(resp.respuesta)
        @respuestas[resp.respuesta]=resp
        @laminas[lam].push(resp)
      }
		end
		def open_file(file)
			raise "No se definió archivo" if file.nil?
			File.open(file,'r') {|file|
				open_stream(file)
			}
		end
		def each_determinante
			@respuestas.each {|n,resp| resp.determinantes.each {|det| yield det }}
		end
		def obtenerZ(lamina,tipo)
			return @laminas_z[lamina][tipo]
		end
		def procesar
			@respuestas.each do |n,resp|
				@zf+=1 if resp.z >0
				@zsum+=resp.z
				@pares+=1 if resp.par
				@populares+=1 if resp.popular
				raise "No existe localizacion para la respuesta "+n.to_s if resp.localizacion.nil?
				@frecuencias['localizacion'][resp.localizacion]+=1
				@frecuencias['dq'][resp.dq]+=1
				@frecuencias['fqx'][resp.fq]+=1
				@frecuencias['fqf'][resp.fq]+=1 if resp.determinantes==['F']
				@frecuencias['mq'][resp.fq]+=1 if resp.tiene_movimiento_humano?
				@frecuencias['sqx'][resp.fq]+=1 if resp.localizacion=~/S/
				@frecuencias['wqx'][resp.fq]+=1 if resp.localizacion_pura=='W'
				@frecuencias['dqx'][resp.fq]+=1 if resp.localizacion_pura=='D'
				@frecuencias['wdx'][resp.fq]+=1 if resp.localizacion_pura=='W' or resp.localizacion_pura=='D'
				@complejos.push(resp) if resp.determinantes.size>1
				resp.determinantes.each {|d|
					@frecuencias['determinantes'][d]+=1
				}
				cp=true
				resp.contenidos.each {|d|
					@frecuencias['contenidos'][d]+=1
					@tipos_contenidos+=1 if @frecuencias['contenidos'][d]==1
					if cp
						@frecuencias['contenidos_1'][d]+=1
						cp=false
					else
						@frecuencias['contenidos_2'][d]+=1
					end

				}
				resp.ccee.each {|d|
					@frecuencias['ccee'][d]+=1
				}
			end
			procesar_extras
		end
		def procesar_extras
		  Dir[Exner.dir_root+'/exner/'+self.class.to_s.gsub('Exner::','').downcase+'_plugins/*.rb'].each {|file|
		    require file
		  }

		end
		def localizaciones
			res=Hash.new
			locs=%w{W Wv D Dd S}
			locs.each {|i| res[i]=0}
			@respuestas.each {|n,resp|
				res['W']+=1 if resp.localizacion_pura=='W'
				res['Wv']+=1 if resp.localizacion_pura=='W' and resp.dq=='v'
				res['D']+=1 if resp.localizacion_pura=='D'
				res['Dd']+=1 if resp.localizacion_pura=='Dd'
				res['S']+=1 if resp.localizacion=~/S/
			}
			res
		end
		def determinantes_simples
			res=@frecuencias['determinantes'].dup
			['M','FM','m'].each {|mov|
				res[mov]=res[mov+'a']+res[mov+'p']
				res.delete(mov+'a')
				res.delete(mov+'p')
			}
			res['(2)']=@pares
			res
		end

		def msum
			sumdet('M')
		end
		# sumatoria de color ponderado
		def det
			@frecuencias['determinantes']
		end
		def sumcolpond
			_d['C']*1.5+_d['CF']+_d['FC']*0.5
			end

		# sumatoria de items de un determinado tipo
		def sumdet(tipo)
			suma=0
			each_determinante {|det|
					if tipo=='M'
						suma+=1 if det=='Ma' or det=='Mp'
					elsif tipo=='FD'
						suma+=1 if det=='FD'
					elsif tipo=='C'
						suma+=1 if det=='C' or det=='FC' or det=='CF'
					elsif tipo=='Cn'
						suma+=1 if det=='Cn'
					elsif tipo=='F'
						suma+1 if det=='F'
					else
						det=det.gsub(/[ap]/,'')
						suma+=1 if det=~/#{tipo}/
					end
			}
			suma
		end
		def resumen_del_enfoque
			res=Hash.new
			@laminas.each {|ln,resps|
				resps.sort.each {|resp|
					res[ln]=Array.new if res[ln].nil?
					res[ln].push(resp.localizacion_pura)
				}
			}
			res.sort
		end
		# Controles
		def R
			@respuestas.size
		end
		def L
			fp=0.0
			@respuestas.each {|n,resp|
				fp+=1 if resp.determinantes==['F']
			}
			return fp.to_f / (self.R-fp)
		end
		def EB
			sumdet('M').to_s+":"+sumcolpond.to_s
		end
		def EA
			(msum+sumcolpond).to_f
		end
		def eb_izq
			(sumdet('FM')+sumdet('m'))
		end
		def eb_der
			(sumdet('T')+sumdet('V')+sumdet("C'")+ sumdet('Y'))
		end
		def eb
			eb_izq.to_s+":"+eb_der.to_s
		end
		def es
			eb_izq+eb_der
		end
		def Adjes
			madj=(sumdet('m')>0) ? 1:0;
			yadj=(sumdet('Y')>0) ? 1:0;
			sumdet('FM')+madj+(sumdet('T')+sumdet('V')+sumdet("C'")+ yadj)
		end
		def EBPer
			if (((msum-sumcolpond).abs<=2 and self.EA<=10) or
			self.EA>10)
			if msum>sumcolpond
				msum/sumcolpond
				else
				sumcolpond/msum
				end
			else
			false
			end
		end
		def Dscore(d)
			return 0 if d>=-2.5 and d<=2.5
			(((d.abs-3)/2.5)+1).to_i*(d<0 ? -1:+1)
		end
		def D
			Dscore(self.EA-es)
		end
		def AdjD
			Dscore(self.EA-self.Adjes)
		end
		#Afectos

		#FC:CF+C
		def fc_cf_c
			(det['FC']).to_s+':'+(det['CF']+det['C']).to_s
		end
		def sumc_wsumc
			(sumdet("C'")).to_s+":"+(det['FC']*0.5+det['CF']+det['C']*1.5).to_s
		end
		def Afr
			n=Hash.new
		@laminas.each {|x,l|
			n[x]=l.size
		}
		(n[8]+n[9]+n[10]).to_f/(n[1]+n[2]+n[3]+n[4]+n[5]+n[6]+n[7]).to_f
		end
		def complj_r
			porcentaje(@complejos.size)
		end
		def CP
			@frecuencias['ccee']['CP']
		end
		#interpersonal
		def COP
			@frecuencias['ccee']['COP']
		end
		def Fd
			@frecuencias['contenidos']['Fd']
		end
		def AG
			@frecuencias['ccee']['AG']
		end
		def aislamiento_r
			c=@frecuencias['contenidos']
			(2*c['Na']+2*c['Cl']+c['Bt']+c['Ls']+c['Ge']).to_f/self.R
		end
		def h_h_hd_hd
			_c['H'].to_s+':'+(_c['(H)']+_c['Hd']+_c['(Hd)']).to_s
		end
		def p_h_hd_p_a_ad
			c=@frecuencias['contenidos']
			(c['(H)']+c['(Hd)']).to_s+':'+(c['(A)']+c['(Ad)']).to_s

		end
		def h_a_hd_ad
			c=@frecuencias['contenidos']
			(c['H']+c['A']).to_s+':'+(c['Hd']+c['Ad']).to_s
		end
		def a_porciento
			c=@frecuencias['contenidos']
			porcentaje(c['A']+c['Ad'])
		end
		def porcentaje(valor)
			return valor.to_f/self.R
		end
		#Ideación
		def suma_preg(p)
			suma=0
			each_determinante {|det| suma+=1 if det=~/#{p}/ }
			suma
		end
		def activos
			suma_preg('a')
		end
		def pasivos
			suma_preg('p')
		end
		def a_p
			activos.to_s+":"+pasivos.to_s
		end
		def Ma_Mp
			a=p=0
			each_determinante {|det|
				if(det=='Ma' or det=='Mp')
					a+=1 if det=~/a/
					p+=1 if det=~/p/
				end
			}
			a.to_s+":"+p.to_s
		end
		def intelectualizacion
		c=@frecuencias['contenidos']
		2*@frecuencias['ccee']['AB']+(c['Art']+c['Ay'])
		end
		def m_menos
			@frecuencias['mq']['-']
		end
		def SumBr6
			suma=0
			@respuestas.each {|n,resp|
				resp.ccee.each {|ccee|
					suma+=1 if CCEE_IDEACION.has_key?(ccee)
				}
			}
			suma
		end
		def SumPon6
			suma=0
			@respuestas.each {|n,resp|
				resp.ccee.each {|ccee|
					suma+=CCEE_IDEACION[ccee] if CCEE_IDEACION.has_key?(ccee)
				}
			}
			suma
		end
		def nvl2
			suma=0
			@respuestas.each {|n,resp|
				resp.ccee.each {|ccee|
					suma+=1 if CCEE_IDEACION.has_key?(ccee) and ccee=~/2/
				}
			}
			suma
		end
		def msin
			suma=0
			@respuestas.each {|n,resp|
				suma+=1 if resp.fq=='sin' and resp.determinantes.detect {|a| a=='Ma' or a=='Mp'}
				}
			suma
		end
		# mediacion
		def P
			@populares
		end
		def xmas
			(@frecuencias['fqx']['o']+@frecuencias['fqx']['+']).to_f/self.R
		end
		def fmas
			(@frecuencias['fqf']['o']+@frecuencias['fqf']['+']).to_f/ determinantes_simples['F']
		end
		def xmenos
			@frecuencias['fqx']['-'].to_f/self.R
		end
		def smenos
			@frecuencias['sqx']['-'].to_f/@frecuencias['fqx']['-']

		end
		def xu
			@frecuencias['fqx']['u'].to_f/self.R
		end
		def xa
			(@frecuencias['fqx']['o']+@frecuencias['fqx']['+']+ @frecuencias['fqx']['u']).to_f/self.R
		end
		def wda
			wdx=@frecuencias['wdx']
			loc=localizaciones
			(wdx['+']+wdx['o']+wdx['u']).to_f/(loc['W']+loc['D'])
		end
		#Procesamiento
		def Zf
			@zf
		end
		def Zd
			@zsum-zest
		end
		def w_d_dd
			l=localizaciones
			sprintf("%d:%d:%d",l['W'],l['D'],l['Dd'])
		end
		def w_m
			l=localizaciones
			sprintf("%d:%d",l['W'],determinantes_simples['M'])
		end
		def dqmas
			@frecuencias['dq']['+']
		end
		def dqv
			@frecuencias['dq']['v']
		end
		# autopercepcion
		def autocentracion
			(3*sumdet('r')+@pares).to_f/self.R
		end
		def fr_rf
			sumdet('r')
		end
		def FD
			@frecuencias['determinantes']['FD']
		end
		def an_xy
			@frecuencias['contenidos']['An']+@frecuencias['contenidos']['Xy']
		end
		def mor
			@frecuencias['ccee']['MOR']
		end
	end
	
	
end

require 'exner/rorschach'
require 'exner/zulliger'

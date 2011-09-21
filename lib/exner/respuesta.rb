# -encoding: UTF-8
module Exner
  class Respuesta
		include Comparable
		attr_accessor :lamina, :respuesta, :par, :popular
		attr_reader :localizacion, :dq, :determinantes, :fq, :contenidos,:ccee,:z
		def initialize(test,definicion=false)
			@test=test
			@loc= @dq = nil
			@determinantes = Array.new
			@contenidos= Array.new
			@ccee=Array.new
			@z= 0
			if (definicion)
				from_s(definicion)
			end
		end

		# Procesa una cadena de texto con una tabulación
		def from_s(t)
		  raise "Error en linea "+t  unless t=~/^s*
			([I|V|X]{1,4})\s+ #1 Lamina
			(\d{1,3})\s+ #2 Respuesta
			([WSDd]+) #3 Localizacion
			(\+|o|v|v\/\+)\s+ #4 Dq
			([^\s|\+|o|u|-]+) #5 Determinante
			(\+|o|u|-|sin)\s+ #6 Fq
			(\(2\))?\s* #7 par
			(\S+)\s* #8 contenidos
			(P)*\s* #9 popular
			(\d\.\d|[abcd])?\s* #10 Z
			(\S+)?\s* #11 fenómenos especiales
			$/x
			raise "no dq" if $4.nil?
			raise "no contenido" if $8.nil?
			@lamina= Exner.de_romano($1)
			@respuesta= $2.to_i
			self.localizacion= $3
			self.dq= $4
			self.determinantes= $5
			self.fq= $6
			self.par= ($7=='(2)')
			self.contenidos= $8
			self.popular = ($9 =='P')
			self.z=$10
			self.ccee=$11
		end
		def es_compleja?
			return @determinantes.size>1
		end
		def localizacion=(loc)
			return false unless LOC_VALIDAS.include?(loc)
			@localizacion = loc
		end
		def localizacion_pura
			@localizacion.gsub("S","")
		end
		def tiene_movimiento_humano?
			a=@determinantes.detect {|c| c=='Mp' or c=='Ma'}
			!a.nil?
		end
		def dq=(dq)
			return false unless DQ_VALIDAS.include?(dq)
			@dq = dq
		end
		def z=(z)
			if(z=~/a|b|c|d/)
				@z=@test.obtenerZ(@lamina,z)
			else
			@z=z.to_f
			end
		end
		def determinantes=(deter)
			if deter.kind_of?(String)
				deter=deter.chomp.split('.')
			end
			return false if (!deter.kind_of?(Array) or
			!(deter - DET_VALIDOS).empty?)
			@determinantes = deter
		end
		def fq=(fq)
			return false unless FQ_VALIDAS.include?(fq)
			@fq = fq
		end
		def contenidos=(cont)
			#puts "Contenido:"+ cont
			if cont.kind_of?(String)
				#p cont.strip
				cont=cont.strip.split(',').collect {|x| x.strip}
			end
			#p cont
			return false if (!cont.kind_of?(Array) or
			!(cont - CONT_VALIDOS).empty?)
			@contenidos = cont
		end
		def ccee=(cont)
		  cont=cont.strip.split(',').collect {|x| x.strip} if cont.kind_of?(String)
			return false if (!cont.kind_of?(Array) or
			!(cont - CCEE_VALIDOS).empty?)
			@ccee = cont
		end

		def to_s
			Exner.a_romano(@lamina)+" "+@respuesta.to_s+" "+@localizacion+@dq+" "+@determinantes.join('.')+@fq+" "+(@par ? "(2) ":" ")+@contenidos.join(',')+" "+(@popular ? "P " :" ")+@z.to_s+" "+@ccee.join(',')
		end
		def <=>(resp)
			@respuesta<=>resp.respuesta
		end
	end
end

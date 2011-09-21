# encoding: UTF-8
module Exner
	class Rorschach
	public
		def depi(lista=false)
			total=0
			cons={
			1=>(sumdet('V')>0 or _d['FD']>2),
			2=>(scon_col_sombra>0 or localizaciones['S']>2),
			3=>((aislamiento_r>0.44 and sumdet('r')==0) or (aislamiento_r<0.33)),
			4=>(self.Afr<0.46 or @complejos.size<4),
			5=> ((sumdet("C'")>sumdet('FM')+sumdet('m')) or sumdet("C'")>2) ,
			6=>((_ccee['MOR']>2) or (intelectualizacion>3)),
			7=>((_ccee['COP']<2) or (aislamiento_r>0.24))
			}.each {|n,r|
				total+=1 if r
			}
			lista ? cons : total
			
		end
    def depi_si
		return (depi > 4) ? 'Sí':'No'
	end
	private 
	def scon_col_sombra
		suma=0	
		@respuestas.each {|n,resp|
			cond1=cond2=false
			resp.determinantes.each {|d|
				cond1=true if d=~/Y/
				cond2=true if d=='FC' or d=='CF' or d=='C'
			}
			suma=+1 if cond1 and cond2
		}
		suma
	end
	end
end
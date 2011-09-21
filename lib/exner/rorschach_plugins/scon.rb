# encoding: UTF-8
module Exner
	class Rorschach
	public
		def scon(lista=false)
			det=@frecuencias['determinantes']
			total=0
			cons={
			1=>sumdet('V')+det['FD']>2,
			2=>scon_col_sombra>0,
			3=>(aislamiento_r<0.31 or aislamiento_r>0.44),
			4=>@frecuencias['ccee']['MOR']>3,
			5=> (self.Zd > 3.5 or self.Zd < -3.5) ,
			6=>es>self.EA,
			7=>det['CF']+det['C']>det['FC'],
			8=>xmas<0.7,
			9=>localizaciones['S']>3,
			10=>(@populares<3 or @populares>8),
			11=>@frecuencias['contenidos']['H']<2,
			12 => self.R<17
			}.each {|n,r|
				total+=1 if r
			}
			lista ? cons : total
			
		end
		def scon_si
			return (scon>7) ? 'Sí':'No' 
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
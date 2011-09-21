# encoding: UTF-8
module Exner
	class Rorschach
	public
		def hvi(lista=false)
			total=0
			cons={
			1=>sumdet('T')==0,
			2=>(self.Zf>12),
			3=>(self.Zd>3.5),
			4=>(localizaciones['S']>3),
			5=>(_c['H']+_c['(H)']+_c['Hd']+_c['(Hd)']>6),
			6=>(_c['(H)']+_c['(A)']+_c['(Hd)']+_c['(Ad)']>3),
			7=>(((_c['H']+_c['A']).to_f / (_c['Hd']+_c['Ad']).to_f )<4),
			8=>_c['Cg']>3
			}.each {|n,r|
				total+=1 if r
			}
			lista ? cons : total
		end
		def hvi_si
			return (hvi(true)[1] and hvi-1>=4) ? 'Sí':'No'
		end
	end
end
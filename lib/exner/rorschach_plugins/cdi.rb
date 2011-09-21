# encoding: UTF-8
module Exner
	class Rorschach
	public
		def cdi(lista=false)
			total=0
			cons={
			1=>(self.EA<6 or self.AdjD<0),
			2=>(_ccee['COP']<2 and _ccee['AG']<2),
			3=>((sumcolpond<2.5) or (self.Afr<0.46)),
			4=>((pasivos>activos+1) or (_c['H']<2)),
			5=>((sumdet('T')>1)or(aislamiento_r>0.24)or(_c['Fd']>0))
			}.each {|n,r|
				total+=1 if r
			}
			lista ? cons : total
		end
		def cdi_si
			return ( cdi > 3) ? 'Sí': 'No'
		end
	end
end
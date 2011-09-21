# encoding: UTF-8
module Exner
	class Rorschach
	public
		def sczi(lista=false)
			det=@frecuencias['determinantes']
			fq=@frecuencias['fqx']
			total=0
			cons={
			1=>((xmas<0.61 and smenos<0.41) or xmas<0.50),
			2=>xmenos>0.29,
			3=>((fq['-']>fq['u'])or(fq['-']>fq['o']+fq['+'])),
			4=>(nvl2>1 and @frecuencias['ccee']['FABCOM2']>0),
			5=>(self.SumBr6>6 or self.SumPon6>17),
			6=>(@frecuencias['mq']['-']>1 or xmenos>0.4),
			}.each {|n,r|
				total+=1 if r
			}
			lista ? cons : total
		end
		def sczi_si
			return (sczi > 3) ? 'Sí':'No'
		end
	end
end
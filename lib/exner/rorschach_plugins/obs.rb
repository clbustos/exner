# encoding: UTF-8
module Exner
	class Rorschach
	public
		def obs(lista=false)
			total=0
			cons={
			1=>localizaciones['Dd']>3,
			2=>(self.Zf>12),
			3=>(self.Zd>3),
			4=>(@populares>7),
			5=>(_f['fqx']['+']>1),
			
			}.each {|n,r|
				total+=1 if r
			}
			lista ? cons : total
		end
		def obs_si
			return (obs_si_bool) ? 'Sí':'No'
		end
		def obs_si_bool
			return true if obs==5
			return true if (obs>=3 and xmas>0.89)
			return true if (_f['fqx']['+']>3 and xmas>0.89)
			l=obs(true)
			
			return true if ((bi(l[1])+bi(l[2])+bi(l[3])+bi(l[4]))>=2 and _f['fqx']['+']>3)
			false
		end
		private
		def bi(v)
			v ? 1: 0 
		end
	end
end
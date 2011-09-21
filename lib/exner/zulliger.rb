# -encoding: UTF-8
module Exner
  class Zulliger < TestManchas
		def initialize
			@laminas_z={
			1=>{'a'=>1.0,'b'=>4.0,'c'=>6.0,'d'=>3.5},
			2=>{'a'=>5.5,'b'=>3.0,'c'=>3.0,'d'=>4.0},
			3=>{'a'=>5.5,'b'=>3.0,'c'=>4.0,'d'=>4.5}
			}
			super
		end
		def ZEST_FILE
			Exner.dir_data+'/Zulliger_Zest.txt'
		end
		def N
		3
		end
		def Afr
			n=Hash.new
		@laminas.each {|x,l|
			n[x]=l.size
		}
		n[2].to_f/(n[1]+n[3]).to_f
		end
	end
end

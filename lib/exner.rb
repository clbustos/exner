# -encoding: UTF-8


require 'exner/test_manchas.rb'
require 'exner/respuesta.rb'
require 'exner/rtf'
# Clase que almacena información sobre una respuesta a una lámina
module Exner
  VERSION="1.0.0"
  # De números arábigos a romanos
	ROMANOS={1=>'I',2=>'II', 3=>'III',4=>'IV',5=>'V', 6=>'VI',7=>'VII',8=>'VIII',9=>'IX',10=>'X'}
	# Localizaciones válidas
	LOC_VALIDAS=['W','D','Dd','WS','DS','DdS']
	DQ_VALIDAS=['+','o','v','v/+']
	DET_VALIDOS=['F','Ma','FMa', 'ma','Mp','FMp', 'mp', 'C', 'CF', 'FC', 'C', 'Cn', "C'", "C'F", "FC'", "T","TF", "FT","V", "VF","FV", "Y", "YF","FY","FD","rF","Fr"]
	CONT_VALIDOS=['H','(H)','Hd','(Hd)','Hx','A','(A)','Ad', '(Ad)', 'An', 'Art','Ay','Bl','Bt','Cg','Cl','Ex','Fd','Fi', 'Ge','Hh', 'Ls', 'Na','Sc','Sx','Xy','Id']
	CCEE_VALIDOS=['DV1','DV2','DR1','DR2','INCOM1','INCOM2','FABCOM1', 'FABCOM2','CONTAM', 'ALOG','PSVi','PSVc','PSVm','CONFAB','AG','COP', 'MOR','AB','PER','CP']
	CCEE_IDEACION={'DV1'=>1,'DV2'=>2,'INCOM1'=>2,'INCOM2'=>4,'DR1'=>3,'DR2'=>6, 'FABCOM1'=>4, 'FABCOM2'=>7, 'ALOG'=>5, 'CONTAM'=>7}
	FQ_VALIDAS= ['+','o','u','-','sin']
	# Abre un archivo zest y devuelve un hash con los valores correspondientes. 
	def self.open_zest(file)
		aEst=Hash.new
		File.open(file,'r') { |aFile|
			aFile.each_line {|line|
				if line =~ /(\d+)\s+(\d+\.\d+)/
					aEst[$1.to_i]=$2.to_f
				end
			}
		}
		aEst
	end
	def self.a_romano(i)
	  i.kind_of?(Integer) ? ROMANOS[i] : false
	end
	def self.de_romano(s)
		ROMANOS.has_value?(s) ? ROMANOS.key(s):false
	end
	def self.dir_root()
		File.dirname(__FILE__)
	end
	def self.dir_data
	  File.dirname(__FILE__)+"/../data/"
	end
end

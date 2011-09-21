require 'erb'
module Exner
  module Rtf
    module Zulliger
      def _dcp(c)
        _ds[c.gsub('C',"C'")]
      end
      def _cd(c)
        c+" = "+_f['contenidos_1'][c].to_s+","+_f['contenidos_2'][c].to_s
      end
      def detRtf
      s=""
        @respuestas.each {|n,r|
          s+="\n\\par "+r.determinantes.join('.')+r.fq if r.determinantes.size>1
        }
        s
      end
      def _ds
        determinantes_simples
      end
      def superscript(a)
      '{{\*\updnprop5801}\up8 '+a+'}'
      end
      def _res_enf
        a=resumen_del_enfoque.collect {|lam|
          Exner.a_romano(lam[0])+":"+lam[1].join(',')
        }.join("\n\\par ")+"\n"
      end
      def _lq(tipo)
      s=''
        Exner::FQ_VALIDAS.each {|fq|
          s+=fq+":"+_f[tipo][fq].to_s+"\n\\par "
        }
      s
      end
      def ldq
        s=''
        Exner::DQ_VALIDAS.each {|dq|
          s+=dq+":"+_f['dq'][dq].to_s+"\n\\par "
        }
        s
      end
      def aParrafos(array)
      array.collect {|x|
        "\n\\par "+x.to_s
      }.join("")
      end
      def self.process(text)
        t=Exner::Zulliger.new
        t.open_stream(text)
        t.procesar
        t.extend(Exner::Rtf::Zulliger)
        template=File.read(Exner.dir_data+'/sumario_Zulliger.rtf')
        zz=t
        ERB.new(template).result(binding)
      end
    end
  end
end

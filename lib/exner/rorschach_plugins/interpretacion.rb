# encoding: UTF-8
require 'iconv'
module Exner
	class Rorschach
	# calcula, para un determinado valor en los baremos
	# el porcentaje que le corresponde al valor específico
	# hace el ajuste en función al número de respuestas
	def norma(valor)
		r_est=22.67
		return (valor*self.R) / r_est
	end
	def respuestatriple(valor,bajo,alto,resp_bajo,resp_alto,resp_normal)
		if valor<bajo
			return resp_bajo
		elsif valor>alto
			return resp_alto
		else
			return resp_normal
		end
	end
	def interpretacion
	salida=Array.new
	# Lambda
	salida.push('{\b Controles}')
	if self.R < 14
		salida.push('{\b ATENCION: POCAS RESPUESTAS. TEST INVALIDO}')
	end
	
	if self.L> 0.84
		salida.push("L aumentado. Sobresimplificación perceptiva. Registro sólo de lo cognitivo. Se evita lo emocional. INHIBICION DE POTENCIAL: Restricción emocional, sobrecontrol")
		if self.L>1 
			if self.R >=17 or self.EA>=4 
				salida.push("Estilo evitativo. Trata estímulos de forma simple, evitando aspectos intrincado y ambigüedades")
			else 
				salida.push("DEFENSIVIDAD SITUACIONAL. Puede ser que EA no sea válido")
			end
		end
	elsif self.L<0.32
		salida.push("L < disminuido. No es capaz de simplificar las percepciones. Sobrestimulación emocional, pudiéndose agotar. Revisar Hiperincorporación. INHIBICION DE POTENCIAL: sobrestimulación, especialmente emocional")
	else
		salida.push("L normal. Manejo normal de la cantidad de información")
	end
	# Tipo vivencial
	if self.EA>=4
		salida.push("Estilo vivencial bien definido")
	else
		salida.push("No se puede definir bien el estilo vivencial")
	end

	dif=(sumdet("M")-sumcolpond).abs
		if sumdet("M")>sumcolpond and dif>=2
			salida.push("Intratensivo. Para solucionar sus problemas recurren a su mundo interno.")
		elsif sumdet("M")<sumcolpond and dif>=2
			salida.push("Extratensivo. Para solucionar sus problemas recurren al mundo externo")
		else
			salida.push("Ambigual. NO tiene un estilo defeinido. Dudan mucho entre el pensar y el actuar y se desgantan")
		end
	# Estilo organizativo
	if (self.Zd>3) 
		salida.push("Estilo hiperincorporador. Minucioso al recoger información del medio, teniendo dificultades para distinguir lo importante de lo accesorio")
	elsif (self.Zd<-3) 
		salida.push("Estilo hipoincorporador. Decide rápidamente en función de lo más llamativo. Tiende a ser rápido, pero en su precipitación puede equivocarse")
	else
		salida.push("Estilo organizativo normal. Registra la información de forma eficaz y organiza activamente la información de su entorno")
	end
	# D
	if (self.D>0) 
		salida.push("D positivo. Buena tolerancia al estrés, utilizando bien sus recursos y respondiendo a demandas del ambiente")
	elsif (self.D==0)
		salida.push("D=0. Buena tolerancia al estrés, pero se puede descompensar")
	else 
		if(self.AdjD>self.D)
			salida.push("D<0 y AdjD menor. Sobrecarga situacional. Algo lo tiene sobrepasado")
		else
			salida.push("D<0 y AdjD igual. Tensión y sufrimiento crónico. Disposición crónica a la desorganización")
		end
	end
	# estimulacion sufrida (es)

	if eb_izq>eb_der
		salida.push("FM+m aumentado. Ideas sin que el sujeto se lo proponga. Sobrecarga interna.")
		if sumdet("FM")>sumdet("m")
			salida.push("FM>m. Malestar crónico por necesidades insatisfechas")
		elsif sumdet("m")>sumdet("FM")
			salida.push("m>FM. Malestar agudo, por estresante actual")
		end
	elsif eb_der>eb_izq
		salida.push("C'+T+V+Y aumentados. Aumento del sufrimiento y del dolor psíquico causado por situaciones internas")
	else
		salida.push("Necesidades y sufrimientos en igual grado")
	end
	
	if sumdet("FM")>norma(4.89)
		salida.push("FM aumentada. Necesidades insatisfechas de forma crónica. Es un sujeto que quiere gratificarse ahora, puede estar a merced de sus impulsos, lo cual lo puede llevar a conductas desadaptativas")
	elsif sumdet("FM")< norma(2.51)
		salida.push("FM disminuido. Represión de necesidades básicas")
	end
	
	if sumdet("m")>norma(1.97)
		salida.push("m aumentado. Malestar por necesidades externas agudo aumentado")
	end

	if sumdet("Y")>norma(1.57)
		salida.push("Claroscuro difuso aumentado. Angustia, sensación de indefensión, parálisis, desamparto")
	end
	if self.EA>self.es+2
		salida.push("EA>es+2. Sujeto tiene recursos para satisfacer sus necesiades")
	elsif self.EA<self.es
		salida.push("EA<es. Sujeto no tiene suficientes recursos para satisfacer sus necesidades. INHIBICION DE POTENCIAL")
	else
		salida.push("Recursos suficientes, pero a veces se puede desbordar. POSIBLE INHIBICION DE POTENCIAL")
	end
	
	salida.push('{\b Mediación}')
	
	if fmas >= 0.88
		salida.push("FQX% elevado. Exagerada precoupación por la realidad, en desmedro de la propia singularidad(rigidez)")
	elsif fmas <= 0.54
		salida.push("FQX% disminuido. Distorsión de la realidad. Puede ser creatividad, subjetividad o distorsión propiamente tal")
	else
		salida.push("FQX% normal. Buen control de la realidad, objetivo y con buena capacidad intelectual")
	end
	
	if xmas>=0.87
		salida.push("X+% elevado. Cuando los afectos están involucrado, la persona se va a apegar mucho a la realidad y puede paralizarse")
	elsif xmas<=0.71
		salida.push("X+% disminuido. Cuando los afectos están involucrados, no pueden ser muy objetivos. Revisar FQXu y - para ver si es patológico o no")
	else
		salida.push("X+% normal. El sujeto es capaz de manejar sus afectos de modo bastante objetivo")
	end
	
	if wda<=0.75
		salida.push("WDA+%<0.75. La percepción es inadecuada en situaciones obvias")
	else
		salida.push("WDA+%>0.75. La percepción es adecuada en situaciones obvias")
	end	
	
	if xa<=0.7
		salida.push("Xa%<0.7. Trastorno de percepción en situaciones inusuales")
	else
		salida.push("Xa%>0.7. La percepción es adecuada en situaciones inusuales")
	end

	if xmenos>0.25
		salida.push("X-%>0.25. Preocupante alejamiento de lo convencional")
	end
	if smenos>0.30
		salida.push("S-%>0.30. Fuerte interferencia emocional en situaciones de rabia")
	end

	if @populares<5
		salida.push("P<5. Tiene dificultades para percibir las normas sociales(psicótico-sociópata). O puede ser muy brillante y arrogante y no quiere contestar las obvias.")
		if @populares<2
			salida.push("Hiciste límite, supongo...")
		end
	elsif @populares>=5 and @populares<=8
		salida.push("5<P<8. Puede percibir y acatar las normas sociales")
	else
		salida.push("P>8. Sobresocializado. Demasiado atento a las normas sociales. sobresocializado")
	end

	salida.push('{\b Ideación}')
	
	if(sumdet("F")>norma(10.66))
		salida.push("F aumentadas. Muy defensivo, teme sus emociones y las evite")
	elsif(sumdet("F")<norma(5.32))
		salida.push("F disminuidas. Expresión descontrolada de los impulsos. Falta de demora cognitiva")
	end
	if pasivos>activos+1
		salida.push("p>a+1. Persona que tiende a asumir un rol pasivo frente a los demás. Vigilar T, P, Ego disminuido y Fd")

		salida.push("T>0.Pasivo por necesidad de afecto") if (sumdet('T')>0)
		salida.push("P>4.Pasivo por Sobresocialización") if (@populares>4)
		salida.push("Fd>0. Pasivo por dependencia") if (_c['Fd']>0)
		if (sumdet("M")+sumdet("FM")+sumdet("m"))<4
			salida.push("Hay pocos movimientos para estar seguro sobre la pasividad")
		end
		
	else
		salida.push("a+1>p. Persona adopta rol activo")
	end
	if (pasivos-activos).abs>4
		salida.push("Dif pasivos activos > 4. Rigidez cognitiva")
	end
	
	if _d['Mp']>_d['Ma']+1
		salida.push("Mp>Ma+1. Crea fantasías, pero tiene dificultades para hacer deliberaciones eficaces. Ocupa su inteligencia para escapar de los problemas, no para afrontarlos")
		salida.push("Pocos Movimientos humanos para estar seguro de esto") if sumdet("M")<2
	end
	if intelectualizacion>=5
		salida.push("Intelectualización alta. Uso abusivo de la intelectualizacion")
	end
	
	if _ccee['MOR']>2
		salida.push("MOR>2. Pesimismo")
	end
	if m_menos>1
		salida.push("M->0. ALERTA. Mal signo. Sus recursos ideativos presentan alteraciones, con ideación paranoide.")
	end
	if self.SumBr6>=norma(6.17)
		salida.push("SumBr6 aumentada .Posible trastorno del pensamiento. INHIBICION DEL POTENCIAL")
	end
	if self.SumPon6>2
		salida.push("SumPon6>2.Posible trastorno del pensamiento. INHIBICION DEL POTENCIAL")
	end
	if msin>0
		salida.push("M sin >0. Es una persona que puede desorientarse y perder contacto con la realidad")
	end
	#
	# AFECTOS
	#
	salida.push('{\b Afectos}')
	
	if det['FC']<(det['CF']+det['C'])*2
		salida.push("FC<CF+C*2. Vigilar poco control sobre descarga emocional")
		salida.push("C>CF. Posible impulsividad!") if det['C']>det['CF']
	end
	
	if det['C']>0
		salida.push("C>0. Persona que disfruta mucho de situaciones vertiginosas. ")
	end
	
	if sumdet("C'")>det['FC']*0.5+det['CF']+det['C']*1.5
		salida.push("SumC':SumPondC hacia derecha. Se internaliza en demasía la descarga afectiva. Posible somatización")
	end
	
	if self.Afr<0.53
		salida.push("Afr disminuido. Evitación de situaciones emocionales. Trabaja mejor en ambientes sin carga emocional")
	elsif self.Afr>0.85
		salida.push("Afr umentado. Atracción por estimulación emocional. Trabaja mejor en ambientes cargados afectivamente.")
	else
		salida.push("Afr normal. Interés normal por estimulación emocional.")
	end
	
	if complj_r<0.2 and self.L<=1.51
		salida.push("Compl/r dism y L normal. Tiende a simplificar las situaciones, aunque no de manera excesiva")
	elsif complj_r<0.2 and self.L> 1.51
		salida.push("Compl/r dism y L alto. Limitación de tipo intelectual o tendencia a simplificar demasiado la situación")
	elsif complj_r>0.25 and self.EA>7
		salida.push("Compl/r alta y muchos recursos. Buen signo. Tiene capacidad para considerar de manera integral los estímulos y buena capacidad para elaborarlos ")
	elsif complj_r>0.25 and self.EA<2
		salida.push("Compl/r alta y pocos recursos. Mal signo. Puede tener dificultad para controlar y puede desorganizarse")
	else
		salida.push("complejas normal. Capacidad normal para manejar de forma integral los estímulos")
	end
	
	if _l['S'].to_f/self.R>0.2
		salida.push("S aumentado. Vigilar si es autonomía u oposicionismo")
	end
	#
	# PROCESAMIENTO
	#
	
	salida.push('{\b Procesamiento}')
	salida.push(respuestatriple(self.Zf,norma(9.22),norma(14.4),
	"Zf dism. Sujeto con poco interés por organizar. Puede ser por limitación intelectual o depresión",
	"Zf alto. Alto nivel de motivación , que dedican al proceso de información más energía que el promedio",
	"Zf normal. Motivación e interés normal para organizar elementos del entorno")
	)
	
	if _l['W'].to_f/self.R>0.50
		salida.push("W aumentadas. Gran interés por tareas de análisis y por organizar los componentes del mundo interno en un todo significativo")
	elsif _l['W'].to_f/self.R<0.15
		salida.push("W disminuidas. Poco interés en tareas de análisis y dificultad para integrar los elementos de su mundo interno en un todo significativo. Revisar síntomas depresivos")
	end
	
	if _l['D'].to_f/self.R>0.70
		salida.push("D aumentadas. Mucho apego a lo práctico")
	elsif _l['D'].to_f/self.R<0.30
		salida.push("D disminuidas. Pierde sentido de lo práctico. Vigilar W y Dd")
		if _l['W'].to_f/self.R>0.50
			salida.push("W aum. Pierde sentido de lo práctico por irse en la volada")
		elsif _l['W'].to_f/self.R>0.50
			salida.push("Dd aum . Pierde sentido de lo práctico por el detalle")

		else
			salida.push("Revisa bien los datos, que no pude cachar el mote")
		end
	end
	
	if _l['Dd'].to_f/self.R>40
		salida.push("Dd aumentadas. Muy apegado a la exactitud. temor a cometer equivocaciones. Personas inseguras que se van por las ramas")
	elsif _l['Dd'].to_f/self.R<0.05
		salida.push("Dd disminuidas. No muy preocupada por la exactitud")
	end
	
	rel_aspir=_l['W'].to_f/sumdet('M')
	
	if (rel_aspir> 2.5)
		salida.push("W*2>M ("+rel_aspir.to_s+"); Aspiraciones sobre los recursos. El sujeto se puede frustrar")
	elsif (rel_aspir<1.5)
		salida.push("W*2<M ("+rel_aspir.to_s+"); Aspiraciones bajo los recursos. Los gasta en fantasías, vigilar pasividad")
	else
		salida.push("W*2=M ("+rel_aspir.to_s+"); Aspiraciones adecuadas a los recursos")
	end
	rel_teor=_l['W'].to_f / _l['D'].to_f
	if (rel_teor> 2.5)
		salida.push("Teórico ("+rel_teor.to_s+")")
	elsif (rel_teor<1.5)
		salida.push("Práctico ("+rel_teor.to_s+")")
	else
		salida.push("Equilibrio Teórico práctico ("+rel_teor.to_s+")")
	end
	
	if zsum<15
		salida.push("ZSum<15. Poca interés en integrar")
	elsif zsum>32
		salida.push("ZSum>32. Alto interés en integrar")
	else
		salida.push("ZSum normal. Interés normal en integrar estímulos")
	end
	#
	# INTERPERSONAL
	#
	
	salida.push('{\b Interpersonal}')
	if _ccee['COP']==0 and _ccee['AG']==0
		salida.push("COP y AG=0. Poco interés en relaciones interpersonales")
	end
	salida.push("Fd>0. Rasgos incrementados de dependencia") if _c['Fd']>0
	if aislamiento_r>0.29
		salida.push("Aisl>0.29. Sujeto menos implicados que el resto en lo social")
	else 
		salida.push("Aisl normal. Sujeto implicado en lo social")
	end
	
	# a (H+Dh:A+Ad)
	rel=(_c['H']+_c['Hd']).to_f/(_c['A']+_c['Ad'])
	if rel<0.3
		salida.push("H+Dh:A+Ad hacia animal. Persona se está aislando. No tiene interés en otros")
	elsif rel>0.5
		salida.push("H+Dh:A+Ad hacia humano. Persona con interés exagerado por relacionarse")
	else
		salida.push("H+Dh:A+Ad equilibrado. Persona con interés normal por relacionarse")
	end
	rel=(_c['H']+_c['A']).to_f/(_c['Hd']+_c['Ad'])
	if rel<0.3
		salida.push("H+A:Hd+Ad hacia parcial. Se relaciona con objetos parciales, disocia, escinde, se relaciona con partes del otro")
	else
		salida.push("H+A:Hd+Ad hacia total. Persona se relaciona con objetos totales")
	end
	
	if (_c['H']+_c['Hd']) >= (_c['(H)']+_c['(Hd)'])*3
		salida.push("H+Hd>(H)+(hd)*3: Se relaciona a nivel concreto")
	else
		salida.push("H+Hd<(H)+(hd)*3: Se relaciona en la fantasía")
	end

	if porcentaje(_c['H']+_c['Hd'])>=0.2
		salida.push("H+Hd>=20%. Capacidad e interés en relacionarse con otros")
	else 
		salida.push("H+Hd<20%. Poca capacidad e interés en relacionarse con otros")
	end
	if (_c['Hd']+_c['(H)']+_c['(Hd)'])*3>_c['H']
		salida.push("H<Hd+(H)+(Hd)*3: Problemas en interpersonal. Revisar protocolo para ver que pasa.")
		salida.push("Puede que no sea válido, porque faltan humanos") if (_c['Hd']+_c['(H)']+_c['(Hd)']+_c['H'])<3
	end
	if _c['Hd']*3>_c['H']
		salida.push("H<Hd*3: Angustia, depresión y fobia social. Aumenta si los Hd son perfiles de caras")
	end

	if a_porciento>0.47
		salida.push("A% aumentado. Sujeto inmaduro, rutinario, predecible")
	elsif a_porciento<0.31
		salida.push("A% disminuido. Sujeto Flexible. Si es muy bajo, poco comprometido")
	else
		salida.push("A% normal. Buena adaptación social")
	end
	
	if @tipos_contenidos>=5
		salida.push("Tipos de contenido mayor a 5. Flexibilidad intelectual y distintos intereses")
	else
		salida.push("Tipos de contenido menor a 5. Poca flexibilidad intelectual y pocos intereses")
	end		
	salida.push('{\b Autopercepción}')
	if autocentracion<0.32
		salida.push("ego disminuido. Tiene dificultades para tomarse a sí mismo como centro de interes")
	elsif autocentracion>0.46
		salida.push("ego aumentado. Sujeto tiende a tomarse como centro de sus preocupaciones. Privilegia mucho su propio punto de vista. Le cuesta ser flexibles")
	else
		salida.push("ego normal. Capacidad normal para ser el eje de su propia atención")
	end
	if sumdet("V")>norma(0.84)
		salida.push("Vista aumentado. Instrospección dolorosa. El sujeto se mira a si mismo con culpa") 
	end
	if sumdet("FD")>norma(2.03)
		salida.push("FD aumentada. Anormal distanciamiento del yo. Si está en terapia, es normal")
	end
	salida.push("Xy+An>2. Si no hay problemas físicos, trastornos de autoimagen") if an_xy>2
	salida.push("MOR>2. Pesimismo") if _ccee['MOR']>2
	
	if _c['H']>_c['(H)']+_c['Hd']+_c['(Hd)']
		salida.push("H>(H)+Hd+(Hd). Percepción realista de sí mismo")
	else
		salida.push("H<(H)+Hd+(Hd). Percepción no realista de sí mismo")
	end
	
	#
	# POTENCIAL INTELECTUAL
	#
	salida.push('{\b Potencial intelectual}')
	salida.push("Revisa que los valores estén sobre, en o bajo el promedio")
	salida.push(respuestatriple(self.R, 18.44, 26.9, 
	"R disminuida. Signo de potencial bajo", 
	"R aumentada. Signo de potencial superior", 
	"R normal. Signo de potencial normal"))
	salida.push(respuestatriple(fmas, 0.54, 0.88, 
	"F+% disminuido. Signo de potencial bajo", 
	"F+% aumentado. Signo de potencial normal, pero posiblemente bajo", 
	"F+% normal. Signo de potencial normal o superior"))
	salida.push(respuestatriple(xmas, 0.71, 0.87, 
	"X+% disminuido. Signo de potencial bajo", 
	"X+% aumentado. Signo de potencial normal, pero posiblemente bajo", 
	"X+% normal. Signo de potencial normal o superior"))
	salida.push(respuestatriple(@frecuencias['dq']['+'], 5.15,9.47, 
	"DQ+ disminuido. Signo de potencial normal o bajo", 
	"DQ+ aumentado. Signo de potencial alto", 
	"DQ+ normal. Signo de potencial normal"))
	salida.push(respuestatriple(@frecuencias['fqx']['+'], 0,1.82, 
	"FQX+ disminuido. Signo de potencial normal o bajo", 
	"FQX+ aumentado. Signo de potencial alto", 
	"FQX+ normal. Signo de potencial normal"))
	salida.push(respuestatriple(@frecuencias['dq']['v'], 0.04,2.56, 
	"DQv disminuido. Signo de potencial normal", 
	"DQv aumentado. Signo de potencial bajo", 
	"DQv normal. Signo de potencial normal"))
	salida.push(respuestatriple(@frecuencias['dq']['v/+'], 0,1.07, 
	"DQv disminuido. Signo de potencial normal", 
	"DQv aumentado. Signo de potencial bajo", 
	"DQv normal. Signo de potencial normal"))
	
	#salida.collect {|a|
	#	Iconv.conv('ISO-8859-1','UTF-8',a)
	#}
	salida
		end
	end
end

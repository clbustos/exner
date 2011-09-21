# encoding: UTF-8
module Exner
	class Zulliger
	# calcula, para un determinado valor en los baremos
	# el porcentaje que le corresponde al valor específico
	# hace el ajuste en función al número de respuestas
	def norma(valor)
		r_est=11.92
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
	if self.R < 8
		salida.push('{\b ATENCION: POCAS RESPUESTAS. TEST INVALIDO}')
	end
	if self.L> 1.51
	salida.push("L > 1.51. Si hay pocas respuestas complejas, es sobre simplificación de percepción. Si no, es defensivo")
	elsif self.L<0.2
	salida.push("L < 0.2. Muy pendientes de la información. Se sobrepasan por lo datos")
	else
	salida.push("L normal. Manejo normal de la cantidad de información")
	end
	# Tipo vivencial

	if (sumdet("M").to_f-sumcolpond).abs <2
		salida.push("Ambigual"+(sumdet("M").to_f-sumcolpond).abs.to_s+". No tiene un estilo definido. Duda mucho entre el pensar y el actuar y se desgantan")
	elsif sumdet("M")>sumcolpond
		salida.push("Intratensivo. Para solucionar sus problemas recurren a su mundo interno.")
	elsif sumdet("M")<sumcolpond
			salida.push("Extratensivo. Para solucionar sus problemas recurren al mundo externo")
	end

	# estimulacion sufrida (es)

	if self.EA<2
		salida.push("EA<2. Pocos recursos!")
	elsif self.EA>7
		salida.push("EA>7. Muchos recursos")
	else
		salida.push("EA normal. Recursos dentro de la norma")
	end
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
	if sumdet("FM")>6
		salida.push("FM>6. Necesidades insatisfechas de forma crónica")
	end
	if sumdet("m")>4
		salida.push("m>4. Malestar por necesidades externas agudo aumentado")
	end

	if es>7
		salida.push("es>7. Bastante estimulación sufrida.")
	end
	if self.EA*2<self.es
		salida.push("EA<es*2: La persona mostrará dificultades para hacer frente a situaciones de tensión. Trabajará mejor en situaciones estructuradas")
	end

	salida.push('{\b Mediación}')
	if xmas>=0.8
		salida.push("X+%>0.80. Tiene los 'pies sobre la tierra'. Percibe los estímulos como la mayoría de la gente")
	end
	if wda>=0.8
		salida.push("WDA+%>0.8. La percepción es adecuada en situaciones obvias")
		if xa<0.8
			salida.push("XA%<0.8. Pero no lo es en situaciones inusuales")
		else
			salida.push("XA%>0.8. Y en situaciones inusuales")
		end
	end
	if xmenos>0.25
		salida.push("X-%>0.25. Preocupante alejamiento de lo convencional!")
	end
	if smenos>0.40
		salida.push("S-%>0.40. Fuerte interferencia emocional en situaciones de rabia")
	end

	if @populares<2
		salida.push("P<2. Tiene dificultades para percibir las normas sociales")
	elsif @populares<5
		salida.push("2<P<5. Puede percibir y acatar las normas sociales")
	else
		salida.push("P>=5. Sobresocializado. Demasiado atento a las normas sociales. sobresocializado")
	end

	salida.push('{\b Ideación}')

	if pasivos>activos+1
		salida.push("p>a+1. Persona que tiende a asumir un rol pasivo frente a los demás. Vigilar T, P, Ego disminuido y Fd")

		salida.push("T>0.Pasivo por necesidad de afecto") if (sumdet('T')>0)
		salida.push("P>4.Pasivo por Sobresocialización") if (@populares>4)
		salida.push("Fd>0. Pasivo por dependencia") if (_c['Fd']>0)
	else
		salida.push("a+1>p. Persona adopta rol activo")
	end
	if _d['Mp']>_d['Ma']+1
		salida.push("Mp>Ma+1. Crea fantasías, pero tiene dificultades para hacer deliberaciones eficaces. Ocupa su inteligencia para escapar de los problemas, no para afrontarlos")
	end
	if intelectualizacion>=5
		salida.push("Intelectualización alta. Uso abusivo de la intelectualizacion")
	end
	if _ccee['MOR']>2
		salida.push("MOR>2. Pesimismo")
	end
	if m_menos>1
		salida.push("M->0. ALERTA. Mal signo. Sus recursos ideativos presentan alteraciones")
	end
	if self.SumBr6>=5
		salida.push("SumBr6>5.Posible trastorno del pensamiento. INHIBICION DEL POTENCIAL")
	end
	if self.SumPon6>2
		salida.push("SumPon6>2.Posible trastorno del pensamiento. INHIBICION DEL POTENCIAL")
	end
	if msin>0
		salida.push("M sin >0. Es una persona que puede desorientarse y perder contacto con la realidad")
	end
	salida.push('{\b Afectos}')
	if det['FC']<det['CF']+det['C']
		salida.push("FC<CF+C. Vigilar poco control sobre descarga emocional")
		salida.push("C>CF. Posible impulsividad!") if det['C']>det['CF']
	end
	if det['C']>0
		salida.push("C>0. Persona que disfruta mucho de situaciones vertiginosas. ")
	end

	if sumdet("C'")>det['FC']*0.5+det['CF']+det['C']*1.5
		salida.push("SumC':SumPondC hacia derecha. Se internaliza en demasía la descarga afectiva. Posible somatización")
	end
	if self.Afr<0.20
		salida.push("Afr<0.2. Evitación de situaciones emocionales. Trabaja mejor en ambientes sin carga emocional")
	elsif self.Afr>1
		salida.push("Afr>1. Atracción por estimulación emocional. Trabaja mejor en ambientes cargados afectivamente.")
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
	if self.Zf<5
		salida.push("Zf dism. Sujeto con poca capacidad cognitiva o bajo nivel de motivación e  inicitiva")
	elsif self.Zf>9
		salida.push("Zf alto. Alto nivel de motivación , que dedican al proceso de información más energía que el promedio")
	else
		salida.push("Zf normal. Motivación normal")
	end
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
	if aislamiento_r>0.45
		salida.push("Aisl>0.45. Sujeto menos implicados que el resto en lo social")
	else
		salida.push("Aisl normal. Sujeto implicado en lo social")
	end

	# a (H+Dh:A+Ad)
	salida.push("Lo que sigue, tómalo con andina")
    hum=_c['H']+_c['Hd']
	an=_c['A']+_c['Ad']
	if an>hum*3
		salida.push(sprintf("H+Dh:A+Ad hacia animal(%d:%d). Persona se está aislando. No tiene interés en otros",hum,an))
	elsif an<hum*2
		salida.push(sprintf("H+Dh:A+Ad hacia humano(%d:%d). Persona con interés exagerado por relacionarse",hum,an))
	else
		salida.push("H+Dh:A+Ad equilibrado. Persona con interés normal por relacionarse")
	end
	ent=_c['H']+_c['A']
	par=_c['Hd']+_c['Ad']
	if ent<par*2
		salida.push(sprintf("H+A:Hd+Ad hacia parcial(%d:%d). Se relaciona con objetos parciales, disocia, escinde, se relaciona con partes del otro",ent,par))
	else
		salida.push(sprintf("H+A:Hd+Ad hacia total(%d:%d). Persona se relaciona con objetos totales",ent,par))
	end

	if (_c['H']+_c['Hd']) >= (_c['(H)']+_c['(Hd)'])*3
		salida.push("H+Hd>(H)+(hd)*3: Se relaciona a nivel concreto")
		salida.push("(H)+(Hd)=0. Puede que la persona no se deje tener ideales") if (_c['(H)']+_c['(Hd)'])==0
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
	salida.push("Hasta aquí llega la andina con andina")
	if _c['H']<1
		salida.push("H=0;Presenta poco interés las personas")
	elsif _c['H']>=1 and _c['H']<4
		salida.push("H="+_c['H'].to_s+". Presenta un interés promedio en las personas")
	else
		salida.push("H>4. Presenta un interés sobre el promedio por las personas")
	end

	salida.push('{\b Autopercepción}')
	if autocentracion<0.26
		salida.push("ego<0.26. Tiene dificultades para tomarse a sí mismo como centro de interes")
	elsif autocentracion>0.60
		salida.push("ego>0.60. Sujeto tiende a tomarse como centro de sus preocupaciones. Privilegia mucho su propio punto de vista. Le cuesta ser flexibles")
	else
		salida.push("ego normal. Capacidad normal para ser el eje de su propia atención")
	end
	salida.push("V>1. Sujeto con instrospección dolorosa") if sumdet('V')>1
	salida.push("FD>2. Demasiada atención a autoevaluación") if _d['FD']>2
	salida.push("Xy+An>2. Si no hay problemas físicos, trastornos de autoimagen") if an_xy>2
	salida.push("MOR>2. Pesimismo") if _ccee['MOR']>2
	if _c['H']>_c['(H)']+_c['Hd']+_c['(Hd)']
		salida.push("H>(H)+Hd+(Hd). Percepción realista de sí mismo")
	else
		salida.push("H<(H)+Hd+(Hd). Percepción no realista de sí mismo")
	end
	#salida.collect {|a|
	#	Iconv.conv('ISO-8859-1','UTF-8',a)
	#}
	salida
		end
	end
end

class AtividadesController < ApplicationController

	def index
		file=Rails.root.join('app', 'content', 'proposals.txt')#'C:\proposals.txt'
		listaPalestras = []
		File.readlines(file).each do |line|
			titulo = line
	        tempo = titulo.split(/[^\d]/).join
         	palestra = Atividade.new
         	palestra.titulo = titulo
         	palestra.tempo = tempo
		  	listaPalestras.push(palestra)
		end
		#Inicializa as disponibilidades
		track1DiponibilidadeManha = 180
        track1DiponibilidadeTarde = 240
		track2DiponibilidadeManha = 180
        track2DiponibilidadeTarde = 240
		#Inicializa o objeto de almoço
		almoco = Atividade.new
     	almoco.titulo = 'Almoço'
     	almoco.tempo = 60
     	almoco.horario = Time.new(2000, 01, 01, 12).to_formatted_s(:time)
		#Inicializa o objeto de networking
     	networking = Atividade.new
     	networking.titulo = 'Evento de networking'
     	networking.tempo = 60
     	networking.horario = Time.new(2000, 01, 01, 17).to_formatted_s(:time)
 		#Inicializa os arrays com a organização das atividades
		palestrasTrackA = []
		palestrasTrackB = []
		addPosAlmoco = []
		addEncaixes = []
		#Inicializa os contadores de horas
		contadorHorasTrack1 = Time.new(2000, 01, 01, 9)
		contadorHorasTrack2 = Time.new(2000, 01, 01, 9)
		
		# Para cada palestra listada, executa o organizador
		listaPalestras.each do |palestra|
			duracao = palestra.tempo.to_i
			# Se a duração for zero, adiciona depois do almoço
			if duracao == 0
				addEncaixes.push(palestra)
			else
				# Se o horário da Track 1 não excedeu o encerramento, adiciona as ativiades
				if track1DiponibilidadeManha >= duracao && ((track1DiponibilidadeManha - duracao) > 29 || (track1DiponibilidadeManha - duracao) == 0)
					track1DiponibilidadeManha = track1DiponibilidadeManha - duracao
                    palestra.horario = contadorHorasTrack1.to_formatted_s(:time)
					palestrasTrackA.push(palestra)
                    contadorHorasTrack1 = contadorHorasTrack1 + duracao*60 
                    if track1DiponibilidadeManha == 0
                        contadorHorasTrack1 = contadorHorasTrack1 + 60*60 
                        palestrasTrackA.push(almoco)
                    end
				elsif track1DiponibilidadeTarde >= duracao && ((track1DiponibilidadeTarde - duracao) > 29 || (track1DiponibilidadeTarde - duracao) == 0)
					if track1DiponibilidadeManha > 29
                    	addPosAlmoco.push(palestra)
                    else
                    	track1DiponibilidadeTarde = track1DiponibilidadeTarde - duracao
                        palestra.horario = contadorHorasTrack1.to_formatted_s(:time)
                        palestrasTrackA.push(palestra)
                    	contadorHorasTrack1 = contadorHorasTrack1 + duracao*60
                    end
				elsif track2DiponibilidadeManha >= duracao && ((track2DiponibilidadeManha - duracao) > 29 || (track2DiponibilidadeManha - duracao) == 0)
					track2DiponibilidadeManha = track2DiponibilidadeManha - duracao
                    palestra.horario = contadorHorasTrack2.to_formatted_s(:time)
					palestrasTrackB.push(palestra)
                    contadorHorasTrack2 = contadorHorasTrack2 + duracao*60 
                    if track2DiponibilidadeManha == 0
                        contadorHorasTrack2 = contadorHorasTrack2 + 60*60 
                        palestrasTrackB.push(almoco)
                    end
				elsif track2DiponibilidadeTarde >= duracao && ((track2DiponibilidadeTarde - duracao) > 29 || (track2DiponibilidadeTarde - duracao) == 0)
					if track2DiponibilidadeManha > 29
                    	addPosAlmoco.push(palestra)
                    else
                    	track2DiponibilidadeTarde = track2DiponibilidadeTarde - duracao
                        palestra.horario = contadorHorasTrack2.to_formatted_s(:time)
                        palestrasTrackB.push(palestra)
                    	contadorHorasTrack2 = contadorHorasTrack2 + duracao*60
                    end
				end
			end
		end

		#Realiza a adição das atividades que ficaram para encaixe após o horário do almoço
		addPosAlmoco.each do |palestra|
			duracao = palestra.tempo.to_i
			if track1DiponibilidadeTarde >= duracao
				palestra.horario = contadorHorasTrack1.to_formatted_s(:time)
				palestrasTrackA.push(palestra)
        		contadorHorasTrack1 = contadorHorasTrack1 + duracao*60
			elsif track2DiponibilidadeTarde >= duracao
				palestra.horario = contadorHorasTrack2.to_formatted_s(:time)
				palestrasTrackB.push(palestra)
        		contadorHorasTrack2 = contadorHorasTrack2 + duracao*60
			end
		end
        #Realiza a adição das atividades que ficaram de encaixe em horários disponíveis
     	addEncaixes.each do |palestra|
     		if track1DiponibilidadeManha > 0 || track1DiponibilidadeTarde > 0
     			palestra.horario = contadorHorasTrack1.to_formatted_s(:time)
     			palestrasTrackA.push(palestra)
     		elsif track2DiponibilidadeManha > 0 || track2DiponibilidadeTarde > 0
     			palestra.horario = contadorHorasTrack2.to_formatted_s(:time)
     			palestrasTrackB.push(palestra)
     		end
     	end
		# Adiciona os eventos de Networking às listas de atividades
        palestrasTrackA.push(networking)
        palestrasTrackB.push(networking)
		@palestrasTrackA = palestrasTrackA
		@palestrasTrackB = palestrasTrackB
	end
end
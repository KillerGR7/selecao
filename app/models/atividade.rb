class Atividade
	def titulo
		@titulo
	end

	def titulo=(valor)
		@titulo = valor
	end

	def tempo
		@tempo
	end

	def tempo=(valor)
		@tempo = valor
	end

	def horario
		@horario
	end

	def horario=(valor)
		@horario = valor
	end

	def preencher=(titulo, tempo, horario)
		@titulo = titulo
		@tempo = tempo
		@horario = horario
	end
end
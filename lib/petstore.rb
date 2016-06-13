# Базовые параметры конфигурации
require 'petstore/conf'

#require 'rubygems'
require 'net/http'
require 'json'

require 'petstore/pet'

module PetStore
	# Храним конфигурационные параметры подключения к API, которые позволяем менять пользователю
	# content_type - в каком формате взаимодействовать с API.
	# log - писать логи. Значение true/false
	class << self
		attr_accessor :content_type, :log
	end
	
	# Установим значения по-умолчанию
	self.content_type = 'application/json'
	self.log = true
	
	# Функция логирования
	def self.write_log(text)
		if PetStore.log
			file_log = File.new('log.txt', 'a')
			file_log.puts Time.now.strftime("%Y-%m-%d %H:%M:%S").to_s+' '+text.to_s
			file_log.close
		end
		
		return true
	end
end
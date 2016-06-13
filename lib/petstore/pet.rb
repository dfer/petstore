require 'petstore/objectstore'

module PetStore
	# Класс описывающий конкретный объект Pet
	# id (integer, optional),
	# category (Category, optional), Категория - либо нет, либо одна категория
	# name (string),
	# photoUrls (Array[string]),
	# tags (Array[Tag], optional), Тегов может быть от 0 и больше
	# status (string, optional): pet status in the store = ['available', 'pending', 'sold']
	# 
	# type - какой объект. Например 'pet'
	class Pet < ObjectStore
		@@status_valid = ['available', 'pending', 'sold']
		
		#attr_accessor :id, :category, :name, :photo_urls, :tags, :status
		attr_reader :type, :id, :category, :name, :photo_urls, :tags, :status
		
		def initialize(id=nil)
			if !id.nil?
				@id = id.to_i
			end
			
			# Устанавливаем необязательные параметры.
			# Параметр photo_urls является обязательным, но мы можем передать пустой массив в запросе
			# Поэтому его тоже устанавливаем здесь
			@category = nil
			@photo_urls = Array.new
			@tags = Array.new
			@status = nil
			
			@type = 'pet'
			
			super(@type, @id)
		end
		
		# Установим имя
		def name=(value)
			@name = value.to_s
		end
		
		# Установка категории
		def category_set(id=nil, name=nil)
			if id.nil? and name.nil?
				PetStore.write_log('Error. You can not add category without id and name. Category must has id or name.')
				return false
			else
				@category = {:id=>id.to_i, :name=>name.to_s}
			end
		end
		
		# Добавление ссылки на фотографию
		def photo_url_add(url)
			@photo_urls << url.to_s
		end
		
		# Добавление тега
		def tag_add(id=nil, name=nil)
			if id.nil? and name.nil?
				PetStore.write_log('Error. You can not add tag without id and name. Tag must has id or name.')
				return false
			else
				@tags << {:id=>id.to_i, :name=>name.to_s}
				return true
			end
		end
		
		# Установка статуса. Он может быть равен только 'available' / 'pending' / 'sold'
		def status_set(value)
			value = value.to_s.downcase
			
			if @@status_valid.include? value
				@status = value
				
				return true
			else
				PetStore.write_log('Error. You can not set wrong status to pet.')
				return false
			end
		end
		
		# Преобразуем данные Pet в нужный формат для отправки на сервер
		def to_api
			# Выполняем в зависимости от значения content_type
			if PetStore.content_type == 'application/json'
				hash = self.to_json
				return hash
			# В данный момент поддерживается только формат json
			elsif PetStore.content_type == 'application/xml'
				PetStore.write_log('Error. XML format not support now.')
				return false
			end
		end
		
		# Получаем json с объектом
		def to_json
			hash = Hash.new
			
			if !@id.nil?
				hash[:id] = @id
			end
			
			if !@category.nil?
				hash[:category] = @category
			end
			
			if !@name.nil?
				hash[:name] = @name
			else
				PetStore.write_log('Error. Pet do not have name. to_json operation is not posible.')
				return false
			end
			
			hash[:photoUrls] = []
			@photo_urls.each do |pu|
				hash[:photoUrls] << pu
			end
			
			# Так как tags - опциональное свойство, то его может и не быть
			if @tags.size > 0
				hash[:tags] = []
				@tags.each do |t|
					hash[:tags] << t
				end
			end
			
			if !@status.nil?
				hash[:status] = @status
			end
			
			return hash.to_json
		end
		
		# Устанавливаем параметры объекта полученные с сервера
		def read_json(json)
			# Разбираем полученный json от API-сервера
			hash_from_server = JSON.parse json
			
			if !hash_from_server['id'].nil?
				@id = hash_from_server['id'].to_i
			end
			
			if !hash_from_server['name'].nil?
				@name = hash_from_server['name'].to_s
			end
			
			if !hash_from_server['status'].nil?
				unless self.status_set(hash_from_server['status'])
					PetStore.write_log('read_json. Error. We get wrong status for pet from json.')
					return false
				end
			end
			
			if !hash_from_server['photoUrls'].nil?
				hash_from_server['photoUrls'].each do |pu|
					self.photo_url_add(pu)
				end
			end
			
			if !hash_from_server['tags'].nil?
				hash_from_server['tags'].each do |t|
					unless self.tag_add(t['id'], t['name'])
						PetStore.write_log('read_json. You get wrong tag for pet from json.')
						return false
					end
				end
			end
			
			if !hash_from_server['category'].nil?
				unless self.category_set(hash_from_server['category']['id'], hash_from_server['category']['name'])
					PetStore.write_log('read_json. Error. We get wrong category for pet from json.')
					return false
				end
			end
		end
		
		# ------ Функции для работы с API ---------
		# Они переопределяют функции из родительского класса
		
		# Получение объекта с сервера
		def api_get
			if !@id.nil?
				result = super
				
				unless result
					PetStore.write_log('Api_get. Error from API server.')
					return false
				else
					# Разбираем полученный json от API-сервера
					self.read_json(result[2])
				end
			else
				PetStore.write_log('Api_get. Error. Pet don not have id.')
				return false
			end
		end
		
		# Удаление объекта на сервере
		def api_delete
			if !@id.nil?
				super
			else
				PetStore.write_log('Api_delete. Error. Pet don not have id.')
				return false
			end
		end
		
		# Добавление объекта на сервер с помощью API
		def api_add
			hash = self.to_api
			
			if hash != false
				result = super(hash)
				
				unless result
					return false
				else
					# Разбираем полученное тело ответа только в одном случае. 
					# Если при создании объекта у него не было задано значение id, то мы получаем его от API
					if @id.nil?
						json_from_server = result[2]
						hash = JSON.parse json_from_server
						
						if hash['id'].to_i > 0 
							@id = hash['id'].to_i
						else
							PetStore.write_log('Api_add. Error. Pet don not get id.')
							return false
						end
					end
				end
			end
		end
		
		# Обновление объекта на сервере с помощью API
		def api_update
			hash = self.to_api
			
			if hash != false
				super(hash)
			end
		end
		
		# Поиск pets с указанным статусом
		def api_find_by_status(status)
			status = status.downcase
			
			# Проверям что статус валиден
			if @@status_valid.include? status
				super(status)
			else
				PetStore.write_log('Api_find_by_status. Error. You can not find pets from wrong status.')
				return false
			end
		end
		
		# Обновление имени или статуса на сервере
		def api_update_name_status(name=nil, status=nil)
			if @id.nil?
				PetStore.write_log('Api_update_name_status. Error. Pet do not have id.')
				return false
			end
				
			if name.nil? and status.nil?
				PetStore.write_log('Api_update_name_status. Error. Pet do not have name and status.')
				return false
			end
				
			if !name.nil?
				@name = name.to_s
			end
			
			if !status.nil? and self.status_set(status) == false
				PetStore.write_log('Api_update_name_status. Error. You can not set wrong status to pet.')
				return false
			end
			
			super(@name, @status)
		end
		
		# Загрузка файла с картинкой на сервер
		def api_upload_image(filename)
			super(filename.to_s)
		end
	end
end
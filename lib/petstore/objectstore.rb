module PetStore
	class ObjectStore
		attr_accessor :type, :objectid, :content_type
	
		def initialize(type, objectid)
			@type = type.to_s
			@objectid = objectid.to_i
			@content_type = PetStore.content_type.to_s
			@content_type.downcase!
		end
		
		# Установлен верный content-type?
		def content_type_valid?
			if CONTENT_TYPES.include? @content_type
				return true
			else
				PetStore.write_log('Error with content_type')
				return false
			end
		end
		
		# Корректен ли тип объекта?
		def type_valid?
			unless OBJECT_TYPES.include? @type
				PetStore.write_log('Error with type')
				return false
			else
				return true
			end
		end
		
		# Можно ли делать API-запрос?
		def can_make_api_request?
			if self.content_type_valid? and self.type_valid?
				return true
			else
				return false
			end
		end
		
		# Формирование и выполнение запроса к серверу API
		def api_call(method, path, body=nil, form_data_hash=nil, filename=nil)
			# Проверим, что метод верный
			method = method.to_s.downcase
			
			unless ['get', 'post', 'put', 'delete'].include? method
				PetStore.write_log('Api_call wrong http-method.')
				return false
			end
			
			path = path.to_s
			
			if path == ''
				PetStore.write_log('Api_call path is empty.')
				return false
			end
			
			begin
				uri = URI.parse(path)
				http = Net::HTTP.new(uri.host, uri.port)
				http.open_timeout = TIMEOUT_OPEN
				http.read_timeout = TIMEOUT_READ
				
				if method == 'get'
					request = Net::HTTP::Get.new(uri.path)
				elsif method == 'post'
					request = Net::HTTP::Post.new(uri.path)
				elsif method == 'put'
					request = Net::HTTP::Put.new(uri.path)
				elsif method == 'delete'
					request = Net::HTTP::Delete.new(uri.path)
				end
				
				request["Accept"] = @content_type
				request["Content-Type"] = @content_type
				
				request.body = body.to_s if !body.nil?
				
				# Значения передаваемые в теле post-запроса
				if !form_data_hash.nil?
					if method != 'post'
						PetStore.write_log('Api_call We can not send form_data without post http-method')
						return false
					else
						# Благодаря request.form_data= content-type будет автоматически установлен равным 'application/x-www-form-urlencoded'
						request.form_data = form_data_hash
					end
				end
				
				# Если отправляем файл
				if !filename.nil?
					if method != 'post'
						PetStore.write_log('Api_call We can not send file without post http-method')
						return false
					else
						request.set_form [['file',  File.open(filename)]], 'multipart/form-data'
					end
				end
				
				response = http.request(request)
				
				# Проверям что получили 200 код ответа
				# Оставить так, потому что в будущем может понадобиться определенные коды ответа обрабатывать по особому в классе объекта
				if response.code.to_i != 200
					# Логируем сообщение об ошибке от сервера API
					PetStore.write_log('Api_call response code not equal 200. Response body:'+response.body.to_s)
					return false
				else
					# Возвращаем массив с кодом ответа, типом ответа и телом ответа
					return [response.code.to_i, response["content-type"].to_s, response.body.to_s]
				end
			rescue Timeout::Error
				PetStore.write_log('Api_call timeout error. Timeout params: open_timeout:'+TIMEOUT_OPEN.to_s+' read_timeout:'+TIMEOUT_READ.to_s)
				return false
			end
		end
		
		# Обработка запроса GET /object/{objectid}
		def api_get
			# Логируем с какими параметрами вызвана функция
			PetStore.write_log('Function api_get call with parameters: type:'+@type+' objectid:'+@objectid.to_s+' content_type:'+@content_type)
			
			unless self.can_make_api_request?
				return false
			end
			
			self.api_call('get', BASE_URL+@type+'/'+@objectid.to_s)
		end
		
		# Обработка запроса POST /object
		def api_add(body)
			# Логируем с какими параметрами вызвана функция
			PetStore.write_log('Function api_add call with parameters: type:'+@type+' content_type:'+@content_type+' body:'+body.to_s)
			
			unless self.can_make_api_request?
				return false
			end
			
			self.api_call('post', BASE_URL+@type, body)
		end
		
		# Обработка запроса PUT /object
		def api_update(body)
			# Логируем с какими параметрами вызвана функция
			PetStore.write_log('Function api_update call with parameters: type:'+@type+' content_type:'+@content_type+' body:'+body.to_s)
			
			unless self.can_make_api_request?
				return false
			end
			
			self.api_call('put', BASE_URL+@type, body)
		end
		
		# Обработка запроса GET /object/findByStatus
		# Проверка на валидность статусов происходит в дочернем классе. Так как для каждого типа объекта статусы могут быть разными.
		# Здесь status является валидной строкой, которую нужно просто передать в GET запрос
		def api_find_by_status(status)
			# Логируем с какими параметрами вызвана функция
			PetStore.write_log('Function api_find_by_status call with parameters: type:'+@type+' status:'+status.to_s+' content_type:'+@content_type)
			
			unless self.can_make_api_request?
				return false
			end
			
			self.api_call('get', BASE_URL+@type+'/findByStatus?status='+URI::encode(status))
		end
		
		# Обработка запроса DELETE /object/{objectid}
		def api_delete
			# Логируем с какими параметрами вызвана функция
			PetStore.write_log('Function api_delete call with parameters: type:'+@type+' objectid:'+@objectid.to_s+' content_type:'+@content_type)
			
			unless self.can_make_api_request?
				return false
			end
			
			self.api_call('delete', BASE_URL+@type+'/'+@objectid.to_s)
		end
		
		# Обработка запроса POST /object/{objectid}
		# Обновление у конкретного objectid name и/или status
		def api_update_name_status(name, status)
			# Логируем с какими параметрами вызвана функция
			PetStore.write_log('Function api_update_name_status call with parameters: type:'+@type+' objectid:'+@objectid.to_s+' content_type:'+@content_type+' name:'+name.to_s+' status:'+status.to_s)
			
			unless self.can_make_api_request?
				return false
			end
			
			if name.nil?
				form_data_hash = {'status'=>status}
			elsif status.nil?
				form_data_hash = {'name'=>name}
			else
				form_data_hash = {'name'=>name, 'status'=>status}
			end
			
			self.api_call('post', BASE_URL+@type+'/'+@objectid.to_s, nil, form_data_hash)		
		end
		
		# Обработка запроса POST /object/{objectid}/uploadImage
		# Обновление у конкретного objectid name и/или status
		def api_upload_image(filename)
			# Логируем с какими параметрами вызвана функция
			PetStore.write_log('Function api_upload_image call with parameters: type:'+@type+' objectid:'+@objectid.to_s+' content_type:'+@content_type+' filename:'+filename.to_s)
			
			unless self.can_make_api_request?
				return false
			end
			
			# Проверим, что файл существует и у него допустимое расширение
			unless File.exist?(filename)
				PetStore.write_log('File to upload image not exist.')
				return false
			end
			
			# Функция вернет из '123.png' -> '.png'
			extension = File.extname(filename).downcase  
			
			if extension == ''
				PetStore.write_log('File to upload image has empty extension.')
				return false
			end
			
			extension = extension[1..extension.size-1] # Избавлемся от точки в начале строки
			
			# Смотрим входит ли расширение файла в список допустимых?
			unless IMAGE_EXTENSION.include? extension
				PetStore.write_log('File to upload image has wrong extension.')
				return false
			end
			
			self.api_call('post', BASE_URL+@type+'/'+@objectid.to_s+'/uploadImage', nil, nil, filename)		
		end
	end
end
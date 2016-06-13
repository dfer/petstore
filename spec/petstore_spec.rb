require_relative '../lib/petstore'

describe do
	context 'Тестирование класса Pet' do
		# ----------- Создание экземпляра класса --------------
		it 'Создание объекта с указанием id' do
			id = rand(100)
			pet = PetStore::Pet.new(id)
			
			expect(pet.id).to eq id
			expect(pet.category).to be_nil
			expect(pet.photo_urls).to match_array([])
			expect(pet.tags).to match_array([])
			expect(pet.status).to be_nil
			expect(pet.type).to eq 'pet'
		end
		
		it 'Создание объекта без указания id' do
			pet = PetStore::Pet.new
			
			expect(pet.id).to be_nil
			expect(pet.category).to be_nil
			expect(pet.photo_urls).to match_array([])
			expect(pet.tags).to match_array([])
			expect(pet.status).to be_nil
			expect(pet.type).to eq 'pet'
		end
		
		# ----------- Установка имени --------------
		it 'name=строка.' do
			pet = PetStore::Pet.new
			
			new_name = 'some_text'
			pet.name = new_name
			expect(pet.name).to eq new_name
		end
		
		it 'name=пустая строка.' do
			pet = PetStore::Pet.new
			
			new_name = ''
			pet.name = new_name
			expect(pet.name).to eq new_name
		end
		
		it 'name=число.' do
			pet = PetStore::Pet.new
			
			new_name = 123
			pet.name = new_name
			expect(pet.name).to eq new_name.to_s
		end
		
		# ----------- Установка категории --------------
		it 'category_set(id=nil, name=nil). Функция вернет false' do
			pet = PetStore::Pet.new
			
			category_id = nil
			category_name = nil
			expect(pet.category_set(category_id, category_name)).to be false
		end 
			
		it 'category_set(id-число, name=nil)' do
			pet = PetStore::Pet.new
			
			rand_int = rand(100)
			category_id = rand_int
			category_name = nil
			pet.category_set(category_id, category_name)
			expect(pet.category[:id]).to eq rand_int
			expect(pet.category[:name]).to eq ''
		end
		
		it 'category_set(id=nil, name-string)' do
			pet = PetStore::Pet.new
			
			category_id = nil
			category_name = 'some_text'
			pet.category_set(category_id, category_name)
			expect(pet.category[:id]).to eq 0
			expect(pet.category[:name]).to eq category_name
		end
		
		it 'category_set(id-число, name-string)' do
			pet = PetStore::Pet.new
			
			rand_int = rand(100)
			category_id = rand_int
			category_name = 'some_text'
			pet.category_set(category_id, category_name)
			expect(pet.category[:id]).to eq rand_int
			expect(pet.category[:name]).to eq category_name
		end
		
		it 'category_set(id-nil, name-число). Name должно быть преобразовано в строку' do
			pet = PetStore::Pet.new
			
			rand_int = rand(100)
			category_id = nil
			category_name = rand_int
			pet.category_set(category_id, category_name)
			expect(pet.category[:id]).to eq 0
			expect(pet.category[:name]).to eq rand_int.to_s
		end
		
		# ----------- Добавление ссылки(-ок) на фотографию --------------
		it 'photo_url_add. Ссылка в виде не пустой строки' do 
			pet = PetStore::Pet.new
			
			url = 'some_text'
			pet.photo_url_add(url)
			expect(pet.photo_urls).to include (url)
		end
		
		it 'photo_url_add. Ссылка в виде пустой строки' do 
			pet = PetStore::Pet.new
			
			url = ''
			pet.photo_url_add(url)
			expect(pet.photo_urls).to include (url)
		end
		
		it 'photo_url_add. Ссылка в виде числа' do 
			pet = PetStore::Pet.new
			
			url = 123
			pet.photo_url_add(url)
			expect(pet.photo_urls).to include (url.to_s)
		end
		
		it 'photo_url_add. Ссылка в виде nil' do 
			pet = PetStore::Pet.new
			
			url = nil
			pet.photo_url_add(url)
			expect(pet.photo_urls).to include (url.to_s)
		end
		
		it 'photo_url_add. Добавление нескольких ссылок' do 
			pet = PetStore::Pet.new
			
			rand_url = Array.new
			
			for i in 0..10 do 
				rand_url[i] = 'some_url_'+rand(100).to_s
				
				pet.photo_url_add(rand_url[i])
				
				expect(pet.photo_urls).to include (rand_url[i])
			end
		end
		
		# ----------- Добавление тега(-ов) --------------
		it 'tag_add(id=nil, name=nil)' do
			pet = PetStore::Pet.new
			
			tag_id = nil
			tag_name = nil
			expect(pet.tag_add(tag_id, tag_name)).to be false
		end 
			
		it 'tag_add(id-число, name=nil)' do
			pet = PetStore::Pet.new
			
			rand_int = rand(100)
			tag_id = rand_int
			tag_name = nil
			pet.tag_add(tag_id, tag_name)
			expect(pet.tags[0][:id]).to eq rand_int
			expect(pet.tags[0][:name]).to eq ''
		end
		
		it 'tag_add(id-nil, name-string)' do
			pet = PetStore::Pet.new
			
			tag_id = nil
			tag_name = 'some_text'
			pet.tag_add(tag_id, tag_name)
			expect(pet.tags[0][:id]).to eq 0
			expect(pet.tags[0][:name]).to eq tag_name
		end
		
		it 'tag_add(id-число, name-string)' do
			pet = PetStore::Pet.new
			
			rand_int = rand(100)
			tag_id = rand_int
			tag_name = 'some_text'
			pet.tag_add(tag_id, tag_name)
			expect(pet.tags[0][:id]).to eq rand_int
			expect(pet.tags[0][:name]).to eq tag_name
		end
		
		it 'Добавление нескольких тегов' do 
			pet = PetStore::Pet.new
			
			rand_id, rand_name = Array.new, Array.new
			
			for i in 0..10 do 
				rand_id[i] = rand(100)
				rand_name[i] = 'some_text_'+rand_id[i].to_s
				
				pet.tag_add(rand_id[i], rand_name[i])
				
				expect(pet.tags[i][:id]).to eq rand_id[i]
				expect(pet.tags[i][:name]).to eq rand_name[i]
			end
		end
		
		# ----------- Установка статуса --------------
		# Статус может либо отсутствовать, либо быть равен одному из трех значений: 'available' / 'pending' / 'sold'
		it 'status_set. Статус не равен ни одному из трех значений. Получим false' do
			pet = PetStore::Pet.new
			 
			expect(pet.status_set('some_text')).to be false 
		end
		
		it 'status_set. Статус равен одному из трех значений. Значения указаны с маленькой буквы' do
			pet = PetStore::Pet.new
			
			array_with_valid_values = ['available', 'pending', 'sold']
			
			for i in 0..2 do
				pet.status_set(array_with_valid_values[i])
				expect(pet.status).to eq array_with_valid_values[i]
			end
		end
		
		it 'status_set. Статус равен одному из трех значений. Значения указаны с большой буквы' do
			pet = PetStore::Pet.new
			
			array_with_not_valid_values = ['Available', 'Pending', 'Sold']
			
			for i in 0..2 do
				pet.status_set(array_with_not_valid_values[i])
				
				expect(pet.status).to eq array_with_not_valid_values[i].downcase
			end
		end
		
		# ------------- to_api ------------------
		it '.to_api. Проверка для content_type != application/json' do
			pet = PetStore::Pet.new
			PetStore.content_type = 'application/xml'
			
			expect(pet.to_api).to be false
		end
		
		it '.to_api. Проверка для content_type = application/json' do
			id = rand(100)
			pet = PetStore::Pet.new(id)
			PetStore.content_type = 'application/json'
			pet.name = 'some_name'
			
			expect(pet.to_api).to eq pet.to_json
		end
		
		# ------------- to_json ------------------
		it '.to_json. Установим все возможные параметры Pet' do
			id = rand(100)
			category_id = rand(100)
			
			pet = PetStore::Pet.new(id)
			PetStore.content_type = 'application/json'
			
			pet.name = 'some_name'
			pet.status_set('available')
			pet.category_set(category_id, 'catagory_name')
			pet.tag_add(1, 'tag_one')
			pet.tag_add(2, 'tag_two')
			pet.photo_url_add('some_url1')
			pet.photo_url_add('some_url2')
			
			pet_json = pet.to_json
			result = JSON.parse pet_json
			
			# Генерируем json с которым будем сравнивать результат
			hash = {:id=>id, :name=>'some_name', :status=>'available', :category=>{:id=>category_id, :name=>'catagory_name'}, :tags=>[{:id=>1, :name=>'tag_one'}, {:id=>2, :name=>'tag_two'}], :photoUrls=>['some_url1', 'some_url2']}
			hash_json = hash.to_json
			result_in_test = JSON.parse hash_json
			
			expect(result['id']).to eq result_in_test['id']
			expect(result['name']).to eq result_in_test['name']
			expect(result['status']).to eq result_in_test['status']
			expect(result['category']).to eq result_in_test['category']
			expect(result['tags']).to eq result_in_test['tags']
			expect(result['photoUrls']).to eq result_in_test['photoUrls']
		end
		 
		it '.to_json Вызов без установленного св-ва name' do 
			pet = PetStore::Pet.new
			PetStore.content_type = 'application/json'
			
			expect(pet.to_json).to be false
		end
		
		# ------------- .read_json -----------------
		it '.read_json' do 
			# Генерируем json, а потом сравниваем хэш полученный из него с результатом работы .json_read
			id = rand(100)
			category_id = rand(100)
			
			pet = PetStore::Pet.new(id)
			PetStore.content_type = 'application/json'
			
			pet.name = 'some_name'
			pet.status_set('available')
			pet.category_set(category_id, 'catagory_name')
			pet.tag_add(1, 'tag_one')
			pet.tag_add(2, 'tag_two')
			pet.photo_url_add('some_url1')
			pet.photo_url_add('some_url2')
			
			pet_json = pet.to_json
			result = JSON.parse pet_json
			
			# Создаем новый объект на основе сгенерированного json
			pet_form_json = PetStore::Pet.new
			pet_form_json.read_json(pet_json)
			
			expect(pet.id).to eq pet_form_json.id
			expect(pet.name).to eq pet_form_json.name
			expect(pet.category).to eq pet_form_json.category
			expect(pet.status).to eq pet_form_json.status
			expect(pet.tags).to eq pet_form_json.tags
			expect(pet.photo_urls).to eq pet_form_json.photo_urls
		end
	end
	
	context 'Тестирование класса Pet - работа с API' do
		# ------------- api_add ----------------
		it 'api_add Only Pet: name' do 
			name = 'pet_name'+rand(100).to_s
			
			pet = PetStore::Pet.new
			pet.name = name
			
			result = pet.api_add
			
			expect(result).to_not be false
			expect(pet.id).to be > 0
			expect(pet.name).to eq name
		end
		
		it 'api_add Only Pet: id, name' do 
			name = 'pet_name'+rand(100).to_s
			id = rand(1_000_000)
			
			pet = PetStore::Pet.new(id)
			pet.name = name
			
			result = pet.api_add
			
			expect(result).to_not be false
			expect(pet.id).to eq id
			expect(pet.name).to eq name
		end
		
		it 'api_add Only Pet: id, name, status' do 
			name = 'pet_name'+rand(100).to_s
			id = rand(1_000_000)
			status = 'sold'
			
			pet = PetStore::Pet.new(id)
			pet.name = name
			pet.status_set(status)
			
			result = pet.api_add
			
			expect(result).to_not be false
			expect(pet.id).to eq id
			expect(pet.name).to eq name
			expect(pet.status).to eq status
		end
		
		it 'api_add Only Pet: id, name, status, tags' do 
			name = 'pet_name'+rand(100).to_s
			id = rand(1_000_000)
			status = 'sold'
			tags = [{:id=>1, :name=>'tag_one'}, {:id=>2, :name=>'tag_two'}]
			
			pet = PetStore::Pet.new(id)
			pet.name = name
			pet.status_set(status)
			
			for i in 0..1 do
				pet.tag_add(tags[i][:id], tags[i][:name])
			end
			
			result = pet.api_add
			
			expect(result).to_not be false
			expect(pet.id).to eq id
			expect(pet.name).to eq name
			expect(pet.status).to eq status
			expect(pet.tags).to eq tags
		end
		
		it 'api_add Only Pet: id, name, status, tags, category' do 
			name = 'pet_name'+rand(100).to_s
			id = rand(1_000_000)
			status = 'sold'
			tags = [{:id=>1, :name=>'tag_one'}, {:id=>2, :name=>'tag_two'}]
			category_id = rand(1000)
			category = {:id=>category_id, :name=>'category_name'}
			
			pet = PetStore::Pet.new(id)
			pet.name = name
			pet.status_set(status)
			
			for i in 0..1 do
				pet.tag_add(tags[i][:id], tags[i][:name])
			end
			
			pet.category_set(category[:id], category[:name])
			
			result = pet.api_add
			
			expect(result).to_not be false
			expect(pet.id).to eq id
			expect(pet.name).to eq name
			expect(pet.status).to eq status
			expect(pet.tags).to eq tags
			expect(pet.category).to eq category
		end
		
		it 'api_add Only Pet: id, name, status, tags, category, photoUrls' do 
			name = 'pet_name'+rand(100).to_s
			id = rand(1_000_000)
			status = 'sold'
			tags = [{:id=>1, :name=>'tag_one'}, {:id=>2, :name=>'tag_two'}]
			category_id = rand(1000)
			category = {:id=>category_id, :name=>'category_name'}
			photo_urls = ['some_url1', 'some_url2']
			
			pet = PetStore::Pet.new(id)
			pet.name = name
			pet.status_set(status)
			
			for i in 0..1 do
				pet.tag_add(tags[i][:id], tags[i][:name])
			end
			
			pet.category_set(category[:id], category[:name])
			
			for i in 0..1 do 
				pet.photo_url_add(photo_urls[i])
			end
			
			result = pet.api_add
			
			expect(result).to_not be false
			expect(pet.id).to eq id
			expect(pet.name).to eq name
			expect(pet.status).to eq status
			expect(pet.tags).to eq tags
			expect(pet.category).to eq category
			expect(pet.photo_urls).to eq photo_urls
		end
		
		it 'api_add + api_get Pet: id, name, status, tags, category, photoUrls' do 
			name = 'pet_name'+rand(100).to_s
			id = rand(1_000_000)
			status = 'sold'
			tags = [{:id=>1, :name=>'tag_one'}, {:id=>2, :name=>'tag_two'}]
			category_id = rand(1000)
			category = {:id=>category_id, :name=>'category_name'}
			photo_urls = ['some_url1', 'some_url2']
			
			pet = PetStore::Pet.new(id)
			pet.name = name
			pet.status_set(status)
			
			for i in 0..1 do
				pet.tag_add(tags[i][:id], tags[i][:name])
			end
			
			pet.category_set(category[:id], category[:name])
			
			for i in 0..1 do 
				pet.photo_url_add(photo_urls[i])
			end
			
			result = pet.api_add
			
			# Загружаем с сервера этот объект
			pet_new = PetStore::Pet.new(pet.id)
			result_get = pet_new.api_get
			
			expect(result).to_not be false
			expect(result_get).to_not be false
			expect(pet.id).to eq pet_new.id
			expect(pet.name).to eq pet_new.name
			expect(pet.status).to eq pet_new.status
			expect(pet.tags).to eq pet_new.tags
			expect(pet.category).to eq pet_new.category
			expect(pet.photo_urls).to eq pet_new.photo_urls
		end
		
		it 'api_add + api_delete + api_get Pet: id, name, status, tags, category, photoUrls' do 
			name = 'pet_name'+rand(100).to_s
			id = rand(1_000_000)
			status = 'sold'
			tags = [{:id=>1, :name=>'tag_one'}, {:id=>2, :name=>'tag_two'}]
			category_id = rand(1000)
			category = {:id=>category_id, :name=>'category_name'}
			photo_urls = ['some_url1', 'some_url2']
			
			pet = PetStore::Pet.new(id)
			pet.name = name
			pet.status_set(status)
			
			for i in 0..1 do
				pet.tag_add(tags[i][:id], tags[i][:name])
			end
			
			pet.category_set(category[:id], category[:name])
			
			for i in 0..1 do 
				pet.photo_url_add(photo_urls[i])
			end
			
			result = pet.api_add
			
			# Удаляем объект на сервере
			result_delete = pet.api_delete
			
			# Загружаем с сервера этот объект
			pet_new = PetStore::Pet.new(pet.id)
			result_get = pet_new.api_get
			
			expect(result).to_not be false
			expect(result_delete).to_not be false
			expect(result_get).to be false
		end
		
		it 'api_get Pet without id' do 
			pet = PetStore::Pet.new
			result_get = pet.api_get
			
			expect(result_get).to be false
		end
		
		it 'api_delete Pet without id' do 
			pet = PetStore::Pet.new
			result_delete = pet.api_delete
			
			expect(result_delete).to be false
		end
		
		it 'api_find_by_status(status is not valid)' do 
			pet = PetStore::Pet.new
			result = pet.api_find_by_status('not_valid_status')
			
			expect(result).to be false
		end
		
		it 'api_find_by_status(status is valid)' do 
			pet = PetStore::Pet.new
			result = pet.api_find_by_status('available')
			
			expect(result).to_not be false
		end
		
		it 'api_update_name_status Pet without id' do 
			pet = PetStore::Pet.new
			result_update = pet.api_update_name_status
			
			expect(result_update).to be false
		end
		
		it 'api_add + api_update_name_status(name=nil, status=nil)' do 
			pet_new = PetStore::Pet.new
			pet_new.name = 'first name'
			pet_new.status_set('available')
			result_add = pet_new.api_add
			
			result_update = pet_new.api_update_name_status(nil, nil)
			
			expect(result_add).to_not be false
			expect(result_update).to be false
		end
		
		it 'api_add + api_update_name_status(name string, status=nil) + api_get' do 
			id = rand(1_000_000)
			name_current = 'first name'
			status_current = 'available'
			
			pet = PetStore::Pet.new(id)
			pet.name = name_current
			pet.status_set(status_current)
			
			expect(pet.id).to eq id
			expect(pet.name).to eq name_current
			expect(pet.status).to eq status_current
			
			result_add = pet.api_add
			
			expect(result_add).to_not be false
			
			name_new = 'second name'
			result_update = pet.api_update_name_status(name_new)
			
			expect(result_update).to_not be false
			expect(pet.name).to eq name_new
			expect(pet.status).to eq status_current
			
			# Загружаем с сервера данные об объекте
			pet_2 = PetStore::Pet.new(pet.id)
			result_get = pet_2.api_get
			
			expect(result_get).to_not be false
			expect(pet_2.name).to eq pet.name
			expect(pet_2.status).to eq pet.status
		end
		
		it 'api_add + api_update_name_status(name nil, status string) + api_get' do 
			id = rand(1_000_000)
			name_current = 'first name'
			status_current = 'available'
			
			pet = PetStore::Pet.new(id)
			pet.name = name_current
			pet.status_set(status_current)
			
			expect(pet.id).to eq id
			expect(pet.name).to eq name_current
			expect(pet.status).to eq status_current
			
			result_add = pet.api_add
			
			expect(result_add).to_not be false
			
			name_new = nil
			status_new = 'sold'
			result_update = pet.api_update_name_status(name_new, status_new)
			
			expect(result_update).to_not be false
			expect(pet.name).to eq name_current
			expect(pet.status).to eq status_new
			
			# Загружаем с сервера данные об объекте
			pet_2 = PetStore::Pet.new(pet.id)
			result_get = pet_2.api_get
			
			expect(result_get).to_not be false
			expect(pet_2.name).to eq pet.name
			expect(pet_2.status).to eq pet.status
		end
		
		it 'api_add + api_update_name_status(name string, status string) + api_get' do 
			id = rand(1_000_000)
			name_current = 'first name'
			status_current = 'available'
			
			pet = PetStore::Pet.new(id)
			pet.name = name_current
			pet.status_set(status_current)
			
			expect(pet.id).to eq id
			expect(pet.name).to eq name_current
			expect(pet.status).to eq status_current
			
			result_add = pet.api_add
			
			expect(result_add).to_not be false
			
			name_new = 'second name'
			status_new = 'sold'
			result_update = pet.api_update_name_status(name_new, status_new)
			
			expect(result_update).to_not be false
			expect(pet.name).to eq name_new
			expect(pet.status).to eq status_new
			
			# Загружаем с сервера данные об объекте
			pet_2 = PetStore::Pet.new(pet.id)
			result_get = pet_2.api_get
			
			expect(result_get).to_not be false
			expect(pet_2.name).to eq pet.name
			expect(pet_2.status).to eq pet.status
		end
		
		it 'api_add + api_upload_image(filename) file not exist' do 
			id = rand(1_000_000)
			name_current = 'first name'
			
			pet = PetStore::Pet.new(id)
			pet.name = name_current
			
			result_add = pet.api_add
			expect(result_add).to_not be false
			
			result_upload = pet.api_upload_image('temp989879hji.png')
			expect(result_upload).to be false
		end
		
		it 'api_add + api_upload_image(filename) file exist with right extension' do 
			id = rand(1_000_000)
			name_current = 'first name'
			
			pet = PetStore::Pet.new(id)
			pet.name = name_current
			
			result_add = pet.api_add
			expect(result_add).to_not be false
			
			filename = 'spec/tmp/temp.png'
			
			File.new(filename, 'a')
			
			result_upload = pet.api_upload_image(filename)
			
			expect(result_upload).to_not be false
		end
		
		it 'api_add + api_upload_image(filename) file exist with wrong extension' do 
			id = rand(1_000_000)
			name_current = 'first name'
			
			pet = PetStore::Pet.new(id)
			pet.name = name_current
			
			result_add = pet.api_add
			expect(result_add).to_not be false
			
			filename = 'spec/tmp/temp.txt'
			
			File.new(filename, 'a')
			
			result_upload = pet.api_upload_image(filename)
			
			expect(result_upload).to be false
		end
		
		it 'api_add + api_update + api_get' do 
			name = 'pet_name'+rand(100).to_s
			id = rand(1_000_000)
			status = 'sold'
			tags = [{:id=>1, :name=>'tag_one'}, {:id=>2, :name=>'tag_two'}]
			category_id = rand(1000)
			category = {:id=>category_id, :name=>'category_name'}
			photo_urls = ['some_url1', 'some_url2']
			
			pet = PetStore::Pet.new(id)
			pet.name = name
			pet.status_set(status)
			
			for i in 0..1 do
				pet.tag_add(tags[i][:id], tags[i][:name])
			end
			
			pet.category_set(category[:id], category[:name])
			
			for i in 0..1 do 
				pet.photo_url_add(photo_urls[i])
			end
			
			result_add = pet.api_add
			
			expect(result_add).to_not be false
			expect(pet.id).to eq id
			expect(pet.name).to eq name
			expect(pet.status).to eq status
			expect(pet.tags).to eq tags
			expect(pet.category).to eq category
			expect(pet.photo_urls).to eq photo_urls
			
			# Обновляем данные у объекта
			name_new = 'pet_name_new'+rand(100).to_s
			status_new = 'available'
			tags_new = [{:id=>3, :name=>'tag_3'}, {:id=>4, :name=>'tag_4'}]
			category_id_new = rand(1000)
			category_new = {:id=>category_id_new, :name=>'category_name_new'}
			photo_urls_new = ['some_url3', 'some_url4']
			
			pet.name = name_new
			pet.status_set(status_new)
			
			for i in 0..1 do
				pet.tag_add(tags_new[i][:id], tags_new[i][:name])
			end
			
			pet.category_set(category_new[:id], category_new[:name])
			
			for i in 0..1 do 
				pet.photo_url_add(photo_urls_new[i])
			end
			
			# Проверям что данные корректно изменились в объекте
			expect(pet.id).to eq id
			expect(pet.name).to eq name_new
			expect(pet.status).to eq status_new
			expect(pet.tags).to eq (tags + tags_new)
			expect(pet.category).to eq category_new
			expect(pet.photo_urls).to eq (photo_urls + photo_urls_new)
			
			# Обновляем данные на сервере
			result_update = pet.api_update
			expect(result_update).to_not be false
			
			# Загружаем данные с сервера в новый объект и сравниваем со старым
			pet_2 = PetStore::Pet.new(pet.id)
			result_get = pet_2.api_get
			expect(result_get).to_not be false
			
			expect(pet_2.id).to be pet.id
			expect(pet_2.name).to eq pet.name
			expect(pet_2.status).to eq pet.status
			expect(pet_2.tags).to eq pet.tags
			expect(pet_2.category).to eq pet.category
			expect(pet_2.photo_urls).to eq pet.photo_urls
		end
	end
	
	context 'Тестирование класса ObjectStore' do
		it 'initialize' do 
			type = 'some_type'
			id = rand(100)
			ostore = PetStore::ObjectStore.new(type, id)
			
			expect(ostore.objectid).to eq id
			expect(ostore.type).to eq type
			expect(ostore.content_type).to eq PetStore.content_type
		end
		
		# Content-type по-умолчанию application/json
		it 'content_type_valid? content-type=типу по-умолчанию' do 
			type = 'some_type'
			id = rand(100)
			ostore = PetStore::ObjectStore.new(type, id)
			
			expect(ostore.content_type_valid?).to eq true
		end
		
		it 'content_type_valid? content-type=application/json' do 
			type = 'some_type'
			id = rand(100)
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			expect(ostore.content_type_valid?).to eq true
		end
		
		it 'content_type_valid? content-type=application/xml' do 
			type = 'some_type'
			id = rand(100)
			PetStore.content_type = 'application/xml'
			ostore = PetStore::ObjectStore.new(type, id)
			
			expect(ostore.content_type_valid?).to eq true
		end
		
		it 'content_type_valid? content-type=some_content_type' do 
			type = 'some_type'
			id = rand(100)
			PetStore.content_type = 'some_content_type'
			ostore = PetStore::ObjectStore.new(type, id)
			
			expect(ostore.content_type_valid?).to eq false
		end
		
		it 'type_valid? type=pet' do 
			type = 'pet'
			id = rand(100)
			ostore = PetStore::ObjectStore.new(type, id)
			
			expect(ostore.type_valid?).to eq true
		end
		
		it 'type_valid? type=some_wrong_type' do 
			type = 'some_wrong_type'
			id = rand(100)
			ostore = PetStore::ObjectStore.new(type, id)
			
			expect(ostore.type_valid?).to eq false
		end
		
		it 'can_make_api_request? content_type: valid, type: valid' do 
			type = 'pet'
			id = rand(100)
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			expect(ostore.can_make_api_request?).to eq true
		end
		
		it 'can_make_api_request? content_type: not valid, type: valid' do 
			type = 'pet'
			id = rand(100)
			PetStore.content_type = 'wrong_content_type'
			ostore = PetStore::ObjectStore.new(type, id)
			
			expect(ostore.can_make_api_request?).to eq false
		end
		
		it 'can_make_api_request? content_type: not valid, type: not valid' do 
			type = 'some_wrong_type'
			id = rand(100)
			PetStore.content_type = 'wrong_content_type'
			ostore = PetStore::ObjectStore.new(type, id)
			
			expect(ostore.can_make_api_request?).to eq false
		end
		
		it 'can_make_api_request? content_type: valid, type: not valid' do 
			type = 'some_wrong_type'
			id = rand(100)
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			expect(ostore.can_make_api_request?).to eq false
		end
		
		it 'api_call(method: not valid, path = "some_path", body=nil, form_data_hash=nil, filename=nil)' do 
			type = 'pet'
			id = rand(100)
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			method = 'super_get'
			path = 'some_path'
			
			expect(ostore.api_call(method, path)).to eq false
		end
		
		it 'api_call(method: not valid, path = "", body=nil, form_data_hash=nil, filename=nil)' do 
			type = 'pet'
			id = rand(100)
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			method = 'super_get'
			path = ''
			
			expect(ostore.api_call(method, path)).to eq false
		end
		
		it 'api_call(method: valid, path = "", body=nil, form_data_hash=nil, filename=nil)' do 
			type = 'pet'
			id = rand(100)
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			path = ''
			methods = ['get', 'post', 'put', 'delete']
			methods.each do |method|
				expect(ostore.api_call(method, path)).to eq false
			end
		end
		
		it 'api_call(method: valid, path: incorrect path, body=nil, form_data_hash=nil, filename=nil)' do 
			type = 'pet'
			id = rand(100)
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			path = BASE_URL+type+id.to_s # /petXX
			methods = ['get', 'post', 'put', 'delete']
			methods.each do |method|
				expect(ostore.api_call(method, path)).to eq false
			end
		end
		
		it 'api_call(method: not post, path: correct path, body=nil, form_data_hash is not nil, filename=nil)' do 
			type = 'pet'
			id = rand(100)
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			path = BASE_URL+type+'/'+id.to_s # /pet/XX
			methods = ['get', 'put', 'delete']
			methods.each do |method|
				expect(ostore.api_call(method, path, nil, '')).to eq false
			end
		end
		
		it 'api_call(method: not post, path: correct path, body=nil, form_data_hash=nil, filename is not nil)' do 
			type = 'pet'
			id = rand(100)
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			path = BASE_URL+type+'/'+id.to_s # /pet/XX
			methods = ['get', 'put', 'delete']
			methods.each do |method|
				expect(ostore.api_call(method, path, nil, nil, '')).to eq false
			end
		end
		
		it 'api_get can_make_api_request=false' do 
			type = 'wrong_type'
			id = rand(100)
			
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			result = ostore.api_get
			expect(result).to be false
		end
		
		it 'api_add(body) can_make_api_request=false' do 
			type = 'wrong_type'
			id = rand(100)
			body = ''
			
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			result = ostore.api_add(body)
			expect(result).to be false
		end
		
		it 'api_update(body) can_make_api_request=false' do 
			type = 'wrong_type'
			id = rand(100)
			body = ''
			
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			result = ostore.api_update(body)
			expect(result).to be false
		end
		
		it 'api_find_by_status(status) can_make_api_request=false' do 
			type = 'wrong_type'
			id = rand(100)
			status = ''
			
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			result = ostore.api_find_by_status(status)
			expect(result).to be false
		end
		
		it 'api_delete can_make_api_request=false' do 
			type = 'wrong_type'
			id = rand(100)
			
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			result = ostore.api_delete
			expect(result).to be false
		end
		
		it 'api_update_name_status(name, status) can_make_api_request=false' do 
			type = 'wrong_type'
			id = rand(100)
			name, status = '', ''
			
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			result = ostore.api_update_name_status(name, status)
			expect(result).to be false
		end
		
		it 'api_upload_image(filename) can_make_api_request=false' do 
			type = 'wrong_type'
			id = rand(100)
			filename = ''
			
			PetStore.content_type = 'application/json'
			ostore = PetStore::ObjectStore.new(type, id)
			
			result = ostore.api_upload_image(filename)
			expect(result).to be false
		end
	end
end
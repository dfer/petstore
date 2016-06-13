## Тестовое задание "Разработка клиента Ruby для демо-api Petstore"

Описание задания можно посмотреть здесь - https://dl.dropboxusercontent.com/u/210713/test_ruby.pdf

Использовались Ruby 2.3.0 и gem json 1.8.3

## Комментарии к выполненному заданию
* Клиент разработан с учетом требования, что перечень сущностей может быть расширен. Для расширения достаточно будет добавить класс по типу класса Pet. Вся работа с API реализована в родительском (по отношению к Pet) классе ObjectStore.
* В описании задания мало требований, поэтому это мне пришлось принять как должное:
    * В клиенте реализовано самое простое логирование в файл.
    * Клиент не работает по ssl с API. Но это достаточно легко реализовать, внеся изменения в ObjectStore.api_call
    * В клиенте не проверяются ссылки photoUrls на валидность. Но такую проверку можно легко добавить с помощью регулярного выражения.
    * В клиенте не реализован вызов API /pet/fingByTags - так как он помечен как устаревший.
    * В клиенте не используется AccessToken.
    * В описании API указано, что оно работает c json и xml. В клиенте реализована работа только по json. Я не стал добавлять парсер и генератор xml. Но в коде учтено что может быть 2 представления данных, и работу по xml можно добавить в случае необходимости.
    * Для объектов Pet не проверяется уникальность тегов и ссылок на фотографии.

## Установка 
    git clone https://github.com/dfer/petstore.git 
    cd petstore
    gem install ./petstore-0.0.1.gem

## Запуск тестов
    cd petstore
    run rspec --init
    rspec spec/petstore_spec.rb

## Примеры использования
    require 'petstore'

    # Установим в каком формате взаимодействовать с API
    PetStore.content_type = 'application/json'
    # Включение логирования
    PetStore.log = true 
    
    # Создание Pet. Так как id-необязательный параметр, то объект Pet можно создать двумя способами:
    pet_1 = PetStore::Pet.new
    pet_2 = PetStore::Pet.new(12345678)

    # Присвоение значений Pet
    pet = PetStore::Pet.new(12345678)
    pet.name = 'Pupsik'
    # Статус - необязательный параметр
    pet.status_set('available')
    
    # Три варианта установки категории
    # Напомню, что категории может не быть, либо быть одна
    # Установка только category.id
    pet.category_set(123)
    # Установка только catagory.name
    pet.category_set(nil, 'category_name')
    # Установка обоих параметров
    pet.category_set(123, 'catagory_name')

    # Установка тегов
    # Тегов может не быть, либо быть любое кол-во
    # Тег может иметь либо tag.id, либо tag.name. Либо сразу оба параметра
    # Установка только tag.id
    pet.tag_add(123)
    # Установка только tag.name
    pet.tag_add(nil, 'tag_name')
    # Установка обоих параметров
    pet.tag_add(1, 'tag_one')
    pet.tag_add(2, 'tag_two')

    # Добавление ссылок на фотографии
    # Ссылок может не быть, либо быть любое кол-во
    pet.photo_url_add('some_url')

    # ------------- Работа с API --------------
    # 1. Получение объекта с сервера по его id.
    # GET /pet/{petId}
    pet = PetStore::Pet.new(123)
    pet.api_get

    # 2. Удаление объекта на сервере
    # DELETE /pet/{petId}
    pet = PetStore::Pet.new(123)
    pet.api_delete

    # 3. Добавление объекта на сервер
    # POST /pet
    pet = PetStore::Pet.new
    pet.name = 'Tuzik'
    pet.api_add

    # 4. Обновление данных об объекте на сервере
    # PUT /pet
    pet = PetStore::Pet.new(123)
    pet.name = 'New name'
    pet.api_update

    # 5. Поиск объектов по их статусу
    # GET /pet/findByStatus
    pet = PetStore::Pet.new
    array = pet.api_find_by_status('sold')
    array.each do |pet_json|
        pet_from_server = PetStore::Pet.new
        pet_from_server.read_json(pet_json)
    end

    # 6. Обновление объекта на сервере. Под обновление понимается изменение имени и статуса
    # POST /pet/{petId}
    pet = PetStore::Pet.new(123)
    pet.api_update_name_status('New_name', 'New_status')
    pet.api_update_name_status('New_name')
    pet.api_update_name_status(nil, 'New_status')

    # 7. Загрузка файла на сервер с картинкой объекта
    # POST /pet/{petId}/uploadImage
    pet = PetStore::Pet.new(123)
    pet.api_upload_image(filename) # filename - путь к файлу
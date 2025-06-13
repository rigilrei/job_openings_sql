# job_openings_sql

База данных "Парсер вакансий и мероприятий"
Задача:
База данных разработана для хранения и анализа данных, полученных при парсинге вакансий, мероприятий и постов компаний. Позволяет систематизировать информацию о компаниях, их активностях (мероприятия, вакансии, посты) и категоризировать контент для удобного поиска и анализа.
Сущности и атрибуты:
Список таблиц:
•	Company — информация о компаниях
•	Event — информация о мероприятиях
•	JobOpening — информация о вакансиях
•	Post — записи (посты), полученные при парсинге
•	Category — категории для классификации контента
•	PostCategory — связующая таблица: пост-категория (многие ко многим)
•	CompanySocial — социальные сети компаний (связь 1 к 1)
Таблицы
Company — Компании
•	id (PK) — ID компании
•	name — Название компании (NOT NULL)
•	website — Веб-сайт (CHECK (формат URL), может быть NULL)
•	description — Описание компании (может быть NULL)
•	founded_year — Год основания (может быть NULL, CHECK (год > 1900))
•	employee_count — Количество сотрудников (может быть NULL, CHECK (>=0))
•	created_at — Дата добавления (DEFAULT CURRENT_TIMESTAMP)
CompanySocial — Социальные сети компаний (1 к 1)
•	company_id (PK+FK) — ID компании (FOREIGN KEY → Company(id), ON DELETE CASCADE)
•	vk_page — Страница VK (может быть NULL, UNIQUE)
•	telegram — Telegram (может быть NULL, UNIQUE)
•	linkedin — LinkedIn (может быть NULL, UNIQUE)
•	updated_at — Дата обновления (DEFAULT CURRENT_TIMESTAMP)
Event — Мероприятия
•	id (PK) — ID мероприятия
•	company_id (FK) — Организатор (FOREIGN KEY → Company(id), ON DELETE SET NULL)
•	title — Название мероприятия (NOT NULL)
•	description — Описание (может быть NULL)
•	event_date — Дата проведения (может быть NULL)
•	location — Место проведения (может быть NULL)
•	is_online — Онлайн мероприятие (DEFAULT FALSE)
•	registration_required — Требуется регистрация (DEFAULT FALSE)
•	created_at — Дата добавления (DEFAULT CURRENT_TIMESTAMP)
JobOpening — Вакансии
•	id (PK) — ID вакансии
•	company_id (FK) — Компания (FOREIGN KEY → Company(id), ON DELETE CASCADE)
•	position — Должность (NOT NULL)
•	description — Описание (может быть NULL)
•	requirements — Требования (может быть NULL)
•	salary_from — Зарплата от (может быть NULL, CHECK (>=0))
•	salary_to — Зарплата до (может быть NULL, CHECK (>= salary_from))
•	employment_type — Тип занятости (может быть NULL)
•	is_remote — Удалённая работа (DEFAULT FALSE)
•	posted_at — Дата размещения (DEFAULT CURRENT_TIMESTAMP)
•	expires_at — Дата окончания (может быть NULL)
Post — Посты
•	id (PK) — ID поста
•	company_id (FK) — Компания (FOREIGN KEY → Company(id), ON DELETE SET NULL)
•	text — Текст поста (может быть NULL)
•	post_url — Ссылка на пост (NOT NULL, UNIQUE)
•	published_at — Дата публикации (NOT NULL)
•	likes_count — Количество лайков (DEFAULT 0, CHECK (>=0))
•	views_count — Количество просмотров (DEFAULT 0, CHECK (>=0))
•	comments_count — Количество комментариев (DEFAULT 0, CHECK (>=0))
•	reposts_count — Количество репостов (DEFAULT 0, CHECK (>=0))
•	parsed_at — Дата парсинга (DEFAULT CURRENT_TIMESTAMP)
Category — Категории
•	id (PK) — ID категории
•	name — Название категории (NOT NULL, UNIQUE)
•	description — Описание (может быть NULL)
•	created_at — Дата создания (DEFAULT CURRENT_TIMESTAMP)
PostCategory — Категории постов (многие ко многим)
•	post_id (PK+FK) — ID поста (FOREIGN KEY → Post(id), ON DELETE CASCADE)
•	category_id (PK+FK) — ID категории (FOREIGN KEY → Category(id), ON DELETE CASCADE)
Связи в схеме
Один ко многим (1:N)
•	Company → Post — Одна компания может иметь много постов
•	Company → Event — Одна компания может организовывать много мероприятий
•	Company → JobOpening — Одна компания может размещать много вакансий
Многие ко многим (M:N)
•	Post ↔ Category (через PostCategory) — Один пост может относиться к нескольким категориям, и одна категория может содержать много постов
Один к одному (1:1)
•	Company 1 ↔ 1 CompanySocial — Одна компания имеет только одну запись с социальными сетями, и каждая запись относится к одной компании



--
-- PostgreSQL database dump
--

--
-- SET statements
--
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Tablespace and access method settings
--
SET default_tablespace = '';
SET default_table_access_method = heap;

--
-- Drop tables (safe to run multiple times)
--
DROP TABLE IF EXISTS public."PostCategory" CASCADE;
DROP TABLE IF EXISTS public."Post" CASCADE;
DROP TABLE IF EXISTS public."Category" CASCADE;
DROP TABLE IF EXISTS public."JobOpening" CASCADE;
DROP TABLE IF EXISTS public."Event" CASCADE;
DROP TABLE IF EXISTS public."CompanySocial" CASCADE;
DROP TABLE IF EXISTS public."Company" CASCADE;

--
-- Name: Company; Type: TABLE; Schema: public; Owner: postgres
--
CREATE TABLE public."Company" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    website text,
    description text,
    founded_year integer,
    employee_count integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Company_founded_year_check" CHECK (founded_year > 1840),
    CONSTRAINT "Company_employee_count_check" CHECK (employee_count >= 0),
    CONSTRAINT "Company_website_check" CHECK (website IS NULL OR website ~* '^https?://.*$'),
    PRIMARY KEY (id)
);

--
-- Name: Company_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--
CREATE SEQUENCE public."Company_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public."Company_id_seq" OWNED BY public."Company".id;

--
-- Name: Company id; Type: DEFAULT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public."Company"
    ALTER COLUMN id SET DEFAULT nextval('public."Company_id_seq"'::regclass);

--
-- Name: CompanySocial; Type: TABLE; Schema: public; Owner: postgres
--
CREATE TABLE public."CompanySocial" (
    company_id integer NOT NULL,
    vk_page text,
    telegram text,
    linkedin text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (company_id),
    FOREIGN KEY (company_id) REFERENCES public."Company"(id) ON DELETE CASCADE
);

--
-- Name: Event; Type: TABLE; Schema: public; Owner: postgres
--
CREATE TABLE public."Event" (
    id integer NOT NULL,
    company_id integer,
    title character varying(255) NOT NULL,
    description text,
    event_date timestamp without time zone,
    location text,
    is_online boolean DEFAULT false,
    registration_required boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (company_id) REFERENCES public."Company"(id) ON DELETE SET NULL
);

--
-- Name: Event_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--
CREATE SEQUENCE public."Event_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public."Event_id_seq" OWNED BY public."Event".id;

--
-- Name: Event id; Type: DEFAULT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public."Event"
    ALTER COLUMN id SET DEFAULT nextval('public."Event_id_seq"'::regclass);

--
-- Name: JobOpening; Type: TABLE; Schema: public; Owner: postgres
--
CREATE TABLE public."JobOpening" (
    id integer NOT NULL,
    company_id integer NOT NULL,
    position character varying(255) NOT NULL,
    description text,
    requirements text,
    salary_from numeric,
    salary_to numeric,
    employment_type character varying(100),
    is_remote boolean DEFAULT false,
    posted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    expires_at timestamp without time zone,
    PRIMARY KEY (id),
    FOREIGN KEY (company_id) REFERENCES public."Company"(id) ON DELETE CASCADE
);

--
-- Name: JobOpening_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--
CREATE SEQUENCE public."JobOpening_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public."JobOpening_id_seq" OWNED BY public."JobOpening".id;

--
-- Name: JobOpening id; Type: DEFAULT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public."JobOpening"
    ALTER COLUMN id SET DEFAULT nextval('public."JobOpening_id_seq"'::regclass);

--
-- Name: Post; Type: TABLE; Schema: public; Owner: postgres
--
CREATE TABLE public."Post" (
    id integer NOT NULL,
    company_id integer,
    text text,
    post_url text NOT NULL,
    published_at timestamp without time zone NOT NULL,
    likes_count integer DEFAULT 0,
    views_count integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    reposts_count integer DEFAULT 0,
    parsed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (company_id) REFERENCES public."Company"(id) ON DELETE SET NULL
);

--
-- Name: Post_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--
CREATE SEQUENCE public."Post_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public."Post_id_seq" OWNED BY public."Post".id;

--
-- Name: Post id; Type: DEFAULT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public."Post"
    ALTER COLUMN id SET DEFAULT nextval('public."Post_id_seq"'::regclass);

--
-- Name: Category; Type: TABLE; Schema: public; Owner: postgres
--
CREATE TABLE public."Category" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

--
-- Name: Category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--
CREATE SEQUENCE public."Category_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public."Category_id_seq" OWNED BY public."Category".id;

--
-- Name: Category id; Type: DEFAULT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public."Category"
    ALTER COLUMN id SET DEFAULT nextval('public."Category_id_seq"'::regclass);

--
-- Name: PostCategory; Type: TABLE; Schema: public; Owner: postgres
--
CREATE TABLE public."PostCategory" (
    post_id integer NOT NULL,
    category_id integer NOT NULL,
    PRIMARY KEY (post_id, category_id),
    FOREIGN KEY (post_id) REFERENCES public."Post"(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES public."Category"(id) ON DELETE CASCADE
);

--
-- Data for Name: Company; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO public."Company" (id, name, website, description, founded_year, employee_count, created_at) VALUES
(1, 'Совкомбанк', 'https://sovcombank.ru', 'Крупнейший универсальный банк России', 1990, 25000, NOW()),
(2, 'Росатом', 'https://rosatom.ru', 'Госкорпорация по атомной энергии', 2007, 280000, NOW()),
(3, 'ВТБ', 'https://vtb.ru', 'Второй по величине банк России', 1990, 60000, NOW()),
(4, 'Сбер', 'https://sber.ru', 'Крупнейший банк России', 1841, 320000, NOW()),
(5, 'Хабр', 'https://habr.com', 'Крупнейшая IT-платформа', 2006, 500, NOW());

--
-- Data for Name: CompanySocial; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO public."CompanySocial" (company_id, vk_page, telegram, linkedin, updated_at) VALUES
(1, 'https://vk.com/sovcombank_career', 'https://t.me/sovcombank', 'https://linkedin.com/company/sovcombank', NOW()),
(2, 'https://vk.com/rosatom', 'https://t.me/rosatom_official', 'https://linkedin.com/company/rosatom', NOW()),
(3, 'https://vk.com/vtb_career', 'https://t.me/vtb_news', 'https://linkedin.com/company/vtb-bank', NOW()),
(4, 'https://vk.com/sberbank', 'https://t.me/sberbank', 'https://linkedin.com/company/sberbank', NOW()),
(5, 'https://vk.com/habr_career', NULL, 'https://linkedin.com/company/habr', NOW());

--
-- Data for Name: Event; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO public."Event" (id, company_id, title, description, event_date, location, is_online, registration_required, created_at) VALUES
(1, 1, 'День открытых дверей', 'Знакомство с банком и вакансиями', '2023-11-15 10:00:00', 'Москва', false, true, NOW()),
(2, 2, 'Технологический форум', 'Обсуждение новых технологий в атомной отрасли', '2023-12-05 09:00:00', 'Сочи', true, true, NOW());

--
-- Data for Name: JobOpening; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO public."JobOpening" (id, company_id, position, description, requirements, salary_from, salary_to, employment_type, is_remote, posted_at, expires_at) VALUES
(1, 1, 'Разработчик Java', 'Разработка банковских приложений', 'Опыт от 3 лет, знание Spring', 150000, 250000, 'Full-time', true, NOW(), '2023-12-31'),
(2, 2, 'Инженер-физик', 'Работа на атомных станциях', 'Высшее образование, готовность к переезду', 120000, 180000, 'Full-time', false, NOW(), '2023-12-15');

--
-- Data for Name: Post; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO public."Post" (id, company_id, text, post_url, published_at, likes_count, views_count, comments_count, reposts_count, parsed_at) VALUES
(1, 1, 'Совкомбанк ищет талантливых разработчиков!', 'https://vk.com/sovcombank_career?w=wall-123456_789', '2023-10-01 12:00:00', 150, 1200, 25, 10, NOW()),
(2, 2, 'Росатом приглашает на форум', 'https://vk.com/rosatom?w=wall-654321_123', '2023-10-05 14:30:00', 200, 1500, 30, 15, NOW());

--
-- Data for Name: Category; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO public."Category" (id, name, description, created_at) VALUES
(1, 'Вакансии', 'Посты о вакансиях', NOW()),
(2, 'Мероприятия', 'Посты о мероприятиях', NOW());

--
-- Data for Name: PostCategory; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO public."PostCategory" (post_id, category_id) VALUES
(1, 1),
(2, 2);

--
-- Name: Company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--
SELECT pg_catalog.setval('public."Company_id_seq"', (SELECT MAX(id) FROM public."Company"), true);

--
-- Name: Event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--
SELECT pg_catalog.setval('public."Event_id_seq"', (SELECT MAX(id) FROM public."Event"), true);

--
-- Name: JobOpening_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--
SELECT pg_catalog.setval('public."JobOpening_id_seq"', (SELECT MAX(id) FROM public."JobOpening"), true);

--
-- Name: Post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--
SELECT pg_catalog.setval('public."Post_id_seq"', (SELECT MAX(id) FROM public."Post"), true);

--
-- Name: Category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--
SELECT pg_catalog.setval('public."Category_id_seq"', (SELECT MAX(id) FROM public."Category"), true);

--
-- PostgreSQL database dump complete
--

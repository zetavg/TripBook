--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_borrow_demands; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE book_borrow_demands (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_id integer NOT NULL,
    book_isbn character varying NOT NULL,
    state character varying(32) NOT NULL,
    borrowing_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_borrowing_invitation_invitation_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE book_borrowing_invitation_invitation_users (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    borrowing_invitation_id uuid NOT NULL,
    user_id integer,
    message text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_borrowing_invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE book_borrowing_invitations (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    holding_id uuid NOT NULL,
    borrowing_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_borrowing_trips; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE book_borrowing_trips (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    book_id uuid NOT NULL,
    state character varying(32),
    max_single_durition_days integer,
    max_durition_days integer,
    max_borrowings_count integer,
    borrowings_count integer DEFAULT 0 NOT NULL,
    ended_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_borrowings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE book_borrowings (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    borrowing_trip_id uuid NOT NULL,
    holding_id uuid NOT NULL,
    ended_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_holdings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE book_holdings (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_id integer NOT NULL,
    book_id uuid NOT NULL,
    previous_holding_id uuid,
    state character varying(32) NOT NULL,
    ready_for_released_at timestamp without time zone,
    released_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_stories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE book_stories (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_id integer NOT NULL,
    book_isbn character varying NOT NULL,
    published_at timestamp without time zone,
    privacy_level integer DEFAULT 0 NOT NULL,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: books; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE books (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    isbn character varying,
    owner_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_holding_stories; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW book_holding_stories AS
 SELECT book_holdings.id AS holding_id,
    book_holdings.previous_holding_id,
    book_holdings.state AS holding_state,
    book_holdings.book_id,
    books.owner_id AS book_owner_id,
    book_stories.id,
    book_stories.user_id,
    book_stories.book_isbn,
    book_stories.published_at,
    book_stories.privacy_level,
    book_stories.content,
    book_stories.created_at,
    book_stories.updated_at
   FROM ((book_holdings
     JOIN books ON ((book_holdings.book_id = books.id)))
     JOIN book_stories ON ((((book_stories.book_isbn)::text = (books.isbn)::text) AND (book_stories.user_id = book_holdings.user_id))));


--
-- Name: book_info_cover_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE book_info_cover_images (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    isbn character varying(32),
    image character varying,
    width integer,
    height integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_infos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE book_infos (
    isbn character varying(32) NOT NULL,
    isbn_10 character varying(32),
    isbn_13 character varying(32),
    name character varying(128) NOT NULL,
    language character varying(64),
    author character varying(64),
    publisher character varying(64),
    publish_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_summaries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE book_summaries (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_id integer NOT NULL,
    book_isbn character varying NOT NULL,
    published_at timestamp without time zone,
    privacy_level integer DEFAULT 0 NOT NULL,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: user_cover_photos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_cover_photos (
    id integer NOT NULL,
    user_id integer,
    image character varying,
    secure_token character varying,
    width integer,
    height integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_cover_photos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_cover_photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_cover_photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_cover_photos_id_seq OWNED BY user_cover_photos.id;


--
-- Name: user_facebook_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_facebook_accounts (
    id integer NOT NULL,
    user_id integer,
    facebook_id character varying NOT NULL,
    email character varying,
    name character varying,
    picture_url text,
    cover_photo_url text,
    access_token text NOT NULL,
    access_token_expires_at integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_facebook_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_facebook_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_facebook_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_facebook_accounts_id_seq OWNED BY user_facebook_accounts.id;


--
-- Name: user_pictures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_pictures (
    id integer NOT NULL,
    user_id integer,
    image character varying,
    secure_token character varying,
    width integer,
    height integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_pictures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_pictures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_pictures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_pictures_id_seq OWNED BY user_pictures.id;


--
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_profiles (
    id integer NOT NULL,
    user_id integer,
    gender smallint,
    birthday_year bigint,
    birthday_month smallint,
    birthday_day smallint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_profiles_id_seq OWNED BY user_profiles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    mobile character varying(32),
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    locale character varying(8),
    username character varying(64),
    name character varying(64) NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    mobile_confirmation_token character varying,
    mobile_confirmed_at timestamp without time zone,
    mobile_confirmation_sent_at timestamp without time zone,
    unconfirmed_mobile character varying(32),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: user_cover_photos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_cover_photos ALTER COLUMN id SET DEFAULT nextval('user_cover_photos_id_seq'::regclass);


--
-- Name: user_facebook_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_facebook_accounts ALTER COLUMN id SET DEFAULT nextval('user_facebook_accounts_id_seq'::regclass);


--
-- Name: user_pictures id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_pictures ALTER COLUMN id SET DEFAULT nextval('user_pictures_id_seq'::regclass);


--
-- Name: user_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_profiles ALTER COLUMN id SET DEFAULT nextval('user_profiles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: book_borrow_demands book_borrow_demands_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_borrow_demands
    ADD CONSTRAINT book_borrow_demands_pkey PRIMARY KEY (id);


--
-- Name: book_borrowing_invitation_invitation_users book_borrowing_invitation_invitation_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_borrowing_invitation_invitation_users
    ADD CONSTRAINT book_borrowing_invitation_invitation_users_pkey PRIMARY KEY (id);


--
-- Name: book_borrowing_invitations book_borrowing_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_borrowing_invitations
    ADD CONSTRAINT book_borrowing_invitations_pkey PRIMARY KEY (id);


--
-- Name: book_borrowing_trips book_borrowing_trips_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_borrowing_trips
    ADD CONSTRAINT book_borrowing_trips_pkey PRIMARY KEY (id);


--
-- Name: book_borrowings book_borrowings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_borrowings
    ADD CONSTRAINT book_borrowings_pkey PRIMARY KEY (id);


--
-- Name: book_holdings book_holdings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_holdings
    ADD CONSTRAINT book_holdings_pkey PRIMARY KEY (id);


--
-- Name: book_info_cover_images book_info_cover_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_info_cover_images
    ADD CONSTRAINT book_info_cover_images_pkey PRIMARY KEY (id);


--
-- Name: book_infos book_infos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_infos
    ADD CONSTRAINT book_infos_pkey PRIMARY KEY (isbn);


--
-- Name: book_stories book_stories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_stories
    ADD CONSTRAINT book_stories_pkey PRIMARY KEY (id);


--
-- Name: book_summaries book_summaries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_summaries
    ADD CONSTRAINT book_summaries_pkey PRIMARY KEY (id);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: user_cover_photos user_cover_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_cover_photos
    ADD CONSTRAINT user_cover_photos_pkey PRIMARY KEY (id);


--
-- Name: user_facebook_accounts user_facebook_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_facebook_accounts
    ADD CONSTRAINT user_facebook_accounts_pkey PRIMARY KEY (id);


--
-- Name: user_pictures user_pictures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_pictures
    ADD CONSTRAINT user_pictures_pkey PRIMARY KEY (id);


--
-- Name: user_profiles user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_book_borrow_demands_on_borrowing_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_borrow_demands_on_borrowing_id ON book_borrow_demands USING btree (borrowing_id);


--
-- Name: index_book_borrow_demands_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_borrow_demands_on_user_id ON book_borrow_demands USING btree (user_id);


--
-- Name: index_book_borrowing_invitation_invitation_users_on_b_o_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_borrowing_invitation_invitation_users_on_b_o_id ON book_borrowing_invitation_invitation_users USING btree (borrowing_invitation_id);


--
-- Name: index_book_borrowing_invitation_invitation_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_borrowing_invitation_invitation_users_on_user_id ON book_borrowing_invitation_invitation_users USING btree (user_id);


--
-- Name: index_book_borrowing_invitations_on_borrowing_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_borrowing_invitations_on_borrowing_id ON book_borrowing_invitations USING btree (borrowing_id);


--
-- Name: index_book_borrowing_invitations_on_holding_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_borrowing_invitations_on_holding_id ON book_borrowing_invitations USING btree (holding_id);


--
-- Name: index_book_borrowing_trips_on_book_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_borrowing_trips_on_book_id ON book_borrowing_trips USING btree (book_id);


--
-- Name: index_book_borrowing_trips_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_borrowing_trips_on_state ON book_borrowing_trips USING btree (state);


--
-- Name: index_book_borrowings_on_borrowing_trip_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_borrowings_on_borrowing_trip_id ON book_borrowings USING btree (borrowing_trip_id);


--
-- Name: index_book_borrowings_on_holding_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_borrowings_on_holding_id ON book_borrowings USING btree (holding_id);


--
-- Name: index_book_holdings_on_book_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_holdings_on_book_id ON book_holdings USING btree (book_id);


--
-- Name: index_book_holdings_on_previous_holding_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_holdings_on_previous_holding_id ON book_holdings USING btree (previous_holding_id);


--
-- Name: index_book_holdings_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_holdings_on_state ON book_holdings USING btree (state);


--
-- Name: index_book_holdings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_holdings_on_user_id ON book_holdings USING btree (user_id);


--
-- Name: index_book_info_cover_images_on_isbn; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_info_cover_images_on_isbn ON book_info_cover_images USING btree (isbn);


--
-- Name: index_book_infos_on_isbn; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_book_infos_on_isbn ON book_infos USING btree (isbn);


--
-- Name: index_book_infos_on_isbn_10; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_book_infos_on_isbn_10 ON book_infos USING btree (isbn_10);


--
-- Name: index_book_infos_on_isbn_13; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_book_infos_on_isbn_13 ON book_infos USING btree (isbn_13);


--
-- Name: index_book_stories_on_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_stories_on_published_at ON book_stories USING btree (published_at);


--
-- Name: index_book_stories_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_stories_on_user_id ON book_stories USING btree (user_id);


--
-- Name: index_book_summaries_on_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_summaries_on_published_at ON book_summaries USING btree (published_at);


--
-- Name: index_book_summaries_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_summaries_on_user_id ON book_summaries USING btree (user_id);


--
-- Name: index_books_on_isbn; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_books_on_isbn ON books USING btree (isbn);


--
-- Name: index_books_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_books_on_owner_id ON books USING btree (owner_id);


--
-- Name: index_user_cover_photos_on_secure_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_cover_photos_on_secure_token ON user_cover_photos USING btree (secure_token);


--
-- Name: index_user_cover_photos_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_cover_photos_on_user_id ON user_cover_photos USING btree (user_id);


--
-- Name: index_user_facebook_accounts_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_facebook_accounts_on_email ON user_facebook_accounts USING btree (email);


--
-- Name: index_user_facebook_accounts_on_facebook_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_facebook_accounts_on_facebook_id ON user_facebook_accounts USING btree (facebook_id);


--
-- Name: index_user_facebook_accounts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_facebook_accounts_on_user_id ON user_facebook_accounts USING btree (user_id);


--
-- Name: index_user_pictures_on_secure_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_pictures_on_secure_token ON user_pictures USING btree (secure_token);


--
-- Name: index_user_pictures_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_pictures_on_user_id ON user_pictures USING btree (user_id);


--
-- Name: index_user_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_profiles_on_user_id ON user_profiles USING btree (user_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: book_stories fk_rails_0699fdcfff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_stories
    ADD CONSTRAINT fk_rails_0699fdcfff FOREIGN KEY (book_isbn) REFERENCES book_infos(isbn) ON DELETE RESTRICT;


--
-- Name: books fk_rails_1b1e135573; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY books
    ADD CONSTRAINT fk_rails_1b1e135573 FOREIGN KEY (owner_id) REFERENCES users(id);


--
-- Name: book_borrowing_invitations fk_rails_25e71b8cd3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_borrowing_invitations
    ADD CONSTRAINT fk_rails_25e71b8cd3 FOREIGN KEY (borrowing_id) REFERENCES book_borrowings(id);


--
-- Name: book_borrowing_invitation_invitation_users fk_rails_2ce47b00cd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_borrowing_invitation_invitation_users
    ADD CONSTRAINT fk_rails_2ce47b00cd FOREIGN KEY (borrowing_invitation_id) REFERENCES book_borrowing_invitations(id);


--
-- Name: book_stories fk_rails_2e62e355a0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_stories
    ADD CONSTRAINT fk_rails_2e62e355a0 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: user_pictures fk_rails_30d398c5a4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_pictures
    ADD CONSTRAINT fk_rails_30d398c5a4 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: book_borrow_demands fk_rails_37ed1977ba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_borrow_demands
    ADD CONSTRAINT fk_rails_37ed1977ba FOREIGN KEY (borrowing_id) REFERENCES book_borrowings(id);


--
-- Name: book_borrowing_invitation_invitation_users fk_rails_47e5c973f2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_borrowing_invitation_invitation_users
    ADD CONSTRAINT fk_rails_47e5c973f2 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: books fk_rails_6cd736403e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY books
    ADD CONSTRAINT fk_rails_6cd736403e FOREIGN KEY (isbn) REFERENCES book_infos(isbn) ON DELETE RESTRICT;


--
-- Name: user_facebook_accounts fk_rails_6e246a09f3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_facebook_accounts
    ADD CONSTRAINT fk_rails_6e246a09f3 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: book_holdings fk_rails_75ef9f920b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_holdings
    ADD CONSTRAINT fk_rails_75ef9f920b FOREIGN KEY (previous_holding_id) REFERENCES book_holdings(id);


--
-- Name: book_borrowings fk_rails_7b2a167bbd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_borrowings
    ADD CONSTRAINT fk_rails_7b2a167bbd FOREIGN KEY (borrowing_trip_id) REFERENCES book_borrowing_trips(id);


--
-- Name: book_summaries fk_rails_824719b63b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_summaries
    ADD CONSTRAINT fk_rails_824719b63b FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: book_info_cover_images fk_rails_829d9b9504; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_info_cover_images
    ADD CONSTRAINT fk_rails_829d9b9504 FOREIGN KEY (isbn) REFERENCES book_infos(isbn) ON DELETE SET NULL;


--
-- Name: book_borrowing_trips fk_rails_8724753a26; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_borrowing_trips
    ADD CONSTRAINT fk_rails_8724753a26 FOREIGN KEY (book_id) REFERENCES books(id);


--
-- Name: user_profiles fk_rails_87a6352e58; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_profiles
    ADD CONSTRAINT fk_rails_87a6352e58 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: book_holdings fk_rails_88e83c63e4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_holdings
    ADD CONSTRAINT fk_rails_88e83c63e4 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: user_cover_photos fk_rails_bc716c1313; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_cover_photos
    ADD CONSTRAINT fk_rails_bc716c1313 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: book_borrow_demands fk_rails_c431fa9007; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_borrow_demands
    ADD CONSTRAINT fk_rails_c431fa9007 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: book_borrowings fk_rails_d5c7a92c6f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_borrowings
    ADD CONSTRAINT fk_rails_d5c7a92c6f FOREIGN KEY (holding_id) REFERENCES book_holdings(id);


--
-- Name: book_borrowing_invitations fk_rails_deb81ce894; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_borrowing_invitations
    ADD CONSTRAINT fk_rails_deb81ce894 FOREIGN KEY (holding_id) REFERENCES book_holdings(id);


--
-- Name: book_holdings fk_rails_f151dbf562; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_holdings
    ADD CONSTRAINT fk_rails_f151dbf562 FOREIGN KEY (book_id) REFERENCES books(id);


--
-- Name: book_summaries fk_rails_f3623c029c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_summaries
    ADD CONSTRAINT fk_rails_f3623c029c FOREIGN KEY (book_isbn) REFERENCES book_infos(isbn) ON DELETE RESTRICT;


--
-- Name: book_borrow_demands fk_rails_f49f571546; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_borrow_demands
    ADD CONSTRAINT fk_rails_f49f571546 FOREIGN KEY (book_isbn) REFERENCES book_infos(isbn) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES
('20170212142932'),
('20170217033201'),
('20170217075002'),
('20170217080642'),
('20170217083849'),
('20170218172916'),
('20170218181530'),
('20170219035433'),
('20170219072412'),
('20170222085004'),
('20170222085426'),
('20170314080224'),
('20170314102140'),
('20170316041313'),
('20170321102027'),
('20170321135208'),
('20170321143015');



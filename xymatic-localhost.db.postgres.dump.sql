PGDMP                          y            xymatic-localhost    13.0 (Debian 13.0-1.pgdg100+1)    13.0 (Debian 13.0-1.pgdg100+1) 4    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16384    xymatic-localhost    DATABASE     g   CREATE DATABASE "xymatic-localhost" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';
 #   DROP DATABASE "xymatic-localhost";
                xymatic-user    false            �           1247    24749 	   eattitude    TYPE     D   CREATE TYPE public.eattitude AS ENUM (
    'LIKE',
    'DISLIKE'
);
    DROP TYPE public.eattitude;
       public          xymatic-user    false            �           1247    24678    erole    TYPE     >   CREATE TYPE public.erole AS ENUM (
    'USER',
    'ADMIN'
);
    DROP TYPE public.erole;
       public          xymatic-user    false                       1247    16386    estatus    TYPE     `   CREATE TYPE public.estatus AS ENUM (
    'public',
    'closed',
    'deleted',
    'active'
);
    DROP TYPE public.estatus;
       public          xymatic-user    false            �           1247    24756    table_count    TYPE     K   CREATE TYPE public.table_count AS (
	table_name text,
	num_rows integer
);
    DROP TYPE public.table_count;
       public          xymatic-user    false            �            1255    24757    count_em_all()    FUNCTION       CREATE FUNCTION public.count_em_all() RETURNS SETOF public.table_count
    LANGUAGE plpgsql
    AS $$
DECLARE 
    the_count RECORD; 
    t_name RECORD; 
    r table_count%ROWTYPE; 

BEGIN
    FOR t_name IN 
        SELECT 
            c.relname
        FROM
            pg_catalog.pg_class c LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE 
            c.relkind = 'r'
            AND n.nspname = 'public' 
        ORDER BY 1 
        LOOP
            FOR the_count IN EXECUTE 'SELECT COUNT(*) AS "count" FROM ' || t_name.relname 
            LOOP 
            END LOOP; 

            r.table_name := t_name.relname; 
            r.num_rows := the_count.count; 
            RETURN NEXT r; 
        END LOOP; 
        RETURN; 
END;
$$;
 %   DROP FUNCTION public.count_em_all();
       public          xymatic-user    false    674            �            1255    24741    process_xt_impressions()    FUNCTION     �  CREATE FUNCTION public.process_xt_impressions() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin 
 if (TG_OP = 'DELETE') THEN 
 insert into xt_triggers(tg_key, tg_value, tg_operation) values('users', OLD.post || ":" || OLD.author || ":" || OLD.attitude , 'D');
 return old; 
 elseif (TG_OP = 'UPDATE') THEN 
 insert into xt_triggers(tg_key, tg_value, tg_operation) values('users',  NEW.post || ":" || NEW.author || ":" || NEW.attitude, 'U');
 return new;
 elseif (TG_OP = 'INSERT') THEN 
 insert into xt_triggers(tg_key, tg_value, tg_operation) values('users',  NEW.post || ":" || NEW.author || ":" || NEW.attitude, 'I');
 return new;
END IF;
return NULL;
end;
$$;
 /   DROP FUNCTION public.process_xt_impressions();
       public          xymatic-user    false            �            1255    24739    process_xt_plays()    FUNCTION     !  CREATE FUNCTION public.process_xt_plays() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin 
 if (TG_OP = 'DELETE') THEN 
 insert into xt_triggers(tg_key, tg_value, tg_operation) values('plays', OLD.title, 'D');
 return old; 
 elseif (TG_OP = 'UPDATE') THEN 
 insert into xt_triggers(tg_key, tg_value, tg_operation) values('plays', NEW.title, 'U');
 return new;
 elseif (TG_OP = 'INSERT') THEN 
 insert into xt_triggers(tg_key, tg_value, tg_operation) values('plays', NEW.title, 'I');
 return new;
END IF;
return NULL;
end;
$$;
 )   DROP FUNCTION public.process_xt_plays();
       public          xymatic-user    false            �            1255    16598    process_xt_posts()    FUNCTION     w  CREATE FUNCTION public.process_xt_posts() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin 
 if (TG_OP = 'DELETE') THEN 
 insert into xt_triggers(tg_key, tg_value, tg_operation) values('posts', OLD.title || ' post has been deleted', 'D');
 return old; 
 elseif (TG_OP = 'UPDATE') THEN 
 insert into xt_triggers(tg_key, tg_value, tg_operation) values('posts',  NEW.title || ' post has been updated', 'U');
 return new;
 elseif (TG_OP = 'INSERT') THEN 
 insert into xt_triggers(tg_key, tg_value, tg_operation) values('posts',  NEW.title || ' post has been created', 'I');
 return new;
END IF;
return NULL;
end;
$$;
 )   DROP FUNCTION public.process_xt_posts();
       public          xymatic-user    false            �            1255    16563    process_xt_users()    FUNCTION       CREATE FUNCTION public.process_xt_users() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin 
 if (TG_OP = 'DELETE') THEN 
 insert into xt_triggers(tg_key, tg_value, tg_operation) values('users', OLD.email || ' deleted his/her account', 'D');
 return old; 
 elseif (TG_OP = 'UPDATE') THEN 
 insert into xt_triggers(tg_key, tg_value, tg_operation) values('users',  NEW.email || ' updated his/her account', 'U');
 return new;
 elseif (TG_OP = 'INSERT') THEN 
 insert into xt_triggers(tg_key, tg_value, tg_operation) values('users',  NEW.email || ' signed up his/her account', 'I');
 return new;
END IF;
return NULL;
end;
$$;
 )   DROP FUNCTION public.process_xt_users();
       public          xymatic-user    false            �
           2605    24723 (   CAST (character varying AS public.erole)    CAST     H   CREATE CAST (character varying AS public.erole) WITH INOUT AS IMPLICIT;
 /   DROP CAST (character varying AS public.erole);
                   false    665            �
           2605    24722 *   CAST (character varying AS public.estatus)    CAST     J   CREATE CAST (character varying AS public.estatus) WITH INOUT AS IMPLICIT;
 1   DROP CAST (character varying AS public.estatus);
                   false    639            �            1259    16528    xt_impressions    TABLE     D  CREATE TABLE public.xt_impressions (
    post integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    id integer NOT NULL,
    author integer NOT NULL,
    attitude public.eattitude DEFAULT 'LIKE'::public.eattitude NOT NULL
);
 "   DROP TABLE public.xt_impressions;
       public         heap    xymatic-user    false    671    671            �            1259    16535    xt_impressions_id_seq    SEQUENCE     �   ALTER TABLE public.xt_impressions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.xt_impressions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          xymatic-user    false    204            �            1259    16556    xt_plays    TABLE       CREATE TABLE public.xt_plays (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    author integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.xt_plays;
       public         heap    xymatic-user    false            �            1259    16554    xt_plays_id_seq    SEQUENCE     �   ALTER TABLE public.xt_plays ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.xt_plays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          xymatic-user    false    209            �            1259    16450    xt_posts    TABLE     �  CREATE TABLE public.xt_posts (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    status public.estatus,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    author integer NOT NULL,
    CONSTRAINT xt_posts_content_check CHECK ((content <> ''::text)),
    CONSTRAINT xt_posts_title_check CHECK (((title)::text <> ''::text))
);
    DROP TABLE public.xt_posts;
       public         heap    xymatic-user    false    639            �            1259    16448    xt_posts_id_seq    SEQUENCE     �   ALTER TABLE public.xt_posts ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.xt_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          xymatic-user    false    202            �            1259    24712    xt_roles    TABLE     ^   CREATE TABLE public.xt_roles (
    author integer NOT NULL,
    name public.erole NOT NULL
);
    DROP TABLE public.xt_roles;
       public         heap    xymatic-user    false    665            �            1259    16545    xt_triggers    TABLE     �   CREATE TABLE public.xt_triggers (
    id integer NOT NULL,
    tg_key character varying(255) NOT NULL,
    tg_value text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    tg_operation character(1) NOT NULL
);
    DROP TABLE public.xt_triggers;
       public         heap    xymatic-user    false            �            1259    16543    xt_triggers_id_seq    SEQUENCE     �   ALTER TABLE public.xt_triggers ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.xt_triggers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          xymatic-user    false    207            �            1259    16395    xt_users    TABLE     C  CREATE TABLE public.xt_users (
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    status public.estatus,
    password character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    id integer NOT NULL,
    CONSTRAINT xt_users_email_check CHECK (((email)::text <> ''::text)),
    CONSTRAINT xt_users_name_check CHECK (((name)::text <> ''::text)),
    CONSTRAINT xt_users_password_check CHECK (((password)::text <> ''::text))
);
    DROP TABLE public.xt_users;
       public         heap    xymatic-user    false    639            �            1259    16473    xt_users_id_seq    SEQUENCE     �   ALTER TABLE public.xt_users ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.xt_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          xymatic-user    false    200            �          0    16528    xt_impressions 
   TABLE DATA           \   COPY public.xt_impressions (post, created_at, updated_at, id, author, attitude) FROM stdin;
    public          xymatic-user    false    204   �J       �          0    16556    xt_plays 
   TABLE DATA           M   COPY public.xt_plays (id, title, author, created_at, updated_at) FROM stdin;
    public          xymatic-user    false    209   Z       �          0    16450    xt_posts 
   TABLE DATA           ^   COPY public.xt_posts (id, title, content, status, created_at, updated_at, author) FROM stdin;
    public          xymatic-user    false    202   �m       �          0    24712    xt_roles 
   TABLE DATA           0   COPY public.xt_roles (author, name) FROM stdin;
    public          xymatic-user    false    210   [�       �          0    16545    xt_triggers 
   TABLE DATA           U   COPY public.xt_triggers (id, tg_key, tg_value, created_at, tg_operation) FROM stdin;
    public          xymatic-user    false    207   S�       �          0    16395    xt_users 
   TABLE DATA           ]   COPY public.xt_users (name, email, status, password, created_at, updated_at, id) FROM stdin;
    public          xymatic-user    false    200   V�       �           0    0    xt_impressions_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.xt_impressions_id_seq', 200, true);
          public          xymatic-user    false    205            �           0    0    xt_plays_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.xt_plays_id_seq', 201, true);
          public          xymatic-user    false    208            �           0    0    xt_posts_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.xt_posts_id_seq', 1, false);
          public          xymatic-user    false    201            �           0    0    xt_triggers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.xt_triggers_id_seq', 31, true);
          public          xymatic-user    false    206            �           0    0    xt_users_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.xt_users_id_seq', 122, true);
          public          xymatic-user    false    203            6           2606    16589    xt_users firstkey 
   CONSTRAINT     O   ALTER TABLE ONLY public.xt_users
    ADD CONSTRAINT firstkey PRIMARY KEY (id);
 ;   ALTER TABLE ONLY public.xt_users DROP CONSTRAINT firstkey;
       public            xymatic-user    false    200            :           2606    16538 "   xt_impressions xt_impressions_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.xt_impressions
    ADD CONSTRAINT xt_impressions_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.xt_impressions DROP CONSTRAINT xt_impressions_pkey;
       public            xymatic-user    false    204            >           2606    16562    xt_plays xt_plays_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.xt_plays
    ADD CONSTRAINT xt_plays_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.xt_plays DROP CONSTRAINT xt_plays_pkey;
       public            xymatic-user    false    209            8           2606    16461    xt_posts xt_posts_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.xt_posts
    ADD CONSTRAINT xt_posts_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.xt_posts DROP CONSTRAINT xt_posts_pkey;
       public            xymatic-user    false    202            @           2606    24716    xt_roles xt_roles_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.xt_roles
    ADD CONSTRAINT xt_roles_pkey PRIMARY KEY (author, name);
 @   ALTER TABLE ONLY public.xt_roles DROP CONSTRAINT xt_roles_pkey;
       public            xymatic-user    false    210    210            <           2606    16553    xt_triggers xt_triggers_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.xt_triggers
    ADD CONSTRAINT xt_triggers_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.xt_triggers DROP CONSTRAINT xt_triggers_pkey;
       public            xymatic-user    false    207            H           2620    24742    xt_impressions xt_triggers    TRIGGER     �   CREATE TRIGGER xt_triggers AFTER INSERT OR DELETE OR UPDATE ON public.xt_impressions FOR EACH ROW EXECUTE FUNCTION public.process_xt_impressions();
 3   DROP TRIGGER xt_triggers ON public.xt_impressions;
       public          xymatic-user    false    204    213            I           2620    24740    xt_plays xt_triggers    TRIGGER     �   CREATE TRIGGER xt_triggers AFTER INSERT OR DELETE OR UPDATE ON public.xt_plays FOR EACH ROW EXECUTE FUNCTION public.process_xt_plays();
 -   DROP TRIGGER xt_triggers ON public.xt_plays;
       public          xymatic-user    false    209    212            G           2620    16600    xt_posts xt_triggers    TRIGGER     �   CREATE TRIGGER xt_triggers AFTER INSERT OR DELETE OR UPDATE ON public.xt_posts FOR EACH ROW EXECUTE FUNCTION public.process_xt_posts();
 -   DROP TRIGGER xt_triggers ON public.xt_posts;
       public          xymatic-user    false    216    202            F           2620    16586    xt_users xt_triggers    TRIGGER     �   CREATE TRIGGER xt_triggers AFTER INSERT OR DELETE OR UPDATE ON public.xt_users FOR EACH ROW EXECUTE FUNCTION public.process_xt_users();
 -   DROP TRIGGER xt_triggers ON public.xt_users;
       public          xymatic-user    false    214    200            A           2606    24724    xt_posts author_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.xt_posts
    ADD CONSTRAINT author_id FOREIGN KEY (author) REFERENCES public.xt_users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 <   ALTER TABLE ONLY public.xt_posts DROP CONSTRAINT author_id;
       public          xymatic-user    false    202    2870    200            B           2606    24729    xt_impressions author_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.xt_impressions
    ADD CONSTRAINT author_id FOREIGN KEY (author) REFERENCES public.xt_users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.xt_impressions DROP CONSTRAINT author_id;
       public          xymatic-user    false    200    2870    204            D           2606    24734    xt_plays author_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.xt_plays
    ADD CONSTRAINT author_id FOREIGN KEY (author) REFERENCES public.xt_users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 <   ALTER TABLE ONLY public.xt_plays DROP CONSTRAINT author_id;
       public          xymatic-user    false    200    2870    209            C           2606    24743    xt_impressions xt_post_id    FK CONSTRAINT     x   ALTER TABLE ONLY public.xt_impressions
    ADD CONSTRAINT xt_post_id FOREIGN KEY (post) REFERENCES public.xt_posts(id);
 C   ALTER TABLE ONLY public.xt_impressions DROP CONSTRAINT xt_post_id;
       public          xymatic-user    false    2872    202    204            E           2606    24717    xt_roles xt_roles_author_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.xt_roles
    ADD CONSTRAINT xt_roles_author_fkey FOREIGN KEY (author) REFERENCES public.xt_users(id);
 G   ALTER TABLE ONLY public.xt_roles DROP CONSTRAINT xt_roles_author_fkey;
       public          xymatic-user    false    210    200    2870            �     x�uZMv�<��o�@����5�ӽ���:
 )9�S'z��D[�@�l��l}[�����U�U��ɾ�}�z��4?��������?�MR�N�+����d2�÷���/�U�`���wNߩ|笷t<4�ҿm|�~����ɤ�;MR���j�j=�����j�S�'����9�-\�����%���z?2���E��+����6���Ϋڧ�O&{��{�Ľ��?X�/�3������tK����6��t<L���?��XX�����epr����Kj�,���m�^W�Wm�F_��e�`*�[�qtn_xMIX�Yp�D@�À �p��7������O¡���TX	�Ͱ+�w-V�'j�#0�	V��\��K�w�p��6c_�íZx�s_�1�<��Vݸꂣ���[��`��8-;~5y'�`�$lG��=l-N�x�@*N��]�íf̀�q����gF������V+��O�@8Ȩ?�	�U�hqx�<Q�c�$����N�í66LVt֝&����q�U���S^ �t#�$�<�Ѱ���V%��G��xq�e�Y8ܪ�h6���q�x9��0Oí"*��B��N���x��~.�q�U��K3�bT���HR�`y�íF��nTjWY~^�ʌ��p�y���L�=ruRJĻ��29�*�+�����0��ՊR����NLJ��+;od���jL-��b'�F���^��ʬ��4l��+s)H�g�L닑J���V%Vӈ��T8�y!����0�6J��b��T澍^f�
qʘZeW�2e�(o^���w��Z�%��zsDjV�C�*�טZ%� W8�@�⋑�w���TNr�}	�~^X!�h�UTB�tU�+�]����10�6�<۹s�����+�����0�6��SX�ة�<���3���F�'��,����"�=���5�Qol0�#G'
��ϫ1�W��p�U=;'z3v�q���J�|�p+y9G���j���#+3+�Sk`���F p��J7���
�:�[��b�y6���|0������p�y�������a���Zu�����dd��JDeV�EƨN���|h �#*bn������-����l����c�/�Pd6�S[`c�� ��jV���
�/��������j��RFd ,U�i�U`��V>ʤR�4X��!��M>��w1b^�$�V�HA�ZLm�G�����a)����E��9�j��<��с��J�N^��-��vMd���7?3�^����V��V�p����הĘCTbjl�t�
f��w�y�pE>F�`jl��7�</�ͭL����~0�6�γI80�W�I��ɭ2�[�3�{���q��Y��냩=��w�h� �6���I<��D������w���}���x>��W�t���g�;�N>+o`jl�q��'�J䈒��ע�����F�a�d����iN�J*�������8L+\7��)��#�n�+\-���������;o4�&��v�u=i/��:#�o��Ym���|HF�^-s���C[]�Q���mb�bzCí�>%��`���"�����^Me��5زwW�jյ��|C�&�6����"n��c����|�e���9sP���#�1n��;=o�;���݇�í�cӇ��д�J���ؘwv��+��z��7p�.Sg`c�ٹ)���j��^�[��黻@����Z��9V��3�1w�(��Bؽ}������ؘ[�p~���rg6b�����:��7�E����G����[�v(*��Y�g�sL�0�n5�7�1U,�S&#*:y���ܢ[.)Vx�W#6y^�í��ᑂ,Vv�>��,����3��v�2"n�X��4s��R?���N���7��#Ż����+��v�(� ,oQ���TS�2L]��uWz��cl�J��.���`�
l�z��\<*���[��SW`cm�d(*گNJxq.�,��+��~�ᐭʮ�ukd�����ƺ{~������R�ꔰ���V�ޯ���S��/᥉o,��\T܆�w�e�L��jZ¾Gh_�0N5{��-��h�����p.����E������V����:�ڔ���)-e�ӏ��/��@�g�$�4�NcQ�B���[�;�
�n8����`�[-��:Gi��P!O��/%�˛y+���`!g�:�_Z�c{��E�4#Fd"S��[mifqc�؎�r"���[u�w�i3"k�e���Y���O��^�u�*1^�(��)�z��kP�#W�R���^��Q2�Q~�5��B�?DQo�$�����n�����*�����e�jSv�+u��=eQ�h�{X*L��`���.�l�8��mk9C|c���F{4�긎8���\8H�=����̒��aS���^ҨS�%�:���`�tR��쩍���אb�իj��X$pf��&Bȷ�S���Of�㩎�]�4p&�} i��"��G{��mc�GJa�W�J{����b�mz=��Ge�v��)�J�g��[����)� !/���NHWC�7�&-kG�$��<�؛o1y���HݓTH2=iQ˼�05{�=E� U�dV'�\�`�N˻�RI�ަ���~$MgZC7/�ԋ�i���Y�i���n��S'�r��Z�W$N�:{
�eS�S�
9ٳ�S)u��n}HO?QB2����Jk,�%؍��dA��S+�^�������ηZ&�K%������|�S-�EJ���:�����'�S.���c������*3�S/�ꢎ��P��n��.�A�L����{� #jP@&�b꽾�[]N��[�*��K2�@yt\[�r�t%���f��_�����KR���^��N�̣��U�41�2��C5uL2)��/���2�S6u�_Ek4�eSe�dUӧnE�茚�}�2͕'SRx	�5.4�M�HA.0�����r#EQ*�7��!�x7��N݌���kF.א�I�^ک:�"}�5��ETd�Ԍ��x*32]٥rgeUS�x{��A]���}�D1C� �%��C>uLv]T�s(Y�TUsg/����.N��7�Q�S@�Bej�,���{K$���
j�&��/��ʺ��M�KBu�\ե�s�����P�h�~�IuE��1�,��^"j��������2#	�B�����f[ɕͨo�GiN_2�i�E��.�U����6�^:j��(�v��L*Wظȧ��BH�"����OB�u9H�<�TO i�J�j�I�z�����*����+i�]���?�KK����խ�x����=��-�W��%��?լ<��h��*��S͜���^r���JǏKͩ� �/=���(�P9�oC�f�*.��R�ԒV� ÿU�M�:�3��h�������>$]��K]��R��4U)מ^�x�o"�~g��=EU��~�'}N��C�`��TU�VN��..��X��
*�KVU���=�,n��O'���7/]��W�Cۯo���
OfOa5�kR�t��ȓI޵���G_��ۧ
?�l�'_���"�"�\"�ION_�S[��^sQ��[��DͰ��zrIJv=�*��0$s�u5Tv�_v�w�˜���W�Yr�}e���ʾ���z��}k��e�.�7{	�s���r.;Q�Hxu�K�
�`����v�e񹟽$V����˖�A����Kc]�7ȕ�9KFwS�J���:oɗ���-����Se-q�&)���"I�2��Kf�1������+K�Ab�{�m���[���ĭm%}�a/��U��"���fW����V�Ɯ���hi��X�����,�D�ǹ�\�[�"��w��9����e�n�N�������������0      �      x�}Z�r+7�]���?��ܹ��D/�hO�j6%�$U�d)�����~�$(�^�l)� $2O�s �~^���xRFYm��ؽ�;kZ����1���i��zO��i�O��eo�κC(䷸�fg���oip����>�f����ô�1��[�0v:\8�8x���t���yZ�g�u�������i������C�m���5����|�x��S�������{�Z��L98O�:���r�?��颂|��b3�'ⷼ�i�4F�x�aH4�x�_/4_ܾ]�E���hi�_�2���~��2����r�_ip����Ɲ�g��Q��L��n(j��,���<��<]U���V�����FCE(c���_W����F�TE��6"����cy��A���`�����H1Z磪@�e�-: 
F0u��ͧyJ�����xy�=#��Y�bh$1(w�f����@��ۍF���r���2����ʄio)}0��j0^�9���u�i��6���Զ�`�6���r�f�i���fo�������P��C]H���ʾ�����?�uz[�@�	[�"g�_����k,#�MR�M�;R��-�=����[�p`���L�:9���&I���
R�n9xF��4E�x�ޖ��4Y�� "�V�d�F�k��V׺��i��	J�z4�7eՉ�>Gɛ:n*��r�M_ow��?ij��a�a��t����uO?Y5}�?ϗWU3��ln�Z�Q�*7aT0e��a��0�QadiYo�^��	�U��#r��̶<�#5;.��>
�E�m�1����	�Z%vS��%/�56���4_oTd��j¹S~v�!)�1����\`LP���c{�DH�V��5�� ���fE�9�:Xa/5ZyZ�B�%�[1�q������|-K�S�ߴ^��BT���NN���㥞}W���"��ĭ=�>�g���� 	���n����u_֛rFJP�=�Q5����:��3�W��Y��T� ��FZҖ�e��<�v���*��1�c���-(�M8������4��ۇr^�q��zx'���1��Q1:��y���y�P�wA�+�*�� �c,��Y���ܦ�2�v��t���}����w�g�Y���֬~� M_��RGr:5��{���g�|����\�����i�8�>P�ʚC��IE|�Ea�2����~Bk���/X.,���������tُ��m�Q���F�v�6�ekQ"ڑM��
��L���ل�T���-+N��ܮiA�}\���V��b8�h ���G��{ �4���e~Yֳ�BK=tR���*ޗ�u�����Y���<Pi�#[��{:����I��&�|�e2�Qn{#ݠ���L�M�]>}:L��@�e�Rup��P���/%m��'&<б�5ʚC��0�u]��h��g��s!xK��V���u�P�st�C
l�烖%c	)�/�ߧ	$��	\����d$C:qa;b����z\�ۤ>�I$�>'J
X���S����o��ݿ�Ӻ�j�e$B�N\�	̇�V1���<�W���r|[����渔��O����D?��<Q֫�{�[F#�a/���1�
�w����:�h ���^;�����!�A�e���y��L�EX_�&e�������; "����r�F�,7��ܖ�Y�����?��T�������En��-x����������Z�Ô���f�����a`QY�+t�� ]�h��+P76�J���l�Z	'��S�y=�益V֪�S2��M�MI���2��' %�.-hB�"��1}B�p�01 �x�3�!>��V�N;
#���ٿ���}��cA�l��Y��Sh�z�xZg�-n�7��	��b�߈UƬ���6T.��5�I���bF�y�ELO@�M���Z7���N�7(��C��e^ό`q�f�+��Ao��� b�ɨ�/��D�ӎ���R��X���;��Ԁ��C�긜H�/��-?�Mt�F��TJμ�2��DC3ɩ���JcB[���q�71OK���K�7�>�^���?���J�	����"ɓ��b=�nl�2d������ed�����s����*.��sd>w�{V�ڊ���� �F�!e5����K8�I��"M�D�(�.�����3)U�
*�&���D7�Ȩ��:�!k��y��R�Q�*5#�ߺ��jax�l�m��N�o�>�[�dƵ��,��;4RL���\ɭ�5A���o��z����OD+���T���4�.��bfd0L����A�߉�tB�7"D�enw��+S�T�6���/����}����m�Z�e�V���m�;"W:��=�+��!?�A9~�,�P5�ʆ�<.+��ErS�,���sOD̀�Y2��M��EѲ�
�`�ř0b�.�4�܀'c��0!�}�(U��wq(F�v[���<��{�q��Z5�.y^�b�[i��s�L���"�Q��H񣴨m��fwx��઱�9�0O1=���BJ�E�A�i�ZѨ�1AO�C\y�UGEб�'��D+�Q}��!T]�xp�آ�����"=��]ˠ@p�2w,�<�<a@�궎��,YZ�򜖁=�f�0T4ԚKQ��Jl+�M�U$6[�5����<�ft,�t��V�CtϹJi�E������:>W#Yo�!��1��k�_�89GC�`�W���TS�:ń!�D�HC��,��ܮ
�v�L&��JeFq�|��V�5�a����#R�@�G� Xm��"��D���FcNO|*ИH��h��nK"D5A0�Vݬ9�f���wf^���� w�N��gG8@�>BɖZ˟�[L��tW5��@�hV��Ysi���}Q�fu[��FD�F�6�^�!��ˆ�X/�V�W��&�5���	3>�]�^WF�]�̶�Fp���~��=��X��ۇz ���v%�h}� �`��YL�W*�3��r����u�^���3�;��'q�Y4��N9|���4�$��r���dԕ�5�>p�|�c�D3��~V�V&4��-`�1��b�D�#����q�4
^����4�i>"YTUt���8�Uo���n9K#�����b�Ed�; ��2;[��`��~R?��O��`t~�D,�0�|2I7ϙfE+)R�U�����b
g�0�k��]k��'o��h��WS\-�0z�u�Qd�
[m��,�z��Q�z&�3�X�k����W���ʉ�/)~c�nj
ӣ�l�.�S��p��3�HH�յ����$�Vq���Œ�u&"g�	^?�w���<���T)&��ςU��զ�~��E��R#.E�xd�<�衷A.mQ���v
�BC������ 2U(�L�W�]\?`;�k7`|�k�`�KtQ4zi��Σ���2����-��G�r�>�:�N�v�g�--o�˨�.k8�K��n���v��,=��F��e� �)�����4W6B��B�g3I���J���r_Ŋ�<��l�V<^�����P�?_��v�Z+J�x���`��]aV?�f��6m����A��_�5�`P8��૽V2�Z�ʍX�CN�P�Y�m(ю�vw��c<��o@ɗ^ ~A�_��zе��4�h�Y�7=��ݥ�cF�qF2�%�ߊ�_)�M��ϝ���+;�)c�T@�}���������Dӭ�I����ь��jԼ
���Ϙ�Ÿ��z@I؜�j�����F��
K���5�"��JlReR�D��+t�Wݮڍ\���}~H�f�
c3��^c&�|�D�}~�]䖗��x�Uﰜr����Gӽl���ס�:Di6gГ(�T�#q�"a�s�j�6k�E���w>&X%H��N,�4_������3��^'D�M�m�6&�"eSF��&:�_@������I�q�J�}�Q.Vp[�VW'��r�k
�H���.adH
�[���D�E�ih��
-B�y�
^�i�K6:{��0��Ěr������+W��[��7Pt��!����
_p��/0���m>���Y�j�M��g/����Y�Z%?��U@�h�hԏ�r���O㍯�b#J�W �  ���[:'���eL��\��j���Ilx�m�x��0牮q�jO݉�:CoԵj`BG��ݒ�F6*w5lA�8��ڲ�G����~:}�/�̯��ee�[�/ ��x�b0�~]����[�TrW���JoE�7��vq��1�p�\U�1w>�I֎��9��7J����u~?M�����xlVKF;�$9X�o��GÓ�|�ؘw�Vّ��AU;�I�[����g�e�8j�,��M��(\��N͓��Xl�H�"[�0�~��� �+�̌�!�9kö�J�$���te�	J~��֣E)�\:�5��<�ޖ煸⇘�A. ��nuZѵ���#���ڴqt����AT&�Ή)��6/5�_�l�m�ֶ��Hu�r}��U�j/����o����,�չ�|W���.�.X�<	
�Vo�y��8�+m����W>ɽ`idQ��H�����a-�Nol%5���@ :�>���(��X��g�mς�(��G8���sH�&�8�>rl�V3���l��q��6�^�M����;��q�jh��~�=f�~���}���Wk̰��Cޞ�Mr���D|9˯0!=�D�3șE���zӚ=�Jߠ���uh~�Řhs��4�z}�A�<gt�Y]y|��[K�W3���v ��*�j��Z�>m�ŀ���АP|��8�U/����U��bYח!��P�{>B�%�H�Vne�帜ĳN�hH���]�,n`��yqe{�S�;n�|�":
�o,KPO��w�,r�G��nς�CV`���Y�f�H��WNi�	�Z�r��5-����l�F(�ݞ�fЀg���Ai�^/.)��Ϋc,\�R�N%��P/�;B�6�� B��h�K��������0|�p�$^�!���o�^V�^_Z�u6lW�Z^���.���m���7
      �      x���r#I�6�v<E���i�.eD䕛1^����N��u��%�$�C �'T5{��6Z��c�i���Z��DO��="L�f�R��`��T�@������+z�����բ����XM�l�Ͳ�"/��.�Y>���"��I��l��uv�g��V%?�����y徾���b��p1)f���ǜ���o��[{*�Q�N�kɷJ���w�`'P�����.��ܫ�=|]d�^�-�o��q�m�����~�ȷi��f�r�X��l�5xӪ>+�jTT��|�O�r�U�<�<�G��yQ�Ѣ�G��7��a^f3�j1�X�Y�M�����M��ܻg�|2Y̼Y1��i>�;U.&�̛��+|�c�1��o��y�����.��ޫ8[L�}~?1-ܻdC//�)�:�aU����[_ɖ�;J혘_�~��iO�;���恡�a>��c��VP����/�\��c>.pZo٨p[��eg�|Q�^gy]y�'��76)���&��Nw|�n��=ev�d�d�g��o�e�D���<��J��S��۔9���V#o6�3���?p�E���F��^�S,f��x�9?BY��!,�'`����*��V�Jw�շZyJ�h�7B:,ϳi���;�u������m���̈�}<Dz6��b��Y^�oQ��fT�ʹ.j�����X��ݪ2��wҿ���"��8�ˑ7Y���y]�����Ç����~��;��{�|Q{�N���1���W{a���a�׹�����Z��D�pTcۘo$֛{W�l�gި�GOg�X�R+{g��[�R��M+'���ܝ'�?��I�R\���b�M)f��2ɇ��+kL�]�|9��=G�m+?��Y>��ܠ�e{�żƙ�s��V]��˧�ҐO��j&���3�w6ɠ��{�6���`I�fe&�(���)d���o�W�e�]k�q��rg���u/�g��,�)�a5d���n�n���{�*x+��!�2%j7����}��N=���f��AL��n�9Ѓ:���Z����4�b��P\A��As9sY�숽*o,:�	��
<�wL�
��wK�`^�($���L���kQ����"�j��};T�{�z��/�g�!�~�؅$�fn���JsӋQ�?.&W�9������B���j��?am0�q"eU���m�숖X����N���<Y\��s�����c�m]͖˹qpФ�[-�����U�/|#�)��W���"l�r��5ZlO������L�em<�=p�uL�@��}��&�s�/&�vc�;�>D{��{�$���R�k�Bj����3�����U ��rX`���r��\Z�Ղ?�;�?*���Lޘ?���������E�r�7��Ɵ狋���\+QqN�ԽW�G�ϱ4�֎ykk�����`��p2��~��B�塚�?�����io� �k��?���l��g��ͶN$�_y�����Ӎ�iԘ�Ǣy(Q~�!6%k�ՅǨ�4>����w���!C��Se���u���ղ��	�����X@�/�6ĮT�aU_�[�͂1���<��)����Xŧno�\}����!�g��l�͙|�Y����f����8������8:U}c����9��X'��㨭�D�y~��k�(MG�e�,�Qv��'�x��0ڭln�X��a���6&�5�~'���Ж�� D�VnT4Fr�[}�˺�zX��O�cE}�����ޛ!�s㱂Y5�p�:Q���~D�U�P?�h�c?�Gb��s|lt��iB�ؔ tyq��-7l���_����P���ci�hyĲ�-��[�D\J�����^U��A�\-X?�푴׊���vW|A;����x��67�g�¾���Np�ڐ�_/g8��ieEV��R<���|�GE>o�%�/j�#���$�����1�a�NZ+׬پ�?j��.��Y�$�)墒�qUoX�V�9��k~�1��f��f���?>a��x�ox��+�|����9n��	B8m��bDʡK¹S	{�Aʑ�2�I�_s���G�q6ʩ�����Ȼ��Y�$����y��-/�����5�{c��a�B�G�8_C"'>7��L? `�ޱ��ȡ�C\��o�Zs݇��[��7�<�"kl��WC��ҝ ��ܦB�x8�@_�
*���|8�n�{�$h*i�s�A�nB��S��9�h�b���v�����)V�ǹ�P�%��+j�l��H^��x1B���N+M�G��W+�ngG�.���v��{q������ْ{�z3�ņ��y�F���ws�Cy7�/Y���S!��0r�n%�����U<P	�;��������?�m�`W��`'3z㊊��Kf-p�Vp���z�sb���V��Z������ǽ�h��w[����^
���20�?o\)%u�W�7<uC��v�v�C���J�Ҍ8���nQ��x[GUu%�m�|�Uc�+��,{JM@3i6�p	��gT� 6�TsY=��h^���2Ԟ�U��RNߴѰs��}��qce���+�U��,/v��< ?,.��e�4ڼ���]��8��;�NÅ8�/�0��,���c>������:��r��cyYV�J�3OryH�Ǭ.[�	��n�+M��K�Fk��RH��h�Kl~��_�:�m�qV�B��y��{%>���*�k��ó�\��V���	߅��S�t�?�)1�O��	w������v��A��TJY1g�J�JڧS�e1�5IwO�1W+"&�������}m��69��	j'Yi]����:sV{��k
�W�ں^F �I���q����K�������:�.�����u��|QC�>�����n ��X��Ƚ����8�˅f5КlṗMK#śk�-l���9��i�B���ܥ'��ۼ�R�̷i�e>�My,��,S�'���x#R;�!�7J!�jY���$'o%5�Y:%��/�jB~���xM��c�9����������X/A0��ƊO��N1�i3@�|��*z{0���s@�B��Q�9��M�R�3|�,�͗"��c.tH{�5vH��0.3o�mUs��]�z��H������j�q������_x.�ET"��@Gt�g��-�/<>N�?���g�J�s)�J��6��h�c��7ĶK�hFk���Zl��.$n?ޙ�Ƨ���s����P��:��qq��>N��ݻ��d��5K+�M]Eh�:i��䜖�#	B�Y�K-(�1$���|�5m0��Zr���/ߌ�Ϩ9Ǣ�tr���L]��oċ��G0~L:��8��j8��`7%�t�&�(���t�7seR��&���:���7�l�qV����h�i�-����% n|��-ŀ��F�t�����	}$�5�x'�����t:����?V�rT�z����<¶n�ɰ`�t�B���Y1�������=.��kȩYV본��Yt;`�#sױ��6�r��PtJ���v�����&��*�˷�غ�j�;7]٢-��.�iJ>����m,��s��eb?�?�$k��-�i���m�F2S�<c�ٺɎ�]�=�z��hh�FӇ����j�I�N>�=��ut7 c�}L��|��|��V���l���	���؝JfG�V�[�E�M��n7�O$�@���H*y�O8�c� V鴚g��p�i��F}�p�f��ݍhw=)�q��æ+.l�v%�L00!폋�颼�vG�k���T?��{��gb���.7���k�d���3�@�k�_��*��F���Ʒ��p�<���&��qA�k����iu	5G�5�]����mm#˒���o�=���ƿ�� ����Ӥ�y�i��`3���h �0�� B���"�]g�T�Υ~���N(�q��ԙ��V/����i�I��C�4�}�~�֖��[wS�����"x鑳:���1�iC&>��~F��k������tIq� �Q�m�g��d�B�A�?ۤ��蒡����K��r��|�/���K��*Z�f<t��p�ʡq����Xp�j0�By�t(gr���1pA�]U��M��t��ٷ     r�Iqō�.ͩ�@CY}������J��<`��5w\��J/L�v��Řa[��3�c����"d<ʨ/j���Ɨ�=uD6-�M$��;m�`���B���)k�?��e�K��窭M���rll8�������9\ X<����/f�QϘz����<T��u�Ka�b��J�ݒ�Hh�K�ALo��缮�r����(so�n�4�^��^��8��n˞��w���.˱��e��=ι�Tb#���.z����䝙.!aoۍ��fc�5�F<z9�-?Y��_�>�pW釮8�,�QIӧ��P ��H7d琟����Q�������Y�Z^����bV�	%����ڠ[	c�A�?* ��	�|·�\�3�[ǟv�x�H"Y!�k� ��F�y1�tE�?��&0�e�U�>�h��������HF"lK~*]p1��jjz�s>���뙷���eTq������x������kc�WI��#nl�'��uj�JS������{Ϳ�fy�N"��<�&��	�\{Ɩjn/� �ٴ�����n�\���S@�v�@v������|�h`�F4TF0�29��fԇK=�ģ��u�]���<EƩ���Y`��І��7e5Ϳ=�� :H�Sq�ݱ�Hb�/'��>��]1Qb��c��`$��"�P�*?T�d�}�����I �j�Cڥ>F�86�a�p��	����	&�0��r�	.�l,qGC���c��t&��ֆ<���TZ��{ja:�|�wr����O�9n<���5��"|m��߀1��f���Y}E� R���YE���X|�P���f$.�̌d�>E�3��N)R�Hw:ͭ��c��u��ԑ-�ʆ�Y�H:(�H"Co��3K���^^��^z��>ֺ{V}̷�I�}i��ѮAJ��+�l�Prd-���M�d��D�p�{L?���U��o��v���`$j'�0@�ej�
����QH�y�OC<����Uܠ��%�I�l�P)�^���(
QD'yYͳ��6�z�~����6C�8"��b�t���!�QL��*��6����U�%�5����j����vL�k� �� �'D<x�b����7�Q��;�LR�[�3��9�v ,�����P/�}� l!��ŒA��^vv=���=-���k�F�s�ʵB��_�##�.���[C��Q�"��q]X�i�e���+�����B����=������EN��A_^���]W1�\��Y���~��;%P�|�O����J)��b5�u���5t�lN�
b��n��A����F��%��2wNb�T��|^̼����������W���ܖ�H�$�bƪ��}����?���9�}�ˋIv���G<K��h�RzQ@��
��g���r���1�])��A�ޤ�F�>"��6OxZ}*�K۴1�&k�U�zFG���,�[6{_ptq8�#ڝ� �^4a�S���๝Uğ�����Ev��o���G�8�w�@>�u�AtAH�O׆��5!p�X�eh�Q�qB�g�1֗�|���ͫ�4X��^��'��p����P���� f�
�������z��n �o��%�1�����oB�-34%FK�)Ţ�$�%���A��)|��|��ɧ�t���m��3����3"C��>�3V�L:	�g
BJ�A�� �XLܐ�";�'��L��}��� �W�<�%�y<M����w�{�)Q�D�q5C�m�B��6=�3v�^ �t��z▨F�����DC?�[E*l:�����Q�2�2���q�&�f��
]�B�A���$3(�W;ޞL5�7#��/�=���*������b�v�I�/MI0HBz�mާc���jxi�P��٨m�X����_��l!���.櫕����A�^������b8̼א˙=�>i�'-;I�vD$j?h�K�hO��^�P��>�I�ɦ(i]�F��c�[<�n�Lˌ��g0+�8|�iPN��I<H����i@�S���T���o���G��Ok�G����2\5^P)���S=v�V�àR��d��`��H��OGO/D|�&�nEE(���!3���9�3�ZS�T��b:-�n�W�O٧R7$�e>t3�7�a7�$'̲�����c���Ó�3�;6ַ+�k�#G��xq�89S�REG��r��״���R��6}��������ʭҚR5H5�������ݗ��3�
��ZXFs�1dwY�Y�*��R=H�-ª�|�N��SX>Drn³��i,h��Z�v����ҀK�d&���c�Y����K ѵ�Z��m�1�fD��K�#��� �i��Oi�S4~��.�1.ؔ.AҲXt2�'���4��P/f��|ʮ-�^�@$�oy'�y>��^��z>�{�����8�8&@i�)���|��p�c�)f��z�����N�K��/��_�,�`i<H����g�[�s�{������|#�NROpV�2�k�,�� M�=s�s_g�O��H�z��"�⢉���<�O�WB��LӁ�}�G`�����l�+�5A����KY��{�7���y#'0�-�6):)���ӻ��Y�������(&���IX�i��k�����%A���8�k�zp�s�\�s�͎,�Q	!{��G��V�f��;(.`,ntf9��Q�xH(?ܳbi��mZ?��W��X�^�����Lt��	<�`Gx���{Sԓ����N+����TDWY	�D�{J���A����{S��
鈕��H�����K���]��0ːL]h��@�=2�� �sD�7)�S�S���O~��H2L�G�6�V�����0�X���t�kƶ̯e.�.M/,k$,��R�fP
�sK:��	��uL1N5�����3�
�]g8�x]I~��Mo>#�%XxJ's���u~����x�"�=�ƀ.��vC���Ԗ��kO�َHK�t�M3��X�ޖ�w�M�8���Y�I	��Ud�*O�Jۈ��F���*E��]�Xs��c O`��ք߲�V�X�@m�]�(J�].+�ִ;�'d�����3��#�ƛ����mz<�s+і��k�#��d9t�I!���L����T���qN��L=~Ϯ�-Db,����3[�梀�oe {���ϋ?�z���(�5~m�%�^�f@ Bx���kV�-�����j��3r��_UВ�Z(�	$�b"�0�^̼�2zq?���L}X�r ���|�Ti$��$NT%��d�!s B�D՘��W��)N �Z������r� dDC۴f��j,��� $�ɉ�"�l��hu�����	A�&����Q!��l���z��_�J� v-#���g�Z�J�c�UIIiw����V3�޻��VH��_�?z��t��������%���E�T:Pڧ�jz����Ԍ��t�w}X�͙��k�F7S�^�S��ؽ<�kF��4��U�SHDk"� ����9�\��I#P�<A�γ���[�Z�Gm|׃6y)k\��2tT}̽C�,�iF��ݻ�P3��1�\�R�ۡ9a�9���ЛE1�_{�01��w�W{�9lP�A.9hn�%1�ܥSlHUϼ��o��gV��(�z��K�-P�B�q#��g3��4�F""!67��`A�{E~&8�=,6���9��.G>(_�U)�ZX*!P,�2M�熎.J4P0ǌO۽��'ι:3�~��������*/d���U��j��M'�Yj ���aB�|��b��}Ce�_{�Y�gzR��}w����]/URȌpc,ǒ~?�D�Q�a���o��j�8�W�|=�d!�vȘ�{��	�ҏ%�-���E�ʍ!`[��,�r�.��7m��${�@A��N��s޺@2���;�ˠ!�;�ml��a�`mn}uX�)�3a����Ҝ�v�P����%������ʸK�p�������3/�(�~|lv�5X����gHdB����)"����yj�o�hH��w����~��Nz�=u�֫������N,q��)�����"�V'��gd#]�?�gm�c�b��mƳa�haȿ�)��?��_F�)G��M�B���d�(���W?    �V�R��-��+�xq	a���m�Z�Эr�n�U��I��a�e,+�pr:f�YF!z:u�����:(��"H���0�b��*$�"zSq̾{���ߩ�N������B�©_�h�g��~�WP��%��˲r��B��p��K���p�PB�e�Z��bW1L�����2���7��z���������w�㡋e� �S�e �oãۑ��h�{�X���S�u��]-��6m ���u{��̿/S���9�6�ݘ]Ì�>��n,��u[��?���l<�����m���*�������7���]4�S�c��P���~QҺ�nܚ���a˺!?7 �h� 4��^u�D.�	.7����=���l��A����b�T�S�?�q�'�L* ��8-&�2j�!�l�l��9�In�y�f��k�3%����!^���/��q_�^��N�M�X�Q%��$L�#�W��-��J�x,��D��%a�G*��eXj��G�S/���G�irxv�[`��0��˒@�p�zJ�� �c�\|�mv�s�E�w�0�����x�1O7OZ*�A����!
G �$-uZW��INknvͰV���v�J%��C\_����b´_�4�~����/��vK��,��6�u���4<��w�$���)�YvB���s�{�2W����?�Ϝ8�Pi�-`d��r�:Q%�`���Bv�����~F7�A-����CC!�P�~u5����Λ%�&�e��h��ɒ;;�(�i7! v��q�\�_笝������|`1���ud|���AᔆpJ_Lm���bxM�rv}:��ۇ���
���\��R�.�-���,^�O�}5�c@
�O�|��!>��9�i`�����Eg�}�D��˅>��C��aD?^ͫO��gF���eF:�k��mz>���[L�k�i���گ�WYy��[r��ʦ�i�d�*}ѡcW�Jr҉Oa�-Oh/f��C�$��T����U��� �T�h�]���)WZB�YaJ���3�2�$��Ǐ?v$���c���fЎ��5�&"��|��En����1c���Qװm��­A^��ԙfrM�̉��ĐJ8)!>�7�ͮp��9�C������sh�C�Ԃa}/�(B,iz]��GN\H�4//p9�h8���+�4#�}�j�[���}���8R������M���b�1̉&�%A`*�9��N,��2G����1/<�㽙0��d���O��?��}�*m�95ꮃ��s�ۄϬ�����jIV��<�q�6*��x5Bd ��{�EY�3z*�u��Q7����4n�l����֘�;}X� [�^v��x�a�D��_̯iM�������5l��OGU�3Z�v恒d*�4�:�=�cUM�)��d���0&$���Bԭ�#LS�N�"��䒻�����F�UOFh�V��5\�;#��4�m��)
|���C���/��L��{A�bz]L�c��lTM�>rt����	E�r̎�r])����N��y�埨�^<�����.�
�d��W'��Z	F���IM �)�-F��?,���k�wUb,��b���ِ�Ԓ���E�@�>�γ�m�Ũ���*z笧��J���J�C�׾4����},N��d�����(�g�AagX�o����|5d4p��F4����b��j:Ȯ-1�wZC���6��%�U�F��k4:�'N�)&(�5Vl,\5���9��u��-/�#e���
74��Mse�aR66�`��K@���~�{U�����x�jz&��$,nT���{�V��p�+�ah��p���C�C����k�K��[�A=��=P���*����aӥ�G��t�q���g�w��y�_{�x�_������菝�K�1��,h� \g{?ѧ�U��j
�R��Mǚ�3t����*�a�q##����#|�:�ή���Ǵf-�k6�E�*�4xfB���VU�4��]��+N��#�Z�����uoJXۍ"aP����v?bƵ�]��9\�:[�r0�f�ê��m�g_,�uQ�2}BFθ�m��>�;�ɛ K�tyG����S�M�N��u�&g,#���A�Q�(N#܁�"J�&����oO��=�#}kdL�-Ha���l�)��m2OY��41�A�Y�^��C߮Nζ�k��4�h�"��bJ�&�P�޻
7��s��r_��n�tC��4���2�7����0�1s��b�@<�{�+6,,��3Z��,-�2�h�+�5�[w)AL�D��R�	��^��k)�6������`I��O��יi[��Ӕ Kb:��!����:Yx�V|��ަ'R��A��X˙[��X6R�z!%�>D9lP��M�A{��c�'��?�&D���[�Uڦ���� `�?A���q��{�g���;�����9=)��M���2�˴X~1�7���F��|��r���]:4|֓p�B���$LQ�	�V��1mν���5��y���n)M2�L���#�0\a	$kP�x4����Z��q6�J
ΈM𻬾�i8�������W[��iX*9���FSӑ
(E��*:���o�>�G�i>�ivo�~MF�;�S��Ȧ�R����q�y9��h��;��=��u��HDġ�^�Q*��<0L6�jH�& K���Yo�;�&�g����0�1��6�g#D7�	&%`�/"lL<�!���z��zgsz ����Ueͷ?��FA�u�2_0y x`sB�����{�c���z�0�Y�"Wun��Z &�-)"�4��z*������n�x+?v��p�,l3�~��i�i�γˢ|AO�=X�mp��ر��FՐ�*<)w!�s&�
�{�<j���z�G���a�`�r`D-�W�O27��4��qB��ׅ�Ӧ�}S���VG�pA4ᄴߠ�-�L"�j	�� �����ey-�3�QF�CAv�I;�^��f	��4��|�W< � ��{U�0[�y5��HW�ئg��}M[���R)]���C;2r?�4�V��ך�e�6FP'<�d\�?A���ݧ&Sj���@���:Y
���EJؿ��N�����Ѻ7�guL�cǵ�%�`+��m�y8�ǀ�o� �,�g۴���jeR��d�xń��rt	i,؟����Z�m%�y�*�k�U׃�$F;����\�
���(��D�{vV��RGدf&V�1����8��ֹ������z(��o:t����6�c�iQ���$��n��ƍ��ɳK�g��Rҏ�;	��/_̼�ż:?���b����I���;L&!���t�Z�xi�f�+%Vpv�������}�����+��D:6Cje0HKKgg@��O��򬺞Q��zX?���G�$�F.�~�r$(ǥ�CV���.GPI=���;��O���]-sD;�	s�+���8�k�չ&���`��ڦ^%��ܽ	Z�YF����e�^%�, ����~de�K��8<��Q�;sO�l�����[%8�H`�:Ύ�Z���p^����l����Y?ihM��Urr���G˺.����8ݐ�p2��{�����ȳ������7���5M�!�@k�hD찥9�v)�1���l�u}��ҭ><%�s�r%V�,2�ZE������U6⫆���Qx�����]�j-m�O�BZ�>!�NR1�(��lta�JkY���}/��M��vy�$U7���CvwizW	d2�W���e\��>�˯��]x��υ��Mk�p{��׍j��j����/�.I/��g���_:�ڧ�,��a9e��]#��L�h�T�&A˳��2k��J,J�q6�p7�x�XN�o�`����[�P��Y��V8|M���,�$���E>�_ӓum��ʺ��@Jc�5�����5xMco��?c�x/���w p��A��b �+6�0d�+1��^͆؍&��c��P���PK��Za�6B1-��!�Tjl�y]M�}x��E��凌�`�۫�a���Իd_풭r����B�]���@�
�)�YE��!Y�p�U�F��n�|����%͗��Jd�IGآ��?������    �w���t7�M�!q��p³�x���W��SU���>ϰ�y��<��8|;�Z��8�9��eL��K �)�|V���3.��x����vr�	������a����jf���6,��΢e�Y��:�ҾN����_c����lV��T��9�'�f'���J]m �R-����_A��`b&d|ȓ�]V�/������5S�"�7>l�D�.��V�0
������B\L�gczf�0W�q���0>:h@0��߹��H/���ڝ�M����"�̎�v���jr���̨/����GB�v%;�bB���aԲj[�;Ă>$�@����,�O%�x��.�q
�3�V�W�O?�����6=��ZcʼN� l:��¶��l��--�iM�=i�Ǧ誨�9=AY{�0���o�JI���tGGnΤi&�'��VdB�jD'�����xƭ�����tr�x"��b:��m��S��]|i��"j����V��B2����І�{�L�}o�5�m��I̍���,�6A��ؿQ~k-|��1�����Ԅ��{tv�}��B=�`.��dɹ5�5��vT��w�8H��$����<��s,�6oS:	�n��	/a�kB�������ҁ|:�x��
J�#�(+�ע{�B��+��Z���J�ŧ 1q �,uQ�3o��gͫڦ���~=g�ګk�r�!l[�����tW
$N��w�}`[��j�m��ޫ����E�T?�����+�#����.`L	v;`�B���)8lx-А�Y\x����֏����E���]`������K�^z�\�w q�ٹ3�w<~�Pœ[dX` ��N��̽﫳�m���#�2���5�e�e�Ia?h�%�v�Y�� �<V��R����ʻEts�Jjk�X��Æ������k��{��S�AI
��u��)u͈���&�����?18�O%�8�g���5Q\q�'H���0az�d�A9Ih���:�����y_}%�nFP��[BI��w8�q�`�@XRڟ@����,��J���:��WG�3oLĥJ��7�M�dH:СO�&��5���W�j~��Pԁ( 2;�Y����]i�ڭ��EMJ��D��^ؔI����lgW|݁�p��*����٘�}G���J	�'t�s��x0������y���(/�ɟп𧻱g�X���=�M���&<�ǧ�`z����)"�u@�;AS v^Qk��9��ZX6q�����a#=N����\��f7�����.+�.�1u�8;l�r�ϐ9�~L!�0d���w�����59S&$\Ƕ4�����7��n������;f��ɫٮ�K�o�q�Mao��>Rh��l(��u@Ob�ֺ�Ym������+�[�̣`.�%�^ Xz�m��B�~W���%��,�f���6p��b�D�}2&c��B���<p����z(�Z���Ä��$��m�zʎ*�9�p�0�7X�	g�^c�%3��2����e�q�M=yDߗ�%��*��߾�#
1�#L:�������3ו����i��nc�΋�}��QQ��<�d���N��_�?����_ժ�O��l�㷗|�;~��3�>A��<�Z1�o�3�0�.�4�e�57�~������(��6���f��дd���ȔV�4��Л�iUeE=��	�i��ǩ0�Bp-����3���s`����,�g����ګ%��w��3��p"�6
��!��&���#ߥM���}��?��be�q���O+޻ճ$W��U�$!S��?
�+�W�y>㹿���y�rT}��'�$�w��~{�����A&\kՎ��f�p�!�"�AL��$�fczt����]WHFY!�tlZ����7��!$5�.%��8?�&��WL&�L�ȧ�ԭ�A��;��+d���D��+�Q��N��A�6t2�f�������Ƞla/�_�pǋr�z��z�<�M�h��¶gq�i��,��]Bh�t�c�N��a��[o�Y����@�L��]/�\r#ͦby
���U�;����d�</�7��2��]��+L��(����e�x�
�YQ��=�t\��>d�t>�|<��}1��Bǻ��<Z'�ԝT�
P:�鷁v�ER72�*5F:��8��E����k|�UrV_�Y�ogr2s{�T�b�Hq@{���c#�O�>��;�@f/�~������/��#��C���p��on�ŋ��}���;�>9�缆�|WJ{����n��o� �;b�(�	D�qD'sP�}���K�i9~�op�Jo"6���|ce-[F�bĴ1s�ָ�x�\��E�Y~�LK�\.'7i�>1ޞ�+F,s,Z��Ӭ���g���[&�ݜ��l�-���� ��e��w��b�{{Uu�i���I�^�l�m�]JWV7mRK�B:뾊��Zz���K
Ո����+�ICm!L|��o{������Վ޵	��Νy;��,־h��Z���eU� �Nu6�'=�N�nf\������o y�ؓF�&���{U���̞V�Y�W��s9��8�K�ȗS�8�d�{,J4����`��O�����<���.�mZC��j7��͘��Me�&�����aڝ�%B�����g5XV��j�!��B�^��9H���*JrH�XĿ޿-v�@�;�Q��y[��ϼ�=��/�>l&��ah��5� h�D�P�����9$;�V����	��w�6;�%�n>\�����2���f"�1����k6V�n~T}��|�5�)O3K��F*���<x�y,��ù9m�!�>$��v77��O�O<H
�"Q����gT4�LN@i��Ƨ$����Q^�AĻ�rX�|ǫs�O�D�L���É�M��J��D�݀ ?m�r)g69m�t�Y���"����pL�Һ<7�ӗ'.cg\�Z,�b�
�O��mQ�}Ug�Y1g7�Oܤg�-�ζ�ع'��֔*섛������	��0�x-����m�(����tH��JU��o�����M�Ck�/^5g@;*��ҹN�7�rV�-#��N�D�/Uw��wi����p�[Ρ��e*����H��;+���$��6&�0mA�yBn�
qgΟ�=؈�K��=M�T��.�I1��%n�1%\>�i00�Oo�Q^�O�w�C�ml��X<��Q̖���f�R�IC:�p2�>�}����E�d�]|��q�v%�5\�����k�<��SO�ܗ�:�8�%�e�\���APc:.$�t��8_��y�MN�Ԩ���r��T���ZZ��ɔH_�~A3��RU$L���1�4Y������{�7�j>��[�ْ�@�i�ɺ�Z ��[���5�_��56� ���#�Փ��<�w��V^¸� ��W7��(vx��t`|���ɧ�'�q����Ůtkl��y�ԍ��K;7�;Ƙ(�h//�}��y�)�����Y��k��{��˔wȟD!�|��B�j�+�k��$
g��C�_��� ��.�����i͊�݀��"J#���n^i��� 4��=Db��93q��!��m@�p]*!]^-;JT�p�^Bq�ڂS����V<����}XЇw���	;�J7!mc�����qɐ��c?����^@%�j�6mS���T�/YB��kdXG�݉>�IQ�˻��5w�V���d�l  ]bL^��D�3����9�KZ'���\;�CZ� DI�,3�R�GI蘙���z���&��b�9_�p���`���d\|YIi/y��i1����e�c�q�M}CS�n�<��Z�X(`dJM��)[�7�-l:0�')��E}�C;�������Ȁ��6�D%.�.�
BV���|����y�&�u���!�p���G�?�²0��'�$��ڢa[��B
B��F�6e�{�8����t<��g��Y��Ǚ���%���k�a� 	�KVuv�����ۦ�yB���Ո����2�b��^����:*����Z�8k�[�u�u����1aPJ͸^-Y/a�g�@:C�PՓ��;V5	`g��|9�    N�j{�"{�����*5�v4^*�5�ԠB<QDo��f�^b豘�E����������t��aZ��,�/�Y&RIIEبx��A�m�����*fE�N��m��88���ܯ�������d����d��Q+���ߧ���'�}�u�)u��F�BT,��vF"_.��	=��ᥠ���Ͻ�8@7�s�rS�<�˅ѥN�M�X긐�䫍Ш��ҁ�>�Ux��WP J���u]"��>�v.E5�M�ωh<�����
��ɴ���װV3z�d*���Y,�D�]5vt6bq�IF�I�ø�i��s��� ��͋�>�-@��!�	iD���C�C�`�����|N��<���S��*�����]K�(96_d��w!��5���
�0���>usG�n�DV
ʮq�m����,�:�Ӻ��"��58�x2c�0�T�Jr��E�I#����|��Q�pzN	�� a�p�rl���i�`"�$>���0�9�Ҫ��GsM�d�'�i=Vɭ�N��=�ZF(0���N�Q���ETC:�(%t:θQ��~�%[2z"Aj72B�q�q1�������#����4f]���A��_q���)O
�@�⇒K���A`<�f�َwR��c���wRMX	���_��tn�Q+�.� Z��|v�i�ƙ�o�]}�n=bծ�x.ϖ	��^�O����h4$������?z�����>��<~��̲S�8�Iv�϶�m���TM�����K�:	��()Eߐ1gN=0�0�כ�.�9݇[w�
a�$��7��Bip!��P8%'󬮯�Wל�}hr��}�� GαD��Hj7|��7���D����N�����������y�mC�O���ˣ��wG)��>]�-�Nؐ�&WW��5ӛ1s+�p��;�Oo��k� �
J�<����
�-�A"��)&�G4��T#o�%��C5��m���ܛ�˗/a-?�#��~��i�MO;�������v��x��jn{"A�d�4$�%�*֊P�l�g�3��A�PsJ�"aD`��״����#����8�s�Ӂb��~�>nq���v�&i�;�����!��_��wq2�����.>3L����pd������͖����0 p7��3��I\F �*�d��� j�>�4�f�	CJ����i�7@��f�t��evk�q������\�|�m�?�I6ۦ>���/]%�m�Q��c��#�⊏{d�����*��6��n�m��TѲ=�N�JD�h
rH{U=b��b�����lS?���"k�DWoF�D���$����� �����o��B�J�=���l=W����N5����2A3&vp� c��r�S�C<f}Ut��]�T?��rf�Ri7
�i�4E	nzL'�G�鷯�=����zg��~�U�r�%�.�b�ϧ��h��c�aB'�9�����D֭Ħ���;�q2��Ȁ�EX19S	1������uS9�t	'�%�l�p�c�a
ҁ	}zSa'����b��l����Y?�qX�f�T��\�צ-�+��,�1�>�U�I>�����k��"<������W�O���ܓ8_3bCড়��sU8WM'�nP*5ݽ��~%a�-X��u�$��FR��+2�W@$����v1�J�m2�����X�҂<f@o�Rg���9I��b��S��=����5]�K?�f<�����F�_(��0���S;�����9n.��-0�L�T����0ĶD��c��+'�G+�-ƅT(,"�p-̀ܧ��1�(�VŁ߰.�y���gp�ƅw]owZ�zOe��W�T(\1�c.�z���~��("8�0��Ù�V������bkWį�;���Ϫ�5��,����[L��M}�橃��Řvg�$�੝pI���Dn��O!��0���z&��Q6����
��n��]C�����g��+A���	��$#\���Ӗ�ݶ2'������]O��pGhR��~k7��͵�[�w�7�?(Į2d}",)w�J��a_ӡK�H��<��"����k�`�G���Lf�9���>��+�վ0��x�ʼ5�ѐ�:�HA�4��(���{͐�ь��z�H�M�*u�#pnv��I��P�q��/�j���V��R�g��<Ͻd�����b�A��vg�mz*�h=Yؓ���kI>I;`Ծ����2h�]��C��i�{8nQ^��Zl��e�
�����=
�x!��������ߏB���4R� p�R7 �5SCNC�iD�u���W��g)گ�6�Lv�c�>�̮�S�}�
�l�C5�uc-�Pէ�5��[�'��X�8��jF����Z܌��.�ܲ�k�F���%�̼b
"����bV�c6/[�p���h�^@����Ùګ#�u �@lp�$|�ܹ'=�X���%���uюw�՗�۪.~�JzDn���P� �d�+����B&&��L���>��@ii ���Z�z�b�\�,8�!Q;�FI�/�y�w�C�筛���I���,��b�}�~��'��|�fb(u>�Fs�9VGM{�l��F���d������.�Y��ν˪��K�[냫��-U �t��[$(��B�@�Xc�����7��O�Q=�uà���!�2��S�5��!_l �[�AYV74�5Ө����|�e��N��<�}*��Z�V	�)���ִd�6��� �d3��?���R���u7�Ki�3���kű��8����0��V�"zU���o�|&���㪚P߽��ݻk"�7�HK�P�Ȅ9#���^6LeNz1�� :iF���旯�p��?;��4�{��cX"���
���k�k4ϠF��A]�gL)6fT�Ű����M �L:^�.��|N�$}k�)4��KcυL����(گ��F�V�z�����}�U�!�S�6��|�!%P2'
���[����zƖ����)�De�C`צ�(�6C?���2�\{��K�%���W���9���G��x�����5�~�p���t�)������Jz�'R�'�I�A��[72LO(� ��Q6�����ɤu���a�tFƋ&�<��Rf<��ˋ��α{�16�����ִ)�k���Nm�����`j�,�r�v(�W���[��O3�]��ч/�/�
�0k�S">��qh�T嵽FwQ�����)�Ԗ1\�>ցw��IJ�׶�6�P�F��ҥ��.-��ZHD��*A\�����9p�g��s��@�nOH,9��	̲Ҥ$���XRJ}������feg�S�zQz�y$��;��+o��RcN�_��c7S�G����.f��(��_׬IV'� Z�QL,�Z<�K���1������ʘ[����MW�s�3�(E\����Ε�<���ɬ�H���U���8271�-�4C)��4��x�'WYQ�:&�=�xkD��*���'b�V�2��RD"iH�k<��.�ȝ��.(��s|#8�n�܅�#�D�2��1��� M#:�xs&�۫�b�h�Ť�(��ol���jw���?�d֫?�.�/��εW��!�Y�d����@4�"�Lcb��a�op6ɽ�5��֬��
9�I¨F-+��̡�!Z��.�I{?�,a��[�ʋI�]5㼘Ίr�M��Pa����t^�l�$�`��-n�"ՍZC�~��n�GI��Y�&��Ie�t���Ӕ���u���m�lS��Z��)S?Gou!!]�I���Z�KY�w����t$�g��l��Q�%^ۈ���;<��<ާy\e��a�����P�qS��� n�!��݋�z�г�tͻp�5�~���-�!)߇�(:.F8�)&dS/f�I�3�]�G��x��TZ�֍�}5Q���t
�\6K9dd���ih�_k���m���Y@���n�9pl�0tsd�y�Gh����L�����>�!\��o���:h�����K�+���"�&��C2�π�3����.�g�R�p�h�&nG��2"(v�X����Q2/l��ΥYI&    l���<�����߲S��ƹ2�-���!�(�dE���Fg0
ܙo��ÌV9��`H�q��m���������t8�_{{�y*��j|���#�6��"%ڣ�j�[�[�f�ڟ��_,��ۄgUI}�����˖6Ԏ&1l�r��ZSH����Y'�����5|<z��Yvt�$���߶�XZ	#�?�$\:�O��9m�~|EWD����'%�K�p6[����V*{�hR�3G9��g����?|*�K��L��� ��5ï)���R܃"j�UN�������8��������B�Ǒ�r���v9��;������9��%�z_���ҫ�S�M� ��ĉQ`��R�L@ǵ�vq6��fƲ�F���,�]�x+�q���3R�'�75_�sLF>��z h����&d�wv4�+�Q��`�
!��-\@�w�s��9������&ޫr6����I�5̀vb!�*���2��)�)�FUv#����Oy���C�GzB�{!���#n�\ ��Q;lDǎՙ/B��O�4c����K���~w8v)��]$Y'��X^� F�T�Ha�_zo�c�F��y?\����'U�/,�*Q��]��O��O)��\����$ϯ*�]�S�kQ�b+R����$�Ǻ��[p��v�ꣵ���+b�ͤ���p i9˄R�Ysp��)H���3^D��������0�.m�2|v�y�*.��2�����j!C� �X�f�V�-�l�β7�����m�C����nAy¥p��beظ3.
Y͈��׶����Ӛ ��U��$����P�;�����q4'
6&�#N��Dr�΋2����\��ݞP)�i�Il� ����Z���1 �^�$���W;�6`k����yvC���E�����I��4�$��s�k;�#t�P(S>4b}��_�M��"=�8��E�6����P�/��@@��<��OU=:/fc���ޟZmq��j�c�k�����C�QC�,��.�iƥB�����ֵ�2�5�A�k�,Ӷ��������xSz������lVy[�������؆g��qA���\!�1�}j�^���L	��]�0�f��G*�pZ�A �֝�e�G���"^S��rb=G��"(�˸ⱴ_1L*C�|2>I�1�<�m�]�st� w?\y��Y�Fa���d�������ʽ-��|��>?���ئ>介v��I��t��ɒ� u�xÔk�F�g��$b��|�Q�vnBv�wu/t�1[ZOx�F;+���5c 9��L:)�����g���FOt��yɮ!�L���d���tMi�3d����/�i�N�<����S���:MݷV�i|�C2��b"���XG����ϡ��Q'W�vW)�Vc������{aU<g�D��^g�br��̯�P��W���ł�d:p��z�$b~M��71D(�+Y6����5�O��*��G�nx>��
]�cu��ÖB�;>c��b�$��>�Khd�1��!O4�e�[L�D�����v�%��y�=�&�O�j* ���n�dIZ����Q���SLō�mK���a��Zm����(/�����Ϩ������Ju`�l֗^+�\�Y�c�T�q�t���s����߰Q�kiM�n��@dX��.�5� !;:�@��T�rԢ�^/jǖ�����鰮*҅�k7BZľe�4�AG�?#0���"f�xo���O�P*2�WҞN�i5gi[����,`K�2�Z��{H�����6�o��ho'S�˶�@��nPb{":�>B��F�ϭ����)��G/2Hp�MO`�ť&L��7��ӂ�K0�s$���1�eg�jM�D}$�^�t���%]b�[\�#;t��Q0p�b�lBٵx=��|��+ғy1qlP}]��K�a��kvS����+�M_���.<MA!M鄻q/ز|���c�׋����S���sg�$�|��U') � }z�]�����{]WS��v�\�3���b���]�1\�����x�����@Q�C`���Q�闊;[�Ovk�(ᵃV���yhA�J^�7*쥦��+�k���gM~s֤kA���i�携�	"3fxH)�8nC���{������ �n�R5laڵXǮ�NaR5�‷���{��3|���3;�k�R��`�Y�J��sܲ�k��υڐ� O���b,�n�ѳ�O����B^f�N�d{fTO>�=���d�n]���	��u���q�)3m6�_�|'�a�ǎ�؟��m���2d�/2E�z��=���p���SbU�8i1���'�Ї1��W^DC`�{ӛa�f�C�^h�#d��׸p��k!"v\齢y���j�36�)�����a&�&IsJ�5v*�>��}M!b�ȧc��Y�"Q^Pߩ�u��[���MU�[��;�^��o���j�!D�g�6;��t�k�u�fq�-����M�l}A��j���Xk+և3����g�v*hIw�|���zRo�5w/�"�7u�{5���o>T�h��9e:g��Z�/o�M]}�_r��%�(۱WLF��,�p�����"ߦ�&)ܔ�.3[$M�z�@g$�l\���`Xօ��7z옝��=��~�^�iNO�{�=l_�9�0h��AL��`����6��r#�3�����.e��3S��	\�i�S.���GP`�C:�Pzo�����=�6:v����7�����l^�H��>KkY���3I� ��:�v��h�d�rh�����ϘKJ��}�X���EJĮ/�";�ZPG!�2��l�7��u�y+2�nވئ�7������X�h�O(��1�ơ�
����n�_��hKG��Ka���|ĞFQC
Rz���w��b���ɑ�.���yY���L��h���N4��L��eS�f
�M���O�p��A��)Pĭw*o;*�}(�ޡh76��bȝJa�{*�8NMsI��W�Ë��'y��	�#��[J��?rXb&2�C���
��)�d���W�����
�4��j��&u�P�����#��`3z2jg��ֺqa3�ڎ)�=i-d�N�7�d���P�����6��+�ˢ,9���C�u� v>�-܀m�Ѯ`�r@!\0�a�7p2W��;^̊a6�4mD�`uV��L�nG��C���� ��#:�����Q��>��=�Z��xC_�}�q��H27V�H�)F������Kﻬ̩�-�v��%�H��C���, g ���)F�'�l�xǄ�6G�JO�Փ]���z;Q��]V[��a�{3#�	�)������nJ��p���j�p�yUf9��د��k��lhL���n�/�#'�|GY%�pO2��+D�	�A<"�{���.��kg�	���v�G��}�VIi����� �O�Z"��������>��̮'g8]�p0�1�N�&�SJ�'�vq��b��喝o�jT"D�S��z$P��3R�f�\���D��2,�D�(�B�UU{���N3�]��r��y2I;��aޱ��3�P@{����~8?��l���KzM%} ��Ul�[J`�4<��|A*)�D�t������/{['|p�M��^��)�]�-�,�;�pp"y-�>���Ӈ������z2�>�����n�y�}�'�˺�/����h��躅����܄b�i��Pa�U%1D8��/�:ã~����6��.��Uѻ?��ບ�P�3�5ck��|���җ�_�.�O�e\�����v6���Ľ�Z̝����'mf���e�^K�A���}Q���Z������쥗�+�6=e����ז3o5��hU��Q~����Dx-�ԇ��h!���6�9������Io�d��*��o��|��ahگ�_�ܝEo�7W%���H�F*n���v;%�Ff_�TC0��������'U{�0:�!�}�e�t�:�;�Ɏ8�P-Z�k�~�<@@�����^�J�,��c�dGF8��������� ���'x}E�z��f��mQ/>:�[�-�>:eڂ4�Z"�-j������6ѵ_�	�{�    :�Qq����`i,�+��>�&���O�<�G��^���l|��e��9��ye8�1�,��p����|"m'�-���
ȯ��0�J�NX�{{��g>�mpwkߕ��<���@qvIf���r
�P+��&��:t���號X�nIјލ	�%�My����h�tBm@@�������mr�+{"���#?`v�K
`Y�S&��%���!W$H�>$L����۟T�m��ѹrJfyq��:xr()r���R�M�Y=��g�b�!rY�{;�Ndm��p���Q�ᓓ�4�B`���_���E]�S��ޭc���[��N�HZ��T�d���#��ίen�.��>�hf
�66;|�0q�P*�:�i�1��8��p ����y�K����ql�L����8ʑ972�i7qxd�6����q����~�����f�F;�oգ/�8��	)�N����-��Y�MMtf��k���Q�8��ٵ�u6fܑ�-�.jTb��m��e��T���Z.�xu$�8�ɹΠ�~�����e�m#������X��Ѝn<��䇔X�Jt����@"$2�H�Q�fjV3��
���s�
�35qd����e=Lݷo�ǹ���"~	�\J����&�>�G����0[[�����Lq(#�v�"+�W"E��[)�r���ϋ�����^p0�.:�sJ�xd��9�{,��#%�W�٧d;�o���dL[
&i�$��q�OVa������(�|���$�3��y���_��dN[]vZ8n�j�������8B���6�֦鼄��ɏ�y���r���mZ�g.
Ii~�G��| d~lq�_�i����9!pE�xR�s�ӕ�T��e`�Weu����㧒#��Z�v�T���z+hm(�Fa,^��c[zUa�0x+���NN�˪�4/��`dR\�e;x�M�mQ�}���`|_�.�v���ǔcq��+?��Gk� ��&� V�Nn�����C�ϒ��W��z/������0���=�D%��3��F�}���}����2g�>kO1q�����7�P�t�aG%�V�E�+�nrq�m��>W� l�L�E"��0���p;/�O<6�'�w�қ%F��Zt��nR$�A8�+�U��/�"S�_�c��HlA�o��Vٍ��"nz��BV�_cPt6,��Ƴ����3���˕�D�v�A>`���GO7�o�0������o��"<sh�	(��Z���o�/��n�w5����L��J��H4���q���?A���FG�W�rz'
^�:��O��I/����.�s��~�en��K{\܋_>����P�S���܅�R�d�ݹ��>�O�ȃ+�����rL[p�������N&��EE#�v�:��g����Y"Gg��Y�~4�;{�	o睿��*?5�|�HИe9��vEB�Ǚ/�,��3�Sz��b>£վ��Z1�V��<�1	=7r3��;'��y�s>�G�b<,y6�9��bBKC�,x\dA�ڏ���t�ɩ�{�J�G"�Д-8C1�*�>;�yw�M y0�Yղ�=�f����u0	X/��(�75/���+��@�*۱QH}~�WU�&?�,��4�����=��2����R��V�D�K}[U2��l��Q_��Z�m~�;]?Z�J͖5d��}��I,�ښ�=��PnT)�JM�!�Bp4b����is㯮$����j�W�8V�<]�f�2�%��4]D��M�����b�Oƨ'�?��~�p%9a	�Ҍ�#�E���˻�D�M�^���?;>��mN0��輦��s����;���8n��͖"��͋o���Gg��)���l�@ �K�[E���ߎH���Oi99}���Y��,��eێ逗G nPT ?R�7��lkg֑�\��:���0~�(�K����О.f�b^4|�l���> sW�eH�2�"��Ʊ6`���(aL����l��Aп-����uR�O��V�ݢ�6��G!�J�2z����/�{5�'�Wx2a�c� ��N��Aՙv\kZ�"<h)�v�	���_ˏ��~h#�6ۛ��,�2.��E?�ddB^E�Z]��.p�.�N�d4��ʷ�#�����lDF�=h���<�M�_EbBڂK#��.�[���槍�`z�-���_`^j�w��w~�Rͱnu��M�z�)^V�R x8G�/��ꧣ11d"^f�z�Pa���J�s$���h�W���������yafھ]ۖ7%�F\�hxE��#cx�-�yVL�P��G-�ݷ��_�h8��e9�����m��?ŽqV�n�A�־�י>�������7���U���ɳ�U"���}a4H�zPR*�h5��z>+	9~@��X�טN�_���b�����^���Id�_�f��E�i� �7���4����9��I�~J�21֍zִp{j-�TD�KHJ&D	`f��� �7"�5I����
��/ˋ`���_�f��ގ�k��do9)z��`�_xv�]��yЊ6��7�������X��>�y�6ͶF��pl@i�,�$�	��e�z	��Ѡ�������*���^�(:4��i�}D�m�#�����R��r$��X�K^����y�`����!�E|H=�eh�w�2��`bFv�����y���g��yÜ�{��Ez�{�G�
)���G�Rh�9�ˌ�b{��G���o��r�977�J��``�fE�S��m�&[Ee$�Qw���$"�-�5B3�u@�G�G|P�YF���7!E�	�"��zQ\x�������J[<e����t��@�[G��f��Y�r��i�`-�̟ռ!�����v<��Ii|�^�B���6 �Z-�D�0�Yb$���E�k�b:T�+y�w���v�a��=�"���z(�Ѝ�}ZQ-(
�W����y�:.o�S��aW�����
�qM�;M7�M-�N(9�MؚR:c�����u�F�ڪqTaXl�U����f3�O���M3��g͍�����%�M���-.#�6۱qH����;��U����<r8'�i<ju�H�C^DE��7�A�����^*�O������|!��ǊwG�we5+���#�o�D&�tCW�	yb ��v�y#�z��/J���J0Q����@	�4�Nb�_cCo���.�~2Ί�vRP���Ϳ��i<�1�I����P�yal� ���2��i����hO�e@�+윲P}�`��k�9��c�y\\@#��/M�3��x����[��Q����E��B�Z�9ŋ�����'�^��e��5/Zp^�v������C�l�Z���Nf��[F�����b��yMأ�,��Q�F��#�:�\+��X��%P�iL���7�+i�{�M�Jl�IXk}��;��%cP��� z1�xq��A%�E���ۆ�����RWd�rE�vv�:�����e>�t�B0��َMB:ž\VrF��٫|�������'�i�#����� ߫�ȬA|��{���8T�ߌ�~�}]��zTJ���:
�p5&tc&^/���5 �S�x�5�-����	0�<��VR(��G���@�!6�,%�
'��V�|�^k0�������pu��w-���QZ�M�!��ٻ%��'��]���6o<�E���䬠���#�h N�bd!�l:�����1�%��Ӣ��y]~s��ံ=�x4�yC��Ij�Q+�Og��S��yS|�.�AQu��H�W�Q r `#�Y�!<��'	-�ۈv>d��|�������0/����a�����uڞ���v}����^��*xA|f~�R�m����cK^g���+N��.���ԣ͜O����J��R��Ui����&J!��j�V���^V�Ly�����>p�F|V�o0ƗH�!�Z�:d%��%���!��=&�O�0���I���-��~��H�6x?���+*��s�+
SQ�V�r.�*:�NeH�uU���_@��a�e+|������x�CƂ�RN5SM���A��N
Z72��L��@��N��a n  r��3qV�rV
�Gl
�`o�8/W��7�w����˟�u���;��谄�ǆ���}�X��\Ud)�l;5l��$�"'i�~"�y�{�1MM0�`d1�t2�t��9��j��$ؕ��`���� ,zԑA~o�*&hN���"��-AhJ9�Lcrͺ�^�j�������������Y��t���������~$�i�%��5/E�� �R�gӄޔl�w{A�cp����_��CY�Xx�K;�o��ݎC]m� ���� �J�)B�Ee�r������_R9������]=�{c�?�ٹ1L��$�\�G�EG#hR�y{���h2��Ap6**Eu�����o��JN;@��i5O�K��]L(��<Itb�I������V��T=�{�m�V�1V�a#�c�u���~��
jYȶ��G��%= h���$0Ԟ͉��ʎ���(�F�př�����p)ɿA嵼
���ؕ���=�w}	F6V+%�Bw"u���6Һ�m�e�(ӼK�������n`�s���F�V��#%~��z�?AC+�x�9L.��E��S����`_+C�$n�����;q�� ��XG�D���a��f�M�ҋ�����{'=d�^	w�TTN�f�тV@�s6�Y^������ӜW�Wk/8@�?�qϼ�� �K>I>A�P>��X,QD`�HS>$fz��.�yy:.�j�6��>;|i����*�1Zk�VP>��F����>�k>����=��	b>�n2^��f�ax�1Ky�2:��򽠏	�rrUC�>u��\��HҎՅvN�̟��r����X]ǔe;qǇ������={�g��v���蘈��Ѯv{6��h�/���x-	-��I���ߟ�����"��      �   �   x�=�;N1E��Y��w� 2�����nVO�x��y��ʙz���gƙyf��g�ņ)P�
X���+��+��+��+��+�ʫ���U^�U^�U^�5^�5^�?�k��k��k�����yN�tN�t����]�7x#o����ɛ�ɛ�ɛ����&o�o�o�o�oeu��ۼ�ۼ�ۼ�ۼ�ۙ��q�<��}~|=��d�f�h�j3��n#ÍG��l�����g4��      �   �  x���;��@Fk�ۥ�ff�����H�TW��p�Ac�8���.�;� !*t8߼dq�a��qh��q�UMˇ�鸭ưeu��a`�fӟcA@�BZ�fD�Ѓ��9[|.Uq���O����eߪa|ٻ�k;���B���Ud�!��7`��9�F�	�φ�Kj���ƚ�n�����LO���:��eYg-8]|,���P���T���W݆6ܭ�c^O�k����}��.B"�f��z[���'R�� rj-mΌ�o�3f�z�ƕ�N�lv�`ڶ�ԡ��3���� �Ms)�R��]A��B.Mݶ�ZE�$.�=�G�s)�b� ��DT�QťE߫�؆Y�~�.�p\ �i{H^M徺��gp�zi=���f����B��~Sh��������~�_<���)�8����fn�⼸��E{��X�fޯ)O��ڷ�y*��pN�)�����yW��N$��[��H��{k���e�W��+H����Fe�/�,�}���      �      x�}ZYw��Ҿ�_�^������f������̓��nh�0���OU���{��wЕ���z��J��"W��U���ce'+>e����*��z
ըv�9g��G3��>#��f����C]RW!��
�*UŢR�5�B���@d���wRo������?�:4M��=��3��C�Ps�&<G��p�DJ\-��9���Jr^�U��8�fLw�>�faҐ �!G��9��3�����I��+S�,3��y���WzC�{c�ز
��p�����!��Ї:U�:I��h�熗� �}4ڜ�K��I�4:��Ps�:XS�u(����7+y�l�u�@K��(:Np~��������3�C���1�B�XR�4�JZf	Wb�da�Z^�g�/~.���nr�v1�5�P|��nw�%g�t1M����9W�B`���`�QՃE��kVF�b�F0��4�ԑZ�]���Pm/�����0�M�Uj_�S�xk!�g�:N�+M�s�/9�p������������FW����J�~)�0 �ݟ3�:�}ව�f�;���,lL��>3�2�@�ҖI�T₳ �%�I�''ŝw-�j`mq�t�t�i]��gԒ�C�
!�/E�LY�P]��^��Ũ1�7��r�v�L��2ݡ����J�QC�PLW��<b��XYǥ(���Iɏ���-m��� �*;����	�ʱ;>"KAtu�Jr�q�V0��7��0�Z�����"�2��2]�9��͡��C�`y�(����,M��'Q*|>��Q�%��j���ewTX����ݽ��]�6-���(b�*բ�x:�
�:�ø�F+ߴI?�P�j�����0l:��h �K,���U�Zha��4�@���5}G�_n�c��8��#��R��
�����Bl��U?K��uRoy{-�X�B,O����&�>��i�t���l����	S������l�T�q�c������\�݅��W�L�2Ąݫ���l�w�U'"�%L^5U��Q��<�QlW����Cz��a�t<O�'$��j� �-�u���8�i��2��c�+�@ù=n�]Ck�=���Q�*�.�\�)D���,�+�]����%�QD�]��w5��P��A���La��/���-�m���y��e#�Ӄ#2��C�1�h��>�Zֲ����8�K�@�<����r��;x���.7C� ��	[����;PC}aPc��!2�� mU0qJ��|��y�ʷ\Q`�ϕ�e��Lu��s�� �U�Ao�qț�h25���b�"[X`C����3*g�R/�dL��	D!~<?"�7�cץ�<_���x\x�"e �)�"
C���g�:NA*)|)Rn�(������0�c��q��>��s$cs��TR�54 ���:j�P����2Nr8Ȫ>��ALg�zcu� R#C
�Òc��)4��&J�dV-��M�y�V�����(~���C�``t�k���������Dg��"Y�<X��U���{�ѷr5{�q|i�Y�c��G
��D%F�i�F��|"��츸ﳟ�x���eu<��i��}�Dҧ���Ø�I ��5�+�o�9�?d�#������dM������C�հ�uC�bU�y��0P�|+Z/.�c������\_�v�#�
��/�~Fw�OG��M�����L��	H�-� ��T�8�ʸ�v��ٖ`�n���rw77 �tK�eȀ�U�b�y�c�u�����Vo�Yr`a1���p�F�|!��ޤ�AI�$�kB�5RG��f�:6�x�N�.A�.5�j ��E,,t��b�t)A��Q"V,G�B�7��c5q3Y]|WIm�>�����F$([}GSY�?�a�UGe8�W<ms�{%����3~�&�3�����:�mX�D���c֊���&�8'�"rb����M��-{���阭94����"�u�A�����
���魖"�ٲ�Gg�mەs�sJ�^��,�0v�K����,�T	}Η�X^���/�m��ӛ.�_hR�X ���HE�K�BCW�E���͓��Z�28��6v?xK���Ak�3ҵ�%�#a�B}�`�*H�Pɫ��q����qrs�4����;�ƞ���E1�+��NXQ�J� .�+����e[��;ߛ��=��e]��,�����H��,�������4�I���dq����Nl��u���<�v���b�(c`k�PN|����n �;z�7��=��������':��"҇�φ%��àd~)� �v��#�N5A�t3m�=;�(�v3���C�k��S6\�!	�Y���(I��:c�SU�7K��;�B��A��|p�SS/EΠ�`X��,k�A�N^�M��d���AzU�����$0.�3�"��We���I?
n�������^
[� ��/1҉�y��(�� Gi�r�"�W�,e�A��M5z�j�C���z'dݽ`������z�Z �E�6��$����b�3gI�M}����ٯMvr��N�4�s���O8_�$�H�� ~m|��M�c�5P�P�DIǯAXS=�C��,m,~�|PWk+�ҴQ�`�jx���iXd`n`%�R��I*�h�TqY��3A�~���p�U������@
]d"���$�S���60	�
�k��zA��(�r�8�47�Ƥrt�`��!_G�o:괅H<�yْ̫��6=�tz�[���E2s�����#5]i�[e�6AS�ܫ�;�^w2mM�����:B:O�#c|q�>B��KS/DY&pP�2��E:^����>�|�Z��I_��1�l�5����QUQ�a(�E��!��5��𢬈���{�iݶiH���3Ď?��@��3���IA/����xA� ���8�tz�͙{�>^���:����G҇!���7@E�a�Kƀ%i��x����k����OT�&jk��>���2�)�R-Cn'��%@m�A��	��d}�~ٜWO��G��nZ��u��@d����0QJ�V-�=�4 ��8�r���a#>�<3�����#�;���=U��C��1K�,���d�*"쏈��@	�aO��i�7o�^t��@�e�!��7��	Z�z� �gL�"٦)YyYuRh�����m~u}��n[���g��E�;+4tx���!M�������YŎ��]#��ҧ����|`3ˍA�r/�r�O�����Ed&j�����ExR���w;��}g��A&֤����D�b*��ށ���X		�J���R�d�s5�}�~\ٚ��a&�>���i�ˈl;}A��w	��U���`vįp��ޤ?�F�}5�������� wt��\�M��$�OAEH�B5/��å?�ŵk�|���C�q��aw�K��E��غ��Ò)u,9�RK	La$ �$:i�"�E�_<w�IyfHPڗ[jf�(ن��W��%�����8�>N�?��eJ�M��	d'��t\f�@v�Hp4���T�����#����}<z+����i�w���%kx��d[�x�"VE���w��O~ҷ���˥�_�c��ޅ=ᚍ"h��b۸�sh��J2hjzL������oJΓ� ���!T���7B�,��^'��*Q�B���[��l�W�AXv������K8B�>�
�D��.����q�k�e��%�5 ��$���jW��*�T�]Yv;<[z'����Ac��UMqV*~$Ұʒ:����3p~,:��Ž5m>�zcFv�_�~hWs��s�*I���MI#�4u�JU��an�2��ÞB^K����s��3f ?���R�	D]��y��=��.zhɺ�E�o[�=mKx��st�����+0Xd�k�$��c��4��ͷ�u�X����+�N.(a�C��4�J����@/"J��H�]���Kb�kH*5,H�^l]LÔg��<o+��i�-�cALCLH��	;V^f�<�.zݹ���+�~[��P\�[�c�����R���A(�`p�ׂX<+�'�~�h�t���c�ɻEb*��4DǬ�wގ��(���\�?�7ϣ�F���I����.
q �  ���q�V�N.OES�@�F�+����w��F�[����n����͔1]0�۝)�f[T�4���,Yxz1VV�s�tXPP��z'�w�Wr�JQ�/eK�W& 6�$�ɯ��j�<z�=��Šl_��-Ad��3I �JքJ��v��8Kc�:��..eqB��r��e�aT�K�Q,[ů��`�����~^L�B}����������-48]W����<`u*�4��9��-M[�P����<E���nylw�K�#�Ʈ �2k�v4�9>����;���bݳ(��ʍ�^(������`�CҼT�dŠ� �9�>���s;������$ĖA��(w��� ��ʍJ"j�ϓ4)
���+bQ
�OvW?zs$�GG|�\M��ܾ����ʵq��¯
`F���K���U�pՏ���'9��\Y)|��:��2Q|��L���D�qLV~�ڽ�]����DSy`��L�_�Q\׸�:�&'�rZ��W����Y���)�>�6W��40���!��^����d�%D����ݶ��O���;�H���M#��A��������|òlp�7�?|�Q5�C���;��;���tƟ�-��>sh�g#���*?���vu��k�z������Y��܁nS����+B�gd��,I���[wE��"5��y]�f��~����J*�n����<Z��M�ޕui���᱆���p��ͣ
�~e�`�1���O���4��q{kO�6ҿ��vf,�G�%9k��Ĳ�Ϧ�	tux��1��ߏ�j,S�-���"Ă:%�NK����f�0_d�������{���������f�|z{��x�l�����ﶆ�~=֔MC�|���|E����;;�/�ww�t���������K�����>�^���s����O���trkޜ�'�r�Z@�bi�M��+�_�tI� ���H�%�40��j�?����xl�G�cu���OEZ��b����1>�`&^�篇#a�j��;���q����t��[�}�J����E�o�f9���zh�J��w���������V���$�d�@pX���r;��PM�vT1��[b�������ω�&o��dфs2�>�h�k�}z~ɷ��4�o��ߞ�ji���1b��W�����뿧�m���&�/.fϗ�D���A��ь��D,?�2�����۶&����Oy�D:H�<����$)�߾!���?PU�����)     
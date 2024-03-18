CREATE INDEX company_id_movie_companies on movie_companies(company_id);
CREATE INDEX company_type_id_movie_companies on movie_companies(company_type_id);
CREATE INDEX info_type_id_movie_info_idx on movie_info_idx(info_type_id);
CREATE INDEX info_type_id_movie_info on movie_info(info_type_id);
CREATE INDEX info_type_id_person_info on person_info(info_type_id);
CREATE INDEX keyword_id_movie_keyword on movie_keyword(keyword_id);
CREATE INDEX kind_id_aka_title on aka_title(kind_id);
CREATE INDEX kind_id_title on title(kind_id);
CREATE INDEX linked_movie_id_movie_link on movie_link(linked_movie_id);
CREATE INDEX link_type_id_movie_link on movie_link(link_type_id);
CREATE INDEX movie_id_aka_title on aka_title(movie_id);
CREATE INDEX movie_id_cast_info on cast_info(movie_id);
CREATE INDEX movie_id_complete_cast on complete_cast(movie_id);
CREATE INDEX movie_id_movie_companies on movie_companies(movie_id);
CREATE INDEX movie_id_movie_info_idx on movie_info_idx(movie_id);
CREATE INDEX movie_id_movie_keyword on movie_keyword(movie_id);
CREATE INDEX movie_id_movie_link on movie_link(movie_id);
CREATE INDEX movie_id_movie_info on movie_info(movie_id);
CREATE INDEX person_id_aka_name on aka_name(person_id);
CREATE INDEX person_id_cast_info on cast_info(person_id);
CREATE INDEX person_id_person_info on person_info(person_id);
CREATE INDEX person_role_id_cast_info on cast_info(person_role_id);
CREATE INDEX role_id_cast_info on cast_info(role_id);
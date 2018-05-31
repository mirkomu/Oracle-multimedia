--------------------------------------------------------
--  Fichier créé - jeudi-mai-31-2018   
--------------------------------------------------------

CREATE TABLE LBDORAMULTI_IMAGE 
(
  NUMERO NUMBER 
, PHOTO BLOB 
, PHOTONOM VARCHAR2(50 BYTE) 
, PHOTOMIME VARCHAR2(5 BYTE) 
, PHOTODATE DATE 
, PHOTOMIN BLOB 
) 
/

--inserer les images dans la base de donner dans Photo ( dossier img contiens des photos)
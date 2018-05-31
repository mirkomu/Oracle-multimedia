create or replace PACKAGE oracleImg AS 
--Cours: libraries de base de donn�es
--Semestre: printemps 2018
--Auteur: M.Müller
--Derni�re modif: 25.05.2013

-->>=======Procedure rezizeImage=====================================
PROCEDURE resizeImage(p_image IN number);
--<<===================================================================
-->>=======Procedure rotateImage=====================================
PROCEDURE rotateImageLeft(p_image IN number);
--<<===================================================================
-->>=======Procedure rotateImage=====================================
PROCEDURE rotateImageRight(p_image IN number);
--<<===================================================================
-->>=======Procedure rotateImage=====================================
PROCEDURE compressionQualityImage(p_image IN number);
--<<===================================================================
-->>=======Procedure Properties=====================================
FUNCTION getProperties(p_image IN number)
RETURN VARCHAR;
--<<===================================================================

end oracleImg;
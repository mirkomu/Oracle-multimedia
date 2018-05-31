create or replace PACKAGE BODY oracleImg as
image_blob  BLOB := empty_Blob();
image_blob_small  BLOB := empty_Blob();
v_img ORDSYS.ORDImage;
v_photo  BLOB := empty_Blob();
v_chaineTxt VARCHAR(250);

    --Procedure Fonction Privé =============================================
    --Resize a image by 600 x 600 px =================>>======================
    FUNCTION resize_img(img in BLOB)
       RETURN blob
    AS
         exc_imageToSmal EXCEPTION;
    BEGIN
       dbms_lob.createTemporary(v_photo ,false);
       v_img := ORDSYS.ORDImage(img,1);

        --si l'image est original est plus petite que la tail de la nouvelle image 
        IF  600 > (v_img.getHeight())  then
            raise exc_imageToSmal;
        ELSIF  600 > v_img.getWidth() then
            raise exc_imageToSmal ;
        END IF ;

       ordsys.ordimage.processCopy(img, 'maxScale=600 600', v_photo);
       return  v_photo;
       EXCEPTION
          WHEN exc_imageToSmal THEN 
          Raise_Application_Error(-20001, 'l''image original est plus petite que la taile de la nouvelle image ' );

    End resize_img;
    --rotate a image by 45° left =================>>=============================
    FUNCTION rotate_img_left(img in BLOB)
       RETURN blob
    AS
    BEGIN
       dbms_lob.createTemporary(v_photo ,false);
       v_img := ORDSYS.ORDImage(img,1);
       ordsys.ordimage.processCopy(img, 'rotate 90', v_photo);
       return  v_photo;
    End rotate_img_left; 

    --rotate a image by 45° right =================>>=============================
    FUNCTION rotate_img_right(img in BLOB)
       RETURN blob
    AS
    BEGIN
       dbms_lob.createTemporary(v_photo ,false);
       v_img := ORDSYS.ORDImage(img,1);
       ordsys.ordimage.processCopy(img, 'rotate -90', v_photo);
       return  v_photo;
    End rotate_img_right; 

    --compression de l'image (75)° =================>>=============================
    FUNCTION compressionQuality_img(img in BLOB)
       RETURN blob
    AS
    BEGIN
       dbms_lob.createTemporary(v_photo ,false);
       v_img := ORDSYS.ORDImage(img,1);
       ordsys.ordimage.processCopy(img, 'compressionQuality=75', v_photo);

       return  v_photo;
    End compressionQuality_img; 

    --FIN Procedure Fonction Privé ==========================================
    --
    PROCEDURE resizeImage(p_image IN number)
    AS
    BEGIN
        SELECT PHOTO INTO image_blob FROM LBDORAMULTI_IMAGE WHERE numero =p_image;

        image_blob := resize_img(image_blob);   

        UPDATE LBDORAMULTI_IMAGE p SET PHOTOMIN = image_blob WHERE numero = p_image;

    END resizeImage;
    --<<===================================================================
    PROCEDURE rotateImageLeft(p_image IN number)
    AS

    BEGIN
        SELECT PHOTOMIN INTO image_blob FROM LBDORAMULTI_IMAGE WHERE numero =p_image;
        image_blob := rotate_img_left(image_blob);    

             UPDATE LBDORAMULTI_IMAGE p SET PHOTOMIN = image_blob WHERE numero = p_image;

        INSERT INTO LBDORAMULTI_IMAGE_MIN (PHOTO) VALUES (image_blob);

    END rotateImageLeft;
    --<<===================================================================
    PROCEDURE rotateImageRight(p_image IN number)
    AS

    BEGIN
        SELECT PHOTOMIN INTO image_blob FROM LBDORAMULTI_IMAGE WHERE numero =p_image;
        image_blob := rotate_img_right(image_blob);    

             UPDATE LBDORAMULTI_IMAGE p SET PHOTOMIN = image_blob WHERE numero = p_image;


        INSERT INTO LBDORAMULTI_IMAGE_MIN (PHOTO) VALUES (image_blob);

    END rotateImageRight;

    --<<===================================================================
    PROCEDURE compressionQualityImage(p_image IN number)
    AS
    BEGIN
        SELECT PHOTOMIN INTO image_blob FROM LBDORAMULTI_IMAGE WHERE numero =p_image;
        image_blob := compressionQuality_img(image_blob);    

         UPDATE LBDORAMULTI_IMAGE p SET PHOTOMIN = image_blob WHERE numero = p_image;

        INSERT INTO LBDORAMULTI_IMAGE_MIN (PHOTO) VALUES (image_blob);
    end compressionQualityImage;    
    --get property from image =================>>======================
    FUNCTION getProperties(p_image IN number)
       RETURN VARCHAR
    AS
    v_photo2 BLOB := empty_Blob();
    v_img2 ORDSYS.ORDImage;
    BEGIN
            --Pour l'image original
            SELECT PHOTO, PHOTOMIN INTO image_blob,image_blob_small  FROM LBDORAMULTI_IMAGE WHERE numero =p_image;
       
            IF image_blob_small is not null then
                dbms_lob.createTemporary(v_photo ,false);
                v_img := ORDSYS.ORDImage(image_blob,1);        
        
                dbms_lob.createTemporary(v_photo2 ,false);
                v_img2 := ORDSYS.ORDImage(image_blob_small,1);
                    
            v_chaineTxt :=  'Image original:'||v_chaineTxt||chr(10)||'grandeur de l''image ' || to_char(v_img.getHeight()) ||' x ' || to_char(v_img.getWidth()) || v_chaineTxt||chr(10)|| 'extension '||  to_char(v_img.getFileFormat()|| ', format de compression '||  to_char(v_img.getCompressionFormat()) ||v_chaineTxt||chr(10) ||v_chaineTxt||chr(10) || 'Image modifié: '||v_chaineTxt||chr(10)||'grandeur de l''image ' || to_char(v_img2.getHeight()) ||' x ' || to_char(v_img2.getWidth()) || v_chaineTxt||chr(10)|| 'extension '||  to_char(v_img2.getFileFormat()|| ', format de compression '||  to_char(v_img2.getCompressionFormat())));
            ELSIF image_blob is not null then
                dbms_lob.createTemporary(v_photo ,false);
                v_img := ORDSYS.ORDImage(image_blob,1); 
                v_chaineTxt :=  'Image original:'||v_chaineTxt||chr(10)||'grandeur de l''image ' || to_char(v_img.getHeight()) ||' x ' || to_char(v_img.getWidth()) || v_chaineTxt||chr(10)|| 'extension '||  to_char(v_img.getFileFormat()|| ', format de compression '||  to_char(v_img.getCompressionFormat()));
            ELSE 
                v_chaineTxt:= 'pas d''image existant pour ce numero';
            END IF;
            

        return  v_chaineTxt;
    End getProperties; 

END oracleImg;
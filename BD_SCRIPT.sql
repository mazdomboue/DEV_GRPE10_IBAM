  CREATE TABLE "SPORT_ASSOC" 
   (	"ID_ASSOC" NUMBER NOT NULL ENABLE, 
	"INTITULE_ASSOC" VARCHAR2(500) NOT NULL ENABLE, 
	"COMMENTAIRE" VARCHAR2(100), 
	"LOGO" BLOB, 
	"LOGO_FILE" VARCHAR2(300), 
	"DT_MAJ" DATE NOT NULL ENABLE, 
	"USER_MAJ" VARCHAR2(200) NOT NULL ENABLE, 
                	 CONSTRAINT "SPORT_ASSOC_PK" PRIMARY KEY ("ID_ASSOC")
   ) ;

/
CREATE TABLE "SPORT_NIVEAU_INSTANCES" 
   (	"ID_NIVEAU" NUMBER NOT NULL ENABLE, 
	"INTITULE" VARCHAR2(300) NOT NULL ENABLE, 
	"NIVEAU" NUMBER NOT NULL ENABLE, 
	"USER_NAME" VARCHAR2(100) NOT NULL ENABLE, 
	"DT_MAJ" DATE NOT NULL ENABLE, 
	"ID_ASSOC" NUMBER NOT NULL ENABLE, 
	"COMPETITION" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	"ROLE_LICENCE" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT "SPORT_NIVEAU_INSTANCES_PK" PRIMARY KEY ("ID_NIVEAU", "ID_ASSOC")

   ) ;

/

ALTER TABLE "SPORT_NIVEAU_INSTANCES" ADD CONSTRAINT "SPORT_NIVEAU_INSTANCES_FK1" FOREIGN KEY ("ID_ASSOC")
	  REFERENCES "SPORT_ASSOC" ("ID_ASSOC") ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_SPORT_INS_NIVEAU" 
BEFORE INSERT OR UPDATE ON   SPORT_NIVEAU_INSTANCES 
FOR EACH ROW 
declare 
--cursor c is select id_h from SPORT_NIVEAU_INSTANCES  where ID_ASSOC=:new.id_ASSOC and code_instance=:new.instance_sup ;
BEGIN
   if inserting and :new.ID_NIVEAU is null then
    select nvl(max(ID_NIVEAU),0)+1 into :new.ID_NIVEAU  from SPORT_NIVEAU_INSTANCES  where ID_ASSOC=:new.id_ASSOC;
  end if;
/*if inserting then  
if :new.instance_sup is null then
    :new.id_hp:=null;
    :new.id_H:=:new.code_instance;
 else
    open c; fetch c into :new.id_hp; close c;
    :new.id_h:=:new.id_hp+lpad(:new.code_instance,0,2);
end if;
end if;*/
  
 if inserting and :new.NIVEAU is null then
    select nvl(max(NIVEAU),0)+1 into :new.NIVEAU  from SPORT_NIVEAU_INSTANCES  where ID_ASSOC=:new.id_ASSOC;
  end if;
  :new.dt_maj:=sysdate;

END;
/
ALTER TRIGGER "TRG_SPORT_INS_NIVEAU" ENABLE;
/

CREATE TABLE "SPORT_INSTANCE" 
   (	"CODE_INSTANCE" VARCHAR2(50) NOT NULL ENABLE, 
	"INTITULE" VARCHAR2(300) NOT NULL ENABLE, 
	"NIVEAU" NUMBER NOT NULL ENABLE, 
	"ID_ASSOC" NUMBER NOT NULL ENABLE, 
	"COMMENTAIRE" VARCHAR2(500), 
	"USER_MAJ" VARCHAR2(100) NOT NULL ENABLE, 
	"DT_MAJ" DATE NOT NULL ENABLE, 
	"DATE_CREATION" DATE NOT NULL ENABLE, 
	"EMAIL" VARCHAR2(100), 
	"ADRESSE" VARCHAR2(300), 
	"INSTANCE_SUP" VARCHAR2(50), 
	"ID_H" VARCHAR2(50), 
	"ID_HP" VARCHAR2(50), 
	 CONSTRAINT "SPORT_INSTANCE_PK" PRIMARY KEY ("CODE_INSTANCE", "ID_ASSOC")
  USING INDEX  ENABLE
   ) ;

  ALTER TABLE "SPORT_INSTANCE" ADD CONSTRAINT "SPORT_INSTANCE_FK1" FOREIGN KEY ("NIVEAU", "ID_ASSOC")
	  REFERENCES "SPORT_NIVEAU_INSTANCES" ("ID_NIVEAU", "ID_ASSOC") ENABLE;
  ALTER TABLE "SPORT_INSTANCE" ADD CONSTRAINT "SPORT_INSTANCE_FK2" FOREIGN KEY ("INSTANCE_SUP", "ID_ASSOC")
	  REFERENCES "SPORT_INSTANCE" ("CODE_INSTANCE", "ID_ASSOC") ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "TRIG_SPORT_INST_INSTANCE" 
BEFORE INSERT or update  ON   SPORT_INSTANCE 
FOR EACH ROW 
declare 
cursor c is select id_h from SPORT_INSTANCE  where ID_ASSOC=:new.id_ASSOC and code_instance=:new.instance_sup ;

BEGIN
  if inserting and :new.code_instance is null then
    select nvl(max(to_number(code_instance)),0)+1 into :new.code_instance from SPORT_INSTANCE where ID_ASSOC=:new.id_ASSOC;
  end if;
  :new.dt_maj:=sysdate;
  
  if inserting then  
if :new.instance_sup is null then
    :new.id_hp:=null;
    :new.id_H:=lpad(:new.code_instance,2,0);
 else
    open c; fetch c into :new.id_hp; close c;
    :new.id_h:=:new.id_hp||lpad(:new.code_instance,2,0);
end if;
end if;
END;
/
ALTER TRIGGER "TRIG_SPORT_INST_INSTANCE" ENABLE;

/




  CREATE TABLE "SPORT_TYPE_LICENCE" 
   (	"TYPE_E" VARCHAR2(50) NOT NULL ENABLE, 
	"ID_ASSOC" NUMBER NOT NULL ENABLE, 
	"DATE_MAJ" DATE, 
	"USER_MAJ" VARCHAR2(20), 
	"COUT_UNITE" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT "SPORT_TYPE_E_PK" PRIMARY KEY ("TYPE_E", "ID_ASSOC")

   ) ;

  ALTER TABLE "SPORT_TYPE_LICENCE" ADD CONSTRAINT "SPORT_TYPE_E_FK1" FOREIGN KEY ("ID_ASSOC")
	  REFERENCES "SPORT_ASSOC" ("ID_ASSOC") ENABLE;
/


  CREATE TABLE "SPORT_CATEGORIE" 
   (	"CODE_CATEGORIE" VARCHAR2(50) NOT NULL ENABLE, 
	"AGE_MIN" NUMBER, 
	"AGE_MAX" NUMBER, 
	"ID_ASSOC" NUMBER NOT NULL ENABLE, 
	"DATE_MAJ" DATE, 
	"USER_MAJ" VARCHAR2(20), 
	"COUT_UNITE" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT "SPORT_CATEGORIE_PK" PRIMARY KEY ("CODE_CATEGORIE", "ID_ASSOC")
  USING INDEX  ENABLE
   ) ;

  ALTER TABLE "SPORT_CATEGORIE" ADD CONSTRAINT "SPORT_CATEGORIE_FK1" FOREIGN KEY ("ID_ASSOC")
	  REFERENCES "SPORT_ASSOC" ("ID_ASSOC") ENABLE;
/


  CREATE TABLE "SPORT_JOUEURS" 
   (	"ID_JOUEUR" NUMBER NOT NULL ENABLE, 
	"ID_ASSOC" NUMBER NOT NULL ENABLE, 
	"NOM" VARCHAR2(200) NOT NULL ENABLE, 
	"PRENOMS" VARCHAR2(500) NOT NULL ENABLE, 
	"ID_NIF" VARCHAR2(30), 
	"REF_DOC" VARCHAR2(100), 
	"DATE_DOC" DATE, 
	"DATE_NAISSANCE" DATE NOT NULL ENABLE, 
	"GENRE" VARCHAR2(20) NOT NULL ENABLE, 
	"TEL" VARCHAR2(50) NOT NULL ENABLE, 
	"PERSONNE_PREVENIR" VARCHAR2(100), 
	"PHOTO" BLOB, 
	"NOM_FICHIER" VARCHAR2(500), 
	"MIMETYPE" VARCHAR2(225), 
	"IMAGE_LAST_UPDATE" DATE, 
	"NATIONALITE" VARCHAR2(100) NOT NULL ENABLE, 
	"LIEU_NAISSANCE" VARCHAR2(100) NOT NULL ENABLE, 
	"ID_INSTANCE_ORIG" VARCHAR2(50) NOT NULL ENABLE, 
	"TYPE_DOC" VARCHAR2(50) NOT NULL ENABLE, 
	"VEROUILLE" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	"TYPE_CARAT" VARCHAR2(50), 
	"DT_MAJ" DATE NOT NULL ENABLE, 
	"ORIGINE_DDE" NUMBER NOT NULL ENABLE, 
	"ORIGINE_SAISON" VARCHAR2(50) NOT NULL ENABLE, 
	"PHOTO2" BLOB, 
	"CODE_INSTANCE_DEPART_TRANS" NUMBER, 
	"SAISON_TRANS" VARCHAR2(20), 
	"TYPE_J" NUMBER DEFAULT 1, 
	 CONSTRAINT "SPORT_JOUEURS_PK" PRIMARY KEY ("ID_JOUEUR", "ID_ASSOC")
  USING INDEX  ENABLE
   ) ;
   /
    CREATE TABLE "SPORT_DEMANDE_LICENCE" 
   (	"ID_ASSOC" NUMBER NOT NULL ENABLE, 
	"ID_SAISON" VARCHAR2(100) NOT NULL ENABLE, 
	"ID_INSTANCE" VARCHAR2(50) NOT NULL ENABLE, 
	"ID_DEMNADE" NUMBER NOT NULL ENABLE, 
	"DATE_DDE" DATE NOT NULL ENABLE, 
	"USER_DDE" VARCHAR2(50) NOT NULL ENABLE, 
	"USER_MAJ" VARCHAR2(50) NOT NULL ENABLE, 
	"DATE_MAJ" DATE NOT NULL ENABLE, 
	"FG_ETAT" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	"NBR" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	"COUT_T" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	"QR_CODE" BLOB, 
	"QR_CODE2" BLOB, 
	 CONSTRAINT "DEMANDE_LICENCE_PK" PRIMARY KEY ("ID_DEMNADE", "ID_INSTANCE", "ID_SAISON", "ID_ASSOC")
  USING INDEX  ENABLE
   ) ;
/
 CREATE TABLE "SPORT_UTILISATEUR" 
   (	"ID_USER" NUMBER NOT NULL ENABLE, 
	"USER_CODE" VARCHAR2(200), 
	"ID_ASSOC" NUMBER, 
	"ORGANISATION" NUMBER, 
	"COMPETITION" VARCHAR2(20), 
	"PA" VARCHAR2(20), 
	"LICENCE" VARCHAR2(20), 
	"FINANCES" VARCHAR2(20), 
	"ACTIF" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	"ID_INSTANCE" VARCHAR2(100), 
	"ROW_VERSION_NUMBER" NUMBER, 
	"EMAIL_ADDRESS" VARCHAR2(255), 
	"JUSTIFICATION" VARCHAR2(4000), 
	"CREATED_TRUNC" DATE, 
	"STATUS" VARCHAR2(255), 
	"ACTIONED_BY" VARCHAR2(255), 
	"ACTIONED_REASON" VARCHAR2(4000), 
	"CREATED" TIMESTAMP (6), 
	"CREATED_BY" VARCHAR2(255), 
	"UPDATED" TIMESTAMP (6), 
	"UPDATED_BY" VARCHAR2(255), 
	"NIVEAU" NUMBER, 
	"USER_ROLE" VARCHAR2(10), 
	"PWD" VARCHAR2(100), 
	"PASSWORD" VARCHAR2(50), 
	"NOM" VARCHAR2(200), 
	 CONSTRAINT "T_UTILISATEUR_PK" PRIMARY KEY ("ID_USER")
  USING INDEX  ENABLE, 
	 CONSTRAINT "SPORT_UTILISATEUR_CHK1" CHECK (status in ('pending','approved','declined')) ENABLE, 
	 CONSTRAINT "SPORT_UTILISATEUR_CON" UNIQUE ("USER_CODE")
  USING INDEX  ENABLE
   ) ;
/
  CREATE TABLE "SPORT_SAISON" 
   (	"ID_SAISON" VARCHAR2(50) NOT NULL ENABLE, 
	"INTITULE" VARCHAR2(100) NOT NULL ENABLE, 
	"DATE_DEB" DATE NOT NULL ENABLE, 
	"DATE_FIN" DATE NOT NULL ENABLE, 
	"USER_MAJ" VARCHAR2(50) NOT NULL ENABLE, 
	"DATE_MAJ" DATE NOT NULL ENABLE, 
	"ID_ASSOC" NUMBER NOT NULL ENABLE, 
	 CONSTRAINT "SORT_SAISON_PK" PRIMARY KEY ("ID_SAISON", "ID_ASSOC")
  USING INDEX  ENABLE
   ) ;

  ALTER TABLE "SPORT_SAISON" ADD CONSTRAINT "SPORT_SAISON_FK1" FOREIGN KEY ("ID_ASSOC")
	  REFERENCES "SPORT_ASSOC" ("ID_ASSOC") ENABLE;
/
  CREATE TABLE "SPORT_PERIODE_LICENCE" 
   (	"ID_ASSOC" NUMBER, 
	"ID_SAISON" VARCHAR2(50 CHAR), 
	"DATE_DEBUT" DATE, 
	"DATE_FIN" DATE, 
	"FG_ACTIF" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	"NUM_TEST" NUMBER DEFAULT 0, 
	 CONSTRAINT "SPORT_PERIODE_LICENCE_PK" PRIMARY KEY ("ID_ASSOC", "ID_SAISON")
  USING INDEX  ENABLE
   ) ;
/

  CREATE TABLE "SPORT_LICENCE_SAISON" 
   (	"CODE_SAISON" VARCHAR2(50) NOT NULL ENABLE, 
	"ID_ASSOC" NUMBER NOT NULL ENABLE, 
	"CODE_INSTANCE" VARCHAR2(50) NOT NULL ENABLE, 
	"ID_JOUEUR" NUMBER NOT NULL ENABLE, 
	"CODE_CATEGORIE" VARCHAR2(50), 
	"DATE_ENREG" DATE NOT NULL ENABLE, 
	"DATE_VALIDATION1" DATE, 
	"DATE_VALIDATION2" DATE, 
	"DATE_VALIDATION3" DATE, 
	"USER_VALIDE1" VARCHAR2(100), 
	"USER_VALIDE2" VARCHAR2(100), 
	"USER_VALIDE3" VARCHAR2(100), 
	"FIN_VALIDITE" DATE, 
	"REF_LICENCE" VARCHAR2(100), 
	"CODE_BARRE" VARCHAR2(100), 
	"NOM" VARCHAR2(200) NOT NULL ENABLE, 
	"PENOM" VARCHAR2(250) NOT NULL ENABLE, 
	"DATE_NAIS" DATE NOT NULL ENABLE, 
	"TYPE_DOC" VARCHAR2(100) NOT NULL ENABLE, 
	"NUM_DOC" VARCHAR2(100), 
	"DATE_DOC" DATE, 
	"FG_ETAT" NUMBER NOT NULL ENABLE, 
	"LIEU_NAISS" VARCHAR2(100) NOT NULL ENABLE, 
	"NATIONALITE" VARCHAR2(100) NOT NULL ENABLE, 
	"NIF" VARCHAR2(50), 
	"GENRE" VARCHAR2(20) NOT NULL ENABLE, 
	"ID_DEMNADE" NUMBER NOT NULL ENABLE, 
	"COUT_UNITAIRE" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	"AGE" NUMBER, 
	"REF_PIECE" VARCHAR2(200) DEFAULT '-' NOT NULL ENABLE, 
	"QR_CODE" BLOB, 
	"ADRESSE" VARCHAR2(200), 
	"TEL" VARCHAR2(50), 
	"CODE_INSTANCE_DEPART_TRANS" NUMBER, 
	"TYPE_DEMANDE_LICENCE" VARCHAR2(50), 
	"TYPE_J" NUMBER DEFAULT 1, 
	 CONSTRAINT "SPORT_LICENCE_SAISON_PK" PRIMARY KEY ("CODE_SAISON", "ID_ASSOC", "CODE_INSTANCE", "ID_JOUEUR", "ID_DEMNADE")
  USING INDEX  ENABLE
   ) ;
   
   /
   

  ALTER TABLE "SPORT_PERIODE_LICENCE" ADD CONSTRAINT "SPORT_PERIODE_LICENCE_CON" FOREIGN KEY ("ID_SAISON", "ID_ASSOC")
	  REFERENCES "SPORT_SAISON" ("ID_SAISON", "ID_ASSOC") ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "SPORT_PERIODE_LICENCE_T" 
before
insert or update on "SPORT_PERIODE_LICENCE"
for each row
begin
    IF :new.date_debut is not null and :new.date_fin is not null then
       if  to_date(sysdate) between  trunc(to_date(:new.date_debut)) and trunc (to_date(:new.date_fin)) then
           :new.fg_actif:=1;
       else
         :new.fg_actif:=0;
      end if; 
   else
         :new.fg_actif:=0;
    end if;

end;
/
ALTER TRIGGER "SPORT_PERIODE_LICENCE_T" ENABLE;
/


  ALTER TABLE "SPORT_LICENCE_SAISON" ADD CONSTRAINT "SPORT_LICENCE_SAISON_FK1" FOREIGN KEY ("ID_DEMNADE", "CODE_INSTANCE", "CODE_SAISON", "ID_ASSOC")
	  REFERENCES "SPORT_DEMANDE_LICENCE" ("ID_DEMNADE", "ID_INSTANCE", "ID_SAISON", "ID_ASSOC") ENABLE;
  ALTER TABLE "SPORT_LICENCE_SAISON" ADD CONSTRAINT "SPORT_LICENCE_SAISON_FK2" FOREIGN KEY ("CODE_CATEGORIE", "ID_ASSOC")
	  REFERENCES "SPORT_CATEGORIE" ("CODE_CATEGORIE", "ID_ASSOC") ENABLE;
  ALTER TABLE "SPORT_LICENCE_SAISON" ADD CONSTRAINT "SPORT_LICENCE_SAISON_FK3" FOREIGN KEY ("ID_JOUEUR", "ID_ASSOC")
	  REFERENCES "SPORT_JOUEURS" ("ID_JOUEUR", "ID_ASSOC") ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_SPORT_AFTIN_INS_LICENCE" 
AFTER INSERT OR UPDATE OF FG_ETAT ON SPORT_LICENCE_SAISON 
FOR EACH ROW 
declare
txt varchar2(200);
BEGIN
  if inserting and :new.fg_etat=1 then
    update SPORT_DEMANDE_LICENCE set nbr=nbr+1,cout_t=cout_t+:new.cout_unitaire where id_assoc=:new.id_assoc and id_saison=:new.code_saison 
    and id_instance=:new.code_instance and id_demnade=:new.id_demnade;
 end if;
 
 
   if updating and :new.fg_etat=1 and :old.fg_etat=0 then
    update SPORT_DEMANDE_LICENCE set nbr=nbr+1,cout_t=cout_t+:new.cout_unitaire where id_assoc=:new.id_assoc and id_saison=:new.code_saison 
    and id_instance=:new.code_instance and id_demnade=:new.id_demnade;
 end if;
    if updating and :new.fg_etat=0 and :old.fg_etat=1 then
    update SPORT_DEMANDE_LICENCE set nbr=nbr-1 , cout_t=cout_t-:new.cout_unitaire where id_assoc=:new.id_assoc and id_saison=:new.code_saison 
    and id_instance=:new.code_instance and id_demnade=:new.id_demnade;
  end if;


END;
/



  ALTER TABLE "SPORT_UTILISATEUR" ADD CONSTRAINT "SPORT_UTILISATEUR_FK1" FOREIGN KEY ("ID_INSTANCE", "ID_ASSOC")
	  REFERENCES "SPORT_INSTANCE" ("CODE_INSTANCE", "ID_ASSOC") ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "SPORT_UTILISATEUR_RAS" 
   before insert or update on 
   SPORT_UTILISATEUR 
   for each row
begin
   if :new.id_user is null then
     select nvl(max(id_user),0)+1 into  :new.id_user from SPORT_UTILISATEUR;
   end if;
   :new.email_address := lower(:new.email_address);
   if inserting then
      :new.created    := current_timestamp;
      :new.created_by := lower(nvl(v('APP_USER'),user));
      :new.created_trunc := trunc(current_timestamp);
   end if;
   :new.row_version_number := nvl(:old.row_version_number,0) + 1;
   :new.updated     := current_timestamp;
   :new.updated_by  := lower(nvl(v('APP_USER'),user));
   if updating and :old.status != :new.status then
      :new.actioned_by := lower(nvl(v('APP_USER'),user));
   end if;
end;
/
ALTER TRIGGER "SPORT_UTILISATEUR_RAS" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "T_SPORT_USER" 
  BEFORE INSERT  or update ON SPORT_UTILISATEUR
  for each row 
BEGIN 
  :new.user_CODE := upper(:new.user_CODE); 
  :new.EMAIL_ADDRESS := lower(:new.EMAIL_ADDRESS); 
if (inserting or (updating and :new.PASSWORD!=:old.PASSWORD)  or (updating and :new.PASSWORD is not null and :old.PASSWORD is null)) then
  --:new.password := ENCRYPT_PASSWORD(upper(:new.user_CODE), upper(:new.PASSWORD)); 
  null;
end if;
END;
/
ALTER TRIGGER "T_SPORT_USER" ENABLE;
/



ALTER TRIGGER "TRG_SPORT_AFTIN_INS_LICENCE" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_SPORT_DEFORE_INS" 
BEFORE INSERT OR UPDATE OF DATE_NAIS, fg_etat, date_ENREG,type_doc,num_doc,date_doc ON SPORT_LICENCE_SAISON 
FOR EACH ROW 
declare 
txt varchar2(200);
NB varchar2(50);
cursor c is select code_categorie, age_min, age_max, cout_unite from sport_categorie where id_assoc=:new.id_assoc;
ligne c%rowtype;
BEGIN
  :new.age:=substr(to_char(to_date(sysdate), 'DD/MM/YYYY'),7,4)-substr(to_char(to_date(:new.date_nais), 'DD/MM/YYYY'),7,4);
 if :new.type_j=1 then
  open c; fetch c into ligne;
  while C%found loop
    if  ligne.age_min<= :new.age and :new.age <=ligne.age_max then 
     :new.code_categorie:=ligne.code_categorie;
     :new.cout_unitaire:=ligne.cout_unite; 
    end if;
    fetch c into ligne;
  end loop;
  close c;
  else
    :new.code_categorie:='ENCADREUR';
 end if;
  :new.ref_piece:=:new.type_doc||' '||:new.num_doc||' du '||:new.date_doc;

   if :new.fg_etat=5 and :old.fg_etat!=5 then
    txt:='Licence '||:new.code_categorie ||'délivré à '||:new.nom||' '||:new.penom|| ' né le '||:new.date_nais||' références '||:new.ref_piece ||' le '||:new.date_ENREG||' pour le compte de la saison '||:new.code_saison ;
  --  :new.QR_CODE:=MAKE_QR.qr_bin(txt);

   end if;

END;
/
ALTER TRIGGER "TRG_SPORT_DEFORE_INS" ENABLE;
/
create or replace FUNCTION  "SPORT_RETOURNE_ID_H" 
(
  ID_ASS IN VARCHAR2 
, ID_INS IN VARCHAR2 
) RETURN varchar2 AS 
  cursor k is select I.id_h FROM SPORT_INSTANCE I
where    I.ID_ASSOC=ID_ASS and I.code_instance=ID_INS;
nb varchar2(50);
BEGIN
  open k; fetch k  into nb; close k;
  return nb;
END SPORT_RETOURNE_ID_H;
/
 create or replace FUNCTION  "SPORT_RETOURNE_INSTITULE_INS" 
(
  ID_ASS IN VARCHAR2 
, ID_INS IN VARCHAR2 
) RETURN varchar2 AS 
  cursor k is select I.INTITULE FROM SPORT_INSTANCE I
where    I.ID_ASSOC=ID_ASS and I.code_instance=ID_INS;
nb varchar2(200);
BEGIN
  open k; fetch k  into nb; close k;
  return nb;
END SPORT_RETOURNE_INSTITULE_INS;
/

create or replace FUNCTION  "SPORT_RETOURNE_NIV_INST" 
(
  ID_ASS IN VARCHAR2 
, ID_INS IN VARCHAR2 
) RETURN NUMBER AS 
  cursor k is select N.niveau FROM SPORT_NIVEAU_INSTANCES N ,SPORT_INSTANCE I
where   N.id_assoc=I.id_assoc and I.niveau=N.id_niveau and I.ID_ASSOC=ID_ASS and I.code_instance=ID_INS;
nb number;
BEGIN
  open k; fetch k  into nb; close k;
  return nb;
END SPORT_RETOURNE_NIV_INST;
/

create or replace function "SPORT_RETOURNE_SUP_NIVEAU" (
    ID_ASS in number, ID_INS IN number,  NIV NUMBER  )
return NUMBER
as
    code_ins number;
    cursor c is select instance_sup from sport_instance where id_assoc=ID_ASS and code_instance=code_ins;
    ret number;
begin
    if NIV>=SPORT_RETOURNE_NIV_INST(ID_ASS,ID_INS) then
       return ID_INS;
    end if;
    if NIV<SPORT_RETOURNE_NIV_INST(ID_ASS,ID_INS)  then
       code_ins:=id_ins;
       open c; fetch c into ret; close c;
       if ret is null then ret:=0 ; end if;
       if niv=SPORT_RETOURNE_NIV_INST(ID_ASS,ID_INS)-1 then
         return ret;
       else 
          code_ins:=ret;
           open c; fetch c into ret; close c;
           if ret is null then ret:=0 ; end if;
           if niv=SPORT_RETOURNE_NIV_INST(ID_ASS,ID_INS)-2 then
              return ret;
            else
               code_ins:=ret;
               open c; fetch c into ret; close c;
               if ret is null then ret:=0;  end if;
               if niv=SPORT_RETOURNE_NIV_INST(ID_ASS,ID_INS)-3 then
                 return ret;
                end if;

             end if; 
         end if; 
    end if;
end "SPORT_RETOURNE_SUP_NIVEAU";
/
   
create or replace FUNCTION  "SPORT_NB_NIVEAU" 
(
  ID_AS IN NUMBER 
, NIV IN NUMBER 
, INS IN NUMBER 
) RETURN VARCHAR2 AS 
nivelo number;
cursor c is select count(*) from  SPORT_NIVEAU_INSTANCES N1 ,SPORT_INSTANCE I1
where   N1.id_assoc=I1.id_assoc and  N1.id_assoc=ID_AS and 
 I1.niveau=N1.id_niveau  and N1.niveau=niv and to_number(substr(I1.id_h,(2*nivelo)-1,2))=ins ;
 cursor D is select  N1.intitule  FROM SPORT_NIVEAU_INSTANCES N1 where N1.id_assoc=ID_AS and  N1.niveau=niv;
 nb number;
 inti varchar2(200);
  
BEGIN
  nivelo:=SPORT_RETOURNE_NIV_INST (ID_AS, INS );
   open c; fetch c into nb; close c;
   open D; fetch d into inti; close D;
   if inti is null then 
   return '-';
   else
   return nb||' '||inti;
   end if;

END SPORT_NB_NIVEAU;
/
   
  create or replace function "MAX_SAISON"(ID_AS number)
return varchar2
as
 
   ret varchar2(20);
begin
    select max (id_saison)  into ret from sport_saison where id_assoc=id_as;
    return ret;
end "MAX_SAISON";
/


  ALTER TABLE "SPORT_JOUEURS" ADD CONSTRAINT "SPORT_JOUEURS_FK1" FOREIGN KEY ("ID_ASSOC")
	  REFERENCES "SPORT_ASSOC" ("ID_ASSOC") ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_SPORT_AFTER_INS_JOUEUR" 
AFTER DELETE OR INSERT OR UPDATE OF ID_INSTANCE_orig,origine_DDE,DATE_DOC,type_j,DATE_NAISSANCE,DT_MAJ,GENRE,ID_NIF,LIEU_NAISSANCE,MIMETYPE,NATIONALITE,NOM,PERSONNE_PREVENIR,PRENOMS,REF_DOC,TEL,TYPE_CARAT,TYPE_DOC ON SPORT_JOUEURS 
FOR EACH ROW 
BEGIN
 if inserting then
    insert into SPORT_LICENCE_SAISON(CODE_SAISON,ID_ASSOC,CODE_INSTANCE,ID_JOUEUR,DATE_ENREG,NOM,PENOM,DATE_NAIS,
    TYPE_DOC,NUM_DOC,DATE_DOC,FG_ETAT,LIEU_NAISS,NATIONALITE,NIF,GENRE,ID_DEMNADE,TEL, type_J)
    values(:new.origine_saison,:new.ID_ASSOC,:new.ID_INSTANCE_orig,:new.ID_JOUEUR,sysdate,:new.NOM,:new.PRENOMS,:new.DATE_NAISSANCE,
    :new.TYPE_DOC,:new.REF_DOC,:new.DATE_DOC,1,:new.LIEU_NAISSANCE,:new.NATIONALITE,:new.ID_NIF,:new.GENRE,:new.origine_DDE,:new.TEL, :new.type_j);
 end if;
 
  if updating and  :new.verouille=0 and :new.ID_INSTANCE_orig=:old.ID_INSTANCE_orig    then
  update SPORT_LICENCE_SAISON set type_j=:new.type_j,
   NOM=:new.NOM,PENOM=:new.PRENOMS,DATE_NAIS=:new.DATE_NAISSANCE,
    TYPE_DOC=:new.TYPE_DOC,NUM_DOC=:new.REF_DOC,DATE_DOC=:new.DATE_DOC,
    LIEU_NAISS=:new.LIEU_NAISSANCE,NATIONALITE=:new.NATIONALITE,NIF=:new.ID_NIF,GENRE=:new.GENRE,TEL=:new.TEL
    where CODE_SAISON=:new.origine_saison and ID_ASSOC=:new.ID_ASSOC and CODE_INSTANCE= :new.ID_INSTANCE_orig and 
    ID_DEMNADE=:new.origine_DDE and ID_JOUEUR=:new.ID_JOUEUR and fg_etat<2;
 end if;
  
  if updating  and :new.ID_INSTANCE_orig!=:old.ID_INSTANCE_orig    then
  update SPORT_LICENCE_SAISON set  CODE_INSTANCE= :new.ID_INSTANCE_orig ,    ID_DEMNADE=:new.origine_DDE, code_saison=:new.saison_trans, fg_etat=1,
   NOM=:new.NOM,PENOM=:new.PRENOMS,DATE_NAIS=:new.DATE_NAISSANCE, type_j=:new.type_j,
    TYPE_DOC=:new.TYPE_DOC,NUM_DOC=:new.REF_DOC,DATE_DOC=:new.DATE_DOC,NIF=:new.ID_NIF,TEL=:new.TEL
    where CODE_SAISON=:new.saison_trans and ID_ASSOC=:new.ID_ASSOC ;
 end if;
  

END;
/

ALTER table sport_assoc ADD(default_img blob);

/
ALTER TRIGGER "TRG_SPORT_AFTER_INS_JOUEUR" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_SPORT_INS_JOUEURS" 
BEFORE INSERT OR UPDATE ON SPORT_JOUEURS 
FOR EACH ROW 
declare 
   vSizedImage blob;
BEGIN

  if inserting and :new.ID_joueur is null then
    select nvl(max(ID_joueur),0)+1 into :new.ID_joueur from SPORT_JOUEURS where id_assoc=:new.id_assoc;
  end if;
  :new.dt_maj:=sysdate;
  :new.nom:=upper(:new.nom);
    :new.prenoms:=upper(:new.prenoms);

  if   :new.photo is null  then
      select default_img into  :new.photo from sport_assoc;
   end if;

   -- DBMS_Lob.createTemporary(vSizedImage, FALSE, DBMS_LOB.CALL);

 -- ORDSYS.OrdImage.processCopy(:new.photo, 'maxScale=75 75', vSizedImage);
 -- :new.photo:=vSizedImage;

END;
/
ALTER TRIGGER "TRG_SPORT_INS_JOUEURS" ENABLE;
/


 
  ALTER TABLE "SPORT_DEMANDE_LICENCE" ADD CONSTRAINT "SPORT_DEMANDE_LICENCE_FK1" FOREIGN KEY ("ID_SAISON", "ID_ASSOC")
	  REFERENCES "SPORT_SAISON" ("ID_SAISON", "ID_ASSOC") ENABLE;
  ALTER TABLE "SPORT_DEMANDE_LICENCE" ADD CONSTRAINT "SPORT_DEMANDE_LICENCE_FK2" FOREIGN KEY ("ID_INSTANCE", "ID_ASSOC")
	  REFERENCES "SPORT_INSTANCE" ("CODE_INSTANCE", "ID_ASSOC") ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "SPORT_AFTER_INS_DDE_LICENCE" 
AFTER INSERT ON SPORT_DEMANDE_LICENCE 
FOR EACH ROW 
BEGIN
if :new.ID_DEMNADE=1 then
     insert into SPORT_LICENCE_SAISON(CODE_SAISON,ID_ASSOC,CODE_INSTANCE,ID_JOUEUR,DATE_ENREG,NOM,PENOM,DATE_NAIS,
     TYPE_DOC,NUM_DOC,DATE_DOC,FG_ETAT,LIEU_NAISS,NATIONALITE,NIF,GENRE,ID_DEMNADE)
     select :new.id_saison ,ID_ASSOC,CODE_INSTANCE,ID_JOUEUR,sysdate,NOM,PENOM,DATE_NAIS,
     TYPE_DOC,NUM_DOC,DATE_DOC,1,LIEU_NAISS,NATIONALITE,NIF,GENRE,:new.ID_DEMNADE
     from SPORT_LICENCE_SAISON where  CODE_SAISON=(select min(id_saison) from sport_saison where id_assoc=:new.id_assoc and id_saison!=:new.id_saison)
     and ID_ASSOC=:new.id_assoc and CODE_INSTANCE=:new.id_instance;
  end if;
  
  if :new.ID_DEMNADE>1 then
     insert into SPORT_LICENCE_SAISON(CODE_SAISON,ID_ASSOC,CODE_INSTANCE,ID_JOUEUR,DATE_ENREG,NOM,PENOM,DATE_NAIS,
     TYPE_DOC,NUM_DOC,DATE_DOC,FG_ETAT,LIEU_NAISS,NATIONALITE,NIF,GENRE,ID_DEMNADE)
     select :new.id_saison ,ID_ASSOC,CODE_INSTANCE,ID_JOUEUR,sysdate,NOM,PENOM,DATE_NAIS,
     TYPE_DOC,NUM_DOC,DATE_DOC,1,LIEU_NAISS,NATIONALITE,NIF,GENRE,:new.ID_DEMNADE
     from SPORT_LICENCE_SAISON where  CODE_SAISON=(select min(id_saison) from sport_saison where id_assoc=:new.id_assoc and id_saison!=:new.id_saison)
     and ID_ASSOC=:new.id_assoc and CODE_INSTANCE=:new.id_instance and id_demnade=:new.id_demnade-1 ;
  end if;
END;
/
ALTER TRIGGER "SPORT_AFTER_INS_DDE_LICENCE" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "SPORT_INS_DDE_LICENCE" 
BEFORE INSERT OR UPDATE ON SPORT_DEMANDE_LICENCE 
FOR EACH ROW 
declare txt varchar2(200);
 
BEGIN
  if inserting and :new.ID_DEMNADE is null then
    select nvl(max(ID_DEMNADE),0)+1 into :new.ID_DEMNADE from SPORT_DEMANDE_LICENCE where id_assoc=:new.id_assoc
    and id_saison=:new.id_saison and id_instance=:new.id_instance;
  end if;
   :new.date_maj:=sysdate;
   :new.date_DDE:=sysdate;
   :new.USER_MAJ:=user;
   :new.USER_DDE:=user;
  if :new.fg_etat in (2) then 
    txt:='Reqettes de licence formulée par '||SPORT_RETOURNE_INSTITULE_INS (:new.id_assoc,:new.id_instance) ||' le '||:new.date_DDE||' pour le compte de la saison '||:new.id_saison ||' par l''utilisateur '||:new.USER_MAJ;
    -- :new.QR_CODE:=MAKE_QR.qr_bin(txt);
   end if;

   if updating  and :new.fg_etat>1 and :new.fg_etat!=:old.fg_etat then
      select count(*)  as nb into :new.nbr from sport_licence_saison where id_assoc=:new.id_assoc   and code_saison=:new.id_saison and code_instance=:new.id_instance and id_demnade=:new.ID_DEMNADE and fg_etat=:new.fg_etat;
      :new.cout_t:=:new.nbr*500;
    end if;

END;
/
ALTER TRIGGER "SPORT_INS_DDE_LICENCE" ENABLE;
/


create or replace procedure "TYPE_DEMANDE_LICENCE_OK"(ID_AS number,ID_SAI varchar2,inst2 number )

as
 OLd_SAI  varchar2(20);
 inst1 number;
 ret varchar2(50);

 cat1 varchar2(50);
  cat2 varchar2(50);
 cursor d is select id_joueur, code_categorie from SPORT_licence_saison where id_assoc=id_as and code_saison=ID_SAI and code_instance=inst2;
 id_j number;
 cursor E is select code_categorie,code_instance from SPORT_licence_saison where id_assoc=id_as and code_saison=old_sai and id_joueur=id_j;
 --cursor d is select code_categorie,code_instance from SPORT_licence_saison where id_assoc=id_as and code_saison=ID_SAI and id_joueur=id_j;
begin
 OLd_SAI := substr(ID_SAI,1,4)-1||'-'||substr(ID_SAI,1,4);
open d; fetch d into id_j, cat2;

while d%found loop
    open E; fetch E into cat1, inst1; close E;
    if cat1 is null  then
      ret:='Nouveau joueur';
    elsif cat1 is not null and inst1 is  not null  and inst1!=inst2 then
      ret:='Transfert';
     elsif cat1 is not null and inst1 is  not null  and cat1!=cat2  and inst1=inst2 then
       ret:='Changement Categorie';
     elsif cat1 is not null and inst1 is  not null  and cat1=cat2  and inst1=inst2 then
       ret:='Renouvellement';  
     else 
        ret:='inconnu';  
     end if;
     update SPORT_licence_saison set TYPE_DEMANDE_LICENCE=ret 
     where id_assoc=id_as and code_saison=ID_SAI and code_instance=inst2 and id_joueur=id_j;
     commit;
     fetch d into id_j, cat2;
     end  loop;
     close d;
end "TYPE_DEMANDE_LICENCE_OK";
/


create or replace FUNCTION  "SPORT_RETOURNE_INSTITULE_INS" 
(
  ID_ASS IN VARCHAR2 
, ID_INS IN VARCHAR2 
) RETURN varchar2 AS 
  cursor k is select I.INTITULE FROM SPORT_INSTANCE I
where    I.ID_ASSOC=ID_ASS and I.code_instance=ID_INS;
nb varchar2(200);
BEGIN
  open k; fetch k  into nb; close k;
  return nb;
END SPORT_RETOURNE_INSTITULE_INS;
/

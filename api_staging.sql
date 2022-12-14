CREATE TABLE API_STAGING (
  STAGING_PK NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 2002700 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	SCHEMA_NAME VARCHAR2(30 BYTE), 
	API_NAME VARCHAR2(100 BYTE), 
	API_MODULE VARCHAR2(100 BYTE), 
	DATA_TYPE VARCHAR2(100 BYTE), 
	ACTION VARCHAR2(100 BYTE), 
	ACTION_DATE TIMESTAMP (6) WITH TIME ZONE, 
	BASE_URL VARCHAR2(4000 BYTE), 
	APPEND VARCHAR2(4000 BYTE), 
	URL VARCHAR2(4000 BYTE), 
	STATUS_CODE VARCHAR2(10 BYTE), 
	REQUEST_HEADERS CLOB, 
	RESPONSE_HEADERS CLOB, 
	JSON_RESPONSE CLOB, 
	HTTP_RESPONSE CLOB, 
	BODY CLOB, 
	DELETE_OK TIMESTAMP (6) WITH TIME ZONE, 
	CREATED_ON TIMESTAMP (6) WITH TIME ZONE, 
	AUTH_TOKEN VARCHAR2(2000 CHAR), 
	NEW_TOKEN NUMBER DEFAULT 0, 
	ROWS_FETCHED NUMBER, 
	START_DATE DATE, 
	END_DATE DATE, 
	DURATION_SEC NUMBER, 
	API_USER VARCHAR2(50 CHAR), 
	URL_NEXT VARCHAR2(4000 CHAR), 
	HITS_PER_MINUTE NUMBER, 
	HITS_PER_DAY NUMBER, 
	CONSTRAINT API_STAGING_PK PRIMARY KEY (STAGING_PK)USING INDEX 
	);

COMMENT ON TABLE API_STAGING  IS 'Staging Table and errors from all API';
CREATE INDEX API_STAGING_IDX01 ON API_STAGING (API_NAME) ;
CREATE INDEX API_STAGING_IDX02 ON API_STAGING (API_MODULE) ;
CREATE INDEX API_STAGING_IDX03 ON API_STAGING (DATA_TYPE) ;
CREATE INDEX API_STAGING_IDX04 ON API_STAGING (SYS_EXTRACT_UTC(ACTION_DATE)) ;
CREATE INDEX API_STAGING_IDX05 ON API_STAGING (STATUS_CODE) ;

CREATE OR REPLACE EDITIONABLE TRIGGER API_STAGING_BIU_TRIG 
	before insert or update on API_STAGING
	for each row 
begin
	if inserting then
		select api_staging_seq.nextval into :new.STAGING_PK from dual;
		:new.created_on  :=  systimestamp;
	end if;
end;

/
ALTER TRIGGER API_STAGING_BIU_TRIG ENABLE;

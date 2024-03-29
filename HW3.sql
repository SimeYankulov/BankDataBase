/*
1. A package to serve user registration (login). For
the goal should be to build a separate table, with users, like
the user-client relationship must be 1:1. The password should be
hashed.
*/
DROP TABLE BANK_USER;
CREATE TABLE BANK_USER (
        USER_ID NUMBER GENERATED ALWAYS AS IDENTITY,
        USERNAME VARCHAR2(50),
        USER_PASSWORD VARCHAR2(50),
        LAST_LOGIN_DATE DATE,
        LAST_UPDATE DATE,
        CUSTOMER_ID NUMBER NOT NULL ENABLE,
        CONSTRAINT FK_CUSTOMER_ID FOREIGN KEY(CUSTOMER_ID)
        REFERENCES BANK_CUSTOMER(CUSTOMER_ID)
);

CREATE OR REPLACE PACKAGE USER_OPERATIONS 
AS
    FUNCTION REGISTER_USER( P_USER USER_TYPE)
                RETURN VARCHAR2; 
     
    FUNCTION LOGIN_USER( P_USER USER_TYPE)
                RETURN VARCHAR2;
 
END USER_OPERATIONS; 

CREATE OR REPLACE PACKAGE BODY USER_OPERATIONS AS
    FUNCTION REGISTER_USER( P_USER USER_TYPE)
                            RETURN VARCHAR2
    IS 
      FIND NUMBER;
    BEGIN
          SELECT COUNT(*) INTO FIND
          FROM BANK_CUSTOMER
          WHERE CUSTOMER_ID =P_USER.CUSTOMER_ID;
          
          IF(FIND = 1) THEN 
            BEGIN
                INSERT INTO BANK_USER(USERNAME,
                                      user_PASSWORD,
                                      LAST_LOGIN_DATE,
                                      LAST_UPDATE,
                                     CUSTOMER_ID)
                VALUES(P_USER.USERNAME,
                        ORA_HASH(P_USER.PASWORD),
                        SYSDATE,
                        SYSDATE,
                        P_USER.CUSTOMER_ID);
                COMMIT;
                RETURN 'CUSTOMER SUCCESFULLY REGISTERED IN THE SYSTEM';
                END;
            ELSE 
             RETURN 'INVALID USER';
         END IF;
    END REGISTER_USER;
    
    FUNCTION LOGIN_USER( P_USER USER_TYPE) RETURN VARCHAR2
    IS
        FIND NUMBER;
    BEGIN 
        SELECT COUNT(*) INTO FIND
        FROM BANK_USER
        WHERE USERNAME = P_USER.USERNAME
        AND USER_PASSWORD = ORA_HASH(P_USER.PASWORD);
        
        IF(FIND = 1) THEN
                UPDATE BANK_USER
                SET LAST_LOGIN_DATE = SYSDATE
                WHERE USERNAME = P_USER.USERNAME;
                
                RETURN 'LOG IN SUCCESSFUL FOR '|| P_USER.USERNAME;
            ELSE 
                RETURN 'INVALID CREDENTIALS';
            END IF; 
            
    END LOGIN_USER;
    
END USER_OPERATIONS;


CREATE OR REPLACE TYPE USER_TYPE AS OBJECT 
(
  USER_ID NUMBER,
  USERNAME VARCHAR(50),
  PASWORD  VARCHAR(50),
  CUSTOMER_ID NUMBER  
);
SET SERVEROUTPUT ON;
DECLARE 
  L_USER USER_TYPE;
  L_RETURN_MESSAGE VARCHAR2(100);
BEGIN
  L_USER := USER_TYPE(1,'TEST_USERNAME','TEST_PASSWORD',14);

  --L_RETURN_MESSAGE := USER_OPERATIONS.REGISTER_USER(L_USER);
   L_RETURN_MESSAGE := USER_OPERATIONS.LOGIN_USER(L_USER);
  
  dbms_output.put_line(L_RETURN_MESSAGE);
END;
SELECT * FROM BANK_USER;

/*
2. Functionality through a Scheduled job to intercept
users who have not logged into the application
the last 3 months and save them in a separate table. Frequency
per performance once a day.
*/

DECLARE 
  L_USER USER_TYPE;
  L_RETURN_MESSAGE VARCHAR2(100);
BEGIN
  L_USER := USER_TYPE(1,'DAVID_TAYLOR','TEST_PASSWORD',12);

  L_RETURN_MESSAGE := USER_OPERATIONS.REGISTER_USER(L_USER);
   --L_RETURN_MESSAGE := USER_OPERATIONS.LOGIN_USER(L_USER);
  
  dbms_output.put_line(L_RETURN_MESSAGE);
END;
SELECT * FROM BANK_USER;
UPDATE BANK_USER SET 
    LAST_LOGIN_DATE = SYSDATE - 90
    WHERE CUSTOMER_ID = 12;

CREATE TABLE INACTIVE_USER(
    USER_ID NUMBER,
    USERNAME VARCHAR2(50),
    LAST_LOGIN_DATE DATE
)

CREATE OR REPLACE PROCEDURE FIND_INACTIVE_USERS AS
BEGIN
    DELETE  FROM INACTIVE_USER;
    
    INSERT INTO INACTIVE_USER(USER_ID,USERNAME,LAST_LOGIN_DATE)
    SELECT USER_ID,USERNAME,LAST_LOGIN_DATE
    FROM BANK_USER
    WHERE LAST_LOGIN_DATE < SYSDATE - 90;
END ;

BEGIN
    DBMS_SCHEDULER.CREATE_JOB(
        JOB_NAME        => 'FIND_INACTIVE_USERS_JOB',
        JOB_TYPE        => 'PLSQL_BLOCK',
        JOB_ACTION      => 'BEGIN FIND_INACTIVE_USERS; END;',
        START_DATE      => SYSTIMESTAMP,
        REPEAT_INTERVAL => 'FREQ = DAILY; INTERVAL = 1',
        ENABLED         => FALSE
    );
END;

SELECT * FROM BANK_USER;

SELECT * FROM INACTIVE_USER;
/*
3. A package of CRUD operations to handle users who
use the app.
*/
CREATE OR REPLACE PACKAGE USER_CRUD
AS 
    PROCEDURE CREATE_USER(NEW_USER USER_TYPE);
    PROCEDURE READ_USER(P_USER_ID NUMBER);
    PROCEDURE UPDATE_USER(UPDATED_USER USER_TYPE);
    PROCEDURE DELETE_USER(P_USER_ID NUMBER);
END USER_CRUD;


CREATE OR REPLACE PACKAGE BODY USER_CRUD AS
    PROCEDURE CREATE_USER(NEW_USER USER_TYPE) IS
    BEGIN 
        INSERT INTO BANK_USER(USERNAME,
                            USER_PASSWORD,
                            LAST_LOGIN_DATE,
                            LAST_UPDATE,
                            CUSTOMER_ID)
                    VALUES(NEW_USER.USERNAME,
                           ORA_HASH(NEW_USER.PASWORD),
                           SYSDATE,SYSDATE,
                           NEW_USER.CUSTOMER_ID);
           COMMIT;
           dbms_output.put_line('User created succesfully');
    END CREATE_USER;

    PROCEDURE READ_USER(P_USER_ID NUMBER)
    AS
        L_USERNAME VARCHAR2(50);
        L_CUSTOMER_ID NUMBER;
        L_LAST_LOGIN DATE;
        L_LAST_UPDATE DATE;
    BEGIN 
        SELECT USERNAME,LAST_LOGIN_DATE,LAST_UPDATE,CUSTOMER_ID
        INTO  L_USERNAME,L_LAST_LOGIN, L_LAST_UPDATE, L_CUSTOMER_ID
        FROM BANK_USER WHERE USER_ID = P_USER_ID;
        
        DBMS_OUTPUT.PUT_LINE('USER : '||L_USERNAME);
        DBMS_OUTPUT.PUT_LINE('CUSTOMER :' || L_CUSTOMER_ID);
        DBMS_OUTPUT.PUT_LINE('LAST LOGIN : '||L_LAST_LOGIN);
        DBMS_OUTPUT.PUT_LINE('LAST UPDATE :' ||L_LAST_UPDATE);
    END READ_USER;
    
    PROCEDURE UPDATE_USER(UPDATED_USER USER_TYPE)
    IS
    BEGIN
        UPDATE BANK_USER
        SET USERNAME = UPDATED_USER.USERNAME,
            USER_PASSWORD = ORA_HASH(UPDATED_USER.PASWORD),
            LAST_UPDATE = SYSDATE
        WHERE CUSTOMER_ID = UPDATED_USER.CUSTOMER_ID;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('USER UPDATED');        
    END UPDATE_USER;
    
    PROCEDURE DELETE_USER(P_USER_ID NUMBER)
    IS 
    BEGIN
        DELETE BANK_USER
        WHERE USER_ID = P_USER_ID;
        
        DBMS_OUTPUT.PUT_LINE('USER DELETED');
    END DELETE_USER;
END USER_CRUD;
 
SET SERVEROUTPUT ON;
DECLARE 
  L_USER USER_TYPE;
BEGIN
  L_USER := USER_TYPE(1,'TEST_UPDATED_USERNAME','TEST_PASSWORD',14);
  
  --USER_CRUD.CREATE_USER(L_USER);
  --USER_CRUD.READ_USER(2);
  --USER_CRUD.UPDATE_USER(L_USER);
  --USER_CRUD.READ_USER(2);
  USER_CRUD.DELETE_USER(2);
END;    
SELECT * FROM BANK_USER;
/*
4. Scheduled job to monitor users who have not switched
your password last 3 months and prepare them for
notification. Frequency of execution once a day.
*/
CREATE TABLE NOT_UPDATED_USER(
    USER_ID NUMBER,
    USERNAME VARCHAR2(50),
    LAST_UPDATE DATE
);
CREATE OR REPLACE PROCEDURE FIND_NOT_UPDATED_USERS AS 
BEGIN
    DELETE FROM NOT_UPDATED_USER;
    
    INSERT INTO NOT_UPDATED_USER (USER_ID,USERNAME,LAST_UPDATE) 
    SELECT USER_ID,USERNAME,LAST_UPDATE
    FROM BANK_USER
    WHERE LAST_UPDATE < SYSDATE - 90 ;
END;

BEGIN
    DBMS_SCHEDULER.CREATE_JOB(
        JOB_NAME        => 'FIND_NOT_UPDATED_USERS_JOB',
        JOB_TYPE        => 'PLSQL_BLOCK',
        JOB_ACTION      => 'BEGIN FIND_NOT_UPDATED_USERS; END;',
        START_DATE      => SYSTIMESTAMP,
        REPEAT_INTERVAL => 'FREQ = DAILY; INTERVAL = 1',
        ENABLED         => FALSE
    );
END;

SELECT * FROM BANK_USER;

UPDATE BANK_USER 
SET LAST_UPDATE = SYSDATE - 90
WHERE USER_ID = 4;

SELECT * FROM NOT_UPDATED_USER;
/*
5. Scheduled job to monitor availability on the accounts and yes
updates each customer's status to “VIP” when the value
becomes greater than 100000.
*/

CREATE OR REPLACE PROCEDURE UPDATE_VIP_STATUS AS
    type customer_id_arr is table of number index by pls_integer;
    L_CUSTOMER_ID customer_id_arr;
    SUM_ACCOUNTS FLOAT := 0;
    BEGIN 
        select distinct customer_id
        bulk collect into l_customer_id
        from bank_account;

        for i in 1..l_customer_id.count loop
            SELECT SUM(
                        
                        CASE 
                            WHEN CURRENCY = 'BGN' THEN BALANCE
                            ELSE EXCHANGE_CURRENCY(CURRENCY,'BGN',BALANCE)
                        END
                        ) INTO SUM_ACCOUNTS 
                        FROM BANK_ACCOUNT
                        WHERE  CUSTOMER_ID = L_CUSTOMER_ID(i);
        
        IF SUM_ACCOUNTS > 100000 THEN 
                UPDATE BANK_CUSTOMER
                SET STATUS = 'VIP'
                WHERE CUSTOMER_ID = L_CUSTOMER_ID(i);
        
        END IF;
        end loop;
END;

BEGIN
    DBMS_SCHEDULER.CREATE_JOB(
        JOB_NAME    => 'UPDATE_VIP_STATUS_JOB',
        JOB_TYPE    => 'PLSQL_BLOCK',
        JOB_ACTION  => 'BEGIN UPDATE_VIP_STATUS(); END;',
        START_DATE      => SYSTIMESTAMP,
        REPEAT_INTERVAL => 'FREQ = DAILY; INTERVAL = 1',
        ENABLED         => FALSE
    );
END;

SELECT * FROM BANK_CUSTOMER;

UPDATE BANK_CUSTOMER 
SET STATUS = ' '  

CALL UPDATE_VIP_STATUS();
commit;

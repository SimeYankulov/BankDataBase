/*
1. Create a trigger that automatically updates the status of a customer in
the database when the total balance of their accounts passes
certain threshold. If the customer's total balance exceeds
100,000 BGN, his status must be updated to "VIP
customer". 
This trigger will ensure that important customers are
identify and serve appropriately.
*/
alter table bank_customer
add  status varchar(15);

SELECT * FROM BANK_ACCOUNT WHERE CUSTOMER_ID = 12;

CREATE OR REPLACE PROCEDURE SET_CUSTOMER_VIP_STATUS(P_CUSTOMER_ID NUMBER)
AS
BEGIN
    UPDATE BANK_CUSTOMER
    SET STATUS = 'VIP'
    WHERE CUSTOMER_ID = P_CUSTOMER_ID;
END;

COMMIT;
SELECT * FROM BANK_CUSTOMER;


CREATE OR REPLACE TRIGGER CUSTOMER_VIP_STATUS 
BEFORE INSERT OR UPDATE OF BALANCE 
    ON BANK_ACCOUNT
    FOR EACH ROW 
    DECLARE
    L_CUSTOMER_ID NUMBER;
    SUM_ACCOUNTS FLOAT := 0;
    BEGIN 
        FOR CUST IN (SELECT DISTINCT CUSTOMER_ID
                        FROM BANK_ACCOUNT
                        WHERE CUSTOMER_ID IN (SELECT DISTINCT CUSTOMER_ID 
                                                FROM BANK_ACCOUNT)) 
                                                
        SELECT SUM(
                    
                    CASE 
                        WHEN : NEW.CURRENCY = 'BGN' THEN :NEW.BALANCE
                        ELSE EXCHANGE_CURRENCY(:OLD.CURRENCY,'BGN',:NEW.BALANCE)
                    END
                    ) INTO SUM_ACCOUNTS 
                    FROM BANK_ACCOUNT
                    WHERE  CUSTOMER_ID = L_CUSTOMER_ID;
        
        IF SUM_ACCOUNTS > 100000 THEN 
            L_CUSTOMER_ID := :OLD.CUSTOMER_ID;
            SET_CUSTOMER_VIP_STATUS(L_CUSTOMER_ID);
        
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: '|| SQLERRM);
    
    END;  
        

    
SELECT * FROM BANK_ACCOUNT
WHERE CUSTOMER_ID=12;    
            UPDATE BANK_ACCOUNT 
            SET BALANCE=1000124
            WHERE B_ACCOUNT = 'BGN2';
    SELECT * FROM BANK_CUSTOMER;
UPDATE 
commit;

      SELECT SUM(
                    
                    CASE 
                        WHEN CURRENCY = 'BGN' THEN BALANCE
                        ELSE EXCHANGE_CURRENCY(CURRENCY,'BGN',BALANCE)
                    END
                    ) 
                    FROM BANK_ACCOUNT 
                    WHERE CUSTOMER_ID = 12;
/*
2. Rewrite the functionality from the first project (home
work 1), which monitors the movement of employees between departments,
to work with triggers.

*/
CREATE OR REPLACE TRIGGER BANK_MIGRATION_TRIGGER
AFTER UPDATE 
    ON BANK_EMPLOYEE
    FOR EACH ROW 
    BEGIN 
        IF :OLD.DEPARTMENT_ID <> :NEW.DEPARTMENT_ID THEN
        INSERT INTO BANK_EMPLOYEE_MIGRATION
        (EMPLOYEE_ID,
        OLD_DEPARTMENT_ID,
        NEW_DEPARTMENT_ID,MIGRATION_DATE)
        VALUES( :NEW.EMPLOYEE_ID,
                :OLD.DEPARTMENT_ID,
                :NEW.DEPARTMENT_ID,
                sysdate);
        END IF;
    END;


/*
3. Create fetch, add, delete functions/procedures
and changing account details.

*/
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE PRINT_BANK_ACCOUNT_DATA(p_b_account varchar2)
is
    L_B_ACCOUNT varchar2(30);
    L_BALANCE   FLOAT;
    L_CURRENCY  VARCHAR2(3);
    L_TITLE     VARCHAR2(30);
    L_CUSTOMER_ID NUMBER;
BEGIN
    SELECT B_ACCOUNT,BALANCE,CURRENCY,TITLE,CUSTOMER_ID
    into l_b_account,L_BALANCE,L_CURRENCY,L_TITLE,L_CUSTOMER_ID
    FROM BANK_ACCOUNT 
    WHERE 
    p_b_account = b_account;
       DBMS_OUTPUT.PUT_LINE('Bank Account: '||L_b_account);
    DBMS_OUTPUT.PUT_LINE('Balance: '||L_BALANCE);
    DBMS_OUTPUT.PUT_LINE('Curency : '|| L_CURRENCY);
    DBMS_OUTPUT.PUT_LINE('Title : '|| L_TITLE);
    DBMS_OUTPUT.PUT_LINE('Customer ID : '|| L_CUSTOMER_ID);

       EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No bank accoun was found with the specified ID.');
END;
;
CALL print_bank_account_data('USD1');

CREATE OR REPLACE PROCEDURE ADD_BANK_ACCOUNT(
    P_B_ACCOUNT VARCHAR2,
    P_BALANCE FLOAT,
    P_CURRENCY VARCHAR2,
    P_TITLE VARCHAR2,
    P_CUSTOMER_ID NUMBER
    )
    as
    BEGIN
    INSERT INTO BANK_ACCOUNT(B_ACCOUNT, BALANCE, CURRENCY, TITLE, CUSTOMER_ID)
    VALUES(P_B_ACCOUNT,P_BALANCE,P_CURRENCY,P_TITLE,P_CUSTOMER_ID);
    END;

CALL ADD_BANK_ACCOUNT('BGN2',214,'BGN','David account BGN',12);
CALL print_bank_account_data('BGN2');

CREATE OR REPLACE PROCEDURE DELETE_BANK_ACCOUNT(BANK_ACC VARCHAR)
AS 
BEGIN
    DELETE FROM BANK_ACCOUNT WHERE B_ACCOUNT = BANK_ACC;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No bank accoun was found with the specified ID.');
END;

CALL DELETE_BANK_ACCOUNT('BGN2');

CREATE OR REPLACE PROCEDURE EDIT_BANK_ACCOUNT(
    P_B_ACCOUNT VARCHAR2,
    P_BALANCE FLOAT,
    P_CURRENCY VARCHAR2,
    P_TITLE VARCHAR2,
    P_CUSTOMER_ID NUMBER
    )
    AS 
    BEGIN
        UPDATE BANK_ACCOUNT 
        SET 
            BALANCE =  P_BALANCE,
            CURRENCY = P_CURRENCY,
            TITLE = P_TITLE,
            CUSTOMER_ID = P_CUSTOMER_ID
         WHERE 
            B_ACCOUNT = P_B_ACCOUNT;
        
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END;

CALL EDIT_BANK_ACCOUNT('BGN2',215,'BGN','David account BGN',12);

/*
4. Create fetch, add, delete functions/procedures
and changing customer details.
*/

CREATE OR REPLACE PROCEDURE PRINT_BANK_CUSTOMER_DATA
    (P_CUSTOMER_ID NUMBER)
is
    L_FNAME     VARCHAR2(30);
    L_MNAME     VARCHAR2(30);
    L_LNAME     VARCHAR2(30);
    L_ADDRESS   VARCHAR2(50);
    L_PHONE     VARCHAR2(30);
    L_EMAIL     VARCHAR2(30);
    L_STATUS     VARCHAR2(3);

BEGIN
    SELECT FNAME,MNAME,MNAME,ADDRESS,PHONE_NUMBER,EMAIL,STATUS
    into 
        L_FNAME,L_MNAME,L_LNAME,L_ADDRESS,L_PHONE,L_EMAIL,L_STATUS
    FROM BANK_CUSTOMER 
    WHERE 
    CUSTOMER_ID= P_CUSTOMER_ID;
    
    DBMS_OUTPUT.PUT_LINE('Customer: '||L_FNAME||' '||L_MNAME||' '||L_LNAME);
    DBMS_OUTPUT.PUT_LINE('Adress: '||L_ADDRESS);
    DBMS_OUTPUT.PUT_LINE('Phone number : '|| L_PHONE);
    DBMS_OUTPUT.PUT_LINE('Email : '|| L_EMAIL);
    DBMS_OUTPUT.PUT_LINE('Status : '|| L_STATUS);
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No customer found with the specified ID.');
END;
call PRINT_BANK_CUSTOMER_DATA(12);

CREATE OR REPLACE PROCEDURE ADD_BANK_CUSTOMER(
    P_FNAME VARCHAR2,
    P_MNAME VARCHAR2,
    P_LNAME VARCHAR2,
    P_ADDRESS VARCHAR2,
    P_PHONE VARCHAR2,
    P_EMAIL VARCHAR2
    )
    as
    BEGIN
    INSERT INTO BANK_CUSTOMER(FNAME, MNAME,LNAME , ADDRESS, PHONE_NUMBER,EMAIL)
    VALUES(P_FNAME,P_MNAME,P_LNAME,P_ADDRESS,P_PHONE,P_EMAIL);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END;
    
CALL ADD_BANK_CUSTOMER
('John', 'Michael', 'Doe', '123 Main St', '555-1234', 'john.doe@example.com');
call PRINT_BANK_CUSTOMER_DATA(14);

CREATE OR REPLACE PROCEDURE DELETE_BANK_CUSTOMER(P_CUSTOMER_ID NUMBER)
AS
    BEGIN
        DELETE FROM BANK_CUSTOMER WHERE CUSTOMER_ID = P_CUSTOMER_ID;
         EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END;
    
CALL DELETE_BANK_CUSTOMER(13);

CREATE OR REPLACE PROCEDURE EDIT_BANK_CUSTOMER(
    P_CUSTOMER_ID NUMBER,
    P_FNAME VARCHAR2,
    P_MNAME VARCHAR2,
    P_LNAME VARCHAR2,
    P_ADDRESS VARCHAR2,
    P_PHONE VARCHAR2,
    P_EMAIL VARCHAR2
    )
    AS 
    BEGIN
        UPDATE BANK_CUSTOMER
        SET 
            FNAME = P_FNAME,
            MNAME = P_MNAME,
            LNAME = P_LNAME,
            ADDRESS = P_ADDRESS,
            PHONE_NUMBER = P_PHONE,
            EMAIL = P_EMAIL
        WHERE P_CUSTOMER_ID = CUSTOMER_ID;
         EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END;

CALL EDIT_BANK_CUSTOMER
(14,'JohnN', 'Michael', 'Doe', '123 Main St', '555-1234', 'john.doe@example.com');
/*
5. Create functionality to send money between
individual customers of the bank.
*/
CREATE OR REPLACE PROCEDURE SEND_MONEY(
    SENDER_BANK_ACCOUNT   VARCHAR2,
    RECEIVER_BANK_ACCOUNT VARCHAR2,
    AMMOUNT FLOAT
    )
    IS
     L_SENDER_CURRENCY VARCHAR2(3);
     L_RECEIVER_CURRENCY VARCHAR2(3);
     L_AMMOUNT_RECEIVER_CURRENCY FLOAT;
     
BEGIN

    SELECT CURRENCY INTO L_RECEIVER_CURRENCY
    FROM BANK_ACCOUNT WHERE B_ACCOUNT = RECEIVER_BANK_ACCOUNT;
    SELECT CURRENCY INTO L_SENDER_CURRENCY
    FROM BANK_ACCOUNT WHERE B_ACCOUNT = SENDER_BANK_ACCOUNT;

        
        IF
        L_SENDER_CURRENCY <> L_RECEIVER_CURRENCY 
        THEN
            L_AMMOUNT_RECEIVER_CURRENCY:= EXCHANGE_CURRENCY
                                        (L_SENDER_CURRENCY,
                                         L_RECEIVER_CURRENCY,
                                         AMMOUNT) ;
         ELSIF 
              L_SENDER_CURRENCY = L_RECEIVER_CURRENCY 
         THEN 
                L_AMMOUNT_RECEIVER_CURRENCY := AMMOUNT;
        END IF;
            
            UPDATE BANK_ACCOUNT 
            SET BALANCE = BALANCE - AMMOUNT
            WHERE B_ACCOUNT = SENDER_BANK_ACCOUNT;
            
            UPDATE BANK_ACCOUNT 
            SET BALANCE = BALANCE + L_AMMOUNT_RECEIVER_CURRENCY
            WHERE B_ACCOUNT = RECEIVER_BANK_ACCOUNT;
            
            
            DBMS_OUTPUT.PUT_LINE('TRANSACTION COMPLETE');
            DBMS_OUTPUT.PUT_LINE('-----------------------------------');
            DBMS_OUTPUT.PUT_LINE('SENDER BANK ACCOUNT :' || SENDER_BANK_ACCOUNT);
            DBMS_OUTPUT.PUT_LINE('RECEIVER BANK ACCOUNT :' || RECEIVER_BANK_ACCOUNT);
            DBMS_OUTPUT.PUT_LINE('AMMOUNT :' || AMMOUNT || L_SENDER_CURRENCY);
            
            EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

SELECT * FROM BANK_ACCOUNT;
CALL SEND_MONEY('USD1','EUR1',1);
/*
6. Implement an exchange rate processing module by
apply when sending transfers in a currency other than
account currencies.
(Example: Transfer of 100 euros from an Account
A (lev) account to Account B (dollar).
*/
CREATE OR REPLACE FUNCTION EXCHANGE_CURRENCY(
    BASE_CURRENCY VARCHAR2,
    QUOTE_CURRENCY VARCHAR2,
    AMMOUNT FLOAT) 
    RETURN NUMBER
    AS 
    EXCHANGED_AMMOUNT NUMBER;
    BEGIN
        CASE
            WHEN BASE_CURRENCY = 'BGN' AND QUOTE_CURRENCY = 'EUR'
                THEN EXCHANGED_AMMOUNT :=  AMMOUNT * 0.51;
            WHEN BASE_CURRENCY = 'BGN' AND QUOTE_CURRENCY = 'USD'
                THEN EXCHANGED_AMMOUNT := AMMOUNT *0.56;
                
            WHEN BASE_CURRENCY = 'EUR' AND QUOTE_CURRENCY = 'USD'
                THEN EXCHANGED_AMMOUNT := AMMOUNT *1.09;
            WHEN BASE_CURRENCY = 'EUR' AND QUOTE_CURRENCY = 'BGN'
                THEN EXCHANGED_AMMOUNT := AMMOUNT * 1.96;
                
            WHEN BASE_CURRENCY = 'USD' AND QUOTE_CURRENCY = 'EUR'
                THEN EXCHANGED_AMMOUNT := AMMOUNT * 0.91;
            WHEN BASE_CURRENCY = 'USD' AND QUOTE_CURRENCY = 'BGN'
                THEN EXCHANGED_AMMOUNT := AMMOUNT * 1.79;
        END CASE;
        
         RETURN EXCHANGED_AMMOUNT;
    END;

DECLARE
temp number;
 
BEGIN
tEMp := EXCHANGE_CURRENCY('BGN','EUR',4214);
DBMS_OUTPUT.PUT_LINE('EXCHANGED: '|| TEMP);
END;

COMMIT;






--Creating Tables
CREATE TABLE BANK_DEPARTMENT(
    DEPARTMENT_ID    NUMBER GENERATED ALWAYS AS IDENTITY,
    DEPARTMENT_NAME  VARCHAR(50) NOT NULL ENABLE,
    PRIMARY KEY(DEPARTMENT_ID)
);

CREATE TABLE BANK_EMPLOYEE(
    EMPLOYEE_ID     NUMBER GENERATED ALWAYS AS IDENTITY,
    FNAME           VARCHAR(30) NOT NULL ENABLE,
    LNAME           VARCHAR(30) NOT NULL ENABLE,
    MNAME           VARCHAR(30) ,
    ADDRESS         VARCHAR(50) NOT NULL ENABLE,
    PHONE_NUMBER    VARCHAR(30) NOT NULL ENABLE UNIQUE,
    EMAIL           VARCHAR(30) NOT NULL ENABLE UNIQUE,
    EMP_ROLE        VARCHAR(30) NOT NULL ENABLE,
    SALARY          FLOAT NOT NULL ENABLE,
    EMPLOYMENT_DATE DATE NOT NULL ENABLE,
    STATUS          VARCHAR(15),
    MANAGER_ID      NUMBER,
    DEPARTMENT_ID   NUMBER NOT NULL ENABLE,
    CONSTRAINT FK_EMPLOYEE_MANAGER FOREIGN KEY(MANAGER_ID)
    REFERENCES BANK_EMPLOYEE(EMPLOYEE_ID),
    CONSTRAINT FK_EMPLOYEE_DEPARTMENT FOREIGN KEY(DEPARTMENT_ID)
    REFERENCES BANK_DEPARTMENT(DEPARTMENT_ID),
    PRIMARY KEY(EMPLOYEE_ID)  
);

CREATE TABLE BANK_CUSTOMER(
    CUSTOMER_ID NUMBER GENERATED ALWAYS AS IDENTITY,
    FNAME           VARCHAR(30) NOT NULL ENABLE,
    LNAME           VARCHAR(30) NOT NULL ENABLE,
    MNAME           VARCHAR(30) ,
    ADDRESS         VARCHAR(50) NOT NULL ENABLE,
    PHONE_NUMBER    VARCHAR(30) NOT NULL ENABLE UNIQUE,
    EMAIL           VARCHAR(30) NOT NULL ENABLE UNIQUE,
    PRIMARY KEY(CUSTOMER_ID)
);

CREATE TABLE BANK_ACCOUNT(
    ACCOUNT_ID      NUMBER GENERATED ALWAYS AS IDENTITY,
    B_ACCOUNT       VARCHAR2(50) NOT NULL UNIQUE,
    BALANCE         FLOAT NOT NULL ENABLE,
    CURRENCY        VARCHAR2(3) DEFAULT 'BGN' NOT NULL ENABLE ,
    TITLE           VARCHAR(50), 
    CUSTOMER_ID     NUMBER NOT NULL ENABLE,
    CONSTRAINT FK_ACCOUNT_CUSTOMER FOREIGN KEY(CUSTOMER_ID)
    REFERENCES BANK_CUSTOMER(CUSTOMER_ID),
    PRIMARY KEY(ACCOUNT_ID)
);

CREATE TABLE BANK_EMPLOYEE_MIGRATION(
    MIGRATION_ID      NUMBER GENERATED AS IDENTITY,
    EMPLOYEE_ID       NUMBER NOT NULL ENABLE,   
    OLD_DEPARTMENT_ID NUMBER NOT NULL ENABLE,
    NEW_DEPARTMENT_ID NUMBER NOT NULL ENABLE,
    MIGRATION_DATE    DATE NOT NULL ENABLE,
    
    CONSTRAINT FK_EMPLOYEE FOREIGN KEY(EMPLOYEE_ID)
    REFERENCES BANK_EMPLOYEE(EMPLOYEE_ID),
    CONSTRAINT FK_OLD_DEPARTMENT FOREIGN KEY(OLD_DEPARTMENT_ID)
    REFERENCES BANK_DEPARTMENT(DEPARTMENT_ID),
    CONSTRAINT FK_NEW_DEPARTMENT FOREIGN KEY(NEW_DEPARTMENT_ID)
    REFERENCES BANK_DEPARTMENT(DEPARTMENT_ID),
    PRIMARY KEY(MIGRATION_ID)
);
-- Inserts
-- Departments
INSERT INTO BANK_DEPARTMENT(DEPARTMENT_NAME) VALUES ('Human resources');
INSERT INTO BANK_DEPARTMENT(DEPARTMENT_NAME) VALUES('Finance');
INSERT INTO BANK_DEPARTMENT(DEPARTMENT_NAME) VALUES('Economics');
INSERT INTO BANK_DEPARTMENT(DEPARTMENT_NAME) VALUES('Information Technology');
INSERT INTO BANK_DEPARTMENT(DEPARTMENT_NAME) VALUES('Quality assurance');

select * from bank_department;
-- Employees

INSERT INTO BANK_EMPLOYEE (FNAME, LNAME, MNAME, Address, PHONE_NUMBER, Email, Emp_Role, Salary, EMPLOYMENT_DATE, Status, Department_Id)
VALUES ('Sarah', 'Jones', 'Anne', '654 Cedar St, City, Country', '777-888-9999', 'sarah.jones@bankoftomorrow.bg', 'IT Specialist', 65000,to_date('2023-04-03','yyyy-mm-dd'), 'Active', 2);
INSERT INTO BANK_EMPLOYEE (FNAME, LNAME, MNAME, Address, PHONE_NUMBER, Email, Emp_Role, Salary, EMPLOYMENT_DATE, Status,Department_Id)
VALUES ('Alice', 'Smith', 'Elizabeth', '456 Oak St, Town, Country', '987-654-3210', 'alice.smith@bankoftomorrow.bg', 'Financial Analyst', 70000, to_date('2023-05-15','yyyy-mm-dd'), 'Active', 2);
INSERT INTO BANK_EMPLOYEE (FNAME, LNAME, MNAME, Address, PHONE_NUMBER, Email, Emp_Role, Salary, EMPLOYMENT_DATE, Status,Department_Id)
VALUES ('Bob', 'Johnson', 'Edward', '789 Elm St, City, Country', '555-123-4567', 'bob.johnson@bankoftomorrow.bg', 'HR Manager', 80000, to_date('2023-02-28','yyyy-mm-dd'), 'Active',1);
INSERT INTO BANK_EMPLOYEE (FNAME, LNAME, MNAME, Address, PHONE_NUMBER, Email, Emp_Role, Salary, EMPLOYMENT_DATE, Status,Department_Id)
VALUES ('Emily', 'Brown', 'Grace', '321 Pine St, Village, Country', '333-999-8888', 'emily.brown@bankoftomorrow.bg', 'HR smth', 60000,to_date('2023-08-10','yyyy-mm-dd') , 'Active',1);
INSERT INTO BANK_EMPLOYEE (FNAME, LNAME, MNAME, Address, PHONE_NUMBER, Email, Emp_Role, Salary, EMPLOYMENT_DATE, Status,Department_Id)
VALUES ('David', 'Taylor', 'Patrick', '987 Maple St, Town, Country', '111-222-3333', 'david.taylor@bankoftomorrow.bg', 'Customer Service', 55000, to_date('2023-11-20','yyyy-mm-dd'), 'Active',2);
INSERT INTO BANK_EMPLOYEE (FNAME, LNAME, MNAME, Address, PHONE_NUMBER, Email, Emp_Role, Salary, EMPLOYMENT_DATE, Status, Department_Id)
VALUES ('Jennifer', 'Martinez', 'Marie', '369 Birch St, Town, Country', '222-333-4444', 'jen.martinez@bankoftomorrow.bg', 'Operations Manager', 85000, to_date('2023-07-11','yyyy-mm-dd'), 'Active',3);
INSERT INTO BANK_EMPLOYEE (FNAME, LNAME, MNAME, Address, PHONE_NUMBER, Email, Emp_Role, Salary, EMPLOYMENT_DATE, Status,Department_Id)
VALUES ('Daniel', 'Garcia', 'Robert', '741 Oakwood St, City, Country', '888-999-0000', 'dan.garcia@bankoftomorrow.bg', 'Business Analyst', 70000, to_date('2023-03-05','yyyy-mm-dd'), 'Active',3);
INSERT INTO BANK_EMPLOYEE (FNAME, LNAME, MNAME, Address, PHONE_NUMBER, Email, Emp_Role, Salary, EMPLOYMENT_DATE, Status, Department_Id)
VALUES ('Jessica', 'Lee', 'Nicole', '123 Pinecrest St, Village, Country', '666-777-8888', 'jessica.lee@bankoftomorrow.bg', 'Jr Software Dev', 32000,to_date('2023-10-18','yyyy-mm-dd' ), 'Active',4);
INSERT INTO BANK_EMPLOYEE (FNAME, LNAME, MNAME, Address, PHONE_NUMBER, Email, Emp_Role, Salary, EMPLOYMENT_DATE, Status, Department_Id)
VALUES ('Christopher', 'Hernandez', 'William', '963 Elmwood St, Town, Country', '111-2322-3333', 'chris.hern@bankoftomorrow.bg', 'Software Developer', 72000, to_date('2023-12-30','yyyy-mm-dd' ), 'Active',4);
INSERT INTO BANK_EMPLOYEE(FNAME,LNAME,MNAME,ADDRESS,PHONE_NUMBER,EMAIL,EMP_ROLE,SALARY,EMPLOYMENT_DATE,STATUS,DEPARTMENT_ID)
                    VALUES('Sime','Yankulov','Hristov','bul.Bulgaria 236B','+123123123','jankulov.sime@yahoo.com','QA manager',123123,to_date('2023-12-30','yyyy-mm-dd' ),'Active',5);

commit;

--Customers

-- Customer 1
INSERT INTO BANK_CUSTOMER (FNAME, LNAME, MNAME, Address, Phone_Number, Email)
VALUES ('Emily', 'Johnson', 'Grace', '123 Maple St, City, Country', '111-222-3333', 'emily.johnson@example.com');

INSERT INTO BANK_CUSTOMER (FNAME, LNAME, MNAME, Address, Phone_Number, Email)
VALUES ('David', 'Smith', 'Michael', '456 Oak St, Town, Country', '444-555-6666', 'david.smith@example.com');

INSERT INTO BANK_CUSTOMER (FNAME, LNAME, MNAME, Address, Phone_Number, Email)
VALUES ('Sarah', 'Brown', 'Anne', '789 Elm St, City, Country', '777-888-9999', 'sarah.brown@example.com');

INSERT INTO BANK_CUSTOMER (FNAME, LNAME, MNAME, Address, Phone_Number, Email)
VALUES ('Michael', 'Jones', 'Joseph', '321 Pine St, Village, Country', '222-333-4444', 'michael.jones@example.com');

INSERT INTO BANK_CUSTOMER (FNAME, LNAME, MNAME, Address, Phone_Number, Email)
VALUES ('Jennifer', 'Martinez', 'Marie', '654 Cedar St, City, Country', '555-666-7777', 'jennifer.martinez@example.com');

INSERT INTO BANK_CUSTOMER (FNAME, LNAME, MNAME, Address, Phone_Number, Email)
VALUES ('John', 'Doe', 'Michael', '123 Main St, City, Country', '123-456-7890', 'john.doe@bankoftomorrow.bg');

INSERT INTO BANK_CUSTOMER (FNAME, LNAME, MNAME, Address, Phone_Number, Email)
VALUES ('Alice', 'Smith', NULL, '456 Oak St, Town, Country', '987-654-3210', 'alice.smith@bankoftomorrow.bg');

INSERT INTO BANK_CUSTOMER (FNAME, LNAME, MNAME, Address, Phone_Number, Email)
VALUES ('Bob', 'Johnson', 'Edward', '789 Elm St, City, Country', '555-123-4567', 'bob.johnson@bankoftomorrow.bg');

INSERT INTO BANK_CUSTOMER (FNAME, LNAME, MNAME, Address, Phone_Number, Email)
VALUES ('Emily', 'Brown', 'Grace', '321 Pine St, Village, Country', '333-999-8888', 'emily.brown@bankoftomorrow.bg');

INSERT INTO BANK_CUSTOMER (FNAME, LNAME, MNAME, Address, Phone_Number, Email)
VALUES ('David', 'Taylor', 'Patrick', '987 Maple St, Town, Country', '111-2222-3333', 'd.taylor@bankoftomorrow.bg');

select * from bank_customer;
commit;
DROP TABLE bANK_ACCOUNT;
SELECT * FROM BANK_ACCOUNT;
INSERT INTO BANK_ACCOUNT(B_ACCOUNT,BALANCE,CURRENCY,CUSTOMER_ID)
VALUES('USD1',200000,'USD',1);
INSERT INTO BANK_ACCOUNT(B_ACCOUNT,BALANCE,CURRENCY,CUSTOMER_ID)
VALUES('EUR1',221222,'EUR',2);
INSERT INTO BANK_ACCOUNT(B_ACCOUNT,BALANCE,CURRENCY,CUSTOMER_ID)
VALUES('USD2',11111,'USD',3);
INSERT INTO BANK_ACCOUNT(B_ACCOUNT,BALANCE,CURRENCY,CUSTOMER_ID)
VALUES('EUR2',50,'EUR',4);
INSERT INTO BANK_ACCOUNT(B_ACCOUNT,BALANCE,CURRENCY,CUSTOMER_ID)
VALUES('USD3',0,'USD',5);
INSERT INTO BANK_ACCOUNT(B_ACCOUNT,BALANCE,CURRENCY,CUSTOMER_ID)
VALUES('EUR3',111,'EUR',6);
INSERT INTO BANK_ACCOUNT(B_ACCOUNT,BALANCE,CURRENCY,CUSTOMER_ID)
VALUES('BGN1',999999,'BGN',7);
INSERT INTO BANK_ACCOUNT(B_ACCOUNT,BALANCE,CURRENCY,CUSTOMER_ID)
VALUES('EUR4',5512,'EUR',8);
INSERT INTO BANK_ACCOUNT(B_ACCOUNT,BALANCE,CURRENCY,CUSTOMER_ID)
VALUES('USD4',6699,'USD',9);
INSERT INTO BANK_ACCOUNT(B_ACCOUNT,BALANCE,CURRENCY,CUSTOMER_ID)
VALUES('EUR5',121212,'EUR',12);
INSERT INTO BANK_ACCOUNT(B_ACCOUNT,BALANCE,CURRENCY,CUSTOMER_ID)
VALUES('EUR6',12,'EUR',9);
INSERT INTO BANK_ACCOUNT(B_ACCOUNT,BALANCE,CURRENCY,CUSTOMER_ID)
VALUES('USD5',77,'USD',12);

COMMIT;



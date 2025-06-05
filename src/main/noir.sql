BEGIN
  FOR t IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
  END LOOP;
END;
/
-- ��� ���̺�
CREATE TABLE noir_member (
    member_id NUMBER PRIMARY KEY,                                    -- ȸ�� ���� ID (PK)
    login_id VARCHAR2(50) NOT NULL UNIQUE,                           -- �α��� ���̵�
    password VARCHAR2(100),                                          -- ��й�ȣ
    name VARCHAR2(50),                                               -- ���̸�
    phone VARCHAR2(20),                                              -- ��ȭ��ȣ
    role VARCHAR2(20) CHECK (role IN ('ADMIN', 'USER')),             -- ����: ������ / ��
    social_type VARCHAR2(20),                                        -- �Ҽ� �α��� ���� (��: 'KAKAO')
    sns_id VARCHAR2(100),                                            -- �Ҽ� ���񽺿��� ���� ����� ���� ID
    profileImage VARCHAR2(200)                                       -- ������ �̹��� URL
);
INSERT INTO noir_member (member_id, login_id, password, name, phone, role, social_type, sns_id, profileImage) VALUES (15, 'admin15', 'adminpass123', '������15', '010-1234-1515', 'ADMIN', NULL, NULL, NULL);

-----------------------------------------------------------------------------------------------------------------------------------
-- ������ �������� ��� ���̺�
CREATE TABLE ADMIN_RESERVATION (
    RESERVE_ID     NUMBER PRIMARY KEY,   -- id
    MEAL_TIME      VARCHAR2(10),         -- 'lunch' or 'dinner'
    RESERVE_DATE   DATE,                 -- ���� ��¥
    TIME_SLOT      VARCHAR2(20),         -- �ð��� ��: '12:00 ~ 13:00'
    CREATED_AT     TIMESTAMP DEFAULT SYSTIMESTAMP
);

ALTER TABLE ADMIN_RESERVATION
ADD CONSTRAINT UQ_DATE_TIME_FLOOR
UNIQUE (RESERVE_DATE, TIME_SLOT, FLOOR);

CREATE SEQUENCE ADMIN_RESERVATION_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- auto increment + trigger(�ڵ�����)
CREATE OR REPLACE TRIGGER ADMIN_RESERVATION_TRG
BEFORE INSERT ON ADMIN_RESERVATION
FOR EACH ROW
BEGIN
  SELECT ADMIN_RESERVATION_SEQ.NEXTVAL INTO :NEW.RESERVE_ID FROM dual;
END;

-----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE CUSTOMER_RESERVATION (
    CUSTOMER_ID     NUMBER PRIMARY KEY,         -- �� ���� ID 
    MEMBER_ID       NUMBER NOT NULL,            -- ȸ�� ID (FK)
    SEAT_ID         NUMBER NOT NULL,            -- �¼� ��ȣ
    RESERVE_ID      NUMBER NOT NULL,            -- ������ ���� ID (FK)

    CONSTRAINT FK_CUSTOMER_MEMBER
        FOREIGN KEY (MEMBER_ID)
        REFERENCES NOIR_MEMBER(MEMBER_ID),

    CONSTRAINT FK_CUSTOMER_RESERVE
        FOREIGN KEY (RESERVE_ID)
        REFERENCES ADMIN_RESERVATION(RESERVE_ID)
);


CREATE SEQUENCE CUSTOMER_RESERVATION_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER CUSTOMER_RESERVATION_TRG
BEFORE INSERT ON CUSTOMER_RESERVATION
FOR EACH ROW
BEGIN
  SELECT CUSTOMER_RESERVATION_SEQ.NEXTVAL
  INTO :NEW.CUSTOMER_ID
  FROM dual;
END;
-----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE SEAT (
    SEAT_ID     NUMBER PRIMARY KEY,       -- �¼� ���� ID (PK)
    LOCATION    VARCHAR2(50),             -- ��ġ (ex: 'â��', '�߾�')
    HEAD_COUNT  NUMBER(2),                -- ���� �ο���
    FLOOR       NUMBER(1)                 -- 1�� or 2��
);

INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (1, 'â���ڸ�', 4, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (2, '�����ڸ�', 4, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (3, '�߾�', 4, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (4, '�߾�', 2, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (5, '�Ա���ó', 6, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (6, '�����ڸ�', 2, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (7, '�����ڸ�', 2, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (8, '�����ڸ�', 2, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (9, '�����ڸ�', 2, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (10, 'â���ڸ�', 4, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (11, 'â���ڸ�', 6, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (12, '�߾�', 8, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (13, '�߾�', 4, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (14, '�߾�', 4, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (15, '�߾�', 4, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (16, 'â���ڸ�', 6, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (17, 'â���ڸ�', 4, 2);
-----------------------------------------------------------------------------------------------------------------------------------
-- ����
CREATE TABLE ACCOUNT (
    ACCOUNT_ID     NUMBER PRIMARY KEY,           -- ���� ���� ID
    ACCOUNT_NAME   VARCHAR2(100) NOT NULL,   -- ������ �̸�
    BALANCE        NUMBER(15) DEFAULT 0            -- �ܾ�
);
insert into account (account_id, account_name, balance) values (1, 'ȫ�浿', 500000);
select * from account;
SELECT * FROM ACCOUNT WHERE ACCOUNT_ID = 1;
-----------------------------------------------------------------------------------------------------------------------------------
-- �ŷ� ����0
CREATE TABLE PAYMENT_TRANSACTION (
    TRANSACTION_ID   NUMBER PRIMARY KEY,           -- �ŷ� ���� ID
    ACCOUNT_ID       NUMBER NOT NULL,              -- � ������ �ŷ�����
    TRANSACTION_TYPE VARCHAR2(10) NOT NULL,        -- �Ա�(DEPOSIT), ���(WITHDRAW)
    AMOUNT           NUMBER(15) NOT NULL,          -- �ŷ� �ݾ�
    TRANSACTION_DATE DATE DEFAULT SYSDATE,         -- �ŷ��Ͻ�
    MEMBER_ID        NUMBER NOT NULL,              -- ȸ�� ID (FK)

    CONSTRAINT FK_TRANSACTION_ACCOUNT
      FOREIGN KEY (ACCOUNT_ID)
      REFERENCES ACCOUNT(ACCOUNT_ID),
      
    CONSTRAINT FK_PAYMENT_MEMBER
        FOREIGN KEY (MEMBER_ID)
        REFERENCES NOIR_MEMBER(MEMBER_ID)
);

-- �ŷ����� ID�� ������
CREATE SEQUENCE SEQ_PAYMENT_TRANSACTION_ID
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
select * from seat;
-- dd
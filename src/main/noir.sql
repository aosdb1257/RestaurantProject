BEGIN
  FOR t IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
  END LOOP;
END;
/
-- ������ �������� ��� ���̺�
CREATE TABLE ADMIN_RESERVATION (
    RESERVE_ID     NUMBER PRIMARY KEY,   -- id
    MEAL_TIME      VARCHAR2(10),         -- 'lunch' or 'dinner'
    RESERVE_DATE   DATE,                 -- ���� ��¥
    TIME_SLOT      VARCHAR2(20),         -- �ð��� ��: '12:00 ~ 13:00'
    FLOOR          NUMBER(1),            -- 1 or 2
    CREATED_AT     TIMESTAMP DEFAULT SYSTIMESTAMP
);

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

CREATE TABLE CUSTOMER_RESERVATION (
    CUSTOMER_ID     NUMBER PRIMARY KEY,      -- �� ���� ID 
    SEAT_ID         NUMBER,                  -- �¼� ��ȣ (�ٸ� �¼� ���̺��� �ִٰ� ����, FK�� ó�� ����)
    RESERVE_ID      NUMBER,                  -- ADMIN_RESERVATION�� FK
    CONSTRAINT FK_RESERVE_ID FOREIGN KEY (RESERVE_ID)
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

CREATE TABLE SEAT (
    SEAT_ID     NUMBER PRIMARY KEY,       -- �¼� ���� ID (PK)
    LOCATION    VARCHAR2(50),             -- ��ġ (ex: 'â��', '�߾�')
    HEAD_COUNT  NUMBER(2),                -- ���� �ο���
    FLOOR       NUMBER(1)                 -- 1�� or 2��
);

INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (1, 'â���ڸ�', 4, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (2, '�����ڸ�', 6, 1);
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

-- ���� ���̺� (���� ���� 1���� ����)
CREATE TABLE ACCOUNT (
    ACCOUNT_ID   NUMBER PRIMARY KEY,            -- ���� ���� ID
    OWNER_NAME   VARCHAR2(100) NOT NULL,        -- ��: '�����'
    BALANCE      NUMBER(10) DEFAULT 0           -- ���� �ܾ�
);
-- ���� ����
INSERT INTO ACCOUNT (ACCOUNT_ID, OWNER_NAME, BALANCE)
VALUES (1, '�����', 0);

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

-- ���� ���̺� (�� ID + �� �̸� + �Ա� ���� ID ����)
CREATE TABLE PAYMENT (
    PAYMENT_ID     NUMBER PRIMARY KEY,            -- ���� ���� ID
    CUSTOMER_ID    NUMBER NOT NULL,               -- ������ �� ID (��Ȯ�� ������)
    AMOUNT         NUMBER(10) NOT NULL,           -- ���� �ݾ�
    PAYMENT_DATE   DATE DEFAULT SYSDATE,           -- ���� �Ͻ�
    ACCOUNT_ID     NUMBER NOT NULL,                -- �Աݵ� ���� ID (���� ����)

    -- �ܷ�Ű ��������
    CONSTRAINT FK_PAYMENT_CUSTOMER
      FOREIGN KEY (CUSTOMER_ID)
      REFERENCES noir_member(member_id),

    CONSTRAINT FK_PAYMENT_ACCOUNT
      FOREIGN KEY (ACCOUNT_ID)
      REFERENCES ACCOUNT(ACCOUNT_ID)
);

CREATE SEQUENCE PAYMENT_SEQ
  START WITH 1       -- ���� ��
  INCREMENT BY 1     -- ���� ��
  NOCACHE            -- ĳ�� ���� (�ɼ�)
  NOCYCLE;           -- �ٽ� 1���� �������� ����
  
CREATE OR REPLACE TRIGGER TRG_PAYMENT_ID
BEFORE INSERT ON PAYMENT
FOR EACH ROW
BEGIN
  :NEW.PAYMENT_ID := PAYMENT_SEQ.NEXTVAL;
END;
/
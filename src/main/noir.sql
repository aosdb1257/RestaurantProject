BEGIN
  FOR t IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
  END LOOP;
END;
/
-- 멤버 테이블
CREATE TABLE noir_member (
    member_id NUMBER PRIMARY KEY,                                    -- 회원 고유 ID (PK)
    login_id VARCHAR2(50) NOT NULL UNIQUE,                           -- 로그인 아이디
    password VARCHAR2(100),                                          -- 비밀번호
    name VARCHAR2(50),                                               -- 고객이름
    phone VARCHAR2(20),                                              -- 전화번호
    role VARCHAR2(20) CHECK (role IN ('ADMIN', 'USER')),             -- 역할: 관리자 / 고객
    social_type VARCHAR2(20),                                        -- 소셜 로그인 종류 (예: 'KAKAO')
    sns_id VARCHAR2(100),                                            -- 소셜 서비스에서 받은 사용자 고유 ID
    profileImage VARCHAR2(200)                                       -- 프로필 이미지 URL
);
INSERT INTO noir_member (member_id, login_id, password, name, phone, role, social_type, sns_id, profileImage) VALUES (15, 'admin15', 'adminpass123', '관리자15', '010-1234-1515', 'ADMIN', NULL, NULL, NULL);

-----------------------------------------------------------------------------------------------------------------------------------
-- 관리자 예약정보 등록 테이블
CREATE TABLE ADMIN_RESERVATION (
    RESERVE_ID     NUMBER PRIMARY KEY,   -- id
    MEAL_TIME      VARCHAR2(10),         -- 'lunch' or 'dinner'
    RESERVE_DATE   DATE,                 -- 예약 날짜
    TIME_SLOT      VARCHAR2(20),         -- 시간대 예: '12:00 ~ 13:00'
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

-- auto increment + trigger(자동증가)
CREATE OR REPLACE TRIGGER ADMIN_RESERVATION_TRG
BEFORE INSERT ON ADMIN_RESERVATION
FOR EACH ROW
BEGIN
  SELECT ADMIN_RESERVATION_SEQ.NEXTVAL INTO :NEW.RESERVE_ID FROM dual;
END;

-----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE CUSTOMER_RESERVATION (
    CUSTOMER_ID     NUMBER PRIMARY KEY,         -- 고객 예약 ID 
    MEMBER_ID       NUMBER NOT NULL,            -- 회원 ID (FK)
    SEAT_ID         NUMBER NOT NULL,            -- 좌석 번호
    RESERVE_ID      NUMBER NOT NULL,            -- 관리자 예약 ID (FK)

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
    SEAT_ID     NUMBER PRIMARY KEY,       -- 좌석 고유 ID (PK)
    LOCATION    VARCHAR2(50),             -- 위치 (ex: '창가', '중앙')
    HEAD_COUNT  NUMBER(2),                -- 수용 인원수
    FLOOR       NUMBER(1)                 -- 1층 or 2층
);

INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (1, '창가자리', 4, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (2, '구석자리', 4, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (3, '중앙', 4, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (4, '중앙', 2, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (5, '입구근처', 6, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (6, '구석자리', 2, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (7, '구석자리', 2, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (8, '구석자리', 2, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (9, '구석자리', 2, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (10, '창가자리', 4, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (11, '창가자리', 6, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (12, '중앙', 8, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (13, '중앙', 4, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (14, '중앙', 4, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (15, '중앙', 4, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (16, '창가자리', 6, 2);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (17, '창가자리', 4, 2);
-----------------------------------------------------------------------------------------------------------------------------------
-- 계좌
CREATE TABLE ACCOUNT (
    ACCOUNT_ID     NUMBER PRIMARY KEY,           -- 계좌 고유 ID
    ACCOUNT_NAME   VARCHAR2(100) NOT NULL,   -- 예금주 이름
    BALANCE        NUMBER(15) DEFAULT 0            -- 잔액
);
insert into account (account_id, account_name, balance) values (1, '홍길동', 500000);
select * from account;
SELECT * FROM ACCOUNT WHERE ACCOUNT_ID = 1;
-----------------------------------------------------------------------------------------------------------------------------------
-- 거래 내역0
CREATE TABLE PAYMENT_TRANSACTION (
    TRANSACTION_ID   NUMBER PRIMARY KEY,           -- 거래 고유 ID
    ACCOUNT_ID       NUMBER NOT NULL,              -- 어떤 계좌의 거래인지
    TRANSACTION_TYPE VARCHAR2(10) NOT NULL,        -- 입금(DEPOSIT), 출금(WITHDRAW)
    AMOUNT           NUMBER(15) NOT NULL,          -- 거래 금액
    TRANSACTION_DATE DATE DEFAULT SYSDATE,         -- 거래일시
    MEMBER_ID        NUMBER NOT NULL,              -- 회원 ID (FK)

    CONSTRAINT FK_TRANSACTION_ACCOUNT
      FOREIGN KEY (ACCOUNT_ID)
      REFERENCES ACCOUNT(ACCOUNT_ID),
      
    CONSTRAINT FK_PAYMENT_MEMBER
        FOREIGN KEY (MEMBER_ID)
        REFERENCES NOIR_MEMBER(MEMBER_ID)
);

-- 거래내역 ID용 시퀀스
CREATE SEQUENCE SEQ_PAYMENT_TRANSACTION_ID
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
select * from seat;
-- dd
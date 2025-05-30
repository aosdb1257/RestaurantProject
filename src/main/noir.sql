BEGIN
  FOR t IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
  END LOOP;
END;
/
-- 관리자 예약정보 등록 테이블
CREATE TABLE ADMIN_RESERVATION (
    RESERVE_ID     NUMBER PRIMARY KEY,   -- id
    MEAL_TIME      VARCHAR2(10),         -- 'lunch' or 'dinner'
    RESERVE_DATE   DATE,                 -- 예약 날짜
    TIME_SLOT      VARCHAR2(20),         -- 시간대 예: '12:00 ~ 13:00'
    FLOOR          NUMBER(1),            -- 1 or 2
    CREATED_AT     TIMESTAMP DEFAULT SYSTIMESTAMP
);

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

CREATE TABLE CUSTOMER_RESERVATION (
    CUSTOMER_ID     NUMBER PRIMARY KEY,      -- 고객 예약 ID 
    SEAT_ID         NUMBER,                  -- 좌석 번호 (다른 좌석 테이블이 있다고 가정, FK로 처리 가능)
    RESERVE_ID      NUMBER,                  -- ADMIN_RESERVATION의 FK
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
    SEAT_ID     NUMBER PRIMARY KEY,       -- 좌석 고유 ID (PK)
    LOCATION    VARCHAR2(50),             -- 위치 (ex: '창가', '중앙')
    HEAD_COUNT  NUMBER(2),                -- 수용 인원수
    FLOOR       NUMBER(1)                 -- 1층 or 2층
);

INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (1, '창가자리', 4, 1);
INSERT INTO SEAT (SEAT_ID, LOCATION, HEAD_COUNT, FLOOR) VALUES (2, '구석자리', 6, 1);
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

-- 계좌 테이블 (사장 계좌 1개만 존재)
CREATE TABLE ACCOUNT (
    ACCOUNT_ID   NUMBER PRIMARY KEY,            -- 계좌 고유 ID
    OWNER_NAME   VARCHAR2(100) NOT NULL,        -- 예: '사장님'
    BALANCE      NUMBER(10) DEFAULT 0           -- 현재 잔액
);
-- 사장 계좌
INSERT INTO ACCOUNT (ACCOUNT_ID, OWNER_NAME, BALANCE)
VALUES (1, '사장님', 0);

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

-- 결제 테이블 (고객 ID + 고객 이름 + 입금 계좌 ID 포함)
CREATE TABLE PAYMENT (
    PAYMENT_ID     NUMBER PRIMARY KEY,            -- 결제 고유 ID
    CUSTOMER_ID    NUMBER NOT NULL,               -- 결제한 고객 ID (정확한 추적용)
    AMOUNT         NUMBER(10) NOT NULL,           -- 결제 금액
    PAYMENT_DATE   DATE DEFAULT SYSDATE,           -- 결제 일시
    ACCOUNT_ID     NUMBER NOT NULL,                -- 입금된 계좌 ID (사장 계좌)

    -- 외래키 제약조건
    CONSTRAINT FK_PAYMENT_CUSTOMER
      FOREIGN KEY (CUSTOMER_ID)
      REFERENCES noir_member(member_id),

    CONSTRAINT FK_PAYMENT_ACCOUNT
      FOREIGN KEY (ACCOUNT_ID)
      REFERENCES ACCOUNT(ACCOUNT_ID)
);

CREATE SEQUENCE PAYMENT_SEQ
  START WITH 1       -- 시작 값
  INCREMENT BY 1     -- 증가 값
  NOCACHE            -- 캐싱 안함 (옵션)
  NOCYCLE;           -- 다시 1부터 시작하지 않음
  
CREATE OR REPLACE TRIGGER TRG_PAYMENT_ID
BEFORE INSERT ON PAYMENT
FOR EACH ROW
BEGIN
  :NEW.PAYMENT_ID := PAYMENT_SEQ.NEXTVAL;
END;
/
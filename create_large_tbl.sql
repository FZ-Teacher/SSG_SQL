REM   -----------------------------------------------------------------------------
REM  100만건의 dummy 데이터 생성
REM	EMP_LARGE	 	사원정보 테이블
REM  	BONUS_LARGE 	월별 보너스 지급 현황 테이블
REM   -----------------------------------------------------------------------------


DROP TABLE EMP_LARGE;
DROP TABLE BONUS_LARGE;


CREATE TABLE EMP_LARGE
(	EMPNO	NUMBER(7),			-- 사번
	ENAME	VARCHAR2(10),		-- 이름
	JOB		VARCHAR2(9),	-- 직업
	MGR		NUMBER(4),		-- 매니저 사번
	HIREDATE	DATE,			-- 입사일
	SAL		NUMBER(7,2),	-- 급여
	COMM		NUMBER(7,2),	-- 실적 커미션
	DEPTNO	NUMBER(2)		-- 근무부서
);



CREATE TABLE BONUS_LARGE
	(
	YYYYMM	VARCHAR2(6),	-- 보너스 지급 년월 (YYYYMM)
	EMPNO		NUMBER(7),		-- 사번
	JOB		VARCHAR2(9),	-- 직업
      DEPTNO	NUMBER(2)		-- 근무부서
	SAL		NUMBER(7,2),	-- 급여
	BONUS		NUMBER		-- 보너스
	);


/*-	부서정보 
CREATE TABLE DEPARTMENTS (
		DEPT_ID		NUMBER(2) 	CONSTRAINT PK_DEPARTMENTS PRIMARY KEY, -- 부서번호
		DEPT_NAME		VARCHAR2(14) ,	    -- 부서명	
		LOC			VARCHAR2(13)	    -- 부서위치
) ;
*/

REM ----------------------------------------------------------
REM -- 데이터 생성
REM ----------------------------------------------------------

/*
INSERT INTO DEPARTMENTS VALUES(10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPARTMENTS VALUES(20,'RESEARCH','DALLAS');
INSERT INTO DEPARTMENTS VALUES(30,'SALES','CHICAGO');
INSERT INTO DEPARTMENTS VALUES(40,'OPERATIONS','BOSTON');
*/ 

INSERT INTO EMP_LARGE VALUES
(7369,'SMITH','CLERK',7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP_LARGE VALUES
(7499,'ALLEN','SALESMAN',7698,to_date('20-2-1981','dd-mm-yyyy'),1600,300,30);
INSERT INTO EMP_LARGE VALUES
(7521,'WARD','SALESMAN',7698,to_date('22-2-1981','dd-mm-yyyy'),1250,500,30);
INSERT INTO EMP_LARGE VALUES
(7566,'JONES','MANAGER',7839,to_date('2-4-1981','dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMP_LARGE VALUES
(7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMP_LARGE VALUES
(7698,'BLAKE','MANAGER',7839,to_date('1-5-1981','dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMP_LARGE VALUES
(7782,'CLARK','MANAGER',7839,to_date('9-6-1981','dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMP_LARGE VALUES
(7788,'SCOTT','ANALYST',7566,to_date('13-6-87','dd-mm-rr')-85,3000,NULL,20);
INSERT INTO EMP_LARGE VALUES
(7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP_LARGE VALUES
(7844,'TURNER','SALESMAN',7698,to_date('8-9-1981','dd-mm-yyyy'),1500,0,30);
INSERT INTO EMP_LARGE VALUES
(7876,'ADAMS','CLERK',7788,to_date('13-6-87', 'dd-mm-rr')-51,1100,NULL,20);
INSERT INTO EMP_LARGE VALUES
(7900,'JAMES','CLERK',7698,to_date('3-12-1981','dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMP_LARGE VALUES
(7902,'FORD','ANALYST',7566,to_date('3-12-1981','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP_LARGE VALUES
(7934,'MILLER','CLERK',7782,to_date('23-1-1982','dd-mm-yyyy'),1300,NULL,10);

COMMIT;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;

INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE;
INSERT INTO EMP_LARGE SELECT * FROM EMP_LARGE where rownum <= 82496 ;
COMMIT;


REM ----------------------------------------------------------
REM -- 사번을 고유한 일련번호로 수정
REM ----------------------------------------------------------

UPDATE EMP_LARGE SET EMPNO = ROWNUM;
COMMIT;

REM ----------------------------------------------------------
REM -- JOB = 'PRESIDENT' 는 1명으로 수정 , ENGINEER는 71428명 
REM ----------------------------------------------------------

UPDATE EMP_LARGE 
SET   JOB = 'ENGINEER'
WHERE JOB = 'PRESIDENT' AND 
	 EMPNO <> ( SELECT EMPNO FROM EMP_LARGE 
			 WHERE JOB='PRESIDENT' AND ROWNUM =1);

REM ---------------------------------------------------------------
REM -- JOB = 'ANALYST'는 10명으로 수정
REM ---------------------------------------------------------------

UPDATE EMP_LARGE 
SET JOB = 'CLERK'
WHERE JOB = 'ANALYST' AND 
	 EMPNO NOT IN (  SELECT EMPNO FROM EMP_LARGE 
				WHERE JOB='ANALYST' AND ROWNUM <=10); 

COMMIT;



REM ------------------------------------------------------------------
REM --  ename random 10자 문자로 변경
REM ------------------------------------------------------------------

update emp_large set ename=dbms_random.string('A',10);
commit;

REM ----------------------------------------------------------
REM -- EMP_LARGE 테이블의 EMPNO 컬럼에 P.K 부여
REM ----------------------------------------------------------

ALTER TABLE EMP_LARGE ADD CONSTRAINT EMP_LARGE_EMPNO_PK PRIMARY KEY(EMPNO);

CREATE INDEX EMP_LARGE_JOB_IDX ON EMP_LARGE(JOB) TABLESPACE USERS; 

REM ----------------------------------------------------------
REM Tablespace를 지정가능한 경우
REM ALTER TABLE EMP_LARGE ADD CONSTRAINT EMP_LARGE_EMPNO_PK PRIMARY KEY(EMPNO)
REM USING INDEX TABLESPACE INDX;
REM ----------------------------------------------------------

/* JOB 컬럼에 불균등한 데이터 생성후 Histogram을 생성 하지 않은 상태에서 옵티마이저 판단을 실습하기 위해 FOR COLUMNS 구문을 사용하지 않는다 */ 

ANALYZE TABLE EMP_LARGE COMPUTE STATISTICS;

ANALYZE TABLE EMP_LARGE ESTIMATE STATISTICS SAMPLE 10 PERCENT FOR TABLE FOR ALL INDEXES FOR ALL INDEXED COLUMNS;
ANALYZE TABLE EMP_LARGE COMPUTE STATISTICS FOR TABLE FOR ALL INDEXES FOR ALL INDEXED COLUMNS;

ANALYZE TABLE EMP_LARGE ESTIMATE STATISTICS SAMPLE 10 PERCENT FOR TABLE FOR ALL COLUMNS;

/*
-- EXECUTE DBMS_STATS.GATHER_TABLE_STATS(ownname=>'SCOTT',tabname=>'EMP_LARGE',estimate_percent=>10,method_opt=>'FOR COLUMNS EMPNO FOR ALL INDEXED COLUMNS SIZE 20 ',cascade=>TRUE);

--EXECUTE DBMS_STATS.GATHER_TABLE_STATS(ownname=>'SCOTT',tabname=>'EMP_LARGE',estimate_percent=>10,method_opt=>'FOR COLUMNS (EMPNO,JOB) FOR ALL INDEXED COLUMNS SIZE 20 ',cascade=>TRUE);

--EXECUTE DBMS_STATS.GATHER_INDEX_STATS(ownname=>'SCOTT',tabname=>'EMP_LARGE',estimate_percent=>10,method_opt=>' FOR COLUMNS (EMPNO,JOB) FOR ALL INDEXED COLUMNS SIZE 20 ',cascade=>TRUE);
*/

SELECT COUNT(*) FROM EMP_LARGE;
SELECT JOB,COUNT(*) FROM EMP_LARGE
GROUP BY JOB;

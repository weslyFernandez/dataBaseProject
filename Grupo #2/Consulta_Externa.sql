-- CONSULTA EXTERNA GRUPO #2

CREATE TABLE HOSPITAL.HPTL_CITAS (
		ID INTEGER NOT NULL,
		PACIENTES_ID INTEGER NOT NULL,
		CLINICAS_ID INTEGER NOT NULL,
		DOCTORES_ID INTEGER NOT NULL,
		ESPECIALIDAD_DOC_ID INTEGER,
		ESTATUS CHAR,
		OBSERVACIONES VARCHAR(60),
		FECHA_CITA_INICIO TIMESTAMP,
		FECHA_CITA_FIN TIMESTAMP,
		VERSION NUMERIC(5,0) NOT NULL,
		CONSTRAINT HPTL_CITAS_PK PRIMARY KEY (ID),
		CONSTRAINT HPTL_PAC_PK_HPTL_CIT_FK FOREIGN KEY (PACIENTES_ID) REFERENCES HOSPITAL.HPTL_PACIENTES(ID),
		CONSTRAINT HPTL_DOC_PK_HPTL_CIT_FK FOREIGN KEY (DOCTORES_ID) REFERENCES HOSPITAL.HPTL_DOCTORES(ID),
		CONSTRAINT HPTL_CLI_PK_HPTL_CIT_FK FOREIGN KEY (CLINICAS_ID) REFERENCES HOSPITAL.HPTL_CLINICAS(ID),
 		CONSTRAINT HPTL_ESP_PK_HPTL_CIT_FK FOREIGN KEY (ESPECIALIDAD_DOC_ID) REFERENCES HOSPITAL.HPTL_ESPECIALIDADES_DOC(ID)
);


CREATE TABLE HOSPITAL.HPTL_HIS_MEDICA_DETA (
		ID INTEGER NOT NULL,
		OBSERVACIONES VARCHAR(50),
		CITAS_ID INTEGER,
		VERSION NUMERIC(5,0) NOT NULL,
		CONSTRAINT HPTL_HIS_MEDICA_DETA_PK PRIMARY KEY (ID),
		CONSTRAINT HPTL_CIT_PK_HPTL_HIS_FK FOREIGN KEY (CITAS_ID) REFERENCES HOSPITAL.HPTL_CITAS(ID)
);

CREATE TABLE HOSPITAL.HPTL_RECETAS (
		ID INTEGER NOT NULL,
		HIS_DET_ID INTEGER,
		OBSERVACIONES VARCHAR(250),
		VERSION NUMERIC(5,0) NOT NULL,
		CONSTRAINT HPTL_RECETAS_PK PRIMARY KEY (ID),
		CONSTRAINT HPTL_HIS_PK_HPTL_REC_FK FOREIGN KEY (HIS_DET_ID) REFERENCES HOSPITAL.HPTL_HIS_MEDICA_DETA(ID)
);

CREATE TABLE HOSPITAL.HPTL_HIS_EXAMENES (
		EXAMENES_ID INTEGER NOT NULL,
		HIS_DET_ID INTEGER NOT NULL,
		CONSTRAINT HPTL_HIS_EXAMENES_UK UNIQUE (EXAMENES_ID,HIS_DET_ID),
		CONSTRAINT HPTL_EXA_PK_HPTL_HIS_EXA_FK FOREIGN KEY (EXAMENES_ID) REFERENCES HOSPITAL.HPTL_EXAMENES,
		CONSTRAINT HPTL_HIS_PK_HPTL_HIS_EXA_FK FOREIGN KEY (HIS_DET_ID) REFERENCES HOSPITAL.HPTL_HIS_MEDICA_DETA
);

CREATE TABLE HOSPITAL.HPTL_RECETA_MEDICAMENTO (
		ID INTEGER NOT NULL,
		RECETA_ID INTEGER NOT NULL,
		MEDICAMENTO_ID INTEGER NOT NULL,
		CANTIDAD INTEGER,
		VERSION NUMERIC(5,0)  NOT NULL,
		CONSTRAINT HPTL_RECMED_PK PRIMARY KEY (ID),
		CONSTRAINT HPTL_REC_PK_HPTL_REC_FK FOREIGN KEY (RECETA_ID) REFERENCES HOSPITAL.HPTL_RECETAS,
		CONSTRAINT HPTL_MED_PK_HPTL_MED_FK FOREIGN KEY (MEDICAMENTO_ID) REFERENCES HOSPITAL.HPTL_MEDICAMENTOS
);

CREATE TABLE HOSPITAL.HPTL_BITCNSEXT (
    ID_BITCNSEXT INTEGER NOT NULL,
    TABLA_BITCNSEXT VARCHAR2(30),
    IDTABLA_BITCNSEXT INTEGER,
    CAMPO_BITCNSEXT VARCHAR2(30),
    VANTERIOR_BITCNSEXT VARCHAR2(250),
    VNUEVO_BITCNSEXT VARCHAR2(250),
    FECHA_BITCNSEXT TIMESTAMP NOT NULL,
    USER_BITCNSEXT VARCHAR2 (30),
    CONSTRAINT PK_HPTL_BITCNSEXT PRIMARY KEY (ID_BITCNSEXT)
);

------------- TRIGER PARA HPTL_CITAS -------------
-- TRIGER UPDATE CITAS
CREATE TRIGGER HOSPITAL.HPTL_UCITAS
AFTER UPDATE ON HOSPITAL.HPTL_CITAS 
FOR EACH ROW
BEGIN
	-- CLINICAS
	IF :NEW.CLINICAS_ID != :OLD.CLINICAS_ID THEN
		INSERT INTO
		HOSPITAL.HPTL_BITCNSEXT
		(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
		VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_CITAS',:OLD.ID,'CLINICAS',(SELECT DESCRIPCION FROM HOSPITAL.HPTL_CLINICAS WHERE ID = :OLD.CLINICAS_ID),(SELECT DESCRIPCION FROM HOSPITAL.HPTL_CLINICAS WHERE ID = :NEW.CLINICAS_ID),SYSDATE,USERENV('CLIENT_INFO'));
	END IF;
	-- ESTATUS
	IF :NEW.ESTATUS != :OLD.ESTATUS THEN
		INSERT INTO
		HOSPITAL.HPTL_BITCNSEXT
		(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
		VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_CITAS',:OLD.ID,'ESTATUS',:OLD.ESTATUS,:NEW.ESTATUS,SYSDATE,USERENV('CLIENT_INFO'));
	END IF;
	-- OBSERVACIONES
	IF :NEW.OBSERVACIONES != :OLD.OBSERVACIONES THEN
		INSERT INTO
		HOSPITAL.HPTL_BITCNSEXT
		(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
		VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_CITAS',:OLD.ID,'OBSERVACIONES',:OLD.OBSERVACIONES,:NEW.OBSERVACIONES,SYSDATE,USERENV('CLIENT_INFO'));
	END IF;
	-- DOCTORES
	IF :NEW.DOCTORES_ID != :OLD.DOCTORES_ID THEN
		INSERT INTO
		HOSPITAL.HPTL_BITCNSEXT
		(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
		VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_CITAS',:OLD.ID,'DOCTORES',
		(SELECT PRIMER_NOMBRE FROM HOSPITAL.HPTL_PERSONAS INNER JOIN HPTL_EMPLEADOS ON HPTL_PERSONAS.ID = HPTL_EMPLEADOS.PERSONAS_ID INNER JOIN HPTL_DOCTORES ON HPTL_EMPLEADOS.ID = HPTL_DOCTORES.EMPLEADOS_ID WHERE HPTL_DOCTORES.ID = :OLD.DOCTORES_ID) || ' ' ||
		(SELECT PRIMER_APELLIDO FROM HOSPITAL.HPTL_PERSONAS INNER JOIN HPTL_EMPLEADOS ON HPTL_PERSONAS.ID = HPTL_EMPLEADOS.PERSONAS_ID INNER JOIN HPTL_DOCTORES ON HPTL_EMPLEADOS.ID = HPTL_DOCTORES.EMPLEADOS_ID WHERE HPTL_DOCTORES.ID = :OLD.DOCTORES_ID),
		(SELECT PRIMER_NOMBRE FROM HOSPITAL.HPTL_PERSONAS INNER JOIN HPTL_EMPLEADOS ON HPTL_PERSONAS.ID = HPTL_EMPLEADOS.PERSONAS_ID INNER JOIN HPTL_DOCTORES ON HPTL_EMPLEADOS.ID = HPTL_DOCTORES.EMPLEADOS_ID WHERE HPTL_DOCTORES.ID = :NEW.DOCTORES_ID)  || ' ' ||
		(SELECT PRIMER_APELLIDO FROM HOSPITAL.HPTL_PERSONAS INNER JOIN HPTL_EMPLEADOS ON HPTL_PERSONAS.ID = HPTL_EMPLEADOS.PERSONAS_ID INNER JOIN HPTL_DOCTORES ON HPTL_EMPLEADOS.ID = HPTL_DOCTORES.EMPLEADOS_ID WHERE HPTL_DOCTORES.ID = :NEW.DOCTORES_ID),
		SYSDATE,USERENV('CLIENT_INFO'));
	END IF;
	-- FECHA_INICIO_CITA
	/*IF :NEW.FECHA_INICIO_CITA != :OLD.FECHA_INICIO_CITA THEN
		INSERT INTO
		HOSPITAL.HPTL_BITCNSEXT
		(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
		VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_CITAS',:OLD.ID,'FECHA_INICIO_CITA',TO_CHAR(:OLD.FECHA_INICIO_CITA),TO_CHAR(:NEW.FECHA_INICIO_CITA),
		SYSDATE,USERENV('CLIENT_INFO'));
	END IF;
	-- FECHA_INICIO_CITA
	IF :NEW.FECHA_FIN_CITA != :OLD.FECHA_FIN_CITA THEN
		INSERT INTO
		HOSPITAL.HPTL_BITCNSEXT
		(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
		VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_CITAS',:OLD.ID,'FECHA_INICIO_CITA',TO_CHAR(:OLD.FECHA_FIN_CITA),TO_CHAR(:NEW.FECHA_FIN_CITA),
		SYSDATE,USERENV('CLIENT_INFO'));
	END IF;*/
END;

-- TRIGER INSERT CITAS
CREATE TRIGGER HOSPITAL.HPTL_ICITAS
AFTER INSERT ON HOSPITAL.HPTL_CITAS 
FOR EACH ROW
BEGIN
	-- CLINICAS
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_CITAS',:NEW.ID,'CLINICAS',(SELECT DESCRIPCION FROM HOSPITAL.HPTL_CLINICAS WHERE ID = :NEW.CLINICAS_ID),SYSDATE,USERENV('CLIENT_INFO'));
	-- ESTATUS
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_CITAS',:NEW.ID,'ESTATUS',:NEW.ESTATUS,SYSDATE,USERENV('CLIENT_INFO'));
	-- OBSERVACIONES
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_CITAS',:NEW.ID,'OBSERVACIONES',:NEW.OBSERVACIONES,SYSDATE,USERENV('CLIENT_INFO'));
	-- DOCTORES
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_CITAS',:NEW.ID,'DOCTORES',
	(SELECT PRIMER_NOMBRE FROM HOSPITAL.HPTL_PERSONAS INNER JOIN HPTL_EMPLEADOS ON HPTL_PERSONAS.ID = HPTL_EMPLEADOS.PERSONAS_ID INNER JOIN HPTL_DOCTORES ON HPTL_EMPLEADOS.ID = HPTL_DOCTORES.EMPLEADOS_ID WHERE HPTL_DOCTORES.ID = :NEW.DOCTORES_ID)  || ' ' ||
	(SELECT PRIMER_APELLIDO FROM HOSPITAL.HPTL_PERSONAS INNER JOIN HPTL_EMPLEADOS ON HPTL_PERSONAS.ID = HPTL_EMPLEADOS.PERSONAS_ID INNER JOIN HPTL_DOCTORES ON HPTL_EMPLEADOS.ID = HPTL_DOCTORES.EMPLEADOS_ID WHERE HPTL_DOCTORES.ID = :NEW.DOCTORES_ID),
	SYSDATE,USERENV('CLIENT_INFO'));
END;


-- TRIGGER DELETE CITAS;
CREATE TRIGGER HOSPITAL.HPTL_DCITAS
BEFORE DELETE ON HOSPITAL.HPTL_CITAS 
FOR EACH ROW
BEGIN
	-- CLINICAS
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_CITAS',:OLD.ID,'CLINICAS',(SELECT DESCRIPCION FROM HOSPITAL.HPTL_CLINICAS WHERE ID = :OLD.CLINICAS_ID),SYSDATE,USERENV('CLIENT_INFO'));
	-- ESTATUS
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_CITAS',:OLD.ID,'ESTATUS',:OLD.ESTATUS,SYSDATE,USERENV('CLIENT_INFO'));
	-- OBSERVACIONES
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_CITAS',:OLD.ID,'OBSERVACIONES',:OLD.OBSERVACIONES,SYSDATE,USERENV('CLIENT_INFO'));
	-- DOCTORES
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_CITAS',:OLD.ID,'DOCTORES',
	(SELECT PRIMER_NOMBRE FROM HOSPITAL.HPTL_PERSONAS INNER JOIN HPTL_EMPLEADOS ON HPTL_PERSONAS.ID = HPTL_EMPLEADOS.PERSONAS_ID INNER JOIN HPTL_DOCTORES ON HPTL_EMPLEADOS.ID = HPTL_DOCTORES.EMPLEADOS_ID WHERE HPTL_DOCTORES.ID = :OLD.DOCTORES_ID)  || ' ' ||
	(SELECT PRIMER_APELLIDO FROM HOSPITAL.HPTL_PERSONAS INNER JOIN HPTL_EMPLEADOS ON HPTL_PERSONAS.ID = HPTL_EMPLEADOS.PERSONAS_ID INNER JOIN HPTL_DOCTORES ON HPTL_EMPLEADOS.ID = HPTL_DOCTORES.EMPLEADOS_ID WHERE HPTL_DOCTORES.ID = :OLD.DOCTORES_ID),
	SYSDATE,USERENV('CLIENT_INFO'));
END;


------------- TRIGER PARA HPTL_UHIS_MEDICA_DETA -------------
CREATE TRIGGER HOSPITAL.HPTL_UHIS_MEDICA_DETA
AFTER UPDATE ON HOSPITAL.HPTL_HIS_MEDICA_DETA 
FOR EACH ROW
BEGIN
	-- OBSERVACIONES
	IF :NEW.OBSERVACIONES != :OLD.OBSERVACIONES THEN
		INSERT INTO
		HOSPITAL.HPTL_BITCNSEXT
		(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
		VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_HIS_MEDICA_DETA',:OLD.ID,'OBSERVACIONES', :OLD.OBSERVACIONES,:NEW.OBSERVACIONES,SYSDATE,USERENV('CLIENT_INFO'));
	END IF;
	-- CITAS_ID
	IF :NEW.CITAS_ID != :OLD.CITAS_ID THEN
		INSERT INTO
		HOSPITAL.HPTL_BITCNSEXT
		(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
		VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_HIS_MEDICA_DETA',:OLD.ID,'CITAS_ID',:OLD.CITAS_ID,:NEW.CITAS_ID,SYSDATE,USERENV('CLIENT_INFO'));
	END IF;
END;

-- TRIGGER INSERT HIS_MEDICA_DETA
CREATE TRIGGER HOSPITAL.HPTL_IHIS_MEDICA_DETA
AFTER INSERT ON HOSPITAL.HPTL_HIS_MEDICA_DETA 
FOR EACH ROW
BEGIN
	-- OBSERVACIONES
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_HIS_MEDICA_DETA',:NEW.ID,'OBSERVACIONES', :NEW.OBSERVACIONES,SYSDATE,USERENV('CLIENT_INFO'));
	-- CITAS_ID
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_HIS_MEDICA_DETA',:NEW.ID,'CITAS_ID',:NEW.CITAS_ID,SYSDATE,USERENV('CLIENT_INFO'));
END;

-- TRIGGER DELETE HIS_MEDICA_DETA
CREATE TRIGGER HOSPITAL.HPTL_DHIS_MEDICA_DETA
BEFORE DELETE ON HOSPITAL.HPTL_HIS_MEDICA_DETA 
FOR EACH ROW
BEGIN
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_HIS_MEDICA_DETA',:OLD.ID,'OBSERVACIONES', :OLD.OBSERVACIONES,SYSDATE,USERENV('CLIENT_INFO'));
	-- CITAS_ID
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_HIS_MEDICA_DETA',:OLD.ID,'CITAS_ID',:OLD.CITAS_ID,SYSDATE,USERENV('CLIENT_INFO'));
END;

------------- TRIGER PARA HPTL_RECETAS -------------
-- TRIGER UPDATE HPTL_RECETAS
CREATE TRIGGER HOSPITAL.HPTL_URECETAS
AFTER UPDATE ON HOSPITAL.HPTL_RECETAS 
FOR EACH ROW
BEGIN
	-- OBSERVACIONES
	IF :NEW.OBSERVACIONES != :OLD.OBSERVACIONES THEN
		INSERT INTO
		HOSPITAL.HPTL_BITCNSEXT
		(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
		VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_RECETAS',:OLD.ID,'OBSERVACIONES', :OLD.OBSERVACIONES,:NEW.OBSERVACIONES,SYSDATE,USERENV('CLIENT_INFO'));
	END IF;
	-- HIS_DET_ID
	IF :NEW.HIS_DET_ID != :OLD.HIS_DET_ID THEN
		INSERT INTO
		HOSPITAL.HPTL_BITCNSEXT
		(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
		VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_RECETAS',:OLD.ID,'HIS_DET_ID',:OLD.HIS_DET_ID,:NEW.HIS_DET_ID,SYSDATE,USERENV('CLIENT_INFO'));
	END IF;
END;

-- TRIGGER INSERT HPTL_RECETAS
CREATE TRIGGER HOSPITAL.HPTL_IRECETAS
AFTER INSERT ON HOSPITAL.HPTL_RECETAS 
FOR EACH ROW
BEGIN
	-- OBSERVACIONES
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_RECETAS',:NEW.ID,'OBSERVACIONES', :NEW.OBSERVACIONES,SYSDATE,USERENV('CLIENT_INFO'));
	-- HIS_DET_ID
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VNUEVO_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_HIS_MEDICA_DETA',:NEW.ID,'HIS_DET_ID',:NEW.HIS_DET_ID,SYSDATE,USERENV('CLIENT_INFO'));
END;


-- TRIGGER DELETE HPTL_RECETAS
CREATE TRIGGER HOSPITAL.HPTL_DRECETAS
BEFORE DELETE ON HOSPITAL.HPTL_RECETAS 
FOR EACH ROW
BEGIN
	-- OBSERVACIONES
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_RECETAS',:OLD.ID,'OBSERVACIONES', :OLD.OBSERVACIONES,SYSDATE,USERENV('CLIENT_INFO'));
	-- HIS_DET_ID
	INSERT INTO
	HOSPITAL.HPTL_BITCNSEXT
	(ID_BITCNSEXT, TABLA_BITCNSEXT, IDTABLA_BITCNSEXT, CAMPO_BITCNSEXT, VANTERIOR_BITCNSEXT, FECHA_BITCNSEXT, USER_BITCNSEXT)
	VALUES (HOSPITAL.HPTL_BITCNSEXT_SEQ.NEXTVAL,'HPTL_RECETAS',:OLD.ID,'HIS_DET_ID',:OLD.HIS_DET_ID,SYSDATE,USERENV('CLIENT_INFO'));
END;


CREATE SEQUENCE HOSPITAL.HPTL_CITAS_SEQ 
INCREMENT BY 1
START WITH 1
NOMAXVALUE;

CREATE SEQUENCE HOSPITAL.HPTL_HIS_MEDICA_DETA_SEQ 
INCREMENT BY 1
START WITH 1
NOMAXVALUE;

CREATE SEQUENCE HOSPITAL.HPTL_RECETAS_SEQ 
INCREMENT BY 1
START WITH 1
NOMAXVALUE;

CREATE SEQUENCE HOSPITAL.HPTL_RECETA_MEDICAMENTO_SEQ
INCREMENT BY 1
START WITH 1
NOMAXVALUE;

CREATE SEQUENCE HOSPITAL.HPTL_BITCNSEXT_SEQ 
INCREMENT BY 1
START WITH 1
NOMAXVALUE;

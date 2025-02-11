CREATE TABLE t_contas (
    cd_conta             NUMBER(*, 0) NOT NULL,
    t_usuario_cd_usuario NUMBER(*, 0) NOT NULL,
    nm_banco             VARCHAR2(50 BYTE),
    nr_agencia           VARCHAR2(10 BYTE),
    nr_contas            VARCHAR2(20 BYTE)
);

ALTER TABLE t_contas ADD CONSTRAINT t_contas_pk PRIMARY KEY ( cd_conta );

CREATE TABLE t_despesas (
    cd_despesas          NUMBER(*, 0) NOT NULL,
    t_usuario_cd_usuario NUMBER(*, 0) NOT NULL,
    ds_descricao         VARCHAR2(100 BYTE),
    vl_valor             NUMBER(10, 2),
    dt_registro          DATE
);

ALTER TABLE t_despesas ADD CONSTRAINT t_despesas_pk PRIMARY KEY ( cd_despesas );

CREATE TABLE t_investimentos (
    cd_investimento      NUMBER(*, 0) NOT NULL,
    t_usuario_cd_usuario NUMBER(*, 0) NOT NULL,
    ds_descrição         VARCHAR2(100 BYTE) NOT NULL,
    vl_investido         NUMBER(10, 2) NOT NULL,
    dt_registro          DATE
);

ALTER TABLE t_investimentos ADD CONSTRAINT t_investimentos_pk PRIMARY KEY ( cd_investimento );

CREATE TABLE t_receitas (
    cd_receita           NUMBER(*, 0) NOT NULL,
    t_usuario_cd_usuario NUMBER(*, 0) NOT NULL,
    ds_descricao         VARCHAR2(100 BYTE),
    vl_valor             NUMBER(10, 2),
    dt_registro          DATE
);

ALTER TABLE t_receitas ADD CONSTRAINT t_receitas_pk PRIMARY KEY ( cd_receita );

CREATE TABLE t_usuario (
    cd_usuario  NUMBER(*, 0) NOT NULL,
    nm_nome     VARCHAR2(50 BYTE),
    id_email    VARCHAR2(50),
    dt_nasc     DATE,
    nr_telefone VARCHAR2(15 BYTE)
);

ALTER TABLE t_usuario ADD CONSTRAINT t_usuario_pk PRIMARY KEY ( cd_usuario );

ALTER TABLE t_contas
    ADD CONSTRAINT t_contas_t_usuario_fk FOREIGN KEY ( t_usuario_cd_usuario )
        REFERENCES t_usuario ( cd_usuario );

ALTER TABLE t_despesas
    ADD CONSTRAINT t_despesas_t_usuario_fk FOREIGN KEY ( t_usuario_cd_usuario )
        REFERENCES t_usuario ( cd_usuario );

ALTER TABLE t_investimentos
    ADD CONSTRAINT t_investimentos_t_usuario_fk FOREIGN KEY ( t_usuario_cd_usuario )
        REFERENCES t_usuario ( cd_usuario );

ALTER TABLE t_receitas
    ADD CONSTRAINT t_receitas_t_usuario_fk FOREIGN KEY ( t_usuario_cd_usuario )
        REFERENCES t_usuario ( cd_usuario );
        
INSERT INTO t_usuario 
    (cd_usuario, nm_nome, id_email, dt_nasc, nr_telefone ) 
    VALUES ('1234567', 'Higor Vilela', '4hv@protonmail.com', TO_DATE('03/05/2004' , 'DD/MM/YYYY'), 11-99999-9999);

INSERT INTO t_contas (cd_conta, cd_usuario, nm_banco, nr_agencia) 
    VALUES ( 1 ,1234567, 'Itáu', 12345678910);

UPDATE t_usuario
    SET nm_nome = 'Higor Vilela', id_email = '4hv@protonmail.com', dt_nasc = '03/05/2004' , nr_telefone = 11-99999-9999);
    WHERE cd_usuario = 1234567;

INSERT INTO receitas (cd_despesas, cd_usuario, ds_descricao, vl_valor, dt_registro) 
    VALUES (2, 1234567, 'Salário', 2500.00, '05/01/2023');

UPDATE t_receitas
    SET ds_descricao = 'Bônus', vl_valor = 1000.00, dt_registro = '04/04/2023' 
    WHERE cd_usuario = 1234567 AND cd_despesas = 2;

INSERT INTO despesas (cd_despesas, cd_usuario, ds_descricao, vl_valor, dt_registro) 
    VALUES (4, 1234567, 'Aluguel', 1000.00, '04/10/2024');

UPDATE despesas 
    SET ds_descricao = 'Condomínio', vl_valor = 500.00, dt_despesa = '04/05/2024' 
    WHERE cd_usuario = 1234567 AND codigo_usuario = 4;

INSERT INTO investimentos (cd_investimento, cd_usuario, ds_descricao, vl_investido, dt_registro) 
    VALUES (3,1234567, 'LFT 2024', 1000.00, '2023-04-01');

UPDATE investimentos 
    SET ds_descricao = 'LFT 2027', vl_investido = 2000.00, dt_registro = '2023-04-15' 
    WHERE cd_investimento = 3 AND cd_usuario = 1234567;

SELECT * FROM t_usuario WHERE cd_usuario = 1234567;

SELECT * FROM t_despesa WHERE cd_usuario = 1234567; AND cd_despesa = 4;

SELECT * FROM t_despesa WHERE cd_usuario = 1234567 ORDER BY dt_registro DESC;

SELECT * FROM t_investimentos WHERE cd_usuario = 1234567; AND cd_investimento = 3;

SELECT * FROM t_investimentos WHERE cd_usuario = 1234567; ORDER BY dt_registro DESC;

SELECT u.nm_nome, u.id_email, i.vl_valor, d.nr_telefone
FROM t_usuario 
LEFT JOIN (
  SELECT cd_usuario, vl_investido
  FROM t_investimentos
  WHERE data = (SELECT MAX(data) FROM t_investimentos)
) i ON u.codigo = i.cd_usuario
LEFT JOIN (
  SELECT cd_usuario, vl_registro
  FROM t_despesas
  WHERE data = (SELECT MAX(data) FROM t_despesas)
) d ON u.codigo = d.cd_usuario
WHERE u.codigo = 'CODIGO_DO_USUARIO';

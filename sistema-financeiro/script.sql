-- TABELAS
-----------

CREATE TABLE CLIENTE
(
  id_cliente NUMBER(7) NOT NULL,
  cpf VARCHAR2(11) NOT NULL,
  nome VARCHAR2(50) NOT NULL,
  dt_nascimento DATE NOT NULL,
  sexo CHAR(1) NOT NULL CHECK (sexo IN ('F', 'M')), -- Feminino, Masculino
  est_civil VARCHAR2(1) NOT NULL,
  CONSTRAINT cliente_pk PRIMARY KEY (id_cliente),
  CONSTRAINT cliente_uk1 UNIQUE KEY (cpf)
);

CREATE TABLE ESTABELECIMENTO
(
  id_estabelecimento NUMBER(8) NOT NULL,
  cnpj VARCHAR2(14) NOT NULL,
  razao_social VARCHAR2(80) NOT NULL,
  nome_fantasia VARCHAR2(80) NOT NULL,
  dt_cadastro DATE NOT NULL,
  ativo VARCHAR2(1) NOT NULL CHECK (ativo IN ('S', 'N');
  id_ramo NUMBER(10) NOT NULL,
  end_logradouro VARCHAR2(20) NOT NULL,
  end_nome VARCHAR2(50) NOT NULL,
  end_numero VARCHAR2(10) NOT NULL,
  end_complemento VARCHAR2(20),
  end_bairro VARCHAR2(30) NOT NULL,
  end_cep VARCHAR2(10) NOT NULL,
  prazo_pagto NUMBER(10) NOT NULL,
  taxa_transacao NUMBER(14,8) NOT NULL,
  id_matriz NUMBER(10),
  CONSTRAINT estabelecimento_pk PRIMARY KEY (id_estabelecimento),
  CONSTRAINT estabelecimento_uk1 UNIQUE KEY (cnpj)
  CONSTRAINT estabelecimento_fk1 FOREIGN KEY (id_matriz) REFERENCES ESTABELECIMENTO(id_estabelecimento)
);
 
CREATE TABLE PRODUTO
(
  id_produto NUMBER(5) NOT NULL,
  descricao VARCHAR2(50) NOT NULL,
  tipo CHAR(1) NOT NULL CHECK (tipo IN ('C', 'P', 'B')), -- Comum, Private Label, Cobranded
  ativo CHAR(1) NOT NULL CHECK (ativo IN ('S', 'N')), -- Sim, Não
  id_estabelecimento NUMBER(8),
  CONSTRAINT produto_pk PRIMARY KEY (id_produto),
  CONSTRAINT produto_fk1 FOREIGN KEY (id_estabelecimento) REFERENCES ESTABELECIMENTO(id_estabelecimento)
);

CREATE TABLE TELEFONE
(
  id_telefone NUMBER(12) NOT NULL,
  id_cliente NUMBER(7) NOT NULL,
  tipo CHAR(1) NOT NULL CHECK (teleone IN ('C', 'R', 'S')), -- Contato, Recado, Secundário
  ativo CHAR(1) NOT NULL CHECK (ativo IN ('S', 'N')), -- Sim, Não
  ddd VARCHAR2(2) NOT NULL,
  numero VARCHAR2(9) NOT NULL,
  CONSTRAINT telefone_pk PRIMARY KEY (id_telefone),
  CONSTRAINT telefone_pk1 FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente)
);

CREATE TABLE ENDERECO
(
  id_endereco NUMBER(12) NOT NULL,
  id_cliente NUMBER(7) NOT NULL,
  tipo CHAR(1) NOT NULL CHECK (tipo IN ('R', 'C')), -- Residencial, Correspondência
  ativo CHAR(1) NOT NULL CHECK (ativo in ('S', 'N')), -- Sim, Não
  logradouro VARCHAR2(20) NOT NULL,
  endereco    VARCHAR2(50) NOT NULL,
  numero      VARCHAR2(10) NOT NULL,
  bairro      VARCHAR2(30) NOT NULL,
  cep         VARCHAR2(10) NOT NULL,
  complemento VARCHAR2(30),
  CONSTRAINT endereco_pk PRIMARY KEY (id_endereco),
  CONSTRAINT endereco_fk1 FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente)
);

CREATE TABLE CLIENTE_PRODUTO
(
  id_cliente NUMBER(7) NOT NULL,
  id_produto NUMBER(5) NOT NULL,
  ativo CHAR(1) NOT NULL CHECK (ativo in ('S', 'N')), -- Sim, Não
  limite_liberado NUMBER(14,2) NOT NULL,
  limite_consumido NUMBER(14,2),
  tp_limite CHAR(1) NOT NULL CHECK (tp_limite in ('C', 'I')), -- Compartilhado, Individual
  dt_vencto DATE NOT NULL CHECK (dt_fecto BETWEEN 1 AND 28),
  dt_fecto DATE NOT NULL CHECK (dt_fecto BETWEEN 1 AND 31),
  CONSTRAINT cliente_produto_pk PRIMARY KEY (id_cliente, id_produto),
  CONSTRAINT cliente_produto_fk1 FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente),
  CONSTRAINT cliente_produto_fk2 FOREIGN KEY (id_produto) REFERENCES PRODUTO(id_produto)
);
 
CREATE TABLE CARTAO
(
  id_cartao NUMBER(12) NOT NULL,
  id_cliente NUMBER(7) NOT NULL,
  id_produto NUMBER(5) NOT NULL,
  ativo CHAR(1) NOT NULL CHECK (ativo in ('S', 'N')), -- Sim, Não
  numero VARCHAR2(16) NOT NULL,
  dt_emissao DATE NOT NULL,
  dt_vencimento DATE NOT NULL,
  cvv VARCHAR2(3) NOT NULL,
  cli_nome VARCHAR2(22) NOT NULL,
  limite_liberado NUMBER(14,2),
  limite_consumido NUMBER(14,2),
  id_cliente_adicional NUMBER(10),
  CONSTRAINT cartao_pk PRIMARY KEY (id_cartao),
  CONSTRAINT cartao_fk1 FOREIGN KEY (id_cliente, id_produto) REFERENCES CLIENTE_PRODUTO(id_cliente, id_produto),
  CONSTRAINT cartao_fk2 FOREIGN KEY (id_cliente_adicional) REFERENCES CLIENTE(id_cliente)
);

CREATE TABLE TRANSACAO
(
  id_transacao       NUMBER(15) NOT NULL,
  id_cartao          NUMBER(12) NOT NULL,
  id_estabelecimento NUMBER(8) NOT NULL,
  st_transacao       CHAR(1) NOT NULL CHECK (st_transacao IN ('P', 'A', 'T', 'E', 'C', 'R', 'O')), -- Pendente, Aprovada, auTorizada, Estornada, Cancelada, Recusada, errO
  dt_transacao       TIMESTAMP(6) NOT NULL,
  dt_aprovacao       TIMESTAMP(6),
  vlr_transacao      NUMBER(14,2) NOT NULL,
  vlr_liquidacao     NUMBER(14,2),
  dt_liquidacao      DATE,
  ocorrencia         VARCHAR2(50),
  CONSTRAINT transacao_pk FOREIGN KEY (id_cartao) REFERENCES CARTAO(id_cartao),
  CONSTRAINT transacao_fk1 FOREIGN KEY (id_estabelecimento) REFERENCES ESTABELECIMENTO(id_estabelecimento)
);

-- SEQUENCES 
-------------

CREATE SEQUENCE seq_id_cliente 
  INCREMENT BY 1
  START WITH 1
  MAXVALUE 9999999
  MINVALUE 1
  NOCYCLE;
  
CREATE SEQUENCE seq_id_estabelecimento 
  INCREMENT BY 1
  START WITH 1
  MAXVALUE 99999999
  MINVALUE 1
  NOCYCLE;
  
CREATE SEQUENCE seq_id_produto 
  INCREMENT BY 1
  START WITH 1
  MAXVALUE 99999
  MINVALUE 1
  NOCYCLE;

CREATE SEQUENCE seq_id_telefone 
  INCREMENT BY 1
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE;
  
CREATE SEQUENCE seq_id_endereco 
  INCREMENT BY 1
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE;
  
CREATE SEQUENCE seq_id_cartao
  INCREMENT BY 1
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE;
  
CREATE SEQUENCE seq_id_cartao
  INCREMENT BY 1
  START WITH 1
  MAXVALUE 999999999999999
  MINVALUE 1
  NOCYCLE;
  
-- PROCEDIMENTOS
-----------------


CREATE OR REPLACE PROCEDURE pri_cria_cliente(p_cpf             cliente.cpf%TYPE,
                                             p_nome            cliente.nome%TYPE,
                                             p_dt_nascimento   cliente.dt_nascimento%TYPE,
                                             p_sexo            cliente.sexo%TYPE,
                                             p_est_civil       cliente.est_civil%TYPE,
                                             p_telefone        VARCHAR(11) DEFAULT NULL,
                                             p_end_logradouro  endereco.logradouro%TYPE,
                                             p_end_nome        endereco.endereco%TYPE,   
                                             p_end_numero      endereco.numero%TYPE,
                                             p_end_bairro      endereco.bairro%TYPE,
                                             p_end_cep         endereco.cep%TYPE,
                                             p_end_complemento endereco.complemento%TYPE DEFAULT NULL)
IS

  v_id_cliente cliente.id_cliente%TYPE;
  v_cpf cliente.cpf%TYPE := REPLACE(REPLACE(p_cpf, '.', ''), '-', '');
  v_cpf_dupl PLS_INTEGER;
BEGIN

  SELECT COUNT(*) INTO v_cpf_dupl FROM cliente WHERE cpf = v_cpf;

  IF v_cpf_dupl > 0 THEN
    RAISE_APPLICATION_ERROR('-20000', 'CPF já cadastrado!');
  END IF;

  IF MONTHS_BETWEEN(SYSDATE, p_dt_nascimento) / 12 < 18 THEN
    RAISE_APPLICATION_ERROR('-20000', 'É possível cadastrar somente clientes maiores de idade!');
  END IF;
  
  IF MONTHS_BETWEEN(SYSDATE, p_dt_nascimento) / 12 >= 80 THEN
    RAISE_APPLICATION_ERROR('-20000', 'É permitido cadastrar clientes com idade entre 18 e 80 anos!');
  END IF;
  
  IF p_end_logradouro IS NULL OR p_end_nome IS NULL OR p_end_numero IS NULL OR p_end_bairro IS NULL OR p_end_cep IS NULL THEN 
    RAISE_APPLICATION_ERROR('-20000', 'Cadastro de endereço incompleto!');
  END IF;
  
  INSERT INTO cliente VALUES (seq_id_cliente.NEXTVAL, v_cpf, UPPER(p_nome), dt_nascimento, p_sexo, p_est_civil) RETURNING id_cliente INTO v_id_cliente;
  
  IF p_telefone IS NOT NULL THEN
    
    INSERT INTO telefone VALUES (seq_id_telefone.NEXTVAL, v_id_cliente, 'C', 'S', SUBSTR(p_telefone, 1, 2), SUBSTR(p_telefone, 3)); 
    
  END IF;
  
  INSERT INTO endereco VALUES (seq_id_endereco.NEXTVAL, v_id_cliente, 'R', 'S', p_end_logradouro, p_end_nome, p_end_numero, p_end_bairro, p_end_cep, p_end_complemento);
  
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN 
    RAISE_APPLICATION_ERROR('-20000', 'Erro genérico');
END;
/

---------------------------------------------
---------------------------------------------

CREATE OR REPLACE PROCEDURE pri_cria_cartao_titular(p_id_cliente  cliente.id_cliente%TYPE,
                                                    p_id_produto  produto.id_produto%TYPE,
                                                    p_nome_cartao cartao.cli_nome%TYPE,
                                                    p_dt_vencto   cliente_produto.dt_vencto%TYPE,
                                                    p_tp_limite   cliente_produto.tp_limite%TYPE)
IS

  v_id_cliente       cliente.id_cliente%TYPE;
  v_produto_ativo    produto.ativo%TYPE;
  v_tp_vencto        produto.tp_vencto%TYPE;
  v_cli_produto      PLS_INTEGER;
  v_dt_vencto_cartao cartao.dt_vencto%TYPE;
  v_dt_fecto         cliente_produto.dt_fecto%TYPE;
  v_dt_emissao       cartao.dt_emissao%TYPE;
  v_cvv              cartao.cvv%TYPE;
  v_aux_cvv          PLS_INTEGER;
  v_id_cartao        cartao.id_cartao%TYPE;
BEGIN

  BEGIN
   
    SELECT id_cliente INTO v_id_cliente FROM cliente WHERE id_cliente = p_id_cliente;
    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
      RAISE_APPLICATION_ERROR('-20000', 'Cliente inexistente!');
  END;
  
  BEGIN
   
    SELECT ativo, tp_vencto INTO v_produto_ativo, v_tp_vencto FROM produto WHERE id_produto = p_id_produto;
    
    IF v_produto_ativo = 'N' THEN
      RAISE_APPLICATION_ERROR('-20000', 'Produto desativado!');  
    END IF;
    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
      RAISE_APPLICATION_ERROR('-20000', 'Produto inexistente!');
  END;
  
  SELECT COUNT(*) INTO v_cli_produto FROM cliente_produto WHERE id_cliente = p_id_cliente AND id_produto = p_id_produto;
  
  IF v_cli_produto = 0 THEN
  
    IF p_dt_vencto NOT BETWEEN 1 AND 28 THEN
      RAISE_APPLICATION_ERROR('-20000', 'Data vencimento da fatura inválida!');
    END IF;
    
    v_dt_fecto := p_dt_vencto - 12;
  
    INSERT INTO cliente_produto VALUES (p_id_cliente, p_id_produto, 'S', fn_calc_limite_liberado(id_cliente), 0, 'C', p_tp_limite, p_dt_vencto, v_dt_fecto);
  
  END IF;
  
  v_dt_emissao := TRUNC(SYSDATE);
  
  FOR i IN 1..10 LOOP
  
    v_dt_emissao := v_dt_emissao + DECODE(TO_CHAR(v_dt_emissao+1, 'DY'), '7', 3, '1', 2, 1);
  
  END LOOP;
  
  v_dt_vencto_cartao := ADD_MONTHS(v_dt_emissao, 60);
  v_dt_vencto_cartao := DAY(DECODE(TO_CHAR(LAST_DAY(v_dt_vencto_cartao), 'DY'), '1', LAST_DAY(v_dt_vencto_cartao)-2, 
                                                              '7', LAST_DAY(v_dt_vencto_cartao)-1, 
                                                              LAST_DAY(v_dt_vencto_cartao)));
                                                              
  FOR i IN 1..3 LOOP
  
    IF i = 1 THEN
    
      v_cvv := dbms_random.value(1, 9);
      
    ELSE
    
      LOOP 
      
        v_aux_cvv := NVL(v_aux_cvv + 1, dbms_random.value(0,9));
      
      EXIT WHEN NVL(TO_NUMBER(SUBSTR(v_cvv, 1, 1)), 999) <> v_aux_cvv AND NVL(TO_NUMBER(SUBSTR(v_cvv, 2, 1)), 999) <> v_aux_cvv;

      END LOOP;      
      
      v_cvv := v_cvv || v_aux_cvv;
      
      v_aux_cvv := NULL;
    
    END IF;
    
  END LOOP;
  
  INSERT INTO cartao VALUES (seq_id_cartao.NEXTVAL, 
                             p_id_cliente, 
                             p_id_produto, 
                             fn_gera_numeracao(), 
                             v_dt_emissao, 
                             v_dt_vencto_cartao, 
                             v_cvv, 
                             NVL(p_nome_cartao, fn_gera_nome_cartao(p_id_cliene)),
                             null, null, null) RETURNING id_cartao INTO v_id_cartao;
                             
  UPDATE cartao
     SET ativo = 'N'
   WHERE id_cliente = p_id_cliente
     AND id_produto = p_id_produto
     AND id_cartao <> v_id_cartao
     AND id_cliente_adicional IS NULL;
  
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN 
    RAISE_APPLICATION_ERROR('-20000', 'Erro genérico');
END;
/

---------------------------------------------
---------------------------------------------

CREATE OR REPLACE PROCEDURE pri_cria_estabelecimento (p_cnpj             estabelecimento.cnpj%TYPE,
                                                      p_razao_social     estabelecimento.razao_social%TYPE,
                                                      p_nome_fantasia    estabelecimento.nome_fantasia%TYPE,
                                                      p_dt_cadastro      estabelecimento.dt_cadastro%TYPE,
                                                      p_id_ramo          estabelecimento.id_ramo%TYPE,
                                                      p_end_logradouro   estabelecimento.end_logradouro%TYPE,
                                                      p_end_nome         estabelecimento.end_nome%TYPE,
                                                      p_end_numero       estabelecimento.end_numero%TYPE,
                                                      p_end_complemento  estabelecimento.end_complemento%TYPE,
                                                      p_end_bairro       estabelecimento.end_bairro%TYPE,
                                                      p_end_cep          estabelecimento.end_cep%TYPE,
                                                      p_prazo_pagto      estabelecimento.prazo_pagto%TYPE,
                                                      p_taxa_transacao   estabelecimento.taxa_transacao%TYPE,
                                                      p_id_matriz        estabelecimento.id_matriz%TYPE)
IS
  v_cnpj estabelecimento.cnpj%TYPE := REPLACE(REPLACE(REPLACE(p_cnpj, '/', ''), '.', ''), '-', '');
  v_estabelecimentos PLS_INTEGER;
BEGIN

  SELECT COUNT(*) INTO v_estabelecimentos FROM estabelecimento WHERE cnpj = v_cnpj;

  IF v_estabelecimentos > 0 THEN
    RAISE_APPLICATION_ERROR('-20000', 'CNPJ já cadastrado!');
  END IF;
  
  IF p_end_logradouro IS NULL OR p_end_nome IS NULL OR p_end_numero IS NULL OR p_end_bairro IS NULL OR p_end_cep IS NULL THEN
    RAISE_APPLICATION_ERROR('-20000', 'Cadastro de endereço incompleto!');
  END IF;
  
  INSERT INTO estabelecimento (seq_id_estabelecimento.NEXTVAL,
                               v_cnpj,
                               p_razao_social,
                               p_nome_fantasia,
                               p_dt_cadastro,
                               'S',
                               p_id_ramo,
                               p_end_logradouro,
                               p_end_nome,
                               p_end_numero,
                               p_end_complemento,
                               p_end_bairro,
                               p_end_cep,
                               p_prazo_pagto,
                               p_taxa_transacao,
                               p_id_matriz);

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR('-20000', 'Erro genérico');
END;
/

-----------------------------------------
-----------------------------------------

CREATE OR REPLACE pr_trs_venda(p_id_cartao cartao.id_cartao%TYPE,
                               p_id_estabelecimento estabelecimento.id_estabelecimento%TYPE,
                               p_valor transacao.vlr_transacao%TYPE)
IS

  v_transacao           transacao%ROWTYPE;
  v_cliente_produto     cliente_produto%ROWTYPE;
  v_cartao              cartao%ROWTYPE;
  v_est_estabelecimento estabelecimento.ativo%TYPE;
  v_liq_estabelecimento estabelecimento.prazo_pagto%TYPE;
  v_tax_estabelecimento estabelecimento.taxa_transacao%TYPE;
  v_est_produto         produto.ativo%TYPE;
  v_tp_produto          produto.tipo%TYPE;
  v_estabel_produto     produto.id_estabelecimento%TYPE;
  v_valida_compra       PLS_INTEGER;
  
BEGIN

  v_transacao.id_trasacao := seq_id_transacao.NEXTVAL;
  v_transacao.id_cartao := p_id_cartao;
  v_transacao.id_estabelecimento := p_id_estabelecimento;
  v_transacao.st_transacao := 'P';
  v_transacao.dt_transacao := CURRENT_TIMESTAMP;
  v_transacao.vlr_transacao := p_valor;
    
  SELECT NVL(MAX(ativo), 'N'), 
         prazo_pagto, 
         taxa_transacao 
    INTO v_est_estabelecimento, 
         v_liq_estabelecimento, 
         v_tax_estabelecimento 
    FROM estabelecimento 
   WHERE id_estabelecimento := p_id_estabelecimento;
  
  IF v_est_estabelecimento = 'N' THEN
    v_transacao.ocorrencia := 'ESTABELECIMENTO NÃO AUTORIZADO';
    RAISE nao_autorizado;
  END IF;
  
  -- CARTAO 
  
  BEGIN
  
    SELECT * INTO v_cartao FROM cartao where id_cartao = p_id_cartao;
    
    IF v_cartao.ativo = 'N' THEN
      v_transacao.ocorrencia := 'CARTÃO BLOQUEADO';
      RAISE nao_autorizado;
    END IF;
    
  EXCEPTION
    WHEN no_data_found THEN
      v_transacao.ocorrencia := 'CARTÃO INEXISTENTE';
      RAISE nao_autorizado;
  END;
  
  -- PRODUTO
  
  BEGIN
  
    SELECT ativo, tipo, id_estabelecimento INTO v_est_produto, v_tp_produto, v_estabel_produto FROM produto where id_produto = cartao.id_produto;
    
    IF v_est_produto = 'N' THEN
      v_transacao.ocorrencia := 'PRODUTO BLOQUEADO';
      RAISE nao_autorizado;
    END IF;
    
  EXCEPTION
    WHEN no_data_found THEN
      v_transacao.ocorrencia := 'PRODUTO INEXISTENTE';
      RAISE nao_autorizado;
  END;
  
  
  -- CLIENTE PRODUTO
  
  BEGIN
  
    SELECT * INTO v_cliente_produto FROM cliente_produto WHERE id_cliente = v_cartao.id_cliente AND id_produto = v_cartao.id_produto;
    
    IF v_cliente_produto.ativo = 'N' THEN
      v_transacao.ocorrencia := 'PRODUTO BLOQUEADO PARA O CLIENTE';
      RAISE nao_autorizado;
    END IF;
    
  EXCEPTION
    WHEN no_data_found THEN
      v_transacao.ocorrencia := 'PRODUTO NAO DISPONIVEL PARA O CLIENTE';
      RAISE nao_autorizado;
  END;
  
  IF v_cliente_produto.tipo_limite = 'C' THEN -- Compartilhado

    IF v_cliente_produto.limite_liberado - v_cliente_produto.limite_consumido - p_valor <= 0 THEN
      v_transacao.ocorrencia := 'LIMITE INSUFICIENTE';
      RAISE nao_autorizado;
    END IF;    
    
    v_cliente_produto.limite_consumido := v_cliente_produto.limite_consumido + p_valor;
    
  ELSIF v_cliente_produto.tipo_limite = 'I' THEN -- Individual
  
    IF v_cartao.limite_liberado - v_cartao.limite_consumido - p_valor <= 0 THEN
      v_transacao.ocorrencia := 'LIMITE INSUFICIENTE';
      RAISE nao_autorizado;
    END IF;
    
    v_cartao.limite_consumido := v_cartao.limite_consumido + p_valor;
  
  END IF;
  
  IF v_tp_produto = 'C' THEN -- Cartão comum
    NULL;
  ELSIF v_tp_produto = 'P' THEN
    IF v_cartao.id_estabelecimento <> v_estabel_produto THEN
      v_transacao.ocorrencia := 'PRODUTO NÃO AUTORIZADO NESTE ESTABELECIMENTO';
    END IF;
  ELSIF v_tp_produto = 'P' THEN
    SELECT COUNT(*)
      INTO v_valida_compra
      FROM estabelecimento e,
           estabelecimento i
     WHERE e.id_estabelecimento = v_cartao.id_estabelecimento
       AND i.id_estabelecimento = v_estabel_produto
       AND e.id_ramo            = i.id_ramo;
       
    IF v_valida_compra > 0 THEN
      v_transacao.ocorrencia := 'PRODUTO NÃO AUTORIZADO NESTE ESTABELECIMENTO';
    END IF;
    
  ELSE
    v_transacao.ocorrencia := 'TIPO DE PRODUTO NÃO RELACIONADO';
    RAISE nao_autorizado;
  END IF;
  
  v_transacao.dt_aprovacao := CURRENT_TIMESTAMP;
  v_transacao.dt_liquidacao := v_transacao.dt_aprovacao + v_prz_liquidacao;
  v_transacao.vlr_liquidacao := v_transacao.vlr_transacao * (1 - v_tax_estabelecimento);
  
  INSERT INTO transacao VALUES v_transacao;  
  
  UPDATE cliente_produto 
     SET limite_consumido = v_cliente_produto.limite_consumido 
   WHERE id_cliente = v_cliente_produto.id_cliente
     AND id_produto = v_cliente_produto.id_produto
     AND limite_consumido <> v_cliente_produto.limite_consumido;
     
  IF SQL%ROWCOUNT = 0 THEN
  
    UPDATE cartao 
       SET limite_consumido = v_cartao.limite_consumido 
     WHERE id_cliente = v_cartao.id_cliente
       AND id_produto = v_cartao.id_produto
       AND limite_consumido <> v_cartao.limite_consumido;
       
    IF SQL%ROWCOUNT = 0 THEN
      v_transacao.ocorrencia := 'ERRO AO ATUALIZAR LIMITE';
      RAISE nao_autorizado;
    END IF;
  
  END IF;
  
  v_transacao.st_transacao := 'A'; -- Autorizada

EXCEPTION
  WHEN erro THEN
    v_transacao.st_transacao := 'R'; -- Recusada
    INSERT INTO transacao VALUES v_transacao;
  WHEN OTHERS THEN
    v_transacao.st_transacao := 'E';
    v_transacao.ocorrencia := 'Erro genérico';
    INSERT INTO transacao VALUES v_transacao;
END;
/

------------------------------------------------
------------------------------------------------



SELECT id_cliente, COUNT(*) qtde_transacoes, SUM(vlr_transacao), AVG(vlr_transacao)
  FROM transacao t, cartao c
 WHERE t.id_cartao = c.id_cartao
   AND t.dt_transacao >= TRUNC(SYSDATE, 'MM')
 GROUP BY c.id_cliente;
 
SELECT id_cliente, cpf, nome, count(*) qtde_transacoes
  FROM cliente         c, 
       cliente_produto p, 
       cartao          r, 
       transacao       t
 WHERE c.id_cliente = p.id_cliente
   AND p.id_cliente = r.id_cliente
   AND p.id_produto = r.id_produto
   AND r.id_cartao  = t.id_cartao
   AND t.dt_transacao >= TRUNC(SYSDATE, 'YYYY')
 GROUP BY c.id_cliente
HAVING COUNT(*) >= 5;

SELECT c.nome, 
       e.razao_social
  FROM cliente c, 
       estabelecimento e, 
       cartao r,
       (  SELECT id_cartao, 
                 id_estabelecimento, 
                 dense_rank() OVER (ORDER BY vlr_transacao desc) rank_transacao
            FROM transacao ) x
 WHERE x.id_cartao = r.id_cartao
   AND r.id_cliente = c.id_cliente
   AND x.id_estabelecimento = e.id_estabelecimento
   and x.rank_transacao = 1;

SELECT cpf, 
       nome, 
       descricao, 
       dt_transacao, 
       vlr_transacao,
       cnpj, 
       razao_social
  FROM ( SELECT c.cpf, 
                c.nome, 
                p.descricao, 
                t.dt_transacao, 
                t.vlr_transacao, 
                e.cnpj, 
                e.razao_social, 
                DECODE(p.tp_limite, 'I', r.limite_liberado, p.limite_liberado) limite_liberado,
                DECODE(p.tp_limite, 'I', r.limite_consumido, p.limite_consumido) limite_consumido
           FROM cliente c, cliente_produto p, cartao r, estabelecimento e, transacao t, produto p
          WHERE c.id_cliente         = p.id_cliente
            AND p.id_cliente         = r.id_cliente
            AND p.id_produto         = r.id_produto
            AND p.id_produto         = p.id_produto
            AND r.id_cartao          = t.id_cartao
            AND t.id_estabelecimento = e.id_estabelecimento)
 WHERE limite_consumido / limite_liberado >= 0.9
 ORDER BY 1, 3, 4;

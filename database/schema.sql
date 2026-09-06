CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE perfil_usuario AS ENUM ('ADMINISTRADOR', 'CHEFIA', 'RESPONSAVEL', 'JOVEM');
CREATE TYPE secao_escoteira AS ENUM ('ALCATEIA', 'TROPA_ESCOTEIRA', 'TROPA_SENIOR', 'CLAN_PIONEIRO', 'CHEFIA_GERAL');
CREATE TYPE status_mensalidade AS ENUM ('PENDENTE', 'PAGO', 'ATRASADO', 'CANCELADO');
CREATE TYPE forma_pagamento AS ENUM ('PIX', 'DINHEIRO', 'CARTAO_CREDITO', 'CARTAO_DEBITO', 'TRANSFERENCIA');
CREATE TYPE status_pedido AS ENUM ('SOLICITADO', 'APROVADO', 'RECUSADO', 'ENTREGUE');

CREATE TABLE usuarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    cpf VARCHAR(11) UNIQUE,
    data_nascimento DATE NOT NULL,
    perfil perfil_usuario NOT NULL DEFAULT 'JOVEM',
    secao secao_escoteira,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE responsaveis_jovens (
    responsavel_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    jovem_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    parentesco VARCHAR(50) NOT NULL, -- Ex: Pai, Mãe, Tutor Legal
    PRIMARY KEY (responsavel_id, jovem_id)
);

CREATE TABLE mensalidades (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    jovem_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE RESTRICT,
    valor DECIMAL(10, 2) NOT NULL CHECK (valor > 0),
    data_vencimento DATE NOT NULL,
    status status_mensalidade NOT NULL DEFAULT 'PENDENTE',
    referencia_mes_ano VARCHAR(7) NOT NULL, -- Ex: 03/2026
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pagamentos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    mensalidade_id UUID NOT NULL REFERENCES mensalidades(id) ON DELETE RESTRICT,
    registrado_por_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE RESTRICT,
    valor_pago DECIMAL(10, 2) NOT NULL CHECK (valor_pago > 0),
    data_pagamento TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metodo forma_pagamento NOT NULL,
    observacao TEXT
);

CREATE TABLE distintivos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL, -- Ex: Especialidade, Ramos, Insígnia
    descricao TEXT,
    imagem_url VARCHAR(255),
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pedidos_distintivos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    jovem_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE RESTRICT,
    distintivo_id UUID NOT NULL REFERENCES distintivos(id) ON DELETE RESTRICT,
    solicitado_por_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE RESTRICT,
    aprovado_por_id UUID REFERENCES usuarios(id) ON DELETE SET NULL,
    status status_pedido NOT NULL DEFAULT 'SOLICITADO',
    data_solicitacao TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    observacao TEXT
);
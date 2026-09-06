-- SCRIPT DE SEED (POVOAMENTO INICIAL) DO BANCO DE DADOS

-- Limpa os dados existentes
TRUNCATE pedidos_distintivos, pagamentos, mensalidades, responsaveis_jovens, distintivos, usuarios RESTART IDENTITY CASCADE;

-- POVOANDO USUÁRIOS (Membros)
-- As senhas estão como hash fictício

-- 1.1 Administrador
INSERT INTO usuarios (id, nome, email, senha_hash, cpf, data_nascimento, perfil, secao, ativo) 
VALUES (
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    'Akela Carlos Silva',
    'carlos.admin@escoteiros.org.br',
    '$2b$10$e8T71/eK.Gz.Y.4X7E8E.O9f0V2U6/N0k2a5M7', -- hash simulação
    '11122233344',
    '1985-04-12',
    'ADMINISTRADOR',
    'CHEFIA_GERAL',
    TRUE
);

-- 1.2 Chefe de Seção
INSERT INTO usuarios (id, nome, email, senha_hash, cpf, data_nascimento, perfil, secao, ativo) 
VALUES (
    'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22',
    'Chefia Maria Oliveira',
    'maria.chefia@escoteiros.org.br',
    '$2b$10$e8T71/eK.Gz.Y.4X7E8E.O9f0V2U6/N0k2a5M7',
    '22233344455',
    '1990-08-25',
    'CHEFIA',
    'ALCATEIA',
    TRUE
);

-- 1.3 Responsável
INSERT INTO usuarios (id, nome, email, senha_hash, cpf, data_nascimento, perfil, secao, ativo) 
VALUES (
    'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33',
    'Roberto Souza',
    'roberto.souza@email.com',
    '$2b$10$e8T71/eK.Gz.Y.4X7E8E.O9f0V2U6/N0k2a5M7',
    '33344455566',
    '1980-01-15',
    'RESPONSAVEL',
    NULL,
    TRUE
);

-- 1.4 Jovens (Lobinho e Escoteiro)
INSERT INTO usuarios (id, nome, email, senha_hash, cpf, data_nascimento, perfil, secao, ativo) 
VALUES 
(
    'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44',
    'Lucas Souza',
    'lucas.lobinho@email.com',
    '$2b$10$e8T71/eK.Gz.Y.4X7E8E.O9f0V2U6/N0k2a5M7',
    '44455566677',
    '2016-06-10', -- Lobinho (10 anos)
    'JOVEM',
    'ALCATEIA',
    TRUE
),
(
    'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a55',
    'Beatriz Souza',
    'beatriz.escoteira@email.com',
    '$2b$10$e8T71/eK.Gz.Y.4X7E8E.O9f0V2U6/N0k2a5M7',
    '55566677788',
    '2013-03-20', -- Escoteira (13 anos)
    'JOVEM',
    'TROPA_ESCOTEIRA',
    TRUE
);

-- 2. VINCULANDO RESPONSÁVEL AOS JOVENS (N:N)
INSERT INTO responsaveis_jovens (responsavel_id, jovem_id, parentesco) 
VALUES 
('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 'Pai'),
('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a55', 'Pai');

-- 3. POVOANDO MENSALIDADES
INSERT INTO mensalidades (id, jovem_id, valor, data_vencimento, status, referencia_mes_ano) 
VALUES 
-- Mensalidade Paga do Lucas
(
    'f0eebc99-9c0b-4ef8-bb6d-6bb9bd380a66',
    'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44',
    80.00,
    '2026-09-10',
    'PAGO',
    '09/2026'
),
-- Mensalidade Pendente da Beatriz
(
    'f1eebc99-9c0b-4ef8-bb6d-6bb9bd380a77',
    'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a55',
    80.00,
    '2026-09-10',
    'PENDENTE',
    '09/2026'
);

-- 4. REGISTRANDO PAGAMENTO (Para a mensalidade paga)
INSERT INTO pagamentos (mensalidade_id, registrado_por_id, valor_pago, data_pagamento, metodo, observacao) 
VALUES (
    'f0eebc99-9c0b-4ef8-bb6d-6bb9bd380a66',
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', -- Admin registrou
    80.00,
    CURRENT_TIMESTAMP,
    'PIX',
    'Pagamento via Chave PIX do Grupo'
);

-- 5. POVOANDO CATÁLOGO DE DISTINTIVOS
INSERT INTO distintivos (id, nome, categoria, descricao) 
VALUES 
(
    '11111111-9c0b-4ef8-bb6d-6bb9bd380a88',
    'Especialidade de Primeiros Socorros',
    'Especialidade',
    'Demostra conhecimento em cuidados primários de saúde e emergências.'
),
(
    '22222222-9c0b-4ef8-bb6d-6bb9bd380a99',
    'Insígnia da Lusofonia',
    'Insígnia Especial',
    'Conquistada ao realizar atividades integradas com escoteiros de países de língua portuguesa.'
);

-- 6. SOLICITANDO PEDIDOS DE DISTINTIVOS
INSERT INTO pedidos_distintivos (jovem_id, distintivo_id, solicitado_por_id, aprovado_por_id, status, observacao) 
VALUES 
(
    'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', -- Lucas
    '11111111-9c0b-4ef8-bb6d-6bb9bd380a88', -- Primeiros Socorros
    'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', -- Chefe Maria pediu
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', -- Akela aprovou
    'APROVADO',
    'Requisitos cumpridos em acampamento.'
);
drop table Parcela;
drop table Venda;
drop table Cliente;
drop table Loja;
drop table Vendedor;

create table Cliente(cd_cliente integer not null, nm_cliente varchar2(40) not null, nm_cidade varchar2(40) not null);
alter table Cliente add constraint cd_cliente_pk primary key(cd_cliente);

insert into Cliente values(1, 'Carlos Silva', 'Criciuma');
commit;
insert into Cliente values(2, 'Bruna Marcon', 'Laguna');
commit;
insert into Cliente values(3, 'Daniel Mendes', 'Criciuma');
commit;
insert into Cliente values(4, 'Ana Gomes', 'Laguna');
commit;

create table Loja(cd_loja integer not null, nm_loja varchar2(40) not null, nm_cidade varchar2(40) not null);
alter table Loja add constraint cd_loja_pk primary key(cd_loja);

insert into Loja values(1, 'Rosa feliz', 'Criciuma');
commit;
insert into Loja values(2, 'Margarida sincera', 'Laguna');
commit;

create table Vendedor(cd_vendedor integer not null, nm_vendedor varchar2(40) not null, sl_vendedor number(7,2) not null, cd_supervisor integer not null);
alter table Vendedor add constraint cd_vendedor_pk primary key(cd_vendedor);

insert into Vendedor values(1, 'José Dias', 2000.00, 2);
commit;
insert into Vendedor values(2, 'Eduarda Liberato', 1800.00, 1);
commit;
insert into Vendedor values(3, 'Dara Dias', 2200.00, 4);
commit;
insert into Vendedor values(4, 'Laura Gomes', 2000.00, 3);
commit;

create table Venda(cd_venda integer not null, cd_loja integer not null, cd_vendedor integer not null, cd_cliente integer not null, dt_venda date not null);
alter table Venda add constraint cd_venda_pk primary key(cd_venda);
alter table Venda add constraints cd_venda_loja_fk foreign key(cd_loja) references Loja(cd_loja);
alter table Venda add constraints cd_venda_vendedor_fk foreign key(cd_vendedor) references Vendedor(cd_vendedor);
alter table Venda add constraints cd_venda_cliente_fk foreign key(cd_cliente) references Cliente(cd_cliente);

insert into Venda values(1, 1, 1, 1, (sysdate-30));
commit;
insert into Venda values(2, 1, 3, 1, (sysdate-29));
commit;
insert into Venda values(3, 2, 2, 2, (sysdate-29));
commit;
insert into Venda values(4, 2, 4, 2, (sysdate-28));
commit;

create table Parcela(cd_loja integer not null, cd_venda integer not null, cd_parcela integer not null, dt_vencimento date not null, vl_parcela number(5,2) not null, dt_pagamento date, vl_pago number(5,2));
alter table Parcela add constraint cd_parcela_pk primary key(cd_parcela, cd_loja, cd_venda);
alter table Parcela add constraints cd_parcela_venda_fk foreign key(cd_venda) references Venda(cd_venda);
alter table Parcela add constraints cd_parcela_loja_fk foreign key(cd_loja) references Loja(cd_loja);

insert into Parcela values(1, 1, 1, (sysdate+30), 250.00, null, null);
commit;
insert into Parcela values(1, 1, 2, (sysdate+60), 250.00, null, null);
commit;
insert into Parcela values(1, 2, 1, (sysdate+29), 100.00, null, null);
commit;
insert into Parcela values(2, 3, 1, (sysdate+29), 150.00, null, null);
commit;
insert into Parcela values(2, 3, 2, (sysdate+59), 150.00, null, null);
commit;
insert into Parcela values(2, 4, 1, (sysdate+28), 400.00, null, null);
commit;

-- linha abaixo faz com que put_line consiga sair na tela
set serveroutput on size unlimited

-- imprime olá mundo
begin
DBMS_OUTPUT.put_line('olá mundo');
end;
/

-- pl sql foi usado para inserir um novo cliente, loop normal
declare
wnm_cliente cliente.nm_cliente%type;
wnm_cidade cliente.nm_cidade%type;
c number(1);
begin
c:=1;
-- inicia c como 1
wnm_cliente:='Roger Prado';
wnm_cidade:='Criciuma';
-- atribui nome para as variáveis que serão usadas no insert 
loop
c:=c+1;
exit when c>=5;
end loop;
-- loop faz c acrescentar 1 até chegar a 5, onde é uma posição vaga para inserir um cliente
insert into cliente values(c, wnm_cliente, wnm_cidade);
commit;
end;
/
-- / faz com que saia do bloco pl sql

-- pl sql foi usado para inserir um novo cliente, loop while
declare
wnm_cliente cliente.nm_cliente%type;
wnm_cidade cliente.nm_cidade%type;
c number(1);
begin
c:=1;
-- inicia c como 1
wnm_cliente:='Luise Souza';
wnm_cidade:='Laguna';
-- atribui nome para as variáveis que serão usadas no insert 
while c<6 loop
c:=c+1;
end loop;
-- loop while faz c acrescentar 1 até chegar a 6, onde é uma posição vaga para inserir um cliente
insert into cliente values(c, wnm_cliente, wnm_cidade);
commit;
end;
/
-- / faz com que saia do bloco pl sql

-- pl sql foi usado para inserir um novo cliente, loop for
declare
wnm_cliente cliente.nm_cliente%type;
wnm_cidade cliente.nm_cidade%type;
c number(1);
begin
c:=1;
-- inicia c como 1
wnm_cliente:='Alberto Roberto';
wnm_cidade:='Criciuma';
-- atribui nome para as variáveis que serão usadas no insert 
for c in 1 .. 7 loop
if c=7 then
insert into cliente values(c, wnm_cliente, wnm_cidade);
commit;
end if;
end loop;
-- loop for faz c acrescentar 1 até chegar a 7, onde é uma posição vaga para inserir um cliente
end;
/
-- / faz com que saia do bloco pl sql

-- em pl sql declara duas variáveis que receberão nome e cidade do cliente 1 e mostra as informações depois
declare
wnm_cliente cliente.nm_cliente%type;
wnm_cidade cliente.nm_cidade%type;
begin
select nm_cliente, nm_cidade into wnm_cliente, wnm_cidade from cliente where cd_cliente=1;
dbms_output.put_line('nome: '||wnm_cliente||' - Cidade: '||wnm_cidade);
end;
/
-- / faz com que saia do bloco pl sql

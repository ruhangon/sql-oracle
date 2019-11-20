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

-- cria um cursor que lista código e nome dos vendedores com pelo menos uma venda
declare
cursor cvdd is
select cd_vendedor, nm_vendedor from vendedor;
rvdd cvdd%rowtype;
-- a variável abaixo irá armazenar o número de vendas do vendedor atual
nr_vendas number(3);
begin
open cvdd;
fetch cvdd into rvdd;
while cvdd%found loop
select count(*) into nr_vendas from venda where cd_vendedor = rvdd.cd_vendedor;
if (nr_vendas>0) then
dbms_output.put_line('código: '||rvdd.cd_vendedor||' - nome: '||rvdd.nm_vendedor);
end if;
fetch cvdd into rvdd;
end loop;
close cvdd;
end;
/

-- primeiro cursor abaixo lista os vendedores por nome e quantas vendas cada um tem
-- o segundo cursor fará com que se o vendedor tiver uma venda, como todos tem, irá listar o nome onde ela foi feita
declare
cursor c_vdd is
select vdd.nm_vendedor, v.cd_vendedor, v.cd_venda, count(*) nr_vendas from venda v join vendedor vdd on v.cd_vendedor=vdd.cd_vendedor group by v.cd_vendedor, vdd.nm_vendedor, v.cd_venda;
-- no select acima o nr_vendas depois de count(*) irá armazenar o resultado trazido pelo count
r_vdd c_vdd%rowtype;
cursor c_loj(nr_venda_atual number) is
select l.nm_loja, v.cd_loja from venda v join loja l on l.cd_loja=v.cd_loja where v.cd_venda=nr_venda_atual;
r_loj c_loj%rowtype;
begin
open c_vdd;
fetch c_vdd into r_vdd;
while c_vdd%found loop
dbms_output.put_line('nome: '||r_vdd.nm_vendedor||' - vendas: '||r_vdd.nr_vendas);
if r_vdd.nr_vendas=1 then
open c_loj(r_vdd.cd_venda);
fetch c_loj into r_loj;
dbms_output.put_line('nome da loja: '||r_loj.nm_loja);
close c_loj;
end if;
fetch c_vdd into r_vdd;
end loop;
close c_vdd;
end;
/


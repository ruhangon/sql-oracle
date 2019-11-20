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

-- aumenta salário de vendedores em 100, além de pegar o total de rowcount com a ajuda de estudo de cursores
declare
total_cont number(2);
-- irá armazenar o número total de vendedores, aumentando um a cada passada do update
begin
update vendedor set sl_vendedor=(sl_vendedor+100);
if sql%notfound then 
-- se não encontrar mais vendedores com o cursor entra nesse if
dbms_output.put_line('Sem vendedores selecionados'); 
elsif sql%found then 
-- já se encontrar algum vendedor entra nesse if
total_cont := sql%rowcount;
-- atualiza o total_cont usando o conteúdo de rowcount
dbms_output.put_line(total_cont);
-- mostra o total que agora está armazenado em total_cont
END IF;  
end;
/

-- usa um cursor explícito 
declare
c_id vendedor.cd_vendedor%type;
c_nome vendedor.nm_vendedor%type;
c_salario vendedor.sl_vendedor%type;
cursor c_vendedores is
select cd_vendedor, nm_vendedor, sl_vendedor from vendedor;
-- declara cursor c_vendedores que será usado para teste
begin
open c_vendedores;
-- abre o cursor declarado acima
loop
fetch c_vendedores into c_id, c_nome, c_salario;
-- extrai dados do cursor com fetch
exit when c_vendedores%notfound;
-- quando não houver mais dados para pegar no cursor sai do loop
dbms_output.put_line('id: '||c_id||' - nome: '||c_nome||' - salario: '||c_salario);
-- mostra os dados que foram conseguidos com o fetch
dbms_output.put_line('número de linhas: '||c_vendedores%rowcount);
-- mostra o número de linhas atual que consta no rowcount
end loop;
close c_vendedores;
-- fecha o cursor que foi aberto
end;
/

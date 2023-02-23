select count(*) from bmsql_warehouse; -- 1000
select count(*) from bmsql_district; -- 10000
select count(*) from bmsql_customer; -- 30000000
select count(*) from bmsql_oorder; -- 30000000
select count(*) from bmsql_history; -- 30000000
select count(*) from bmsql_new_order; -- 9000000
select count(*) from bmsql_order_line; -- 300000000+-
select count(*) from bmsql_stock; -- 100000000
select count(*) from bmsql_item; -- 100000

--

select a.* from (Select w_id, w_ytd from bmsql_warehouse) a left join (select d_w_id, sum(d_ytd) s from bmsql_district group by d_w_id) b on a.w_id=b.d_w_id and a.w_ytd=b.s where b.d_w_id is null;
select b.* from (Select w_id, w_ytd from bmsql_warehouse) a right join (select d_w_id, sum(d_ytd) s from bmsql_district group by d_w_id) b on a.w_id=b.d_w_id and a.w_ytd=b.s where a.w_id is null;

--

select a.* from (Select d_w_id, d_id, (D_NEXT_O_ID - 1) d from bmsql_district) a left join (select o_w_id, o_d_id, max(o_id) m from bmsql_oorder group by o_w_id, o_d_id) b on a.d_w_id=b.o_w_id and a.d_id=b.o_d_id and a.d=b.m where b.o_w_id is null;
select b.* from (Select d_w_id, d_id, (D_NEXT_O_ID - 1) d from bmsql_district) a right join (select o_w_id, o_d_id, max(o_id) m from bmsql_oorder group by o_w_id, o_d_id) b on a.d_w_id=b.o_w_id and a.d_id=b.o_d_id and a.d=b.m where a.d_w_id is null;

--

select a.* from (Select d_w_id, d_id, (D_NEXT_O_ID - 1) d from bmsql_district) a left join (select no_w_id, no_d_id, max(no_o_id) m from bmsql_new_order group by no_w_id, no_d_id) b on a.d_w_id=b.no_w_id and a.d_id=b.no_d_id and a.d=b.m where b.no_w_id is null;
select b.* from (Select d_w_id, d_id, (D_NEXT_O_ID - 1) d from bmsql_district) a right join (select no_w_id, no_d_id, max(no_o_id) m from bmsql_new_order group by no_w_id, no_d_id) b on a.d_w_id=b.no_w_id and a.d_id=b.no_d_id and a.d=b.m where a.d_w_id is null;

--

select * from (select (count(no_o_id)-(max(no_o_id)-min(no_o_id)+1)) as diff from bmsql_new_order group by no_w_id, no_d_id) a where a.diff != 0; --43 sec 1000cang

--

select a.* from (select o_w_id, o_d_id, sum(o_ol_cnt) s from bmsql_oorder group by o_w_id, o_d_id) a left join (select ol_w_id, ol_d_id, count(ol_o_id) c from bmsql_order_line group by ol_w_id, ol_d_id) b on a.o_w_id=b.ol_w_id and a.o_d_id=b.ol_d_id and a.s=b.c where b.ol_w_id is null;
select b.* from (select o_w_id, o_d_id, sum(o_ol_cnt) s from bmsql_oorder group by o_w_id, o_d_id) a right join (select ol_w_id, ol_d_id, count(ol_o_id) c from bmsql_order_line group by ol_w_id, ol_d_id) b on a.o_w_id=b.ol_w_id and a.o_d_id=b.ol_d_id and a.s=b.c where a.o_w_id is null;

--  

select a.* from (select d_w_id, sum(d_ytd) s from bmsql_district group by d_w_id) a left join (Select w_id, w_ytd from bmsql_warehouse) b on a.d_w_id=b.w_id and a.s=b.w_ytd where b.w_id is null;
select b.* from (select d_w_id, sum(d_ytd) s from bmsql_district group by d_w_id) a right join (Select w_id, w_ytd from bmsql_warehouse) b on a.d_w_id=b.w_id and a.s=b.w_ytd where a.d_w_id is null;

create or replace procedure proc_item_ord(item int4)
language 'plpgsql'
as $$
begin 
	drop table if exists total_items_sold_by_county cascade;
	create table total_items_sold_by_county as (select a.county_name, count(oi.quantity), now() as update_date
		from order_items oi 
		join orders o on oi.order_id = o.order_id
		join clients c on o.client_id = c.client_id
		join addresses a on c.adr_id = a.adr_id
		where oi.item_id = item
		group by a.county_name);
end;
$$;

create or replace procedure summary_for_each_item()
language 'plpgsql'
as $$
declare 
	item_iterator record;
begin 
	FOR item_iterator IN
		select distinct order_items.item_id from order_items order by order_items.item_id
	loop
		call proc_item_ord(item_iterator.item_id);
	end loop;
	
end;
$$;

--there is single table for each item
call summary_for_each_item();
--u can pick any product to generate table
call proc_item_ord(3);
select * from total_items_sold_by_county


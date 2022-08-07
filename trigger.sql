create table if not exists large_orders(
	order_id int,
	quanity int
);

CREATE OR REPLACE FUNCTION public.check_if_orderd_is_large() 
	returns trigger
	LANGUAGE plpgsql
	AS $function$
	begin
		CREATE VIEW temp_orders as
			select oi.quantity , o.order_id
			from new.orders o
			join order_items oi on o.order_id = oi.order_id; 
		IF temp_orders.quanity > 100
            insert into temp_orders (temp_orders.quanity, temp_orders.order_id)
        END IF;
	END;
$function$
;

create trigger large_order
    after insert
    on public.orders
    for each row
    	execute public.check_if_orderd_is_large

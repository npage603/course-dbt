
with orders as (
	select * from {{ source('postgres', 'orders') }}
)
SELECT 
	order_id,
	user_id,
	promo_id,
	address_id,
	created_at::timestampntz as order_created_at_utc,
	order_cost,
	shipping_cost,
	order_total,
	tracking_id,
	shipping_service,
	estimated_delivery_at::timestampntz as order_estimated_delivery_at_utc,
	delivered_at::timestampntz as order_delivered_at_utc,
	status as order_status
FROM orders
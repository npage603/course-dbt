
SELECT
	user_id,
	first_name as user_first_name,
	last_name as user_last_name,
	concat(first_name,' ',last_name) as user_name,
	email as user_email,
	phone_number as user_phone_number,
	created_at::timestampntz as user_created_at_timestamp_utc,
	updated_at::timestampntz as user_updated_at_timestamp_utc,
	address_id
FROM {{ source('postgres', 'users') }}
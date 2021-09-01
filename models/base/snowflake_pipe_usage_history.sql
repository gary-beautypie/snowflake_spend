WITH base AS (

	SELECT *
	FROM {{ source('snowflake','pipe_usage_history') }}

)

SELECT
  pipe_id,
  pipe_name,
  start_time,
  end_time,
  credits_used
FROM base

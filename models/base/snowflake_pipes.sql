WITH base AS (

	SELECT *
	FROM {{ source('snowflake','pipes') }}

)

SELECT
  pipe_id,
  pipe_name,
  pipe_schema,
  pipe_catalog,
  is_autoingest_enabled
FROM
  base

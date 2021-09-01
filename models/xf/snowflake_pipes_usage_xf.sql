WITH base AS (

	SELECT *
	FROM {{ ref('snowflake_pipe_usage_history') }}

), pipes AS (

    SELECT *
    FROM {{ ref('snowflake_pipes') }}

)
, contract_rates AS (

    SELECT *
    FROM {{ ref('snowflake_amortized_rates') }}

), usage AS (

    SELECT
      base.pipe_id,
      base.pipe_name,
      pipes.pipe_schema,
      pipes.pipe_catalog,
      pipes.is_autoingest_enabled,
      base.start_time,
      base.end_time,
      DATE_TRUNC('month', base.end_time)::DATE          AS usage_month,
      DATE_TRUNC('day', base.end_time)::DATE            AS usage_day,
      DATEDIFF(hour, base.start_time, base.end_time)    AS usage_length,
      contract_rates.rate                               AS credit_rate,
      ROUND(base.credits_used * contract_rates.rate, 2) AS dollars_spent
    FROM base
    JOIN pipes
      ON base.pipe_id = pipes.pipe_id
    LEFT JOIN contract_rates
      ON DATE_TRUNC('day', end_time) = contract_rates.date_day

)

SELECT *
FROM usage

/*
  WITH RankedData CTE:
  This Common Table Expression (CTE) is used to retrieve and rank data from the [history_water], [acc_watet], and [car_call_water] tables.
*/
WITH RankedData AS(
	/*
    SELECT statement within the CTE:
    - Selects relevant columns from the tables.
    - Computes a row number (row_rank) based on the descending order of occupant_code within each account_no partition.
	*/
	SELECT 
		wh.account_no,
		wh.occupant_code,
		wh.mtyr_period,
		wh.read_date,
		wh.meter_no,
		wh.no_of_days,
		wh.usage_hi,
		wh.usage_low,
		wh.billcode,
		pa.name,
		cs.callername,
		cs.workorder,
		cs.note,
		cs.calltype,
		ROW_NUMBER() OVER (PARTITION BY wh.account_no ORDER BY wh.occupant_code DESC) AS row_rank
		FROM [database_name].[table_name].[history_water] wh
		INNER JOIN [database_name].[table_name].[acc_water] pa ON wh.account_no = pa.account_no
		INNER JOIN [database_name].[table_name].[car_call_water] cs ON wh.account_no = cs.account_no
			WHERE wh.usage_hi = 0
				AND ((wh.no_of_days > 60 AND wh.no_of_days < 365) OR wh.no_of_days > 1095)
				AND pa.name NOT LIKE '%CLOSED ACCOUNT%'
				AND pa.name NOT LIKE '%VACANT%'
				AND cs.note LIKE '%STUCK%'
				AND cs.calltype = 'WDEFLT'
				AND wh.read_date = (
					/*
        			Subquery to find the maximum read_date for each account in the [pu_water_hist] table:
        			- Returns the maximum read_date for the specific account in the inner SELECT statement. 
					*/
					SELECT MAX(wh_inner.read_date) 
					FROM [database_name].[table_name].[history_water] wh_inner 
					WHERE wh_inner.account_no = wh.account_no
				)
	)

/*
  Final SELECT statement:
  - Retrieves all columns from the RankedData CTE.
  - Filters the results to only include rows with row_rank equal to 1 (records with the highest read_date for each account_no).
*/
SELECT * 
	FROM RankedData
		WHERE row_rank = 1



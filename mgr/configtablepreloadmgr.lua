pg = pg or {}
pg.ConfigTablePreloadMgr = singletonClass("ConfigTablePreloadMgr")

function pg.ConfigTablePreloadMgr.Init(arg0_1, arg1_1)
	local var0_1 = {
		"furniture_data_template",
		"ship_data_statistics",
		"task_data_template",
		"ship_skin_template_column_time"
	}
	local var1_1 = {}

	for iter0_1, iter1_1 in ipairs(var0_1) do
		table.insert(var1_1, function(arg0_2)
			local var0_2 = pg[iter1_1]

			onNextTick(arg0_2)
		end)
	end

	seriesAsync(var1_1, arg1_1)
end

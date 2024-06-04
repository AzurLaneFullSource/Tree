pg = pg or {}
pg.ConfigTablePreloadMgr = singletonClass("ConfigTablePreloadMgr")

function pg.ConfigTablePreloadMgr.Init(arg0, arg1)
	local var0 = {
		"furniture_data_template",
		"ship_data_statistics",
		"task_data_template",
		"ship_skin_template_column_time"
	}
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var1, function(arg0)
			local var0 = pg[iter1]

			onNextTick(arg0)
		end)
	end

	seriesAsync(var1, arg1)
end

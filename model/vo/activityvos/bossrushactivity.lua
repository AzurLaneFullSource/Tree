local var0 = class("BossRushActivity", import("model.vo.Activity"))

function var0.SetSeriesData(arg0, arg1)
	getProxy(ActivityProxy):GetBossRushRuntime(arg0.id).seriesData = arg1
end

function var0.GetSeriesData(arg0)
	return getProxy(ActivityProxy):GetBossRushRuntime(arg0.id).seriesData
end

function var0.HasAwards(arg0)
	return arg0.data1 == 1
end

function var0.GetUsedBonus(arg0)
	return arg0.data1_list
end

function var0.AddUsedBonus(arg0, arg1)
	local var0 = table.indexof(arg0:GetActiveSeriesIds(), arg1)

	if not var0 or var0 < 0 then
		return
	end

	arg0:GetUsedBonus()[var0] = (arg0:GetUsedBonus()[var0] or 0) + 1
end

function var0.GetPassCounts(arg0)
	return arg0.data2_list
end

function var0.AddPassSeries(arg0, arg1)
	if arg0:HasPassSeries(arg1) then
		return
	end

	table.insert(arg0:GetPassCounts(), arg1)
end

function var0.HasPassSeries(arg0, arg1)
	return table.contains(arg0:GetPassCounts(), arg1)
end

function var0.GetActiveSeriesIds(arg0)
	return arg0:getConfig("config_data")
end

return var0

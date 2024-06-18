local var0_0 = class("BossRushActivity", import("model.vo.Activity"))

function var0_0.SetSeriesData(arg0_1, arg1_1)
	getProxy(ActivityProxy):GetBossRushRuntime(arg0_1.id).seriesData = arg1_1
end

function var0_0.GetSeriesData(arg0_2)
	return getProxy(ActivityProxy):GetBossRushRuntime(arg0_2.id).seriesData
end

function var0_0.HasAwards(arg0_3)
	return arg0_3.data1 == 1
end

function var0_0.GetUsedBonus(arg0_4)
	return arg0_4.data1_list
end

function var0_0.AddUsedBonus(arg0_5, arg1_5)
	local var0_5 = table.indexof(arg0_5:GetActiveSeriesIds(), arg1_5)

	if not var0_5 or var0_5 < 0 then
		return
	end

	arg0_5:GetUsedBonus()[var0_5] = (arg0_5:GetUsedBonus()[var0_5] or 0) + 1
end

function var0_0.GetPassCounts(arg0_6)
	return arg0_6.data2_list
end

function var0_0.AddPassSeries(arg0_7, arg1_7)
	if arg0_7:HasPassSeries(arg1_7) then
		return
	end

	table.insert(arg0_7:GetPassCounts(), arg1_7)
end

function var0_0.HasPassSeries(arg0_8, arg1_8)
	return table.contains(arg0_8:GetPassCounts(), arg1_8)
end

function var0_0.GetActiveSeriesIds(arg0_9)
	return arg0_9:getConfig("config_data")
end

return var0_0

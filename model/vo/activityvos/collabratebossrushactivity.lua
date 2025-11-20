local var0_0 = class("CollabrateBossRushActivity", import("model.vo.Activity"))

function var0_0.SetSeriesData(arg0_1, arg1_1)
	getProxy(ActivityProxy):GetBossRushRuntime(arg0_1.id).seriesData = arg1_1
end

function var0_0.GetSeriesData(arg0_2)
	return getProxy(ActivityProxy):GetBossRushRuntime(arg0_2.id).seriesData
end

function var0_0.Ctor(arg0_3, arg1_3)
	var0_0.super.Ctor(arg0_3, arg1_3)

	arg0_3.collabrateBossList = {}

	local var0_3 = arg0_3:getConfig("config_data")

	for iter0_3, iter1_3 in ipairs(var0_3) do
		local var1_3 = CollabrateBossRushSeriesData.New({
			id = iter1_3,
			index = iter0_3,
			actId = arg0_3.id
		})

		arg0_3.collabrateBossList[iter1_3] = var1_3
	end
end

function var0_0.UpdateCollabrateBossData(arg0_4, arg1_4)
	for iter0_4, iter1_4 in pairs(arg0_4.collabrateBossList) do
		local var0_4 = arg1_4[iter1_4:GetCollabBossID()]

		iter1_4:UpdateCollabBossData(var0_4.hpRate, var0_4.deathTimeStamp, var0_4.trafficPerHour, var0_4.damagePerHour)
	end
end

function var0_0.GetCollabSeriesData(arg0_5, arg1_5)
	return arg0_5.collabrateBossList[arg1_5]
end

function var0_0.GetCollabSeriesDataList(arg0_6)
	return arg0_6.collabrateBossList
end

function var0_0.HasAwards(arg0_7)
	return arg0_7.data1 == 1
end

function var0_0.GetPassCounts(arg0_8)
	return arg0_8.data1_list or {}
end

function var0_0.AddPassSeries(arg0_9, arg1_9)
	table.insert(arg0_9:GetPassCounts(), arg1_9)
end

function var0_0.HasPassSeries(arg0_10, arg1_10)
	return arg0_10.collabrateBossList[arg1_10]:IsPass()
end

function var0_0.HasPlayerDefeatSeries(arg0_11, arg1_11)
	return table.contains(arg0_11:GetPassCounts(), arg1_11)
end

function var0_0.GetActiveSeriesIds(arg0_12)
	return arg0_12:getConfig("config_data")
end

return var0_0

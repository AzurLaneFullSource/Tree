local var0_0 = class("IslandSeason", import("model.vo.BaseVO"))

var0_0.RESET_TIP_KEY = "IslandSeason.RESET_TIP_KEY"

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.pt = arg1_1.pt or 0
	arg0_1.gotPtAwardList = arg1_1.fetch_list or {}
	arg0_1.records = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.count_list or {}) do
		arg0_1.records[iter1_1.key] = iter1_1.value
	end

	arg0_1.endTime = pg.TimeMgr.GetInstance():parseTimeFromConfig(arg0_1:getConfig("time")[2])
	arg0_1.localTipKey = var0_0.RESET_TIP_KEY .. "_" .. getProxy(PlayerProxy):getRawData().id .. "_" .. arg0_1.id
end

function var0_0.IsEnd(arg0_2)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_2.endTime
end

function var0_0.bindConfigTable(arg0_3)
	return pg.island_season
end

function var0_0.GetTimeStr(arg0_4)
	local var0_4 = arg0_4:getConfig("time")
	local var1_4 = var0_4[1][1]
	local var2_4 = var0_4[2][1]

	return string.format("%d.%d.%d - %d.%d.%d", var1_4[1], var1_4[2], var1_4[3], var2_4[1], var2_4[2], var2_4[3])
end

function var0_0.GetRemainTime(arg0_5)
	return arg0_5.endTime - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.NeedTip(arg0_6)
	local var0_6 = arg0_6.endTime - pg.TimeMgr.GetInstance():GetServerTime()
	local var1_6 = math.floor(var0_6 / 86400)

	if var1_6 > 3 then
		return false
	end

	if PlayerPrefs.GetInt(arg0_6.localTipKey .. "_" .. arg0_6:GetTipStamp(var1_6)) == 1 then
		return false
	end

	return true, var1_6, math.floor(var0_6 / 3600)
end

function var0_0.SetTipFlag(arg0_7, arg1_7)
	PlayerPrefs.SetInt(arg0_7.localTipKey .. "_" .. arg0_7:GetTipStamp(arg1_7), 1)
end

function var0_0.GetTipStamp(arg0_8, arg1_8)
	return arg1_8 .. "_" .. arg0_8.endTime - arg1_8 * 86400
end

function var0_0.AddPt(arg0_9, arg1_9)
	if arg0_9.pt == 0 then
		IslandAchievementHelper.UpdateRecordWithAdd(IslandAchievementType.SEASON_NUM, 0, 1)
	end

	arg0_9.pt = arg0_9.pt + arg1_9
end

function var0_0.GetPt(arg0_10)
	return arg0_10.pt
end

function var0_0.GetGotPtAwardList(arg0_11)
	return arg0_11.gotPtAwardList
end

function var0_0.AddGotPtAwardList(arg0_12, arg1_12)
	if arg1_12 == 0 then
		for iter0_12, iter1_12 in ipairs(arg0_12:getConfig("target")) do
			if iter1_12 <= arg0_12.pt and not table.contains(arg0_12.gotPtAwardList, iter1_12) then
				table.insert(arg0_12.gotPtAwardList, iter1_12)
			end
		end
	else
		table.insert(arg0_12.gotPtAwardList, arg1_12)
	end
end

function var0_0.GanGetPtAward(arg0_13)
	return underscore.any(arg0_13:getConfig("target"), function(arg0_14)
		return arg0_14 <= arg0_13.pt and not table.contains(arg0_13.gotPtAwardList, arg0_14)
	end)
end

function var0_0.GetTaskIds(arg0_15)
	return arg0_15:getConfig("task_list")
end

function var0_0.GetAwardsByRank(arg0_16, arg1_16)
	local var0_16 = pg.island_season[arg0_16].rank
	local var1_16 = pg.island_season[arg0_16].rankaward_display

	for iter0_16, iter1_16 in ipairs(var0_16) do
		if arg1_16 >= iter1_16[1] and arg1_16 <= iter1_16[2] then
			return underscore.map(var1_16[iter0_16], function(arg0_17)
				return Drop.Create(arg0_17)
			end)
		end
	end

	return {}
end

function var0_0.GetPtAwardInfos(arg0_18)
	local var0_18 = {}
	local var1_18 = pg.island_season[arg0_18]

	for iter0_18, iter1_18 in ipairs(var1_18.target) do
		table.insert(var0_18, {
			target = iter1_18,
			drop = Drop.Create(var1_18.ptaward_display[iter0_18]),
			isImportant = table.contains(var1_18.ptaward_highvalue, iter0_18)
		})
	end

	return var0_18
end

return var0_0

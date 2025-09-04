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

function var0_0.bindConfigTable(arg0_2)
	return pg.island_season
end

function var0_0.GetTimeStr(arg0_3)
	local var0_3 = arg0_3:getConfig("time")
	local var1_3 = var0_3[1][1]
	local var2_3 = var0_3[2][1]

	return string.format("%d.%d.%d - %d.%d.%d", var1_3[1], var1_3[2], var1_3[3], var2_3[1], var2_3[2], var2_3[3])
end

function var0_0.GetRemainTime(arg0_4)
	return arg0_4.endTime - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.NeedTip(arg0_5)
	local var0_5 = arg0_5.endTime - pg.TimeMgr.GetInstance():GetServerTime()
	local var1_5 = math.floor(var0_5 / 86400)

	if var1_5 > 3 then
		return false
	end

	if PlayerPrefs.GetInt(arg0_5.localTipKey .. "_" .. arg0_5:GetTipStamp(var1_5)) == 1 then
		return false
	end

	return true, var1_5, math.floor(var0_5 / 3600)
end

function var0_0.SetTipFlag(arg0_6, arg1_6)
	PlayerPrefs.SetInt(arg0_6.localTipKey .. "_" .. arg0_6:GetTipStamp(arg1_6), 1)
end

function var0_0.GetTipStamp(arg0_7, arg1_7)
	return arg1_7 .. "_" .. arg0_7.endTime - arg1_7 * 86400
end

function var0_0.AddPt(arg0_8, arg1_8)
	if arg0_8.pt == 0 then
		IslandAchievementHelper.UpdateRecordWithAdd(IslandAchievementType.SEASON_NUM, 0, 1)
	end

	arg0_8.pt = arg0_8.pt + arg1_8
end

function var0_0.GetPt(arg0_9)
	return arg0_9.pt
end

function var0_0.GetGotPtAwardList(arg0_10)
	return arg0_10.gotPtAwardList
end

function var0_0.AddGotPtAwardList(arg0_11, arg1_11)
	if arg1_11 == 0 then
		for iter0_11, iter1_11 in ipairs(arg0_11:getConfig("target")) do
			if iter1_11 <= arg0_11.pt and not table.contains(arg0_11.gotPtAwardList, iter1_11) then
				table.insert(arg0_11.gotPtAwardList, iter1_11)
			end
		end
	else
		table.insert(arg0_11.gotPtAwardList, arg1_11)
	end
end

function var0_0.GanGetPtAward(arg0_12)
	return underscore.any(arg0_12:getConfig("target"), function(arg0_13)
		return arg0_13 <= arg0_12.pt and not table.contains(arg0_12.gotPtAwardList, arg0_13)
	end)
end

function var0_0.GetTaskIds(arg0_14)
	return arg0_14:getConfig("task_list")
end

function var0_0.GetAwardsByRank(arg0_15, arg1_15)
	local var0_15 = pg.island_season[arg0_15].rank
	local var1_15 = pg.island_season[arg0_15].rankaward_display

	for iter0_15, iter1_15 in ipairs(var0_15) do
		if arg1_15 >= iter1_15[1] and arg1_15 <= iter1_15[2] then
			return underscore.map(var1_15[iter0_15], function(arg0_16)
				return Drop.Create(arg0_16)
			end)
		end
	end

	return {}
end

function var0_0.GetPtAwardInfos(arg0_17)
	local var0_17 = {}
	local var1_17 = pg.island_season[arg0_17]

	for iter0_17, iter1_17 in ipairs(var1_17.target) do
		table.insert(var0_17, {
			target = iter1_17,
			drop = Drop.Create(var1_17.ptaward_display[iter0_17]),
			isImportant = table.contains(var1_17.ptaward_highvalue, iter0_17)
		})
	end

	return var0_17
end

return var0_0

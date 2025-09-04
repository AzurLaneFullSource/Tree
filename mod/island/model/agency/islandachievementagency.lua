local var0_0 = class("IslandAchievementAgency", import(".IslandBaseAgency"))

var0_0.NEW_CAN_GET = "IslandAchievementAgency.NEW_CAN_GET"

function var0_0.OnInit(arg0_1, arg1_1)
	local var0_1 = arg1_1.achievement_sys

	arg0_1.gotList = var0_1.finish_list or {}
	arg0_1.recordDic = {}

	for iter0_1, iter1_1 in ipairs(var0_1.achieve_list or {}) do
		local var1_1 = iter1_1.event_type
		local var2_1 = iter1_1.event_arg
		local var3_1 = iter1_1.value

		if not arg0_1.recordDic[var1_1] then
			arg0_1.recordDic[var1_1] = {}
		end

		arg0_1.recordDic[var1_1][var2_1] = var3_1
	end
end

function var0_0.InitRuntimeRecords(arg0_2)
	local var0_2 = IslandAchievementType.GetRuntimeTypes()
	local var1_2 = IslandAchievementType.GetClientTypes()

	for iter0_2, iter1_2 in ipairs(pg.island_achievement.all) do
		local var2_2 = pg.island_achievement[iter1_2]
		local var3_2 = var2_2.target_type
		local var4_2 = var2_2.target_value1

		if table.contains(var0_2, var3_2) then
			if not arg0_2.recordDic[var3_2] then
				arg0_2.recordDic[var3_2] = {}
			end

			if not arg0_2.recordDic[var3_2][var4_2] then
				arg0_2.recordDic[var3_2][var4_2] = IslandAchievementHelper.GetRuntimeData(var3_2, var4_2)
			end
		elseif table.contains(var1_2, var3_2) then
			if not arg0_2.recordDic[var3_2] then
				arg0_2.recordDic[var3_2] = {}
			end

			if not arg0_2.recordDic[var3_2][var4_2] then
				arg0_2.recordDic[var3_2][var4_2] = 0
			end
		end
	end

	arg0_2:BuildDataDic()
end

function var0_0.BuildDataDic(arg0_3)
	arg0_3.groupDic = {}
	arg0_3.achvDic = {}

	for iter0_3, iter1_3 in ipairs(pg.island_achievement.get_id_list_by_group) do
		local var0_3 = IslandAchievementGroup.New(iter0_3, iter1_3)

		for iter2_3, iter3_3 in ipairs(iter1_3) do
			local var1_3 = var0_3:GetAchvById(iter3_3)

			if table.contains(arg0_3.gotList, iter3_3) then
				var1_3:SetStatus(IslandAchievement.STATUS.GOT)
			else
				var1_3:SetStatus(arg0_3:IsCanGet(var1_3) and IslandAchievement.STATUS.GET or IslandAchievement.STATUS.NORMAL)
			end

			local var2_3 = var1_3:GetType()
			local var3_3 = var1_3:GetParam()

			if not arg0_3.achvDic[var2_3] then
				arg0_3.achvDic[var2_3] = {}
			end

			if not arg0_3.achvDic[var2_3][var3_3] then
				arg0_3.achvDic[var2_3][var3_3] = {}
			end

			table.insert(arg0_3.achvDic[var2_3][var3_3], var1_3)
		end

		arg0_3.groupDic[iter0_3] = var0_3
	end
end

function var0_0.GetRecordsByType(arg0_4, arg1_4)
	return arg0_4.recordDic[arg1_4] or {}
end

function var0_0.IsGot(arg0_5, arg1_5)
	return table.contains(arg0_5.gotList, arg1_5)
end

function var0_0.GetGotList(arg0_6)
	return arg0_6.gotList
end

function var0_0.GetGroup(arg0_7, arg1_7)
	return arg0_7.groupDic[arg1_7]
end

function var0_0.IsCanGet(arg0_8, arg1_8)
	if arg1_8:GetStatus() == IslandAchievement.STATUS.GOT then
		return
	end

	local var0_8 = arg1_8:GetType()
	local var1_8 = arg1_8:GetParam()
	local var2_8 = arg1_8:GetNum()

	if not arg0_8.recordDic[var0_8] then
		return false
	end

	local var3_8 = arg0_8.recordDic[var0_8][var1_8]

	return var3_8 and var2_8 <= var3_8
end

function var0_0.GetCurProgress(arg0_9, arg1_9)
	local var0_9 = arg1_9:GetType()
	local var1_9 = arg1_9:GetParam()
	local var2_9 = arg1_9:GetNum()

	if not arg0_9.recordDic[var0_9] then
		return 0
	end

	return arg0_9.recordDic[var0_9][var1_9] or 0
end

function var0_0.GetTotalCnt(arg0_10)
	local var0_10 = 0

	for iter0_10, iter1_10 in pairs(arg0_10.groupDic) do
		var0_10 = underscore.reduce(iter1_10:GetSortAchvList(), var0_10, function(arg0_11, arg1_11)
			return arg0_11 + (arg1_11:IsHideType() and (arg0_10:IsCanGet(arg1_11) and 1 or 0) or 1)
		end)
	end

	return var0_10
end

function var0_0.CheckRecordExist(arg0_12, arg1_12, arg2_12)
	return arg0_12.recordDic[arg1_12] and arg0_12.recordDic[arg1_12][arg2_12]
end

function var0_0.UpdateRecord(arg0_13, arg1_13, arg2_13, arg3_13)
	if not arg0_13.recordDic[arg1_13] then
		arg0_13.recordDic[arg1_13] = {}
	end

	if not arg0_13.recordDic[arg1_13][arg2_13] then
		local var0_13 = 0
	end

	arg0_13.recordDic[arg1_13][arg2_13] = arg3_13

	arg0_13:CheckAchvStatus(arg1_13, arg2_13)
end

function var0_0.UpdateRecordWithAdd(arg0_14, arg1_14, arg2_14, arg3_14)
	if not arg0_14.recordDic[arg1_14] then
		arg0_14.recordDic[arg1_14] = {}
	end

	local var0_14 = arg0_14.recordDic[arg1_14][arg2_14] or 0

	arg0_14.recordDic[arg1_14][arg2_14] = var0_14 + arg3_14

	arg0_14:CheckAchvStatus(arg1_14, arg2_14)
end

function var0_0.CheckAchvStatus(arg0_15, arg1_15, arg2_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.achvDic[arg1_15][arg2_15]) do
		if iter1_15:GetStatus() == IslandAchievement.STATUS.NORMAL and arg0_15:IsCanGet(iter1_15) then
			iter1_15:SetStatus(IslandAchievement.STATUS.GET)
			arg0_15:DispatchEvent(var0_0.NEW_CAN_GET, iter1_15)
		end
	end
end

function var0_0.AddGotIds(arg0_16, arg1_16)
	for iter0_16, iter1_16 in ipairs(arg1_16) do
		table.insert(arg0_16.gotList, iter1_16)

		local var0_16 = pg.island_achievement[iter1_16].group

		arg0_16.groupDic[var0_16]:SetGotTagById(iter1_16)
	end
end

function var0_0.IsTip(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.groupDic) do
		for iter2_17, iter3_17 in ipairs(iter1_17:GetSortAchvList()) do
			if iter3_17:GetStatus() == IslandAchievement.STATUS.GET then
				return true
			end
		end
	end

	return false
end

return var0_0

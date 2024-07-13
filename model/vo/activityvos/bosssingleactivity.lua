local var0_0 = class("BossSingleActivity", import("model.vo.Activity"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.enemyData = {}

	for iter0_1, iter1_1 in ipairs(arg0_1:GetEnemyIds()) do
		local var0_1 = BossSingleEnemyData.New({
			id = iter1_1,
			index = iter0_1
		})

		arg0_1.enemyData[iter1_1] = var0_1
	end
end

function var0_0.GetEnemyDatas(arg0_2)
	return arg0_2.enemyData
end

function var0_0.GetEnemyDataById(arg0_3, arg1_3)
	return arg0_3.enemyData[arg1_3]
end

function var0_0.GetEnemyDataByStageId(arg0_4, arg1_4)
	for iter0_4, iter1_4 in pairs(arg0_4.enemyData) do
		if iter1_4:GetExpeditionId() == arg1_4 then
			return iter1_4
		end
	end
end

function var0_0.GetEnemyDataByFleetIdx(arg0_5, arg1_5)
	for iter0_5, iter1_5 in pairs(arg0_5.enemyData) do
		if iter1_5:GetFleetIdx() == arg1_5 then
			return iter1_5
		end
	end
end

function var0_0.GetEnemyDataByType(arg0_6, arg1_6)
	for iter0_6, iter1_6 in pairs(arg0_6.enemyData) do
		if iter1_6:GetType() == arg1_6 then
			return iter1_6
		end
	end
end

function var0_0.GetCommonEnemyDatas(arg0_7)
	local var0_7 = {}

	for iter0_7, iter1_7 in pairs(arg0_7.enemyData) do
		if iter1_7:GetType() == BossSingleEnemyData.TYPE.EAST or iter1_7:GetType() == BossSingleEnemyData.TYPE.NORMAL or iter1_7:GetType() == BossSingleEnemyData.TYPE.HARD then
			table.insert(var0_7, iter1_7)
		end
	end

	return var0_7
end

function var0_0.GetStageIDs(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8.enemyData) do
		var0_8[iter1_8:GetFleetIdx()] = iter1_8:GetExpeditionId()
	end

	return var0_8
end

function var0_0.GetOilLimits(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9.enemyData) do
		var0_9[iter1_9:GetFleetIdx()] = iter1_9:GetOilLimit()
	end

	return var0_9
end

function var0_0.GetEnemyIds(arg0_10)
	return arg0_10:getConfig("config_data")
end

function var0_0.GetDailyCounts(arg0_11)
	return arg0_11.data1_list
end

function var0_0.AddDailyCount(arg0_12, arg1_12)
	if not arg0_12:IsCountLimit(arg1_12) then
		return
	end

	local var0_12 = arg0_12.enemyData[arg1_12]:GetFleetIdx()

	arg0_12:GetDailyCounts()[var0_12] = (arg0_12:GetDailyCounts()[var0_12] or 0) + 1
end

function var0_0.GetPassStages(arg0_13)
	return arg0_13.data2_list
end

function var0_0.AddPassStage(arg0_14, arg1_14)
	if arg0_14:HasPassStage(arg1_14) then
		return
	end

	table.insert(arg0_14:GetPassStages(), arg1_14)
end

function var0_0.HasPassStage(arg0_15, arg1_15)
	return table.contains(arg0_15:GetPassStages(), arg1_15)
end

function var0_0.IsUnlockByEnemyId(arg0_16, arg1_16)
	if not arg0_16.enemyData[arg1_16] then
		return false
	end

	local var0_16 = arg0_16.enemyData[arg1_16]:GetPreChapterId()

	return var0_16 == 0 or arg0_16:HasPassStage(arg0_16.enemyData[var0_16]:GetExpeditionId())
end

function var0_0.IsCountLimit(arg0_17, arg1_17)
	if not arg0_17.enemyData[arg1_17] then
		return false
	end

	return arg0_17.enemyData[arg1_17]:GetCount() > 0
end

function var0_0.GetCounts(arg0_18, arg1_18)
	local var0_18 = arg0_18.enemyData[arg1_18]

	if not var0_18 then
		return
	end

	local var1_18 = var0_18:GetFleetIdx()

	return var0_18:GetCount() - arg0_18:GetDailyCounts()[var1_18], var0_18:GetCount()
end

function var0_0.CheckEntranceByIdx(arg0_19, arg1_19)
	local var0_19 = arg0_19:GetEnemyDataByFleetIdx(arg1_19)

	if not var0_19 then
		return false, "not exist enemy data, index: " .. arg1_19
	end

	if not var0_19:InTime() then
		return false, i18n("common_activity_end")
	end

	if not arg0_19:IsUnlockByEnemyId(var0_19.id) then
		return false, i18n("adventure_unlock_tip")
	end

	return true
end

function var0_0.CheckCntByIdx(arg0_20, arg1_20)
	local var0_20 = arg0_20:GetEnemyDataByFleetIdx(arg1_20)

	if not var0_20 then
		return false, "not exist enemy data, index: " .. arg1_20
	end

	if arg0_20:IsCountLimit(var0_20.id) and arg0_20:GetCounts(var0_20.id) <= 0 then
		return false, i18n("sp_no_quota")
	end

	return true
end

function var0_0.GetBuffIdsByStageId(arg0_21, arg1_21)
	local var0_21 = getProxy(ActivityProxy):getActivityById(arg0_21:getConfig("config_id"))

	if not var0_21 or var0_21:isEnd() then
		return {}
	end

	if not arg0_21:GetEnemyDataByStageId(arg1_21):IsGuardianEffective() then
		return {}
	end

	return _.map(var0_21.data2_list, function(arg0_22)
		return pg.guardian_template[arg0_22].buff
	end)
end

return var0_0

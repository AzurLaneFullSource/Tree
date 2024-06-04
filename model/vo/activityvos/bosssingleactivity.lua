local var0 = class("BossSingleActivity", import("model.vo.Activity"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.enemyData = {}

	for iter0, iter1 in ipairs(arg0:GetEnemyIds()) do
		local var0 = BossSingleEnemyData.New({
			id = iter1,
			index = iter0
		})

		arg0.enemyData[iter1] = var0
	end
end

function var0.GetEnemyDatas(arg0)
	return arg0.enemyData
end

function var0.GetEnemyDataById(arg0, arg1)
	return arg0.enemyData[arg1]
end

function var0.GetEnemyDataByStageId(arg0, arg1)
	for iter0, iter1 in pairs(arg0.enemyData) do
		if iter1:GetExpeditionId() == arg1 then
			return iter1
		end
	end
end

function var0.GetEnemyDataByFleetIdx(arg0, arg1)
	for iter0, iter1 in pairs(arg0.enemyData) do
		if iter1:GetFleetIdx() == arg1 then
			return iter1
		end
	end
end

function var0.GetEnemyDataByType(arg0, arg1)
	for iter0, iter1 in pairs(arg0.enemyData) do
		if iter1:GetType() == arg1 then
			return iter1
		end
	end
end

function var0.GetCommonEnemyDatas(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.enemyData) do
		if iter1:GetType() == BossSingleEnemyData.TYPE.EAST or iter1:GetType() == BossSingleEnemyData.TYPE.NORMAL or iter1:GetType() == BossSingleEnemyData.TYPE.HARD then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.GetStageIDs(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.enemyData) do
		var0[iter1:GetFleetIdx()] = iter1:GetExpeditionId()
	end

	return var0
end

function var0.GetOilLimits(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.enemyData) do
		var0[iter1:GetFleetIdx()] = iter1:GetOilLimit()
	end

	return var0
end

function var0.GetEnemyIds(arg0)
	return arg0:getConfig("config_data")
end

function var0.GetDailyCounts(arg0)
	return arg0.data1_list
end

function var0.AddDailyCount(arg0, arg1)
	if not arg0:IsCountLimit(arg1) then
		return
	end

	local var0 = arg0.enemyData[arg1]:GetFleetIdx()

	arg0:GetDailyCounts()[var0] = (arg0:GetDailyCounts()[var0] or 0) + 1
end

function var0.GetPassStages(arg0)
	return arg0.data2_list
end

function var0.AddPassStage(arg0, arg1)
	if arg0:HasPassStage(arg1) then
		return
	end

	table.insert(arg0:GetPassStages(), arg1)
end

function var0.HasPassStage(arg0, arg1)
	return table.contains(arg0:GetPassStages(), arg1)
end

function var0.IsUnlockByEnemyId(arg0, arg1)
	if not arg0.enemyData[arg1] then
		return false
	end

	local var0 = arg0.enemyData[arg1]:GetPreChapterId()

	return var0 == 0 or arg0:HasPassStage(arg0.enemyData[var0]:GetExpeditionId())
end

function var0.IsCountLimit(arg0, arg1)
	if not arg0.enemyData[arg1] then
		return false
	end

	return arg0.enemyData[arg1]:GetCount() > 0
end

function var0.GetCounts(arg0, arg1)
	local var0 = arg0.enemyData[arg1]

	if not var0 then
		return
	end

	local var1 = var0:GetFleetIdx()

	return var0:GetCount() - arg0:GetDailyCounts()[var1], var0:GetCount()
end

function var0.CheckEntranceByIdx(arg0, arg1)
	local var0 = arg0:GetEnemyDataByFleetIdx(arg1)

	if not var0 then
		return false, "not exist enemy data, index: " .. arg1
	end

	if not var0:InTime() then
		return false, i18n("common_activity_end")
	end

	if not arg0:IsUnlockByEnemyId(var0.id) then
		return false, i18n("adventure_unlock_tip")
	end

	return true
end

function var0.CheckCntByIdx(arg0, arg1)
	local var0 = arg0:GetEnemyDataByFleetIdx(arg1)

	if not var0 then
		return false, "not exist enemy data, index: " .. arg1
	end

	if arg0:IsCountLimit(var0.id) and arg0:GetCounts(var0.id) <= 0 then
		return false, i18n("sp_no_quota")
	end

	return true
end

function var0.GetBuffIdsByStageId(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0:getConfig("config_id"))

	if not var0 or var0:isEnd() then
		return {}
	end

	if not arg0:GetEnemyDataByStageId(arg1):IsGuardianEffective() then
		return {}
	end

	return _.map(var0.data2_list, function(arg0)
		return pg.guardian_template[arg0].buff
	end)
end

return var0

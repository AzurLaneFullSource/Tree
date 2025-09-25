local var0_0 = class("IslandTechnologyAgency", import(".IslandBaseAgency"))

var0_0.PLACE_ID = 702

function var0_0.OnInit(arg0_1, arg1_1)
	local var0_1 = arg1_1.tech.finish_list
	local var1_1 = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.tech.repeat_finish_list) do
		var1_1[iter1_1.id] = iter1_1.num
	end

	arg0_1.techData = {}
	arg0_1.formula2Id = {}

	for iter2_1, iter3_1 in ipairs(pg.island_technology_template.all) do
		local var2_1 = IslandTechnology.New(iter3_1)

		if var2_1:IsOnceType() then
			var2_1:SetFinishedCnt(table.contains(var0_1, iter3_1) and 1 or 0)
		else
			var2_1:SetFinishedCnt(var1_1[iter3_1] or 0)
		end

		arg0_1.techData[var2_1.id] = var2_1
		arg0_1.formula2Id[var2_1:GetFormulaId()] = var2_1.id
	end
end

function var0_0.InitLockData(arg0_2)
	arg0_2.lockIds = {}

	for iter0_2, iter1_2 in pairs(arg0_2.techData) do
		if not iter1_2:IsUnlock() then
			table.insert(arg0_2.lockIds, iter1_2.id)
		end
	end
end

function var0_0.GetTechnology(arg0_3, arg1_3)
	return arg0_3.techData[arg1_3]
end

function var0_0.GetTechnologys(arg0_4)
	return arg0_4.techData
end

function var0_0.GetTechnologyByFormulaId(arg0_5, arg1_5)
	return arg0_5.techData[arg0_5.formula2Id[arg1_5]]
end

function var0_0.AddFinishCntByFormulatId(arg0_6, arg1_6)
	arg0_6:GetTechnologyByFormulaId(arg1_6):AddFinishedCnt()
end

function var0_0.GetAutoFinishList(arg0_7)
	local var0_7 = {}

	for iter0_7, iter1_7 in pairs(arg0_7.techData) do
		if iter1_7:CheckFinishImmd() then
			table.insert(var0_7, iter1_7.id)
		end
	end

	return var0_7
end

function var0_0.IsUnlockTech(arg0_8, arg1_8)
	return arg0_8.techData[arg1_8]:IsUnlock()
end

function var0_0.IsFinishedTech(arg0_9, arg1_9)
	if not arg0_9.techData[arg1_9] then
		return false
	end

	return arg0_9.techData[arg1_9]:GetFinishedCnt() > 0
end

function var0_0.GetPctByType(arg0_10, arg1_10)
	local var0_10 = pg.island_technology_template.get_id_list_by_tech_belong[arg1_10]

	return math.floor(arg0_10:GetFinishCntByType(arg1_10) / #var0_10 * 100)
end

function var0_0.GetFinishCntByType(arg0_11, arg1_11)
	local var0_11 = pg.island_technology_template.get_id_list_by_tech_belong[arg1_11]

	return underscore.reduce(var0_11, 0, function(arg0_12, arg1_12)
		return arg0_12 + (arg0_11:IsFinishedTech(arg1_12) and 1 or 0)
	end)
end

function var0_0.GetAllTypeFinishCnt(arg0_13)
	return underscore.reduce(pg.island_technology_template.all, 0, function(arg0_14, arg1_14)
		return arg0_14 + (arg0_13:IsFinishedTech(arg1_14) and 1 or 0)
	end)
end

function var0_0.GetEmptySlotId(arg0_15)
	local var0_15 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var0_0.PLACE_ID)

	for iter0_15, iter1_15 in ipairs(var0_0.GetSlotIds()) do
		local var1_15 = var0_15:GetDelegationSlotData(iter1_15)

		if var1_15 and var1_15:CanStartDelegation() then
			return iter1_15
		end
	end

	return nil
end

function var0_0.RemoveLockId(arg0_16, arg1_16)
	table.removebyvalue(arg0_16.lockIds, arg1_16)
end

function var0_0.TryAutoUnlock(arg0_17, arg1_17)
	local var0_17 = {}

	for iter0_17, iter1_17 in ipairs(arg0_17.lockIds) do
		if arg0_17.techData[iter1_17]:CanUnlock() then
			table.insert(var0_17, function(arg0_18)
				pg.m02:sendNotification(GAME.ISLAND_UNLOCK_TECH, {
					techId = iter1_17,
					callback = arg0_18
				})
			end)
		end
	end

	seriesAsync(var0_17, function()
		existCall(arg1_17)
	end)
end

function var0_0.IsTip(arg0_20)
	local var0_20 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var0_0.PLACE_ID)
	local var1_20 = var0_0.GetSlotIds()

	for iter0_20, iter1_20 in ipairs(var1_20) do
		local var2_20 = var0_20:GetDelegationSlotData(iter1_20)

		if var2_20 and var2_20:GetSlotRewardData() then
			return true
		end
	end

	return false
end

function var0_0.GetSlotIds()
	return pg.island_production_slot.get_id_list_by_place[var0_0.PLACE_ID]
end

return var0_0

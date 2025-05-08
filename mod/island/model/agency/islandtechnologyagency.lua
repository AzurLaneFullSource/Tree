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

function var0_0.GetTechnology(arg0_2, arg1_2)
	return arg0_2.techData[arg1_2]
end

function var0_0.GetTechnologyByFormulaId(arg0_3, arg1_3)
	return arg0_3.techData[arg0_3.formula2Id[arg1_3]]
end

function var0_0.AddFinishCntByFormulatId(arg0_4, arg1_4)
	arg0_4:GetTechnologyByFormulaId(arg1_4):AddFinishedCnt()
end

function var0_0.GetAutoFinishList(arg0_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in pairs(arg0_5.techData) do
		if iter1_5:CheckFinishImmd() then
			table.insert(var0_5, iter1_5.id)
		end
	end

	return var0_5
end

function var0_0.IsUnlockTech(arg0_6, arg1_6)
	return arg0_6.techData[arg1_6]:IsUnlock()
end

function var0_0.IsFinishedTech(arg0_7, arg1_7)
	return arg0_7.techData[arg1_7]:GetFinishedCnt() > 0
end

function var0_0.GetPctByType(arg0_8, arg1_8)
	local var0_8 = pg.island_technology_template.get_id_list_by_tech_belong[arg1_8]
	local var1_8 = underscore.reduce(var0_8, 0, function(arg0_9, arg1_9)
		return arg0_9 + (arg0_8:IsFinishedTech(arg1_9) and 1 or 0)
	end)

	return math.floor(var1_8 / #var0_8 * 100)
end

function var0_0.GetEmptySlotId(arg0_10)
	local var0_10 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(var0_0.PLACE_ID)

	for iter0_10, iter1_10 in ipairs(var0_0.GetSlotIds()) do
		local var1_10 = var0_10:GetDelegationSlotData(iter1_10)

		if var1_10 and var1_10:CanStartDelegation() then
			return iter1_10
		end
	end

	return nil
end

function var0_0.GetSlotIds()
	return pg.island_production_slot.get_id_list_by_place[var0_0.PLACE_ID]
end

return var0_0

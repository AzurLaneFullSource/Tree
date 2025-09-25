local var0_0 = class("IslandActivityNpcAllocator", import(".IslandComparableAllocator"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.npcList = arg1_1:GetIsland():GetActivityNpcAgency():GetNpcObjects()

	var0_0.super.Ctor(arg0_1, arg1_1)
end

function var0_0.AddNpc(arg0_2, arg1_2)
	if not table.contains(arg0_2.npcList, arg1_2) then
		table.insert(arg0_2.npcList, arg1_2)
	end
end

function var0_0.DelNpc(arg0_3, arg1_3)
	if table.contains(arg0_3.npcList, arg1_3) then
		table.removebyvalue(arg0_3.npcList, arg1_3)
	end
end

function var0_0.OnInitFlags(arg0_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.controller.sceneData.activityUnits) do
		arg0_4.flags[iter1_4.id] = arg0_4:IsVisible(iter1_4.id)
	end
end

function var0_0.IsVisible(arg0_5, arg1_5)
	if not table.contains(arg0_5.npcList, arg1_5) then
		return false
	end

	local var0_5 = pg.island_world_objects[arg1_5]

	if not var0_5 then
		return false
	end

	local var1_5 = var0_5.param.activity and var0_5.param.activity[1] or 0

	if var1_5 <= 0 then
		return false
	end

	local var2_5 = getProxy(ActivityProxy):RawGetActivityById(var1_5)

	return var2_5 and not var2_5:isEnd()
end

function var0_0.OnCompareSample(arg0_6, arg1_6, arg2_6)
	for iter0_6, iter1_6 in pairs(arg1_6) do
		local var0_6 = iter1_6
		local var1_6 = arg2_6[iter0_6]

		if var0_6 ~= nil and var1_6 ~= nil and var0_6 ~= var1_6 then
			if var0_6 == true and var1_6 == false then
				arg0_6:RemoveUnit(IslandConst.UNIT_LIST_OBJ, iter0_6)
			elseif var0_6 == false and var1_6 == true then
				local var2_6 = arg0_6:GetUnitData(iter0_6)

				if var2_6 then
					arg0_6:GenUnit(var2_6)
				end
			end
		end
	end
end

function var0_0.GetUnitData(arg0_7, arg1_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.controller.sceneData.activityUnits) do
		if iter1_7.id == arg1_7 then
			return iter1_7
		end
	end

	return nil
end

return var0_0

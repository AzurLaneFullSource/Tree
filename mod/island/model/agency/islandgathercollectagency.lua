local var0_0 = class("IslandGatherCollectAgency", import(".IslandBaseAgency"))

var0_0.AddGatherUnit = "IslandGatherCollectAgency:AddGatherUnit"
var0_0.RemoveGatherUnit = "IslandGatherCollectAgency:RemoveGatherUnit"
var0_0.ShowTpye = {
	FriendSee = 2,
	OnlySelf = 1,
	FriendSeeAndSign = 3
}

function var0_0.OnInit(arg0_1)
	return
end

function var0_0.InitGatherData(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.island_id = arg2_2
	arg0_2.gatherDic = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.gather_list) do
		arg0_2.gatherDic[iter1_2.id] = IslandWildGatherData.New(iter1_2, arg3_2)
	end

	arg0_2.collectDic = {}

	for iter2_2, iter3_2 in ipairs(arg1_2.fragment_list) do
		arg0_2.collectDic[iter3_2.id] = IslandCollectFragmentData.New(iter3_2, arg3_2)
	end
end

function var0_0.UpdateGatherData(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg1_3.gather_list) do
		local var0_3
		local var1_3
		local var2_3
		local var3_3

		if iter1_3.push_type == 1 then
			if arg0_3.gatherDic[iter1_3.id] then
				var0_3, var1_3, var2_3, var3_3 = arg0_3.gatherDic[iter1_3.id]:UpdateData(iter1_3)
			end
		elseif iter1_3.push_type == 2 then
			if not arg0_3.gatherDic[iter1_3.id] then
				arg0_3.gatherDic[iter1_3.id] = IslandWildGatherData.New(iter1_3)
				var0_3 = true
				var2_3 = arg0_3.gatherDic[iter1_3.id].pos
			end
		elseif arg0_3.gatherDic[iter1_3.id] then
			var3_3 = arg0_3.gatherDic[iter1_3.id].pos
			arg0_3.gatherDic[iter1_3.id] = nil
			var1_3 = true
		end

		if var1_3 then
			arg0_3:DispatchEvent(var0_0.RemoveGatherUnit, {
				unitId = var3_3
			})
		end

		if var0_3 then
			arg0_3:DispatchEvent(var0_0.AddGatherUnit, {
				unitId = var2_3
			})
		end
	end
end

function var0_0.UpdateCollectFragmentData(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg1_4.gather_list) do
		local var0_4
		local var1_4
		local var2_4
		local var3_4

		if iter1_4.push_type == 1 then
			if arg0_4.collectDic[iter1_4.id] then
				var0_4, var1_4, var2_4, var3_4 = arg0_4.collectDic[iter1_4.id]:UpdateData(iter1_4)
				unitId = arg0_4.collectDic[iter1_4.id].pos
			end
		elseif iter1_4.push_type == 2 then
			if not arg0_4.collectDic[iter1_4.id] then
				arg0_4.collectDic[iter1_4.id] = IslandCollectFragmentData.New(iter1_4)
				var0_4 = true
				var2_4 = arg0_4.collectDic[iter1_4.id].pos
			end
		elseif arg0_4.collectDic[iter1_4.id] then
			var1_4 = true
			var3_4 = arg0_4.collectDic[iter1_4.id].pos
			arg0_4.collectDic[iter1_4.id] = nil
		end

		if var1_4 then
			arg0_4:DispatchEvent(var0_0.RemoveGatherUnit, {
				unitId = var3_4
			})
		end

		if var0_4 then
			arg0_4:DispatchEvent(var0_0.AddGatherUnit, {
				unitId = var2_4
			})
		end
	end
end

function var0_0.GetUnitList(arg0_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in pairs(arg0_5.gatherDic) do
		if iter1_5:IsShow() then
			table.insert(var0_5, {
				unitId = iter1_5.pos,
				gatherType = IslandConst.UNIT_TYPE_ITEM_GATHER_ITEM
			})
		end
	end

	for iter2_5, iter3_5 in pairs(arg0_5.collectDic) do
		if iter3_5:IsShow() then
			table.insert(var0_5, {
				unitId = iter3_5.pos,
				gatherType = IslandConst.UNIT_TYPE_ITEM_WILD_COLLECT_ITEM
			})
		end
	end

	return var0_5
end

function var0_0.GetGatherDataByUnitId(arg0_6, arg1_6)
	for iter0_6, iter1_6 in pairs(arg0_6.gatherDic) do
		if iter1_6.pos == arg1_6 then
			return iter1_6
		end
	end

	return nil
end

function var0_0.GetCollectDataByUnitId(arg0_7, arg1_7)
	for iter0_7, iter1_7 in pairs(arg0_7.collectDic) do
		if iter1_7.pos == arg1_7 then
			return iter1_7
		end
	end

	return nil
end

function var0_0.CheckGatherCanSign(arg0_8, arg1_8)
	local var0_8 = arg0_8:GetGatherDataByUnitId(arg1_8)

	if not var0_8 then
		return false
	end

	return var0_8:CheckGatherCanShow(arg1_8)
end

function var0_0.IsSelf(arg0_9, arg1_9)
	return getProxy(PlayerProxy):getRawData().id == arg1_9
end

return var0_0

local var0_0 = class("IslandGatherCollectAgency", import(".IslandBaseAgency"))

var0_0.AddGatherUnit = "IslandGatherCollectAgency:AddGatherUnit"
var0_0.RemoveGatherUnit = "IslandGatherCollectAgency:RemoveGatherUnit"
var0_0.ShowTpye = {
	FriendSee = 2,
	OnlySelf = 1,
	FriendSeeAndSign = 3
}

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.finnishIds = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.finish_list or {}) do
		table.insert(arg0_1.finnishIds, iter1_1)
	end
end

function var0_0.InitPrivateData(arg0_2, arg1_2)
	local var0_2 = arg1_2.collect_sys or {}

	arg0_2.collectData = {}

	for iter0_2, iter1_2 in ipairs(var0_2.collect_item or {}) do
		arg0_2.collectData[iter1_2.id] = IslandCollectItemData.New(iter1_2)
	end

	arg0_2.finish_listCollect = var0_2.finish_list or {}
end

function var0_0.ExistFragment(arg0_3, arg1_3)
	local var0_3 = pg.island_collect_fragment[arg1_3].collection_id

	for iter0_3, iter1_3 in ipairs(arg0_3.finish_listCollect) do
		if var0_3 == iter1_3 then
			return true
		end
	end

	local var1_3 = arg0_3.collectData[var0_3]

	if var1_3 then
		return var1_3:CheckFragment(arg1_3)
	end

	return false
end

function var0_0.AddCollectFragment(arg0_4, arg1_4)
	local var0_4 = pg.island_collect_fragment[arg1_4].collection_id

	if not arg0_4.collectData[var0_4] then
		arg0_4.collectData[var0_4] = IslandCollectItemData.New({
			id = var0_4
		})
	end

	arg0_4.collectData[var0_4]:AddFragment(arg1_4)
	IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.FRAGMENT)
end

function var0_0.AddFinishCollectData(arg0_5, arg1_5)
	local var0_5 = arg0_5.collectData[arg1_5]

	if var0_5 then
		var0_5:ResetFragment()
	end

	table.insert(arg0_5.finish_listCollect, arg1_5)
end

function var0_0.InitGatherData(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6.island_id = arg2_6
	arg0_6.gatherDic = {}

	for iter0_6, iter1_6 in ipairs(arg1_6.gather_list) do
		arg0_6.gatherDic[iter1_6.id] = IslandWildGatherData.New(iter1_6, arg3_6)
	end

	arg0_6.collectDic = {}

	for iter2_6, iter3_6 in ipairs(arg1_6.fragment_list) do
		arg0_6.collectDic[iter3_6.id] = IslandCollectFragmentData.New(iter3_6, arg3_6)
	end
end

function var0_0.UpdateGatherData(arg0_7, arg1_7)
	for iter0_7, iter1_7 in ipairs(arg1_7.gather_list) do
		local var0_7
		local var1_7
		local var2_7
		local var3_7

		if iter1_7.push_type == 1 then
			if arg0_7.gatherDic[iter1_7.id] then
				var0_7, var1_7, var2_7, var3_7 = arg0_7.gatherDic[iter1_7.id]:UpdateData(iter1_7)
			end
		elseif iter1_7.push_type == 2 then
			if not arg0_7.gatherDic[iter1_7.id] then
				arg0_7.gatherDic[iter1_7.id] = IslandWildGatherData.New(iter1_7)
				var0_7 = true
				var2_7 = arg0_7.gatherDic[iter1_7.id].pos
			end
		elseif arg0_7.gatherDic[iter1_7.id] then
			var3_7 = arg0_7.gatherDic[iter1_7.id].pos
			arg0_7.gatherDic[iter1_7.id] = nil
			var1_7 = true
		end

		if var1_7 then
			arg0_7:DispatchEvent(var0_0.RemoveGatherUnit, {
				unitId = var3_7
			})
		end

		if var0_7 then
			arg0_7:DispatchEvent(var0_0.AddGatherUnit, {
				unitId = var2_7,
				islandId = arg1_7.island_id,
				gatherType = IslandConst.UNIT_TYPE_ITEM_GATHER_ITEM
			})
		end
	end
end

function var0_0.UpdateCollectFragmentData(arg0_8, arg1_8)
	for iter0_8, iter1_8 in ipairs(arg1_8.gather_list) do
		local var0_8
		local var1_8
		local var2_8
		local var3_8

		if iter1_8.push_type == 1 then
			if arg0_8.collectDic[iter1_8.id] then
				var0_8, var1_8, var2_8, var3_8 = arg0_8.collectDic[iter1_8.id]:UpdateData(iter1_8)
				unitId = arg0_8.collectDic[iter1_8.id].pos
			end
		elseif iter1_8.push_type == 2 then
			if not arg0_8.collectDic[iter1_8.id] then
				arg0_8.collectDic[iter1_8.id] = IslandCollectFragmentData.New(iter1_8)
				var0_8 = true
				var2_8 = arg0_8.collectDic[iter1_8.id].pos
			end
		elseif arg0_8.collectDic[iter1_8.id] then
			var1_8 = true
			var3_8 = arg0_8.collectDic[iter1_8.id].pos
			arg0_8.collectDic[iter1_8.id] = nil
		end

		if var1_8 then
			arg0_8:DispatchEvent(var0_0.RemoveGatherUnit, {
				unitId = var3_8
			})
		end

		if var0_8 then
			arg0_8:DispatchEvent(var0_0.AddGatherUnit, {
				unitId = var2_8
			})
		end
	end
end

function var0_0.GetUnitList(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9.gatherDic) do
		if iter1_9:IsShow() then
			table.insert(var0_9, {
				unitId = iter1_9.pos,
				gatherType = IslandConst.UNIT_TYPE_ITEM_GATHER_ITEM
			})
		end
	end

	for iter2_9, iter3_9 in pairs(arg0_9.collectDic) do
		if iter3_9:IsShow() then
			table.insert(var0_9, {
				unitId = iter3_9.pos,
				gatherType = IslandConst.UNIT_TYPE_ITEM_WILD_COLLECT_ITEM
			})
		end
	end

	return var0_9
end

function var0_0.GetGatherDataByUnitId(arg0_10, arg1_10)
	for iter0_10, iter1_10 in pairs(arg0_10.gatherDic) do
		if iter1_10.pos == arg1_10 then
			return iter1_10
		end
	end

	return nil
end

function var0_0.GetCollectDataByUnitId(arg0_11, arg1_11)
	for iter0_11, iter1_11 in pairs(arg0_11.collectDic) do
		if iter1_11.pos == arg1_11 then
			return iter1_11
		end
	end

	return nil
end

function var0_0.CheckGatherCanSign(arg0_12, arg1_12)
	local var0_12 = arg0_12:GetGatherDataByUnitId(arg1_12)

	if not var0_12 then
		return false
	end

	return var0_12:CheckGatherCanShow(arg1_12)
end

function var0_0.IsSelf(arg0_13, arg1_13)
	return getProxy(PlayerProxy):getRawData().id == arg1_13
end

return var0_0

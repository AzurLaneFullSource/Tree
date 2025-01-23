local var0_0 = class("NewEducatePlanState", import(".NewEducateStateBase"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1:SetPlans(arg1_1.plans or {})

	arg0_1.curIdx = arg1_1.cur_index or 0
end

function var0_0.SetPlans(arg0_2, arg1_2)
	arg0_2.plans = {}
	arg0_2.idxList = {}
	arg0_2.drops = {}
	arg0_2.costs = {}
	arg0_2.curIdx = 0

	for iter0_2, iter1_2 in ipairs(arg1_2) do
		arg0_2.plans[iter1_2.key] = iter1_2.value

		table.insert(arg0_2.idxList, iter1_2.key)
	end

	table.sort(arg0_2.idxList)
end

function var0_0.GetIdxList(arg0_3)
	return arg0_3.idxList
end

function var0_0.GetPlans(arg0_4)
	return arg0_4.plans
end

function var0_0.GetCurIdx(arg0_5)
	return arg0_5.curIdx
end

function var0_0.SetNextPlanIdx(arg0_6)
	if arg0_6.curIdx == 0 then
		arg0_6.curIdx = arg0_6.idxList[1]
	else
		local var0_6 = table.indexof(arg0_6.idxList, arg0_6.curIdx)

		arg0_6.curIdx = arg0_6.idxList[var0_6 + 1]
	end
end

function var0_0.SetDrops(arg0_7, arg1_7)
	arg0_7.drops = arg1_7
end

function var0_0.AddDrops(arg0_8, arg1_8)
	arg0_8.drops = table.mergeArray(arg0_8.drops, arg1_8)
end

function var0_0.GetDrops(arg0_9)
	return arg0_9.drops
end

function var0_0.SetResources(arg0_10, arg1_10)
	arg0_10.resources = arg1_10
end

function var0_0.GetResources(arg0_11)
	return arg0_11.resources
end

function var0_0.SetAttrs(arg0_12, arg1_12)
	arg0_12.attrs = arg1_12
end

function var0_0.GetAttrs(arg0_13)
	return arg0_13.attrs
end

function var0_0.MarkFinish(arg0_14)
	arg0_14.curIdx = arg0_14.idxList[#arg0_14.idxList]
end

function var0_0.IsFinish(arg0_15)
	if #arg0_15.idxList == 0 then
		return true
	end

	return arg0_15.curIdx == arg0_15.idxList[#arg0_15.idxList]
end

function var0_0.Reset(arg0_16)
	arg0_16.plans = {}
	arg0_16.idxList = {}
	arg0_16.drops = {}
	arg0_16.resources = {}
	arg0_16.attrs = {}
	arg0_16.curIdx = 0
end

return var0_0

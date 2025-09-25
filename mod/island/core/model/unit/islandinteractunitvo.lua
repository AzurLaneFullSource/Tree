local var0_0 = class("IslandInteractUnitVO", import(".IslandUnitVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.config = pg.island_unit_interactive_item[arg0_1.modelId]
	arg0_1.slots = {}

	for iter0_1 = 1, arg0_1.config.slot_cnt do
		table.insert(arg0_1.slots, InteractSlot.New(iter0_1, arg0_1.id))
	end

	arg0_1:InitTimlineInfo()
end

function var0_0.InitTimlineInfo(arg0_2)
	arg0_2.timelineInfo = {}

	if arg0_2.config.timeline == nil or arg0_2.config.timeline == "" then
		return
	end

	for iter0_2, iter1_2 in ipairs(arg0_2.config.timeline) do
		table.insert(arg0_2.timelineInfo, pg.island_item_timeline[iter1_2])
	end
end

function var0_0.GetEmptySlot(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.slots) do
		if iter1_3:IsEmpty() then
			return iter1_3
		end
	end

	return nil
end

function var0_0.GetSlotById(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.slots) do
		if iter1_4.id == arg1_4 then
			return iter1_4
		end
	end

	return nil
end

function var0_0.GetUsingSlot(arg0_5, arg1_5)
	if arg1_5 then
		for iter0_5, iter1_5 in ipairs(arg0_5.slots) do
			if not iter1_5:IsEmpty() and iter1_5:IsUsing(arg1_5) then
				return iter1_5
			end
		end

		return nil
	else
		return arg0_5.slots[1]
	end
end

function var0_0.AnySlotUsing(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.slots) do
		if not iter1_6:IsEmpty() then
			return true
		end
	end

	return false
end

function var0_0.GetTimeline(arg0_7)
	return arg0_7.timelineInfo
end

function var0_0.HasTimeline(arg0_8)
	return #arg0_8.timelineInfo > 0
end

function var0_0.GetSlot(arg0_9)
	return arg0_9.config.slotCnt
end

function var0_0.GetBlackboardParam(arg0_10)
	return arg0_10.config.param
end

return var0_0

local var0_0 = class("AgoraFurniture", import(".AgoraPlaceableItem"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.configId = arg1_1.configId
	arg0_1.config = pg.island_furniture_template[arg0_1.configId]

	var0_0.super.Ctor(arg0_1, arg1_1, Vector2(arg0_1.config.size[1], arg0_1.config.size[2]))

	arg0_1.slots = {}

	arg0_1:InitSlots()
end

function var0_0.InitSlots(arg0_2)
	for iter0_2 = 1, arg0_2.config.slot_cnt do
		table.insert(arg0_2.slots, AgoraFurnitureSlot.New(iter0_2, arg0_2.id))
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

function var0_0.GetUsingSlot(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.slots) do
		if not iter1_4:IsEmpty() and iter1_4:IsUsing(arg1_4) then
			return iter1_4
		end
	end

	return nil
end

function var0_0.AnySlotUsing(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.slots) do
		if not iter1_5:IsEmpty() then
			return true
		end
	end

	return false
end

function var0_0.HasBt(arg0_6)
	return arg0_6.config.bt ~= nil and arg0_6.config.bt ~= ""
end

function var0_0.GetBt(arg0_7)
	return arg0_7.config.bt
end

function var0_0.GetResPath(arg0_8)
	return arg0_8.config.model
end

function var0_0.HasTimeline(arg0_9)
	return arg0_9.config.timeline ~= nil and arg0_9.config.timeline ~= ""
end

function var0_0.GetTimeline(arg0_10)
	return arg0_10.config.timeline
end

function var0_0.GetName(arg0_11)
	return arg0_11.config.name
end

return var0_0

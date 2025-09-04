local var0_0 = class("AgoraFurniture", import(".AgoraPlaceableItem"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.configId = arg1_1.configId
	arg0_1.config = pg.island_furniture_template[arg0_1.configId]

	assert(arg0_1.config, arg0_1.configId)
	var0_0.super.Ctor(arg0_1, arg1_1, Vector2(arg0_1.config.size[1], arg0_1.config.size[2]))

	arg0_1.slots = {}

	arg0_1:InitSlots()
	arg0_1:InitTimlineInfo()
end

function var0_0.GetMapType(arg0_2)
	if arg0_2:IsNewTileType() then
		return IslandConst.AGORA_MAP_TYPE_NEWTILE
	elseif arg0_2:IsBuildingType() then
		return IslandConst.AGORA_MAP_TYPE_BUILDING
	else
		return IslandConst.AGORA_MAP_TYPE_COMMON
	end
end

function var0_0.InitSlots(arg0_3)
	for iter0_3 = 1, arg0_3.config.slot_cnt do
		table.insert(arg0_3.slots, AgoraFurnitureSlot.New(iter0_3, arg0_3.id))
	end
end

function var0_0.CanInteraction(arg0_4)
	return #arg0_4.slots > 0
end

function var0_0.InitTimlineInfo(arg0_5)
	arg0_5.timelineInfo = {}

	if arg0_5.config.timeline == nil or arg0_5.config.timeline == "" then
		return
	end

	for iter0_5, iter1_5 in ipairs(arg0_5.config.timeline) do
		table.insert(arg0_5.timelineInfo, pg.island_item_timeline[iter1_5])
	end
end

function var0_0.GetEmptySlot(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.slots) do
		if iter1_6:IsEmpty() then
			return iter1_6
		end
	end

	return nil
end

function var0_0.GetUsingSlot(arg0_7, arg1_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.slots) do
		if not iter1_7:IsEmpty() and iter1_7:IsUsing(arg1_7) then
			return iter1_7
		end
	end

	return nil
end

function var0_0.AnySlotUsing(arg0_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.slots) do
		if not iter1_8:IsEmpty() then
			return true
		end
	end

	return false
end

function var0_0.HasBt(arg0_9)
	return arg0_9.config.bt ~= nil and arg0_9.config.bt ~= ""
end

function var0_0.GetBt(arg0_10)
	return arg0_10.config.bt
end

function var0_0.GetResPath(arg0_11)
	return arg0_11.config.model
end

function var0_0.GetTimeline(arg0_12)
	return arg0_12.timelineInfo
end

function var0_0.HasTimeline(arg0_13)
	return #arg0_13.timelineInfo > 0
end

function var0_0.GetName(arg0_14)
	return arg0_14.config.name
end

function var0_0.GetCost(arg0_15)
	return arg0_15.config.capacityCost
end

function var0_0.GetRarity(arg0_16)
	return arg0_16.config.rarity
end

function var0_0.GetIcon(arg0_17)
	return arg0_17.config.icon
end

function var0_0.GetType(arg0_18)
	return arg0_18.config.type
end

function var0_0.GetTime(arg0_19)
	return 0
end

function var0_0.GetDesc(arg0_20)
	return arg0_20.config.describe or ""
end

function var0_0.IsOptionalShapeType(arg0_21)
	return arg0_21:GetType() == AgoraFurnitureType.FLOOR or arg0_21:GetType() == AgoraFurnitureType.TILE
end

function var0_0.IsFoundationType(arg0_22)
	return arg0_22:GetType() == AgoraFurnitureType.FOUNDATION
end

function var0_0.IsBuildingType(arg0_23)
	return arg0_23:GetType() == AgoraFurnitureType.BUILDING
end

function var0_0.IsNewTileType(arg0_24)
	return arg0_24:GetType() == AgoraFurnitureType.TILE_NEW
end

function var0_0.CanSelect(arg0_25)
	return true
end

function var0_0.CanOp(arg0_26)
	if arg0_26:IsFoundationType() or arg0_26:IsBuildingType() then
		return false
	end

	return true
end

function var0_0.IsFloor(arg0_27)
	return arg0_27:GetType() == AgoraFurnitureType.FLOOR
end

function var0_0.IsTile(arg0_28)
	return arg0_28:GetType() == AgoraFurnitureType.TILE
end

function var0_0.Match(arg0_29, arg1_29)
	if arg1_29 == "" or not arg1_29 then
		return true
	end

	local var0_29 = arg0_29:GetName()

	arg1_29 = string.lower(arg1_29)

	local var1_29 = string.lower(var0_29)

	if string.find(var1_29, arg1_29) then
		return true
	end

	return false
end

function var0_0.ToPlacementData(arg0_30)
	local var0_30 = var0_0.super.ToPlacementData(arg0_30)

	var0_30.configId = arg0_30.configId

	return var0_30
end

return var0_0

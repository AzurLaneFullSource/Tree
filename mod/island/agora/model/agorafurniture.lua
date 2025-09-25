local var0_0 = class("AgoraFurniture", import(".AgoraPlaceableItem"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.configId = arg1_1.configId
	arg0_1.time = arg1_1.time or arg0_1.configId
	arg0_1.isNew = defaultValue(arg1_1.isNew, false)
	arg0_1.config = pg.island_furniture_template[arg0_1.configId]

	assert(arg0_1.config, arg0_1.configId)
	var0_0.super.Ctor(arg0_1, arg1_1, Vector2(arg0_1.config.size[1], arg0_1.config.size[2]))
end

function var0_0.IsNew(arg0_2)
	return arg0_2.isNew
end

function var0_0.ClearNew(arg0_3)
	arg0_3.isNew = false
end

function var0_0.GetMapType(arg0_4)
	if arg0_4:IsNewTileType() then
		return IslandConst.AGORA_MAP_TYPE_NEWTILE
	elseif arg0_4:IsBuildingType() then
		return IslandConst.AGORA_MAP_TYPE_BUILDING
	else
		return IslandConst.AGORA_MAP_TYPE_COMMON
	end
end

function var0_0.CanInteraction(arg0_5)
	return arg0_5.config.interact_point ~= "" and #arg0_5.config.interact_point > 0
end

function var0_0.GetInteractionPoints(arg0_6)
	if not arg0_6:CanInteraction() then
		return {}
	end

	return arg0_6.config.interact_point
end

function var0_0.Read(arg0_7)
	return false
end

function var0_0.HasBt(arg0_8)
	return arg0_8.config.bt ~= nil and arg0_8.config.bt ~= ""
end

function var0_0.GetBt(arg0_9)
	return arg0_9.config.bt
end

function var0_0.GetResPath(arg0_10)
	return arg0_10.config.model
end

function var0_0.GetTimeline(arg0_11)
	return arg0_11.timelineInfo
end

function var0_0.HasTimeline(arg0_12)
	return #arg0_12.timelineInfo > 0
end

function var0_0.GetName(arg0_13)
	return arg0_13.config.name
end

function var0_0.GetCost(arg0_14)
	return arg0_14.config.capacityCost
end

function var0_0.GetRarity(arg0_15)
	return arg0_15.config.rarity
end

function var0_0.GetIcon(arg0_16)
	return arg0_16.config.icon
end

function var0_0.GetType(arg0_17)
	return arg0_17.config.type
end

function var0_0.GetTime(arg0_18)
	return arg0_18.time
end

function var0_0.GetDesc(arg0_19)
	return arg0_19.config.describe or ""
end

function var0_0.IsOptionalShapeType(arg0_20)
	return arg0_20:GetType() == AgoraFurnitureType.FLOOR or arg0_20:GetType() == AgoraFurnitureType.TILE
end

function var0_0.IsFoundationType(arg0_21)
	return arg0_21:GetType() == AgoraFurnitureType.FOUNDATION
end

function var0_0.IsBuildingType(arg0_22)
	return arg0_22:GetType() == AgoraFurnitureType.BUILDING
end

function var0_0.IsNewTileType(arg0_23)
	return arg0_23:GetType() == AgoraFurnitureType.TILE_NEW
end

function var0_0.CanSelect(arg0_24)
	return true
end

function var0_0.CanOp(arg0_25)
	if arg0_25:IsFoundationType() or arg0_25:IsBuildingType() then
		return false
	end

	return true
end

function var0_0.IsFloor(arg0_26)
	return arg0_26:GetType() == AgoraFurnitureType.FLOOR
end

function var0_0.IsTile(arg0_27)
	return arg0_27:GetType() == AgoraFurnitureType.TILE
end

function var0_0.Match(arg0_28, arg1_28)
	if arg1_28 == "" or not arg1_28 then
		return true
	end

	local var0_28 = arg0_28:GetName()

	arg1_28 = string.lower(arg1_28)

	local var1_28 = string.lower(var0_28)

	if string.find(var1_28, arg1_28) then
		return true
	end

	return false
end

function var0_0.ToPlacementData(arg0_29)
	local var0_29 = var0_0.super.ToPlacementData(arg0_29)

	var0_29.configId = arg0_29.configId

	return var0_29
end

return var0_0

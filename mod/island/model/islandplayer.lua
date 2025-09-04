local var0_0 = class("IslandPlayer", import("model.vo.PlayerAttire"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.id = arg1_1.id

	arg0_1:Flush(arg1_1)

	arg0_1.position = Vector3.zero
	arg0_1.rotation = Vector3.zero

	arg0_1:InitDressupData(arg1_1)
end

function var0_0.Flush(arg0_2, arg1_2)
	var0_0.super.Flush(arg0_2, arg1_2)

	arg0_2.name = arg1_2.name
	arg0_2.level = arg1_2.level
	arg0_2.mapId = arg1_2.map_id
end

function var0_0.GetModelId(arg0_3)
	if arg0_3:IsSelf() then
		return 0
	else
		local var0_3 = arg0_3:GetCurCommderId()

		return pg.island_dress_commander[var0_3].model
	end
end

function var0_0.GetDressByType(arg0_4, arg1_4)
	return arg0_4.currentDressTypeDic[arg1_4]
end

function var0_0.GetHairFaceBodyDress(arg0_5)
	local var0_5 = arg0_5:GetDressByType(IslandShipDressHelperNew.DressType.Hair)
	local var1_5 = arg0_5:GetDressByType(IslandShipDressHelperNew.DressType.Face)
	local var2_5 = arg0_5:GetDressByType(IslandShipDressHelperNew.DressType.Body)

	return var0_5, var1_5, var2_5
end

function var0_0.GetCurCommderId(arg0_6)
	local var0_6, var1_6, var2_6 = arg0_6:GetHairFaceBodyDress()

	return (IslandShipDressHelper.GetCurCommanderId(var0_6, var1_6, var2_6))
end

function var0_0.IsSelf(arg0_7)
	return arg0_7.id == getProxy(PlayerProxy):getRawData().id
end

function var0_0.GetName(arg0_8)
	return arg0_8.name
end

function var0_0.GetLevel(arg0_9)
	return arg0_9.level
end

function var0_0.GetIcon(arg0_10)
	return pg.ship_skin_template[arg0_10.character].painting
end

function var0_0.GetLoaction(arg0_11)
	if not arg0_11.mapId or not pg.island_map[arg0_11.mapId] then
		return ""
	end

	return pg.island_map[arg0_11.mapId].name
end

function var0_0.SetPosition(arg0_12, arg1_12)
	arg0_12.position = arg1_12
end

function var0_0.SetRotation(arg0_13, arg1_13)
	arg0_13.rotation = arg1_13
end

function var0_0.UpdateName(arg0_14, arg1_14)
	arg0_14.name = arg1_14
end

function var0_0.InitDressupData(arg0_15, arg1_15)
	if arg1_15.cur_dress then
		arg0_15.currentDressTypeDic = {}

		for iter0_15, iter1_15 in ipairs(arg1_15.cur_dress or {}) do
			arg0_15.currentDressTypeDic[iter1_15.type] = iter1_15.id
		end
	end
end

function var0_0.ChangeDressupData(arg0_16, arg1_16)
	arg0_16.currentDressTypeDic = {}

	for iter0_16, iter1_16 in ipairs(arg1_16 or {}) do
		arg0_16.currentDressTypeDic[iter1_16.type] = iter1_16.id
	end
end

function var0_0.IsInMap(arg0_17, arg1_17)
	return arg0_17.mapId == arg1_17
end

return var0_0

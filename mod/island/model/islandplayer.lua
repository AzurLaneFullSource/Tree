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
	return 0
end

function var0_0.GetDressByType(arg0_4, arg1_4)
	return arg0_4.currentDressTypeDic[arg1_4] or 0
end

function var0_0.GetCurrentColorByDressId(arg0_5, arg1_5)
	return arg0_5.dressColorDic[arg1_5] or 0
end

function var0_0.GetHairFaceBodyDress(arg0_6)
	local var0_6 = arg0_6:GetDressByType(IslandShipDressHelperNew.DressType.Hair)
	local var1_6 = arg0_6:GetDressByType(IslandShipDressHelperNew.DressType.Face)
	local var2_6 = arg0_6:GetDressByType(IslandShipDressHelperNew.DressType.Body)

	return var0_6, var1_6, var2_6
end

function var0_0.GetCurCommderId(arg0_7)
	local var0_7, var1_7, var2_7 = arg0_7:GetHairFaceBodyDress()

	return (IslandShipDressHelper.GetCurCommanderId(var0_7, var1_7, var2_7))
end

function var0_0.IsSelf(arg0_8)
	return arg0_8.id == getProxy(PlayerProxy):getRawData().id
end

function var0_0.GetName(arg0_9)
	return arg0_9.name
end

function var0_0.GetLevel(arg0_10)
	return arg0_10.level
end

function var0_0.GetIcon(arg0_11)
	return pg.ship_skin_template[arg0_11.character].painting
end

function var0_0.GetLoaction(arg0_12)
	if not arg0_12.mapId or not pg.island_map[arg0_12.mapId] then
		return ""
	end

	return pg.island_map[arg0_12.mapId].name
end

function var0_0.SetPosition(arg0_13, arg1_13)
	arg0_13.position = arg1_13
end

function var0_0.SetRotation(arg0_14, arg1_14)
	arg0_14.rotation = arg1_14
end

function var0_0.UpdateName(arg0_15, arg1_15)
	arg0_15.name = arg1_15
end

function var0_0.InitDressupData(arg0_16, arg1_16)
	arg0_16.currentDressTypeDic = {}

	for iter0_16, iter1_16 in ipairs(arg1_16.cur_dress or {}) do
		arg0_16.currentDressTypeDic[iter1_16.type] = iter1_16.id
	end

	arg0_16.dressColorDic = {}

	for iter2_16, iter3_16 in ipairs(arg1_16.dress_color or {}) do
		arg0_16.dressColorDic[iter3_16.id] = iter3_16.color
	end
end

function var0_0.ChangeDressupData(arg0_17, arg1_17, arg2_17)
	arg0_17.currentDressTypeDic = {}

	for iter0_17, iter1_17 in ipairs(arg1_17 or {}) do
		arg0_17.currentDressTypeDic[iter1_17.type] = iter1_17.id
	end

	arg0_17.dressColorDic = {}

	for iter2_17, iter3_17 in ipairs(arg2_17 or {}) do
		arg0_17.dressColorDic[iter3_17.id] = iter3_17.color
	end
end

function var0_0.IsInMap(arg0_18, arg1_18)
	return arg0_18.mapId == arg1_18
end

return var0_0

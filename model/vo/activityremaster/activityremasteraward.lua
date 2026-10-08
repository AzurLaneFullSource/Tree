local var0_0 = class("ActivityRemasterAward", import("..BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg1_1
end

function var0_0.bindConfigTable(arg0_2)
	return pg.activity_limit_item_guide_re
end

function var0_0.GetRawDropData(arg0_3)
	return {
		arg0_3:getConfig("type"),
		arg0_3:getConfig("drop_id"),
		arg0_3:getConfig("count")
	}
end

function var0_0.GetDrop(arg0_4)
	if arg0_4:IsShip() then
		local var0_4 = arg0_4:GetRawDropData()
		local var1_4 = var0_4[1]
		local var2_4 = var0_4[2]
		local var3_4 = var0_4[3]
		local var4_4 = ShipGroup.getDefaultShipConfig(var2_4)

		return Drop.Create({
			var1_4,
			var4_4.id,
			var3_4
		})
	else
		return Drop.Create(arg0_4:GetRawDropData())
	end
end

function var0_0.GetOwnedCount(arg0_5)
	local var0_5 = arg0_5:GetDrop()

	if arg0_5:IsShip() then
		local var1_5 = arg0_5:GetRawDropData()
		local var2_5 = var1_5[1]
		local var3_5 = var1_5[2]
		local var4_5 = var1_5[3]

		return getProxy(BayProxy):getSameGroupShipCount(var3_5)
	else
		return var0_5:getOwnedCount()
	end
end

function var0_0.GetWays(arg0_6)
	return arg0_6:getConfig("link_params")
end

function var0_0.IsCollectionFurniture(arg0_7)
	local var0_7 = arg0_7:GetRawDropData()
	local var1_7 = var0_7[1]
	local var2_7 = var0_7[2]
	local var3_7 = var0_7[3]

	if var1_7 == DROP_TYPE_FURNITURE then
		return pg.furniture_data_template[var2_7].type == Furniture.TYPE_COLLECTION
	end

	return false
end

function var0_0.IsShip(arg0_8)
	local var0_8 = arg0_8:GetRawDropData()
	local var1_8 = var0_8[1]
	local var2_8 = var0_8[2]
	local var3_8 = var0_8[3]

	return var1_8 == DROP_TYPE_SHIP
end

function var0_0.IsEquipmentSkin(arg0_9)
	local var0_9 = arg0_9:GetRawDropData()
	local var1_9 = var0_9[1]
	local var2_9 = var0_9[2]
	local var3_9 = var0_9[3]

	return var1_9 == DROP_TYPE_EQUIPMENT_SKIN
end

return var0_0

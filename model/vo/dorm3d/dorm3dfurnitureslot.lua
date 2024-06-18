local var0_0 = class("Dorm3dFurnitureSlot", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.dorm3d_furniture_slot_template
end

function var0_0.GetName(arg0_2)
	return arg0_2:getConfig("name")
end

function var0_0.GetType(arg0_3)
	return arg0_3:getConfig("type")
end

function var0_0.GetShipGroupId(arg0_4)
	return arg0_4:getConfig("char_id")
end

function var0_0.GetZoneID(arg0_5)
	return arg0_5:getConfig("zone_id")
end

function var0_0.GetDefaultFurniture(arg0_6)
	return arg0_6:getConfig("default_furniture")
end

function var0_0.GetFurnitureName(arg0_7)
	return arg0_7:getConfig("furniture_name")
end

function var0_0.CanUseFurniture(arg0_8, arg1_8)
	if arg1_8:GetType() ~= arg0_8:GetType() then
		return false
	end

	local var0_8 = arg1_8:GetTargetSlots()

	if #var0_8 == 0 then
		return true
	end

	return table.contains(var0_8, arg0_8:GetConfigID())
end

return var0_0

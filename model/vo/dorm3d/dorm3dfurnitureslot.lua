local var0 = class("Dorm3dFurnitureSlot", import("model.vo.BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.dorm3d_furniture_slot_template
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.GetShipGroupId(arg0)
	return arg0:getConfig("char_id")
end

function var0.GetZoneID(arg0)
	return arg0:getConfig("zone_id")
end

function var0.GetDefaultFurniture(arg0)
	return arg0:getConfig("default_furniture")
end

function var0.GetFurnitureName(arg0)
	return arg0:getConfig("furniture_name")
end

function var0.CanUseFurniture(arg0, arg1)
	if arg1:GetType() ~= arg0:GetType() then
		return false
	end

	local var0 = arg1:GetTargetSlots()

	if #var0 == 0 then
		return true
	end

	return table.contains(var0, arg0:GetConfigID())
end

return var0

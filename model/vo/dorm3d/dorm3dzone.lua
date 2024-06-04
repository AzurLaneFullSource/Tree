local var0 = class("Dorm3dZone", import("model.vo.BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.dorm3d_zone_template
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetShipGroupId(arg0)
	return arg0:getConfig("char_id")
end

function var0.IsGlobal(arg0)
	return arg0:getConfig("is_global") == 1
end

function var0.GetWatchCameraName(arg0)
	return arg0:getConfig("watch_camera")
end

function var0.GetSlotIDList(arg0)
	return pg.dorm3d_furniture_slot_template.get_id_list_by_zone_id[arg0.configId] or {}
end

function var0.SetSlots(arg0, arg1)
	arg0.slots = arg1
end

function var0.GetSlots(arg0)
	return arg0.slots or {}
end

function var0.GetTypePriorities(arg0)
	local var0 = arg0:getConfig("type_prioritys")

	if var0 == nil or var0 == "" then
		return {}
	end

	return var0
end

function var0.SortTypes(arg0, arg1)
	local var0 = arg0:GetTypePriorities()

	table.sort(arg1, CompareFuncs({
		function(arg0)
			return table.indexof(var0, arg0) or 99
		end,
		function(arg0)
			return -arg0
		end
	}))
end

return var0

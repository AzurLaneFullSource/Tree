local var0_0 = class("Dorm3dZone", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.dorm3d_zone_template
end

function var0_0.GetName(arg0_2)
	return arg0_2:getConfig("name")
end

function var0_0.GetShipGroupId(arg0_3)
	return arg0_3:getConfig("char_id")
end

function var0_0.IsGlobal(arg0_4)
	return arg0_4:getConfig("is_global") == 1
end

function var0_0.GetWatchCameraName(arg0_5)
	return arg0_5:getConfig("watch_camera")
end

function var0_0.GetSlotIDList(arg0_6)
	return pg.dorm3d_furniture_slot_template.get_id_list_by_zone_id[arg0_6.configId] or {}
end

function var0_0.SetSlots(arg0_7, arg1_7)
	arg0_7.slots = arg1_7
end

function var0_0.GetSlots(arg0_8)
	return arg0_8.slots or {}
end

function var0_0.GetTypePriorities(arg0_9)
	local var0_9 = arg0_9:getConfig("type_prioritys")

	if var0_9 == nil or var0_9 == "" then
		return {}
	end

	return var0_9
end

function var0_0.SortTypes(arg0_10, arg1_10)
	local var0_10 = arg0_10:GetTypePriorities()

	table.sort(arg1_10, CompareFuncs({
		function(arg0_11)
			return table.indexof(var0_10, arg0_11) or 99
		end,
		function(arg0_12)
			return -arg0_12
		end
	}))
end

return var0_0

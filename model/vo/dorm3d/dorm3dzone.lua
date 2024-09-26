local var0_0 = class("Dorm3dZone", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.dorm3d_zone_template
end

function var0_0.GetName(arg0_2)
	return arg0_2:getConfig("name")
end

function var0_0.IsGlobal(arg0_3)
	return arg0_3:getConfig("is_global") == 1
end

function var0_0.GetWatchCameraName(arg0_4)
	return arg0_4:getConfig("watch_camera")
end

function var0_0.GetSlotIDList(arg0_5)
	return pg.dorm3d_furniture_slot_template.get_id_list_by_zone_id[arg0_5.configId] or {}
end

function var0_0.SetSlots(arg0_6, arg1_6)
	arg0_6.slots = arg1_6
end

function var0_0.GetSlots(arg0_7)
	return arg0_7.slots or {}
end

function var0_0.GetTypePriorities(arg0_8)
	local var0_8 = arg0_8:getConfig("type_prioritys")

	if var0_8 == nil or var0_8 == "" then
		return {}
	end

	return var0_8
end

function var0_0.SortTypes(arg0_9, arg1_9)
	local var0_9 = arg0_9:GetTypePriorities()

	table.sort(arg1_9, CompareFuncs({
		function(arg0_10)
			return table.indexof(var0_9, arg0_10) or 99
		end,
		function(arg0_11)
			return -arg0_11
		end
	}))
end

return var0_0

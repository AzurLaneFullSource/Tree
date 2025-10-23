local var0_0 = class("Dorm3dCameraAnim", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.dorm3d_camera_anim_template
end

function var0_0.GetName(arg0_2)
	return arg0_2:getConfig("desc")
end

function var0_0.GetStateName(arg0_3)
	return arg0_3:getConfig("state")
end

function var0_0.GetAnimTime(arg0_4)
	return arg0_4:getConfig("anim_time")
end

function var0_0.GetPreAnimID(arg0_5)
	return arg0_5:getConfig("pre_anim")
end

function var0_0.GetFinishAnimID(arg0_6)
	return arg0_6:getConfig("finish_anim")
end

function var0_0.GetUnlockRequirment(arg0_7)
	return arg0_7:getConfig("unlock")
end

function var0_0.GetFurnitureID(arg0_8)
	return arg0_8:getConfig("furniture_id")
end

function var0_0.GetZoneName(arg0_9)
	local var0_9 = tonumber(arg0_9:getConfig("zone"))

	return pg.dorm3d_camera_zone_template[var0_9].name
end

function var0_0.GetZoneIcon(arg0_10)
	return arg0_10:getConfig("icon")
end

function var0_0.GetStartPoint(arg0_11)
	return arg0_11:getConfig("staypoint")
end

function var0_0.GetEnterSceneAnim(arg0_12)
	local var0_12 = arg0_12:getConfig("enter_scene_anim")

	if var0_12 and var0_12 ~= "" and #var0_12 > 0 then
		return var0_12
	else
		return {}
	end
end

function var0_0.GetEnterExtraItem(arg0_13)
	local var0_13 = arg0_13:getConfig("enter_extra_item")

	if var0_13 and var0_13 ~= "" and #var0_13 > 0 then
		return var0_13
	else
		return {}
	end
end

function var0_0.GetHideSceneItem(arg0_14)
	local var0_14 = arg0_14:getConfig("hide_scene_item")

	if var0_14 and var0_14 ~= "" and #var0_14 > 0 then
		return var0_14
	else
		return {}
	end
end

return var0_0

local var0 = class("Dorm3dCameraAnim", import("model.vo.BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.dorm3d_camera_anim_template
end

function var0.GetName(arg0)
	return arg0:getConfig("desc")
end

function var0.GetStateName(arg0)
	return arg0:getConfig("state")
end

function var0.GetAnimTime(arg0)
	return arg0:getConfig("anim_time")
end

function var0.GetPreAnimID(arg0)
	return arg0:getConfig("pre_anim")
end

function var0.GetFinishAnimID(arg0)
	return arg0:getConfig("finish_anim")
end

function var0.GetUnlockRequirment(arg0)
	return arg0:getConfig("unlock")
end

function var0.GetFurnitureID(arg0)
	return arg0:getConfig("furniture_id")
end

return var0

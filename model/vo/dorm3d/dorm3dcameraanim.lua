﻿local var0_0 = class("Dorm3dCameraAnim", import("model.vo.BaseVO"))

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

return var0_0
local var0_0 = class("Dorm3dCameraZone", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.dorm3d_camera_zone_template
end

function var0_0.Ctor(arg0_2, arg1_2)
	var0_0.super.Ctor(arg0_2, arg1_2)

	arg0_2.regulaAnims = _.map(arg0_2:GetRegularAnimIDList(), function(arg0_3)
		return Dorm3dCameraAnim.New({
			configId = arg0_3
		})
	end)
	arg0_2.specialAnims = _.map(arg0_2:GetSpecialFurnitureIDList(), function(arg0_4)
		local var0_4 = arg0_4[1]

		return {
			furnitureId = var0_4,
			slotId = arg0_4[2],
			anims = _.map(arg0_2:GetSpecialAnimIDListByFurnitureID(var0_4), function(arg0_5)
				return Dorm3dCameraAnim.New({
					configId = arg0_5
				})
			end)
		}
	end)
end

function var0_0.GetName(arg0_6)
	return arg0_6:getConfig("name")
end

function var0_0.GetShipGroupId(arg0_7)
	return arg0_7:getConfig("char_id")
end

function var0_0.GetWatchCameraName(arg0_8)
	return arg0_8:getConfig("watch_camera")
end

function var0_0.GetRegularAnimIDList(arg0_9)
	return arg0_9:getConfig("regular_anim") or {}
end

function var0_0.GetRegularAnims(arg0_10)
	return arg0_10.regulaAnims
end

function var0_0.GetSpecialFurnitureIDList(arg0_11)
	return arg0_11:getConfig("special_furniture") or {}
end

function var0_0.GetSpecialAnimIDListByFurnitureID(arg0_12, arg1_12)
	return pg.dorm3d_camera_anim_template.get_id_list_by_furniture_id[arg1_12] or {}
end

function var0_0.GetSpecialAnims(arg0_13)
	return arg0_13.specialAnims
end

function var0_0.GetAnimSpeeds(arg0_14)
	return arg0_14:getConfig("anim_speeds")
end

function var0_0.Get(arg0_15)
	return arg0_15:getConfig("")
end

function var0_0.GetRecordTime(arg0_16)
	return arg0_16:getConfig("record_time")
end

function var0_0.GetFocusDistanceRange(arg0_17)
	return arg0_17:getConfig("focus_distance")
end

function var0_0.GetDepthOfFieldBlurRange(arg0_18)
	return arg0_18:getConfig("blur_strength")
end

function var0_0.GetExposureRange(arg0_19)
	return arg0_19:getConfig("exposure")
end

function var0_0.GetContrastRange(arg0_20)
	return arg0_20:getConfig("contrast")
end

function var0_0.GetSaturationRange(arg0_21)
	return arg0_21:getConfig("saturation")
end

return var0_0

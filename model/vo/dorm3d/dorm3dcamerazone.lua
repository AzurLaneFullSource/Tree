local var0 = class("Dorm3dCameraZone", import("model.vo.BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.dorm3d_camera_zone_template
end

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.regulaAnims = _.map(arg0:GetRegularAnimIDList(), function(arg0)
		return Dorm3dCameraAnim.New({
			configId = arg0
		})
	end)
	arg0.specialAnims = _.map(arg0:GetSpecialFurnitureIDList(), function(arg0)
		local var0 = arg0[1]

		return {
			furnitureId = var0,
			slotId = arg0[2],
			anims = _.map(arg0:GetSpecialAnimIDListByFurnitureID(var0), function(arg0)
				return Dorm3dCameraAnim.New({
					configId = arg0
				})
			end)
		}
	end)
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetShipGroupId(arg0)
	return arg0:getConfig("char_id")
end

function var0.GetWatchCameraName(arg0)
	return arg0:getConfig("watch_camera")
end

function var0.GetRegularAnimIDList(arg0)
	return arg0:getConfig("regular_anim") or {}
end

function var0.GetRegularAnims(arg0)
	return arg0.regulaAnims
end

function var0.GetSpecialFurnitureIDList(arg0)
	return arg0:getConfig("special_furniture") or {}
end

function var0.GetSpecialAnimIDListByFurnitureID(arg0, arg1)
	return pg.dorm3d_camera_anim_template.get_id_list_by_furniture_id[arg1] or {}
end

function var0.GetSpecialAnims(arg0)
	return arg0.specialAnims
end

function var0.GetAnimSpeeds(arg0)
	return arg0:getConfig("anim_speeds")
end

function var0.Get(arg0)
	return arg0:getConfig("")
end

function var0.GetRecordTime(arg0)
	return arg0:getConfig("record_time")
end

function var0.GetFocusDistanceRange(arg0)
	return arg0:getConfig("focus_distance")
end

function var0.GetDepthOfFieldBlurRange(arg0)
	return arg0:getConfig("blur_strength")
end

function var0.GetExposureRange(arg0)
	return arg0:getConfig("exposure")
end

function var0.GetContrastRange(arg0)
	return arg0:getConfig("contrast")
end

function var0.GetSaturationRange(arg0)
	return arg0:getConfig("saturation")
end

return var0

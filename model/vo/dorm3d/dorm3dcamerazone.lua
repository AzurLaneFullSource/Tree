local var0_0 = class("Dorm3dCameraZone", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.dorm3d_camera_zone_template
end

function var0_0.Ctor(arg0_2, arg1_2)
	var0_0.super.Ctor(arg0_2, arg1_2)

	arg0_2.regulaShipAnimsdDic = {}

	for iter0_2, iter1_2 in ipairs(arg0_2:GetRegularAnimIDList()) do
		arg0_2.regulaShipAnimsdDic[iter1_2[1]] = _.map(iter1_2[2], function(arg0_3)
			return Dorm3dCameraAnim.New({
				configId = arg0_3
			})
		end)
	end

	arg0_2.specialFurnitureDic = {}
	arg0_2.specialAnims = _.map(arg0_2:GetSpecialFurnitureIDList(), function(arg0_4)
		local var0_4 = arg0_4[1]

		arg0_2.specialFurnitureDic[var0_4] = true

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

function var0_0.GetWatchCameraName(arg0_7)
	return arg0_7:getConfig("watch_camera")
end

function var0_0.GetRegularAnimIDList(arg0_8)
	return arg0_8:getConfig("regular_anim") or {}
end

function var0_0.GetRegularAnimsByShipId(arg0_9, arg1_9)
	return arg0_9.regulaShipAnimsdDic[arg1_9] or {}
end

function var0_0.GetSpecialFurnitureIDList(arg0_10)
	return arg0_10:getConfig("special_furniture") or {}
end

function var0_0.GetAllSpecialList(arg0_11, arg1_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(pg.dorm3d_camera_anim_template.get_id_list_by_furniture_id) do
		local function var1_11(arg0_12)
			if pg.dorm3d_furniture_template[arg0_12].room_id == arg1_11 then
				return true
			end

			return false
		end

		if iter0_11 ~= 0 and var1_11(iter0_11) and not arg0_11.specialFurnitureDic[iter0_11] then
			local var2_11 = {}

			for iter2_11, iter3_11 in ipairs(iter1_11) do
				table.insert(var2_11, Dorm3dCameraAnim.New({
					configId = iter3_11
				}))
			end

			table.insert(var0_11, {
				furnitureId = iter0_11,
				anims = var2_11
			})
		end
	end

	if arg0_11.specialAnims then
		for iter4_11, iter5_11 in ipairs(arg0_11.specialAnims) do
			table.insert(var0_11, iter4_11, iter5_11)
		end
	end

	return var0_11
end

function var0_0.CheckFurnitureIdInZone(arg0_13, arg1_13)
	return arg0_13.specialFurnitureDic[arg1_13]
end

function var0_0.GetSpecialAnimIDListByFurnitureID(arg0_14, arg1_14)
	return pg.dorm3d_camera_anim_template.get_id_list_by_furniture_id[arg1_14] or {}
end

function var0_0.GetSpecialAnims(arg0_15)
	return arg0_15.specialAnims
end

function var0_0.GetAnimSpeeds(arg0_16)
	return arg0_16:getConfig("anim_speeds")
end

function var0_0.GetRecordTime(arg0_17)
	return arg0_17:getConfig("record_time")
end

function var0_0.GetFocusDistanceRange(arg0_18)
	return arg0_18:getConfig("focus_distance")
end

function var0_0.GetDepthOfFieldBlurRange(arg0_19)
	return arg0_19:getConfig("blur_strength")
end

function var0_0.GetExposureRange(arg0_20)
	return arg0_20:getConfig("exposure")
end

function var0_0.GetContrastRange(arg0_21)
	return arg0_21:getConfig("contrast")
end

function var0_0.GetSaturationRange(arg0_22)
	return arg0_22:getConfig("saturation")
end

return var0_0

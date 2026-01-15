local var0_0 = class("Dorm3dHxHelper")

function var0_0.GetTimelineMainCharacter()
	local var0_1 = GameObject.Find("[actor]").transform
	local var1_1

	table.IpairsCArray(var0_1:GetComponentsInChildren(typeof("BLHXCharacterPropertiesController")), function(arg0_2, arg1_2)
		if arg0_2 == 0 or var0_0.GetSkinIdByModelName(arg1_2.gameObject.name) then
			var1_1 = arg1_2.transform
		end
	end)

	return var1_1
end

function var0_0.GetSkinIdByModelName(arg0_3)
	arg0_3 = string.gsub(arg0_3, "%s*%(Clone%)$", "")

	for iter0_3, iter1_3 in ipairs(pg.dorm3d_resource.all) do
		local var0_3 = pg.dorm3d_resource[iter1_3]

		if var0_3.origin_model == arg0_3 or var0_3.model_id == arg0_3 then
			return iter1_3
		end
	end

	return nil
end

function var0_0.ReplaceCharacterParts(arg0_4)
	if not HXSet.isHx() then
		return false
	end

	local var0_4 = var0_0.GetSkinIdByModelName(arg0_4.name)

	if not var0_4 then
		return false
	end

	local var1_4 = pg.dorm3d_resource[var0_4].hx_component

	if not var1_4 or var1_4 == "" or #var1_4 == 0 then
		return false
	end

	local var2_4 = false

	_.each(var1_4, function(arg0_5)
		if not checkABExist(arg0_5) then
			warning("要替换的部件不存在", arg0_5)

			return
		end

		GraphicsInterface.Instance:LoadCharacterComponent(go(arg0_4), arg0_5)
		warning("ReplaceCharacterPart", arg0_5)

		var2_4 = true
	end)

	return var2_4
end

function var0_0.ShowHolyLight(arg0_6, arg1_6, arg2_6)
	if not HXSet.isHx() then
		return false
	end

	arg2_6 = arg2_6 or false

	local var0_6 = {}

	for iter0_6, iter1_6 in ipairs(arg0_6) do
		if iter1_6 then
			local var1_6 = var0_0.GetSkinIdByModelName(iter1_6.name)

			if var1_6 then
				for iter2_6, iter3_6 in ipairs(pg.dorm3d_holylight.get_id_list_by_skin_id[var1_6] or {}) do
					table.insert(var0_6, {
						iter1_6,
						pg.dorm3d_holylight[iter3_6]
					})
				end
			end
		end
	end

	UIItemList.StaticAlign(arg1_6, arg1_6:GetChild(0), #var0_6, function(arg0_7, arg1_7, arg2_7)
		local var0_7, var1_7 = unpack(var0_6[arg1_7 + 1])
		local var2_7 = arg2_7:GetComponent(typeof(HolyLightController))

		var2_7.targetBone = var0_7:Find(var1_7.target_bone)
		var2_7.localAxis = Vector3(unpack(var1_7.axis))
		var2_7.invertAxis = var1_7.invert ~= 0
		var2_7.defaultAxisThreshold = var1_7.default_threshold
		var2_7.axisThreshold = var2_7.defaultAxisThreshold
		var2_7.rotationOffset = Vector3(unpack(var1_7.rotation_offset))

		GetSpriteFromAtlasAsync(var1_7.texture, "", function(arg0_8)
			local var0_8 = arg2_7:GetComponent(typeof(Image))

			var0_8.sprite = arg0_8
			var0_8.color = Color.New(unpack(var1_7.color))
		end)

		var2_7.baseSize = Vector2(unpack(var1_7.base_size))
		var2_7.useRaycastOcclusion = arg2_6
		var2_7.targetDispatcher = GetOrAddComponent(var0_7, typeof(DormAnimationEventDispatcher))
	end)
end

function var0_0.GetHolyLightScreenShotInfo(arg0_9)
	local var0_9 = {}
	local var1_9 = {}

	for iter0_9 = 0, arg0_9.childCount - 1 do
		local var2_9 = arg0_9:GetChild(iter0_9).gameObject

		if isActive(var2_9) then
			local var3_9, var4_9, var5_9 = var2_9:GetComponent(typeof(HolyLightController)):GetScreenShotInfo(nil, nil)

			if var3_9 then
				table.insert(var0_9, var4_9)
				table.insert(var1_9, var5_9)
			end
		end
	end

	return var1_9, var0_9
end

return var0_0

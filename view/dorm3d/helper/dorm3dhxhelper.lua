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
	for iter0_6, iter1_6 in ipairs(arg0_6) do
		if iter1_6 then
			GetOrAddComponent(iter1_6, typeof(DormAnimationEventDispatcher))
		end
	end

	if not HXSet.isHx() then
		return false
	end

	arg2_6 = arg2_6 or false

	local var0_6 = {}

	for iter2_6, iter3_6 in ipairs(arg0_6) do
		if iter3_6 then
			local var1_6 = var0_0.GetSkinIdByModelName(iter3_6.name)

			if var1_6 then
				for iter4_6, iter5_6 in ipairs(pg.dorm3d_holylight.get_id_list_by_skin_id[var1_6] or {}) do
					table.insert(var0_6, {
						iter3_6,
						pg.dorm3d_holylight[iter5_6]
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

function var0_0.SetModelHolyLightActive(arg0_9, arg1_9, arg2_9)
	if not HXSet.isHx() then
		return false
	end

	if not arg0_9 or IsNil(arg0_9) or not arg1_9 or IsNil(arg1_9) then
		return false
	end

	local var0_9 = false

	for iter0_9 = 0, arg1_9.childCount - 1 do
		local var1_9 = arg1_9:GetChild(iter0_9)
		local var2_9 = var1_9:GetComponent(typeof(HolyLightController))
		local var3_9 = var2_9 and var2_9.targetBone

		if var3_9 and not IsNil(var3_9) and var3_9:IsChildOf(arg0_9) then
			setActive(var1_9, arg2_9)

			var0_9 = true
		end
	end

	return var0_9
end

function var0_0.GetHolyLightScreenShotInfo(arg0_10)
	local var0_10 = {}
	local var1_10 = {}

	for iter0_10 = 0, arg0_10.childCount - 1 do
		local var2_10 = arg0_10:GetChild(iter0_10).gameObject

		if isActive(var2_10) then
			local var3_10, var4_10, var5_10 = var2_10:GetComponent(typeof(HolyLightController)):GetScreenShotInfo(nil, nil)

			if var3_10 then
				table.insert(var0_10, var4_10)
				table.insert(var1_10, var5_10)
			end
		end
	end

	return var1_10, var0_10
end

function var0_0.HideCharacterPart(arg0_11, arg1_11, arg2_11)
	local var0_11 = var0_0.GetSkinIdByModelName(arg0_11.name)

	warning("HideCharacterPart skinId", var0_11)

	if not var0_11 then
		return
	end

	local var1_11 = Dorm3dSkin.New({
		configId = var0_11
	})

	if arg2_11 and not var1_11:ShouldApplyHiddenPartInTimeline() then
		return
	end

	local var2_11 = var1_11:GetGroupId()

	arg1_11 = arg1_11 or getProxy(ApartmentProxy):getApartment(var2_11):GetHiddenParts(var0_11)

	local var3_11, var4_11 = var1_11:GetActiveAndHiddenPartNames(arg1_11)

	_.each(var3_11, function(arg0_12)
		setActive(arg0_11:Find(arg0_12), true)
	end)
	_.each(var4_11, function(arg0_13)
		setActive(arg0_11:Find(arg0_13), false)
	end)
end

return var0_0

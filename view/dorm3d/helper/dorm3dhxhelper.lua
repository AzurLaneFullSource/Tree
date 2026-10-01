local var0_0 = class("Dorm3dHxHelper")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.loader = arg1_1
	arg0_1.materialsBySkin = {}
	arg0_1.loadedGroups = {}
	arg0_1.loadingGroups = {}
	arg0_1.appliedMaterials = setmetatable({}, {
		__mode = "k"
	})
end

local function var1_0(arg0_2)
	local var0_2 = pg.dorm3d_resource[arg0_2].hx_material

	return type(var0_2) == "table" and var0_2 or {}
end

local function var2_0(arg0_3)
	return string.lower((string.gsub(arg0_3, "%s*%(Instance%)$", "")))
end

local function var3_0(arg0_4)
	return string.lower((string.gsub(arg0_4, "\\", "/")))
end

local function var4_0(arg0_5, arg1_5)
	local var0_5 = string.match(var3_0(arg1_5), "[^/]+$")
	local var1_5 = {}

	for iter0_5, iter1_5 in ipairs(arg0_5) do
		if string.match(var3_0(iter1_5), "[^/]+$") == var0_5 then
			table.insert(var1_5, iter1_5)
		end
	end

	return #var1_5 > 0 and table.concat(var1_5, ", ") or "<none>"
end

function var0_0.GetMaterialResources(arg0_6)
	local var0_6 = {}

	if not HXSet.isHx() then
		return var0_6
	end

	for iter0_6, iter1_6 in ipairs(pg.dorm3d_resource.get_id_list_by_ship_group[arg0_6] or {}) do
		for iter2_6, iter3_6 in ipairs(var1_0(iter1_6)) do
			if not table.contains(var0_6, iter3_6[1]) then
				table.insert(var0_6, iter3_6[1])
			end
		end
	end

	return var0_6
end

function var0_0.LoadMaterials(arg0_7, arg1_7, arg2_7)
	if not HXSet.isHx() or arg0_7.loadedGroups[arg1_7] then
		existCall(arg2_7)

		return
	end

	if arg0_7.loadingGroups[arg1_7] then
		table.insert(arg0_7.loadingGroups[arg1_7], arg2_7)

		return
	end

	arg0_7.loadingGroups[arg1_7] = {
		arg2_7
	}

	local var0_7 = {}
	local var1_7 = {}

	for iter0_7, iter1_7 in ipairs(pg.dorm3d_resource.get_id_list_by_ship_group[arg1_7] or {}) do
		var0_7[iter1_7] = {}

		for iter2_7, iter3_7 in ipairs(var1_0(iter1_7)) do
			local var2_7, var3_7 = unpack(iter3_7)

			var1_7[var2_7] = var1_7[var2_7] or {}

			table.insert(var1_7[var2_7], {
				iter1_7,
				var3_7
			})
		end
	end

	local var4_7 = {}

	for iter4_7, iter5_7 in pairs(var1_7) do
		table.insert(var4_7, function(arg0_8)
			arg0_7.loader:LoadBundle(iter4_7, function(arg0_9)
				if not arg0_9 or not EDITOR_TOOL and IsNil(arg0_9.ab) then
					error("Missing Dorm3D HX material bundle: " .. iter4_7)
				end

				local var0_9 = arg0_9:GetAllAssetNames()
				local var1_9 = {}

				for iter0_9, iter1_9 in ipairs(var0_9) do
					var1_9[var3_0(iter1_9)] = iter1_9
				end

				local var2_9 = {}

				for iter2_9, iter3_9 in ipairs(iter5_7) do
					local var3_9, var4_9 = unpack(iter3_9)
					local var5_9 = var2_9[var4_9]

					if not var5_9 then
						local var6_9 = var1_9[var3_0(var4_9)]

						if not var6_9 then
							error(string.format("Missing Dorm3D HX material asset in bundle: skin=%s bundle=%s asset=%s same-name assets=[%s]", var3_9, iter4_7, var4_9, var4_0(var0_9, var4_9)))
						end

						var5_9 = arg0_9:LoadAssetSync(var6_9, typeof(Material), false, false)

						if IsNil(var5_9) then
							error(string.format("Failed to load Dorm3D HX material: skin=%s bundle=%s asset=%s resolved=%s", var3_9, iter4_7, var4_9, var6_9))
						end

						var2_9[var4_9] = var5_9
					end

					local var7_9 = var2_0(var5_9.name)
					local var8_9 = var0_7[var3_9][var7_9]

					if var8_9 and (var8_9.bundle ~= iter4_7 or var8_9.asset ~= var4_9) then
						error(string.format("Duplicate Dorm3D HX material name: skin=%s name=%s assets=%s / %s", var3_9, var7_9, var8_9.asset, var4_9))
					end

					var0_7[var3_9][var7_9] = {
						material = var5_9,
						bundle = iter4_7,
						asset = var4_9
					}
				end

				arg0_8()
			end)
		end)
	end

	parallelAsync(var4_7, function()
		for iter0_10, iter1_10 in pairs(var0_7) do
			arg0_7.materialsBySkin[iter0_10] = iter1_10
		end

		arg0_7.loadedGroups[arg1_7] = true

		local var0_10 = arg0_7.loadingGroups[arg1_7]

		arg0_7.loadingGroups[arg1_7] = nil

		for iter2_10, iter3_10 in ipairs(var0_10) do
			iter3_10()
		end
	end)
end

function var0_0.ReplaceMaterials(arg0_11, arg1_11, arg2_11)
	if not HXSet.isHx() or IsNil(arg1_11) then
		return false
	end

	arg2_11 = arg2_11 or var0_0.GetSkinIdByModelName(arg1_11.name)

	if not arg2_11 then
		return false
	end

	local var0_11 = arg0_11.materialsBySkin[arg2_11]

	if not var0_11 then
		if #var1_0(arg2_11) > 0 then
			error("Dorm3D HX materials are not loaded for skin: " .. tostring(arg2_11))
		end

		return false
	end

	if not next(var0_11) then
		return false
	end

	local var1_11 = {}
	local var2_11 = arg1_11:GetComponentsInChildren(typeof(Renderer), true)

	table.IpairsCArray(var2_11, function(arg0_12, arg1_12)
		local var0_12 = arg1_12.sharedMaterials
		local var1_12 = arg0_11.appliedMaterials[arg1_12]
		local var2_12 = false

		table.IpairsCArray(var0_12, function(arg0_13, arg1_13)
			if IsNil(arg1_13) then
				return
			end

			local var0_13 = var0_11[var2_0(arg1_13.name)]

			if not var0_13 or arg1_13 == var0_13.material then
				return
			end

			if var1_12 and var1_12.skinId == arg2_11 and var1_12.materials[arg0_13] == arg1_13 then
				return
			end

			var0_12[arg0_13] = var0_13.material
			var2_12 = true

			warning("DORM3D HX REPLACE MATERIAL", arg1_13.name)
		end)

		if var2_12 then
			arg1_12.sharedMaterials = var0_12

			table.insert(var1_11, arg1_12)
		end
	end)

	if #var1_11 == 0 then
		return false
	end

	GraphicsInterface.Instance:UpdateCharacterMaterialLst(go(arg1_11))

	for iter0_11, iter1_11 in ipairs(var1_11) do
		arg0_11.appliedMaterials[iter1_11] = {
			skinId = arg2_11,
			materials = iter1_11.sharedMaterials
		}
	end

	return true
end

function var0_0.Apply(arg0_14, arg1_14, arg2_14)
	if not HXSet.isHx() or IsNil(arg1_14) then
		return false
	end

	if var0_0.ReplaceCharacterParts(arg1_14, arg2_14) then
		return true
	end

	return arg0_14:ReplaceMaterials(arg1_14, arg2_14)
end

function var0_0.GetTimelineMainCharacter()
	local var0_15 = GameObject.Find("[actor]").transform
	local var1_15

	table.IpairsCArray(var0_15:GetComponentsInChildren(typeof("BLHXCharacterPropertiesController")), function(arg0_16, arg1_16)
		if arg0_16 == 0 or var0_0.GetSkinIdByModelName(arg1_16.gameObject.name) then
			var1_15 = arg1_16.transform
		end
	end)

	return var1_15
end

function var0_0.GetSkinIdByModelName(arg0_17)
	arg0_17 = string.gsub(arg0_17, "%s*%(Clone%)$", "")

	for iter0_17, iter1_17 in ipairs(pg.dorm3d_resource.all) do
		local var0_17 = pg.dorm3d_resource[iter1_17]

		if var0_17.origin_model == arg0_17 or var0_17.model_id == arg0_17 then
			return iter1_17
		end
	end

	return nil
end

function var0_0.ReplaceCharacterParts(arg0_18, arg1_18)
	if not HXSet.isHx() then
		return false
	end

	arg1_18 = arg1_18 or var0_0.GetSkinIdByModelName(arg0_18.name)

	if not arg1_18 then
		return false
	end

	local var0_18 = pg.dorm3d_resource[arg1_18].hx_component

	if not var0_18 or var0_18 == "" or #var0_18 == 0 then
		return false
	end

	local var1_18 = false

	_.each(var0_18, function(arg0_19)
		if not checkABExist(arg0_19) then
			warning("要替换的部件不存在", arg0_19)

			return
		end

		GraphicsInterface.Instance:LoadCharacterComponent(go(arg0_18), arg0_19)
		warning("ReplaceCharacterPart", arg0_19)

		var1_18 = true
	end)

	return var1_18
end

function var0_0.ShowHolyLight(arg0_20, arg1_20, arg2_20)
	for iter0_20, iter1_20 in ipairs(arg0_20) do
		if iter1_20 then
			GetOrAddComponent(iter1_20, typeof(DormAnimationEventDispatcher))
		end
	end

	if not HXSet.isHx() then
		return false
	end

	arg2_20 = arg2_20 or false

	local var0_20 = {}

	for iter2_20, iter3_20 in ipairs(arg0_20) do
		if iter3_20 then
			local var1_20 = var0_0.GetSkinIdByModelName(iter3_20.name)

			if var1_20 then
				for iter4_20, iter5_20 in ipairs(pg.dorm3d_holylight.get_id_list_by_skin_id[var1_20] or {}) do
					table.insert(var0_20, {
						iter3_20,
						pg.dorm3d_holylight[iter5_20]
					})
				end
			end
		end
	end

	UIItemList.StaticAlign(arg1_20, arg1_20:GetChild(0), #var0_20, function(arg0_21, arg1_21, arg2_21)
		local var0_21, var1_21 = unpack(var0_20[arg1_21 + 1])
		local var2_21 = arg2_21:GetComponent(typeof(HolyLightController))

		var2_21.targetBone = var0_21:Find(var1_21.target_bone)
		var2_21.localAxis = Vector3(unpack(var1_21.axis))
		var2_21.invertAxis = var1_21.invert ~= 0
		var2_21.defaultAxisThreshold = var1_21.default_threshold
		var2_21.axisThreshold = var2_21.defaultAxisThreshold
		var2_21.rotationOffset = Vector3(unpack(var1_21.rotation_offset))

		GetSpriteFromAtlasAsync(var1_21.texture, "", function(arg0_22)
			local var0_22 = arg2_21:GetComponent(typeof(Image))

			var0_22.sprite = arg0_22
			var0_22.color = Color.New(unpack(var1_21.color))
		end)

		var2_21.baseSize = Vector2(unpack(var1_21.base_size))
		var2_21.useRaycastOcclusion = arg2_20
		var2_21.targetDispatcher = GetOrAddComponent(var0_21, typeof(DormAnimationEventDispatcher))
	end)
end

function var0_0.SetModelHolyLightActive(arg0_23, arg1_23, arg2_23)
	if not HXSet.isHx() then
		return false
	end

	if not arg0_23 or IsNil(arg0_23) or not arg1_23 or IsNil(arg1_23) then
		return false
	end

	local var0_23 = false

	for iter0_23 = 0, arg1_23.childCount - 1 do
		local var1_23 = arg1_23:GetChild(iter0_23)
		local var2_23 = var1_23:GetComponent(typeof(HolyLightController))
		local var3_23 = var2_23 and var2_23.targetBone

		if var3_23 and not IsNil(var3_23) and var3_23:IsChildOf(arg0_23) then
			setActive(var1_23, arg2_23)

			var0_23 = true
		end
	end

	return var0_23
end

function var0_0.GetHolyLightScreenShotInfo(arg0_24)
	local var0_24 = {}
	local var1_24 = {}

	for iter0_24 = 0, arg0_24.childCount - 1 do
		local var2_24 = arg0_24:GetChild(iter0_24).gameObject

		if isActive(var2_24) then
			local var3_24, var4_24, var5_24 = var2_24:GetComponent(typeof(HolyLightController)):GetScreenShotInfo(nil, nil)

			if var3_24 then
				table.insert(var0_24, var4_24)
				table.insert(var1_24, var5_24)
			end
		end
	end

	return var1_24, var0_24
end

function var0_0.HideCharacterPart(arg0_25, arg1_25, arg2_25)
	local var0_25 = var0_0.GetSkinIdByModelName(arg0_25.name)

	warning("HideCharacterPart skinId", var0_25)

	if not var0_25 then
		return
	end

	local var1_25 = Dorm3dSkin.New({
		configId = var0_25
	})

	if arg2_25 and not var1_25:ShouldApplyHiddenPartInTimeline() then
		return
	end

	local var2_25 = var1_25:GetGroupId()

	arg1_25 = arg1_25 or getProxy(ApartmentProxy):getApartment(var2_25):GetHiddenParts(var0_25)

	local var3_25, var4_25 = var1_25:GetActiveAndHiddenPartNames(arg1_25)

	_.each(var3_25, function(arg0_26)
		setActive(arg0_25:Find(arg0_26), true)
	end)
	_.each(var4_25, function(arg0_27)
		setActive(arg0_25:Find(arg0_27), false)
	end)
end

return var0_0

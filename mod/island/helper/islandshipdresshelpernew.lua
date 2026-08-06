local var0_0 = class("IslandShipDressHelperNew")

var0_0.DressType = {
	Flotage = 2,
	Face = 5,
	Hat = 7,
	Body = 6,
	Footprint = 3,
	BackDecorate = 1,
	Hair = 4
}
var0_0.CommanderCustom = {
	var0_0.DressType.Hair,
	var0_0.DressType.Face,
	var0_0.DressType.Body,
	var0_0.DressType.Hat
}
var0_0.ExtraDressType = {
	var0_0.DressType.BackDecorate,
	var0_0.DressType.Flotage,
	var0_0.DressType.Footprint
}
var0_0.ComponentType = {
	Body = 1,
	Face = 2,
	Hair = 3,
	Headware = 4
}
var0_0.DressType2ComponentType = {
	[var0_0.DressType.Body] = var0_0.ComponentType.Body,
	[var0_0.DressType.Face] = var0_0.ComponentType.Face,
	[var0_0.DressType.Hair] = var0_0.ComponentType.Hair,
	[var0_0.DressType.Hat] = var0_0.ComponentType.Headware
}

function var0_0.Ctor(arg0_1, arg1_1)
	if arg1_1 then
		arg0_1.curIsland = arg1_1
		arg0_1.isOtherIsland = getProxy(PlayerProxy):getRawData().id ~= arg0_1.curIsland.id
	end

	arg0_1.gcCnt = 0
end

function var0_0.GetInitDressByType(arg0_2)
	local function var0_2(arg0_3)
		local var0_3 = pg.island_set.default_dress.key_value_varchar

		for iter0_3, iter1_3 in ipairs(var0_3) do
			if pg.island_dress_template[iter1_3].type == arg0_3 then
				return iter1_3
			end
		end

		return 0
	end

	if arg0_2 == var0_0.DressType.Hat then
		local var1_2 = var0_2(var0_0.DressType.Body)

		return pg.island_dress_template.get_id_list_by_related_dress[var1_2][1]
	end

	return var0_2(arg0_2)
end

function var0_0.PreLoadVisterDressupItem(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	arg0_4.roleTF = arg1_4.transform
	arg0_4.isScene = true
	arg0_4.shipId = 0
	arg0_4.playerId = arg2_4
	arg0_4.hasTF = true
	arg0_4.currentDressDataDic = {}
	arg0_4.pageDressTFDic = {}

	local var0_4 = {
		var0_0.DressType.BackDecorate,
		var0_0.DressType.Flotage,
		var0_0.DressType.Footprint
	}
	local var1_4 = arg3_4 and getProxy(IslandProxy):GetIsland() or getProxy(IslandProxy):GetSharedIsland()
	local var2_4 = var1_4:GetVisitorAgency():GetPlayer(arg0_4.playerId)
	local var3_4 = 0

	for iter0_4, iter1_4 in ipairs(var0_4) do
		local var4_4 = var2_4:GetDressByType(iter1_4)

		if var4_4 and var4_4 ~= 0 then
			local var5_4 = {
				id = var4_4
			}

			var5_4.colorId = 0
			arg0_4.currentDressDataDic[iter1_4] = var5_4
			var3_4 = var3_4 + 1
		end
	end

	arg0_4:InitVisterCustomDressData(arg2_4, var1_4)

	if var3_4 == 0 then
		arg4_4()

		return
	end

	local var6_4 = 0

	for iter2_4, iter3_4 in pairs(arg0_4.currentDressDataDic) do
		arg0_4:LoadDressObjectItem(iter2_4, iter3_4.id, function()
			var6_4 = var6_4 + 1

			if var6_4 == var3_4 then
				arg4_4()
			end
		end)
	end
end

function var0_0.InitVisterCustomDressData(arg0_6, arg1_6, arg2_6)
	arg0_6.commanderDressDic = {}

	local var0_6 = arg2_6:GetVisitorAgency():GetPlayer(arg0_6.playerId)

	for iter0_6, iter1_6 in pairs(var0_0.CommanderCustom) do
		local var1_6 = var0_6:GetDressByType(iter1_6)

		if var1_6 then
			arg0_6.commanderDressDic[iter1_6] = var1_6
		end
	end
end

function var0_0.PreLoadShipDressupItem(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7.roleTF = arg1_7.transform
	arg0_7.isScene = true
	arg0_7.shipId = arg2_7
	arg0_7.hasTF = true
	arg0_7.currentDressDataDic = {}
	arg0_7.pageDressTFDic = {}

	local var0_7 = {
		var0_0.DressType.BackDecorate,
		var0_0.DressType.Flotage,
		var0_0.DressType.Footprint
	}
	local var1_7 = getProxy(IslandProxy):GetIsland()

	if arg0_7.shipId == 0 then
		local var2_7 = var1_7:GetDressUpAgency()
		local var3_7 = 0

		for iter0_7, iter1_7 in ipairs(var0_7) do
			local var4_7 = var2_7:GetDressByType(iter1_7)

			if var4_7 and var4_7 ~= 0 then
				local var5_7 = {
					id = var4_7
				}

				var5_7.colorId = 0
				arg0_7.currentDressDataDic[iter1_7] = var5_7
				var3_7 = var3_7 + 1
			end
		end

		arg0_7:InitCommanderCustomDressData()

		if var3_7 == 0 then
			arg3_7()

			return
		end

		local var6_7 = 0

		for iter2_7, iter3_7 in pairs(arg0_7.currentDressDataDic) do
			arg0_7:LoadDressObjectItem(iter2_7, iter3_7.id, function()
				var6_7 = var6_7 + 1

				if var6_7 == var3_7 then
					arg3_7()
				end
			end)
		end
	else
		if arg0_7.isOtherIsland then
			arg3_7()

			return
		end

		local var7_7 = var1_7:GetCharacterAgency()

		arg0_7.modelData = var7_7:GetShipById(arg0_7.shipId):GetModel()

		local var8_7 = 0

		for iter4_7, iter5_7 in pairs(var0_7) do
			local var9_7 = var7_7:GetCurDressIdByShipId(arg0_7.shipId, iter5_7)

			if var9_7 then
				local var10_7 = {
					id = var9_7.dress_id
				}

				var10_7.colorId = 0
				arg0_7.currentDressDataDic[iter5_7] = var10_7
				var8_7 = var8_7 + 1
			end
		end

		if var8_7 == 0 then
			arg3_7()

			return
		end

		local var11_7 = 0

		for iter6_7, iter7_7 in pairs(arg0_7.currentDressDataDic) do
			arg0_7:LoadDressObjectItem(iter6_7, iter7_7.id, function()
				var11_7 = var11_7 + 1

				if var11_7 == var8_7 then
					arg3_7()
				end
			end)
		end
	end
end

function var0_0.SetShipId(arg0_10, arg1_10)
	arg0_10.shipId = arg1_10
	arg0_10.hasTF = false
	arg0_10.currentDressDataDic = {}
	arg0_10.dataAfterRoleInit = {}

	arg0_10:RemoveDressTF()
	arg0_10:InitDressData()
end

function var0_0.InitCommanderCustomDressData(arg0_11)
	arg0_11.commanderDressDic = {}

	local var0_11 = getProxy(IslandProxy):GetIsland():GetDressUpAgency()

	for iter0_11, iter1_11 in pairs(var0_0.CommanderCustom) do
		local var1_11 = var0_11:GetDressByType(iter1_11)

		if var1_11 then
			arg0_11.commanderDressDic[iter1_11] = var1_11
		end
	end
end

function var0_0.InitDressData(arg0_12)
	local var0_12 = {
		var0_0.DressType.BackDecorate,
		var0_0.DressType.Flotage,
		var0_0.DressType.Footprint
	}
	local var1_12 = getProxy(IslandProxy):GetIsland()

	if arg0_12.shipId == 0 then
		local var2_12 = var1_12:GetDressUpAgency()

		for iter0_12, iter1_12 in pairs(var0_12) do
			local var3_12 = var2_12:GetDressByType(iter1_12)

			if var3_12 then
				local var4_12 = {
					id = var3_12
				}

				var4_12.colorId = 0
				arg0_12.dataAfterRoleInit[iter1_12] = var4_12
			end
		end

		arg0_12:InitCommanderCustomDressData()
	else
		local var5_12 = var1_12:GetCharacterAgency()

		for iter2_12, iter3_12 in pairs(var0_12) do
			local var6_12 = var5_12:GetCurDressIdByShipId(arg0_12.shipId, iter3_12)

			if var6_12 then
				local var7_12 = {
					id = var6_12.dress_id
				}

				var7_12.colorId = 0
				arg0_12.dataAfterRoleInit[iter3_12] = var7_12
			end
		end
	end
end

function var0_0.InitDressTF(arg0_13, arg1_13)
	for iter0_13, iter1_13 in pairs(arg0_13.dataAfterRoleInit) do
		arg0_13:ChangeDressByType(iter0_13, iter1_13, arg1_13)
	end

	arg0_13.dataAfterRoleInit = {}
end

function var0_0.OnRoleLoaded(arg0_14, arg1_14, arg2_14, arg3_14)
	arg0_14.modelData = arg2_14
	arg0_14.roleTF = arg1_14
	arg0_14.hasTF = true
	arg0_14.commanderPartTokens = {}

	arg0_14:InitDressTF(arg3_14)
end

function var0_0.IsRoleValid(arg0_15, arg1_15)
	if not arg0_15.hasTF then
		return false
	end

	if not arg0_15.roleTF or IsNil(arg0_15.roleTF) or arg0_15.roleTF.childCount <= 0 then
		return false
	end

	if arg1_15 and IsNil(arg1_15) then
		return false
	end

	return true
end

function var0_0.ResetFootprint(arg0_16)
	if not arg0_16.roleTF or IsNil(arg0_16.roleTF) then
		return
	end

	local var0_16 = arg0_16.roleTF:GetComponent(typeof(CharacterFootprintMgr))

	if var0_16 then
		var0_16:ResetFootprint()
	end
end

function var0_0.RemoveDressTF(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.pageDressTFDic or {}) do
		Object.Destroy(iter1_17.gameObject)
	end

	arg0_17.pageDressTFDic = {}

	arg0_17:ResetFootprint()
end

function var0_0.ChangeCommanderPartColor(arg0_18, arg1_18, arg2_18)
	local var0_18 = var0_0.DressType2ComponentType[arg1_18]

	if not var0_18 then
		return
	end

	if not arg0_18:IsRoleValid() then
		return
	end

	if arg2_18 == 0 then
		GraphicsInterface.Instance:ResetCharacterComponentMaterialData(arg0_18.roleTF:GetChild(0).gameObject, var0_18)
	else
		local var1_18 = pg.island_dress_colordiff_template[arg2_18].model

		GraphicsInterface.Instance:SetCharacterComponentMaterialData(arg0_18.roleTF:GetChild(0).gameObject, var1_18)
	end
end

function var0_0.SetCommanderHairBlendShape(arg0_19, arg1_19)
	if not arg1_19 or arg1_19 == 0 then
		GraphicsInterface.Instance:SetCharacterBlendShape(arg0_19, var0_0.ComponentType.Hair, 0, 0)
		GraphicsInterface.Instance:SetCharacterBlendShape(arg0_19, var0_0.ComponentType.Hair, 1, 0)

		return
	end

	local var0_19 = pg.island_dress_template[arg1_19]

	if not var0_19 then
		return
	end

	local var1_19 = var0_19.sub_type - 1

	GraphicsInterface.Instance:SetCharacterBlendShape(arg0_19, var0_0.ComponentType.Hair, var1_19, 100)
	GraphicsInterface.Instance:SetCharacterBlendShape(arg0_19, var0_0.ComponentType.Hair, 1 - var1_19, 0)
end

function var0_0.SetCommanderHairAndFaceShow(arg0_20, arg1_20)
	GraphicsInterface.Instance:SetCharacterComponentShow(arg0_20, var0_0.ComponentType.Hair, arg1_20)
	GraphicsInterface.Instance:SetCharacterComponentShow(arg0_20, var0_0.ComponentType.Face, arg1_20)
end

function var0_0.RefreshCommanderHatState(arg0_21, arg1_21)
	var0_0.SetCommanderHairBlendShape(arg0_21, arg1_21)

	local var0_21 = true

	if arg1_21 and arg1_21 ~= 0 then
		local var1_21 = pg.island_dress_template[arg1_21]

		var0_21 = not var1_21 or var1_21.head_hide ~= 1
	end

	var0_0.SetCommanderHairAndFaceShow(arg0_21, var0_21)
end

function var0_0.LoadCommanderComponent(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = pg.island_dress_template[arg1_22]

	if not var0_22 then
		existCall(arg3_22)

		return
	end

	local var1_22 = var0_22.model

	if arg2_22 == 0 or arg2_22 == nil then
		GraphicsInterface.Instance:LoadCharacterComponent(arg0_22, var1_22, arg3_22)
	else
		local var2_22 = pg.island_dress_colordiff_template[arg2_22].model

		GraphicsInterface.Instance:LoadCharacterComponentAndMaterial(arg0_22, var1_22, var2_22, arg3_22)
	end
end

function var0_0.LoadCommanderBaseAnimator(arg0_23)
	if var0_0.CommanderBaseRuntimeController then
		existCall(arg0_23, var0_0.CommanderBaseRuntimeController)

		return
	end

	local var0_23 = pg.island_unit_character[0]
	local var1_23 = var0_23 and var0_23.animator or ""

	if var1_23 == "" then
		existCall(arg0_23)

		return
	end

	IslandAssetLoadDispatcher.Instance:Enqueue(var1_23, "", typeof(RuntimeAnimatorController), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_24)
		var0_0.CommanderBaseRuntimeController = arg0_24

		existCall(arg0_23, arg0_24)
	end), true, true)
end

function var0_0.BuildCommanderCustomParts(arg0_25, arg1_25, arg2_25, arg3_25)
	local var0_25
	local var1_25 = 0

	local function var2_25()
		var1_25 = var1_25 + 1

		if var1_25 == #var0_0.CommanderCustom then
			local var0_26 = arg1_25(var0_0.DressType.Hat) or 0
			local var1_26 = arg1_25(var0_0.DressType.Body) or 0

			var0_0.RefreshCommanderHatState(arg0_25, var0_26)
			existCall(arg3_25, var0_25, var1_26)
		end
	end

	for iter0_25, iter1_25 in ipairs(var0_0.CommanderCustom) do
		local var3_25 = arg1_25(iter1_25) or 0

		if var3_25 == 0 then
			if iter1_25 == var0_0.DressType.Hat then
				GraphicsInterface.Instance:SetCharacterComponentShow(arg0_25, var0_0.ComponentType.Headware, false, var2_25)
			else
				var2_25()
			end
		else
			local var4_25 = pg.island_dress_template[var3_25]

			if var4_25 and var4_25.face_clip ~= "" then
				var0_25 = var4_25.face_clip
			end

			local var5_25 = arg2_25 and arg2_25(var3_25) or 0

			var0_0.LoadCommanderComponent(arg0_25, var3_25, var5_25, var2_25)
		end
	end
end

function var0_0.ChangeCommanderPart(arg0_27, arg1_27, arg2_27, arg3_27)
	if not arg0_27:IsRoleValid() then
		existCall(arg3_27)

		return
	end

	local var0_27 = arg2_27.id
	local var1_27 = arg2_27.colorId
	local var2_27 = arg0_27.roleTF:GetChild(0).gameObject

	arg0_27.commanderPartTokens = arg0_27.commanderPartTokens or {}
	arg0_27.commanderPartTokens[arg1_27] = (arg0_27.commanderPartTokens[arg1_27] or 0) + 1

	local var3_27 = arg0_27.commanderPartTokens[arg1_27]

	arg0_27.commanderDressDic[arg1_27] = var0_27

	local function var4_27()
		if var3_27 ~= (arg0_27.commanderPartTokens and arg0_27.commanderPartTokens[arg1_27] or 0) or not arg0_27:IsRoleValid(var2_27) then
			existCall(arg3_27)

			return
		end

		if arg1_27 == var0_0.DressType.Hat then
			arg0_27:ChangeCommanderPartShow(arg1_27, true)
			var0_0.RefreshCommanderHatState(var2_27, var0_27)
		elseif arg1_27 == var0_0.DressType.Hair then
			var0_0.RefreshCommanderHatState(var2_27, arg0_27.commanderDressDic[var0_0.DressType.Hat] or 0)
		elseif arg1_27 == var0_0.DressType.Face then
			local var0_28 = pg.island_dress_template[var0_27]
			local var1_28 = var0_28.face_clip == "" and "idle" or var0_28.face_clip
			local var2_28 = var2_27:GetComponent(typeof(Animator))

			if var2_28 and not IsNil(var2_28) then
				var2_28:Play(var1_28, 4)
			end
		elseif arg1_27 == var0_0.DressType.Body then
			arg0_27:ApplyAnimatorOverride(var0_27, arg3_27)
		end
	end

	if var0_27 ~= 0 then
		var0_0.LoadCommanderComponent(var2_27, var0_27, var1_27, var4_27)
	end

	if arg1_27 == var0_0.DressType.Hat then
		if var0_27 == 0 then
			arg0_27:ChangeCommanderPartShow(arg1_27, false)
			var0_0.RefreshCommanderHatState(var2_27, 0)
			existCall(arg3_27)
		end
	elseif arg1_27 == var0_0.DressType.Body and var0_27 == 0 then
		arg0_27:ApplyAnimatorOverride(0, arg3_27)
	end
end

function var0_0.LoadDressObjectItem(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = pg.island_dress_template[arg2_29]
	local var1_29 = var0_29.model
	local var2_29 = arg0_29.shipId
	local var3_29 = IslandAssetLoadDispatcher.Instance:Enqueue(var1_29, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_30)
		if IsNil(arg0_29.roleTF) then
			return
		end

		if arg0_29.hasTF == false then
			return
		end

		local var0_30 = arg0_29.currentDressDataDic[arg1_29]

		if not var0_30 then
			return
		end

		if var2_29 ~= arg0_29.shipId then
			return
		end

		if var0_30.id ~= arg2_29 then
			return
		end

		if arg1_29 == var0_0.DressType.Footprint then
			local var1_30 = GetOrAddComponent(arg0_29.roleTF, typeof(CharacterFootprintMgr))
			local var2_30 = Vector3(0, 0, 0)

			if var0_29.offset ~= "" then
				var2_30 = Vector3(var0_29.offset[1], var0_29.offset[2], var0_29.offset[3])
			end

			var1_30:SetFootprintPrefab(var0_29.footprint_type, arg0_30, var2_30)
			existCall(arg3_29)

			return
		end

		local var3_30 = Object.Instantiate(arg0_30)
		local var4_30 = arg0_29.isScene and Layer.Default or Layer.Character3D

		pg.ViewUtils.SetLayer(var3_30.transform, var4_30)
		switch(arg1_29, {
			[var0_0.DressType.BackDecorate] = function()
				local var0_31 = arg0_29.roleTF.transform

				if var0_29.attachmentPoint ~= "" then
					local var1_31 = var0_29.attachmentPoint

					local function var2_31(arg0_32)
						for iter0_32 = 0, arg0_32.childCount - 1 do
							local var0_32 = arg0_32:GetChild(iter0_32)

							if var0_32.name == var1_31 then
								return var0_32
							end

							local var1_32 = var2_31(var0_32, var1_31)

							if var1_32 then
								return var1_32
							end
						end

						return nil
					end

					var0_31 = var2_31(var0_31)
				end

				if var0_29.offset ~= "" then
					local var3_31 = Vector3(var0_29.offset[1], var0_29.offset[2], var0_29.offset[3])

					var3_30.transform.localPosition = var3_31
				end

				if var0_29.rotation ~= "" then
					local var4_31 = Quaternion.Euler(var0_29.rotation[1], var0_29.rotation[2], var0_29.rotation[3])

					var3_30.transform.rotation = var4_31
				end

				if var0_29.scale ~= "" then
					local var5_31 = Vector3(var0_29.scale[1], var0_29.scale[1], var0_29.scale[1])

					var3_30.transform.localScale = var5_31
				end

				setParent(var3_30, var0_31)
			end,
			[var0_0.DressType.Flotage] = function()
				local var0_33

				if var0_29.offset ~= "" then
					var0_33 = Vector3(var0_29.offset[1], var0_29.offset[2], var0_29.offset[3])

					local var1_33 = var3_30.name
					local var2_33 = GameObject.New(var1_33)

					setParent(var3_30.transform, var2_33.transform, false)

					var3_30 = var2_33
					var3_30.transform.position = arg0_29.roleTF:GetChild(0).transform:TransformPoint(var0_33)
				end

				if var0_29.scale ~= "" then
					local var3_33 = Vector3(var0_29.scale[1], var0_29.scale[1], var0_29.scale[1])

					var3_30.transform.localScale = var3_33
				end

				local var4_33 = Vector3(0, 0, 0)

				if var0_29.rotation ~= "" then
					var4_33 = Vector3(var0_29.rotation[1], var0_29.rotation[2], var0_29.rotation[3])
				end

				var3_30.transform.rotation = var4_33

				local var5_33 = GetOrAddComponent(var3_30, typeof(DressFlow))
				local var6_33 = pg.island_set.island_dress_follow_param.key_value_varchar

				var5_33.target = arg0_29.roleTF
				var5_33.delayTime = var6_33[1]
				var5_33.lerpSpeed = var6_33[2]
				var5_33.recordInterval = var6_33[3]

				if not not var0_33 then
					var5_33.offset = var0_33
				end

				if not not var4_33 then
					var5_33.rotationOffest = var4_33
				end
			end
		})

		arg0_29.pageDressTFDic[arg2_29] = var3_30

		existCall(arg3_29, var3_30)
	end), true, true)

	table.insert(arg0_29.loadingIdList or {}, var3_29)
end

function var0_0.ChangeDressObject(arg0_34, arg1_34, arg2_34, arg3_34)
	local var0_34 = arg2_34.id
	local var1_34 = arg0_34.currentDressDataDic[arg1_34] and arg0_34.currentDressDataDic[arg1_34].id or 0

	if var1_34 then
		if var1_34 == var0_34 then
			return
		end

		if var1_34 ~= 0 then
			if arg1_34 == var0_0.DressType.Footprint then
				arg0_34:ResetFootprint()
			else
				local var2_34 = arg0_34.pageDressTFDic[var1_34]

				if var2_34 then
					Object.Destroy(var2_34)

					arg0_34.pageDressTFDic[var1_34] = nil
				end
			end

			arg0_34.currentDressDataDic[arg1_34] = nil
		end
	end

	if var0_34 == 0 then
		return
	end

	arg0_34.currentDressDataDic[arg1_34] = arg2_34

	arg0_34:LoadDressObjectItem(arg1_34, var0_34, arg3_34)
end

function var0_0.ChangeDressByType(arg0_35, arg1_35, arg2_35, arg3_35)
	if not arg0_35.hasTF then
		arg0_35.dataAfterRoleInit[arg1_35] = arg2_35

		return
	end

	if table.contains(var0_0.CommanderCustom, arg1_35) then
		arg0_35:ChangeCommanderPart(arg1_35, arg2_35, arg3_35)
	else
		arg0_35:ChangeDressObject(arg1_35, arg2_35, arg3_35)
	end
end

function var0_0.ChangeCommanderPartShow(arg0_36, arg1_36, arg2_36)
	if not arg0_36.hasTF then
		return
	end

	if not arg0_36:IsRoleValid() then
		return
	end

	GraphicsInterface.Instance:SetCharacterComponentShow(arg0_36.roleTF:GetChild(0).gameObject, var0_0.ComponentType.Headware, arg2_36)
end

function var0_0.ChangeModelTransfromByUnitId(arg0_37, arg1_37, arg2_37, arg3_37)
	arg0_37.gcCnt = arg0_37.gcCnt + 1

	local var0_37 = pg.island_unit_character[arg1_37]

	arg0_37.hasTF = false
	arg0_37.commanderPartTokens = {}
	arg0_37.animatorOverrideToken = (arg0_37.animatorOverrideToken or 0) + 1

	arg0_37:StopMorphSwitch()
	arg0_37:RemoveDressTF()

	arg0_37.dataAfterRoleInit = arg0_37.currentDressDataDic
	arg0_37.currentDressDataDic = {}

	local var1_37 = arg0_37.roleTF:GetChild(0).gameObject

	pg.UIMgr.GetInstance():LoadingOn()
	_IslandCore:GetPoolMgr():ReturnCharacterModel(arg0_37.modelData.model, arg0_37.modelData.animator, var1_37, true)

	arg0_37.modelData = {
		model = var0_37.model,
		animator = var0_37.animator,
		personal_ani = var0_37.personal_ani
	}

	_IslandCore:GetPoolMgr():GetCharacterModel(arg0_37.modelData.model, arg0_37.modelData.animator, function(arg0_38)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_37.hasTF = true

		local var0_38 = arg0_37.isScene and Layer.Default or Layer.Character3D

		pg.ViewUtils.SetLayer(arg0_38.transform, var0_38)
		setParent(arg0_38.transform, arg0_37.roleTF, false)
		arg0_37:InitDressTF()

		if arg3_37 then
			local var1_38 = arg0_37.modelData.personal_ani

			if var1_38 and var1_38 ~= "" then
				local var2_38 = GetOrAddComponent(arg0_37.roleTF.transform:GetChild(0), typeof(Animator))

				for iter0_38 = 1, var2_38.layerCount do
					var2_38:CrossFadeInFixedTime(var1_38, 0, iter0_38 - 1)
				end
			end
		end

		existCall(arg2_37, arg0_37.roleTF)
	end, true)

	if arg0_37.gcCnt >= 5 then
		arg0_37.gcCnt = 0

		IslandHelper.RunGC(true)
	end
end

function var0_0.ChangeModelTransfromByUnitIdAndChangeDress(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39, arg5_39)
	local var0_39 = pg.island_unit_character[arg1_39]

	arg0_39.hasTF = false
	arg0_39.commanderPartTokens = {}
	arg0_39.animatorOverrideToken = (arg0_39.animatorOverrideToken or 0) + 1

	arg0_39:StopMorphSwitch()
	arg0_39:RemoveDressTF()

	arg0_39.dataAfterRoleInit = arg0_39.currentDressDataDic

	for iter0_39, iter1_39 in ipairs(arg2_39 or {}) do
		local var1_39 = pg.island_dress_template[iter1_39].type

		if arg0_39.dataAfterRoleInit[var1_39].id == iter1_39 then
			arg0_39.dataAfterRoleInit[var1_39] = nil
		end
	end

	for iter2_39, iter3_39 in ipairs(arg3_39 or {}) do
		local var2_39 = pg.island_dress_template[iter3_39].type

		arg0_39.dataAfterRoleInit[var2_39] = {
			colorId = 0,
			id = iter3_39
		}
	end

	arg0_39.currentDressDataDic = {}

	local var3_39 = arg0_39.roleTF:GetChild(0).gameObject

	_IslandCore:GetPoolMgr():ReturnCharacterModel(arg0_39.modelData.model, arg0_39.modelData.animator, var3_39, true)

	arg0_39.modelData = {
		model = var0_39.model,
		animator = var0_39.animator,
		personal_ani = var0_39.personal_ani
	}

	_IslandCore:GetPoolMgr():GetCharacterModel(arg0_39.modelData.model, arg0_39.modelData.animator, function(arg0_40)
		arg0_39.hasTF = true

		local var0_40 = arg0_39.isScene and Layer.Default or Layer.Character3D

		pg.ViewUtils.SetLayer(arg0_40.transform, var0_40)
		setParent(arg0_40.transform, arg0_39.roleTF, false)
		arg0_39:InitDressTF()

		if arg5_39 then
			local var1_40 = arg0_39.modelData.personal_ani

			if var1_40 and var1_40 ~= "" then
				local var2_40 = GetOrAddComponent(arg0_39.roleTF.transform:GetChild(0), typeof(Animator))

				for iter0_40 = 1, var2_40.layerCount do
					var2_40:CrossFadeInFixedTime(var1_40, 0, iter0_40 - 1)
				end
			end
		end

		existCall(arg4_39, arg0_39.roleTF)
	end, true)
end

function var0_0.ApplyAnimatorOverride(arg0_41, arg1_41, arg2_41)
	if not arg0_41.hasTF then
		existCall(arg2_41)

		return
	end

	if IsNil(arg0_41.roleTF) then
		existCall(arg2_41)

		return
	end

	if not arg0_41.roleTF:GetChild(0).gameObject:GetComponent(typeof(Animator)) then
		existCall(arg2_41)

		return
	end

	arg0_41.animatorOverrideToken = (arg0_41.animatorOverrideToken or 0) + 1

	local var0_41 = arg0_41.animatorOverrideToken
	local var1_41 = arg1_41 ~= 0 and pg.island_dress_template[arg1_41] or nil
	local var2_41 = var1_41 and var1_41.special_animator or ""

	if var2_41 == "" then
		var0_0.LoadCommanderBaseAnimator(function(arg0_42)
			if IsNil(arg0_41.roleTF) then
				existCall(arg2_41)

				return
			end

			if not arg0_41.hasTF then
				existCall(arg2_41)

				return
			end

			if var0_41 ~= arg0_41.animatorOverrideToken then
				existCall(arg2_41)

				return
			end

			local var0_42 = arg0_41.roleTF:GetChild(0).gameObject:GetComponent(typeof(Animator))

			if var0_42 and not IsNil(var0_42) and arg0_42 then
				var0_42.runtimeAnimatorController = arg0_42

				var0_42:Rebind()
				var0_42:Update(0)
				var0_42:Play("idle", 4)
			end

			existCall(arg2_41)
		end)

		return
	end

	IslandAssetLoadDispatcher.Instance:Enqueue(var2_41, "", typeof(UnityEngine.RuntimeAnimatorController), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_43)
		if IsNil(arg0_41.roleTF) then
			existCall(arg2_41)

			return
		end

		if not arg0_41.hasTF then
			existCall(arg2_41)

			return
		end

		if var0_41 ~= arg0_41.animatorOverrideToken then
			existCall(arg2_41)

			return
		end

		local var0_43 = arg0_41.roleTF:GetChild(0).gameObject:GetComponent(typeof(Animator))

		if var0_43 and not IsNil(var0_43) then
			var0_43.runtimeAnimatorController = arg0_43
		end

		existCall(arg2_41)
	end), true, true)
end

function var0_0.Destroy(arg0_44)
	arg0_44.curIsland = nil
	arg0_44.hasTF = false
	arg0_44.commanderPartTokens = {}
	arg0_44.animatorOverrideToken = (arg0_44.animatorOverrideToken or 0) + 1

	arg0_44:StopMorphSwitch()
	arg0_44:RemoveDressTF()

	for iter0_44, iter1_44 in ipairs(arg0_44.loadingIdList or {}) do
		IslandAssetLoadDispatcher.Instance:Cancel(iter1_44)
	end

	arg0_44.loadingIdList = nil
	arg0_44.roleTF = nil
end

function var0_0.InvalidateRole(arg0_45)
	arg0_45.hasTF = false
	arg0_45.commanderPartTokens = {}
	arg0_45.animatorOverrideToken = (arg0_45.animatorOverrideToken or 0) + 1

	arg0_45:StopMorphSwitch()

	arg0_45.roleTF = nil
end

function var0_0.ResetDressUp(arg0_46)
	local var0_46 = getProxy(IslandProxy):GetIsland()

	if arg0_46.shipId == 0 then
		local var1_46 = {
			var0_0.DressType.BackDecorate,
			var0_0.DressType.Flotage,
			var0_0.DressType.Footprint
		}
		local var2_46 = var0_46:GetDressUpAgency()

		for iter0_46, iter1_46 in ipairs(var1_46) do
			local var3_46 = var2_46:GetDressByType(iter1_46) or 0
			local var4_46 = 0

			arg0_46:ChangeDressByType(iter1_46, {
				id = var3_46,
				colorId = var4_46
			})
		end
	else
		local var5_46 = var0_46:GetCharacterAgency()
		local var6_46 = {
			var0_0.DressType.BackDecorate,
			var0_0.DressType.Flotage,
			var0_0.DressType.Footprint
		}

		for iter2_46, iter3_46 in ipairs(var6_46) do
			local var7_46 = var5_46:GetCurDressIdByShipId(arg0_46.shipId, iter3_46) or {}

			arg0_46:ChangeDressByType(iter3_46, {
				colorId = 0,
				id = var7_46.dress_id or 0
			})
		end
	end
end

function var0_0.DoMorphSwitch(arg0_47, arg1_47, arg2_47, arg3_47)
	local var0_47 = arg0_47.roleTF
	local var1_47 = var0_47 and var0_47.childCount > 0 and var0_47:GetChild(0)
	local var2_47 = var1_47 and var1_47.gameObject:GetComponent(typeof(Animator))

	if not var2_47 then
		existCall(arg3_47)

		return
	end

	arg0_47:StopMorphSwitch()

	local var3_47 = pg.island_dress_template[arg1_47].cut_out_state

	arg0_47.morphTimer = var0_0.PlayMorphAndWait(var2_47, var3_47, arg1_47, function()
		arg0_47.morphTimer = nil

		existCall(arg3_47, arg2_47)
	end)
end

function var0_0.StopMorphSwitch(arg0_49)
	if arg0_49.morphTimer then
		arg0_49.morphTimer:Stop()

		arg0_49.morphTimer = nil
	end
end

function var0_0.PlayMorphAndWait(arg0_50, arg1_50, arg2_50, arg3_50)
	for iter0_50 = 1, arg0_50.layerCount do
		arg0_50:CrossFadeInFixedTime(arg1_50, 0, iter0_50 - 1)
	end

	local var0_50 = pg.island_dress_template[arg2_50]
	local var1_50 = (var0_50 and var0_50.morph_wait_frames or 30) / 30 + 0.2
	local var2_50 = false
	local var3_50 = false
	local var4_50 = false
	local var5_50
	local var6_50

	local function var7_50()
		if var3_50 then
			return
		end

		if var2_50 then
			return
		end

		var2_50 = true

		if var5_50 then
			var5_50:Stop()

			var5_50 = nil
		end

		if var6_50 then
			var6_50:Stop()

			var6_50 = nil
		end

		existCall(arg3_50)
	end

	local function var8_50()
		if var2_50 then
			return
		end

		var3_50 = true
		var2_50 = true

		if var5_50 then
			var5_50:Stop()

			var5_50 = nil
		end

		if var6_50 then
			var6_50:Stop()

			var6_50 = nil
		end
	end

	var5_50 = FrameTimer.New(function()
		if IsNil(arg0_50) then
			var7_50()

			return
		end

		if arg0_50:IsInTransition(0) then
			return
		end

		local var0_53 = arg0_50:GetCurrentAnimatorStateInfo(0)

		if var0_53:IsName(arg1_50) then
			var4_50 = true
		end

		if var4_50 and var0_53.normalizedTime >= 1 then
			var7_50()
		end
	end, 1, -1)

	var5_50:Start()

	var6_50 = Timer.New(var7_50, var1_50, 1)

	var6_50:Start()

	return {
		Stop = var8_50
	}
end

return var0_0

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

function var0_0.GetInitDressByType(arg0_1)
	local function var0_1(arg0_2)
		local var0_2 = pg.island_set.default_dress.key_value_varchar

		for iter0_2, iter1_2 in ipairs(var0_2) do
			if pg.island_dress_template[iter1_2].type == arg0_2 then
				return iter1_2
			end
		end

		return 0
	end

	if arg0_1 == var0_0.DressType.Hat then
		local var1_1 = var0_1(var0_0.DressType.Body)

		return pg.island_dress_template.get_id_list_by_related_dress[var1_1][1]
	end

	return var0_1(arg0_1)
end

function var0_0.PreLoadVisterDressupItem(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	arg0_3.roleTF = arg1_3.transform
	arg0_3.isScene = true
	arg0_3.shipId = 0
	arg0_3.playerId = arg2_3
	arg0_3.hasTF = true
	arg0_3.currentDressDataDic = {}
	arg0_3.pageDressTFDic = {}

	local var0_3 = {
		var0_0.DressType.BackDecorate,
		var0_0.DressType.Flotage,
		var0_0.DressType.Footprint
	}
	local var1_3 = arg3_3 and getProxy(IslandProxy):GetIsland() or getProxy(IslandProxy):GetSharedIsland()
	local var2_3 = var1_3:GetVisitorAgency():GetPlayer(arg0_3.playerId)
	local var3_3 = 0

	for iter0_3, iter1_3 in ipairs(var0_3) do
		local var4_3 = var2_3:GetDressByType(iter1_3)

		if var4_3 and var4_3 ~= 0 then
			local var5_3 = {
				id = var4_3
			}

			var5_3.colorId = 0
			arg0_3.currentDressDataDic[iter1_3] = var5_3
			var3_3 = var3_3 + 1
		end
	end

	arg0_3:InitVisterCustomDressData(arg2_3, var1_3)

	if var3_3 == 0 then
		arg4_3()

		return
	end

	local var6_3 = 0

	for iter2_3, iter3_3 in pairs(arg0_3.currentDressDataDic) do
		arg0_3:LoadDressObjectItem(iter2_3, iter3_3.id, function()
			var6_3 = var6_3 + 1

			if var6_3 == var3_3 then
				arg4_3()
			end
		end)
	end
end

function var0_0.InitVisterCustomDressData(arg0_5, arg1_5, arg2_5)
	arg0_5.commanderDressDic = {}

	local var0_5 = arg2_5:GetVisitorAgency():GetPlayer(arg0_5.playerId)

	for iter0_5, iter1_5 in pairs(var0_0.CommanderCustom) do
		local var1_5 = var0_5:GetDressByType(iter1_5)

		if var1_5 then
			arg0_5.commanderDressDic[iter1_5] = var1_5
		end
	end
end

function var0_0.PreLoadShipDressupItem(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6.roleTF = arg1_6.transform
	arg0_6.isScene = true
	arg0_6.shipId = arg2_6
	arg0_6.hasTF = true
	arg0_6.currentDressDataDic = {}
	arg0_6.pageDressTFDic = {}

	local var0_6 = {
		var0_0.DressType.BackDecorate,
		var0_0.DressType.Flotage,
		var0_0.DressType.Footprint
	}
	local var1_6 = getProxy(IslandProxy):GetIsland()

	if arg0_6.shipId == 0 then
		local var2_6 = var1_6:GetDressUpAgency()
		local var3_6 = 0

		for iter0_6, iter1_6 in ipairs(var0_6) do
			local var4_6 = var2_6:GetDressByType(iter1_6)

			if var4_6 and var4_6 ~= 0 then
				local var5_6 = {
					id = var4_6
				}

				var5_6.colorId = 0
				arg0_6.currentDressDataDic[iter1_6] = var5_6
				var3_6 = var3_6 + 1
			end
		end

		arg0_6:InitCommanderCustomDressData()

		if var3_6 == 0 then
			arg3_6()

			return
		end

		local var6_6 = 0

		for iter2_6, iter3_6 in pairs(arg0_6.currentDressDataDic) do
			arg0_6:LoadDressObjectItem(iter2_6, iter3_6.id, function()
				var6_6 = var6_6 + 1

				if var6_6 == var3_6 then
					arg3_6()
				end
			end)
		end
	else
		local var7_6 = var1_6:GetCharacterAgency()

		arg0_6.modelData = var7_6:GetShipById(arg0_6.shipId):GetModel()

		local var8_6 = 0

		for iter4_6, iter5_6 in pairs(var0_6) do
			local var9_6 = var7_6:GetCurDressIdByShipId(arg0_6.shipId, iter5_6)

			if var9_6 and dressId ~= 0 then
				local var10_6 = {
					id = var9_6.dress_id
				}

				var10_6.colorId = 0
				arg0_6.currentDressDataDic[iter5_6] = var10_6
				var8_6 = var8_6 + 1
			end
		end

		if var8_6 == 0 then
			arg3_6()

			return
		end

		local var11_6 = 0

		for iter6_6, iter7_6 in pairs(arg0_6.currentDressDataDic) do
			arg0_6:LoadDressObjectItem(iter6_6, iter7_6.id, function()
				var11_6 = var11_6 + 1

				if var11_6 == var8_6 then
					arg3_6()
				end
			end)
		end
	end
end

function var0_0.SetShipId(arg0_9, arg1_9)
	arg0_9.shipId = arg1_9
	arg0_9.hasTF = false
	arg0_9.currentDressDataDic = {}
	arg0_9.dataAfterRoleInit = {}

	arg0_9:RemoveDressTF()
	arg0_9:InitDressData()
end

function var0_0.InitCommanderCustomDressData(arg0_10)
	arg0_10.commanderDressDic = {}

	local var0_10 = getProxy(IslandProxy):GetIsland():GetDressUpAgency()

	for iter0_10, iter1_10 in pairs(var0_0.CommanderCustom) do
		local var1_10 = var0_10:GetDressByType(iter1_10)

		if var1_10 then
			arg0_10.commanderDressDic[iter1_10] = var1_10
		end
	end
end

function var0_0.InitDressData(arg0_11)
	local var0_11 = {
		var0_0.DressType.BackDecorate,
		var0_0.DressType.Flotage,
		var0_0.DressType.Footprint
	}
	local var1_11 = getProxy(IslandProxy):GetIsland()

	if arg0_11.shipId == 0 then
		local var2_11 = var1_11:GetDressUpAgency()

		for iter0_11, iter1_11 in pairs(var0_11) do
			local var3_11 = var2_11:GetDressByType(iter1_11)

			if var3_11 then
				local var4_11 = {
					id = var3_11
				}

				var4_11.colorId = 0
				arg0_11.dataAfterRoleInit[iter1_11] = var4_11
			end
		end

		arg0_11:InitCommanderCustomDressData()
	else
		local var5_11 = var1_11:GetCharacterAgency()

		for iter2_11, iter3_11 in pairs(var0_11) do
			local var6_11 = var5_11:GetCurDressIdByShipId(arg0_11.shipId, iter3_11)

			if var6_11 then
				local var7_11 = {
					id = var6_11.dress_id
				}

				var7_11.colorId = 0
				arg0_11.dataAfterRoleInit[iter3_11] = var7_11
			end
		end
	end
end

function var0_0.InitDressTF(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12.dataAfterRoleInit) do
		arg0_12:ChangeDressByType(iter0_12, iter1_12)
	end

	arg0_12.dataAfterRoleInit = {}
end

function var0_0.OnRoleLoaded(arg0_13, arg1_13, arg2_13)
	arg0_13.modelData = arg2_13
	arg0_13.roleTF = arg1_13
	arg0_13.hasTF = true

	arg0_13:InitDressTF()
end

function var0_0.RemoveDressTF(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.pageDressTFDic or {}) do
		Object.Destroy(iter1_14.gameObject)
	end

	arg0_14.pageDressTFDic = {}
end

function var0_0.ChangeCommanderPartColor(arg0_15, arg1_15, arg2_15)
	if arg2_15 == 0 then
		GraphicsInterface.Instance:ResetCharacterComponentMaterialData(arg0_15.roleTF:GetChild(0).gameObject, var0_0.ComponentType.Hair)
	else
		local var0_15 = pg.island_dress_colordiff_template[arg2_15].model

		GraphicsInterface.Instance:SetCharacterComponentMaterialData(arg0_15.roleTF:GetChild(0).gameObject, var0_15)
	end
end

function var0_0.ChangeCommanderPart(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg2_16.id
	local var1_16 = arg2_16.colorId

	arg0_16.commanderDressDic[arg1_16] = arg2_16.id

	local function var2_16()
		local var0_17 = arg0_16.commanderDressDic[var0_0.DressType.Hat] or 0

		if var0_17 == 0 then
			GraphicsInterface.Instance:SetCharacterBlendShape(arg0_16.roleTF:GetChild(0).gameObject, var0_0.ComponentType.Hair, 0, 0)
			GraphicsInterface.Instance:SetCharacterBlendShape(arg0_16.roleTF:GetChild(0).gameObject, var0_0.ComponentType.Hair, 1, 0)
		else
			local var1_17 = pg.island_dress_template[var0_17].sub_type - 1

			GraphicsInterface.Instance:SetCharacterBlendShape(arg0_16.roleTF:GetChild(0).gameObject, var0_0.ComponentType.Hair, var1_17, 100)
			GraphicsInterface.Instance:SetCharacterBlendShape(arg0_16.roleTF:GetChild(0).gameObject, var0_0.ComponentType.Hair, 1 - var1_17, 0)
		end
	end

	local function var3_16()
		if arg1_16 == var0_0.DressType.Hat then
			arg0_16:ChangeCommanderPartShow(arg1_16, true)
			var2_16()
		elseif arg1_16 == var0_0.DressType.Hair then
			var2_16()
		elseif arg1_16 == var0_0.DressType.Face then
			local var0_18 = pg.island_dress_template[var0_16]
			local var1_18 = var0_18.face_clip == "" and "idle" or var0_18.face_clip

			arg0_16.roleTF:GetChild(0).gameObject:GetComponent(typeof(Animator)):Play(var1_18, 4)
		end
	end

	if var0_16 ~= 0 then
		local var4_16 = pg.island_dress_template[var0_16].model

		if var1_16 == 0 or var1_16 == nil then
			GraphicsInterface.Instance:LoadCharacterComponent(arg0_16.roleTF:GetChild(0).gameObject, var4_16, var3_16)
		else
			local var5_16 = pg.island_dress_colordiff_template[var1_16].model

			GraphicsInterface.Instance:LoadCharacterComponentAndMaterial(arg0_16.roleTF:GetChild(0).gameObject, var4_16, var5_16, var3_16)
		end
	end

	if arg1_16 == var0_0.DressType.Hat and var0_16 == 0 then
		arg0_16:ChangeCommanderPartShow(arg1_16, false)
		var2_16()
	end
end

function var0_0.LoadDressObjectItem(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = pg.island_dress_template[arg2_19]
	local var1_19 = var0_19.model
	local var2_19 = arg0_19.shipId
	local var3_19 = IslandAssetLoadDispatcher.Instance:Enqueue(var1_19, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_20)
		if var2_19 ~= arg0_19.shipId then
			return
		end

		if arg0_19.currentDressDataDic[arg1_19].id ~= arg2_19 then
			return
		end

		local var0_20 = Object.Instantiate(arg0_20)
		local var1_20 = arg0_19.isScene and Layer.Default or Layer.Character3D

		pg.ViewUtils.SetLayer(var0_20.transform, var1_20)
		switch(arg1_19, {
			[var0_0.DressType.BackDecorate] = function()
				local var0_21 = arg0_19.roleTF.transform

				if var0_19.attachmentPoint ~= "" then
					local var1_21 = var0_19.attachmentPoint

					local function var2_21(arg0_22)
						for iter0_22 = 0, arg0_22.childCount - 1 do
							local var0_22 = arg0_22:GetChild(iter0_22)

							if var0_22.name == var1_21 then
								return var0_22
							end

							local var1_22 = var2_21(var0_22, var1_21)

							if var1_22 then
								return var1_22
							end
						end

						return nil
					end

					var0_21 = var2_21(var0_21)
				end

				if var0_19.offset ~= "" then
					local var3_21 = Vector3(var0_19.offset[1], var0_19.offset[2], var0_19.offset[3])

					var0_20.transform.localPosition = var3_21
				end

				if var0_19.rotation ~= "" then
					local var4_21 = Quaternion.Euler(var0_19.rotation[1], var0_19.rotation[2], var0_19.rotation[3])

					var0_20.transform.rotation = var4_21
				end

				if var0_19.scale ~= "" then
					local var5_21 = Vector3(var0_19.scale[1], var0_19.scale[1], var0_19.scale[1])

					var0_20.transform.localScale = var5_21
				end

				setParent(var0_20, var0_21)
			end,
			[var0_0.DressType.Flotage] = function()
				local var0_23

				if var0_19.offset ~= "" then
					var0_23 = Vector3(var0_19.offset[1], var0_19.offset[2], var0_19.offset[3])

					local var1_23 = var0_20.name
					local var2_23 = GameObject.New(var1_23)

					setParent(var0_20.transform, var2_23.transform, false)

					var0_20 = var2_23
					var0_20.transform.position = arg0_19.roleTF:GetChild(0).transform:TransformPoint(var0_23)
				end

				if var0_19.scale ~= "" then
					local var3_23 = Vector3(var0_19.scale[1], var0_19.scale[1], var0_19.scale[1])

					var0_20.transform.localScale = var3_23
				end

				local var4_23 = Vector3(0, 0, 0)

				if var0_19.rotation ~= "" then
					var4_23 = Vector3(var0_19.rotation[1], var0_19.rotation[2], var0_19.rotation[3])
				end

				var0_20.transform.rotation = var4_23

				local var5_23 = GetOrAddComponent(var0_20, typeof(DressFlow))
				local var6_23 = pg.island_set.island_dress_follow_param.key_value_varchar

				var5_23.target = arg0_19.roleTF
				var5_23.offset = var0_23
				var5_23.delayTime = var6_23[1]
				var5_23.lerpSpeed = var6_23[2]
				var5_23.recordInterval = var6_23[3]
				var5_23.rotationOffest = var4_23
			end,
			[var0_0.DressType.Footprint] = function()
				local var0_24 = Vector3(0, 0, 0)

				if var0_19.offset ~= "" then
					var0_24 = Vector3(var0_19.offset[1], var0_19.offset[2], var0_19.offset[3])
				end

				setParent(var0_20, arg0_19.roleTF)

				var0_20.transform.localPosition = var0_24
			end
		})

		arg0_19.pageDressTFDic[arg2_19] = var0_20

		existCall(arg3_19)
	end), true, true)

	table.insert(arg0_19.loadingIdList or {}, var3_19)
end

function var0_0.ChangeDressObject(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg2_25.id
	local var1_25 = arg0_25.currentDressDataDic[arg1_25] and arg0_25.currentDressDataDic[arg1_25].id or 0

	if var1_25 then
		if var1_25 == var0_25 then
			return
		end

		if var1_25 ~= 0 then
			local var2_25 = arg0_25.pageDressTFDic[var1_25]

			if var2_25 then
				Object.Destroy(var2_25)

				arg0_25.pageDressTFDic[var1_25] = nil
			end

			arg0_25.currentDressDataDic[arg1_25] = nil
		end
	end

	if var0_25 == 0 then
		return
	end

	arg0_25.currentDressDataDic[arg1_25] = arg2_25

	arg0_25:LoadDressObjectItem(arg1_25, var0_25)
end

function var0_0.ChangeDressByType(arg0_26, arg1_26, arg2_26)
	if not arg0_26.hasTF then
		arg0_26.dataAfterRoleInit[arg1_26] = arg2_26

		return
	end

	if table.contains(var0_0.CommanderCustom, arg1_26) then
		arg0_26:ChangeCommanderPart(arg1_26, arg2_26)
	else
		arg0_26:ChangeDressObject(arg1_26, arg2_26)
	end
end

function var0_0.ChangeCommanderPartShow(arg0_27, arg1_27, arg2_27)
	if not arg0_27.hasTF then
		return
	end

	GraphicsInterface.Instance:SetCharacterComponentShow(arg0_27.roleTF:GetChild(0).gameObject, var0_0.ComponentType.Headware, arg2_27)
end

function var0_0.ChangeModelTransfromByUnitId(arg0_28, arg1_28, arg2_28, arg3_28)
	local var0_28 = pg.island_unit_character[arg1_28]

	arg0_28.hasTF = false

	arg0_28:RemoveDressTF()

	arg0_28.dataAfterRoleInit = arg0_28.currentDressDataDic
	arg0_28.currentDressDataDic = {}

	local var1_28 = arg0_28.roleTF:GetChild(0).gameObject

	_IslandCore:GetPoolMgr():ReturnCharacterModel(arg0_28.modelData.model, arg0_28.modelData.animator, var1_28, true)

	arg0_28.modelData = {
		model = var0_28.model,
		animator = var0_28.animator,
		personal_ani = var0_28.personal_ani
	}

	_IslandCore:GetPoolMgr():GetCharacterModel(arg0_28.modelData.model, arg0_28.modelData.animator, function(arg0_29)
		arg0_28.hasTF = true

		local var0_29 = arg0_28.isScene and Layer.Default or Layer.Character3D

		pg.ViewUtils.SetLayer(arg0_29.transform, var0_29)
		setParent(arg0_29.transform, arg0_28.roleTF, false)
		arg0_28:InitDressTF()

		if arg3_28 then
			local var1_29 = arg0_28.modelData.personal_ani

			if var1_29 and var1_29 ~= "" then
				local var2_29 = GetOrAddComponent(arg0_28.roleTF.transform:GetChild(0), typeof(Animator))

				for iter0_29 = 1, var2_29.layerCount do
					var2_29:CrossFadeInFixedTime(var1_29, 0, iter0_29 - 1)
				end
			end
		end

		existCall(arg2_28, arg0_28.roleTF)
	end, true)
end

function var0_0.ChangeModelTransfromByUnitIdAndChangeDress(arg0_30, arg1_30, arg2_30, arg3_30, arg4_30, arg5_30)
	local var0_30 = pg.island_unit_character[arg1_30]

	arg0_30.hasTF = false

	arg0_30:RemoveDressTF()

	arg0_30.dataAfterRoleInit = arg0_30.currentDressDataDic

	for iter0_30, iter1_30 in ipairs(arg2_30 or {}) do
		local var1_30 = pg.island_dress_template[iter1_30].type

		if arg0_30.dataAfterRoleInit[var1_30].id == iter1_30 then
			arg0_30.dataAfterRoleInit[var1_30] = nil
		end
	end

	for iter2_30, iter3_30 in ipairs(arg3_30 or {}) do
		local var2_30 = pg.island_dress_template[iter3_30].type

		arg0_30.dataAfterRoleInit[var2_30] = {
			colorId = 0,
			id = iter3_30
		}
	end

	arg0_30.currentDressDataDic = {}

	local var3_30 = arg0_30.roleTF:GetChild(0).gameObject

	_IslandCore:GetPoolMgr():ReturnCharacterModel(arg0_30.modelData.model, arg0_30.modelData.animator, var3_30, true)

	arg0_30.modelData = {
		model = var0_30.model,
		animator = var0_30.animator,
		personal_ani = var0_30.personal_ani
	}

	_IslandCore:GetPoolMgr():GetCharacterModel(arg0_30.modelData.model, arg0_30.modelData.animator, function(arg0_31)
		arg0_30.hasTF = true

		local var0_31 = arg0_30.isScene and Layer.Default or Layer.Character3D

		pg.ViewUtils.SetLayer(arg0_31.transform, var0_31)
		setParent(arg0_31.transform, arg0_30.roleTF, false)
		arg0_30:InitDressTF()

		if arg5_30 then
			local var1_31 = arg0_30.modelData.personal_ani

			if var1_31 and var1_31 ~= "" then
				local var2_31 = GetOrAddComponent(arg0_30.roleTF.transform:GetChild(0), typeof(Animator))

				for iter0_31 = 1, var2_31.layerCount do
					var2_31:CrossFadeInFixedTime(var1_31, 0, iter0_31 - 1)
				end
			end
		end

		existCall(arg4_30, arg0_30.roleTF)
	end, true)
end

function var0_0.Destroy(arg0_32)
	arg0_32:RemoveDressTF()

	for iter0_32, iter1_32 in ipairs(arg0_32.loadingIdList or {}) do
		IslandAssetLoadDispatcher.Instance:Cancel(iter1_32)
	end

	arg0_32.loadingIdList = nil
end

function var0_0.ResetDressUp(arg0_33)
	local var0_33 = getProxy(IslandProxy):GetIsland()

	if arg0_33.shipId == 0 then
		local var1_33 = {
			var0_0.DressType.BackDecorate,
			var0_0.DressType.Flotage,
			var0_0.DressType.Footprint
		}
		local var2_33 = var0_33:GetDressUpAgency()

		for iter0_33, iter1_33 in ipairs(var1_33) do
			local var3_33 = var2_33:GetDressByType(iter1_33) or 0
			local var4_33 = 0

			arg0_33:ChangeDressByType(iter1_33, {
				id = var3_33,
				colorId = var4_33
			})
		end
	else
		local var5_33 = var0_33:GetCharacterAgency()
		local var6_33 = {
			var0_0.DressType.BackDecorate,
			var0_0.DressType.Flotage,
			var0_0.DressType.Footprint
		}

		for iter2_33, iter3_33 in ipairs(var6_33) do
			local var7_33 = var5_33:GetCurDressIdByShipId(arg0_33.shipId, iter3_33) or {}

			arg0_33:ChangeDressByType(iter3_33, {
				colorId = 0,
				id = var7_33.dress_id or 0
			})
		end
	end
end

return var0_0

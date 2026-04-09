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

function var0_0.Ctor(arg0_1, arg1_1)
	if arg1_1 then
		arg0_1.curIsland = arg1_1
		arg0_1.isOtherIsland = getProxy(PlayerProxy):getRawData().id ~= arg0_1.curIsland.id
	end
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

	arg0_14:InitDressTF(arg3_14)
end

function var0_0.RemoveDressTF(arg0_15)
	for iter0_15, iter1_15 in pairs(arg0_15.pageDressTFDic or {}) do
		Object.Destroy(iter1_15.gameObject)
	end

	arg0_15.pageDressTFDic = {}
end

function var0_0.ChangeCommanderPartColor(arg0_16, arg1_16, arg2_16)
	if arg2_16 == 0 then
		GraphicsInterface.Instance:ResetCharacterComponentMaterialData(arg0_16.roleTF:GetChild(0).gameObject, var0_0.ComponentType.Hair)
	else
		local var0_16 = pg.island_dress_colordiff_template[arg2_16].model

		GraphicsInterface.Instance:SetCharacterComponentMaterialData(arg0_16.roleTF:GetChild(0).gameObject, var0_16)
	end
end

function var0_0.ChangeCommanderPart(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg2_17.id
	local var1_17 = arg2_17.colorId

	arg0_17.commanderDressDic[arg1_17] = arg2_17.id

	local function var2_17()
		local var0_18 = arg0_17.commanderDressDic[var0_0.DressType.Hat] or 0

		if var0_18 == 0 then
			GraphicsInterface.Instance:SetCharacterBlendShape(arg0_17.roleTF:GetChild(0).gameObject, var0_0.ComponentType.Hair, 0, 0)
			GraphicsInterface.Instance:SetCharacterBlendShape(arg0_17.roleTF:GetChild(0).gameObject, var0_0.ComponentType.Hair, 1, 0)
		else
			local var1_18 = pg.island_dress_template[var0_18].sub_type - 1

			GraphicsInterface.Instance:SetCharacterBlendShape(arg0_17.roleTF:GetChild(0).gameObject, var0_0.ComponentType.Hair, var1_18, 100)
			GraphicsInterface.Instance:SetCharacterBlendShape(arg0_17.roleTF:GetChild(0).gameObject, var0_0.ComponentType.Hair, 1 - var1_18, 0)
		end
	end

	local function var3_17()
		if arg1_17 == var0_0.DressType.Hat then
			arg0_17:ChangeCommanderPartShow(arg1_17, true)
			var2_17()
		elseif arg1_17 == var0_0.DressType.Hair then
			var2_17()
		elseif arg1_17 == var0_0.DressType.Face then
			local var0_19 = pg.island_dress_template[var0_17]
			local var1_19 = var0_19.face_clip == "" and "idle" or var0_19.face_clip

			arg0_17.roleTF:GetChild(0).gameObject:GetComponent(typeof(Animator)):Play(var1_19, 4)
		end
	end

	if var0_17 ~= 0 then
		local var4_17 = pg.island_dress_template[var0_17].model

		if var1_17 == 0 or var1_17 == nil then
			GraphicsInterface.Instance:LoadCharacterComponent(arg0_17.roleTF:GetChild(0).gameObject, var4_17, var3_17)
		else
			local var5_17 = pg.island_dress_colordiff_template[var1_17].model

			GraphicsInterface.Instance:LoadCharacterComponentAndMaterial(arg0_17.roleTF:GetChild(0).gameObject, var4_17, var5_17, var3_17)
		end
	end

	if arg1_17 == var0_0.DressType.Hat and var0_17 == 0 then
		arg0_17:ChangeCommanderPartShow(arg1_17, false)
		var2_17()
	end
end

function var0_0.LoadDressObjectItem(arg0_20, arg1_20, arg2_20, arg3_20)
	local var0_20 = pg.island_dress_template[arg2_20]
	local var1_20 = var0_20.model
	local var2_20 = arg0_20.shipId
	local var3_20 = IslandAssetLoadDispatcher.Instance:Enqueue(var1_20, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_21)
		if IsNil(arg0_20.roleTF) then
			return
		end

		if arg0_20.hasTF == false then
			return
		end

		if var2_20 ~= arg0_20.shipId then
			return
		end

		if arg0_20.currentDressDataDic[arg1_20].id ~= arg2_20 then
			return
		end

		local var0_21 = Object.Instantiate(arg0_21)
		local var1_21 = arg0_20.isScene and Layer.Default or Layer.Character3D

		pg.ViewUtils.SetLayer(var0_21.transform, var1_21)
		switch(arg1_20, {
			[var0_0.DressType.BackDecorate] = function()
				local var0_22 = arg0_20.roleTF.transform

				if var0_20.attachmentPoint ~= "" then
					local var1_22 = var0_20.attachmentPoint

					local function var2_22(arg0_23)
						for iter0_23 = 0, arg0_23.childCount - 1 do
							local var0_23 = arg0_23:GetChild(iter0_23)

							if var0_23.name == var1_22 then
								return var0_23
							end

							local var1_23 = var2_22(var0_23, var1_22)

							if var1_23 then
								return var1_23
							end
						end

						return nil
					end

					var0_22 = var2_22(var0_22)
				end

				if var0_20.offset ~= "" then
					local var3_22 = Vector3(var0_20.offset[1], var0_20.offset[2], var0_20.offset[3])

					var0_21.transform.localPosition = var3_22
				end

				if var0_20.rotation ~= "" then
					local var4_22 = Quaternion.Euler(var0_20.rotation[1], var0_20.rotation[2], var0_20.rotation[3])

					var0_21.transform.rotation = var4_22
				end

				if var0_20.scale ~= "" then
					local var5_22 = Vector3(var0_20.scale[1], var0_20.scale[1], var0_20.scale[1])

					var0_21.transform.localScale = var5_22
				end

				setParent(var0_21, var0_22)
			end,
			[var0_0.DressType.Flotage] = function()
				local var0_24

				if var0_20.offset ~= "" then
					var0_24 = Vector3(var0_20.offset[1], var0_20.offset[2], var0_20.offset[3])

					local var1_24 = var0_21.name
					local var2_24 = GameObject.New(var1_24)

					setParent(var0_21.transform, var2_24.transform, false)

					var0_21 = var2_24
					var0_21.transform.position = arg0_20.roleTF:GetChild(0).transform:TransformPoint(var0_24)
				end

				if var0_20.scale ~= "" then
					local var3_24 = Vector3(var0_20.scale[1], var0_20.scale[1], var0_20.scale[1])

					var0_21.transform.localScale = var3_24
				end

				local var4_24 = Vector3(0, 0, 0)

				if var0_20.rotation ~= "" then
					var4_24 = Vector3(var0_20.rotation[1], var0_20.rotation[2], var0_20.rotation[3])
				end

				var0_21.transform.rotation = var4_24

				local var5_24 = GetOrAddComponent(var0_21, typeof(DressFlow))
				local var6_24 = pg.island_set.island_dress_follow_param.key_value_varchar

				var5_24.target = arg0_20.roleTF
				var5_24.offset = var0_24
				var5_24.delayTime = var6_24[1]
				var5_24.lerpSpeed = var6_24[2]
				var5_24.recordInterval = var6_24[3]
				var5_24.rotationOffest = var4_24
			end,
			[var0_0.DressType.Footprint] = function()
				local var0_25 = Vector3(0, 0, 0)

				if var0_20.offset ~= "" then
					var0_25 = Vector3(var0_20.offset[1], var0_20.offset[2], var0_20.offset[3])
				end

				setParent(var0_21, arg0_20.roleTF)

				var0_21.transform.localPosition = var0_25
			end
		})

		arg0_20.pageDressTFDic[arg2_20] = var0_21

		existCall(arg3_20, var0_21)
	end), true, true)

	table.insert(arg0_20.loadingIdList or {}, var3_20)
end

function var0_0.ChangeDressObject(arg0_26, arg1_26, arg2_26, arg3_26)
	local var0_26 = arg2_26.id
	local var1_26 = arg0_26.currentDressDataDic[arg1_26] and arg0_26.currentDressDataDic[arg1_26].id or 0

	if var1_26 then
		if var1_26 == var0_26 then
			return
		end

		if var1_26 ~= 0 then
			local var2_26 = arg0_26.pageDressTFDic[var1_26]

			if var2_26 then
				Object.Destroy(var2_26)

				arg0_26.pageDressTFDic[var1_26] = nil
			end

			arg0_26.currentDressDataDic[arg1_26] = nil
		end
	end

	if var0_26 == 0 then
		return
	end

	arg0_26.currentDressDataDic[arg1_26] = arg2_26

	arg0_26:LoadDressObjectItem(arg1_26, var0_26, arg3_26)
end

function var0_0.ChangeDressByType(arg0_27, arg1_27, arg2_27, arg3_27)
	if not arg0_27.hasTF then
		arg0_27.dataAfterRoleInit[arg1_27] = arg2_27

		return
	end

	if table.contains(var0_0.CommanderCustom, arg1_27) then
		arg0_27:ChangeCommanderPart(arg1_27, arg2_27)
	else
		arg0_27:ChangeDressObject(arg1_27, arg2_27, arg3_27)
	end
end

function var0_0.ChangeCommanderPartShow(arg0_28, arg1_28, arg2_28)
	if not arg0_28.hasTF then
		return
	end

	GraphicsInterface.Instance:SetCharacterComponentShow(arg0_28.roleTF:GetChild(0).gameObject, var0_0.ComponentType.Headware, arg2_28)
end

function var0_0.ChangeModelTransfromByUnitId(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = pg.island_unit_character[arg1_29]

	arg0_29.hasTF = false

	arg0_29:RemoveDressTF()

	arg0_29.dataAfterRoleInit = arg0_29.currentDressDataDic
	arg0_29.currentDressDataDic = {}

	local var1_29 = arg0_29.roleTF:GetChild(0).gameObject

	_IslandCore:GetPoolMgr():ReturnCharacterModel(arg0_29.modelData.model, arg0_29.modelData.animator, var1_29, true)

	arg0_29.modelData = {
		model = var0_29.model,
		animator = var0_29.animator,
		personal_ani = var0_29.personal_ani
	}

	_IslandCore:GetPoolMgr():GetCharacterModel(arg0_29.modelData.model, arg0_29.modelData.animator, function(arg0_30)
		arg0_29.hasTF = true

		local var0_30 = arg0_29.isScene and Layer.Default or Layer.Character3D

		pg.ViewUtils.SetLayer(arg0_30.transform, var0_30)
		setParent(arg0_30.transform, arg0_29.roleTF, false)
		arg0_29:InitDressTF()

		if arg3_29 then
			local var1_30 = arg0_29.modelData.personal_ani

			if var1_30 and var1_30 ~= "" then
				local var2_30 = GetOrAddComponent(arg0_29.roleTF.transform:GetChild(0), typeof(Animator))

				for iter0_30 = 1, var2_30.layerCount do
					var2_30:CrossFadeInFixedTime(var1_30, 0, iter0_30 - 1)
				end
			end
		end

		existCall(arg2_29, arg0_29.roleTF)
	end, true)
end

function var0_0.ChangeModelTransfromByUnitIdAndChangeDress(arg0_31, arg1_31, arg2_31, arg3_31, arg4_31, arg5_31)
	local var0_31 = pg.island_unit_character[arg1_31]

	arg0_31.hasTF = false

	arg0_31:RemoveDressTF()

	arg0_31.dataAfterRoleInit = arg0_31.currentDressDataDic

	for iter0_31, iter1_31 in ipairs(arg2_31 or {}) do
		local var1_31 = pg.island_dress_template[iter1_31].type

		if arg0_31.dataAfterRoleInit[var1_31].id == iter1_31 then
			arg0_31.dataAfterRoleInit[var1_31] = nil
		end
	end

	for iter2_31, iter3_31 in ipairs(arg3_31 or {}) do
		local var2_31 = pg.island_dress_template[iter3_31].type

		arg0_31.dataAfterRoleInit[var2_31] = {
			colorId = 0,
			id = iter3_31
		}
	end

	arg0_31.currentDressDataDic = {}

	local var3_31 = arg0_31.roleTF:GetChild(0).gameObject

	_IslandCore:GetPoolMgr():ReturnCharacterModel(arg0_31.modelData.model, arg0_31.modelData.animator, var3_31, true)

	arg0_31.modelData = {
		model = var0_31.model,
		animator = var0_31.animator,
		personal_ani = var0_31.personal_ani
	}

	_IslandCore:GetPoolMgr():GetCharacterModel(arg0_31.modelData.model, arg0_31.modelData.animator, function(arg0_32)
		arg0_31.hasTF = true

		local var0_32 = arg0_31.isScene and Layer.Default or Layer.Character3D

		pg.ViewUtils.SetLayer(arg0_32.transform, var0_32)
		setParent(arg0_32.transform, arg0_31.roleTF, false)
		arg0_31:InitDressTF()

		if arg5_31 then
			local var1_32 = arg0_31.modelData.personal_ani

			if var1_32 and var1_32 ~= "" then
				local var2_32 = GetOrAddComponent(arg0_31.roleTF.transform:GetChild(0), typeof(Animator))

				for iter0_32 = 1, var2_32.layerCount do
					var2_32:CrossFadeInFixedTime(var1_32, 0, iter0_32 - 1)
				end
			end
		end

		existCall(arg4_31, arg0_31.roleTF)
	end, true)
end

function var0_0.Destroy(arg0_33)
	arg0_33.curIsland = nil

	arg0_33:RemoveDressTF()

	for iter0_33, iter1_33 in ipairs(arg0_33.loadingIdList or {}) do
		IslandAssetLoadDispatcher.Instance:Cancel(iter1_33)
	end

	arg0_33.loadingIdList = nil
end

function var0_0.ResetDressUp(arg0_34)
	local var0_34 = getProxy(IslandProxy):GetIsland()

	if arg0_34.shipId == 0 then
		local var1_34 = {
			var0_0.DressType.BackDecorate,
			var0_0.DressType.Flotage,
			var0_0.DressType.Footprint
		}
		local var2_34 = var0_34:GetDressUpAgency()

		for iter0_34, iter1_34 in ipairs(var1_34) do
			local var3_34 = var2_34:GetDressByType(iter1_34) or 0
			local var4_34 = 0

			arg0_34:ChangeDressByType(iter1_34, {
				id = var3_34,
				colorId = var4_34
			})
		end
	else
		local var5_34 = var0_34:GetCharacterAgency()
		local var6_34 = {
			var0_0.DressType.BackDecorate,
			var0_0.DressType.Flotage,
			var0_0.DressType.Footprint
		}

		for iter2_34, iter3_34 in ipairs(var6_34) do
			local var7_34 = var5_34:GetCurDressIdByShipId(arg0_34.shipId, iter3_34) or {}

			arg0_34:ChangeDressByType(iter3_34, {
				colorId = 0,
				id = var7_34.dress_id or 0
			})
		end
	end
end

return var0_0

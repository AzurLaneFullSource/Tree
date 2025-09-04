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

function var0_0.SetShipId(arg0_3, arg1_3)
	arg0_3.shipId = arg1_3
	arg0_3.hasTF = false
	arg0_3.currentDressDataDic = {}
	arg0_3.dataAfterRoleInit = {}

	arg0_3:RemoveDressTF()
	arg0_3:InitDressData()
end

function var0_0.InitDressData(arg0_4)
	local var0_4 = {
		var0_0.DressType.BackDecorate,
		var0_0.DressType.Flotage,
		var0_0.DressType.Footprint
	}
	local var1_4 = getProxy(IslandProxy):GetIsland()

	if arg0_4.shipId == 0 then
		local var2_4 = var1_4:GetDressUpAgency()

		for iter0_4, iter1_4 in pairs(var0_4) do
			local var3_4 = var2_4:GetDressByType(iter1_4)

			if var3_4 then
				local var4_4 = {
					id = var3_4
				}

				var4_4.colorId = 0
				arg0_4.dataAfterRoleInit[iter1_4] = var4_4
			end
		end
	else
		local var5_4 = var1_4:GetCharacterAgency():GetShipById(arg0_4.shipId)

		for iter2_4, iter3_4 in pairs(var0_4) do
			local var6_4 = var5_4:GetDressByType(iter3_4)

			if var6_4 then
				local var7_4 = {
					id = var6_4
				}

				var7_4.colorId = 0
				arg0_4.dataAfterRoleInit[iter3_4] = var7_4
			end
		end
	end
end

function var0_0.InitDressTF(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5.dataAfterRoleInit) do
		arg0_5:ChangeDressByType(iter0_5, iter1_5)
	end

	arg0_5.dataAfterRoleInit = {}
end

function var0_0.OnRoleLoaded(arg0_6, arg1_6, arg2_6)
	arg0_6.modelData = arg2_6
	arg0_6.roleTF = arg1_6
	arg0_6.hasTF = true

	arg0_6:InitDressTF()
end

function var0_0.RemoveDressTF(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.pageDressTFDic or {}) do
		Object.Destroy(iter1_7.gameObject)
	end

	arg0_7.pageDressTFDic = {}
end

function var0_0.ChangeCommanderPartColor(arg0_8, arg1_8, arg2_8)
	if arg2_8 == 0 then
		GraphicsInterface.Instance:ResetCharacterComponentMaterialData(arg0_8.roleTF:GetChild(0).gameObject, var0_0.ComponentType.Hair)
	else
		local var0_8 = pg.island_dress_colordiff_template[arg2_8].model

		GraphicsInterface.Instance:SetCharacterComponentMaterialData(arg0_8.roleTF:GetChild(0).gameObject, var0_8)
	end
end

function var0_0.ChangeCommanderPart(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg2_9.id
	local var1_9 = arg2_9.colorId

	local function var2_9()
		if arg1_9 == var0_0.DressType.Hat then
			arg0_9:ChangeCommanderPartShow(arg1_9, true)
		end
	end

	if var0_9 ~= 0 then
		local var3_9 = pg.island_dress_template[var0_9].model

		if var1_9 == 0 or var1_9 == nil then
			GraphicsInterface.Instance:LoadCharacterComponent(arg0_9.roleTF:GetChild(0).gameObject, var3_9, var2_9)
		else
			local var4_9 = pg.island_dress_colordiff_template[var1_9].model

			GraphicsInterface.Instance:LoadCharacterComponentAndMaterial(arg0_9.roleTF:GetChild(0).gameObject, var3_9, var4_9, var2_9)
		end
	end

	if arg1_9 == var0_0.DressType.Hat and var0_9 == 0 then
		arg0_9:ChangeCommanderPartShow(arg1_9, false)
	end
end

function var0_0.ChangeDressObject(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg2_11.id
	local var1_11 = arg0_11.currentDressDataDic[arg1_11] and arg0_11.currentDressDataDic[arg1_11].id or 0

	if var1_11 then
		if var1_11 == var0_11 then
			return
		end

		if var1_11 ~= 0 then
			local var2_11 = arg0_11.pageDressTFDic[var1_11]

			if var2_11 then
				Object.Destroy(var2_11)

				arg0_11.pageDressTFDic[var1_11] = nil
			end

			arg0_11.currentDressDataDic[arg1_11] = nil
		end
	end

	if var0_11 == 0 then
		return
	end

	arg0_11.currentDressDataDic[arg1_11] = arg2_11

	local var3_11 = pg.island_dress_template[var0_11]
	local var4_11 = var3_11.model
	local var5_11 = arg0_11.shipId

	ResourceMgr.Inst:getAssetAsync(var4_11, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_12)
		if var5_11 ~= arg0_11.shipId then
			return
		end

		if arg0_11.currentDressDataDic[arg1_11].id ~= var0_11 then
			return
		end

		local var0_12 = Object.Instantiate(arg0_12)

		pg.ViewUtils.SetLayer(var0_12.transform, Layer.Character3D)
		switch(arg1_11, {
			[var0_0.DressType.BackDecorate] = function()
				local var0_13 = arg0_11.roleTF.transform

				if var3_11.attachmentPoint ~= "" then
					local var1_13 = var3_11.attachmentPoint

					local function var2_13(arg0_14)
						for iter0_14 = 0, arg0_14.childCount - 1 do
							local var0_14 = arg0_14:GetChild(iter0_14)

							if var0_14.name == var1_13 then
								return var0_14
							end

							local var1_14 = var2_13(var0_14, var1_13)

							if var1_14 then
								return var1_14
							end
						end

						return nil
					end

					var0_13 = var2_13(var0_13)
				end

				if var3_11.offset ~= "" then
					local var3_13 = Vector3(var3_11.offset[1], var3_11.offset[2], var3_11.offset[3])

					var0_12.transform.localPosition = var3_13
				end

				if var3_11.rotation ~= "" then
					local var4_13 = Quaternion.Euler(var3_11.rotation[1], var3_11.rotation[2], var3_11.rotation[3])

					var0_12.transform.rotation = var4_13
				end

				if var3_11.scale ~= "" then
					local var5_13 = Vector3(var3_11.scale[1], var3_11.scale[1], var3_11.scale[1])

					var0_12.transform.localScale = var5_13
				end

				setParent(var0_12, var0_13)
			end,
			[var0_0.DressType.Flotage] = function()
				local var0_15

				if var3_11.offset ~= "" then
					var0_15 = Vector3(var3_11.offset[1], var3_11.offset[2], var3_11.offset[3])

					local var1_15 = var0_12.name
					local var2_15 = GameObject.New(var1_15)

					setParent(var0_12.transform, var2_15.transform, false)

					var0_12 = var2_15
					var0_12.transform.position = arg0_11.roleTF.position + var0_15
				end

				local var3_15 = GetOrAddComponent(var0_12, typeof(DressFlow))

				var3_15.target = arg0_11.roleTF
				var3_15.offset = var0_15
				var3_15.delayTime = 0.01
			end,
			[var0_0.DressType.Footprint] = function()
				local var0_16 = Vector3(0, 0, 0)

				if var3_11.offset ~= "" then
					var0_16 = Vector3(var3_11.offset[1], var3_11.offset[2], var3_11.offset[3])
				end

				setParent(var0_12, arg0_11.roleTF)

				var0_12.transform.localPosition = var0_16
			end
		})

		arg0_11.pageDressTFDic[var0_11] = var0_12
	end), true, true)
end

function var0_0.ChangeDressByType(arg0_17, arg1_17, arg2_17)
	if not arg0_17.hasTF then
		arg0_17.dataAfterRoleInit[arg1_17] = arg2_17

		return
	end

	if table.contains(var0_0.CommanderCustom, arg1_17) then
		arg0_17:ChangeCommanderPart(arg1_17, arg2_17)
	else
		arg0_17:ChangeDressObject(arg1_17, arg2_17)
	end
end

function var0_0.ChangeCommanderPartShow(arg0_18, arg1_18, arg2_18)
	if not arg0_18.hasTF then
		return
	end

	GraphicsInterface.Instance:SetCharacterComponentShow(arg0_18.roleTF:GetChild(0).gameObject, var0_0.ComponentType.Headware, arg2_18)
end

function var0_0.ChangeModelTransfromByUnitId(arg0_19, arg1_19)
	local var0_19 = pg.island_unit_character[arg1_19]

	arg0_19.hasTF = false

	arg0_19:RemoveDressTF()

	arg0_19.dataAfterRoleInit = arg0_19.currentDressDataDic
	arg0_19.currentDressDataDic = {}

	local var1_19 = arg0_19.roleTF:GetChild(0).gameObject

	_IslandCore:GetPoolMgr():ReturnCharacterModel(arg0_19.modelData.model, arg0_19.modelData.animator, var1_19, true)

	arg0_19.modelData = {
		model = var0_19.model,
		animator = var0_19.animator
	}

	_IslandCore:GetPoolMgr():GetCharacterModel(arg0_19.modelData.model, arg0_19.modelData.animator, function(arg0_20)
		arg0_19.hasTF = true

		pg.ViewUtils.SetLayer(arg0_20.transform, Layer.Character3D)
		setParent(arg0_20.transform, arg0_19.roleTF, false)
		arg0_19:InitDressTF()
	end, true)
end

function var0_0.Destroy(arg0_21)
	arg0_21:RemoveDressTF()
end

return var0_0

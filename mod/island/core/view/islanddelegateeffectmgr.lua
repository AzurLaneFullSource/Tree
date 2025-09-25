local var0_0 = class("IslandDelegateEffectMgr", import(".IslandBaseUnit"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.effectPath = pg.island_unit_item[1018].model
	arg0_1.selectEffectPath = pg.island_unit_item[1019].model
	arg0_1.effectDic = {}
	arg0_1.effectIsShow = {}
end

function var0_0.LoadDelegatePreviewRole(arg0_2, arg1_2, arg2_2)
	arg0_2.modelData = arg1_2

	local var0_2 = pg.island_world_objects[arg2_2].param.position
	local var1_2 = Vector3(var0_2[1], var0_2[2], var0_2[3])
	local var2_2 = pg.island_world_objects[arg2_2].param.rotation
	local var3_2 = Vector3(var2_2[1], var2_2[2], var2_2[3])

	arg0_2:GetPoolMgr():GetCharacter(arg1_2.model, arg1_2.animator, function(arg0_3)
		arg0_2.role = arg0_3
		arg0_2.role.transform.eulerAngles = var3_2
		arg0_2.role.transform.position = var1_2

		local var0_3 = pg.island_set.delegate_role_transparency.key_value_int / 100

		GraphicsInterface.Instance:SetSelectedTransparency(arg0_2.role.transform:GetChild(0).gameObject, var0_3, true)
	end)
end

function var0_0.UnLoadDelegatePreviewRole(arg0_4)
	if arg0_4.role then
		GraphicsInterface.Instance:SetSelectedTransparency(arg0_4.role.transform:GetChild(0).gameObject, 0, false)
		arg0_4:GetPoolMgr():ReturnCharacter(arg0_4.modelData.model, arg0_4.modelData.animator, arg0_4.role)

		arg0_4.modelData = nil
		arg0_4.role = nil
	end
end

function var0_0.UpdatePositionAndRotation(arg0_5, arg1_5, arg2_5, arg3_5)
	arg1_5.transform.rotation = arg3_5
	arg1_5.transform.position = arg2_5
end

function var0_0.SelectSlotEffectShow(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	local var0_6 = arg1_6 == arg2_6

	arg0_6.effectIsShow[arg1_6] = var0_6

	if not var0_6 then
		local var1_6 = arg0_6.effectDic[arg1_6]

		if var1_6 then
			setActive(var1_6, true)
			arg0_6:UpdatePositionAndRotation(var1_6, arg3_6, arg4_6)

			return
		end

		arg0_6:GetPoolMgr():GetDelegateEffect(arg0_6.effectPath, function(arg0_7)
			if arg0_6.effectIsShow[arg1_6] then
				return
			end

			setParent(arg0_7, arg0_6:GetView().root)

			arg0_6.effectDic[arg1_6] = arg0_7

			arg0_6:UpdatePositionAndRotation(arg0_7, arg3_6, arg4_6)
		end)
	else
		if arg0_6.effectDic[arg1_6] then
			setActive(arg0_6.effectDic[arg1_6], false)
		end

		if arg0_6.selectEffect then
			arg0_6:UpdatePositionAndRotation(arg0_6.selectEffect, arg3_6, arg4_6)

			return
		end

		arg0_6:GetPoolMgr():GetDelegateEffect(arg0_6.selectEffectPath, function(arg0_8)
			if not arg0_6.effectIsShow[arg1_6] then
				return
			end

			setParent(arg0_8, arg0_6:GetView().root)

			arg0_6.selectEffect = arg0_8

			arg0_6:UpdatePositionAndRotation(arg0_8, arg3_6, arg4_6)
		end)
	end
end

function var0_0.RecycleAllSlotEffct(arg0_9)
	for iter0_9, iter1_9 in pairs(arg0_9.effectIsShow) do
		arg0_9.effectIsShow[iter0_9] = false
	end

	arg0_9.effectIsShow = {}

	for iter2_9, iter3_9 in pairs(arg0_9.effectDic) do
		if not IsNil(iter3_9) then
			arg0_9:GetPoolMgr():ReturnDelegateEffect(arg0_9.effectPath, iter3_9)
		end
	end

	arg0_9.effectDic = {}

	if not IsNil(arg0_9.selectEffect) then
		arg0_9:GetPoolMgr():ReturnDelegateEffect(arg0_9.selectEffect, arg0_9.selectEffect)
	end

	arg0_9.selectEffect = nil
end

function var0_0.OnDestroy(arg0_10)
	arg0_10:RecycleAllSlotEffct()
end

return var0_0

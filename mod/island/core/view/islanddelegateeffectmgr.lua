local var0_0 = class("IslandDelegateEffectMgr", import(".IslandBaseUnit"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.effectPath = pg.island_unit_item[1018].model
	arg0_1.selEffectPath = pg.island_unit_item[1019].model
	arg0_1.delegateEffectDic = {}
	arg0_1.delegateSelectEffectDic = {}
	arg0_1.delegateSelect = {}
end

function var0_0.GenEffect(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.delegateSelect[arg1_2] = false

	local var0_2 = arg0_2.delegateEffectDic[arg1_2]

	if var0_2 then
		arg0_2:UpdatePositionAndRotation(arg0_2.delegateEffectDic[arg1_2], arg2_2, arg3_2)
		setActive(var0_2, true)
	else
		arg0_2:GetPoolMgr():GetDelegateEffect(arg0_2.effectPath, function(arg0_3)
			setParent(arg0_3, arg0_2:GetView().root)

			arg0_2.delegateEffectDic[arg1_2] = arg0_3

			arg0_2:UpdatePositionAndRotation(arg0_3, arg2_2, arg3_2)

			if arg0_2.delegateSelect[arg1_2] then
				setActive(arg0_3, false)
			end
		end)
	end

	if arg0_2.delegateSelectEffectDic[arg1_2] then
		arg0_2:UpdatePositionAndRotation(arg0_2.delegateSelectEffectDic[arg1_2], arg2_2, arg3_2)
		setActive(var0_2, false)
	else
		arg0_2:GetPoolMgr():GetDelegateEffect(arg0_2.selEffectPath, function(arg0_4)
			setParent(arg0_4, arg0_2:GetView().root)

			arg0_2.delegateSelectEffectDic[arg1_2] = arg0_4

			arg0_2:UpdatePositionAndRotation(arg0_4, arg2_2, arg3_2)

			if arg0_2.delegateSelect[arg1_2] then
				setActive(arg0_4, true)
			end
		end)
	end
end

function var0_0.UpdatePositionAndRotation(arg0_5, arg1_5, arg2_5, arg3_5)
	arg1_5.transform.rotation = arg3_5
	arg1_5.transform.position = arg2_5
end

function var0_0.UpdateEffect(arg0_6, arg1_6, arg2_6, arg3_6)
	if arg0_6.delegateEffectDic[arg1_6] then
		arg0_6:UpdatePositionAndRotation(arg0_6.delegateEffectDic[arg1_6], arg2_6, arg3_6)
	end

	if arg0_6.delegateSelectEffectDic[arg1_6] then
		arg0_6:UpdatePositionAndRotation(arg0_6.delegateSelectEffectDic[arg1_6], arg2_6, arg3_6)
	end
end

function var0_0.OnDefaultSlotEffectShow(arg0_7, arg1_7, arg2_7)
	if arg0_7.delegateEffectDic[arg1_7] then
		setActive(arg0_7.delegateEffectDic[arg1_7], arg2_7)
	else
		arg0_7.delegateSelect[arg1_7] = arg2_7
	end
end

function var0_0.OnSelectSlotEffectShow(arg0_8, arg1_8, arg2_8)
	if arg0_8.delegateSelectEffectDic[arg1_8] then
		setActive(arg0_8.delegateSelectEffectDic[arg1_8], arg2_8)
	else
		arg0_8.delegateSelect[arg1_8] = arg2_8
	end
end

function var0_0.OnDestroy(arg0_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.delegateSelectEffectDic) do
		arg0_9:GetPoolMgr():ReturnDelegateEffect(arg0_9.selEffectPath, iter1_9)
	end

	for iter2_9, iter3_9 in ipairs(arg0_9.delegateEffectDic) do
		arg0_9:GetPoolMgr():ReturnDelegateEffect(arg0_9.effectPath, iter3_9)
	end

	arg0_9:GetPoolMgr():ClearDelegateEffect()

	arg0_9.delegateSelectEffectDic = nil
	arg0_9.delegateEffectDic = nil
	arg0_9.delegateSelect = nil
end

return var0_0

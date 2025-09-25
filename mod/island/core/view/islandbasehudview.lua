local var0_0 = class("IslandBaseHudView", import(".IslandBaseOpView"))

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.parent = arg0_1._tf:Find("parent")
	arg0_1.unitHudRoot = arg0_1._tf:Find("parent/unitHud")
	arg0_1.unitHudDic = {}
	arg0_1.views = {}

	arg0_1:SubViewInit()
end

function var0_0.SetUIParent(arg0_2, arg1_2)
	setParent(arg1_2, arg0_2:GetView().hudContainer)
end

function var0_0.GetSubView(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.views) do
		if isa(iter1_3, arg1_3) then
			return iter1_3
		end
	end

	return nil
end

function var0_0.OnUpdate(arg0_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.views) do
		iter1_4:Update()
	end
end

function var0_0.OnLateUpdate(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5.unitHudDic) do
		local var0_5 = arg0_5:UnitKey2unitData(iter0_5)
		local var1_5 = arg0_5:GetView():GetUnitModuleWithType(var0_5.type, var0_5.id)
		local var2_5 = var1_5 and var1_5._go or nil

		if var1_5 and not IsNil(var2_5) then
			local var3_5 = var2_5.transform.position + arg0_5:GetHeadOffset() * var2_5.transform.rotation
			local var4_5 = IslandCalcUtil.IsInViewport(var3_5)

			setActive(iter1_5, var4_5)

			if var4_5 then
				arg0_5:UpdateTplPosition(var2_5, iter1_5, var3_5)
			end
		end
	end
end

function var0_0.UpdateTplPosition(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = IslandCalcUtil.WorldPosition2LocalPosition(arg0_6.parent, arg3_6)

	arg2_6.transform.localPosition = var0_6
end

function var0_0.GetUnitHudRoot(arg0_7, arg1_7)
	local var0_7 = arg0_7.unitHudDic[arg1_7.key]

	if IsNil(var0_7) then
		var0_7 = Object.Instantiate(arg0_7.unitHudRoot, arg0_7.parent)
		var0_7.name = arg1_7.key

		setActive(var0_7, true)

		arg0_7.unitHudDic[arg1_7.key] = var0_7
	end

	return var0_7.transform
end

function var0_0.GenUnitData(arg0_8, arg1_8, arg2_8)
	return {
		id = arg1_8,
		type = arg2_8,
		key = arg2_8 .. "_" .. arg1_8
	}
end

function var0_0.UnitKey2unitData(arg0_9, arg1_9)
	local var0_9 = string.split(arg1_9, "_")

	return {
		id = tonumber(var0_9[2]),
		type = tonumber(var0_9[1])
	}
end

function var0_0.OnDispose(arg0_10)
	var0_0.super.OnDispose(arg0_10)

	for iter0_10, iter1_10 in pairs(arg0_10.unitHudDic) do
		Object.Destroy(iter1_10.gameObject)
	end

	arg0_10.unitHudDic = nil
end

function var0_0.SubViewInit(arg0_11)
	return
end

function var0_0.GetHeadOffset(arg0_12)
	assert(false, "overwrite me!!!!")
end

return var0_0

local var0_0 = class("IslandBottomHeadHudView", import(".IslandBaseHudView"))

function var0_0.GetUIName(arg0_1)
	return "IslandTopHeadHudUI"
end

function var0_0.GetHeadOffset(arg0_2)
	return Vector3(0.5, 1.5, 0)
end

function var0_0.OnInit(arg0_3, arg1_3)
	arg0_3.animationOpTpl = arg0_3._tf:Find("tpls/IslandNpcAnimationOpTpl")
	arg0_3.animationOpTpls = {}
	arg0_3.animationOpShowFlags = {}
	arg0_3.animationOpShowDistance = pg.island_set.action_bubble_range.key_value_int

	var0_0.super.OnInit(arg0_3, arg1_3)
end

function var0_0.OnLateUpdate(arg0_4)
	var0_0.super.OnLateUpdate(arg0_4)

	local var0_4 = arg0_4:GetView().player

	if var0_4 then
		for iter0_4, iter1_4 in ipairs(arg0_4.animationOpShowFlags) do
			local var1_4 = arg0_4.animationOpTpls[iter1_4]
			local var2_4 = arg0_4:UnitKey2unitData(iter1_4)
			local var3_4 = arg0_4:GetView():GetUnitModuleWithType(var2_4.type, var2_4.id)

			if var3_4 then
				local var4_4 = Vector3.Distance(var0_4._go.transform.position, var3_4._go.transform.position) <= arg0_4.animationOpShowDistance

				setActive(var1_4, var4_4)
			end
		end
	end
end

function var0_0.UpdateTplPosition(arg0_5, arg1_5, arg2_5, arg3_5)
	var0_0.super.UpdateTplPosition(arg0_5, arg1_5, arg2_5, arg3_5)

	local var0_5 = IslandCalcUtil.IsBehindCamera(arg1_5.transform.forward)

	arg2_5.transform.localScale = Vector3(var0_5 and -1 or 1, 1, 1)
	arg2_5.transform:Find("aniamtionOpContainer"):GetChild(0):Find("Image").localScale = Vector3(var0_5 and -1 or 1, 1, 1)
end

function var0_0.ShowAnimationOp(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6:GenUnitData(arg1_6.id, arg1_6.unitType)
	local var1_6 = arg0_6:GetUnitHudRoot(var0_6):Find("aniamtionOpContainer")
	local var2_6 = arg0_6.animationOpTpls[var0_6.key] or Object.Instantiate(arg0_6.animationOpTpl, var1_6)

	setParent(var2_6, var1_6)
	setActive(var2_6, true)

	local var3_6 = pg.island_action[arg2_6]

	assert(var3_6, "island_action>>>>" .. arg2_6)
	LoadImageSpriteAsync("island/IslandActionIcon/" .. var3_6.resource, var2_6.transform:Find("Image"), false)

	arg0_6.animationOpTpls[var0_6.key] = var2_6

	table.insert(arg0_6.animationOpShowFlags, var0_6.key)
	setActive(var2_6.transform:Find("effect"), false)
end

function var0_0.UpdateAnimationOpEffect(arg0_7, arg1_7, arg2_7)
	local var0_7, var1_7 = IslandCalcUtil.GetTypeAndIdByUniqueId(arg1_7)
	local var2_7 = arg0_7:GenUnitData(var1_7, var0_7)
	local var3_7 = arg0_7.animationOpTpls[var2_7.key]

	if not var3_7 then
		return
	end

	setActive(var3_7.transform:Find("effect"), arg2_7)
end

function var0_0.HideAnimationOp(arg0_8, arg1_8)
	local var0_8 = arg0_8:GenUnitData(arg1_8.id, arg1_8.unitType)

	table.removebyvalue(arg0_8.animationOpShowFlags, var0_8.key)

	local var1_8 = arg0_8.animationOpTpls[var0_8.key]

	if not var1_8 then
		return
	end

	setActive(var1_8, false)
	setActive(var1_8.transform:Find("effect"), false)
end

function var0_0.OnDispose(arg0_9)
	var0_0.super.OnDispose(arg0_9)

	for iter0_9, iter1_9 in pairs(arg0_9.animationOpTpls) do
		Object.Destroy(iter1_9)
	end

	arg0_9.animationOpTpls = nil
	arg0_9.animationOpShowFlags = nil
end

return var0_0

local var0_0 = class("IslandCancelAnimationOpView", import(".IslandBaseHudView"))

function var0_0.GetUIName(arg0_1)
	return "IslandTopHeadHudUI"
end

function var0_0.SetUIParent(arg0_2, arg1_2)
	return arg0_2:GetView().layer2OpContianer
end

function var0_0.GetHeadOffset(arg0_3)
	return Vector3(0, 1.8, 0)
end

function var0_0.OnInit(arg0_4, arg1_4)
	arg0_4.cancelAnimationOpTpl = arg0_4._tf:GetComponent(typeof(ItemList)).prefabItem[4]
	arg0_4.cancelAnimationOpTpls = {}

	var0_0.super.OnInit(arg0_4, arg1_4)
end

function var0_0.ShowCancelableAnimationOp(arg0_5, arg1_5)
	local var0_5 = arg0_5:GenUnitData(arg1_5.id, arg1_5.unitType)
	local var1_5 = arg0_5:GetUnitHudRoot(var0_5):Find("aniamtionOpContainer")
	local var2_5 = arg0_5.cancelAnimationOpTpls[var0_5.key] or Object.Instantiate(arg0_5.cancelAnimationOpTpl, var1_5)

	setParent(var2_5, var1_5)
	setActive(var2_5, true)

	arg0_5.cancelAnimationOpTpls[var0_5.key] = var2_5

	onButton(arg0_5, var2_5, function()
		arg0_5:NotifiyCore(ISLAND_EVT.CANCEL_COUPLE_ACTION)
	end, SFX_PANEL)
end

function var0_0.HideCancelableAnimationOp(arg0_7, arg1_7)
	local var0_7 = arg0_7:GenUnitData(arg1_7.id, arg1_7.unitType)
	local var1_7 = arg0_7.cancelAnimationOpTpls[var0_7.key]

	if not var1_7 then
		return
	end

	setActive(var1_7, false)
end

function var0_0.OnDispose(arg0_8)
	var0_0.super.OnDispose(arg0_8)

	for iter0_8, iter1_8 in pairs(arg0_8.cancelAnimationOpTpls) do
		Object.Destroy(iter1_8)
	end

	arg0_8.cancelAnimationOpTpls = nil
end

return var0_0

local var0_0 = class("IslandHudPanel", import("Mod.Island.Core.View.IslandBaseUnit"))

function var0_0.Init(arg0_1, ...)
	PoolMgr.GetInstance():GetUI(arg0_1:GetUIName(), true, function(arg0_2)
		arg0_1._go = arg0_2
		arg0_1._tf = arg0_2.transform

		var0_0.super.Init(arg0_1, arg0_2)
		setParent(arg0_2, arg0_1.parentTF)
		arg0_2.transform:SetAsFirstSibling()
	end)
end

function var0_0.Ctor(arg0_3, arg1_3, arg2_3)
	arg0_3.super.Ctor(arg0_3, arg2_3)

	arg0_3.parentTF = arg1_3

	arg0_3:InitHudHeight()
end

function var0_0.GetUIName(arg0_4)
	return "IslandCollectHud"
end

function var0_0.OnInit(arg0_5, arg1_5)
	assert(arg1_5)

	arg0_5._go = arg1_5
	arg0_5._tf = arg1_5.transform
	arg0_5.name = arg0_5._tf:Find("name_bg/name")
	arg0_5.productIcon = arg0_5._tf:Find("productIcon")
	arg0_5.timeTF = arg0_5._tf:Find("process/layout/time")
	arg0_5.energyTF = arg0_5._tf:Find("process/layout/enrgy_bar")
	arg0_5.numProcessTF = arg0_5._tf:Find("name_bg/name/numer")
	arg0_5.timeMgr = pg.TimeMgr.GetInstance()

	arg0_5:UpdateHudDisplay()
end

function var0_0.InitHudHeight(arg0_6)
	arg0_6.heightUnitDic = {}

	local var0_6 = pg.island_set.information_hud_height.key_value_varchar[2]

	for iter0_6, iter1_6 in pairs(pg.island_set.information_hud_height.key_value_varchar[1]) do
		arg0_6.heightUnitDic[iter1_6] = var0_6
	end
end

function var0_0.ShowUnitHud(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7.unitId = arg1_7
	arg0_7.position = pg.island_world_objects[arg0_7.unitId].param.position
	arg0_7.height = arg3_7 or 1

	arg0_7:UpdateUnitHud(arg2_7)
end

function var0_0.UpdateUnitHud(arg0_8, arg1_8)
	arg0_8.hudInfo = arg1_8

	if arg0_8:IsLoaded() then
		arg0_8:UpdateHudDisplay()
	end
end

function var0_0.UpdateHudDisplay(arg0_9)
	setActive(arg0_9._tf, arg0_9.active)

	if arg0_9.hudInfo.name then
		setActive(arg0_9.name, true)
		setText(arg0_9.name, arg0_9.hudInfo.name)
	else
		setActive(arg0_9.name, false)
	end

	if arg0_9.hudInfo.hudState then
		local var0_9 = arg0_9.hudInfo.hudState

		setActive(arg0_9.timeTF, true)

		if var0_9.stateEndTime then
			arg0_9:UpdateTime(var0_9)
		else
			setText(arg0_9.timeTF, var0_9.stateText)
		end
	else
		setActive(arg0_9.timeTF, false)
	end

	if arg0_9.hudInfo.process then
		setActive(arg0_9.energyTF, true)
		setSlider(arg0_9.energyTF, 0, 1, arg0_9.hudInfo.process)
	else
		setActive(arg0_9.energyTF, false)
	end

	if arg0_9.hudInfo.numProcess then
		setActive(arg0_9.numProcessTF, true)
		setText(arg0_9.numProcessTF, arg0_9.hudInfo.numProcess)
	else
		setActive(arg0_9.numProcessTF, false)
	end

	if arg0_9.hudInfo.itemIcon then
		GetImageSpriteFromAtlasAsync(arg0_9.hudInfo.itemIcon, "", arg0_9.productIcon)
	end
end

function var0_0.HideHud(arg0_10)
	if arg0_10._tf then
		setActive(arg0_10._tf, false)

		arg0_10.active = false
	end
end

function var0_0.UpdateTime(arg0_11, arg1_11)
	if not arg1_11 then
		return
	end

	if arg1_11.stateEndTime then
		local var0_11 = arg1_11.stateEndTime - arg0_11.timeMgr:GetServerTime()

		if var0_11 > 0 then
			setText(arg0_11.timeTF, arg0_11.timeMgr:DescCDTime(var0_11))
		end
	end
end

function var0_0.Update(arg0_12)
	if not arg0_12:IsLoaded() then
		return
	end

	arg0_12:UpdateTime(arg0_12.hudInfo.hudState)
end

function var0_0.LateUpdate(arg0_13)
	if not arg0_13:IsLoaded() then
		return
	end

	local var0_13 = Vector3(arg0_13.position[1], arg0_13.position[2], arg0_13.position[3]) + Vector3(0, arg0_13.height, 0)

	if not IslandCalcUtil.IsInViewport(var0_13) then
		setActive(arg0_13._tf, false)
	else
		setActive(arg0_13._tf, true)

		local var1_13 = IslandCalcUtil.WorldPosition2LocalPosition(arg0_13.parentTF, var0_13)

		arg0_13._tf.localPosition = var1_13
	end
end

function var0_0.OnDispose(arg0_14)
	PoolMgr.GetInstance():ReturnUI(arg0_14:GetUIName(), arg0_14._go)
end

function var0_0.Clear(arg0_15)
	return
end

return var0_0

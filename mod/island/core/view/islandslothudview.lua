local var0_0 = class("IslandSlotHudView", import(".IslandBaseOpView"))
local var1_0 = 4

function var0_0.GetUIName(arg0_1)
	return "IslandSlotHudUI"
end

function var0_0.GetUIParent(arg0_2, arg1_2)
	return arg0_2:GetView().hudContainer
end

function var0_0.OnInit(arg0_3, arg1_3)
	arg0_3._go = arg1_3
	arg0_3._tf = arg1_3.transform
	arg0_3.parent = arg0_3._tf:Find("look")
	arg0_3.hideHudDic = {}
	arg0_3.unitHideHudQueue = {}
end

function var0_0.Update(arg0_4)
	if arg0_4.currentHud then
		arg0_4.currentHud:Update()
	end
end

function var0_0.LateUpdate(arg0_5)
	if arg0_5.currentHud then
		arg0_5.currentHud:LateUpdate()
	end
end

function var0_0.ShowHud(arg0_6, arg1_6, arg2_6)
	if arg1_6 == nil then
		return
	end

	if arg0_6.currentHud then
		if arg0_6.currentHud.unitId == arg1_6 then
			return
		end

		arg0_6:HideUnitHud(arg0_6.currentHud.unitId)
	end

	arg0_6:ShowUnitHud(arg1_6, arg2_6)
end

function var0_0.UpdateHud(arg0_7, arg1_7, arg2_7)
	if arg1_7 == nil then
		return
	end

	local var0_7 = arg0_7.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_7)

	if not var0_7 then
		return
	end

	local var1_7 = var0_7:GetHudInfo()

	if not arg0_7.currentHud then
		arg0_7:ShowUnitHud(arg1_7, arg2_7)

		return
	end

	if arg0_7.currentHud.unitId == arg1_7 then
		arg0_7.currentHud:UpdateUnitHud(var1_7)
	end
end

function var0_0.HideUnitHud(arg0_8, arg1_8)
	if not arg0_8.currentHud then
		return
	end

	if arg0_8.currentHud.unitId == arg1_8 then
		arg0_8.currentHud:HideHud()
		arg0_8:InPool(arg0_8.currentHud)

		arg0_8.currentHud = nil
	end
end

function var0_0.InPool(arg0_9, arg1_9)
	local var0_9

	for iter0_9, iter1_9 in ipairs(arg0_9.unitHideHudQueue) do
		if iter1_9 == arg1_9.unitId then
			var0_9 = iter0_9
		end
	end

	if var0_9 then
		table.remove(arg0_9.unitHideHudQueue, var0_9)
	end

	table.insert(arg0_9.unitHideHudQueue, arg1_9.unitId)

	arg0_9.hideHudDic[arg1_9.unitId] = arg1_9

	if #arg0_9.unitHideHudQueue > var1_0 then
		local var1_9 = arg0_9.unitHideHudQueue[1]

		table.remove(arg0_9.unitHideHudQueue, 1)
		arg0_9.hideHudDic[var1_9]:Dispose()

		arg0_9.hideHudDic[var1_9] = nil
	end
end

function var0_0.ShowUnitHud(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_10):GetHudInfo()

	if arg0_10.hideHudDic[arg1_10] then
		arg0_10.currentHud = arg0_10.hideHudDic[arg1_10]

		arg0_10.currentHud:ShowUnitHud(arg1_10, var0_10, arg2_10)
	else
		if not arg0_10.currentHud then
			arg0_10.currentHud = IslandHudPanel.New(arg0_10.parent, arg0_10.view)

			arg0_10.currentHud:ShowUnitHud(arg1_10, var0_10, arg2_10)
			arg0_10.currentHud:Init()

			return
		end

		arg0_10.currentHud:ShowUnitHud(arg1_10, var0_10, arg2_10)
	end
end

function var0_0.OnDestroy(arg0_11)
	return
end

return var0_0

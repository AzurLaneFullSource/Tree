local var0_0 = class("IslandSlotHudView", import(".IslandBaseOpView"))
local var1_0 = 4

function var0_0.GetUIName(arg0_1)
	return "IslandSlotHudUI"
end

function var0_0.OnInit(arg0_2, arg1_2)
	arg0_2._go = arg1_2
	arg0_2._tf = arg1_2.transform
	arg0_2.parent = arg0_2._tf:Find("look")
	arg0_2.hideHudDic = {}
	arg0_2.unitHideHudQueue = {}
end

function var0_0.Update(arg0_3)
	if arg0_3.currentHud then
		arg0_3.currentHud:Update()
	end
end

function var0_0.LateUpdate(arg0_4)
	if arg0_4.currentHud then
		arg0_4.currentHud:LateUpdate()
	end
end

function var0_0.ShowHud(arg0_5, arg1_5, arg2_5)
	if arg1_5 == nil then
		return
	end

	if arg0_5.currentHud then
		if arg0_5.currentHud.unitId == arg1_5 then
			return
		end

		arg0_5:HideUnitHud(arg0_5.currentHud.unitId)
	end

	arg0_5:ShowUnitHud(arg1_5, arg2_5)
end

function var0_0.UpdateHud(arg0_6, arg1_6)
	if arg1_6 == nil then
		return
	end

	local var0_6 = arg0_6.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_6)

	if not var0_6 then
		return
	end

	local var1_6 = var0_6:GetHudInfo()

	if not arg0_6.currentHud then
		return
	end

	if arg0_6.currentHud.unitId == arg1_6 then
		arg0_6.currentHud:UpdateUnitHud(var1_6)
	end
end

function var0_0.HideUnitHud(arg0_7, arg1_7)
	if not arg0_7.currentHud then
		return
	end

	if arg0_7.currentHud.unitId == arg1_7 then
		arg0_7.currentHud:HideHud()
		arg0_7:InPool(arg0_7.currentHud)

		arg0_7.currentHud = nil
	end
end

function var0_0.InPool(arg0_8, arg1_8)
	local var0_8

	for iter0_8, iter1_8 in ipairs(arg0_8.unitHideHudQueue) do
		if iter1_8 == arg1_8.unitId then
			var0_8 = iter0_8
		end
	end

	if var0_8 then
		table.remove(arg0_8.unitHideHudQueue, var0_8)
	end

	table.insert(arg0_8.unitHideHudQueue, arg1_8.unitId)

	arg0_8.hideHudDic[arg1_8.unitId] = arg1_8

	if #arg0_8.unitHideHudQueue > var1_0 then
		local var1_8 = arg0_8.unitHideHudQueue[1]

		table.remove(arg0_8.unitHideHudQueue, 1)
		arg0_8.hideHudDic[var1_8]:Dispose()

		arg0_8.hideHudDic[var1_8] = nil
	end
end

function var0_0.ShowUnitHud(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_9):GetHudInfo()

	if arg0_9.hideHudDic[arg1_9] then
		arg0_9.currentHud = arg0_9.hideHudDic[arg1_9]

		arg0_9.currentHud:ShowUnitHud(arg1_9, var0_9, arg2_9)
	else
		if not arg0_9.currentHud then
			arg0_9.currentHud = IslandHudPanel.New(arg0_9.parent, arg0_9.view)

			arg0_9.currentHud:ShowUnitHud(arg1_9, var0_9, arg2_9)
			arg0_9.currentHud:Init()

			return
		end

		arg0_9.currentHud:ShowUnitHud(arg1_9, var0_9, arg2_9)
	end
end

function var0_0.OnDestroy(arg0_10)
	return
end

return var0_0

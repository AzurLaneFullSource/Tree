local var0 = class("CommanderHomeSelCommanderPage", import(".CommanderHomeBaseSelPage"))

function var0.getUIName(arg0)
	return "CommanderHomeSelCommanderPage"
end

function var0.OnCatteryUpdate(arg0, arg1)
	arg0.cattery = arg1

	arg0:Update(arg0.home, arg1)
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.selectedID = -1

	onButton(arg0, arg0.okBtn, function()
		if arg0.selectedID >= 0 then
			arg0:emit(CommanderHomeMediator.ON_SEL_COMMANDER, arg0.cattery.id, arg0.selectedID)
		end
	end, SFX_PANEL)
end

function var0.OnSelected(arg0, arg1)
	if arg1.commanderVO then
		local var0 = arg1.commanderVO.id
		local var1, var2 = arg0:Check(var0)

		if var1 then
			if arg0.mark then
				setActive(arg0.mark, false)
			end

			if arg0.selectedID == var0 then
				arg0.selectedID = 0
				arg0.mark = nil

				arg0:emit(CatteryDescPage.CHANGE_COMMANDER, nil)
			else
				setActive(arg1.mark2, true)

				arg0.mark = arg1.mark2
				arg0.selectedID = var0

				arg0:emit(CatteryDescPage.CHANGE_COMMANDER, arg1.commanderVO)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(var2)
		end
	end
end

function var0.Check(arg0, arg1)
	local var0 = arg0.home:GetCatteries()

	for iter0, iter1 in ipairs(var0) do
		if iter1:GetCommanderId() == arg1 and iter1.id ~= arg0.cattery.id then
			return false, i18n("commander_is_in_cattery")
		end
	end

	return true
end

function var0.CheckIncludeSelf(arg0, arg1)
	local var0 = arg0.home:GetCatteries()

	for iter0, iter1 in ipairs(var0) do
		if iter1:GetCommanderId() == arg1 then
			return false
		end
	end

	return true
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	var0.super.OnUpdateItem(arg0, arg1, arg2)

	local var0 = arg1 + 1
	local var1 = arg0.displays[var0]
	local var2 = arg0.cards[arg2]

	if var1 then
		local var3 = arg0.selectedID == var1.id

		setActive(var2.mark2, var3)

		if var3 then
			arg0.mark = var2.mark2
		end

		local var4 = arg0:CheckIncludeSelf(var1.id)

		setActive(var2._tf:Find("info/home"), not var4)
	end
end

function var0.Update(arg0, arg1, arg2)
	arg0:Show()

	arg0.home = arg1
	arg0.cattery = arg2

	local var0 = arg2:GetCommanderId()

	if var0 ~= 0 then
		arg0.selectedID = var0
	end

	var0.super.Update(arg0)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)

	arg0.selectedID = -1
	arg0.mark = nil
end

return var0

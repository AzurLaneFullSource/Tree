local var0_0 = class("CommanderHomeSelCommanderPage", import(".CommanderHomeBaseSelPage"))

function var0_0.getUIName(arg0_1)
	return "CommanderHomeSelCommanderPage"
end

function var0_0.OnCatteryUpdate(arg0_2, arg1_2)
	arg0_2.cattery = arg1_2

	arg0_2:Update(arg0_2.home, arg1_2)
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)

	arg0_3.selectedID = -1

	onButton(arg0_3, arg0_3.okBtn, function()
		if arg0_3.selectedID >= 0 then
			arg0_3:emit(CommanderHomeMediator.ON_SEL_COMMANDER, arg0_3.cattery.id, arg0_3.selectedID)
		end
	end, SFX_PANEL)
end

function var0_0.OnSelected(arg0_5, arg1_5)
	if arg1_5.commanderVO then
		local var0_5 = arg1_5.commanderVO.id
		local var1_5, var2_5 = arg0_5:Check(var0_5)

		if var1_5 then
			if arg0_5.mark then
				setActive(arg0_5.mark, false)
			end

			if arg0_5.selectedID == var0_5 then
				arg0_5.selectedID = 0
				arg0_5.mark = nil

				arg0_5:emit(CatteryDescPage.CHANGE_COMMANDER, nil)
			else
				setActive(arg1_5.mark2, true)

				arg0_5.mark = arg1_5.mark2
				arg0_5.selectedID = var0_5

				arg0_5:emit(CatteryDescPage.CHANGE_COMMANDER, arg1_5.commanderVO)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(var2_5)
		end
	end
end

function var0_0.Check(arg0_6, arg1_6)
	local var0_6 = arg0_6.home:GetCatteries()

	for iter0_6, iter1_6 in ipairs(var0_6) do
		if iter1_6:GetCommanderId() == arg1_6 and iter1_6.id ~= arg0_6.cattery.id then
			return false, i18n("commander_is_in_cattery")
		end
	end

	return true
end

function var0_0.CheckIncludeSelf(arg0_7, arg1_7)
	local var0_7 = arg0_7.home:GetCatteries()

	for iter0_7, iter1_7 in ipairs(var0_7) do
		if iter1_7:GetCommanderId() == arg1_7 then
			return false
		end
	end

	return true
end

function var0_0.OnUpdateItem(arg0_8, arg1_8, arg2_8)
	var0_0.super.OnUpdateItem(arg0_8, arg1_8, arg2_8)

	local var0_8 = arg1_8 + 1
	local var1_8 = arg0_8.displays[var0_8]
	local var2_8 = arg0_8.cards[arg2_8]

	if var1_8 then
		local var3_8 = arg0_8.selectedID == var1_8.id

		setActive(var2_8.mark2, var3_8)

		if var3_8 then
			arg0_8.mark = var2_8.mark2
		end

		local var4_8 = arg0_8:CheckIncludeSelf(var1_8.id)

		setActive(var2_8._tf:Find("info/home"), not var4_8)
	end
end

function var0_0.Update(arg0_9, arg1_9, arg2_9)
	arg0_9:Show()

	arg0_9.home = arg1_9
	arg0_9.cattery = arg2_9

	local var0_9 = arg2_9:GetCommanderId()

	if var0_9 ~= 0 then
		arg0_9.selectedID = var0_9
	end

	var0_0.super.Update(arg0_9)
end

function var0_0.Hide(arg0_10)
	var0_0.super.Hide(arg0_10)

	arg0_10.selectedID = -1
	arg0_10.mark = nil
end

return var0_0

local var0_0 = class("DALptPage", import("view.activity.CorePage.CorePageNewPtTemplatePage"))

function var0_0.UpdateAward(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg1_1 + 1
	local var1_1 = arg0_1.awardList[var0_1].drop

	updateDrop(arg2_1:Find("icon"), var1_1)
	setText(arg2_1:Find("pt"), arg0_1.awardList[var0_1].target)

	local var2_1 = var0_1 <= arg0_1.ptData:GetLevel()
	local var3_1 = not var2_1 and var0_1 <= arg0_1.ptData:GetMaxAvailableTargetIndex()
	local var4_1 = not var2_1 and not var3_1

	setActive(arg2_1:Find("got"), var2_1)
	setActive(arg2_1:Find("get"), var3_1)
	setActive(arg2_1:Find("lock"), not var4_1)
	setActive(arg2_1:Find("lock/lock"), var4_1)
	onButton(arg0_1, arg2_1, function()
		arg0_1:emit(BaseUI.ON_DROP, var1_1)
	end, SFX_PANEL)
end

return var0_0

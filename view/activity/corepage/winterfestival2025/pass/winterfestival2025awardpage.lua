local var0_0 = class("WinterFestival2025AwardPage", import("...PSS.Hei5.PSSHei5AwardPage"))

function var0_0.getUIName(arg0_1)
	return "WinterFestival2025AwardPage"
end

function var0_0.initTplVar(arg0_2)
	arg0_2.btnAllTip = "winter_cruise_btn_all"
end

function var0_0.UpdateAwardInfo(arg0_3, arg1_3, arg2_3, arg3_3)
	if arg3_3.id < 10 then
		setText(arg2_3:Find("Text"), "0" .. arg3_3.id)
	else
		setText(arg2_3:Find("Text"), arg3_3.id)
	end

	local var0_3 = arg3_3.pt <= arg0_3.pt
	local var1_3 = Drop.Create(arg3_3.award)

	onButton(arg0_3, arg2_3:Find("base"), function()
		arg0_3:emit(BaseUI.ON_NEW_STYLE_DROP, {
			drop = var1_3
		})
	end, SFX_CONFIRM)
	setActive(arg2_3:Find("base/lock"), not var0_3)
	updateDrop(arg2_3:Find("base/mask/IconTpl"), var1_3)
	setActive(arg2_3:Find("base/get"), var0_3 and not arg0_3.awardDic[arg3_3.pt])
	setActive(arg2_3:Find("base/got"), arg0_3.awardDic[arg3_3.pt])

	local var2_3 = Drop.Create(arg3_3.award_pay)

	onButton(arg0_3, arg2_3:Find("pay"), function()
		arg0_3:emit(BaseUI.ON_NEW_STYLE_DROP, {
			drop = var2_3
		})
	end, SFX_CONFIRM)
	updateDrop(arg2_3:Find("pay/mask/IconTpl"), var2_3)
	setActive(arg2_3:Find("pay/no_pay"), not var0_3 or not arg0_3.isPay)
	setActive(arg2_3:Find("pay/get"), arg0_3.isPay and var0_3 and not arg0_3.awardPayDic[arg3_3.pt])
	setActive(arg2_3:Find("pay/got"), arg0_3.awardPayDic[arg3_3.pt])
end

return var0_0

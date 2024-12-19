local var0_0 = class("BlackFridayWithManualSignPage_2024", import(".BlackFridayWithManualSignPage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)
	setActive(arg0_1.shopBtn, false)
	setText(arg0_1._tf:Find("AD/signMask/Image/Text"), i18n("challenge_end_tip"))
end

function var0_0.FlushSignBtn(arg0_2)
	var0_0.super.FlushSignBtn(arg0_2)

	local var0_2 = getProxy(ActivityProxy):getActivityById(arg0_2.signInActId)
	local var1_2 = not var0_2 or var0_2:isEnd()

	setActive(arg0_2._tf:Find("AD/signMask"), var1_2)
end

return var0_0

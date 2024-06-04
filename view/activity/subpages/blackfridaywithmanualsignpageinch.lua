local var0 = class("BlackFridayWithManualSignPageInCH", import(".BlackFridayWithManualSignPage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	setText(arg0._tf:Find("AD/signMask/Image/Text"), i18n("challenge_end_tip"))
end

function var0.FlushSignBtn(arg0)
	var0.super.FlushSignBtn(arg0)

	local var0 = getProxy(ActivityProxy):getActivityById(arg0.signInActId)
	local var1 = not var0 or var0:isEnd()

	setActive(arg0._tf:Find("AD/signMask"), var1)
end

return var0

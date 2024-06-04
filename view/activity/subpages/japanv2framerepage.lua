local var0 = class("JapanV2frameRePage", import(".TemplatePage.NewFrameTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.gotTag = arg0:findTF("AD/switcher/phase2/got")
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity.data1
	local var1 = arg0.avatarConfig.target

	var0 = var1 < var0 and var1 or var0

	local var2 = var0 / var1

	setText(arg0.cur, var2 >= 1 and setColorStr(var0, "#487CFFFF") or var0)
	setText(arg0.target, "/" .. var1)
	setFillAmount(arg0.bar, var2)

	local var3 = var1 <= var0
	local var4 = arg0.activity.data2 >= 1

	setActive(arg0.battleBtn, arg0.inPhase2 and not var3)
	setActive(arg0.getBtn, arg0.inPhase2 and not var4 and var3)
	setActive(arg0.gotBtn, arg0.inPhase2 and var4)
	setActive(arg0.gotTag, arg0.inPhase2 and var4)
	setActive(arg0.cur, not var4)
	setActive(arg0.target, not var4)
end

return var0

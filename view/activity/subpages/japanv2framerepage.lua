local var0_0 = class("JapanV2frameRePage", import(".TemplatePage.NewFrameTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.gotTag = arg0_1:findTF("AD/switcher/phase2/got")
end

function var0_0.OnUpdateFlush(arg0_2)
	local var0_2 = arg0_2.activity.data1
	local var1_2 = arg0_2.avatarConfig.target

	var0_2 = var1_2 < var0_2 and var1_2 or var0_2

	local var2_2 = var0_2 / var1_2

	setText(arg0_2.cur, var2_2 >= 1 and setColorStr(var0_2, "#487CFFFF") or var0_2)
	setText(arg0_2.target, "/" .. var1_2)
	setFillAmount(arg0_2.bar, var2_2)

	local var3_2 = var1_2 <= var0_2
	local var4_2 = arg0_2.activity.data2 >= 1

	setActive(arg0_2.battleBtn, arg0_2.inPhase2 and not var3_2)
	setActive(arg0_2.getBtn, arg0_2.inPhase2 and not var4_2 and var3_2)
	setActive(arg0_2.gotBtn, arg0_2.inPhase2 and var4_2)
	setActive(arg0_2.gotTag, arg0_2.inPhase2 and var4_2)
	setActive(arg0_2.cur, not var4_2)
	setActive(arg0_2.target, not var4_2)
end

return var0_0

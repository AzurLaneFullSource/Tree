local var0_0 = class("DexiV6FramePage", import(".TemplatePage.NewFrameTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.battleBtn = arg0_1:findTF("battle_btn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("get_btn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("got_btn", arg0_1.bg)
	arg0_1.switchBtn = arg0_1:findTF("AD/switch_btn")
	arg0_1.phases = {
		arg0_1:findTF("AD/switcher/phase1"),
		arg0_1:findTF("AD/switcher/phase2")
	}
	arg0_1.bar = arg0_1:findTF("AD/switcher/phase2/Image/barContent/bar")
	arg0_1.cur = arg0_1:findTF("AD/switcher/phase2/Image/step")
	arg0_1.gotTag = arg0_1:findTF("AD/switcher/phase2/Image/got")
	arg0_1.getTag = arg0_1:findTF("AD/switcher/phase2/Image/get")
end

function var0_0.OnUpdateFlush(arg0_2)
	local var0_2 = arg0_2.activity.data1
	local var1_2 = arg0_2.avatarConfig.target

	var0_2 = var1_2 < var0_2 and var1_2 or var0_2

	local var2_2 = var0_2 / var1_2

	setText(arg0_2.cur, (var2_2 >= 1 and setColorStr(var0_2, COLOR_GREEN) or setColorStr(var0_2, "#81CBD0")) .. setColorStr("/" .. var1_2, "#1AB3B1"))
	setFillAmount(arg0_2.bar, var2_2)

	local var3_2 = var1_2 <= var0_2
	local var4_2 = arg0_2.activity.data2 >= 1

	setActive(arg0_2.battleBtn, arg0_2.inPhase2 and not var3_2)
	setActive(arg0_2.getBtn, arg0_2.inPhase2 and not var4_2 and var3_2)
	setActive(arg0_2.gotBtn, arg0_2.inPhase2 and var4_2)
	setActive(arg0_2.gotTag, arg0_2.inPhase2 and var4_2)
	setActive(arg0_2.getTag, arg0_2.inPhase2 and not var4_2 and var3_2)
	setActive(arg0_2.cur, not var4_2)
end

return var0_0

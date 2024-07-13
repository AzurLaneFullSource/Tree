local var0_0 = class("DexiV4FrameReRePage", import(".TemplatePage.NewFrameTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.super.OnInit(arg0_1)

	arg0_1.redDot = arg0_1:findTF("AD/switcher/phase2/Image/red")
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.battleBtn, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.getBtn, function()
		arg0_2:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_2.activity.id
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_5)
	local var0_5 = arg0_5.activity.data1
	local var1_5 = arg0_5.avatarConfig.target

	var0_5 = var1_5 < var0_5 and var1_5 or var0_5

	local var2_5 = var0_5 / var1_5

	setText(arg0_5.cur, var2_5 >= 1 and setColorStr(var0_5, COLOR_GREEN) or var0_5)
	setText(arg0_5.target, "/" .. var1_5)
	setFillAmount(arg0_5.bar, var2_5)

	local var3_5 = var1_5 <= var0_5
	local var4_5 = arg0_5.activity.data2 >= 1

	setActive(arg0_5.battleBtn, not var3_5)
	setActive(arg0_5.getBtn, not var4_5 and var3_5)
	setActive(arg0_5.gotBtn, var4_5)
	setActive(arg0_5.gotTag, var4_5)
	setActive(arg0_5.redDot, arg0_5.activity:readyToAchieve())
end

return var0_0

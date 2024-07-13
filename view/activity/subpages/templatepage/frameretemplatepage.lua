local var0_0 = class("FrameReTemplatePage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.battleBtn = arg0_1:findTF("battle_btn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("get_btn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("got_btn", arg0_1.bg)
	arg0_1.bar = arg0_1:findTF("frame/bar", arg0_1.bg)
	arg0_1.step = arg0_1:findTF("frame/step", arg0_1.bg)
	arg0_1.progress = arg0_1:findTF("frame/progress", arg0_1.bg)
	arg0_1.frameGot = arg0_1:findTF("frame/got", arg0_1.bg)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.avatarConfig = pg.activity_event_avatarframe[arg0_2.activity:getConfig("config_id")]
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.battleBtn, function()
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		arg0_3:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_3.activity.id
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_6)
	local var0_6 = arg0_6.activity.data1
	local var1_6 = arg0_6.avatarConfig.target

	var0_6 = var1_6 < var0_6 and var1_6 or var0_6

	local var2_6 = var0_6 / var1_6

	setText(arg0_6.step, var2_6 >= 1 and setColorStr(var0_6, COLOR_GREEN) or var0_6)
	setText(arg0_6.progress, "/" .. var1_6)
	setFillAmount(arg0_6.bar, var2_6)

	local var3_6 = var1_6 <= var0_6
	local var4_6 = arg0_6.activity.data2 >= 1

	setActive(arg0_6.battleBtn, not var3_6)
	setActive(arg0_6.getBtn, not var4_6 and var3_6)
	setActive(arg0_6.gotBtn, var4_6)
	setActive(arg0_6.frameGot, var4_6)
end

return var0_0

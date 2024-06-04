local var0 = class("FrameReTemplatePage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.battleBtn = arg0:findTF("battle_btn", arg0.bg)
	arg0.getBtn = arg0:findTF("get_btn", arg0.bg)
	arg0.gotBtn = arg0:findTF("got_btn", arg0.bg)
	arg0.bar = arg0:findTF("frame/bar", arg0.bg)
	arg0.step = arg0:findTF("frame/step", arg0.bg)
	arg0.progress = arg0:findTF("frame/progress", arg0.bg)
	arg0.frameGot = arg0:findTF("frame/got", arg0.bg)
end

function var0.OnDataSetting(arg0)
	arg0.avatarConfig = pg.activity_event_avatarframe[arg0.activity:getConfig("config_id")]
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		arg0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0.activity.id
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity.data1
	local var1 = arg0.avatarConfig.target

	var0 = var1 < var0 and var1 or var0

	local var2 = var0 / var1

	setText(arg0.step, var2 >= 1 and setColorStr(var0, COLOR_GREEN) or var0)
	setText(arg0.progress, "/" .. var1)
	setFillAmount(arg0.bar, var2)

	local var3 = var1 <= var0
	local var4 = arg0.activity.data2 >= 1

	setActive(arg0.battleBtn, not var3)
	setActive(arg0.getBtn, not var4 and var3)
	setActive(arg0.gotBtn, var4)
	setActive(arg0.frameGot, var4)
end

return var0

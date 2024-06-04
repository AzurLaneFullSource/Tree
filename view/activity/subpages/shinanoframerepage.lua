local var0 = class("ShinanoframeRePage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.goBtn = arg0:findTF("GoBtn", arg0.bg)
	arg0.getBtn = arg0:findTF("GetBtn", arg0.bg)
	arg0.gotBtn = arg0:findTF("GotBtn", arg0.bg)
	arg0.gotTag = arg0:findTF("got", arg0.bg)
	arg0.cur = arg0:findTF("cur", arg0.bg)
	arg0.max = arg0:findTF("max", arg0.bg)
	arg0.progressBar = arg0:findTF("progress", arg0.bg)

	setActive(arg0.goBtn, false)
	setActive(arg0.getBtn, false)
	setActive(arg0.gotBtn, false)
	setActive(arg0.gotTag, false)
end

function var0.OnDataSetting(arg0)
	return
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.goBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {})
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		arg0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0.activity.id
		})
	end, SFX_PANEL)

	local var0 = pg.activity_event_avatarframe[arg0.activity:getConfig("config_id")].icon_frame
	local var1 = LoadAndInstantiateSync("IconFrame", var0)

	setParent(var1, findTF(arg0.bg, "icon"), false)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity.data1
	local var1 = pg.activity_event_avatarframe[arg0.activity:getConfig("config_id")].target

	if var1 < var0 then
		var0 = var1
	end

	local var2 = var0 / var1

	setText(arg0.cur, var0)
	setText(arg0.max, "/" .. var1)
	setSlider(arg0.progressBar, 0, 1, var2)
	setActive(arg0.progressBar, true)

	local var3 = var1 <= var0
	local var4 = arg0.activity.data2 >= 1

	setActive(arg0.goBtn, not var3)
	setActive(arg0.getBtn, not var4 and var3)
	setActive(arg0.gotBtn, var4)
	setActive(arg0.gotTag, var4)
end

function var0.OnDestroy(arg0)
	return
end

return var0

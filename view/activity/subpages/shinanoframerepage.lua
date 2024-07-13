local var0_0 = class("ShinanoframeRePage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.goBtn = arg0_1:findTF("GoBtn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("GetBtn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("GotBtn", arg0_1.bg)
	arg0_1.gotTag = arg0_1:findTF("got", arg0_1.bg)
	arg0_1.cur = arg0_1:findTF("cur", arg0_1.bg)
	arg0_1.max = arg0_1:findTF("max", arg0_1.bg)
	arg0_1.progressBar = arg0_1:findTF("progress", arg0_1.bg)

	setActive(arg0_1.goBtn, false)
	setActive(arg0_1.getBtn, false)
	setActive(arg0_1.gotBtn, false)
	setActive(arg0_1.gotTag, false)
end

function var0_0.OnDataSetting(arg0_2)
	return
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.goBtn, function()
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		arg0_3:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_3.activity.id
		})
	end, SFX_PANEL)

	local var0_3 = pg.activity_event_avatarframe[arg0_3.activity:getConfig("config_id")].icon_frame
	local var1_3 = LoadAndInstantiateSync("IconFrame", var0_3)

	setParent(var1_3, findTF(arg0_3.bg, "icon"), false)
end

function var0_0.OnUpdateFlush(arg0_6)
	local var0_6 = arg0_6.activity.data1
	local var1_6 = pg.activity_event_avatarframe[arg0_6.activity:getConfig("config_id")].target

	if var1_6 < var0_6 then
		var0_6 = var1_6
	end

	local var2_6 = var0_6 / var1_6

	setText(arg0_6.cur, var0_6)
	setText(arg0_6.max, "/" .. var1_6)
	setSlider(arg0_6.progressBar, 0, 1, var2_6)
	setActive(arg0_6.progressBar, true)

	local var3_6 = var1_6 <= var0_6
	local var4_6 = arg0_6.activity.data2 >= 1

	setActive(arg0_6.goBtn, not var3_6)
	setActive(arg0_6.getBtn, not var4_6 and var3_6)
	setActive(arg0_6.gotBtn, var4_6)
	setActive(arg0_6.gotTag, var4_6)
end

function var0_0.OnDestroy(arg0_7)
	return
end

return var0_0

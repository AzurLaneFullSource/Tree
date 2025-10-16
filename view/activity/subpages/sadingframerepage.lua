local var0_0 = class("SaDingFrameRePage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.battleBtn = arg0_1.bg:Find("battle_btn")
	arg0_1.getBtn = arg0_1.bg:Find("get_btn")
	arg0_1.gotBtn = arg0_1.bg:Find("got_btn")
	arg0_1.bar = GetComponent(arg0_1._tf:Find("AD/switcher/phase2/barContent"), typeof(Slider))
	arg0_1.cur = arg0_1._tf:Find("AD/switcher/phase2/progress/step")
	arg0_1.target = arg0_1._tf:Find("AD/switcher/phase2/progress/all")
	arg0_1.getTag = arg0_1._tf:Find("AD/switcher/phase2/get")
	arg0_1.gotTag = arg0_1._tf:Find("AD/switcher/phase2/got")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.avatarConfig = pg.activity_event_avatarframe[arg0_2.activity:getConfig("config_id")]

	local var0_2 = arg0_2.avatarConfig.start_time

	if var0_2 == "stop" then
		arg0_2.timeStamp = nil
	else
		arg0_2.timeStamp = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_2)
	end
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

	arg0_3.inPhase2 = arg0_3.timeStamp and pg.TimeMgr.GetInstance():GetServerTime() - arg0_3.timeStamp > 0
end

function var0_0.OnUpdateFlush(arg0_6)
	local var0_6 = arg0_6.activity.data1
	local var1_6 = arg0_6.avatarConfig.target

	var0_6 = var1_6 < var0_6 and var1_6 or var0_6

	local var2_6 = var0_6 / var1_6

	setText(arg0_6.cur, var2_6 >= 1 and setColorStr(var0_6, COLOR_GREEN) or var0_6)
	setText(arg0_6.target, "/" .. var1_6)
	setSlider(arg0_6.bar, 0, var1_6, var0_6)

	local var3_6 = var1_6 <= var0_6
	local var4_6 = arg0_6.activity.data2 >= 1

	setActive(arg0_6.battleBtn, arg0_6.inPhase2 and not var3_6)
	setActive(arg0_6.getBtn, arg0_6.inPhase2 and not var4_6 and var3_6)
	setActive(arg0_6.gotBtn, arg0_6.inPhase2 and var4_6)
	setActive(arg0_6.getTag, arg0_6.inPhase2 and not var4_6 and var3_6)
	setActive(arg0_6.gotTag, arg0_6.inPhase2 and var4_6)
	setActive(arg0_6._tf:Find("AD/switcher/phase2/progress"), not var4_6)
end

return var0_0

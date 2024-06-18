local var0_0 = class("ShenshengxvmuRePage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.step = arg0_1:findTF("step", arg0_1.bg)
	arg0_1.progress = arg0_1:findTF("progress", arg0_1.bg)
	arg0_1.displayBtn = arg0_1:findTF("display_btn", arg0_1.bg)
	arg0_1.awardTF = arg0_1:findTF("award", arg0_1.bg)
	arg0_1.battleBtn = arg0_1:findTF("battle_btn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("get_btn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("got_btn", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	setActive(arg0_2.displayBtn, false)
	setActive(arg0_2.awardTF, false)
	onButton(arg0_2, arg0_2.battleBtn, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)

	arg0_2.step = arg0_2:findTF("AD/step")
	arg0_2.progress = arg0_2:findTF("AD/progress")
	arg0_2.bar = arg0_2:findTF("AD/slider/bar")

	local var0_2 = pg.activity_event_avatarframe[arg0_2.activity:getConfig("config_id")].start_time

	if var0_2 == "stop" then
		arg0_2.inTime = false
	else
		local var1_2 = pg.TimeMgr.GetInstance():Table2ServerTime({
			year = var0_2[1][1],
			month = var0_2[1][2],
			day = var0_2[1][3],
			hour = var0_2[2][1],
			min = var0_2[2][2],
			sec = var0_2[2][3]
		})

		arg0_2.inTime = pg.TimeMgr.GetInstance():GetServerTime() - var1_2 > 0
	end

	setActive(arg0_2.battleBtn, isActive(arg0_2.battleBtn) and arg0_2.inTime)
end

function var0_0.Switch(arg0_4, arg1_4)
	arg0_4:UpdateAwardGot()
	onButton(arg0_4, arg0_4.getBtn, function()
		arg0_4:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_4.activity.id
		})
	end, SFX_PANEL)
end

function var0_0.UpdateAwardGot(arg0_6)
	local var0_6 = arg0_6.activity.data2 >= 1
	local var1_6 = arg0_6:findTF("AD/got")

	setActive(var1_6, var0_6)
end

function var0_0.OnUpdateFlush(arg0_7)
	local var0_7 = arg0_7.activity

	setActive(arg0_7.battleBtn, isActive(arg0_7.battleBtn) and arg0_7.inTime)
	arg0_7:UpdateAwardGot()

	local var1_7 = arg0_7.activity.data1
	local var2_7 = pg.activity_event_avatarframe[arg0_7.activity:getConfig("config_id")].target

	if var2_7 < var1_7 then
		var1_7 = var2_7
	end

	local var3_7 = var1_7 / var2_7

	setText(arg0_7.step, var3_7 >= 1 and setColorStr(var1_7, "#487CFFFF") or var1_7)
	setText(arg0_7.progress, "/" .. var2_7)
	setFillAmount(arg0_7.bar, var1_7 / var2_7)

	local var4_7 = var2_7 <= var1_7
	local var5_7 = arg0_7.activity.data2 >= 1

	setActive(arg0_7.battleBtn, not var5_7 and not var4_7 and arg0_7.inTime)
	setActive(arg0_7.getBtn, var4_7 and not var5_7)
	setActive(arg0_7.gotBtn, var5_7)
end

return var0_0

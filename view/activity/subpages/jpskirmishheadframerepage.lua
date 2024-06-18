local var0_0 = class("JPSkirmishHeadFrameRePage", import(".TemplatePage.FrameReTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.battleBtn = arg0_1:findTF("GoBtn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("GetBtn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("GotBtn", arg0_1.bg)
	arg0_1.bar = arg0_1:findTF("Progress", arg0_1.bg)
	arg0_1.progress = arg0_1:findTF("ProgressText", arg0_1.bg)
	arg0_1.frameGot = arg0_1:findTF("GotTag", arg0_1.bg)
end

function var0_0.OnUpdateFlush(arg0_2)
	local var0_2 = arg0_2.activity.data1
	local var1_2 = arg0_2.avatarConfig.target

	var0_2 = var1_2 < var0_2 and var1_2 or var0_2

	local var2_2 = var0_2 / var1_2

	setText(arg0_2.progress, (var2_2 >= 1 and setColorStr(var0_2, COLOR_GREEN) or var0_2) .. "/" .. var1_2)
	setSlider(arg0_2.bar, 0, 1, var2_2)

	local var3_2 = var1_2 <= var0_2
	local var4_2 = arg0_2.activity.data2 >= 1
	local var5_2 = arg0_2.avatarConfig.start_time

	if var5_2 == "stop" then
		arg0_2.inTime = false
	else
		local var6_2 = pg.TimeMgr.GetInstance():Table2ServerTime({
			year = var5_2[1][1],
			month = var5_2[1][2],
			day = var5_2[1][3],
			hour = var5_2[2][1],
			min = var5_2[2][2],
			sec = var5_2[2][3]
		})

		arg0_2.inTime = pg.TimeMgr.GetInstance():GetServerTime() - var6_2 > 0
	end

	setActive(arg0_2.battleBtn, arg0_2.inTime and not var3_2 or false)
	setActive(arg0_2.getBtn, not var4_2 and var3_2)
	setActive(arg0_2.gotBtn, var4_2)
	setActive(arg0_2.frameGot, var4_2)
end

return var0_0

local var0 = class("JPSkirmishHeadFrameRePage", import(".TemplatePage.FrameReTemplatePage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.battleBtn = arg0:findTF("GoBtn", arg0.bg)
	arg0.getBtn = arg0:findTF("GetBtn", arg0.bg)
	arg0.gotBtn = arg0:findTF("GotBtn", arg0.bg)
	arg0.bar = arg0:findTF("Progress", arg0.bg)
	arg0.progress = arg0:findTF("ProgressText", arg0.bg)
	arg0.frameGot = arg0:findTF("GotTag", arg0.bg)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity.data1
	local var1 = arg0.avatarConfig.target

	var0 = var1 < var0 and var1 or var0

	local var2 = var0 / var1

	setText(arg0.progress, (var2 >= 1 and setColorStr(var0, COLOR_GREEN) or var0) .. "/" .. var1)
	setSlider(arg0.bar, 0, 1, var2)

	local var3 = var1 <= var0
	local var4 = arg0.activity.data2 >= 1
	local var5 = arg0.avatarConfig.start_time

	if var5 == "stop" then
		arg0.inTime = false
	else
		local var6 = pg.TimeMgr.GetInstance():Table2ServerTime({
			year = var5[1][1],
			month = var5[1][2],
			day = var5[1][3],
			hour = var5[2][1],
			min = var5[2][2],
			sec = var5[2][3]
		})

		arg0.inTime = pg.TimeMgr.GetInstance():GetServerTime() - var6 > 0
	end

	setActive(arg0.battleBtn, arg0.inTime and not var3 or false)
	setActive(arg0.getBtn, not var4 and var3)
	setActive(arg0.gotBtn, var4)
	setActive(arg0.frameGot, var4)
end

return var0

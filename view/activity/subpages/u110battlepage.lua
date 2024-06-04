local var0 = class("U110BattlePage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.slider = arg0:findTF("slider", arg0.bg)
	arg0.step = arg0:findTF("step", arg0.bg)
	arg0.progress = arg0:findTF("progress", arg0.bg)
	arg0.desc = arg0:findTF("desc", arg0.bg)
	arg0.awardTF = arg0:findTF("award", arg0.bg)
	arg0.battleBtn = arg0:findTF("battle_btn", arg0.bg)
	arg0.getBtn = arg0:findTF("get_btn", arg0.bg)
	arg0.gotBtn = arg0:findTF("got_btn", arg0.bg)
	arg0.buildBtn = arg0:findTF("build_btn", arg0.bg)
end

function var0.OnDataSetting(arg0)
	local var0 = arg0.activity:getConfig("config_data")

	arg0.taskIDList = _.flatten(var0)
	arg0.taskProxy = getProxy(TaskProxy)
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_U110_BATTLE_LEVEL)

		if not var0 or var0:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

			return
		end

		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		arg0:emit(ActivityMediator.ON_TASK_SUBMIT, arg0.curTaskVO)
	end, SFX_PANEL)
	onButton(arg0, arg0.buildBtn, function()
		local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_U110_BUILD)

		if not var0 or var0:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

			return
		end

		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			projectName = BuildShipScene.PROJECTS.SPECIAL
		})
	end)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0:findCurTaskIndex()

	setText(arg0.step, var0 .. "/" .. #arg0.taskIDList)

	local var1 = arg0.taskIDList[var0]
	local var2 = arg0.taskProxy:getTaskVO(var1)

	arg0.curTaskVO = var2

	local var3 = var2:getProgress()
	local var4 = var2:getConfig("target_num")

	setText(arg0.progress, (var4 <= var3 and setColorStr(var3, COLOR_GREEN) or var3) .. "/" .. var4)
	setSlider(arg0.slider, 0, var4, var3)

	local var5 = var2:getConfig("award_display")[1]
	local var6 = {
		type = var5[1],
		id = var5[2],
		count = var5[3]
	}

	updateDrop(arg0.awardTF, var6)
	onButton(arg0, arg0.awardTF, function()
		arg0:emit(BaseUI.ON_DROP, var6)
	end, SFX_PANEL)

	local var7 = pg.task_data_template[var1].desc

	setText(arg0.desc, var7)

	local var8 = var2:getTaskStatus()

	setActive(arg0.battleBtn, var8 == 0)
	setActive(arg0.getBtn, var8 == 1)
	setActive(arg0.gotBtn, var8 == 2)
end

function var0.OnDestroy(arg0)
	return
end

function var0.findCurTaskIndex(arg0)
	local var0

	for iter0, iter1 in ipairs(arg0.taskIDList) do
		if arg0.taskProxy:getTaskVO(iter1):getTaskStatus() <= 1 then
			var0 = iter0

			break
		elseif iter0 == #arg0.taskIDList then
			var0 = iter0
		end
	end

	return var0
end

return var0

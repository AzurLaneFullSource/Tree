local var0_0 = class("U110BattleRePage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.slider = arg0_1:findTF("slider", arg0_1.bg)
	arg0_1.step = arg0_1:findTF("step", arg0_1.bg)
	arg0_1.progress = arg0_1:findTF("progress", arg0_1.bg)
	arg0_1.desc = arg0_1:findTF("desc", arg0_1.bg)
	arg0_1.awardTF = arg0_1:findTF("award", arg0_1.bg)
	arg0_1.battleBtn = arg0_1:findTF("battle_btn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("get_btn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("got_btn", arg0_1.bg)
	arg0_1.buildBtn = arg0_1:findTF("build_btn", arg0_1.bg)
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_data")

	arg0_2.taskIDList = _.flatten(var0_2)
	arg0_2.taskProxy = getProxy(TaskProxy)
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.battleBtn, function()
		local var0_4 = arg0_3.activity:getConfig("config_client").fightLinkActID
		local var1_4 = var0_4 and getProxy(ActivityProxy):getActivityById(var0_4)

		if not var1_4 or var1_4:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

			return
		end

		arg0_3:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_3.curTaskVO)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.buildBtn, function()
		local var0_6 = arg0_3.activity:getConfig("config_client").buildLinkActID
		local var1_6 = var0_6 and getProxy(ActivityProxy):getActivityById(var0_6)

		if not var1_6 or var1_6:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

			return
		end

		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			projectName = BuildShipScene.PROJECTS.SPECIAL
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_7)
	local var0_7 = arg0_7:findCurTaskIndex()

	setText(arg0_7.step, var0_7 .. "/" .. #arg0_7.taskIDList)

	local var1_7 = arg0_7.taskIDList[var0_7]
	local var2_7 = arg0_7.taskProxy:getTaskVO(var1_7)

	arg0_7.curTaskVO = var2_7

	local var3_7 = var2_7:getProgress()
	local var4_7 = var2_7:getConfig("target_num")

	setText(arg0_7.progress, (var4_7 <= var3_7 and setColorStr(var3_7, COLOR_GREEN) or var3_7) .. "/" .. var4_7)
	setSlider(arg0_7.slider, 0, var4_7, var3_7)

	local var5_7 = var2_7:getConfig("award_display")[1]
	local var6_7 = {
		type = var5_7[1],
		id = var5_7[2],
		count = var5_7[3]
	}

	updateDrop(arg0_7.awardTF, var6_7)
	onButton(arg0_7, arg0_7.awardTF, function()
		arg0_7:emit(BaseUI.ON_DROP, var6_7)
	end, SFX_PANEL)

	local var7_7 = pg.task_data_template[var1_7].desc

	setText(arg0_7.desc, var7_7)

	local var8_7 = var2_7:getTaskStatus()

	setActive(arg0_7.battleBtn, var8_7 == 0)
	setActive(arg0_7.getBtn, var8_7 == 1)
	setActive(arg0_7.gotBtn, var8_7 == 2)
end

function var0_0.OnDestroy(arg0_9)
	return
end

function var0_0.findCurTaskIndex(arg0_10)
	local var0_10

	for iter0_10, iter1_10 in ipairs(arg0_10.taskIDList) do
		if arg0_10.taskProxy:getTaskVO(iter1_10):getTaskStatus() <= 1 then
			var0_10 = iter0_10

			break
		elseif iter0_10 == #arg0_10.taskIDList then
			var0_10 = iter0_10
		end
	end

	return var0_10
end

return var0_0

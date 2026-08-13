local var0_0 = class("RapidSeasideMonopolyPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.startBtn = arg0_1._tf:Find("AD/start")
	arg0_1.leftCountTxt = arg0_1.startBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_1.turnTxt = arg0_1._tf:Find("AD/loop_cnt/turn"):GetComponent(typeof(Text))
	arg0_1.turnCntTxt = arg0_1._tf:Find("AD/loop_cnt/turn_cnt"):GetComponent(typeof(Text))
	arg0_1.progressTxt = arg0_1._tf:Find("AD/loop_cnt/progress"):GetComponent(typeof(Text))
	arg0_1.progressCntTxt = arg0_1._tf:Find("AD/loop_cnt/progress_cnt"):GetComponent(typeof(Text))
	arg0_1.turnAwards = {
		arg0_1._tf:Find("AD/turn_awards/award_1"),
		arg0_1._tf:Find("AD/turn_awards/award_2"),
		arg0_1._tf:Find("AD/turn_awards/award_3")
	}
	arg0_1.turnGetBtn = arg0_1._tf:Find("AD/turn_awards/get_btn")
	arg0_1.turnGotBtn = arg0_1._tf:Find("AD/turn_awards/got_btn")
	arg0_1.progressImage = arg0_1._tf:Find("AD/turn_awards/progress/bar")
	arg0_1.title = arg0_1._tf:Find("AD/RapidSeasideTitle Variant/Main/title")
	arg0_1._paintingParticles = arg0_1._tf:Find("AD/RapidSeasideTitle Variant/Main/title/title_2/Particle System")
	arg0_1._paintingParticleSystem = arg0_1._paintingParticles:GetComponent(typeof(ParticleSystem))
	arg0_1.btnManual = arg0_1._tf:Find("TopPage/top/manual")
	arg0_1.Txtmanual = arg0_1.btnManual:Find("Text")
	arg0_1.redMalPoint = arg0_1.btnManual:Find("tip")

	for iter0_1, iter1_1 in ipairs(arg0_1.turnAwards) do
		setActive(iter1_1:Find("can_get_mask"), false)
	end

	onButton(arg0_1, arg0_1.startBtn, function()
		if not arg0_1.activity or arg0_1.activity:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		setActive(arg0_1.title, false)
		arg0_1._paintingParticleSystem:Stop(true)
		arg0_1:emit(ActivityMediator.GO_MONOPOLY2026, arg0_1.activity.id, function()
			setActive(arg0_1.title, true)
			arg0_1._paintingParticleSystem:Play()
			arg0_1:OnUpdateFlush()
		end)
	end, SFX_PANEL)

	arg0_1.taskGoBtn = arg0_1._tf:Find("AD/loop_progress/go_btn")
	arg0_1.taskGetBtn = arg0_1._tf:Find("AD/loop_progress/get_btn")
	arg0_1.taskGotBtn = arg0_1._tf:Find("AD/loop_progress/got_btn")
	arg0_1.taskDesc = arg0_1._tf:Find("AD/loop_progress/Text"):GetComponent(typeof(Text))
	arg0_1.taskAward = arg0_1._tf:Find("AD/loop_progress/award")
	arg0_1.taskProgress = arg0_1._tf:Find("AD/loop_progress/taskProgress")
end

function var0_0.OnDataSetting(arg0_4)
	return
end

function var0_0.OnFirstFlush(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.turnAwards) do
		setText(iter1_5:Find("bg_lock/Text"), i18n("RapidSeasideMonopolyPage_award_loop" .. iter0_5))
		setText(iter1_5:Find("bg_unlock/Text"), i18n("RapidSeasideMonopolyPage_award_loop" .. iter0_5))
	end

	onButton(arg0_5, arg0_5.btnManual, function()
		local var0_6 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = RapidSeasideMedalAlbumView
		})

		arg0_5:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_6)
	end, SFX_PANEL)
	setText(arg0_5.Txtmanual, i18n("anniversary_nine_main_page"))
	arg0_5:UpdateRed()
end

function var0_0.OnUpdateFlush(arg0_7)
	arg0_7:UpdateTurnAwards()
	arg0_7:UpdateTask()
	arg0_7:UpdateRed()
end

function var0_0.UpdateTurnAwards(arg0_8)
	local var0_8 = arg0_8.activity
	local var1_8 = "MONOPOLY_AWARD_LIST"
	local var2_8 = pg.gameset[var1_8] and pg.gameset[var1_8].description or {
		3,
		6,
		9
	}
	local var3_8 = var2_8[3]
	local var4_8 = (var0_8.data1_list[3] or 1) - 1
	local var5_8 = var0_8.data1_list[6] or 0

	arg0_8.turnTxt.text = i18n("RapidSeasideMonopolyPage_turn_cnt_tip")
	arg0_8.turnCntTxt.text = var4_8 .. "/" .. var3_8

	local var6_8 = (math.max(var0_8.data2, 1) - 1) / #(var0_8:getDataConfig("map") or {})

	if var6_8 == 0 and var4_8 > 0 then
		var6_8 = 1
	end

	arg0_8.progressTxt.text = i18n("RapidSeasideMonopolyPage_progress_tip")
	arg0_8.progressCntTxt.text = string.format("%.1f", var6_8 * 100) .. "%"

	local var7_8 = var0_8:getDataConfig("sum_lap_reward_show")
	local var8_8 = false
	local var9_8 = 0

	for iter0_8, iter1_8 in ipairs(arg0_8.turnAwards) do
		local var10_8 = var7_8[iter0_8]
		local var11_8 = Drop.New({
			type = var10_8[1],
			id = var10_8[2],
			count = var10_8[3]
		})
		local var12_8 = var2_8[iter0_8]
		local var13_8 = var12_8 <= var4_8 and var5_8 < var12_8

		updateDrop(iter1_8:Find("mask"), var11_8)
		onButton(arg0_8, iter1_8, function()
			arg0_8:emit(BaseUI.ON_DROP, var11_8)
		end, SFX_PANEL)
		setActive(iter1_8:Find("got"), var12_8 <= var5_8)
		setActive(iter1_8:Find("bg_lock"), var12_8 <= var4_8)
		setActive(iter1_8:Find("bg_unlock"), var4_8 < var12_8)

		if var9_8 == 0 and var13_8 then
			var9_8 = var12_8
		end

		setActive(iter1_8:Find("can_get_mask"), var13_8)

		var8_8 = var8_8 or var13_8
	end

	setActive(arg0_8.turnGotBtn, not var8_8)
	setActive(arg0_8.turnGetBtn, var8_8)

	local var14_8 = pg.TimeMgr.GetInstance():GetServerTime()
	local var15_8 = var0_8.data1
	local var16_8 = math.ceil((var14_8 - var15_8) / 86400) * var0_8:getDataConfig("daily_time") + (var0_8.data1_list[1] or 0) - (var0_8.data1_list[2] or 0)

	arg0_8.leftCountTxt.text = i18n("MonopolyCar2024Game_total_num_tip", var16_8)

	onButton(arg0_8, arg0_8.turnGetBtn, function()
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = var0_8.id,
			arg1 = var9_8,
			cmd = ActivityConst.MONOPOLY_OP_ROUND_AWD
		})
	end, SFX_PANEL)
end

function var0_0.UpdateTask(arg0_11)
	local var0_11 = pg.activity_template[arg0_11.activity.id].config_data[1]
	local var1_11 = pg.activity_template[var0_11].config_data[1]
	local var2_11 = getProxy(TaskProxy)
	local var3_11 = var2_11:getTaskById(var1_11) or var2_11:getFinishTaskById(var1_11) or Task.New({
		id = var1_11
	})
	local var4_11 = var2_11:getTaskById(var1_11)
	local var5_11 = var3_11:getConfig("award_display")[1]
	local var6_11 = Drop.New({
		type = var5_11[1],
		id = var5_11[2],
		count = var5_11[3]
	})

	updateDrop(arg0_11.taskAward:Find("mask"), var6_11)
	onButton(arg0_11, arg0_11.taskAward, function()
		arg0_11:emit(BaseUI.ON_DROP, var6_11)
	end, SFX_PANEL)

	local var7_11 = var3_11:getConfig("target_num")

	if var4_11 ~= nil then
		local var8_11 = math.min(var3_11:getProgress(), var7_11)

		setSlider(arg0_11.taskProgress, 0, var7_11, var8_11)

		local var9_11 = var3_11:getConfig("desc")

		for iter0_11, iter1_11 in ipairs({
			var8_11
		}) do
			var9_11 = string.gsub(var9_11, "$" .. iter0_11, iter1_11)
		end

		arg0_11.taskDesc.text = var9_11

		local var10_11 = var3_11:isFinish()
		local var11_11 = var3_11:isReceive()

		setActive(arg0_11.taskGoBtn, not var10_11 and not var11_11)
		setActive(arg0_11.taskGetBtn, var10_11 and not var11_11)
		setActive(arg0_11.taskGotBtn, var11_11)
	else
		local var12_11 = var7_11

		setSlider(arg0_11.taskProgress, 0, var7_11, var12_11)

		local var13_11 = var3_11:getConfig("desc")

		for iter2_11, iter3_11 in ipairs({
			var12_11
		}) do
			var13_11 = string.gsub(var13_11, "$" .. iter2_11, iter3_11)
		end

		arg0_11.taskDesc.text = var13_11

		setActive(arg0_11.taskGoBtn, false)
		setActive(arg0_11.taskGetBtn, false)
		setActive(arg0_11.taskGotBtn, true)
	end

	onButton(arg0_11, arg0_11.taskGetBtn, function()
		arg0_11:emit(ActivityMediator.ON_TASK_SUBMIT, var3_11, function(arg0_14)
			if arg0_14 then
				arg0_11:OnUpdateFlush()
			end
		end)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.taskGoBtn, function()
		arg0_11:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
end

function var0_0.UpdateRed(arg0_16)
	local var0_16 = pg.activity_template[arg0_16.activity.id].config_client

	if var0_16.is_showMedal then
		local var1_16 = var0_16.medal_group_id

		setActive(arg0_16.redMalPoint, ActivityMedalGroup.showTip(var1_16))
	end
end

function var0_0.OnHideFlush(arg0_17)
	return
end

function var0_0.OnDestroy(arg0_18)
	return
end

return var0_0

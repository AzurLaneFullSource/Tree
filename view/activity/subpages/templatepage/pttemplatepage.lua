local var0_0 = class("PtTemplatePage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.slider = arg0_1:findTF("slider", arg0_1.bg)
	arg0_1.step = arg0_1:findTF("step", arg0_1.bg)
	arg0_1.progress = arg0_1:findTF("progress", arg0_1.bg)
	arg0_1.displayBtn = arg0_1:findTF("display_btn", arg0_1.bg)
	arg0_1.awardTF = arg0_1:findTF("award", arg0_1.bg)
	arg0_1.battleBtn = arg0_1:findTF("battle_btn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("get_btn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("got_btn", arg0_1.bg)
end

function var0_0.OnDataSetting(arg0_2)
	if arg0_2.ptData then
		arg0_2.ptData:Update(arg0_2.activity)
	else
		arg0_2.ptData = ActivityPtData.New(arg0_2.activity)
	end
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.displayBtn, function()
		arg0_3:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			type = arg0_3.ptData.type,
			dropList = arg0_3.ptData.dropList,
			targets = arg0_3.ptData.targets,
			level = arg0_3.ptData.level,
			count = arg0_3.ptData.count,
			resId = arg0_3.ptData.resId,
			unlockStamps = arg0_3.ptData:GetDayUnlockStamps()
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.battleBtn, function()
		local var0_5
		local var1_5

		if arg0_3.activity:getConfig("config_client") ~= "" then
			var0_5 = arg0_3.activity:getConfig("config_client").linkActID

			if var0_5 then
				var1_5 = getProxy(ActivityProxy):getActivityById(var0_5)
			end
		end

		if not var0_5 then
			arg0_3:emit(ActivityMediator.BATTLE_OPERA)
		elseif var1_5 and not var1_5:isEnd() then
			arg0_3:emit(ActivityMediator.BATTLE_OPERA)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		local var0_6 = {}
		local var1_6 = arg0_3.ptData:GetAward()
		local var2_6 = getProxy(PlayerProxy):getRawData()
		local var3_6 = pg.gameset.urpt_chapter_max.description[1]
		local var4_6 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_6)
		local var5_6, var6_6 = Task.StaticJudgeOverflow(var2_6.gold, var2_6.oil, var4_6, true, true, {
			{
				var1_6.type,
				var1_6.id,
				var1_6.count
			}
		})

		if var5_6 then
			table.insert(var0_6, function(arg0_7)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_6,
					onYes = arg0_7
				})
			end)
		end

		seriesAsync(var0_6, function()
			local var0_8, var1_8 = arg0_3.ptData:GetResProgress()

			arg0_3:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_3.ptData:GetId(),
				arg1 = var1_8
			})
		end)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_9)
	local var0_9 = arg0_9.ptData:getTargetLevel()
	local var1_9 = arg0_9.activity:getConfig("config_client").story

	if checkExist(var1_9, {
		var0_9
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var1_9[var0_9][1])
	end

	if arg0_9.step then
		local var2_9, var3_9, var4_9 = arg0_9.ptData:GetLevelProgress()

		setText(arg0_9.step, var2_9 .. "/" .. var3_9)
	end

	local var5_9, var6_9, var7_9 = arg0_9.ptData:GetResProgress()

	setText(arg0_9.progress, (var7_9 >= 1 and setColorStr(var5_9, COLOR_GREEN) or var5_9) .. "/" .. var6_9)
	setSlider(arg0_9.slider, 0, 1, var7_9)

	local var8_9 = arg0_9.ptData:CanGetAward()
	local var9_9 = arg0_9.ptData:CanGetNextAward()
	local var10_9 = arg0_9.ptData:CanGetMorePt()

	setActive(arg0_9.battleBtn, var10_9 and not var8_9 and var9_9)
	setActive(arg0_9.getBtn, var8_9)
	setActive(arg0_9.gotBtn, not var9_9)

	local var11_9 = arg0_9.ptData:GetAward()

	updateDrop(arg0_9.awardTF, var11_9)
	onButton(arg0_9, arg0_9.awardTF, function()
		arg0_9:emit(BaseUI.ON_DROP, var11_9)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_11)
	return
end

function var0_0.GetWorldPtData(arg0_12, arg1_12)
	if arg1_12 <= pg.TimeMgr.GetInstance():GetServerTime() - (ActivityMainScene.Data2Time or 0) then
		ActivityMainScene.Data2Time = pg.TimeMgr.GetInstance():GetServerTime()

		arg0_12:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 2,
			activity_id = arg0_12.ptData:GetId()
		})
	end
end

return var0_0

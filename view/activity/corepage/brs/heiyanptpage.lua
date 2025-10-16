local var0_0 = class("HeiYanPtPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.task_bg = arg0_1.bg:Find("task_bg")
	arg0_1.slider = arg0_1.task_bg:Find("slider")
	arg0_1.step = arg0_1.task_bg:Find("step")
	arg0_1.progress = arg0_1.task_bg:Find("progress")
	arg0_1.progres = arg0_1.task_bg:Find("progres")
	arg0_1.displayBtn = arg0_1.task_bg:Find("display_btn")
	arg0_1.awardTF = arg0_1.task_bg:Find("award")
	arg0_1.battleBtn = arg0_1.task_bg:Find("battle_btn")
	arg0_1.getBtn = arg0_1.task_bg:Find("get_btn")
	arg0_1.gotBtn = arg0_1.task_bg:Find("got_btn")
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
			blur = true,
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
		arg0_3:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		arg0_3:GetAllAward()
	end, SFX_PANEL)
	arg0_3:OnUpdateFlush()
end

function var0_0.GetAllAward(arg0_7)
	local var0_7 = {}
	local var1_7 = arg0_7.ptData:GetAward()
	local var2_7 = getProxy(PlayerProxy):getRawData()
	local var3_7 = pg.gameset.urpt_chapter_max.description[1]
	local var4_7 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_7)
	local var5_7, var6_7 = Task.StaticJudgeOverflow(var2_7.gold, var2_7.oil, var4_7, true, true, {
		{
			var1_7.type,
			var1_7.id,
			var1_7.count
		}
	})

	if var5_7 then
		table.insert(var0_7, function(arg0_8)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("award_max_warning"),
				items = var6_7,
				onYes = arg0_8
			})
		end)
	end

	seriesAsync(var0_7, function()
		local var0_9, var1_9 = arg0_7.ptData:GetResProgress()

		arg0_7:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0_7.ptData:GetId(),
			arg1 = var1_9
		})
	end)
end

function var0_0.OnUpdateFlush(arg0_10)
	local var0_10, var1_10, var2_10 = arg0_10.ptData:GetLevelProgress()

	if arg0_10.step then
		setText(arg0_10.step, var0_10 .. "/" .. var1_10)
	end

	local var3_10 = arg0_10.activity:getConfig("config_client").story

	if checkExist(var3_10, {
		var0_10
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var3_10[var0_10][1])
	end

	local var4_10, var5_10, var6_10 = arg0_10.ptData:GetResProgress()

	setText(arg0_10.progress, "/" .. var5_10)
	setText(arg0_10.progres, var6_10 >= 1 and setColorStr(var4_10, "#6ef0ff") or var4_10)
	setSlider(arg0_10.slider, 0, 1, var6_10)

	local var7_10 = arg0_10.ptData:CanGetAward()
	local var8_10 = arg0_10.ptData:CanGetNextAward()
	local var9_10 = arg0_10.ptData:CanGetMorePt()

	setActive(arg0_10.battleBtn, var9_10 and not var7_10 and var8_10)
	setActive(arg0_10.getBtn, var7_10)
	setActive(arg0_10.gotBtn, not var8_10)

	local var10_10 = arg0_10.ptData:GetAward()

	updateDrop(arg0_10.awardTF, var10_10)
	onButton(arg0_10, arg0_10.awardTF, function()
		arg0_10:emit(BaseUI.ON_DROP, var10_10)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_12)
	return
end

function var0_0.GetWorldPtData(arg0_13, arg1_13)
	if arg1_13 <= pg.TimeMgr.GetInstance():GetServerTime() - (ActivityMainScene.Data2Time or 0) then
		ActivityMainScene.Data2Time = pg.TimeMgr.GetInstance():GetServerTime()

		arg0_13:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 2,
			activity_id = arg0_13.ptData:GetId()
		})
	end
end

return var0_0

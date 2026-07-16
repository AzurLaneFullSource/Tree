local var0_0 = class("NieRAutomataKillPage", import("..CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.title = arg0_1.bg:Find("title")
	arg0_1.desc1 = arg0_1.title:Find("desc1")
	arg0_1.desc2 = arg0_1.title:Find("desc2")
	arg0_1.rtTask = arg0_1.bg:Find("task")
	arg0_1.step = arg0_1.rtTask:Find("step")
	arg0_1.nowday = arg0_1.step:Find("nowday")
	arg0_1.aimday = arg0_1.step:Find("aimday")
	arg0_1.progress = arg0_1.rtTask:Find("progress")
	arg0_1.slider = arg0_1.progress:Find("slider")
	arg0_1.awardTF = arg0_1.progress:Find("award")
	arg0_1.progressStep = arg0_1.progress:Find("step")
	arg0_1.progressRule = arg0_1.progress:Find("rule")
	arg0_1.BtnGroup = arg0_1.rtTask:Find("BtnGroup")
	arg0_1.displayBtn = arg0_1.BtnGroup:Find("Check_btn")
	arg0_1.battleBtn = arg0_1.BtnGroup:Find("battle_btn")
	arg0_1.getBtn = arg0_1.BtnGroup:Find("get_btn")
	arg0_1.gotBtn = arg0_1.BtnGroup:Find("got_btn")
	arg0_1.displayText = arg0_1.displayBtn:Find("Text")
	arg0_1.finishAll = false
end

function var0_0.OnDataSetting(arg0_2)
	if arg0_2.ptData then
		arg0_2.ptData:Update(arg0_2.activity)
	else
		arg0_2.ptData = ActivityPtData.New(arg0_2.activity)
	end
end

function var0_0.LocalInit(arg0_3)
	setText(arg0_3.displayText, i18n("nier_core_award_check"))
	setText(arg0_3.progressRule, i18n("nier_core_task_desc"))
end

function var0_0.LocalFresh(arg0_4)
	local var0_4, var1_4, var2_4 = arg0_4.ptData:GetLevelProgress()
	local var3_4 = "nier_2b_text_block_day"
	local var4_4 = arg0_4.ptData:CanGetNextAward()
	local var5_4

	arg0_4.finishAll = var0_4 >= 7 and not var4_4

	if arg0_4.finishAll then
		var5_4 = i18n(var3_4 .. "_fin")

		setActive(arg0_4.desc1, false)
	else
		var5_4 = i18n(var3_4 .. var0_4)

		setText(arg0_4.desc1, var5_4[1].info)
	end

	setText(arg0_4.desc2, var5_4[2].info)
	setActive(arg0_4.desc2, false)
	arg0_4:Playwriter()
end

function var0_0.InitBtn(arg0_5)
	onButton(arg0_5, arg0_5.displayBtn, function()
		arg0_5:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			blur = true,
			type = arg0_5.ptData.type,
			dropList = arg0_5.ptData.dropList,
			targets = arg0_5.ptData.targets,
			level = arg0_5.ptData.level,
			count = arg0_5.ptData.count,
			resId = arg0_5.ptData.resId,
			unlockStamps = arg0_5.ptData:GetDayUnlockStamps()
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.battleBtn, function()
		arg0_5:emit(ActivityMediator.GO_Activity_level)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.getBtn, function()
		local var0_8 = {}
		local var1_8 = arg0_5.ptData:GetAward()
		local var2_8 = getProxy(PlayerProxy):getRawData()
		local var3_8 = pg.gameset.urpt_chapter_max.description[1]
		local var4_8 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_8)
		local var5_8, var6_8 = Task.StaticJudgeOverflow(var2_8.gold, var2_8.oil, var4_8, true, true, {
			{
				var1_8.type,
				var1_8.id,
				var1_8.count
			}
		})

		if var5_8 then
			table.insert(var0_8, function(arg0_9)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_8,
					onYes = arg0_9
				})
			end)
		end

		seriesAsync(var0_8, function()
			local var0_10, var1_10 = arg0_5.ptData:GetResProgress()

			arg0_5:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_5.ptData:GetId(),
				arg1 = var1_10
			})
		end)
	end, SFX_PANEL)
end

function var0_0.GetTypewriterSpeed(arg0_11)
	local var0_11 = arg0_11.activity:getConfig("config_client").typewriterSpeed

	return var0_11 and var0_11 or 0.1
end

function var0_0.Playwriter(arg0_12)
	local var0_12 = {}

	if not arg0_12.finishAll then
		table.insert(var0_12, function(arg0_13)
			local var0_13 = arg0_12.desc1
			local var1_13 = GetOrAddComponent(var0_13, typeof(Typewriter))

			function var1_13.endFunc()
				arg0_13()
			end

			var1_13:setSpeed(arg0_12:GetTypewriterSpeed())
			var1_13:Play()
		end)
	else
		local var1_12, var2_12, var3_12 = arg0_12.ptData:GetLevelProgress()

		table.insert(var0_12, function(arg0_15)
			local var0_15 = arg0_12.activity:getConfig("config_client").story
			local var1_15 = checkExist(var0_15, {
				var1_12
			}, {
				1
			})

			if var1_15 and not pg.NewStoryMgr.GetInstance():IsPlayed(var1_15) then
				pg.NewStoryMgr.GetInstance():Play(var1_15, function()
					arg0_15()
				end)
			else
				arg0_15()
			end
		end)
	end

	table.insert(var0_12, function(arg0_17)
		local var0_17 = arg0_12.desc2

		setActive(arg0_12.desc2, true)

		local var1_17 = GetOrAddComponent(var0_17, typeof(Typewriter))

		function var1_17.endFunc()
			arg0_17()
		end

		var1_17:setSpeed(arg0_12:GetTypewriterSpeed())
		var1_17:Play()
	end)
	seriesAsync(var0_12, callback)
end

function var0_0.OnFirstFlush(arg0_19)
	arg0_19:LocalInit()
	arg0_19:LocalFresh()
	arg0_19:InitBtn()
end

function var0_0.OnUpdateFlush(arg0_20)
	local var0_20 = arg0_20.ptData:getTargetLevel()
	local var1_20, var2_20, var3_20 = arg0_20.ptData:GetLevelProgress()

	setText(arg0_20.nowday, string.format("%s", var1_20))
	setText(arg0_20.aimday, string.format("/%s", var2_20))
	arg0_20:LocalFresh()

	local var4_20, var5_20, var6_20 = arg0_20.ptData:GetResProgress()

	setText(arg0_20.progressStep, string.format("%s<color=#ffffff33>/%s</color>", var6_20 >= 1 and setColorStr(var4_20, COLOR_GREEN) or var4_20, var5_20))
	setSlider(arg0_20.slider, 0, 1, var6_20)

	local var7_20 = arg0_20.ptData:CanGetAward()
	local var8_20 = arg0_20.ptData:CanGetNextAward()
	local var9_20 = arg0_20.ptData:CanGetMorePt()

	setActive(arg0_20.battleBtn, var9_20 and not var7_20 and var8_20)
	setActive(arg0_20.getBtn, var7_20)
	setActive(arg0_20.gotBtn, not var8_20)

	local var10_20 = arg0_20.ptData:GetAward()

	updateDrop(arg0_20.awardTF, var10_20)
	onButton(arg0_20, arg0_20.awardTF, function()
		arg0_20:emit(BaseUI.ON_DROP, var10_20)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_22)
	return
end

function var0_0.GetWorldPtData(arg0_23, arg1_23)
	if arg1_23 <= pg.TimeMgr.GetInstance():GetServerTime() - (ActivityMainScene.Data2Time or 0) then
		ActivityMainScene.Data2Time = pg.TimeMgr.GetInstance():GetServerTime()

		arg0_23:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 2,
			activity_id = arg0_23.ptData:GetId()
		})
	end
end

return var0_0

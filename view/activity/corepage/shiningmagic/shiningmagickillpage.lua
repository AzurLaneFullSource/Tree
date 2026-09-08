local var0_0 = class("ShiningMagicKillPage", import("..CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
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

function var0_0.InitBtn(arg0_4)
	onButton(arg0_4, arg0_4.displayBtn, function()
		arg0_4:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			blur = true,
			type = arg0_4.ptData.type,
			dropList = arg0_4.ptData.dropList,
			targets = arg0_4.ptData.targets,
			level = arg0_4.ptData.level,
			count = arg0_4.ptData.count,
			resId = arg0_4.ptData.resId,
			unlockStamps = arg0_4.ptData:GetDayUnlockStamps()
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.battleBtn, function()
		arg0_4:emit(ActivityMediator.GO_Activity_level)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.getBtn, function()
		local var0_7 = {}
		local var1_7 = arg0_4.ptData:GetAward()
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
			local var0_9, var1_9 = arg0_4.ptData:GetResProgress()

			arg0_4:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_4.ptData:GetId(),
				arg1 = var1_9
			})
		end)
	end, SFX_PANEL)
end

function var0_0.OnFirstFlush(arg0_10)
	arg0_10:LocalInit()
	arg0_10:InitBtn()
end

function var0_0.OnUpdateFlush(arg0_11)
	local var0_11 = arg0_11.ptData:getTargetLevel()
	local var1_11, var2_11, var3_11 = arg0_11.ptData:GetLevelProgress()

	setText(arg0_11.nowday, string.format("%s", var1_11))
	setText(arg0_11.aimday, string.format("/%s", var2_11))

	local var4_11, var5_11, var6_11 = arg0_11.ptData:GetResProgress()

	setText(arg0_11.progressStep, string.format("%s<color=#ffffff33>/%s</color>", var6_11 >= 1 and setColorStr(var4_11, COLOR_GREEN) or var4_11, var5_11))
	setSlider(arg0_11.slider, 0, 1, var6_11)

	local var7_11 = arg0_11.ptData:CanGetAward()
	local var8_11 = arg0_11.ptData:CanGetNextAward()
	local var9_11 = arg0_11.ptData:CanGetMorePt()

	setActive(arg0_11.battleBtn, var9_11 and not var7_11 and var8_11)
	setActive(arg0_11.getBtn, var7_11)
	setActive(arg0_11.gotBtn, not var8_11)

	local var10_11 = arg0_11.ptData:GetAward()

	updateDrop(arg0_11.awardTF, var10_11)
	onButton(arg0_11, arg0_11.awardTF, function()
		arg0_11:emit(BaseUI.ON_DROP, var10_11)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_13)
	return
end

function var0_0.GetWorldPtData(arg0_14, arg1_14)
	if arg1_14 <= pg.TimeMgr.GetInstance():GetServerTime() - (ActivityMainScene.Data2Time or 0) then
		ActivityMainScene.Data2Time = pg.TimeMgr.GetInstance():GetServerTime()

		arg0_14:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 2,
			activity_id = arg0_14.ptData:GetId()
		})
	end
end

function var0_0.OnHideFlush(arg0_15)
	return
end

function var0_0.OnDestroy(arg0_16)
	return
end

return var0_0

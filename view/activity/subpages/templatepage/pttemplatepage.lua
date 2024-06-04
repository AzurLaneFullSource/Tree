local var0 = class("PtTemplatePage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.slider = arg0:findTF("slider", arg0.bg)
	arg0.step = arg0:findTF("step", arg0.bg)
	arg0.progress = arg0:findTF("progress", arg0.bg)
	arg0.displayBtn = arg0:findTF("display_btn", arg0.bg)
	arg0.awardTF = arg0:findTF("award", arg0.bg)
	arg0.battleBtn = arg0:findTF("battle_btn", arg0.bg)
	arg0.getBtn = arg0:findTF("get_btn", arg0.bg)
	arg0.gotBtn = arg0:findTF("got_btn", arg0.bg)
end

function var0.OnDataSetting(arg0)
	if arg0.ptData then
		arg0.ptData:Update(arg0.activity)
	else
		arg0.ptData = ActivityPtData.New(arg0.activity)
	end
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.displayBtn, function()
		arg0:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			type = arg0.ptData.type,
			dropList = arg0.ptData.dropList,
			targets = arg0.ptData.targets,
			level = arg0.ptData.level,
			count = arg0.ptData.count,
			resId = arg0.ptData.resId,
			unlockStamps = arg0.ptData:GetDayUnlockStamps()
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.battleBtn, function()
		local var0
		local var1

		if arg0.activity:getConfig("config_client") ~= "" then
			var0 = arg0.activity:getConfig("config_client").linkActID

			if var0 then
				var1 = getProxy(ActivityProxy):getActivityById(var0)
			end
		end

		if not var0 then
			arg0:emit(ActivityMediator.BATTLE_OPERA)
		elseif var1 and not var1:isEnd() then
			arg0:emit(ActivityMediator.BATTLE_OPERA)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		local var0 = {}
		local var1 = arg0.ptData:GetAward()
		local var2 = getProxy(PlayerProxy):getRawData()
		local var3 = pg.gameset.urpt_chapter_max.description[1]
		local var4 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3)
		local var5, var6 = Task.StaticJudgeOverflow(var2.gold, var2.oil, var4, true, true, {
			{
				var1.type,
				var1.id,
				var1.count
			}
		})

		if var5 then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6,
					onYes = arg0
				})
			end)
		end

		seriesAsync(var0, function()
			local var0, var1 = arg0.ptData:GetResProgress()

			arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0.ptData:GetId(),
				arg1 = var1
			})
		end)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.ptData:getTargetLevel()
	local var1 = arg0.activity:getConfig("config_client").story

	if checkExist(var1, {
		var0
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var1[var0][1])
	end

	if arg0.step then
		local var2, var3, var4 = arg0.ptData:GetLevelProgress()

		setText(arg0.step, var2 .. "/" .. var3)
	end

	local var5, var6, var7 = arg0.ptData:GetResProgress()

	setText(arg0.progress, (var7 >= 1 and setColorStr(var5, COLOR_GREEN) or var5) .. "/" .. var6)
	setSlider(arg0.slider, 0, 1, var7)

	local var8 = arg0.ptData:CanGetAward()
	local var9 = arg0.ptData:CanGetNextAward()
	local var10 = arg0.ptData:CanGetMorePt()

	setActive(arg0.battleBtn, var10 and not var8 and var9)
	setActive(arg0.getBtn, var8)
	setActive(arg0.gotBtn, not var9)

	local var11 = arg0.ptData:GetAward()

	updateDrop(arg0.awardTF, var11)
	onButton(arg0, arg0.awardTF, function()
		arg0:emit(BaseUI.ON_DROP, var11)
	end, SFX_PANEL)
end

function var0.OnDestroy(arg0)
	return
end

function var0.GetWorldPtData(arg0, arg1)
	if arg1 <= pg.TimeMgr.GetInstance():GetServerTime() - (ActivityMainScene.Data2Time or 0) then
		ActivityMainScene.Data2Time = pg.TimeMgr.GetInstance():GetServerTime()

		arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 2,
			activity_id = arg0.ptData:GetId()
		})
	end
end

return var0

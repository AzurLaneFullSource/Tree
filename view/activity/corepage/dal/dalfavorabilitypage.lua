local var0_0 = class("DALFavorabilityPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.progres = arg0_1.bg:Find("progres")
	arg0_1.awardTF = arg0_1.bg:Find("award")
	arg0_1.battleBtn = arg0_1.bg:Find("battle_btn")
	arg0_1.getBtn = arg0_1.bg:Find("get_btn")
	arg0_1.gotBtn = arg0_1.bg:Find("got_btn")
	arg0_1.displayBtn = arg0_1.bg:Find("display_btn")
	arg0_1.vx_get = arg0_1.bg:Find("vx_get")
end

function var0_0.OnDataSetting(arg0_2)
	if arg0_2.ptData then
		arg0_2.ptData:Update(arg0_2.activity)
	else
		arg0_2.ptData = ActivityPtData.New(arg0_2.activity)
	end
end

function var0_0.OnFirstFlush(arg0_3)
	SetActive(arg0_3.vx_get, false)
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
	SetActive(arg0_7.vx_get, true)
end

function var0_0.OnUpdateFlush(arg0_10)
	local var0_10 = arg0_10.ptData:GetAward()

	updateDrop(arg0_10.awardTF:Find("IconTpl"), var0_10)

	local var1_10, var2_10, var3_10 = arg0_10.ptData:GetResProgress()

	setText(arg0_10.progres, setColorStr(var1_10, "#ffffff") .. setColorStr("/" .. var2_10, "#DD9D9D"))

	local var4_10 = arg0_10.ptData:CanGetAward()
	local var5_10 = arg0_10.ptData:CanGetNextAward()
	local var6_10 = arg0_10.ptData:CanGetMorePt()

	setActive(arg0_10.battleBtn, var6_10 and not var4_10 and var5_10)
	setActive(arg0_10.getBtn, var4_10)
	setActive(arg0_10.gotBtn, not var5_10)

	for iter0_10 = 1, 10 do
		if iter0_10 <= arg0_10.ptData:GetLevel() then
			SetActive(arg0_10.bg:Find("schedule/" .. iter0_10 .. "/on"), true)
			SetActive(arg0_10.bg:Find("schedule/" .. iter0_10 .. "/not"), false)
		else
			SetActive(arg0_10.bg:Find("schedule/" .. iter0_10 .. "/on"), false)
			SetActive(arg0_10.bg:Find("schedule/" .. iter0_10 .. "/not"), true)
		end
	end
end

function var0_0.GetWorldPtData(arg0_11, arg1_11)
	if arg1_11 <= pg.TimeMgr.GetInstance():GetServerTime() - (ActivityMainScene.Data2Time or 0) then
		ActivityMainScene.Data2Time = pg.TimeMgr.GetInstance():GetServerTime()

		arg0_11:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 2,
			activity_id = arg0_11.ptData:GetId()
		})
	end
end

return var0_0

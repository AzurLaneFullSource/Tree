local var0_0 = class("HelenaPTPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.task_bg = arg0_1.bg:Find("task_bg")
	arg0_1.slider = arg0_1.task_bg:Find("slider")
	arg0_1.step = arg0_1.task_bg:Find("step")
	arg0_1.progres = arg0_1.task_bg:Find("progres")
	arg0_1.displayBtn = arg0_1.task_bg:Find("display_btn")
	arg0_1.awardTF = arg0_1.task_bg:Find("award")
	arg0_1.battleBtn = arg0_1.task_bg:Find("battle_btn")
	arg0_1.getBtn = arg0_1.task_bg:Find("get_btn")
	arg0_1.gotBtn = arg0_1.task_bg:Find("got_btn")
	arg0_1.skinBtn = arg0_1.bg:Find("skinbtn")
	arg0_1.scenario = HelenaScenarioPage.New(arg0_1._tf, arg0_1.event)

	arg0_1.scenario:SetCoreStoryPage(arg0_1)
	arg0_1.scenario:RegisterView(arg0_1.coreActivityUI)

	arg0_1.loader = AutoLoader.New()
	arg0_1.mapGroup = {}
	arg0_1.currentBG = nil

	setText(arg0_1.task_bg:Find("Text"), i18n("Outpost_20250904_Progress"))
	setText(arg0_1.task_bg:Find("display_btn/Text"), i18n("other_world_temple_award"))
end

function var0_0.OnDataSetting(arg0_2)
	if arg0_2.ptData then
		arg0_2.ptData:Update(arg0_2.activity)
	else
		arg0_2.ptData = ActivityPtData.New(arg0_2.activity)
	end
end

function var0_0.OnShowFlush(arg0_3)
	var0_0.super.OnShowFlush(arg0_3)

	if arg0_3.contextData.activeScenario then
		triggerButton(arg0_3.skinBtn)
	end
end

function var0_0.OnFirstFlush(arg0_4)
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
		arg0_4:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.getBtn, function()
		arg0_4:GetAllAward()
	end, SFX_PANEL)
	arg0_4:OnAddUI()
	arg0_4:OnUpdateFlush()
end

function var0_0.OnAddUI(arg0_8)
	onButton(arg0_8, arg0_8.skinBtn, function()
		arg0_8.scenario:Load()
		arg0_8.scenario:SetActivity(arg0_8.activity)
		arg0_8.scenario:UpdateStoryTask()
		arg0_8.scenario:ActionInvoke("UpdateView")
		arg0_8:ShowScenarioLayer(true)
	end, SFX_PANEL)
	setActive(arg0_8.skinBtn:Find("red"), arg0_8.scenario:IsShowRed(arg0_8.activity))
end

function var0_0.SwitchBG(arg0_10, arg1_10, arg2_10, arg3_10)
	if not arg1_10 or #arg1_10 <= 0 then
		existCall(arg2_10)

		return
	elseif arg3_10 then
		-- block empty
	elseif table.equal(arg0_10.currentBG, arg1_10) then
		return
	end

	arg0_10.currentBG = arg1_10

	for iter0_10, iter1_10 in ipairs(arg0_10.mapGroup) do
		arg0_10.loader:ClearRequest(iter1_10)
	end

	table.clear(arg0_10.mapGroup)

	local var0_10 = arg0_10.loader:GetSpriteDirect("bg/" .. arg1_10[1].BG, "", function(arg0_11)
		setImageSprite(arg0_10.bg, arg0_11)
		SetActive(arg0_10.bg, true)
	end)

	table.insert(arg0_10.mapGroup, var0_10)
end

function var0_0.ShowScenarioLayer(arg0_12, arg1_12)
	if arg1_12 then
		arg0_12.coreActivityUI:ActiveScenarioLayer(true)
		arg0_12.scenario:ActionInvoke("Show")
	else
		arg0_12.scenario:Hide()
		setActive(arg0_12.skinBtn:Find("red"), arg0_12.scenario:IsShowRed(arg0_12.activity))
		arg0_12.coreActivityUI:ActiveScenarioLayer(false)
	end
end

function var0_0.IsShowingPopWindow(arg0_13)
	return arg0_13.scenario:isShowing()
end

function var0_0.ClosePopWindow(arg0_14)
	arg0_14.scenario:Hide()
	arg0_14:ShowScenarioLayer(false)
end

function var0_0.GetAllAward(arg0_15)
	local var0_15 = {}
	local var1_15 = arg0_15.ptData:GetAward()
	local var2_15 = getProxy(PlayerProxy):getRawData()
	local var3_15 = pg.gameset.urpt_chapter_max.description[1]
	local var4_15 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_15)
	local var5_15, var6_15 = Task.StaticJudgeOverflow(var2_15.gold, var2_15.oil, var4_15, true, true, {
		{
			var1_15.type,
			var1_15.id,
			var1_15.count
		}
	})

	if var5_15 then
		table.insert(var0_15, function(arg0_16)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("award_max_warning"),
				items = var6_15,
				onYes = arg0_16
			})
		end)
	end

	seriesAsync(var0_15, function()
		local var0_17, var1_17 = arg0_15.ptData:GetResProgress()

		arg0_15:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0_15.ptData:GetId(),
			arg1 = var1_17
		})
	end)
end

function var0_0.OnUpdateFlush(arg0_18)
	local var0_18, var1_18, var2_18 = arg0_18.ptData:GetLevelProgress()

	if arg0_18.step then
		setText(arg0_18.step, var0_18 .. "/" .. var1_18)
	end

	local var3_18 = arg0_18.activity:getConfig("config_client").story

	if checkExist(var3_18, {
		var0_18
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var3_18[var0_18][1])
	end

	local var4_18, var5_18, var6_18 = arg0_18.ptData:GetResProgress()

	if var5_18 < var4_18 then
		var4_18 = var5_18
	end

	setText(arg0_18.progres, setColorStr(var4_18, "#3f93d4") .. setColorStr("/" .. var5_18, "#747c88"))
	setSlider(arg0_18.slider, 0, 1, var6_18)

	local var7_18 = arg0_18.ptData:CanGetAward()
	local var8_18 = arg0_18.ptData:CanGetNextAward()
	local var9_18 = arg0_18.ptData:CanGetMorePt()

	setActive(arg0_18.battleBtn, var9_18 and not var7_18 and var8_18)
	setActive(arg0_18.getBtn, var7_18)
	setActive(arg0_18.gotBtn, not var8_18)

	local var10_18 = arg0_18.ptData:GetAward()

	updateDrop(arg0_18.awardTF, var10_18)
	onButton(arg0_18, arg0_18.awardTF, function()
		arg0_18:emit(BaseUI.ON_DROP, var10_18)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_20)
	if arg0_20.scenario:isShowing() then
		arg0_20.scenario:Hide()
	end

	arg0_20.scenario:Destroy()
end

function var0_0.GetWorldPtData(arg0_21, arg1_21)
	if arg1_21 <= pg.TimeMgr.GetInstance():GetServerTime() - (ActivityMainScene.Data2Time or 0) then
		ActivityMainScene.Data2Time = pg.TimeMgr.GetInstance():GetServerTime()

		arg0_21:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 2,
			activity_id = arg0_21.ptData:GetId()
		})
	end
end

return var0_0

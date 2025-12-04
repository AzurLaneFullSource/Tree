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
	arg0_3:OnAddUI()
	arg0_3:OnUpdateFlush()
end

function var0_0.OnAddUI(arg0_7)
	arg0_7.skinBtn = arg0_7.bg:Find("skinbtn")

	onButton(arg0_7, arg0_7.skinBtn, function()
		arg0_7.scenario:Load()
		arg0_7.scenario:SetActivity(arg0_7.activity)
		arg0_7.scenario:UpdateStoryTask()
		arg0_7.scenario:ActionInvoke("UpdateView")
		arg0_7:ShowScenarioLayer(true)
	end, SFX_PANEL)
	setActive(arg0_7.skinBtn:Find("red"), arg0_7.scenario:IsShowRed(arg0_7.activity))
end

function var0_0.SwitchBG(arg0_9, arg1_9, arg2_9, arg3_9)
	if not arg1_9 or #arg1_9 <= 0 then
		existCall(arg2_9)

		return
	elseif arg3_9 then
		-- block empty
	elseif table.equal(arg0_9.currentBG, arg1_9) then
		return
	end

	arg0_9.currentBG = arg1_9

	for iter0_9, iter1_9 in ipairs(arg0_9.mapGroup) do
		arg0_9.loader:ClearRequest(iter1_9)
	end

	table.clear(arg0_9.mapGroup)

	local var0_9 = arg0_9.loader:GetSpriteDirect("bg/" .. arg1_9[1].BG, "", function(arg0_10)
		setImageSprite(arg0_9.bg, arg0_10)
		SetActive(arg0_9.bg, true)
	end)

	table.insert(arg0_9.mapGroup, var0_9)
end

function var0_0.ShowScenarioLayer(arg0_11, arg1_11)
	if arg1_11 then
		arg0_11.coreActivityUI:ActiveScenarioLayer(true)
		arg0_11.scenario:ActionInvoke("Show")
	else
		arg0_11.scenario:Hide()
		setActive(arg0_11.skinBtn:Find("red"), arg0_11.scenario:IsShowRed(arg0_11.activity))
		arg0_11.coreActivityUI:ActiveScenarioLayer(false)
	end
end

function var0_0.IsShowingPopWindow(arg0_12)
	return arg0_12.scenario:isShowing()
end

function var0_0.ClosePopWindow(arg0_13)
	arg0_13.scenario:Hide()
	arg0_13:ShowScenarioLayer(false)
end

function var0_0.GetAllAward(arg0_14)
	local var0_14 = {}
	local var1_14 = arg0_14.ptData:GetAward()
	local var2_14 = getProxy(PlayerProxy):getRawData()
	local var3_14 = pg.gameset.urpt_chapter_max.description[1]
	local var4_14 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_14)
	local var5_14, var6_14 = Task.StaticJudgeOverflow(var2_14.gold, var2_14.oil, var4_14, true, true, {
		{
			var1_14.type,
			var1_14.id,
			var1_14.count
		}
	})

	if var5_14 then
		table.insert(var0_14, function(arg0_15)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("award_max_warning"),
				items = var6_14,
				onYes = arg0_15
			})
		end)
	end

	seriesAsync(var0_14, function()
		local var0_16, var1_16 = arg0_14.ptData:GetResProgress()

		arg0_14:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0_14.ptData:GetId(),
			arg1 = var1_16
		})
	end)
end

function var0_0.OnUpdateFlush(arg0_17)
	local var0_17, var1_17, var2_17 = arg0_17.ptData:GetLevelProgress()

	if arg0_17.step then
		setText(arg0_17.step, var0_17 .. "/" .. var1_17)
	end

	local var3_17 = arg0_17.activity:getConfig("config_client").story

	if checkExist(var3_17, {
		var0_17
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var3_17[var0_17][1])
	end

	local var4_17, var5_17, var6_17 = arg0_17.ptData:GetResProgress()

	if var5_17 < var4_17 then
		var4_17 = var5_17
	end

	setText(arg0_17.progres, setColorStr(var4_17, "#3f93d4") .. setColorStr("/" .. var5_17, "#747c88"))
	setSlider(arg0_17.slider, 0, 1, var6_17)

	local var7_17 = arg0_17.ptData:CanGetAward()
	local var8_17 = arg0_17.ptData:CanGetNextAward()
	local var9_17 = arg0_17.ptData:CanGetMorePt()

	setActive(arg0_17.battleBtn, var9_17 and not var7_17 and var8_17)
	setActive(arg0_17.getBtn, var7_17)
	setActive(arg0_17.gotBtn, not var8_17)

	local var10_17 = arg0_17.ptData:GetAward()

	updateDrop(arg0_17.awardTF, var10_17)
	onButton(arg0_17, arg0_17.awardTF, function()
		arg0_17:emit(BaseUI.ON_DROP, var10_17)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_19)
	if arg0_19.scenario:isShowing() then
		arg0_19.scenario:Hide()
	end

	arg0_19.scenario:Destroy()
end

function var0_0.GetWorldPtData(arg0_20, arg1_20)
	if arg1_20 <= pg.TimeMgr.GetInstance():GetServerTime() - (ActivityMainScene.Data2Time or 0) then
		ActivityMainScene.Data2Time = pg.TimeMgr.GetInstance():GetServerTime()

		arg0_20:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 2,
			activity_id = arg0_20.ptData:GetId()
		})
	end
end

return var0_0

local var0_0 = class("BossRushVerSardiniaSPScene", import("view.base.BaseUI"))

var0_0.DISPLAY = {
	STORY = "Story",
	BATTLE = "Battle"
}

function var0_0.getUIName(arg0_1)
	return "BossRushVerSardiniaSPUI"
end

function var0_0.init(arg0_2)
	arg0_2.top = arg0_2._tf:Find("Top")
	arg0_2.seriesNodes = {}

	eachChild(arg0_2._tf:Find("Battle/Nodes"), function(arg0_3, arg1_3)
		arg0_2.seriesNodes[arg0_3.name] = arg0_3
	end)

	arg0_2.progressText = arg0_2.rtStoryAward:Find("Text")

	for iter0_2 = 1, arg0_2.rtStoryItems.childCount do
		local var0_2 = arg0_2.rtStoryItems:GetChild(iter0_2 - 1)

		var0_2:GetComponent(typeof(LayoutElement)).preferredWidth = iter0_2 == arg0_2.index and arg0_2.EXPAND_WIDTH or arg0_2.CLOSE_WIDTH

		setCanvasGroupAlpha(var0_2:Find("close"), iter0_2 == arg0_2.index and 0 or 1)
		setText(var0_2:Find("get/Text"), i18n("SardiniaSPCoreActivityUI_unlock"))
		onButton(arg0_2, var0_2, function()
			if arg0_2.blockAnim then
				return
			end

			arg0_2:SelectItem(iter0_2)
		end, SFX_PANEL)
	end

	arg0_2.ActionSequence = {}
end

function var0_0.SetActivity(arg0_5, arg1_5)
	arg0_5.activity = arg1_5
end

function var0_0.SetPtActivity(arg0_6, arg1_6)
	arg0_6.ptActivity = arg1_6

	setText(arg0_6.countPT, arg0_6.ptActivity.data1)
	setActive(arg0_6.tipPT, Activity.IsActivityReady(arg0_6.ptActivity))
end

function var0_0.SetStoryActivity(arg0_7, arg1_7)
	arg0_7.storyActivity = arg1_7
	arg0_7.storyList = arg1_7:GetConfigClientSetting("story")
end

function var0_0.SetTasksActivity(arg0_8, arg1_8)
	arg0_8.tasksActivity = arg1_8
end

function var0_0.SelectItem(arg0_9, arg1_9)
	if arg0_9.index == arg1_9 then
		return
	end

	arg0_9.index = arg1_9
	arg0_9.blockAnim = true

	for iter0_9, iter1_9 in ipairs(arg0_9.LTList or {}) do
		LeanTween.cancel(iter1_9)
	end

	arg0_9.LTList = {}

	for iter2_9 = 1, arg0_9.rtStoryItems.childCount do
		local var0_9 = arg0_9.rtStoryItems:GetChild(iter2_9 - 1)
		local var1_9 = var0_9:GetComponent(typeof(LayoutElement))
		local var2_9 = var1_9.preferredWidth
		local var3_9 = iter2_9 == arg1_9 and arg0_9.EXPAND_WIDTH or arg0_9.CLOSE_WIDTH

		if var2_9 ~= var3_9 then
			local var4_9 = math.abs(var3_9 - var2_9) / arg0_9.DURATION_PARAMETER

			table.insert(arg0_9.LTList, LeanTween.value(go(var0_9), var2_9, var3_9, var4_9):setEase(LeanTweenType.easeOutSine):setOnUpdate(System.Action_float(function(arg0_10)
				var1_9.preferredWidth = arg0_10
			end)).uniqueId)
			table.insert(arg0_9.LTList, LeanTween.alphaCanvas(var0_9:Find("close"):GetComponent(typeof(CanvasGroup)), iter2_9 == arg1_9 and 0 or 1, var4_9):setEase(LeanTweenType.easeOutSine).uniqueId)
		end
	end

	local var5_9 = pg.NewStoryMgr.GetInstance()

	if arg0_9.index ~= 1 and arg0_9.storyActivity.data1 > 0 and not var5_9:IsPlayed(arg0_9.storyList[arg0_9.index - 1][1]) then
		arg0_9:emit(BossRushVerSardiniaSPMediator.ON_ACTIVITY_UNLOCKSTOIRY, arg0_9.storyActivity.id, var5_9:StoryName2StoryId(arg0_9.storyList[arg0_9.index - 1][1]))
	else
		arg0_9:UpdataStoryState()
	end
end

function var0_0.didEnter(arg0_11)
	onButton(arg0_11, arg0_11.btnBack, function()
		arg0_11:closeView()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.btnHome, function()
		arg0_11:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("SardiniaSPCoreActivityUI_help")
		})
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.btnRank, function()
		arg0_11:emit(BossRushVerSardiniaSPMediator.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.btnPT, function()
		arg0_11:emit(BossRushVerSardiniaSPMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = arg0_11.ptActivity.id
		})
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.btnTask, function()
		arg0_11:emit(BossRushVerSardiniaSPMediator.GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.switchToggle:Find("Story"), function()
		if arg0_11.blockAnim then
			return
		end

		arg0_11:SetDisplayMode(var0_0.DISPLAY.BATTLE)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.switchToggle:Find("Battle"), function()
		if arg0_11.blockAnim then
			return
		end

		arg0_11:SetDisplayMode(var0_0.DISPLAY.STORY)
	end, SFX_PANEL)
	arg0_11:SetDisplayMode(arg0_11.contextData.displayMode or var0_0.DISPLAY.BATTLE)
end

function var0_0.SetDisplayMode(arg0_20, arg1_20)
	arg0_20.contextData.displayMode = arg1_20

	arg0_20:UpdateView()
end

function var0_0.UpdateView(arg0_21)
	local var0_21 = arg0_21.contextData.displayMode == var0_0.DISPLAY.BATTLE

	arg0_21.switchToggle:Find(arg0_21.contextData.displayMode):SetAsLastSibling()
	setActive(arg0_21.rtPageBattle, var0_21)
	setActive(arg0_21.rtPageStory, not var0_21)

	if var0_21 then
		arg0_21:UpdateBattle()
	else
		arg0_21:UpdateStory()
	end

	arg0_21:UpdateTipDisplay()
end

function var0_0.UpdateBattle(arg0_22)
	local var0_22 = arg0_22.activity
	local var1_22 = arg0_22.contextData.showFlash and underscore.to_array(var0_22:GetPassCounts()) or nil

	arg0_22.contextData.showFlash = nil

	local var2_22 = {}

	for iter0_22, iter1_22 in ipairs(var0_22:getConfig("config_data")) do
		local var3_22 = arg0_22.seriesNodes[tostring(iter1_22)]
		local var4_22 = BossRushSeriesData.New({
			id = iter1_22,
			actId = var0_22.id
		})

		var2_22[iter0_22] = var4_22

		local var5_22 = var4_22:IsUnlock(var0_22)

		setActive(var3_22:Find("lock"), not var5_22)

		local var6_22 = var0_22:HasPassSeries(var4_22.id)

		setActive(var3_22:Find("finish"), var6_22)
		setActive(var3_22:Find("finish"):GetChild(0), var1_22 and arg0_22.contextData.passCounts and not table.contains(arg0_22.contextData.passCounts, var4_22.id) and table.contains(var1_22, var4_22.id))

		local var7_22 = var4_22:GetType() == BossRushSeriesData.TYPE.SP
		local var8_22 = true

		if var7_22 then
			setActive(var3_22:Find("times"), var5_22)

			local var9_22 = var0_22:GetUsedBonus()[iter0_22] or 0
			local var10_22 = var4_22:GetMaxBonusCount()

			var8_22 = var10_22 - var9_22 > 0

			setText(var3_22:Find("times/Text"), i18n("series_enemy_SP_count") .. setColorStr(math.max(0, var10_22 - var9_22) .. "/" .. var10_22, "#f77d24"))
		end

		onButton(arg0_22, var3_22, function()
			if not var5_22 then
				local var0_23 = var4_22:GetPreSeriesId()
				local var1_23 = BossRushSeriesData.New({
					id = var0_23
				})

				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_unlock", var1_23:GetName()))

				return
			end

			if not var8_22 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_SP_error"))

				return
			end

			local var2_23 = {}
			local var3_23

			if iter0_22 > 1 and var4_22:IsFleetsEmpty() then
				table.insert(var2_23, function(arg0_24)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("SardiniaSPCoreActivityUI_fleetconfirm"),
						onYes = function()
							var4_22:CopyFleetsByOther(var2_22[iter0_22 - 1])
							arg0_24()
						end,
						onNo = arg0_24
					})
				end)
			end

			seriesAsync(var2_23, function()
				arg0_22:emit(BossRushVerSardiniaSPMediator.ON_FLEET_SELECT, var4_22)
			end)
		end, SFX_PANEL)
	end
end

var0_0.EXPAND_WIDTH = 628
var0_0.CLOSE_WIDTH = 136
var0_0.DURATION_PARAMETER = 1500

function var0_0.UpdateStory(arg0_27)
	if not arg0_27.index then
		arg0_27:SelectItem(1)
	else
		arg0_27:UpdataStoryState()
	end
end

function var0_0.UpdataStoryState(arg0_28, arg1_28)
	local var0_28 = pg.NewStoryMgr.GetInstance()
	local var1_28 = arg1_28 and var0_28:StoryId2StoryName(arg1_28) or nil

	assert(not arg1_28 or arg0_28.storyList[arg0_28.index - 1][1] == var1_28)
	eachChild(arg0_28.rtStoryItems, function(arg0_29, arg1_29)
		arg1_29 = arg1_29 + 1

		local var0_29
		local var1_29
		local var2_29

		if arg1_29 == 1 then
			var0_29 = false
			var2_29 = false
		else
			var0_29 = arg0_28.index == arg1_29 and arg1_28
			var0_29 = var0_29 or var0_28:IsPlayed(arg0_28.storyList[arg1_29 - 1][1])
			var2_29 = arg0_28.storyActivity.data1 > 0
		end

		setActive(arg0_29:Find("got"), var0_29)
		setActive(arg0_29:Find("get"), not var0_29 and var2_29)
	end)

	local var2_28 = {}

	if arg0_28.index == 1 then
		local var3_28 = arg0_28.activity:GetConfigClientSetting("openStory")

		if not var0_28:IsPlayed(var3_28) then
			table.insert(var2_28, function(arg0_30)
				var0_28:Play(var3_28, arg0_30)
			end)
		end
	end

	if var1_28 and not var0_28:IsPlayed(var1_28) then
		table.insert(var2_28, function(arg0_31)
			var0_28:Play(var1_28, arg0_31)
		end)
	end

	local var4_28 = arg0_28.activity:GetConfigClientSetting("endStory")

	if not var0_28:IsPlayed(var4_28) and underscore.all(arg0_28.storyList, function(arg0_32)
		return var0_28:IsPlayed(arg0_32[1]) or arg0_32[1] == var1_28
	end) then
		table.insert(var2_28, function(arg0_33)
			var0_28:Play(var4_28, arg0_33)
		end)
	end

	arg0_28.blockAnim = false

	seriesAsync(var2_28, function()
		arg0_28:UpdateStoryTask()
	end)
end

function var0_0.PlayStory(arg0_35, arg1_35, arg2_35)
	if not arg1_35 then
		return existCall(arg2_35)
	end

	local var0_35 = pg.NewStoryMgr.GetInstance()
	local var1_35 = var0_35:IsPlayed(arg1_35)

	seriesAsync({
		function(arg0_36)
			if var1_35 then
				return arg0_36()
			end

			local var0_36 = tonumber(arg1_35)

			if var0_36 and var0_36 > 0 then
				arg0_35:emit(BossRushVerSardiniaSPMediator.ON_PERFORM_COMBAT, var0_36)
			else
				var0_35:Play(arg1_35, arg0_36)
			end
		end
	}, arg2_35)
end

function var0_0.UpdateStoryTask(arg0_37)
	local var0_37 = arg0_37.activity:GetConfigClientSetting("tasks")[1]

	arg0_37.storyTask = getProxy(TaskProxy):getTaskVO(var0_37) or Task.New({
		submit_time = 1,
		id = var0_37
	})

	local var1_37 = arg0_37.storyTask:getProgress()
	local var2_37 = arg0_37.storyTask:getTargetNumber()

	setText(arg0_37.progressText, i18n("SardiniaSPCoreActivityUI_story_reward_count", arg0_37.storyActivity.data1, var1_37))

	local var3_37 = arg0_37.storyTask:getConfig("award_display")
	local var4_37 = Drop.Create(var3_37[1])
	local var5_37 = arg0_37.rtStoryAward:Find("IconTpl")

	updateDrop(var5_37, var4_37)
	onButton(arg0_37, var5_37, function()
		arg0_37:emit(BaseUI.ON_DROP, var4_37)
	end, SFX_PANEL)

	local var6_37 = arg0_37.storyTask:getTaskStatus()

	setActive(var5_37:Find("get"), var6_37 == 1)
	setActive(var5_37:Find("got"), var6_37 == 2)

	if var6_37 == 1 then
		arg0_37:emit(BossRushVerSardiniaSPMediator.ON_TASK_SUBMIT, arg0_37.storyTask)
	end
end

function var0_0.addbubbleMsgBoxList(arg0_39, arg1_39)
	local var0_39 = #arg0_39.ActionSequence == 0

	table.insertto(arg0_39.ActionSequence, arg1_39)

	if not var0_39 then
		return
	end

	arg0_39:resumeBubble()
end

function var0_0.addbubbleMsgBox(arg0_40, arg1_40)
	local var0_40 = #arg0_40.ActionSequence == 0

	table.insert(arg0_40.ActionSequence, arg1_40)

	if not var0_40 then
		return
	end

	arg0_40:resumeBubble()
end

function var0_0.resumeBubble(arg0_41)
	if #arg0_41.ActionSequence == 0 then
		return
	end

	local var0_41

	local function var1_41()
		local var0_42 = arg0_41.ActionSequence[1]

		if var0_42 then
			var0_42(function()
				table.remove(arg0_41.ActionSequence, 1)
				var1_41()
			end)
		end
	end

	var1_41()
end

function var0_0.CleanBubbleMsgbox(arg0_44)
	table.clean(arg0_44.ActionSequence)
end

function var0_0.UpdateTipDisplay(arg0_45)
	setActive(arg0_45.rtToggleTip, arg0_45.contextData.displayMode == var0_0.DISPLAY.BATTLE and arg0_45:IsStoryTip())
	setActive(arg0_45.btnTask:Find("tip"), Activity.IsActivityReady(arg0_45.tasksActivity))
end

function var0_0.IsStoryTip(arg0_46)
	local var0_46 = pg.NewStoryMgr.GetInstance()

	if not var0_46:IsPlayed(arg0_46.activity:GetConfigClientSetting("openStory")) then
		return true
	end

	if Activity.IsActivityReady(arg0_46.storyActivity) then
		return true
	end

	if not var0_46:IsPlayed(arg0_46.activity:GetConfigClientSetting("endStory")) and underscore.all(arg0_46.storyList, function(arg0_47)
		return var0_46:IsPlayed(arg0_47[1])
	end) then
		return true
	end

	local var1_46 = arg0_46.activity:GetConfigClientSetting("tasks")[1]
	local var2_46 = var1_46 and getProxy(TaskProxy):getTaskVO(var1_46)

	if var2_46 and var2_46:getTaskStatus() == 1 then
		return true
	end

	return false
end

function var0_0.willExit(arg0_48)
	arg0_48.contextData.passCounts = underscore.to_array(arg0_48.activity:GetPassCounts())
end

return var0_0

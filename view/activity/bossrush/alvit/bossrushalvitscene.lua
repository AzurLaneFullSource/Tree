local var0_0 = class("BossRushAlvitScene", import("view.base.BaseUI"))

var0_0.DISPLAY = {
	STORY = 2,
	BATTLE = 1
}

function var0_0.getUIName(arg0_1)
	return "BossRushAlvitUI"
end

function var0_0.init(arg0_2)
	arg0_2.top = arg0_2._tf:Find("Top")
	arg0_2.ptBtn = arg0_2.top:Find("right/pt")
	arg0_2.ptText = arg0_2.ptBtn:Find("value/Text")
	arg0_2.ptTip = arg0_2.ptBtn:Find("tip")
	arg0_2.rankBtn = arg0_2.top:Find("right/rank")
	arg0_2.taskBtn = arg0_2.top:Find("right/task")
	arg0_2.taskTip = arg0_2.taskBtn:Find("tip")
	arg0_2.seriesNodes = _.map(_.range(arg0_2._tf:Find("Battle/Nodes").childCount), function(arg0_3)
		return arg0_2._tf:Find("Battle/Nodes"):GetChild(arg0_3 - 1)
	end)
	arg0_2.nodes = {}

	for iter0_2 = 1, arg0_2._tf:Find("Story/Nodes").childCount do
		local var0_2 = arg0_2._tf:Find("Story/Nodes"):GetChild(iter0_2 - 1)

		arg0_2.nodes[var0_2.name] = var0_2
	end

	arg0_2.progressText = arg0_2._tf:Find("Story/Desc/Text")
	arg0_2.storyAward = arg0_2._tf:Find("Story/Award")
	arg0_2.ActionSequence = {}
end

function var0_0.SetActivity(arg0_4, arg1_4)
	arg0_4.activity = arg1_4
end

function var0_0.SetPtActivity(arg0_5, arg1_5)
	arg0_5.ptActivity = arg1_5
	arg0_5.ptData = ActivityPtData.New(arg0_5.ptActivity)
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6.top:Find("top/back"), function()
		arg0_6:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6.top:Find("top/home"), function()
		arg0_6:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.rankBtn, function()
		arg0_6:emit(BossRushAlvitMediator.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.ptBtn, function()
		arg0_6:emit(BossRushAlvitMediator.GO_SUBLAYER, Context.New({
			mediator = ChildishnessSchoolPtMediator,
			viewComponent = ChildishnessSchoolPtPage
		}))
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.taskBtn, function()
		arg0_6:emit(BossRushAlvitMediator.GO_SUBLAYER, Context.New({
			mediator = ChildishnessSchoolTaskMediator,
			viewComponent = ChildishnessSchoolTaskPage
		}))
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6._tf:Find("Battle/Story"), function()
		arg0_6:SetDisplayMode(var0_0.DISPLAY.STORY)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6._tf:Find("Story/Battle"), function()
		arg0_6:SetDisplayMode(var0_0.DISPLAY.BATTLE)
	end, SFX_PANEL)

	local var0_6 = arg0_6.activity:getConfig("config_client").storys

	arg0_6.storyNodesDict = {}

	_.each(var0_6, function(arg0_14)
		arg0_6.storyNodesDict[arg0_14] = BossRushStoryNode.New({
			id = arg0_14
		})
	end)
	arg0_6:UpdateStoryTask()

	local var1_6 = arg0_6.contextData.displayMode or BossRushAlvitScene.DISPLAY.BATTLE

	arg0_6.contextData.displayMode = nil

	arg0_6:SetDisplayMode(var1_6)
end

function var0_0.getBGM(arg0_15)
	local var0_15 = pg.voice_bgm[arg0_15.__cname]

	if not var0_15 then
		return nil
	end

	local var1_15 = var0_15.bgm
	local var2_15 = "story-richang-11"
	local var3_15 = arg0_15.contextData.displayMode

	if var3_15 == var0_0.DISPLAY.BATTLE then
		return var1_15
	elseif var3_15 == var0_0.DISPLAY.STORY then
		return var2_15
	end
end

function var0_0.SetDisplayMode(arg0_16, arg1_16)
	if arg1_16 == arg0_16.contextData.displayMode then
		return
	end

	arg0_16.contextData.displayMode = arg1_16

	arg0_16:PlayBGM()
	arg0_16:UpdateView()
end

function var0_0.UpdateView(arg0_17)
	local var0_17 = arg0_17.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_17._tf:Find("Battle"), var0_17)
	setActive(arg0_17._tf:Find("Story"), not var0_17)
	arg0_17:UpdateBattle()

	if not var0_17 then
		arg0_17:UpdateStory()
	end

	arg0_17:UpdateTaskTip()

	local var1_17 = arg0_17.contextData.displayMode

	arg0_17:addbubbleMsgBoxList({
		function(arg0_18)
			local var0_18

			if var1_17 == var0_0.DISPLAY.BATTLE then
				var0_18 = arg0_17.activity:getConfig("config_client").openActivityStory
			elseif var1_17 == var0_0.DISPLAY.STORY then
				var0_18 = arg0_17.activity:getConfig("config_client").openStory
			end

			arg0_17:PlayStory(var0_18, arg0_18)
		end,
		function(arg0_19)
			local var0_19 = true

			for iter0_19, iter1_19 in pairs(arg0_17.storyNodesDict) do
				local var1_19 = iter1_19:GetStory()

				if var1_19 and var1_19 ~= "" then
					var0_19 = var0_19 and pg.NewStoryMgr.GetInstance():IsPlayed(var1_19)
				end

				if not var0_19 then
					break
				end
			end

			if var0_19 and arg0_17.storyTask and arg0_17.storyTask:getTaskStatus() == 2 then
				local var2_19 = arg0_17.activity:getConfig("config_client").endStory

				arg0_17:PlayStory(var2_19, function(arg0_20)
					arg0_19()

					if arg0_20 then
						arg0_17:UpdateView()
					end
				end)

				return
			end

			arg0_19()
		end
	})
end

function var0_0.UpdateBattle(arg0_21)
	local var0_21 = arg0_21.activity
	local var1_21 = var0_21:GetActiveSeriesIds()

	table.Foreach(arg0_21.seriesNodes, function(arg0_22, arg1_22)
		local var0_22 = var1_21[arg0_22]
		local var1_22 = BossRushSeriesData.New({
			id = var0_22,
			actId = var0_21.id
		})
		local var2_22 = var1_22:IsUnlock(var0_21)

		setActive(arg1_22, var2_22)

		local var3_22 = var1_22:GetType() == BossRushSeriesData.TYPE.SP
		local var4_22 = true

		if var3_22 then
			local var5_22 = var0_21:GetUsedBonus()[arg0_22] or 0
			local var6_22 = var1_22:GetMaxBonusCount()

			setText(arg1_22:Find("count/Text"), i18n("series_enemy_SP_count") .. math.max(0, var6_22 - var5_22) .. "/" .. var6_22)

			var4_22 = var6_22 - var5_22 > 0
		end

		local function var7_22()
			if not var2_22 then
				local var0_23 = var1_22:GetPreSeriesId()
				local var1_23 = BossRushSeriesData.New({
					id = var0_23
				})

				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_unlock", var1_23:GetName()))

				return
			end

			if not var4_22 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_SP_error"))

				return
			end

			arg0_21:emit(BossRushAlvitMediator.ON_FLEET_SELECT, var1_22)
		end

		onButton(arg0_21, arg1_22:Find("icon"), function()
			var7_22()
		end, SFX_PANEL)
		onButton(arg0_21, arg1_22:Find("text"), function()
			var7_22()
		end, SFX_PANEL)
	end)
	setText(arg0_21.ptText, arg0_21.ptActivity.data1)
	setActive(arg0_21.ptTip, Activity.IsActivityReady(arg0_21.ptActivity))
	setActive(arg0_21._tf:Find("Battle/Story/new"), arg0_21.storyTask and arg0_21.storyTask:getTaskStatus() ~= 2)
end

function var0_0.UpdateStory(arg0_26)
	local var0_26 = {}
	local var1_26 = pg.NewStoryMgr.GetInstance()
	local var2_26 = 1
	local var3_26 = 2
	local var4_26 = 3
	local var5_26 = 0
	local var6_26 = 0

	for iter0_26, iter1_26 in pairs(arg0_26.storyNodesDict) do
		var0_26[iter0_26] = {}

		local var7_26 = iter1_26:GetStory()
		local var8_26 = true

		if var7_26 and var7_26 ~= "" then
			var8_26 = var1_26:IsPlayed(var7_26)
			var5_26 = var5_26 + (var8_26 and 1 or 0)
			var6_26 = var6_26 + 1
		end

		var0_26[iter0_26].status = var8_26 and var4_26 or var2_26
	end

	setText(arg0_26.progressText, var5_26 .. "/" .. var6_26)

	local var9_26 = _.sort(_.values(arg0_26.storyNodesDict), function(arg0_27, arg1_27)
		return arg0_27.id < arg1_27.id
	end)

	_.each(var9_26, function(arg0_28)
		local var0_28 = arg0_28:GetTriggers()

		if var0_26[arg0_28.id].status == var4_26 then
			return
		end

		if not _.any(var0_28, function(arg0_29)
			if arg0_29.type == BossRushStoryNode.TRIGGER_TYPE.PT_GOT then
				return arg0_26.ptActivity.data1 < arg0_29.value
			elseif arg0_29.type == BossRushStoryNode.TRIGGER_TYPE.SERIES_PASSED then
				return not BossRushSeriesData.New({
					id = arg0_29.value,
					actId = arg0_26.activity.id
				}):IsUnlock(arg0_26.activity)
			elseif arg0_29.type == BossRushStoryNode.TRIGGER_TYPE.STORY_READED then
				return var0_26[arg0_29.value].status < var4_26
			end
		end) then
			var0_26[arg0_28.id].status = var3_26
		end
	end)
	table.Foreach(arg0_26.storyNodesDict, function(arg0_30, arg1_30)
		local var0_30 = arg0_26.nodes[tostring(arg1_30.id)]
		local var1_30 = isActive(var0_30)

		if var0_26[arg0_30].status > var2_26 then
			if not var1_30 then
				setActive(var0_30, true)
			end

			setActive(var0_30, true)

			if not var1_30 then
				var0_30:GetComponent(typeof(Animation)):Play("anim_kinder_bossrush_story_tip")
			end
		else
			setActive(var0_30, false)
		end

		setText(var0_30:Find("main/Text"), arg1_30:GetName())

		local var2_30 = var0_26[arg0_30].status == var3_26
		local var3_30 = arg1_30:GetType()

		if var3_30 == BossRushStoryNode.NODE_TYPE.NORMAL then
			setActive(var0_30:Find("tags/story"), true)
			setActive(var0_30:Find("tags/battle"), false)
		elseif var3_30 == BossRushStoryNode.NODE_TYPE.EVENT then
			-- block empty
		elseif var3_30 == BossRushStoryNode.NODE_TYPE.BATTLE then
			setActive(var0_30:Find("tags/story"), false)
			setActive(var0_30:Find("tags/battle"), true)
		end

		local var4_30 = var0_26[arg0_30].status == var4_26

		setActive(var0_30:Find("main"), not var4_30)
		setActive(var0_30:Find("finish"), var4_30)
		setActive(var0_30:Find("finish_tag"), var4_30)
		onButton(arg0_26, var0_30, function()
			if not var2_30 or var4_30 then
				return
			end

			local var0_31 = arg1_30:GetStory()

			arg0_26:PlayStory(var0_31, function()
				arg0_26:UpdateView()
			end)
		end)
	end)
	setActive(arg0_26.storyAward, tobool(arg0_26.storyTask))

	if arg0_26.storyTask then
		local var10_26 = arg0_26.storyTask:getConfig("award_display")
		local var11_26 = Drop.New({
			type = var10_26[1][1],
			id = var10_26[1][2],
			count = var10_26[1][3]
		})

		updateDrop(arg0_26.storyAward:GetChild(0), var11_26)

		local var12_26 = arg0_26.storyTask:getTaskStatus()

		setActive(arg0_26.storyAward:Find("get"), var12_26 == 1)
		setActive(arg0_26.storyAward:Find("got"), var12_26 == 2)

		if var12_26 == 1 then
			arg0_26:emit(BossRushAlvitMediator.ON_TASK_SUBMIT, arg0_26.storyTask)
		end

		onButton(arg0_26, arg0_26.storyAward, function()
			arg0_26:emit(BaseUI.ON_DROP, var11_26)
		end)
	end
end

function var0_0.PlayStory(arg0_34, arg1_34, arg2_34)
	if not arg1_34 then
		return existCall(arg2_34)
	end

	local var0_34 = pg.NewStoryMgr.GetInstance()
	local var1_34 = var0_34:IsPlayed(arg1_34)

	seriesAsync({
		function(arg0_35)
			if var1_34 then
				return arg0_35()
			end

			local var0_35 = tonumber(arg1_34)

			if var0_35 and var0_35 > 0 then
				arg0_34:emit(BossRushAlvitMediator.ON_PERFORM_COMBAT, var0_35)
			else
				var0_34:Play(arg1_34, arg0_35)
			end
		end,
		function(arg0_36, ...)
			existCall(arg2_34, ...)
		end
	})
end

function var0_0.UpdateStoryTask(arg0_37)
	local var0_37 = arg0_37.activity:getConfig("config_client").tasks[1]

	arg0_37.storyTask = getProxy(TaskProxy):getTaskVO(var0_37) or Task.New({
		submit_time = 1,
		id = var0_37
	})
end

function var0_0.UpdateTaskTip(arg0_38)
	setActive(arg0_38.taskTip, Activity.IsActivityReady(getProxy(ActivityProxy):getActivityById(ActivityConst.ALVIT_TASK_ACT_ID)))
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

function var0_0.onBackPressed(arg0_44)
	arg0_44:emit(BossRushAlvitMediator.GO_SCENE, SCENE.KINDERGARTEN, {
		isBack = true
	})
end

function var0_0.CleanBubbleMsgbox(arg0_45)
	table.clean(arg0_45.ActionSequence)
end

return var0_0

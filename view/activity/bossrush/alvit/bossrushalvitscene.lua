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
	arg0_2.seriesNodes = {}

	local var0_2 = arg0_2._tf:Find("Battle/Nodes")

	for iter0_2 = 1, var0_2.childCount do
		local var1_2 = var0_2:GetChild(iter0_2 - 1)

		if isActive(var1_2) then
			table.insert(arg0_2.seriesNodes, var1_2)
		end
	end

	arg0_2.nodes = {}

	for iter1_2 = 1, arg0_2._tf:Find("Story/Nodes").childCount do
		local var2_2 = arg0_2._tf:Find("Story/Nodes"):GetChild(iter1_2 - 1)

		arg0_2.nodes[var2_2.name] = var2_2
	end

	arg0_2.progressText = arg0_2._tf:Find("Story/Desc/Text")
	arg0_2.storyAward = arg0_2._tf:Find("Story/Award")
	arg0_2.ActionSequence = {}
end

function var0_0.SetActivity(arg0_3, arg1_3)
	arg0_3.activity = arg1_3
end

function var0_0.SetPtActivity(arg0_4, arg1_4)
	arg0_4.ptActivity = arg1_4
	arg0_4.ptData = ActivityPtData.New(arg0_4.ptActivity)
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.top:Find("top/back"), function()
		arg0_5:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.top:Find("top/home"), function()
		arg0_5:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.rankBtn, function()
		arg0_5:emit(BossRushAlvitMediator.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.ptBtn, function()
		arg0_5:emit(BossRushAlvitMediator.GO_SUBLAYER, Context.New({
			mediator = ChildishnessSchoolPtMediator,
			viewComponent = ChildishnessSchoolPtPage
		}))
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.taskBtn, function()
		arg0_5:emit(BossRushAlvitMediator.GO_SUBLAYER, Context.New({
			mediator = ChildishnessSchoolTaskMediator,
			viewComponent = ChildishnessSchoolTaskPage
		}))
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("Battle/Story"), function()
		arg0_5:SetDisplayMode(var0_0.DISPLAY.STORY)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("Story/Battle"), function()
		arg0_5:SetDisplayMode(var0_0.DISPLAY.BATTLE)
	end, SFX_PANEL)

	local var0_5 = arg0_5.activity:getConfig("config_client").storys or {}

	arg0_5.storyNodesDict = {}

	_.each(var0_5, function(arg0_13)
		arg0_5.storyNodesDict[arg0_13] = BossRushStoryNode.New({
			id = arg0_13
		})
	end)
	arg0_5:UpdateStoryTask()

	local var1_5 = arg0_5.contextData.displayMode or BossRushAlvitScene.DISPLAY.BATTLE

	arg0_5.contextData.displayMode = nil

	arg0_5:SetDisplayMode(var1_5)
end

function var0_0.getBGM(arg0_14)
	local var0_14 = pg.voice_bgm[arg0_14.__cname]

	if not var0_14 then
		return nil
	end

	local var1_14 = var0_14.bgm
	local var2_14 = "story-richang-11"
	local var3_14 = arg0_14.contextData.displayMode

	if var3_14 == var0_0.DISPLAY.BATTLE then
		return var1_14
	elseif var3_14 == var0_0.DISPLAY.STORY then
		return var2_14
	end
end

function var0_0.SetDisplayMode(arg0_15, arg1_15)
	if arg1_15 == arg0_15.contextData.displayMode then
		return
	end

	arg0_15.contextData.displayMode = arg1_15

	arg0_15:PlayBGM()
	arg0_15:UpdateView()
end

function var0_0.UpdateView(arg0_16)
	local var0_16 = arg0_16.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_16._tf:Find("Battle"), var0_16)
	setActive(arg0_16._tf:Find("Story"), not var0_16)
	arg0_16:UpdateBattle()

	if not var0_16 then
		arg0_16:UpdateStory()
	end

	arg0_16:UpdateTaskTip()

	local var1_16 = arg0_16.contextData.displayMode

	arg0_16:addbubbleMsgBoxList({
		function(arg0_17)
			local var0_17

			if var1_16 == var0_0.DISPLAY.BATTLE then
				var0_17 = arg0_16.activity:getConfig("config_client").openActivityStory
			elseif var1_16 == var0_0.DISPLAY.STORY then
				var0_17 = arg0_16.activity:getConfig("config_client").openStory
			end

			arg0_16:PlayStory(var0_17, arg0_17)
		end,
		function(arg0_18)
			if underscore.all(underscore.values(arg0_16.storyNodesDict), function(arg0_19)
				return arg0_19:IsReaded()
			end) and arg0_16.storyTask and arg0_16.storyTask:getTaskStatus() == 2 then
				local var0_18 = arg0_16.activity:getConfig("config_client").endStory

				arg0_16:PlayStory(var0_18, function(arg0_20)
					arg0_18()

					if arg0_20 then
						arg0_16:UpdateView()
					end
				end)

				return
			end

			arg0_18()
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
	arg0_21:UpdateTpTip()
	setActive(arg0_21._tf:Find("Battle/Story/new"), arg0_21.storyTask and arg0_21.storyTask:getTaskStatus() ~= 2)
end

function var0_0.UpdateTpTip(arg0_26)
	setActive(arg0_26.ptTip, Activity.IsActivityReady(arg0_26.ptActivity))
end

function var0_0.UpdateStory(arg0_27)
	local var0_27 = pg.NewStoryMgr.GetInstance()
	local var1_27 = 0
	local var2_27 = 0

	table.Foreach(arg0_27.storyNodesDict, function(arg0_28, arg1_28)
		local var0_28 = arg0_27.nodes[tostring(arg1_28.id)]
		local var1_28 = isActive(var0_28)
		local var2_28 = arg1_28:IsActive(arg0_27.activity, arg0_27.ptActivity)

		if var2_28 then
			if not var1_28 then
				setActive(var0_28, true)
			end

			setActive(var0_28, true)

			if not var1_28 then
				var0_28:GetComponent(typeof(Animation)):Play("anim_kinder_bossrush_story_tip")
			end
		else
			setActive(var0_28, false)
		end

		setText(var0_28:Find("main/Text"), arg1_28:GetName())

		local var3_28 = arg1_28:GetType()

		if var3_28 == BossRushStoryNode.NODE_TYPE.NORMAL then
			setActive(var0_28:Find("tags/story"), true)
			setActive(var0_28:Find("tags/battle"), false)
		elseif var3_28 == BossRushStoryNode.NODE_TYPE.EVENT then
			-- block empty
		elseif var3_28 == BossRushStoryNode.NODE_TYPE.BATTLE then
			setActive(var0_28:Find("tags/story"), false)
			setActive(var0_28:Find("tags/battle"), true)
		end

		local var4_28 = arg1_28:IsReaded()

		var1_27 = var1_27 + (var4_28 and 1 or 0)
		var2_27 = var2_27 + 1

		setActive(var0_28:Find("main"), not var4_28)
		setActive(var0_28:Find("finish"), var4_28)
		setActive(var0_28:Find("finish_tag"), var4_28)
		onButton(arg0_27, var0_28, function()
			if not var2_28 or var4_28 then
				return
			end

			local var0_29 = arg1_28:GetStory()

			arg0_27:PlayStory(var0_29, function()
				arg0_27:UpdateView()
			end)
		end)
	end)
	setText(arg0_27.progressText, var1_27 .. "/" .. var2_27)
	setActive(arg0_27.storyAward, tobool(arg0_27.storyTask))

	if arg0_27.storyTask then
		local var3_27 = arg0_27.storyTask:getConfig("award_display")
		local var4_27 = Drop.New({
			type = var3_27[1][1],
			id = var3_27[1][2],
			count = var3_27[1][3]
		})

		updateDrop(arg0_27.storyAward:GetChild(0), var4_27)

		local var5_27 = arg0_27.storyTask:getTaskStatus()

		setActive(arg0_27.storyAward:Find("get"), var5_27 == 1)
		setActive(arg0_27.storyAward:Find("got"), var5_27 == 2)

		if var5_27 == 1 then
			arg0_27:emit(BossRushAlvitMediator.ON_TASK_SUBMIT, arg0_27.storyTask)
		end

		onButton(arg0_27, arg0_27.storyAward, function()
			arg0_27:emit(BaseUI.ON_DROP, var4_27)
		end)
	end
end

function var0_0.PlayStory(arg0_32, arg1_32, arg2_32)
	if not arg1_32 then
		return existCall(arg2_32)
	end

	local var0_32 = pg.NewStoryMgr.GetInstance()
	local var1_32 = var0_32:IsPlayed(arg1_32)

	seriesAsync({
		function(arg0_33)
			if var1_32 then
				return arg0_33()
			end

			local var0_33 = tonumber(arg1_32)

			if var0_33 and var0_33 > 0 then
				arg0_32:emit(BossRushAlvitMediator.ON_PERFORM_COMBAT, var0_33)
			else
				var0_32:Play(arg1_32, arg0_33)
			end
		end,
		function(arg0_34, ...)
			existCall(arg2_32, ...)
		end
	})
end

function var0_0.UpdateStoryTask(arg0_35)
	local var0_35 = arg0_35.activity:getConfig("config_client").tasks[1]

	arg0_35.storyTask = getProxy(TaskProxy):getTaskVO(var0_35) or Task.New({
		submit_time = 1,
		id = var0_35
	})
end

function var0_0.UpdateTaskTip(arg0_36)
	setActive(arg0_36.taskTip, Activity.IsActivityReady(getProxy(ActivityProxy):getActivityById(ActivityConst.ALVIT_TASK_ACT_ID)))
end

function var0_0.addbubbleMsgBoxList(arg0_37, arg1_37)
	local var0_37 = #arg0_37.ActionSequence == 0

	table.insertto(arg0_37.ActionSequence, arg1_37)

	if not var0_37 then
		return
	end

	arg0_37:resumeBubble()
end

function var0_0.addbubbleMsgBox(arg0_38, arg1_38)
	local var0_38 = #arg0_38.ActionSequence == 0

	table.insert(arg0_38.ActionSequence, arg1_38)

	if not var0_38 then
		return
	end

	arg0_38:resumeBubble()
end

function var0_0.resumeBubble(arg0_39)
	if #arg0_39.ActionSequence == 0 then
		return
	end

	local var0_39

	local function var1_39()
		local var0_40 = arg0_39.ActionSequence[1]

		if var0_40 then
			var0_40(function()
				table.remove(arg0_39.ActionSequence, 1)
				var1_39()
			end)
		end
	end

	var1_39()
end

function var0_0.onBackPressed(arg0_42)
	arg0_42:emit(BossRushAlvitMediator.GO_SCENE, SCENE.KINDERGARTEN, {
		isBack = true
	})
end

function var0_0.CleanBubbleMsgbox(arg0_43)
	table.clean(arg0_43.ActionSequence)
end

return var0_0

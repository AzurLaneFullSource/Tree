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
			if underscore.all(underscore.values(arg0_17.storyNodesDict), function(arg0_20)
				return arg0_20:IsReaded()
			end) and arg0_17.storyTask and arg0_17.storyTask:getTaskStatus() == 2 then
				local var0_19 = arg0_17.activity:getConfig("config_client").endStory

				arg0_17:PlayStory(var0_19, function(arg0_21)
					arg0_19()

					if arg0_21 then
						arg0_17:UpdateView()
					end
				end)

				return
			end

			arg0_19()
		end
	})
end

function var0_0.UpdateBattle(arg0_22)
	local var0_22 = arg0_22.activity
	local var1_22 = var0_22:GetActiveSeriesIds()

	table.Foreach(arg0_22.seriesNodes, function(arg0_23, arg1_23)
		local var0_23 = var1_22[arg0_23]
		local var1_23 = BossRushSeriesData.New({
			id = var0_23,
			actId = var0_22.id
		})
		local var2_23 = var1_23:IsUnlock(var0_22)

		setActive(arg1_23, var2_23)

		local var3_23 = var1_23:GetType() == BossRushSeriesData.TYPE.SP
		local var4_23 = true

		if var3_23 then
			local var5_23 = var0_22:GetUsedBonus()[arg0_23] or 0
			local var6_23 = var1_23:GetMaxBonusCount()

			setText(arg1_23:Find("count/Text"), i18n("series_enemy_SP_count") .. math.max(0, var6_23 - var5_23) .. "/" .. var6_23)

			var4_23 = var6_23 - var5_23 > 0
		end

		local function var7_23()
			if not var2_23 then
				local var0_24 = var1_23:GetPreSeriesId()
				local var1_24 = BossRushSeriesData.New({
					id = var0_24
				})

				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_unlock", var1_24:GetName()))

				return
			end

			if not var4_23 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_SP_error"))

				return
			end

			arg0_22:emit(BossRushAlvitMediator.ON_FLEET_SELECT, var1_23)
		end

		onButton(arg0_22, arg1_23:Find("icon"), function()
			var7_23()
		end, SFX_PANEL)
		onButton(arg0_22, arg1_23:Find("text"), function()
			var7_23()
		end, SFX_PANEL)
	end)
	setText(arg0_22.ptText, arg0_22.ptActivity.data1)
	setActive(arg0_22.ptTip, Activity.IsActivityReady(arg0_22.ptActivity))
	setActive(arg0_22._tf:Find("Battle/Story/new"), arg0_22.storyTask and arg0_22.storyTask:getTaskStatus() ~= 2)
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

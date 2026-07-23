local var0_0 = class("BossRushEscapeManorScene", import("view.base.BaseUI"))
local var1_0 = "anim_BRVZ_change"

var0_0.DISPLAY = {
	STORY = "Story",
	BATTLE = "Battle"
}

function var0_0.getUIName(arg0_1)
	return "BossRushEscapeManorUI"
end

function var0_0.init(arg0_2)
	arg0_2.top = arg0_2._tf:Find("Top")
	arg0_2.ptBtn = arg0_2.top:Find("right/pt")
	arg0_2.ptTip = arg0_2.ptBtn:Find("tip")
	arg0_2.rankBtn = arg0_2.top:Find("right/rank")

	setText(arg0_2.rankBtn:Find("Text"), i18n("escape_series_rank"))

	arg0_2.taskBtn = arg0_2.top:Find("right/task")

	setText(arg0_2.taskBtn:Find("Text"), i18n("escape_series_task"))

	arg0_2.taskTip = arg0_2.taskBtn:Find("tip")
	arg0_2.seriesNodes = {}

	eachChild(arg0_2._tf:Find("Battle/Nodes"), function(arg0_3, arg1_3)
		arg0_2.seriesNodes[arg0_3.name] = arg0_3
	end)

	arg0_2.nodes = {}

	eachChild(arg0_2._tf:Find("Story/Nodes"), function(arg0_4, arg1_4)
		arg0_2.nodes[arg0_4.name] = arg0_4
	end)

	arg0_2.switchToggle = arg0_2.top:Find("bottom/switch_toggle")
	arg0_2.ActionSequence = {}

	arg0_2:UpdateRatioScale()

	arg0_2.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_5, arg1_5)
		arg0_2:UpdateRatioScale()
	end)
	arg0_2.storyAward = arg0_2.top:Find("bottom/Award")
	arg0_2.progressText = arg0_2.storyAward:Find("desc")
end

function var0_0.SetActivity(arg0_6, arg1_6)
	arg0_6.activity = arg1_6
end

function var0_0.SetPtActivity(arg0_7, arg1_7)
	arg0_7.ptActivity = arg1_7
	arg0_7.ptData = ActivityPtData.New(arg0_7.ptActivity)
end

function var0_0.didEnter(arg0_8)
	onButton(arg0_8, arg0_8.top:Find("top/back"), function()
		arg0_8:closeView()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.top:Find("top/home"), function()
		arg0_8:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.top:Find("top/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("escape_manor_series_help")
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.rankBtn, function()
		arg0_8:emit(BossRushEscapeManorMediator.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.ptBtn, function()
		arg0_8:emit(BossRushEscapeManorMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = arg0_8.ptActivity.id
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.taskBtn, function()
		arg0_8:emit(BossRushEscapeManorMediator.GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
	onToggle(arg0_8, arg0_8.switchToggle:Find("Story"), function(arg0_15)
		if arg0_15 then
			if arg0_8.blockAnim then
				arg0_8.blockAnim = false
			end

			arg0_8:SetDisplayMode(var0_0.DISPLAY.STORY)
		end
	end, SFX_PANEL)
	onToggle(arg0_8, arg0_8.switchToggle:Find("Battle"), function(arg0_16)
		if arg0_16 then
			if arg0_8.blockAnim then
				arg0_8.blockAnim = false
			end

			arg0_8:SetDisplayMode(var0_0.DISPLAY.BATTLE)
		end
	end, SFX_PANEL)

	arg0_8.storyNodesDict = {}

	for iter0_8, iter1_8 in ipairs(arg0_8.activity:getConfig("config_client").storys) do
		arg0_8.storyNodesDict[iter1_8] = BossRushStoryNode.New({
			id = iter1_8
		})
	end

	arg0_8.blockAnim = true

	triggerToggle(arg0_8.switchToggle:Find(arg0_8.contextData.displayMode or var0_0.DISPLAY.BATTLE), true)
end

function var0_0.getBGM(arg0_17)
	if arg0_17.contextData.displayMode ~= var0_0.DISPLAY.STORY then
		return var0_0.super.getBGM(arg0_17)
	else
		local var0_17 = arg0_17.activity:getConfig("config_client").storybgm
		local var1_17 = pg.TimeMgr.GetInstance():GetServerHour()
		local var2_17 = var0_17[#var0_17][2]

		for iter0_17, iter1_17 in ipairs(var0_17) do
			if var1_17 < iter1_17[1] then
				break
			else
				var2_17 = iter1_17[2]
			end
		end

		return var2_17
	end
end

function var0_0.getBG(arg0_18)
	if arg0_18.contextData.displayMode ~= var0_0.DISPLAY.STORY then
		return "bg1"
	else
		return "bg2"
	end
end

function var0_0.SetDisplayMode(arg0_19, arg1_19)
	arg0_19.contextData.displayMode = arg1_19

	arg0_19:UpdateView()
end

function var0_0.UpdateRatioScale(arg0_20, arg1_20)
	local var0_20

	for iter0_20, iter1_20 in ipairs({
		"Mask",
		"Battle",
		"Story"
	}) do
		local var1_20 = arg0_20._tf:Find(iter1_20)
		local var2_20 = var1_20.rect.height

		var0_20 = var0_20 or var2_20 > 1440 and var2_20 / 1440 or 1

		setLocalScale(var1_20, {
			x = var0_20,
			y = var0_20
		})
	end
end

function var0_0.UpdateView(arg0_21)
	local var0_21 = arg0_21.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_21._tf:Find("Battle"), var0_21)
	setActive(arg0_21._tf:Find("Story"), not var0_21)
	setActive(arg0_21.storyAward, not var0_21)

	if var0_21 then
		arg0_21:UpdateBattle()
	else
		arg0_21:UpdateStory()
	end

	arg0_21:UpdateStoryTask()

	local var1_21 = arg0_21:getBG()

	eachChild(arg0_21._tf:Find("Mask"), function(arg0_22, arg1_22)
		setActive(arg0_22, arg0_22.name == var1_21 or arg0_22.name == "FX")
	end)
	arg0_21:PlayBGM()
	setText(arg0_21.ptBtn:Find("Text"), i18n("escape_series_pt", arg0_21.ptActivity.data1))
	setActive(arg0_21.ptTip, Activity.IsActivityReady(arg0_21.ptActivity))

	local var2_21 = arg0_21.contextData.displayMode

	arg0_21:addbubbleMsgBoxList({
		function(arg0_23)
			local var0_23

			if var2_21 == var0_0.DISPLAY.BATTLE then
				var0_23 = arg0_21.activity:getConfig("config_client").openActivityStory
			elseif var2_21 == var0_0.DISPLAY.STORY then
				var0_23 = arg0_21.activity:getConfig("config_client").openStory
			end

			arg0_21:PlayStory(var0_23, arg0_23)
		end,
		function(arg0_24)
			if underscore.all(underscore.values(arg0_21.storyNodesDict), function(arg0_25)
				return arg0_25:IsReaded()
			end) and arg0_21.storyTask and arg0_21.storyTask:getTaskStatus() == 2 then
				local var0_24 = arg0_21.activity:getConfig("config_client").endStory

				arg0_21:PlayStory(var0_24, arg0_24)
			else
				arg0_24()
			end
		end
	})
end

function var0_0.UpdateBattle(arg0_26)
	local var0_26 = arg0_26.activity
	local var1_26 = var0_26:GetActiveSeriesIds()

	for iter0_26, iter1_26 in ipairs(var1_26) do
		local var2_26 = arg0_26.seriesNodes[tostring(iter1_26)]
		local var3_26 = BossRushSeriesData.New({
			id = iter1_26,
			actId = var0_26.id
		})
		local var4_26 = var3_26:IsUnlock(var0_26)

		setActive(var2_26, var4_26)

		local var5_26 = var3_26:GetType()

		setActive(var2_26:Find("blue"), var5_26 == BossRushSeriesData.TYPE.NORMAL)
		setActive(var2_26:Find("red"), var5_26 ~= BossRushSeriesData.TYPE.NORMAL)

		local var6_26

		if var5_26 == BossRushSeriesData.TYPE.NORMAL then
			var6_26 = var2_26:Find("blue")
		else
			var6_26 = var2_26:Find("red")
		end

		setText(var6_26:Find("Text"), var3_26:GetName())
		setText(var6_26:Find("diff/Text"), switch(iter1_26, {
			[6001] = function()
				return i18n("zengke_series_easy")
			end,
			[6002] = function()
				return i18n("zengke_series_normal")
			end,
			[6003] = function()
				return i18n("zengke_series_hard")
			end,
			[6004] = function()
				return i18n("zengke_series_sp")
			end,
			[6005] = function()
				return i18n("zengke_series_ex")
			end
		}))

		local var7_26 = var5_26 == BossRushSeriesData.TYPE.SP

		setActive(var2_26:Find("times"), var7_26)

		local var8_26 = true

		if var7_26 then
			local var9_26 = var0_26:GetUsedBonus()[iter0_26] or 0
			local var10_26 = var3_26:GetMaxBonusCount()

			var8_26 = var10_26 - var9_26 > 0

			setText(var2_26:Find("times/Text"), i18n("series_enemy_SP_count") .. setColorStr(math.max(0, var10_26 - var9_26) .. "/" .. var10_26, var8_26 and "#6EE868" or "#7f7f7f"))
		end

		onButton(arg0_26, var2_26, function()
			if not var4_26 then
				local var0_32 = var3_26:GetPreSeriesId()
				local var1_32 = BossRushSeriesData.New({
					id = var0_32
				})

				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_unlock", var1_32:GetName()))

				return
			end

			if not var8_26 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_SP_error"))

				return
			end

			arg0_26:emit(BossRushEscapeManorMediator.ON_FLEET_SELECT, var3_26)
		end, SFX_PANEL)
	end
end

function var0_0.UpdateStory(arg0_33)
	local var0_33 = pg.NewStoryMgr.GetInstance()
	local var1_33 = 0
	local var2_33 = 0

	for iter0_33, iter1_33 in pairs(arg0_33.storyNodesDict) do
		print("find node id " .. tostring(iter1_33.id))

		local var3_33 = arg0_33.nodes[tostring(iter1_33.id)]
		local var4_33 = iter1_33:IsActive(arg0_33.activity, arg0_33.ptActivity)

		setActive(var3_33, var4_33)
		setText(var3_33:Find("main/char/bg/Text"), iter1_33:GetName())

		local var5_33 = iter1_33:IsReaded()

		var1_33 = var1_33 + (var5_33 and 1 or 0)
		var2_33 = var2_33 + 1

		setActive(var3_33:Find("main/char"), not var5_33)
		setActive(var3_33:Find("main/talk"), var5_33)
		onButton(arg0_33, var3_33, function()
			if not var4_33 or var5_33 then
				return
			end

			local var0_34 = iter1_33:GetStory()

			arg0_33:PlayStory(var0_34, function()
				arg0_33:UpdateView()
			end)
		end)
	end

	setText(arg0_33.progressText, i18n("escape_story_reward_count"))
	setText(findTF(arg0_33.progressText, "progress"), setColorStr(var1_33, "#f34f66") .. "/" .. var2_33)

	if arg0_33.storyTask then
		local var6_33 = arg0_33.storyTask:getConfig("award_display")
		local var7_33 = Drop.Create(var6_33[1])
		local var8_33 = arg0_33.storyAward:Find("award_bg")

		updateDrop(var8_33:Find("IconTpl"), var7_33)
		onButton(arg0_33, var8_33, function()
			arg0_33:emit(BaseUI.ON_DROP, var7_33)
		end, SFX_PANEL)

		local var9_33 = arg0_33.storyTask:getTaskStatus()

		setActive(var8_33:Find("get"), var9_33 == 1)
		setActive(var8_33:Find("got"), var9_33 == 2)
	end
end

function var0_0.PlayStory(arg0_37, arg1_37, arg2_37)
	if not arg1_37 then
		return existCall(arg2_37)
	end

	local var0_37 = pg.NewStoryMgr.GetInstance()
	local var1_37 = var0_37:IsPlayed(arg1_37)

	seriesAsync({
		function(arg0_38)
			if var1_37 then
				return arg0_38()
			end

			local var0_38 = tonumber(arg1_37)

			if var0_38 and var0_38 > 0 then
				arg0_37:emit(BossRushEscapeManorMediator.ON_PERFORM_COMBAT, var0_38)
			else
				var0_37:Play(arg1_37, arg0_38)
			end
		end
	}, arg2_37)
end

function var0_0.UpdateStoryTask(arg0_39)
	local var0_39 = arg0_39.activity:getConfig("config_client").tasks[1]

	arg0_39.storyTask = getProxy(TaskProxy):getTaskVO(var0_39) or Task.New({
		submit_time = 1,
		id = var0_39
	})

	setActive(arg0_39.switchToggle:Find("Story/new"), arg0_39.storyTask and arg0_39.storyTask:getTaskStatus() ~= 2)
	setActive(arg0_39.taskTip, Activity.IsActivityReady(getProxy(ActivityProxy):getActivityById(ActivityConst.ESCAPE_BOSS_RUSH_TASK_ACT_ID)))

	if arg0_39.storyTask then
		local var1_39 = arg0_39.storyTask:getConfig("award_display")
		local var2_39 = Drop.Create(var1_39[1])
		local var3_39 = arg0_39.storyAward:Find("award_bg")

		updateDrop(var3_39:Find("IconTpl"), var2_39)
		onButton(arg0_39, var3_39:Find("IconTpl"), function()
			arg0_39:emit(BaseUI.ON_DROP, var2_39)
		end, SFX_PANEL)

		local var4_39 = arg0_39.storyTask:getTaskStatus()

		setActive(var3_39:Find("get"), var4_39 == 1)
		setActive(var3_39:Find("got"), var4_39 == 2)
	end

	local var5_39 = arg0_39.storyTask:getConfig("award_display")
	local var6_39 = Drop.Create(var5_39[1])
	local var7_39 = arg0_39.storyAward:Find("award_bg")

	updateDrop(var7_39:Find("IconTpl"), var6_39)
	onButton(arg0_39, var7_39, function()
		return
	end, SFX_PANEL)

	local var8_39 = arg0_39.storyTask:getTaskStatus()

	setActive(var7_39:Find("get"), var8_39 == 1)
	setActive(var7_39:Find("got"), var8_39 == 2)

	if var8_39 == 1 then
		arg0_39:emit(BossRushEscapeManorMediator.ON_TASK_SUBMIT, arg0_39.storyTask)
	end
end

function var0_0.addbubbleMsgBoxList(arg0_42, arg1_42)
	local var0_42 = #arg0_42.ActionSequence == 0

	table.insertto(arg0_42.ActionSequence, arg1_42)

	if not var0_42 then
		return
	end

	arg0_42:resumeBubble()
end

function var0_0.addbubbleMsgBox(arg0_43, arg1_43)
	local var0_43 = #arg0_43.ActionSequence == 0

	table.insert(arg0_43.ActionSequence, arg1_43)

	if not var0_43 then
		return
	end

	arg0_43:resumeBubble()
end

function var0_0.resumeBubble(arg0_44)
	if #arg0_44.ActionSequence == 0 then
		return
	end

	local var0_44

	local function var1_44()
		local var0_45 = arg0_44.ActionSequence[1]

		if var0_45 then
			var0_45(function()
				table.remove(arg0_44.ActionSequence, 1)
				var1_44()
			end)
		end
	end

	var1_44()
end

function var0_0.CleanBubbleMsgbox(arg0_47)
	table.clean(arg0_47.ActionSequence)
end

function var0_0.willExit(arg0_48)
	if arg0_48.camEventId then
		pg.CameraFixMgr.GetInstance():disconnect(arg0_48.camEventId)

		arg0_48.camEventId = nil
	end
end

return var0_0

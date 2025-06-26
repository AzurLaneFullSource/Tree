local var0_0 = class("BossRushVerZenkerScene", import("view.base.BaseUI"))

var0_0.DISPLAY = {
	STORY = "Story",
	BATTLE = "Battle"
}

function var0_0.getUIName(arg0_1)
	return "BossRushVerZenkerUI"
end

function var0_0.init(arg0_2)
	arg0_2.top = arg0_2._tf:Find("Top")
	arg0_2.ptBtn = arg0_2.top:Find("right/pt")

	setText(arg0_2.ptBtn:Find("Text"), i18n("zengke_series_pt"))
	setText(arg0_2.ptBtn:Find("Text/en"), i18n("zengke_series_pt_small"))

	arg0_2.ptText = arg0_2.ptBtn:Find("value/Text")
	arg0_2.ptTip = arg0_2.ptBtn:Find("tip")
	arg0_2.rankBtn = arg0_2.top:Find("right/rank")

	setText(arg0_2.rankBtn:Find("Text"), i18n("zengke_series_rank"))
	setText(arg0_2.rankBtn:Find("Text/en"), i18n("zengke_series_rank_small"))

	arg0_2.taskBtn = arg0_2.top:Find("right/task")

	setText(arg0_2.taskBtn:Find("Text"), i18n("zengke_series_task"))
	setText(arg0_2.taskBtn:Find("Text/en"), i18n("zengke_series_task_small"))

	arg0_2.taskTip = arg0_2.taskBtn:Find("tip")
	arg0_2.seriesNodes = {}

	eachChild(arg0_2._tf:Find("Battle/Nodes"), function(arg0_3, arg1_3)
		arg0_2.seriesNodes[arg0_3.name] = arg0_3
	end)

	arg0_2.nodes = {}

	eachChild(arg0_2._tf:Find("Story/Nodes"), function(arg0_4, arg1_4)
		arg0_2.nodes[arg0_4.name] = arg0_4
	end)

	arg0_2.storyAward = arg0_2.top:Find("bottom/Award")
	arg0_2.progressText = arg0_2.storyAward:Find("desc")
	arg0_2.switchToggle = arg0_2.top:Find("bottom/switch_toggle")
	arg0_2.ActionSequence = {}

	arg0_2:UpdateRatioScale()

	arg0_2.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_5, arg1_5)
		arg0_2:UpdateRatioScale()
	end)
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
			helps = i18n("zengke_series_help")
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.rankBtn, function()
		arg0_8:emit(BossRushVerZenkerMediator.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.ptBtn, function()
		arg0_8:emit(BossRushVerZenkerMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = arg0_8.ptActivity.id
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.taskBtn, function()
		arg0_8:emit(BossRushVerZenkerMediator.GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
	onToggle(arg0_8, arg0_8.switchToggle:Find("Story"), function(arg0_15)
		if arg0_15 then
			if arg0_8.blockAnim then
				arg0_8.blockAnim = false
			else
				quickPlayAnimation(arg0_8._tf, "anim_BRVZ_change")
			end

			arg0_8:SetDisplayMode(var0_0.DISPLAY.STORY)
		end
	end, SFX_PANEL)
	onToggle(arg0_8, arg0_8.switchToggle:Find("Battle"), function(arg0_16)
		if arg0_16 then
			if arg0_8.blockAnim then
				arg0_8.blockAnim = false
			else
				quickPlayAnimation(arg0_8._tf, "anim_BRVZ_change")
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
		local var0_18 = arg0_18.activity:getConfig("config_client").levelbg
		local var1_18 = pg.TimeMgr.GetInstance():GetServerHour()
		local var2_18 = var0_18[#var0_18][2]

		for iter0_18, iter1_18 in ipairs(var0_18) do
			if var1_18 < iter1_18[1] then
				break
			else
				var2_18 = iter1_18[2]
			end
		end

		return var2_18
	else
		local var3_18 = arg0_18.activity:getConfig("config_client").storybg
		local var4_18
		local var5_18 = pg.NewStoryMgr.GetInstance()

		for iter2_18, iter3_18 in ipairs(var3_18) do
			if iter3_18[1] == "default" or var5_18:IsPlayed(iter3_18[1]) then
				var4_18 = iter3_18[2]
			else
				break
			end
		end

		return var4_18
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
	setText(arg0_21.ptText, arg0_21.ptActivity.data1)
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
			local var0_24 = true

			for iter0_24, iter1_24 in pairs(arg0_21.storyNodesDict) do
				local var1_24 = iter1_24:GetStory()

				if var1_24 and var1_24 ~= "" then
					var0_24 = var0_24 and pg.NewStoryMgr.GetInstance():IsPlayed(var1_24)
				end

				if not var0_24 then
					break
				end
			end

			if not var0_21 and var0_24 and arg0_21.storyTask and arg0_21.storyTask:getTaskStatus() == 2 then
				local var2_24 = arg0_21.activity:getConfig("config_client").endStory

				arg0_21:PlayStory(var2_24, arg0_24)
			else
				arg0_24()
			end
		end
	})
end

function var0_0.UpdateBattle(arg0_25)
	local var0_25 = arg0_25.activity

	for iter0_25, iter1_25 in ipairs(var0_25:GetActiveSeriesIds()) do
		local var1_25 = arg0_25.seriesNodes[tostring(iter1_25)]
		local var2_25 = BossRushSeriesData.New({
			id = iter1_25,
			actId = var0_25.id
		})
		local var3_25 = var2_25:IsUnlock(var0_25)

		setActive(var1_25, var3_25)

		local var4_25 = var2_25:GetType()

		setActive(var1_25:Find("blue"), var4_25 == BossRushSeriesData.TYPE.NORMAL)
		setActive(var1_25:Find("red"), var4_25 ~= BossRushSeriesData.TYPE.NORMAL)

		local var5_25

		if var4_25 == BossRushSeriesData.TYPE.NORMAL then
			var5_25 = var1_25:Find("blue")
		else
			var5_25 = var1_25:Find("red")
		end

		setText(var5_25:Find("Text"), var2_25:GetName())
		setText(var5_25:Find("diff/Text"), switch(iter1_25, {
			[3001] = function()
				return i18n("zengke_series_easy")
			end,
			[3002] = function()
				return i18n("zengke_series_normal")
			end,
			[3003] = function()
				return i18n("zengke_series_hard")
			end,
			[3004] = function()
				return i18n("zengke_series_sp")
			end,
			[3005] = function()
				return i18n("zengke_series_ex")
			end
		}))

		local var6_25 = var4_25 == BossRushSeriesData.TYPE.SP

		setActive(var1_25:Find("times"), var6_25)

		local var7_25 = true

		if var6_25 then
			local var8_25 = var0_25:GetUsedBonus()[iter0_25] or 0
			local var9_25 = var2_25:GetMaxBonusCount()

			var7_25 = var9_25 - var8_25 > 0

			setText(var1_25:Find("times/Text"), i18n("series_enemy_SP_count") .. setColorStr(math.max(0, var9_25 - var8_25) .. "/" .. var9_25, var7_25 and "#6EE868" or "#7f7f7f"))
		end

		onButton(arg0_25, var1_25, function()
			if not var3_25 then
				local var0_31 = var2_25:GetPreSeriesId()
				local var1_31 = BossRushSeriesData.New({
					id = var0_31
				})

				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_unlock", var1_31:GetName()))

				return
			end

			if not var7_25 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_SP_error"))

				return
			end

			arg0_25:emit(BossRushVerZenkerMediator.ON_FLEET_SELECT, var2_25)
		end, SFX_PANEL)
	end
end

function var0_0.UpdateStory(arg0_32)
	local var0_32 = {}
	local var1_32 = pg.NewStoryMgr.GetInstance()
	local var2_32 = 1
	local var3_32 = 2
	local var4_32 = 3
	local var5_32 = 0
	local var6_32 = 0

	for iter0_32, iter1_32 in pairs(arg0_32.storyNodesDict) do
		var0_32[iter0_32] = {}

		local var7_32 = iter1_32:GetStory()
		local var8_32 = true

		if var7_32 and var7_32 ~= "" then
			var8_32 = var1_32:IsPlayed(var7_32)
			var5_32 = var5_32 + (var8_32 and 1 or 0)
			var6_32 = var6_32 + 1
		end

		var0_32[iter0_32].status = var8_32 and var4_32 or var2_32
	end

	setText(arg0_32.progressText, i18n("zengke_story_reward_count") .. string.format("(" .. setColorStr("%d/%d", "#AEB2E3") .. ")", var5_32, var6_32))
	underscore(arg0_32.storyNodesDict):chain():values():sort(CompareFuncs({
		function(arg0_33)
			return arg0_33.id
		end
	})):each(function(arg0_34)
		local var0_34 = arg0_34:GetTriggers()

		if var0_32[arg0_34.id].status == var4_32 then
			return
		end

		if not _.any(var0_34, function(arg0_35)
			if arg0_35.type == BossRushStoryNode.TRIGGER_TYPE.PT_GOT then
				return arg0_32.ptActivity.data1 < arg0_35.value
			elseif arg0_35.type == BossRushStoryNode.TRIGGER_TYPE.SERIES_PASSED then
				return not BossRushSeriesData.New({
					id = arg0_35.value,
					actId = arg0_32.activity.id
				}):IsUnlock(arg0_32.activity)
			elseif arg0_35.type == BossRushStoryNode.TRIGGER_TYPE.STORY_READED then
				return var0_32[arg0_35.value].status < var4_32
			end
		end) then
			var0_32[arg0_34.id].status = var3_32
		end
	end)

	for iter2_32, iter3_32 in pairs(arg0_32.storyNodesDict) do
		local var9_32 = arg0_32.nodes[tostring(iter3_32.id)]

		setActive(var9_32, var2_32 < var0_32[iter2_32].status)
		setText(var9_32:Find("main/char/bg/Text"), iter3_32:GetName())

		local var10_32 = var0_32[iter2_32].status == var4_32

		setActive(var9_32:Find("main/char"), not var10_32)
		setActive(var9_32:Find("main/talk"), var10_32)
		onButton(arg0_32, var9_32, function()
			if not isActive or var10_32 then
				return
			end

			local var0_36 = iter3_32:GetStory()

			arg0_32:PlayStory(var0_36, function()
				arg0_32:UpdateView()
			end)
		end)
	end
end

function var0_0.PlayStory(arg0_38, arg1_38, arg2_38)
	if not arg1_38 then
		return existCall(arg2_38)
	end

	local var0_38 = pg.NewStoryMgr.GetInstance()
	local var1_38 = var0_38:IsPlayed(arg1_38)

	seriesAsync({
		function(arg0_39)
			if var1_38 then
				return arg0_39()
			end

			local var0_39 = tonumber(arg1_38)

			if var0_39 and var0_39 > 0 then
				arg0_38:emit(BossRushVerZenkerMediator.ON_PERFORM_COMBAT, var0_39)
			else
				var0_38:Play(arg1_38, arg0_39)
			end
		end
	}, arg2_38)
end

function var0_0.UpdateStoryTask(arg0_40)
	local var0_40 = arg0_40.activity:getConfig("config_client").tasks[1]

	arg0_40.storyTask = getProxy(TaskProxy):getTaskVO(var0_40) or Task.New({
		submit_time = 1,
		id = var0_40
	})

	setActive(arg0_40.switchToggle:Find("Story/new"), arg0_40.storyTask and arg0_40.storyTask:getTaskStatus() ~= 2)
	setActive(arg0_40.taskTip, Activity.IsActivityReady(getProxy(ActivityProxy):getActivityById(ActivityConst.ZENGKEHAIJUNSHANGJIANG_TASK_ACT_ID)))

	local var1_40 = arg0_40.storyTask:getConfig("award_display")
	local var2_40 = Drop.Create(var1_40[1])
	local var3_40 = arg0_40.storyAward:Find("award_bg")

	updateDrop(var3_40:Find("IconTpl"), var2_40)
	onButton(arg0_40, var3_40, function()
		arg0_40:emit(BaseUI.ON_DROP, var2_40)
	end, SFX_PANEL)

	local var4_40 = arg0_40.storyTask:getTaskStatus()

	setActive(var3_40:Find("get"), var4_40 == 1)
	setActive(var3_40:Find("got"), var4_40 == 2)

	if var4_40 == 1 then
		arg0_40:emit(BossRushVerZenkerMediator.ON_TASK_SUBMIT, arg0_40.storyTask)
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

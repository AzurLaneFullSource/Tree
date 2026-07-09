local var0_0 = class("BossRushKurskScene", import("view.base.BaseUI"))
local var1_0 = require("Mgr/Pool/PoolPlural")

var0_0.DISPLAY = {
	STORY = 2,
	BATTLE = 1
}

function var0_0.getUIName(arg0_1)
	return "BossRushKurskUI"
end

function var0_0.GetAtalsName(arg0_2)
	return "ui/BossRushKurskUI_atlas"
end

function var0_0.ResUISettings(arg0_3)
	return true
end

function var0_0.Ctor(arg0_4)
	var0_0.super.Ctor(arg0_4)

	arg0_4.loader = AutoLoader.New()
end

function var0_0.preload(arg0_5, arg1_5)
	existCall(arg1_5)
	arg0_5.loader:LoadBundle(arg0_5:GetAtalsName())
end

function var0_0.init(arg0_6)
	arg0_6.top = arg0_6._tf:Find("Top")
	arg0_6.map = arg0_6._tf:Find("Map")

	local var0_6 = arg0_6._tf:Find("Battle/Nodes")

	arg0_6.seriesNodes = {}

	for iter0_6 = 1, var0_6.childCount do
		local var1_6 = var0_6:GetChild(iter0_6 - 1)

		if isActive(var1_6) then
			table.insert(arg0_6.seriesNodes, var1_6)
		end
	end

	arg0_6.ptText = arg0_6._tf:Find("Battle/Reward/Text")
	arg0_6.nodes = {}

	for iter1_6 = 1, arg0_6._tf:Find("Map").childCount do
		local var2_6 = arg0_6._tf:Find("Map"):GetChild(iter1_6 - 1)

		arg0_6.nodes[var2_6.name] = {
			tfType = 1,
			trans = var2_6
		}
	end

	for iter2_6 = 1, arg0_6._tf:Find("Story/Nodes").childCount do
		local var3_6 = arg0_6._tf:Find("Story/Nodes"):GetChild(iter2_6 - 1)

		arg0_6.nodes[var3_6.name] = {
			tfType = 2,
			trans = var3_6
		}
	end

	arg0_6.pluralRoot = pg.PoolMgr.GetInstance().root

	local var4_6 = go(arg0_6._tf:Find("Link"))

	setActive(var4_6, false)

	arg0_6.plural = var1_0.New(var4_6, 32)
	arg0_6.linksContainer = arg0_6._tf:Find("Links")
	arg0_6.links = {}
	arg0_6.storyBar = arg0_6._tf:Find("Story/StoryBar")
	arg0_6.storyAward = arg0_6._tf:Find("Story/PassLevel/Award")
	arg0_6.ActionSequence = {}

	setText(arg0_6._tf:Find("Battle/Rank/Title"), i18n("word_billboard"))
	setText(arg0_6._tf:Find("Battle/Reward/Title"), i18n("series_enemy_reward"))
	setText(arg0_6._tf:Find("Story/PassLevel/Title"), i18n("series_enemy_storyreward"))
	setText(arg0_6._tf:Find("Story/PassLevel/PT/Tips"), i18n("series_enemy_storyunlock"))
end

function var0_0.SetActivity(arg0_7, arg1_7)
	arg0_7.activity = arg1_7
end

function var0_0.SetPtActivity(arg0_8, arg1_8)
	arg0_8.ptActivity = arg1_8
	arg0_8.ptData = ActivityPtData.New(arg0_8.ptActivity)
end

function var0_0.didEnter(arg0_9)
	onButton(arg0_9, arg0_9.top:Find("back_btn"), function()
		arg0_9:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9.top:Find("option"), function()
		arg0_9:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9._tf:Find("Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = {
				{
					info = i18n("series_enemy_help")
				}
			}
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9._tf:Find("Battle/Rank"), function()
		arg0_9:emit(BossRushKurskMediator.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9._tf:Find("Battle/Reward"), function()
		arg0_9:emit(BossRushKurskMediator.GO_ACT_SHOP, arg0_9.ptData)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9._tf:Find("Battle/Story"), function()
		arg0_9:SetDisplayMode(var0_0.DISPLAY.STORY)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9._tf:Find("Story/Battle"), function()
		arg0_9:SetDisplayMode(var0_0.DISPLAY.BATTLE)
	end, SFX_PANEL)

	local var0_9 = arg0_9.activity:getConfig("config_client").storys or {}

	arg0_9.storyNodesDict = {}

	_.each(var0_9, function(arg0_17)
		arg0_9.storyNodesDict[arg0_17] = BossRushStoryNode.New({
			id = arg0_17
		})
	end)

	if #(arg0_9.activity:getConfig("config_client").tasks or {}) > 0 then
		local var1_9 = arg0_9.activity:getConfig("config_client").tasks[1]

		arg0_9.storyTask = getProxy(TaskProxy):getTaskVO(var1_9) or Task.New({
			submitTime = 1,
			id = var1_9
		})
	end

	local var2_9 = arg0_9.contextData.displayMode or BossRushKurskScene.DISPLAY.BATTLE

	arg0_9.contextData.displayMode = nil

	arg0_9:SetDisplayMode(var2_9)
end

function var0_0.getBGM(arg0_18)
	local var0_18 = pg.voice_bgm[arg0_18.__cname]

	if not var0_18 then
		return nil
	end

	local var1_18 = var0_18.bgm
	local var2_18 = "battle-deepecho"
	local var3_18 = arg0_18.contextData.displayMode

	if var3_18 == var0_0.DISPLAY.BATTLE then
		return var1_18
	elseif var3_18 == var0_0.DISPLAY.STORY then
		return var2_18
	end
end

function var0_0.SetDisplayMode(arg0_19, arg1_19)
	if arg1_19 == arg0_19.contextData.displayMode then
		return
	end

	arg0_19.contextData.displayMode = arg1_19

	arg0_19:PlayBGM()
	arg0_19:UpdateView()
end

function var0_0.UpdateView(arg0_20)
	local var0_20 = arg0_20.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_20._tf:Find("Battle"), var0_20)
	setActive(arg0_20._tf:Find("Story"), not var0_20)
	setActive(arg0_20._tf:Find("Links"), not var0_20)
	arg0_20:UpdateBattle()
	arg0_20:UpdateStory()

	local var1_20 = arg0_20.contextData.displayMode

	arg0_20:addbubbleMsgBoxList({
		function(arg0_21)
			if arg0_20.activity:HasPassSeries(1001) then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0036", nil, arg0_21)

				return
			end

			arg0_21()
		end,
		function(arg0_22)
			local var0_22

			if var1_20 == var0_0.DISPLAY.BATTLE then
				var0_22 = arg0_20.activity:getConfig("config_client").openActivityStory
			elseif var1_20 == var0_0.DISPLAY.STORY then
				var0_22 = arg0_20.activity:getConfig("config_client").openStory
			end

			arg0_20:PlayStory(var0_22, arg0_22)
		end,
		function(arg0_23)
			if underscore.all(underscore.values(arg0_20.storyNodesDict), function(arg0_24)
				return arg0_24:IsReaded()
			end) then
				local var0_23 = arg0_20.activity:getConfig("config_client").endStory

				arg0_20:PlayStory(var0_23, function(arg0_25)
					arg0_23()

					if arg0_25 then
						arg0_20:UpdateView()
					end
				end)

				return
			end

			arg0_23()
		end
	})
end

function var0_0.UpdateBattle(arg0_26)
	local var0_26 = arg0_26.activity
	local var1_26 = var0_26:GetActiveSeriesIds()

	table.Foreach(arg0_26.seriesNodes, function(arg0_27, arg1_27)
		local var0_27 = var1_26[arg0_27]
		local var1_27 = BossRushSeriesData.New({
			id = var0_27,
			actId = var0_26.id
		})
		local var2_27 = var1_27:IsUnlock(var0_26)

		setActive(arg1_27:Find("Pin/NameBG"), var2_27)
		setActive(arg1_27:Find("Pin/Lock"), not var2_27)
		setText(arg1_27:Find("Pin/ChapterName"), var1_27:GetSeriesCode())
		setText(arg1_27:Find("Pin/NameBG/Name"), var1_27:GetName())

		local var3_27 = var1_27:GetType() == BossRushSeriesData.TYPE.SP

		setActive(arg1_27:Find("Pin/NameBG/BonusCount"), var2_27 and var3_27)

		local var4_27 = true

		if var3_27 then
			local var5_27 = var0_26:GetUsedBonus()[arg0_27] or 0
			local var6_27 = var1_27:GetMaxBonusCount()

			setText(arg1_27:Find("Pin/NameBG/BonusCount"):GetChild(0), i18n("series_enemy_SP_count"))
			setText(arg1_27:Find("Pin/NameBG/BonusCount"):GetChild(1), math.max(0, var6_27 - var5_27) .. "/" .. var6_27)

			var4_27 = var6_27 - var5_27 > 0
		end

		onButton(arg0_26, arg1_27, function()
			if not var2_27 then
				local var0_28 = var1_27:GetPreSeriesId()
				local var1_28 = BossRushSeriesData.New({
					id = var0_28
				})

				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_unlock", var1_28:GetName()))

				return
			end

			if not var4_27 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_SP_error"))

				return
			end

			arg0_26:emit(BossRushKurskMediator.ON_FLEET_SELECT, var1_27)
		end, SFX_PANEL)
	end)
	setActive(arg0_26._tf:Find("Battle/Reward/Tip"), arg0_26.ptData:CanGetAward())
	setText(arg0_26.ptText, arg0_26.ptActivity.data1)
end

local var2_0 = {
	"story_bar_green",
	"story_bar_yellow",
	"story_bar_purple"
}

function var0_0.UpdateStory(arg0_29)
	local var0_29 = pg.NewStoryMgr.GetInstance()
	local var1_29 = 0
	local var2_29 = 0
	local var3_29
	local var4_29

	arg0_29:ReturnLinks()

	local var5_29 = false

	table.Foreach(arg0_29.storyNodesDict, function(arg0_30, arg1_30)
		local var0_30 = arg0_29.nodes[arg1_30:GetIconName()].trans
		local var1_30 = arg1_30:IsActive(arg0_29.activity, arg0_29.ptActivity)
		local var2_30 = arg1_30:IsReaded()
		local var3_30 = arg1_30:GetType()

		if var3_30 == BossRushStoryNode.NODE_TYPE.NORMAL then
			arg0_29.loader:GetSprite(arg0_29:GetAtalsName(), var1_30 and "story_green_active" or "story_green", var0_30:GetChild(0), true)
		elseif var3_30 == BossRushStoryNode.NODE_TYPE.EVENT then
			setActive(var0_30, var1_30)
			arg0_29.loader:GetSprite(arg0_29:GetAtalsName(), var1_30 and "story_yellow_active" or "story_yellow", var0_30:GetChild(0), true)
		elseif var3_30 == BossRushStoryNode.NODE_TYPE.BATTLE then
			-- block empty
		end

		if var1_30 then
			local var4_30 = arg0_29._tf:Find("Story"):InverseTransformPoint(var0_30.position)

			setAnchoredPosition(arg0_29.storyBar, var4_30)
			setText(arg0_29.storyBar:Find("Text"), arg1_30:GetName())
			arg0_29.loader:GetSprite(arg0_29:GetAtalsName(), var2_0[var3_30], arg0_29.storyBar, true)
			onButton(arg0_29, arg0_29.storyBar, function()
				local var0_31 = arg1_30:GetStory()

				arg0_29:PlayStory(var0_31, function()
					arg0_29:UpdateView()
				end)
			end)

			var5_29 = true
		end

		local var5_30 = arg1_30:GetActiveLink()

		;(function()
			if var5_30 == 0 or not var2_30 then
				return
			end

			local var0_33 = arg0_29.storyNodesDict[var5_30]
			local var1_33 = arg0_29.nodes[var0_33:GetIconName()].trans
			local var2_33 = arg0_29.plural:Dequeue()

			table.insert(arg0_29.links, go(var2_33))
			setActive(var2_33, true)
			setParent(var2_33, arg0_29.linksContainer)

			local var3_33 = arg0_29.linksContainer:InverseTransformPoint(var0_30.position)
			local var4_33 = arg0_29.linksContainer:InverseTransformPoint(var1_33.position) - var3_33
			local var5_33 = Vector2.Magnitude(var4_33)

			tf(var2_33).sizeDelta = Vector2(var5_33, 2)
			tf(var2_33).anchoredPosition = var3_33
			tf(var2_33).localRotation = Quaternion.FromToRotation(Vector3.right, var4_33)
		end)()

		local var6_30 = arg1_30:GetTriggers()

		_.each(var6_30, function(arg0_34)
			if arg0_34.type == BossRushStoryNode.TRIGGER_TYPE.PT_GOT then
				if var1_30 then
					var4_29 = var4_29 and math.max(arg0_34.value, var4_29) or arg0_34.value
				else
					var3_29 = var3_29 and math.min(arg0_34.value, var3_29) or arg0_34.value
				end
			end
		end)
	end)
	setText(arg0_29._tf:Find("Story/PassLevel/PT/Text"), arg0_29.ptActivity.data1 .. "/" .. (var3_29 or var4_29 or ""))
	setText(arg0_29._tf:Find("Story/PassLevel/Values"):GetChild(0), var1_29)
	setText(arg0_29._tf:Find("Story/PassLevel/Values"):GetChild(2), var2_29)
	setActive(arg0_29.storyBar, var5_29)
	setActive(arg0_29.storyAward, tobool(arg0_29.storyTask))

	if arg0_29.storyTask then
		local var6_29 = arg0_29.storyTask:getConfig("award_display")
		local var7_29 = {
			type = var6_29[1][1],
			id = var6_29[1][2],
			count = var6_29[1][3]
		}

		updateDrop(arg0_29.storyAward:Find("Mask"):GetChild(0), var7_29)
		onButton(arg0_29, arg0_29.storyAward:Find("Mask"):GetChild(0), function()
			arg0_29:emit(BaseUI.ON_DROP, var7_29)
		end)

		local var8_29 = arg0_29.storyTask:getTaskStatus()

		setActive(arg0_29.storyAward:Find("Got"), var8_29 == 2)

		if var8_29 == 1 then
			arg0_29:emit(BossRushKurskMediator.ON_TASK_SUBMIT, arg0_29.storyTask)
		end
	end

	setActive(arg0_29._tf:Find("Battle/Story/New"), var5_29)
end

function var0_0.ReturnLinks(arg0_36, arg1_36)
	for iter0_36, iter1_36 in ipairs(arg0_36.links) do
		if not arg0_36.plural:Enqueue(iter1_36, arg1_36) then
			setParent(iter1_36, arg0_36.pluralRoot)
		end
	end

	table.clean(arg0_36.links)
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
				arg0_37:emit(BossRushKurskMediator.ON_PERFORM_COMBAT, var0_38)
			else
				var0_37:Play(arg1_37, arg0_38)
			end
		end,
		function(arg0_39, ...)
			existCall(arg2_37, ...)
		end
	})
end

function var0_0.UpdateTasks(arg0_40, arg1_40)
	if _.any(arg1_40, function(arg0_41)
		return arg0_40.storyTask and arg0_40.storyTask.id == arg0_41
	end) then
		arg0_40.storyTask.submitTime = 1

		arg0_40:UpdateView()
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
	arg0_48:ReturnLinks(true)
	arg0_48.loader:Clear()
	var0_0.super.willExit(arg0_48)
end

return var0_0

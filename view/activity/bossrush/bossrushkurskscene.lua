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
	arg0_6.seriesNodes = _.map(_.range(arg0_6._tf:Find("Battle/Nodes").childCount), function(arg0_7)
		return arg0_6._tf:Find("Battle/Nodes"):GetChild(arg0_7 - 1)
	end)
	arg0_6.ptText = arg0_6._tf:Find("Battle/Reward/Text")
	arg0_6.nodes = {}

	for iter0_6 = 1, arg0_6._tf:Find("Map").childCount do
		local var0_6 = arg0_6._tf:Find("Map"):GetChild(iter0_6 - 1)

		arg0_6.nodes[var0_6.name] = {
			tfType = 1,
			trans = var0_6
		}
	end

	for iter1_6 = 1, arg0_6._tf:Find("Story/Nodes").childCount do
		local var1_6 = arg0_6._tf:Find("Story/Nodes"):GetChild(iter1_6 - 1)

		arg0_6.nodes[var1_6.name] = {
			tfType = 2,
			trans = var1_6
		}
	end

	arg0_6.pluralRoot = pg.PoolMgr.GetInstance().root

	local var2_6 = go(arg0_6._tf:Find("Link"))

	setActive(var2_6, false)

	arg0_6.plural = var1_0.New(var2_6, 32)
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

function var0_0.SetActivity(arg0_8, arg1_8)
	arg0_8.activity = arg1_8
end

function var0_0.SetPtActivity(arg0_9, arg1_9)
	arg0_9.ptActivity = arg1_9
	arg0_9.ptData = ActivityPtData.New(arg0_9.ptActivity)
end

function var0_0.didEnter(arg0_10)
	onButton(arg0_10, arg0_10.top:Find("back_btn"), function()
		arg0_10:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10.top:Find("option"), function()
		arg0_10:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10._tf:Find("Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = {
				{
					info = i18n("series_enemy_help")
				}
			}
		})
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10._tf:Find("Battle/Rank"), function()
		arg0_10:emit(BossRushKurskMediator.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10._tf:Find("Battle/Reward"), function()
		arg0_10:emit(BossRushKurskMediator.GO_ACT_SHOP, arg0_10.ptData)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10._tf:Find("Battle/Story"), function()
		arg0_10:SetDisplayMode(var0_0.DISPLAY.STORY)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10._tf:Find("Story/Battle"), function()
		arg0_10:SetDisplayMode(var0_0.DISPLAY.BATTLE)
	end, SFX_PANEL)

	local var0_10 = arg0_10.activity:getConfig("config_client").storys

	arg0_10.storyNodesDict = {}

	_.each(var0_10, function(arg0_18)
		arg0_10.storyNodesDict[arg0_18] = BossRushStoryNode.New({
			id = arg0_18
		})
	end)

	local var1_10 = arg0_10.activity:getConfig("config_client").tasks[1]

	arg0_10.storyTask = getProxy(TaskProxy):getTaskVO(var1_10) or Task.New({
		submitTime = 1,
		id = var1_10
	})

	local var2_10 = arg0_10.contextData.displayMode or BossRushKurskScene.DISPLAY.BATTLE

	arg0_10.contextData.displayMode = nil

	arg0_10:SetDisplayMode(var2_10)
end

function var0_0.getBGM(arg0_19)
	local var0_19 = pg.voice_bgm[arg0_19.__cname]

	if not var0_19 then
		return nil
	end

	local var1_19 = var0_19.bgm
	local var2_19 = "battle-deepecho"
	local var3_19 = arg0_19.contextData.displayMode

	if var3_19 == var0_0.DISPLAY.BATTLE then
		return var1_19
	elseif var3_19 == var0_0.DISPLAY.STORY then
		return var2_19
	end
end

function var0_0.SetDisplayMode(arg0_20, arg1_20)
	if arg1_20 == arg0_20.contextData.displayMode then
		return
	end

	arg0_20.contextData.displayMode = arg1_20

	arg0_20:PlayBGM()
	arg0_20:UpdateView()
end

function var0_0.UpdateView(arg0_21)
	local var0_21 = arg0_21.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_21._tf:Find("Battle"), var0_21)
	setActive(arg0_21._tf:Find("Story"), not var0_21)
	setActive(arg0_21._tf:Find("Links"), not var0_21)
	arg0_21:UpdateBattle()
	arg0_21:UpdateStory()

	local var1_21 = arg0_21.contextData.displayMode

	arg0_21:addbubbleMsgBoxList({
		function(arg0_22)
			if arg0_21.activity:HasPassSeries(1001) then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0036", nil, arg0_22)

				return
			end

			arg0_22()
		end,
		function(arg0_23)
			local var0_23

			if var1_21 == var0_0.DISPLAY.BATTLE then
				var0_23 = arg0_21.activity:getConfig("config_client").openActivityStory
			elseif var1_21 == var0_0.DISPLAY.STORY then
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

			if var0_24 then
				local var2_24 = arg0_21.activity:getConfig("config_client").endStory

				arg0_21:PlayStory(var2_24, function(arg0_25)
					arg0_24()

					if arg0_25 then
						arg0_21:UpdateView()
					end
				end)

				return
			end

			arg0_24()
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
	local var0_29 = {}
	local var1_29 = pg.NewStoryMgr.GetInstance()
	local var2_29 = 1
	local var3_29 = 2
	local var4_29 = 3
	local var5_29 = 0
	local var6_29 = 0

	for iter0_29, iter1_29 in pairs(arg0_29.storyNodesDict) do
		var0_29[iter0_29] = {}

		local var7_29 = iter1_29:GetStory()
		local var8_29 = true

		if var7_29 and var7_29 ~= "" then
			var8_29 = var1_29:IsPlayed(var7_29)
			var5_29 = var5_29 + (var8_29 and 1 or 0)
			var6_29 = var6_29 + 1
		end

		var0_29[iter0_29].status = var8_29 and var4_29 or var2_29
	end

	local var9_29
	local var10_29
	local var11_29 = _.sort(_.values(arg0_29.storyNodesDict), function(arg0_30, arg1_30)
		return arg0_30.id < arg1_30.id
	end)

	_.each(var11_29, function(arg0_31)
		local var0_31 = arg0_31:GetTriggers()

		if var0_29[arg0_31.id].status == var4_29 then
			return
		end

		if not _.any(var0_31, function(arg0_32)
			if arg0_32.type == BossRushStoryNode.TRIGGER_TYPE.PT_GOT then
				return arg0_29.ptActivity.data1 < arg0_32.value
			elseif arg0_32.type == BossRushStoryNode.TRIGGER_TYPE.SERIES_PASSED then
				return not BossRushSeriesData.New({
					id = arg0_32.value,
					actId = arg0_29.activity.id
				}):IsUnlock(arg0_29.activity)
			elseif arg0_32.type == BossRushStoryNode.TRIGGER_TYPE.STORY_READED then
				return var0_29[arg0_32.value].status < var4_29
			end
		end) then
			var0_29[arg0_31.id].status = var3_29
		end
	end)
	_.each(var11_29, function(arg0_33)
		local var0_33 = arg0_33:GetTriggers()

		_.each(var0_33, function(arg0_34)
			if arg0_34.type == BossRushStoryNode.TRIGGER_TYPE.PT_GOT then
				if var0_29[arg0_33.id].status > var2_29 then
					var10_29 = var10_29 and math.max(arg0_34.value, var10_29) or arg0_34.value
				elseif var0_29[arg0_33.id].status == var2_29 then
					var9_29 = var9_29 and math.min(arg0_34.value, var9_29) or arg0_34.value
				end
			end
		end)
	end)
	setText(arg0_29._tf:Find("Story/PassLevel/PT/Text"), arg0_29.ptActivity.data1 .. "/" .. (var9_29 or var10_29 or ""))
	setText(arg0_29._tf:Find("Story/PassLevel/Values"):GetChild(0), var5_29)
	setText(arg0_29._tf:Find("Story/PassLevel/Values"):GetChild(2), var6_29)
	arg0_29:ReturnLinks()

	local var12_29 = false

	table.Foreach(arg0_29.storyNodesDict, function(arg0_35, arg1_35)
		local var0_35 = arg0_29.nodes[arg1_35:GetIconName()].trans
		local var1_35 = var0_29[arg0_35].status == var3_29
		local var2_35 = arg1_35:GetType()

		if var2_35 == BossRushStoryNode.NODE_TYPE.NORMAL then
			arg0_29.loader:GetSprite(arg0_29:GetAtalsName(), var1_35 and "story_green_active" or "story_green", var0_35:GetChild(0), true)
		elseif var2_35 == BossRushStoryNode.NODE_TYPE.EVENT then
			setActive(var0_35, var0_29[arg0_35].status > var2_29)
			arg0_29.loader:GetSprite(arg0_29:GetAtalsName(), var1_35 and "story_yellow_active" or "story_yellow", var0_35:GetChild(0), true)
		elseif var2_35 == BossRushStoryNode.NODE_TYPE.BATTLE then
			-- block empty
		end

		if var1_35 then
			local var3_35 = arg0_29._tf:Find("Story"):InverseTransformPoint(var0_35.position)

			setAnchoredPosition(arg0_29.storyBar, var3_35)
			setText(arg0_29.storyBar:Find("Text"), arg1_35:GetName())
			arg0_29.loader:GetSprite(arg0_29:GetAtalsName(), var2_0[var2_35], arg0_29.storyBar, true)
			onButton(arg0_29, arg0_29.storyBar, function()
				local var0_36 = arg1_35:GetStory()

				arg0_29:PlayStory(var0_36, function()
					arg0_29:UpdateView()
				end)
			end)

			var12_29 = true
		end

		local var4_35 = arg1_35:GetActiveLink()

		;(function()
			if var4_35 == 0 or var0_29[var4_35].status ~= var4_29 then
				return
			end

			local var0_38 = arg0_29.storyNodesDict[var4_35]
			local var1_38 = arg0_29.nodes[var0_38:GetIconName()].trans
			local var2_38 = arg0_29.plural:Dequeue()

			table.insert(arg0_29.links, go(var2_38))
			setActive(var2_38, true)
			setParent(var2_38, arg0_29.linksContainer)

			local var3_38 = arg0_29.linksContainer:InverseTransformPoint(var0_35.position)
			local var4_38 = arg0_29.linksContainer:InverseTransformPoint(var1_38.position) - var3_38
			local var5_38 = Vector2.Magnitude(var4_38)

			tf(var2_38).sizeDelta = Vector2(var5_38, 2)
			tf(var2_38).anchoredPosition = var3_38
			tf(var2_38).localRotation = Quaternion.FromToRotation(Vector3.right, var4_38)
		end)()
	end)
	setActive(arg0_29.storyBar, var12_29)
	setActive(arg0_29.storyAward, tobool(arg0_29.storyTask))

	if arg0_29.storyTask then
		local var13_29 = arg0_29.storyTask:getConfig("award_display")
		local var14_29 = {
			type = var13_29[1][1],
			id = var13_29[1][2],
			count = var13_29[1][3]
		}

		updateDrop(arg0_29.storyAward:Find("Mask"):GetChild(0), var14_29)
		onButton(arg0_29, arg0_29.storyAward:Find("Mask"):GetChild(0), function()
			arg0_29:emit(BaseUI.ON_DROP, var14_29)
		end)

		local var15_29 = arg0_29.storyTask:getTaskStatus()

		setActive(arg0_29.storyAward:Find("Got"), var15_29 == 2)

		if var15_29 == 1 then
			arg0_29:emit(BossRushKurskMediator.ON_TASK_SUBMIT, arg0_29.storyTask)
		end
	end

	setActive(arg0_29._tf:Find("Battle/Story/New"), var12_29)
end

function var0_0.ReturnLinks(arg0_40, arg1_40)
	for iter0_40, iter1_40 in ipairs(arg0_40.links) do
		if not arg0_40.plural:Enqueue(iter1_40, arg1_40) then
			setParent(iter1_40, arg0_40.pluralRoot)
		end
	end

	table.clean(arg0_40.links)
end

function var0_0.PlayStory(arg0_41, arg1_41, arg2_41)
	if not arg1_41 then
		return existCall(arg2_41)
	end

	local var0_41 = pg.NewStoryMgr.GetInstance()
	local var1_41 = var0_41:IsPlayed(arg1_41)

	seriesAsync({
		function(arg0_42)
			if var1_41 then
				return arg0_42()
			end

			local var0_42 = tonumber(arg1_41)

			if var0_42 and var0_42 > 0 then
				arg0_41:emit(BossRushKurskMediator.ON_PERFORM_COMBAT, var0_42)
			else
				var0_41:Play(arg1_41, arg0_42)
			end
		end,
		function(arg0_43, ...)
			existCall(arg2_41, ...)
		end
	})
end

function var0_0.UpdateTasks(arg0_44, arg1_44)
	if _.any(arg1_44, function(arg0_45)
		return arg0_44.storyTask and arg0_44.storyTask.id == arg0_45
	end) then
		arg0_44.storyTask.submitTime = 1

		arg0_44:UpdateView()
	end
end

function var0_0.addbubbleMsgBoxList(arg0_46, arg1_46)
	local var0_46 = #arg0_46.ActionSequence == 0

	table.insertto(arg0_46.ActionSequence, arg1_46)

	if not var0_46 then
		return
	end

	arg0_46:resumeBubble()
end

function var0_0.addbubbleMsgBox(arg0_47, arg1_47)
	local var0_47 = #arg0_47.ActionSequence == 0

	table.insert(arg0_47.ActionSequence, arg1_47)

	if not var0_47 then
		return
	end

	arg0_47:resumeBubble()
end

function var0_0.resumeBubble(arg0_48)
	if #arg0_48.ActionSequence == 0 then
		return
	end

	local var0_48

	local function var1_48()
		local var0_49 = arg0_48.ActionSequence[1]

		if var0_49 then
			var0_49(function()
				table.remove(arg0_48.ActionSequence, 1)
				var1_48()
			end)
		end
	end

	var1_48()
end

function var0_0.CleanBubbleMsgbox(arg0_51)
	table.clean(arg0_51.ActionSequence)
end

function var0_0.willExit(arg0_52)
	arg0_52:ReturnLinks(true)
	arg0_52.loader:Clear()
	var0_0.super.willExit(arg0_52)
end

return var0_0

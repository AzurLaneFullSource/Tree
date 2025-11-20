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

	print(arg1_9)

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
			if underscore.all(underscore.values(arg0_21.storyNodesDict), function(arg0_25)
				return arg0_25:IsReaded()
			end) then
				local var0_24 = arg0_21.activity:getConfig("config_client").endStory

				arg0_21:PlayStory(var0_24, function(arg0_26)
					arg0_24()

					if arg0_26 then
						arg0_21:UpdateView()
					end
				end)

				return
			end

			arg0_24()
		end
	})
end

function var0_0.UpdateBattle(arg0_27)
	local var0_27 = arg0_27.activity
	local var1_27 = var0_27:GetActiveSeriesIds()

	table.Foreach(arg0_27.seriesNodes, function(arg0_28, arg1_28)
		local var0_28 = var1_27[arg0_28]
		local var1_28 = BossRushSeriesData.New({
			id = var0_28,
			actId = var0_27.id
		})
		local var2_28 = var1_28:IsUnlock(var0_27)

		setActive(arg1_28:Find("Pin/NameBG"), var2_28)
		setActive(arg1_28:Find("Pin/Lock"), not var2_28)
		setText(arg1_28:Find("Pin/ChapterName"), var1_28:GetSeriesCode())
		setText(arg1_28:Find("Pin/NameBG/Name"), var1_28:GetName())

		local var3_28 = var1_28:GetType() == BossRushSeriesData.TYPE.SP

		setActive(arg1_28:Find("Pin/NameBG/BonusCount"), var2_28 and var3_28)

		local var4_28 = true

		if var3_28 then
			local var5_28 = var0_27:GetUsedBonus()[arg0_28] or 0
			local var6_28 = var1_28:GetMaxBonusCount()

			setText(arg1_28:Find("Pin/NameBG/BonusCount"):GetChild(0), i18n("series_enemy_SP_count"))
			setText(arg1_28:Find("Pin/NameBG/BonusCount"):GetChild(1), math.max(0, var6_28 - var5_28) .. "/" .. var6_28)

			var4_28 = var6_28 - var5_28 > 0
		end

		onButton(arg0_27, arg1_28, function()
			if not var2_28 then
				local var0_29 = var1_28:GetPreSeriesId()
				local var1_29 = BossRushSeriesData.New({
					id = var0_29
				})

				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_unlock", var1_29:GetName()))

				return
			end

			if not var4_28 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_SP_error"))

				return
			end

			arg0_27:emit(BossRushKurskMediator.ON_FLEET_SELECT, var1_28)
		end, SFX_PANEL)
	end)
	print(var0_27.id)
	setActive(arg0_27._tf:Find("Battle/Reward/Tip"), arg0_27.ptData:CanGetAward())
	setText(arg0_27.ptText, arg0_27.ptActivity.data1)
end

local var2_0 = {
	"story_bar_green",
	"story_bar_yellow",
	"story_bar_purple"
}

function var0_0.UpdateStory(arg0_30)
	local var0_30 = pg.NewStoryMgr.GetInstance()
	local var1_30 = 0
	local var2_30 = 0
	local var3_30
	local var4_30

	arg0_30:ReturnLinks()

	local var5_30 = false

	table.Foreach(arg0_30.storyNodesDict, function(arg0_31, arg1_31)
		local var0_31 = arg0_30.nodes[arg1_31:GetIconName()].trans
		local var1_31 = arg1_31:IsActive(arg0_30.activity, arg0_30.ptActivity)
		local var2_31 = arg1_31:IsReaded()
		local var3_31 = arg1_31:GetType()

		if var3_31 == BossRushStoryNode.NODE_TYPE.NORMAL then
			arg0_30.loader:GetSprite(arg0_30:GetAtalsName(), var1_31 and "story_green_active" or "story_green", var0_31:GetChild(0), true)
		elseif var3_31 == BossRushStoryNode.NODE_TYPE.EVENT then
			setActive(var0_31, var1_31)
			arg0_30.loader:GetSprite(arg0_30:GetAtalsName(), var1_31 and "story_yellow_active" or "story_yellow", var0_31:GetChild(0), true)
		elseif var3_31 == BossRushStoryNode.NODE_TYPE.BATTLE then
			-- block empty
		end

		if var1_31 then
			local var4_31 = arg0_30._tf:Find("Story"):InverseTransformPoint(var0_31.position)

			setAnchoredPosition(arg0_30.storyBar, var4_31)
			setText(arg0_30.storyBar:Find("Text"), arg1_31:GetName())
			arg0_30.loader:GetSprite(arg0_30:GetAtalsName(), var2_0[var3_31], arg0_30.storyBar, true)
			onButton(arg0_30, arg0_30.storyBar, function()
				local var0_32 = arg1_31:GetStory()

				arg0_30:PlayStory(var0_32, function()
					arg0_30:UpdateView()
				end)
			end)

			var5_30 = true
		end

		local var5_31 = arg1_31:GetActiveLink()

		;(function()
			if var5_31 == 0 or not var2_31 then
				return
			end

			local var0_34 = arg0_30.storyNodesDict[var5_31]
			local var1_34 = arg0_30.nodes[var0_34:GetIconName()].trans
			local var2_34 = arg0_30.plural:Dequeue()

			table.insert(arg0_30.links, go(var2_34))
			setActive(var2_34, true)
			setParent(var2_34, arg0_30.linksContainer)

			local var3_34 = arg0_30.linksContainer:InverseTransformPoint(var0_31.position)
			local var4_34 = arg0_30.linksContainer:InverseTransformPoint(var1_34.position) - var3_34
			local var5_34 = Vector2.Magnitude(var4_34)

			tf(var2_34).sizeDelta = Vector2(var5_34, 2)
			tf(var2_34).anchoredPosition = var3_34
			tf(var2_34).localRotation = Quaternion.FromToRotation(Vector3.right, var4_34)
		end)()

		local var6_31 = arg1_31:GetTriggers()

		_.each(var6_31, function(arg0_35)
			if arg0_35.type == BossRushStoryNode.TRIGGER_TYPE.PT_GOT then
				if var1_31 then
					var4_30 = var4_30 and math.max(arg0_35.value, var4_30) or arg0_35.value
				else
					var3_30 = var3_30 and math.min(arg0_35.value, var3_30) or arg0_35.value
				end
			end
		end)
	end)
	setText(arg0_30._tf:Find("Story/PassLevel/PT/Text"), arg0_30.ptActivity.data1 .. "/" .. (var3_30 or var4_30 or ""))
	setText(arg0_30._tf:Find("Story/PassLevel/Values"):GetChild(0), var1_30)
	setText(arg0_30._tf:Find("Story/PassLevel/Values"):GetChild(2), var2_30)
	setActive(arg0_30.storyBar, var5_30)
	setActive(arg0_30.storyAward, tobool(arg0_30.storyTask))

	if arg0_30.storyTask then
		local var6_30 = arg0_30.storyTask:getConfig("award_display")
		local var7_30 = {
			type = var6_30[1][1],
			id = var6_30[1][2],
			count = var6_30[1][3]
		}

		updateDrop(arg0_30.storyAward:Find("Mask"):GetChild(0), var7_30)
		onButton(arg0_30, arg0_30.storyAward:Find("Mask"):GetChild(0), function()
			arg0_30:emit(BaseUI.ON_DROP, var7_30)
		end)

		local var8_30 = arg0_30.storyTask:getTaskStatus()

		setActive(arg0_30.storyAward:Find("Got"), var8_30 == 2)

		if var8_30 == 1 then
			arg0_30:emit(BossRushKurskMediator.ON_TASK_SUBMIT, arg0_30.storyTask)
		end
	end

	setActive(arg0_30._tf:Find("Battle/Story/New"), var5_30)
end

function var0_0.ReturnLinks(arg0_37, arg1_37)
	for iter0_37, iter1_37 in ipairs(arg0_37.links) do
		if not arg0_37.plural:Enqueue(iter1_37, arg1_37) then
			setParent(iter1_37, arg0_37.pluralRoot)
		end
	end

	table.clean(arg0_37.links)
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
				arg0_38:emit(BossRushKurskMediator.ON_PERFORM_COMBAT, var0_39)
			else
				var0_38:Play(arg1_38, arg0_39)
			end
		end,
		function(arg0_40, ...)
			existCall(arg2_38, ...)
		end
	})
end

function var0_0.UpdateTasks(arg0_41, arg1_41)
	if _.any(arg1_41, function(arg0_42)
		return arg0_41.storyTask and arg0_41.storyTask.id == arg0_42
	end) then
		arg0_41.storyTask.submitTime = 1

		arg0_41:UpdateView()
	end
end

function var0_0.addbubbleMsgBoxList(arg0_43, arg1_43)
	local var0_43 = #arg0_43.ActionSequence == 0

	table.insertto(arg0_43.ActionSequence, arg1_43)

	if not var0_43 then
		return
	end

	arg0_43:resumeBubble()
end

function var0_0.addbubbleMsgBox(arg0_44, arg1_44)
	local var0_44 = #arg0_44.ActionSequence == 0

	table.insert(arg0_44.ActionSequence, arg1_44)

	if not var0_44 then
		return
	end

	arg0_44:resumeBubble()
end

function var0_0.resumeBubble(arg0_45)
	if #arg0_45.ActionSequence == 0 then
		return
	end

	local var0_45

	local function var1_45()
		local var0_46 = arg0_45.ActionSequence[1]

		if var0_46 then
			var0_46(function()
				table.remove(arg0_45.ActionSequence, 1)
				var1_45()
			end)
		end
	end

	var1_45()
end

function var0_0.CleanBubbleMsgbox(arg0_48)
	table.clean(arg0_48.ActionSequence)
end

function var0_0.willExit(arg0_49)
	arg0_49:ReturnLinks(true)
	arg0_49.loader:Clear()
	var0_0.super.willExit(arg0_49)
end

return var0_0

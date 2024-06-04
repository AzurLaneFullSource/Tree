local var0 = class("BossRushKurskScene", import("view.base.BaseUI"))
local var1 = require("Mgr/Pool/PoolPlural")

var0.DISPLAY = {
	STORY = 2,
	BATTLE = 1
}

function var0.getUIName(arg0)
	return "BossRushKurskUI"
end

function var0.GetAtalsName(arg0)
	return "ui/BossRushKurskUI_atlas"
end

function var0.ResUISettings(arg0)
	return true
end

function var0.Ctor(arg0)
	var0.super.Ctor(arg0)

	arg0.loader = AutoLoader.New()
end

function var0.preload(arg0, arg1)
	existCall(arg1)
	arg0.loader:LoadBundle(arg0:GetAtalsName())
end

function var0.init(arg0)
	arg0.top = arg0._tf:Find("Top")
	arg0.map = arg0._tf:Find("Map")
	arg0.seriesNodes = _.map(_.range(arg0._tf:Find("Battle/Nodes").childCount), function(arg0)
		return arg0._tf:Find("Battle/Nodes"):GetChild(arg0 - 1)
	end)
	arg0.ptText = arg0._tf:Find("Battle/Reward/Text")
	arg0.nodes = {}

	for iter0 = 1, arg0._tf:Find("Map").childCount do
		local var0 = arg0._tf:Find("Map"):GetChild(iter0 - 1)

		arg0.nodes[var0.name] = {
			tfType = 1,
			trans = var0
		}
	end

	for iter1 = 1, arg0._tf:Find("Story/Nodes").childCount do
		local var1 = arg0._tf:Find("Story/Nodes"):GetChild(iter1 - 1)

		arg0.nodes[var1.name] = {
			tfType = 2,
			trans = var1
		}
	end

	arg0.pluralRoot = pg.PoolMgr.GetInstance().root

	local var2 = go(arg0._tf:Find("Link"))

	setActive(var2, false)

	arg0.plural = var1.New(var2, 32)
	arg0.linksContainer = arg0._tf:Find("Links")
	arg0.links = {}
	arg0.storyBar = arg0._tf:Find("Story/StoryBar")
	arg0.storyAward = arg0._tf:Find("Story/PassLevel/Award")
	arg0.ActionSequence = {}

	setText(arg0._tf:Find("Battle/Rank/Title"), i18n("word_billboard"))
	setText(arg0._tf:Find("Battle/Reward/Title"), i18n("series_enemy_reward"))
	setText(arg0._tf:Find("Story/PassLevel/Title"), i18n("series_enemy_storyreward"))
	setText(arg0._tf:Find("Story/PassLevel/PT/Tips"), i18n("series_enemy_storyunlock"))
end

function var0.SetActivity(arg0, arg1)
	arg0.activity = arg1
end

function var0.SetPtActivity(arg0, arg1)
	arg0.ptActivity = arg1
	arg0.ptData = ActivityPtData.New(arg0.ptActivity)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.top:Find("back_btn"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0.top:Find("option"), function()
		arg0:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = {
				{
					info = i18n("series_enemy_help")
				}
			}
		})
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("Battle/Rank"), function()
		arg0:emit(BossRushKurskMediator.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("Battle/Reward"), function()
		arg0:emit(BossRushKurskMediator.GO_ACT_SHOP, arg0.ptData)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("Battle/Story"), function()
		arg0:SetDisplayMode(var0.DISPLAY.STORY)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("Story/Battle"), function()
		arg0:SetDisplayMode(var0.DISPLAY.BATTLE)
	end, SFX_PANEL)

	local var0 = arg0.activity:getConfig("config_client").storys

	arg0.storyNodesDict = {}

	_.each(var0, function(arg0)
		arg0.storyNodesDict[arg0] = BossRushStoryNode.New({
			id = arg0
		})
	end)

	local var1 = arg0.activity:getConfig("config_client").tasks[1]

	arg0.storyTask = getProxy(TaskProxy):getTaskVO(var1) or Task.New({
		submitTime = 1,
		id = var1
	})

	local var2 = arg0.contextData.displayMode or BossRushKurskScene.DISPLAY.BATTLE

	arg0.contextData.displayMode = nil

	arg0:SetDisplayMode(var2)
end

function var0.getBGM(arg0)
	local var0 = pg.voice_bgm[arg0.__cname]

	if not var0 then
		return nil
	end

	local var1 = var0.bgm
	local var2 = var0.special_bgm
	local var3 = arg0.contextData.displayMode

	if var3 == var0.DISPLAY.BATTLE then
		return var1
	elseif var3 == var0.DISPLAY.STORY then
		return var2
	end
end

function var0.SetDisplayMode(arg0, arg1)
	if arg1 == arg0.contextData.displayMode then
		return
	end

	arg0.contextData.displayMode = arg1

	arg0:PlayBGM()
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0 = arg0.contextData.displayMode == var0.DISPLAY.BATTLE

	setActive(arg0._tf:Find("Battle"), var0)
	setActive(arg0._tf:Find("Story"), not var0)
	setActive(arg0._tf:Find("Links"), not var0)
	arg0:UpdateBattle()
	arg0:UpdateStory()

	local var1 = arg0.contextData.displayMode

	arg0:addbubbleMsgBoxList({
		function(arg0)
			if arg0.activity:HasPassSeries(1001) then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0036", nil, arg0)

				return
			end

			arg0()
		end,
		function(arg0)
			local var0

			if var1 == var0.DISPLAY.BATTLE then
				var0 = arg0.activity:getConfig("config_client").openActivityStory
			elseif var1 == var0.DISPLAY.STORY then
				var0 = arg0.activity:getConfig("config_client").openStory
			end

			arg0:PlayStory(var0, arg0)
		end,
		function(arg0)
			local var0 = true

			for iter0, iter1 in pairs(arg0.storyNodesDict) do
				local var1 = iter1:GetStory()

				if var1 and var1 ~= "" then
					var0 = var0 and pg.NewStoryMgr.GetInstance():IsPlayed(var1)
				end

				if not var0 then
					break
				end
			end

			if var0 then
				local var2 = arg0.activity:getConfig("config_client").endStory

				arg0:PlayStory(var2, function(arg0)
					arg0()

					if arg0 then
						arg0:UpdateView()
					end
				end)

				return
			end

			arg0()
		end
	})
end

function var0.UpdateBattle(arg0)
	local var0 = arg0.activity
	local var1 = var0:GetActiveSeriesIds()

	table.Foreach(arg0.seriesNodes, function(arg0, arg1)
		local var0 = var1[arg0]
		local var1 = BossRushSeriesData.New({
			id = var0,
			actId = var0.id
		})
		local var2 = var1:IsUnlock(var0)

		setActive(arg1:Find("Pin/NameBG"), var2)
		setActive(arg1:Find("Pin/Lock"), not var2)
		setText(arg1:Find("Pin/ChapterName"), var1:GetSeriesCode())
		setText(arg1:Find("Pin/NameBG/Name"), var1:GetName())

		local var3 = var1:GetType() == BossRushSeriesData.TYPE.SP

		setActive(arg1:Find("Pin/NameBG/BonusCount"), var2 and var3)

		local var4 = true

		if var3 then
			local var5 = var0:GetUsedBonus()[arg0] or 0
			local var6 = var1:GetMaxBonusCount()

			setText(arg1:Find("Pin/NameBG/BonusCount"):GetChild(0), i18n("series_enemy_SP_count"))
			setText(arg1:Find("Pin/NameBG/BonusCount"):GetChild(1), math.max(0, var6 - var5) .. "/" .. var6)

			var4 = var6 - var5 > 0
		end

		onButton(arg0, arg1, function()
			if not var2 then
				local var0 = var1:GetPreSeriesId()
				local var1 = BossRushSeriesData.New({
					id = var0
				})

				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_unlock", var1:GetName()))

				return
			end

			if not var4 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_SP_error"))

				return
			end

			arg0:emit(BossRushKurskMediator.ON_FLEET_SELECT, var1)
		end, SFX_PANEL)
	end)
	setActive(arg0._tf:Find("Battle/Reward/Tip"), arg0.ptData:CanGetAward())
	setText(arg0.ptText, arg0.ptActivity.data1)
end

local var2 = {
	"story_bar_green",
	"story_bar_yellow",
	"story_bar_purple"
}

function var0.UpdateStory(arg0)
	local var0 = {}
	local var1 = pg.NewStoryMgr.GetInstance()
	local var2 = 1
	local var3 = 2
	local var4 = 3
	local var5 = 0
	local var6 = 0

	for iter0, iter1 in pairs(arg0.storyNodesDict) do
		var0[iter0] = {}

		local var7 = iter1:GetStory()
		local var8 = true

		if var7 and var7 ~= "" then
			var8 = var1:IsPlayed(var7)
			var5 = var5 + (var8 and 1 or 0)
			var6 = var6 + 1
		end

		var0[iter0].status = var8 and var4 or var2
	end

	local var9
	local var10
	local var11 = _.sort(_.values(arg0.storyNodesDict), function(arg0, arg1)
		return arg0.id < arg1.id
	end)

	_.each(var11, function(arg0)
		local var0 = arg0:GetTriggers()

		if var0[arg0.id].status == var4 then
			return
		end

		if not _.any(var0, function(arg0)
			if arg0.type == BossRushStoryNode.TRIGGER_TYPE.PT_GOT then
				return arg0.ptActivity.data1 < arg0.value
			elseif arg0.type == BossRushStoryNode.TRIGGER_TYPE.SERIES_PASSED then
				return not BossRushSeriesData.New({
					id = arg0.value,
					actId = arg0.activity.id
				}):IsUnlock(arg0.activity)
			elseif arg0.type == BossRushStoryNode.TRIGGER_TYPE.STORY_READED then
				return var0[arg0.value].status < var4
			end
		end) then
			var0[arg0.id].status = var3
		end
	end)
	_.each(var11, function(arg0)
		local var0 = arg0:GetTriggers()

		_.each(var0, function(arg0)
			if arg0.type == BossRushStoryNode.TRIGGER_TYPE.PT_GOT then
				if var0[arg0.id].status > var2 then
					var10 = var10 and math.max(arg0.value, var10) or arg0.value
				elseif var0[arg0.id].status == var2 then
					var9 = var9 and math.min(arg0.value, var9) or arg0.value
				end
			end
		end)
	end)
	setText(arg0._tf:Find("Story/PassLevel/PT/Text"), arg0.ptActivity.data1 .. "/" .. (var9 or var10 or ""))
	setText(arg0._tf:Find("Story/PassLevel/Values"):GetChild(0), var5)
	setText(arg0._tf:Find("Story/PassLevel/Values"):GetChild(2), var6)
	arg0:ReturnLinks()

	local var12 = false

	table.Foreach(arg0.storyNodesDict, function(arg0, arg1)
		local var0 = arg0.nodes[arg1:GetIconName()].trans
		local var1 = var0[arg0].status == var3
		local var2 = arg1:GetType()

		if var2 == BossRushStoryNode.NODE_TYPE.NORMAL then
			arg0.loader:GetSprite(arg0:GetAtalsName(), var1 and "story_green_active" or "story_green", var0:GetChild(0), true)
		elseif var2 == BossRushStoryNode.NODE_TYPE.EVENT then
			setActive(var0, var0[arg0].status > var2)
			arg0.loader:GetSprite(arg0:GetAtalsName(), var1 and "story_yellow_active" or "story_yellow", var0:GetChild(0), true)
		elseif var2 == BossRushStoryNode.NODE_TYPE.BATTLE then
			-- block empty
		end

		if var1 then
			local var3 = arg0._tf:Find("Story"):InverseTransformPoint(var0.position)

			setAnchoredPosition(arg0.storyBar, var3)
			setText(arg0.storyBar:Find("Text"), arg1:GetName())
			arg0.loader:GetSprite(arg0:GetAtalsName(), var2[var2], arg0.storyBar, true)
			onButton(arg0, arg0.storyBar, function()
				local var0 = arg1:GetStory()

				arg0:PlayStory(var0, function()
					arg0:UpdateView()
				end)
			end)

			var12 = true
		end

		local var4 = arg1:GetActiveLink()

		;(function()
			if var4 == 0 or var0[var4].status ~= var4 then
				return
			end

			local var0 = arg0.storyNodesDict[var4]
			local var1 = arg0.nodes[var0:GetIconName()].trans
			local var2 = arg0.plural:Dequeue()

			table.insert(arg0.links, go(var2))
			setActive(var2, true)
			setParent(var2, arg0.linksContainer)

			local var3 = arg0.linksContainer:InverseTransformPoint(var0.position)
			local var4 = arg0.linksContainer:InverseTransformPoint(var1.position) - var3
			local var5 = Vector2.Magnitude(var4)

			tf(var2).sizeDelta = Vector2(var5, 2)
			tf(var2).anchoredPosition = var3
			tf(var2).localRotation = Quaternion.FromToRotation(Vector3.right, var4)
		end)()
	end)
	setActive(arg0.storyBar, var12)
	setActive(arg0.storyAward, tobool(arg0.storyTask))

	if arg0.storyTask then
		local var13 = arg0.storyTask:getConfig("award_display")
		local var14 = {
			type = var13[1][1],
			id = var13[1][2],
			count = var13[1][3]
		}

		updateDrop(arg0.storyAward:Find("Mask"):GetChild(0), var14)
		onButton(arg0, arg0.storyAward:Find("Mask"):GetChild(0), function()
			arg0:emit(BaseUI.ON_DROP, var14)
		end)

		local var15 = arg0.storyTask:getTaskStatus()

		setActive(arg0.storyAward:Find("Got"), var15 == 2)

		if var15 == 1 then
			arg0:emit(BossRushKurskMediator.ON_TASK_SUBMIT, arg0.storyTask)
		end
	end

	setActive(arg0._tf:Find("Battle/Story/New"), var12)
end

function var0.ReturnLinks(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.links) do
		if not arg0.plural:Enqueue(iter1, arg1) then
			setParent(iter1, arg0.pluralRoot)
		end
	end

	table.clean(arg0.links)
end

function var0.PlayStory(arg0, arg1, arg2)
	if not arg1 then
		return existCall(arg2)
	end

	local var0 = pg.NewStoryMgr.GetInstance()
	local var1 = var0:IsPlayed(arg1)

	seriesAsync({
		function(arg0)
			if var1 then
				return arg0()
			end

			local var0 = tonumber(arg1)

			if var0 and var0 > 0 then
				arg0:emit(BossRushKurskMediator.ON_PERFORM_COMBAT, var0)
			else
				var0:Play(arg1, arg0)
			end
		end,
		function(arg0, ...)
			existCall(arg2, ...)
		end
	})
end

function var0.UpdateTasks(arg0, arg1)
	if _.any(arg1, function(arg0)
		return arg0.storyTask and arg0.storyTask.id == arg0
	end) then
		arg0.storyTask.submitTime = 1

		arg0:UpdateView()
	end
end

function var0.addbubbleMsgBoxList(arg0, arg1)
	local var0 = #arg0.ActionSequence == 0

	table.insertto(arg0.ActionSequence, arg1)

	if not var0 then
		return
	end

	arg0:resumeBubble()
end

function var0.addbubbleMsgBox(arg0, arg1)
	local var0 = #arg0.ActionSequence == 0

	table.insert(arg0.ActionSequence, arg1)

	if not var0 then
		return
	end

	arg0:resumeBubble()
end

function var0.resumeBubble(arg0)
	if #arg0.ActionSequence == 0 then
		return
	end

	local var0

	local function var1()
		local var0 = arg0.ActionSequence[1]

		if var0 then
			var0(function()
				table.remove(arg0.ActionSequence, 1)
				var1()
			end)
		end
	end

	var1()
end

function var0.CleanBubbleMsgbox(arg0)
	table.clean(arg0.ActionSequence)
end

function var0.willExit(arg0)
	arg0:ReturnLinks(true)
	arg0.loader:Clear()
	var0.super.willExit(arg0)
end

return var0

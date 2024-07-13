local var0_0 = class("BillboardScene", import("..base.BaseUI"))

var0_0.SINGLE_SHOW = {
	PowerRank.TYPE_EXTRA_CHAPTER,
	PowerRank.TYPE_ACT_BOSS_BATTLE,
	PowerRank.TYPE_BOSSRUSH
}

function var0_0.getUIName(arg0_1)
	return "BillboardUI"
end

function var0_0.updateRankList(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	if not arg0_2.rankVOs then
		arg0_2.rankVOs = {}
	end

	if not arg0_2.playerRankVOs then
		arg0_2.playerRankVOs = {}
	end

	arg0_2.rankVOs[arg1_2] = arg2_2

	if not arg0_2.ptRanks then
		arg0_2.ptRanks = {}
	end

	if arg1_2 == PowerRank.TYPE_PT then
		assert(arg4_2)

		arg0_2.ptRanks[arg4_2] = arg2_2
		arg0_2.playerPTRankVOMap = arg0_2.playerPTRankVOMap or {}
		arg0_2.playerPTRankVOMap[arg4_2] = arg3_2
	end

	arg0_2.playerRankVOs[arg1_2] = arg3_2
end

function var0_0.init(arg0_3)
	arg0_3.blurPanel = arg0_3:findTF("blur_panel")
	arg0_3.rankRect = arg0_3:findTF("main/frame/ranks"):GetComponent("LScrollRect")
	arg0_3.playerRankTF = arg0_3:findTF("main/frame/player_rank")

	setActive(arg0_3.playerRankTF, false)

	arg0_3.topPanel = arg0_3:findTF("adapt/top", arg0_3.blurPanel)
	arg0_3.leftPanel = arg0_3:findTF("adapt/left_length", arg0_3.blurPanel)
	arg0_3.mainPanel = arg0_3:findTF("main")
	arg0_3.extraChapterBg = arg0_3:findTF("extra_chapter_bg")
	arg0_3.toggleScrollRect = arg0_3:findTF("frame/scroll_rect", arg0_3.leftPanel)
	arg0_3.toggleContainer = arg0_3:findTF("frame/scroll_rect/tagRoot", arg0_3.leftPanel)
	arg0_3.listEmptyTF = arg0_3:findTF("main/frame/empty")

	setActive(arg0_3.listEmptyTF, false)

	arg0_3.listEmptyTxt = arg0_3:findTF("Text", arg0_3.listEmptyTF)

	setText(arg0_3.listEmptyTxt, i18n("list_empty_tip_billboardui"))

	arg0_3.toggles = {
		arg0_3:findTF("frame/scroll_rect/tagRoot/power", arg0_3.leftPanel),
		arg0_3:findTF("frame/scroll_rect/tagRoot/collection", arg0_3.leftPanel),
		arg0_3:findTF("frame/scroll_rect/tagRoot/pt", arg0_3.leftPanel),
		arg0_3:findTF("frame/scroll_rect/tagRoot/pledge", arg0_3.leftPanel),
		arg0_3:findTF("frame/scroll_rect/tagRoot/chanllenge", arg0_3.leftPanel),
		arg0_3:findTF("frame/scroll_rect/tagRoot/extra_chapter", arg0_3.leftPanel),
		arg0_3:findTF("frame/scroll_rect/tagRoot/boss_battle", arg0_3.leftPanel),
		arg0_3:findTF("frame/scroll_rect/tagRoot/guild", arg0_3.leftPanel),
		arg0_3:findTF("frame/scroll_rect/tagRoot/military", arg0_3.leftPanel),
		arg0_3:findTF("frame/scroll_rect/tagRoot/bossrush", arg0_3.leftPanel)
	}
	arg0_3.ptToggles = {}

	local var0_3 = _.filter(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_4)
		return not arg0_4:isEnd() and tonumber(arg0_4:getConfig("config_data")) > 0
	end)

	if #var0_3 > 1 then
		local var1_3 = arg0_3.toggles[3]

		for iter0_3, iter1_3 in pairs(var0_3) do
			local var2_3 = cloneTplTo(var1_3, var1_3.parent)

			arg0_3.ptToggles[iter1_3.id] = var2_3
		end

		arg0_3.toggles[3] = nil
	end

	arg0_3:updateToggles()

	arg0_3.rankRect.decelerationRate = 0.07

	local var3_3 = arg0_3.contextData.page or PowerRank.TYPE_POWER

	if table.contains(var0_0.SINGLE_SHOW, var3_3) then
		setActive(arg0_3.leftPanel, false)
		setAnchoredPosition(arg0_3.mainPanel, Vector2(0, -35.5))

		local var4_3 = GetSpriteFromAtlas("commonbg/bg_fengshan", "")

		setImageSprite(arg0_3.extraChapterBg, var4_3)
	end

	setActive(arg0_3.extraChapterBg, var3_3 == PowerRank.TYPE_EXTRA_CHAPTER)
end

function var0_0.updateToggles(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5.toggles) do
		local var0_5

		if PowerRank.typeInfo[iter0_5].act_type then
			var0_5 = PowerRank:getActivityByRankType(iter0_5)
		else
			var0_5 = (iter0_5 ~= PowerRank.TYPE_PLEDGE or false) and (iter0_5 == PowerRank.TYPE_GUILD_BATTLE and true or true)
		end

		setActive(iter1_5, var0_5)
	end

	for iter2_5, iter3_5 in pairs(arg0_5.ptToggles) do
		local var1_5 = getProxy(ActivityProxy):getActivityById(iter2_5)

		setActive(iter3_5, var1_5 and not var1_5:isEnd())
	end

	setActive(arg0_5.toggleContainer, true)
	Canvas.ForceUpdateCanvases()

	local var2_5 = arg0_5.toggleScrollRect.rect.height < arg0_5.toggleContainer.rect.height

	arg0_5.toggleContainer:GetComponent(typeof(ScrollRect)).enabled = var2_5
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6:findTF("back_btn", arg0_6.topPanel), function()
		arg0_6:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)

	for iter0_6, iter1_6 in pairs(arg0_6.toggles) do
		onToggle(arg0_6, iter1_6, function(arg0_8)
			if iter0_6 == PowerRank.TYPE_GUILD_BATTLE then
				setActive(arg0_6.mainPanel, not arg0_8)
				arg0_6:emit(BillboardMediator.ON_GUILD_RANK, arg0_8)

				return
			end

			if arg0_8 then
				local var0_8 = checkExist(PowerRank:getActivityByRankType(iter0_6), {
					"id"
				})

				arg0_6:switchPage(iter0_6, var0_8)
			end
		end, SFX_PANEL)
	end

	for iter2_6, iter3_6 in pairs(arg0_6.ptToggles) do
		onToggle(arg0_6, iter3_6, function(arg0_9)
			if arg0_9 then
				arg0_6:switchPage(PowerRank.TYPE_PT, iter2_6)
			end
		end, SFX_PANEL)
	end

	arg0_6.cards = {}

	function arg0_6.rankRect.onInitItem(arg0_10)
		arg0_6:onInintItem(arg0_10)
	end

	function arg0_6.rankRect.onUpdateItem(arg0_11, arg1_11)
		arg0_6:onUpdateItem(arg0_11, arg1_11, arg0_6.curPagePTActID)
	end

	function arg0_6.rankRect.onReturnItem(arg0_12, arg1_12)
		arg0_6:onReturnItem(arg0_12, arg1_12)
	end

	arg0_6.playerCard = RankCard.New(arg0_6.playerRankTF, RankCard.TYPE_SELF)

	local var0_6 = arg0_6.contextData.page or PowerRank.TYPE_POWER

	triggerToggle(arg0_6.toggles[var0_6], true)
end

function var0_0.onInintItem(arg0_13, arg1_13)
	local var0_13 = RankCard.New(arg1_13, RankCard.TYPE_OTHER)

	onButton(arg0_13, var0_13._tf, function()
		if var0_13.rankVO.type == PowerRank.TYPE_MILITARY_RANK then
			arg0_13:emit(BillboardMediator.OPEN_RIVAL_INFO, var0_13.rankVO.id)
		end
	end)

	arg0_13.cards[arg1_13] = var0_13
end

function var0_0.onUpdateItem(arg0_15, arg1_15, arg2_15, arg3_15)
	local var0_15 = arg0_15.cards[arg2_15]

	if not var0_15 then
		arg0_15:onInintItem(arg2_15)

		var0_15 = arg0_15.cards[arg2_15]
	end

	local var1_15 = arg0_15.displayRankVOs[arg1_15 + 1]

	var0_15:update(var1_15, arg3_15)
end

function var0_0.onReturnItem(arg0_16, arg1_16, arg2_16)
	if arg0_16.exited then
		return
	end

	local var0_16 = arg0_16.cards[arg2_16]

	if var0_16 then
		var0_16:clear()
	end
end

function var0_0.filter(arg0_17, arg1_17, arg2_17)
	if arg1_17 ~= arg0_17.page then
		return
	end

	local var0_17 = arg0_17.page
	local var1_17

	if PowerRank.TYPE_PT == arg1_17 then
		assert(arg2_17)

		var1_17 = arg0_17.ptRanks[arg2_17]
	else
		var1_17 = arg0_17.rankVOs[var0_17]
	end

	arg0_17.displayRankVOs = {}

	for iter0_17, iter1_17 in ipairs(var1_17) do
		table.insert(arg0_17.displayRankVOs, iter1_17)
	end

	arg0_17.rankRect:SetTotalCount(#arg0_17.displayRankVOs)
	setActive(arg0_17.listEmptyTF, #arg0_17.displayRankVOs <= 0)

	local var2_17 = arg0_17.playerRankVOs[arg0_17.page]

	if PowerRank.TYPE_PT == arg1_17 then
		local var3_17 = arg0_17.playerPTRankVOMap[arg2_17]

		arg0_17.playerCard:update(var3_17, arg2_17)
	else
		arg0_17.playerCard:update(var2_17, arg2_17)
	end
end

function var0_0.switchPage(arg0_18, arg1_18, arg2_18)
	if arg0_18.page == arg1_18 and arg1_18 ~= PowerRank.TYPE_PT then
		return
	end

	if arg1_18 == PowerRank.TYPE_PT then
		arg0_18.curPagePTActID = arg2_18
	else
		arg0_18.curPagePTActID = nil
	end

	arg0_18.page = arg1_18

	local var0_18

	if arg0_18.page == PowerRank.TYPE_PT then
		assert(arg2_18)

		var0_18 = arg0_18.ptRanks[arg2_18]
	else
		var0_18 = arg0_18.rankVOs[arg1_18]
	end

	if not var0_18 then
		arg0_18.rankRect:SetTotalCount(0)
		arg0_18.playerCard:clear()
		arg0_18:emit(BillboardMediator.FETCH_RANKS, arg0_18.page, arg2_18)
	else
		arg0_18:filter(arg0_18.page, arg2_18)
	end

	setActive(arg0_18:findTF("tip", arg0_18.topPanel), not table.contains(BillboardProxy.NONTIMER, arg0_18.page))
	arg0_18:updateScoreTitle(arg0_18.page, arg2_18)
end

function var0_0.updateScoreTitle(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19:findTF("main/frame/title")
	local var1_19 = PowerRank:getTitleWord(arg1_19, arg2_19)

	for iter0_19 = 1, 4 do
		setText(var0_19:GetChild(iter0_19 - 1), var1_19[iter0_19])
	end
end

function var0_0.willExit(arg0_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.cards) do
		iter1_20:dispose()
	end

	arg0_20.playerCard:dispose()

	if arg0_20.name then
		retPaintingPrefab(arg0_20.paintingTF, arg0_20.name)
	end
end

return var0_0

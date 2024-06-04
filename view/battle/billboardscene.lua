local var0 = class("BillboardScene", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "BillboardUI"
end

function var0.updateRankList(arg0, arg1, arg2, arg3, arg4)
	if not arg0.rankVOs then
		arg0.rankVOs = {}
	end

	if not arg0.playerRankVOs then
		arg0.playerRankVOs = {}
	end

	arg0.rankVOs[arg1] = arg2

	if not arg0.ptRanks then
		arg0.ptRanks = {}
	end

	if arg1 == PowerRank.TYPE_PT then
		assert(arg4)

		arg0.ptRanks[arg4] = arg2
		arg0.playerPTRankVOMap = arg0.playerPTRankVOMap or {}
		arg0.playerPTRankVOMap[arg4] = arg3
	end

	arg0.playerRankVOs[arg1] = arg3
end

function var0.init(arg0)
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.rankRect = arg0:findTF("main/frame/ranks"):GetComponent("LScrollRect")
	arg0.playerRankTF = arg0:findTF("main/frame/player_rank")

	setActive(arg0.playerRankTF, false)

	arg0.topPanel = arg0:findTF("adapt/top", arg0.blurPanel)
	arg0.leftPanel = arg0:findTF("adapt/left_length", arg0.blurPanel)
	arg0.mainPanel = arg0:findTF("main")
	arg0.extraChapterBg = arg0:findTF("extra_chapter_bg")
	arg0.toggleScrollRect = arg0:findTF("frame/scroll_rect", arg0.leftPanel)
	arg0.toggleContainer = arg0:findTF("frame/scroll_rect/tagRoot", arg0.leftPanel)
	arg0.listEmptyTF = arg0:findTF("main/frame/empty")

	setActive(arg0.listEmptyTF, false)

	arg0.listEmptyTxt = arg0:findTF("Text", arg0.listEmptyTF)

	setText(arg0.listEmptyTxt, i18n("list_empty_tip_billboardui"))

	arg0.toggles = {
		arg0:findTF("frame/scroll_rect/tagRoot/power", arg0.leftPanel),
		arg0:findTF("frame/scroll_rect/tagRoot/collection", arg0.leftPanel),
		arg0:findTF("frame/scroll_rect/tagRoot/pt", arg0.leftPanel),
		arg0:findTF("frame/scroll_rect/tagRoot/pledge", arg0.leftPanel),
		arg0:findTF("frame/scroll_rect/tagRoot/chanllenge", arg0.leftPanel),
		arg0:findTF("frame/scroll_rect/tagRoot/extra_chapter", arg0.leftPanel),
		arg0:findTF("frame/scroll_rect/tagRoot/boss_battle", arg0.leftPanel),
		arg0:findTF("frame/scroll_rect/tagRoot/guild", arg0.leftPanel),
		arg0:findTF("frame/scroll_rect/tagRoot/military", arg0.leftPanel),
		arg0:findTF("frame/scroll_rect/tagRoot/bossrush", arg0.leftPanel)
	}
	arg0.ptToggles = {}

	local var0 = _.filter(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0)
		return not arg0:isEnd() and tonumber(arg0:getConfig("config_data")) > 0
	end)

	if #var0 > 1 then
		local var1 = arg0.toggles[3]

		for iter0, iter1 in pairs(var0) do
			local var2 = cloneTplTo(var1, var1.parent)

			arg0.ptToggles[iter1.id] = var2
		end

		arg0.toggles[3] = nil
	end

	arg0:updateToggles()

	arg0.rankRect.decelerationRate = 0.07

	local var3 = arg0.contextData.page or PowerRank.TYPE_POWER

	if var3 == PowerRank.TYPE_EXTRA_CHAPTER then
		setActive(arg0.leftPanel, false)
		setAnchoredPosition(arg0.mainPanel, Vector2(0, -35.5))

		local var4 = GetSpriteFromAtlas("commonbg/bg_fengshan", "")

		setImageSprite(arg0.extraChapterBg, var4)
	end

	setActive(arg0.extraChapterBg, var3 == PowerRank.TYPE_EXTRA_CHAPTER)
end

function var0.updateToggles(arg0)
	for iter0, iter1 in pairs(arg0.toggles) do
		local var0

		if PowerRank.typeInfo[iter0].act_type then
			var0 = PowerRank:getActivityByRankType(iter0)
		else
			var0 = (iter0 ~= PowerRank.TYPE_PLEDGE or false) and (iter0 == PowerRank.TYPE_GUILD_BATTLE and true or true)
		end

		setActive(iter1, var0)
	end

	for iter2, iter3 in pairs(arg0.ptToggles) do
		local var1 = getProxy(ActivityProxy):getActivityById(iter2)

		setActive(iter3, var1 and not var1:isEnd())
	end

	setActive(arg0.toggleContainer, true)
	Canvas.ForceUpdateCanvases()

	local var2 = arg0.toggleScrollRect.rect.height < arg0.toggleContainer.rect.height

	arg0.toggleContainer:GetComponent(typeof(ScrollRect)).enabled = var2
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("back_btn", arg0.topPanel), function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)

	for iter0, iter1 in pairs(arg0.toggles) do
		onToggle(arg0, iter1, function(arg0)
			if iter0 == PowerRank.TYPE_GUILD_BATTLE then
				setActive(arg0.mainPanel, not arg0)
				arg0:emit(BillboardMediator.ON_GUILD_RANK, arg0)

				return
			end

			if arg0 then
				local var0 = checkExist(PowerRank:getActivityByRankType(iter0), {
					"id"
				})

				arg0:switchPage(iter0, var0)
			end
		end, SFX_PANEL)
	end

	for iter2, iter3 in pairs(arg0.ptToggles) do
		onToggle(arg0, iter3, function(arg0)
			if arg0 then
				arg0:switchPage(PowerRank.TYPE_PT, iter2)
			end
		end, SFX_PANEL)
	end

	arg0.cards = {}

	function arg0.rankRect.onInitItem(arg0)
		arg0:onInintItem(arg0)
	end

	function arg0.rankRect.onUpdateItem(arg0, arg1)
		arg0:onUpdateItem(arg0, arg1, arg0.curPagePTActID)
	end

	function arg0.rankRect.onReturnItem(arg0, arg1)
		arg0:onReturnItem(arg0, arg1)
	end

	arg0.playerCard = RankCard.New(arg0.playerRankTF, RankCard.TYPE_SELF)

	local var0 = arg0.contextData.page or PowerRank.TYPE_POWER

	triggerToggle(arg0.toggles[var0], true)
end

function var0.onInintItem(arg0, arg1)
	local var0 = RankCard.New(arg1, RankCard.TYPE_OTHER)

	onButton(arg0, var0._tf, function()
		if var0.rankVO.type == PowerRank.TYPE_MILITARY_RANK then
			arg0:emit(BillboardMediator.OPEN_RIVAL_INFO, var0.rankVO.id)
		end
	end)

	arg0.cards[arg1] = var0
end

function var0.onUpdateItem(arg0, arg1, arg2, arg3)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:onInintItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.displayRankVOs[arg1 + 1]

	var0:update(var1, arg3)
end

function var0.onReturnItem(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.cards[arg2]

	if var0 then
		var0:clear()
	end
end

function var0.filter(arg0, arg1, arg2)
	if arg1 ~= arg0.page then
		return
	end

	local var0 = arg0.page
	local var1

	if PowerRank.TYPE_PT == arg1 then
		assert(arg2)

		var1 = arg0.ptRanks[arg2]
	else
		var1 = arg0.rankVOs[var0]
	end

	arg0.displayRankVOs = {}

	for iter0, iter1 in ipairs(var1) do
		table.insert(arg0.displayRankVOs, iter1)
	end

	arg0.rankRect:SetTotalCount(#arg0.displayRankVOs)
	setActive(arg0.listEmptyTF, #arg0.displayRankVOs <= 0)

	local var2 = arg0.playerRankVOs[arg0.page]

	if PowerRank.TYPE_PT == arg1 then
		local var3 = arg0.playerPTRankVOMap[arg2]

		arg0.playerCard:update(var3, arg2)
	else
		arg0.playerCard:update(var2, arg2)
	end
end

function var0.switchPage(arg0, arg1, arg2)
	if arg0.page == arg1 and arg1 ~= PowerRank.TYPE_PT then
		return
	end

	if arg1 == PowerRank.TYPE_PT then
		arg0.curPagePTActID = arg2
	else
		arg0.curPagePTActID = nil
	end

	arg0.page = arg1

	local var0

	if arg0.page == PowerRank.TYPE_PT then
		assert(arg2)

		var0 = arg0.ptRanks[arg2]
	else
		var0 = arg0.rankVOs[arg1]
	end

	if not var0 then
		arg0.rankRect:SetTotalCount(0)
		arg0.playerCard:clear()
		arg0:emit(BillboardMediator.FETCH_RANKS, arg0.page, arg2)
	else
		arg0:filter(arg0.page, arg2)
	end

	setActive(arg0:findTF("tip", arg0.topPanel), not table.contains(BillboardProxy.NONTIMER, arg0.page))
	arg0:updateScoreTitle(arg0.page, arg2)
end

function var0.updateScoreTitle(arg0, arg1, arg2)
	local var0 = arg0:findTF("main/frame/title")
	local var1 = PowerRank:getTitleWord(arg1, arg2)

	for iter0 = 1, 4 do
		setText(var0:GetChild(iter0 - 1), var1[iter0])
	end
end

function var0.willExit(arg0)
	for iter0, iter1 in ipairs(arg0.cards) do
		iter1:dispose()
	end

	arg0.playerCard:dispose()

	if arg0.name then
		retPaintingPrefab(arg0.paintingTF, arg0.name)
	end
end

return var0

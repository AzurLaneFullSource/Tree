local var0_0 = class("BillboardScene", import("..base.BaseUI"))

var0_0.SINGLE_SHOW = {
	PowerRank.TYPE_EXTRA_CHAPTER,
	PowerRank.TYPE_ACT_BOSS_BATTLE,
	PowerRank.TYPE_BOSSRUSH
}

function var0_0.getUIName(arg0_1)
	return "BillboardUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"commonbg/bg_fengshan",
		"billboardframe",
		"weaponframes",
		"shiptype",
		"ui/iconcolorful"
	}

	local function var1_2(arg0_3)
		if noEmptyStr(arg0_3) and not table.contains(var0_2, arg0_3) then
			table.insert(var0_2, arg0_3)
		end
	end

	for iter0_2, iter1_2 in pairs(PowerRank.typeInfo) do
		local var2_2 = iter1_2.score_icon

		if var2_2 and var2_2[1] then
			var1_2(var2_2[1])
		end
	end

	local var3_2 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK)

	for iter2_2, iter3_2 in ipairs(var3_2) do
		if not iter3_2:isEnd() and tonumber(iter3_2:getConfig("config_data")) > 0 then
			local var4_2 = iter3_2:getConfig("config_id")
			local var5_2 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = var4_2
			}):getIcon()

			var1_2(var5_2)
		end
	end

	local var6_2 = checkExist(arg1_2, {
		"page"
	}) or PowerRank.TYPE_POWER
	local var7_2 = checkExist(arg1_2, {
		"act_id"
	}) or checkExist(PowerRank:getActivityByRankType(var6_2), {
		"id"
	})
	local var8_2 = getProxy(BillboardProxy):getRankList(var6_2, var7_2)

	for iter4_2, iter5_2 in ipairs(var8_2 or {}) do
		var1_2("emblem/" .. iter5_2.arenaRank)
		var1_2("emblem/n_" .. iter5_2.arenaRank)
	end

	if not var8_2 then
		for iter6_2 = 1, #pg.arena_data_rank.all do
			var1_2("emblem/" .. iter6_2)
			var1_2("emblem/n_" .. iter6_2)
		end
	end

	local var9_2 = getProxy(MilitaryExerciseProxy):RawGetSeasonInfo()

	if var9_2 then
		local var10_2 = SeasonInfo.getEmblem(var9_2.score, var9_2.rank)

		var1_2("emblem/" .. var10_2)
		var1_2("emblem/n_" .. var10_2)
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.updateRankList(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	if not arg0_4.rankVOs then
		arg0_4.rankVOs = {}
	end

	if not arg0_4.playerRankVOs then
		arg0_4.playerRankVOs = {}
	end

	arg0_4.rankVOs[arg1_4] = arg2_4

	if not arg0_4.ptRanks then
		arg0_4.ptRanks = {}
	end

	if arg1_4 == PowerRank.TYPE_PT then
		assert(arg4_4)

		arg0_4.ptRanks[arg4_4] = arg2_4
		arg0_4.playerPTRankVOMap = arg0_4.playerPTRankVOMap or {}
		arg0_4.playerPTRankVOMap[arg4_4] = arg3_4
	end

	arg0_4.playerRankVOs[arg1_4] = arg3_4
end

function var0_0.init(arg0_5)
	arg0_5.blurPanel = arg0_5._tf:Find("blur_panel")
	arg0_5.rankRect = arg0_5._tf:Find("main/frame/ranks"):GetComponent("LScrollRect")
	arg0_5.playerRankTF = arg0_5._tf:Find("main/frame/player_rank")

	setActive(arg0_5.playerRankTF, false)

	arg0_5.topPanel = arg0_5.blurPanel:Find("adapt/top")
	arg0_5.leftPanel = arg0_5.blurPanel:Find("adapt/left_length")
	arg0_5.mainPanel = arg0_5._tf:Find("main")
	arg0_5.extraChapterBg = arg0_5._tf:Find("extra_chapter_bg")
	arg0_5.toggleScrollRect = arg0_5.leftPanel:Find("frame/scroll_rect")
	arg0_5.toggleContainer = arg0_5.leftPanel:Find("frame/scroll_rect/tagRoot")
	arg0_5.listEmptyTF = arg0_5._tf:Find("main/frame/empty")

	setActive(arg0_5.listEmptyTF, false)

	arg0_5.listEmptyTxt = arg0_5.listEmptyTF:Find("Text")

	setText(arg0_5.listEmptyTxt, i18n("list_empty_tip_billboardui"))

	arg0_5.toggles = {
		arg0_5.leftPanel:Find("frame/scroll_rect/tagRoot/power"),
		arg0_5.leftPanel:Find("frame/scroll_rect/tagRoot/collection"),
		arg0_5.leftPanel:Find("frame/scroll_rect/tagRoot/pt"),
		arg0_5.leftPanel:Find("frame/scroll_rect/tagRoot/pledge"),
		arg0_5.leftPanel:Find("frame/scroll_rect/tagRoot/chanllenge"),
		arg0_5.leftPanel:Find("frame/scroll_rect/tagRoot/extra_chapter"),
		arg0_5.leftPanel:Find("frame/scroll_rect/tagRoot/boss_battle"),
		arg0_5.leftPanel:Find("frame/scroll_rect/tagRoot/guild"),
		arg0_5.leftPanel:Find("frame/scroll_rect/tagRoot/military"),
		arg0_5.leftPanel:Find("frame/scroll_rect/tagRoot/bossrush")
	}
	arg0_5.ptToggles = {}

	local var0_5 = _.filter(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_6)
		return not arg0_6:isEnd() and arg0_6:IsShowRank()
	end)

	if #var0_5 > 1 then
		local var1_5 = arg0_5.toggles[3]

		for iter0_5, iter1_5 in pairs(var0_5) do
			local var2_5 = cloneTplTo(var1_5, var1_5.parent)

			arg0_5.ptToggles[iter1_5.id] = var2_5
		end

		arg0_5.toggles[3] = nil
	end

	arg0_5:updateToggles()

	arg0_5.rankRect.decelerationRate = 0.07

	local var3_5 = arg0_5.contextData.page or PowerRank.TYPE_POWER

	if table.contains(var0_0.SINGLE_SHOW, var3_5) then
		setActive(arg0_5.leftPanel, false)
		setAnchoredPosition(arg0_5.mainPanel, Vector2(0, -35.5))

		local var4_5 = GetSpriteFromAtlas("commonbg/bg_fengshan", "")

		setImageSprite(arg0_5.extraChapterBg, var4_5)
	end

	setActive(arg0_5.extraChapterBg, var3_5 == PowerRank.TYPE_EXTRA_CHAPTER)
end

function var0_0.updateToggles(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.toggles) do
		local var0_7

		if PowerRank.typeInfo[iter0_7].act_type then
			var0_7 = PowerRank:getActivityByRankType(iter0_7)
		else
			var0_7 = (iter0_7 ~= PowerRank.TYPE_PLEDGE or false) and (iter0_7 == PowerRank.TYPE_GUILD_BATTLE and true or true)
		end

		setActive(iter1_7, var0_7)
	end

	for iter2_7, iter3_7 in pairs(arg0_7.ptToggles) do
		local var1_7 = getProxy(ActivityProxy):getActivityById(iter2_7)

		setActive(iter3_7, var1_7 and not var1_7:isEnd())
	end

	setActive(arg0_7.toggleContainer, true)
	Canvas.ForceUpdateCanvases()

	local var2_7 = arg0_7.toggleScrollRect.rect.height < arg0_7.toggleContainer.rect.height

	arg0_7.toggleContainer:GetComponent(typeof(ScrollRect)).enabled = var2_7
end

function var0_0.didEnter(arg0_8)
	onButton(arg0_8, arg0_8.topPanel:Find("back_btn"), function()
		arg0_8:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)

	for iter0_8, iter1_8 in pairs(arg0_8.toggles) do
		onToggle(arg0_8, iter1_8, function(arg0_10)
			if iter0_8 == PowerRank.TYPE_GUILD_BATTLE then
				setActive(arg0_8.mainPanel, not arg0_10)
				arg0_8:emit(BillboardMediator.ON_GUILD_RANK, arg0_10)

				return
			end

			if arg0_10 then
				local var0_10 = checkExist(PowerRank:getActivityByRankType(iter0_8), {
					"id"
				})

				arg0_8:switchPage(iter0_8, var0_10)
			end
		end, SFX_PANEL)
	end

	for iter2_8, iter3_8 in pairs(arg0_8.ptToggles) do
		onToggle(arg0_8, iter3_8, function(arg0_11)
			if arg0_11 then
				arg0_8:switchPage(PowerRank.TYPE_PT, iter2_8)
			end
		end, SFX_PANEL)
	end

	arg0_8.cards = {}

	function arg0_8.rankRect.onInitItem(arg0_12)
		arg0_8:onInintItem(arg0_12)
	end

	function arg0_8.rankRect.onUpdateItem(arg0_13, arg1_13)
		arg0_8:onUpdateItem(arg0_13, arg1_13, arg0_8.curPagePTActID)
	end

	function arg0_8.rankRect.onReturnItem(arg0_14, arg1_14)
		arg0_8:onReturnItem(arg0_14, arg1_14)
	end

	arg0_8.playerCard = RankCard.New(arg0_8.playerRankTF, RankCard.TYPE_SELF)

	local var0_8 = arg0_8.contextData.page or PowerRank.TYPE_POWER

	triggerToggle(arg0_8.toggles[var0_8], true)
end

function var0_0.onInintItem(arg0_15, arg1_15)
	local var0_15 = RankCard.New(arg1_15, RankCard.TYPE_OTHER)

	onButton(arg0_15, var0_15._tf, function()
		if var0_15.rankVO.type == PowerRank.TYPE_MILITARY_RANK then
			arg0_15:emit(BillboardMediator.OPEN_RIVAL_INFO, var0_15.rankVO.id)
		end
	end)

	arg0_15.cards[arg1_15] = var0_15
end

function var0_0.onUpdateItem(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = arg0_17.cards[arg2_17]

	if not var0_17 then
		arg0_17:onInintItem(arg2_17)

		var0_17 = arg0_17.cards[arg2_17]
	end

	local var1_17 = arg0_17.displayRankVOs[arg1_17 + 1]

	var0_17:update(var1_17, arg3_17)
end

function var0_0.onReturnItem(arg0_18, arg1_18, arg2_18)
	if arg0_18.exited then
		return
	end

	local var0_18 = arg0_18.cards[arg2_18]

	if var0_18 then
		var0_18:clear()
	end
end

function var0_0.filter(arg0_19, arg1_19, arg2_19)
	if arg1_19 ~= arg0_19.page then
		return
	end

	local var0_19 = arg0_19.page
	local var1_19

	if PowerRank.TYPE_PT == arg1_19 then
		assert(arg2_19)

		var1_19 = arg0_19.ptRanks[arg2_19]
	else
		var1_19 = arg0_19.rankVOs[var0_19]
	end

	local function var2_19()
		arg0_19.displayRankVOs = {}

		for iter0_20, iter1_20 in ipairs(var1_19) do
			table.insert(arg0_19.displayRankVOs, iter1_20)
		end

		arg0_19.rankRect:SetTotalCount(#arg0_19.displayRankVOs)
		setActive(arg0_19.listEmptyTF, #arg0_19.displayRankVOs <= 0)

		local var0_20 = arg0_19.playerRankVOs[arg0_19.page]

		if PowerRank.TYPE_PT == arg1_19 then
			local var1_20 = arg0_19.playerPTRankVOMap[arg2_19]

			arg0_19.playerCard:update(var1_20, arg2_19)
		else
			arg0_19.playerCard:update(var0_20, arg2_19)
		end
	end

	if var1_19 and #var1_19 > 0 then
		local var3_19 = {}

		for iter0_19, iter1_19 in ipairs(var1_19) do
			table.insert(var3_19, "squareicon/" .. iter1_19:getPainting())
		end

		SplitPackConst.DownloadByLuaArr(var3_19, function()
			var2_19()
		end)
	else
		var2_19()
	end
end

function var0_0.switchPage(arg0_22, arg1_22, arg2_22)
	if arg0_22.page == arg1_22 and arg1_22 ~= PowerRank.TYPE_PT then
		return
	end

	if arg1_22 == PowerRank.TYPE_PT then
		arg0_22.curPagePTActID = arg2_22
	else
		arg0_22.curPagePTActID = nil
	end

	arg0_22.page = arg1_22

	local var0_22

	if arg0_22.page == PowerRank.TYPE_PT then
		assert(arg2_22)

		var0_22 = arg0_22.ptRanks[arg2_22]
	else
		var0_22 = arg0_22.rankVOs[arg1_22]
	end

	if not var0_22 then
		arg0_22.rankRect:SetTotalCount(0)
		arg0_22.playerCard:clear()
		arg0_22:emit(BillboardMediator.FETCH_RANKS, arg0_22.page, arg2_22)
	else
		arg0_22:filter(arg0_22.page, arg2_22)
	end

	setActive(arg0_22.topPanel:Find("tip"), not table.contains(BillboardProxy.NONTIMER, arg0_22.page))
	arg0_22:updateScoreTitle(arg0_22.page, arg2_22)
end

function var0_0.updateScoreTitle(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23._tf:Find("main/frame/title")
	local var1_23 = PowerRank:getTitleWord(arg1_23, arg2_23)

	for iter0_23 = 1, 4 do
		setText(var0_23:GetChild(iter0_23 - 1), var1_23[iter0_23])
	end
end

function var0_0.willExit(arg0_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.cards) do
		iter1_24:dispose()
	end

	arg0_24.playerCard:dispose()

	if arg0_24.name then
		retPaintingPrefab(arg0_24.paintingTF, arg0_24.name)
	end
end

return var0_0

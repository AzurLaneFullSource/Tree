local var0_0 = class("IslandSeasonPage", import("...base.IslandBasePage"))

var0_0.PAGE_PT = "pt"
var0_0.PAGE_TASK = "task"
var0_0.PAGE_SHOP = "shop"
var0_0.PAGE_RANK = "rank"
var0_0.PAGE_REVIEW = "review"

function var0_0.getUIName(arg0_1)
	return "IslandSeasonUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.blurTF = arg0_2._tf:Find("blur")

	setText(arg0_2.blurTF:Find("top/title/Text"), i18n("island_season_title"))

	arg0_2.ptTitleTF = arg0_2.blurTF:Find("pt_title")
	arg0_2.otherTitleTF = arg0_2.blurTF:Find("other_title")

	local var0_2 = arg0_2.blurTF:Find("pages")

	arg0_2.pages = {
		[var0_0.PAGE_PT] = IslandSeasonPtPanel.New(var0_2, arg0_2.event, arg0_2.contextData),
		[var0_0.PAGE_TASK] = IslandSeasonTaskPanel.New(var0_2, arg0_2.event, arg0_2.contextData),
		[var0_0.PAGE_SHOP] = IslandSeasonShopPanel.New(var0_2, arg0_2.event, setmetatable({
			openBuyLayer = function(arg0_3, arg1_3)
				arg0_2:OpenPage(IslandShopItemLayer, arg0_3, arg1_3)
			end
		}, {
			__index = arg0_2.contextData
		})),
		[var0_0.PAGE_RANK] = IslandSeasonRankPanel.New(var0_2, arg0_2.event, arg0_2.contextData)
	}

	local var1_2 = IslandSeasonAgency.GetCurrentSeason() == 1

	if not var1_2 then
		arg0_2.pages[var0_0.PAGE_REVIEW] = IslandSeasonReviewPanel.New(var0_2, arg0_2.event, arg0_2.contextData)
	end

	arg0_2.togglesTF = arg0_2.blurTF:Find("toggles/content")

	setActive(arg0_2.togglesTF:Find(var0_0.PAGE_REVIEW), not var1_2)

	local function var2_2(arg0_4, arg1_4)
		setText(arg0_4:Find("sel/Text"), arg1_4)
		setText(arg0_4:Find("sel/Text/shandw"), arg1_4)
		setText(arg0_4:Find("unsel/Text"), arg1_4)
		setText(arg0_4:Find("unsel/Text/shandw"), arg1_4)
	end

	var2_2(arg0_2.togglesTF:Find("pt"), i18n("island_season_pt"))
	var2_2(arg0_2.togglesTF:Find("task"), i18n("island_season_task"))
	var2_2(arg0_2.togglesTF:Find("shop"), i18n("island_season_shop"))
	var2_2(arg0_2.togglesTF:Find("rank"), i18n("island_season_charts"))
	var2_2(arg0_2.togglesTF:Find("review"), i18n("island_season_review"))
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5.blurTF:Find("top/back"), function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.blurTF:Find("top/help"), function()
		arg0_5:ShowMsgBox({
			type = IslandMsgBox.TYPE_WHITOUT_BTN,
			content = i18n("island_season_help")
		})
	end, SFX_PANEL)
	eachChild(arg0_5.togglesTF, function(arg0_8)
		onToggle(arg0_5, arg0_8, function(arg0_9)
			if arg0_9 then
				arg0_5.curPage = arg0_8.name

				arg0_5:SwitchPage()
			end
		end, SFX_PANEL)
	end)
end

function var0_0.AddListeners(arg0_10)
	arg0_10:AddListener(IslandSeasonAgency.ADD_PT, arg0_10.FlushPtPage)
	arg0_10:AddListener(GAME.ISLAND_GET_SEASON_PT_AWARD_DONE, arg0_10.FlushPtPage)
	arg0_10:AddListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_10.FlushTaskPage)
	arg0_10:AddListener(GAME.ISLAND_SUBMIT_TASK_ONE_STEP_DONE, arg0_10.FlushTaskPage)
	arg0_10:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_10.FlushShopPage)
	arg0_10:AddListener(GAME.ISLAND_GET_SEASON_RANK_DONE, arg0_10.OnGetRankData)
end

function var0_0.RemoveListeners(arg0_11)
	arg0_11:RemoveListener(IslandSeasonAgency.ADD_PT, arg0_11.FlushPtPage)
	arg0_11:RemoveListener(GAME.ISLAND_GET_SEASON_PT_AWARD_DONE, arg0_11.FlushPtPage)
	arg0_11:RemoveListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_11.FlushTaskPage)
	arg0_11:RemoveListener(GAME.ISLAND_SUBMIT_TASK_ONE_STEP_DONE, arg0_11.FlushTaskPage)
	arg0_11:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_11.FlushShopPage)
	arg0_11:RemoveListener(GAME.ISLAND_GET_SEASON_RANK_DONE, arg0_11.OnGetRankData)
end

function var0_0.OnShow(arg0_12)
	arg0_12.contextData.season = getProxy(IslandProxy):GetIsland():GetSeasonAgency():GetSeason()

	triggerToggle(arg0_12.togglesTF:Find(var0_0.PAGE_PT), true)
end

function var0_0.SwitchPage(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.pages) do
		if iter0_13 == arg0_13.curPage then
			iter1_13:ExecuteAction("Show")
		else
			iter1_13:ExecuteAction("Hide")
		end

		local var0_13 = arg0_13.curPage == var0_0.PAGE_PT

		SetCompomentEnabled(arg0_13.blurTF, "Image", not var0_13)
		setActive(arg0_13.ptTitleTF, var0_13)
		setActive(arg0_13.otherTitleTF, not var0_13)

		if var0_13 then
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13.blurTF, arg0_13._tf)
		else
			pg.UIMgr.GetInstance():OverlayPanelPB(arg0_13.blurTF, {
				pbList = {
					arg0_13.blurTF
				},
				groupName = LayerWeightConst.GROUP_ISLAND
			})
		end
	end
end

function var0_0.FlushPtPage(arg0_14)
	arg0_14.contextData.season = getProxy(IslandProxy):GetIsland():GetSeasonAgency():GetSeason()

	arg0_14.pages[var0_0.PAGE_PT]:ExecuteAction("Flush")
end

function var0_0.FlushTaskPage(arg0_15)
	arg0_15.pages[var0_0.PAGE_TASK]:ExecuteAction("Flush")
end

function var0_0.FlushShopPage(arg0_16, arg1_16)
	arg0_16.pages[var0_0.PAGE_SHOP]:ExecuteAction("Flush")

	if arg1_16.operation == IslandConst.SHOP_BUY_COMMODITY then
		arg0_16:OpenPage(IslandShopBuySuccessLayer, arg1_16.awards, arg1_16.ptAward)
	end
end

function var0_0.OnGetRankData(arg0_17, arg1_17)
	arg0_17.pages[var0_0.PAGE_RANK]:ExecuteAction("UpdateRankVOs", arg1_17.seasonId, arg1_17.list, arg1_17.playerInfo)
	arg0_17.pages[var0_0.PAGE_RANK]:ExecuteAction("UpdataRankView")

	if arg0_17.pages[var0_0.PAGE_REVIEW] then
		arg0_17.pages[var0_0.PAGE_REVIEW]:ExecuteAction("UpdateRankVOs", arg1_17.seasonId, arg1_17.list, arg1_17.playerInfo)
		arg0_17.pages[var0_0.PAGE_REVIEW]:ExecuteAction("UpdataIcon")
	end
end

function var0_0.OnHide(arg0_18)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_18.blurTF, arg0_18._tf)
	arg0_18.pages[var0_0.PAGE_PT]:OnHide()
end

function var0_0.OnDisable(arg0_19)
	arg0_19:OnHide()
end

function var0_0.OnDestroy(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.pages) do
		if iter1_20 then
			iter1_20:Destroy()

			iter1_20 = nil
		end
	end
end

return var0_0

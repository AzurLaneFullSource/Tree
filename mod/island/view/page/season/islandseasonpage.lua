local var0_0 = class("IslandSeasonPage", import("...base.IslandBasePage"))

var0_0.PAGE_ACTIVITY = "activity"
var0_0.PAGE_PT = "pt"
var0_0.PAGE_TASK = "task"
var0_0.PAGE_SHOP = "shop"
var0_0.PAGE_RANK = "rank"
var0_0.PAGE_REVIEW = "review"

function var0_0.getUIName(arg0_1)
	return "IslandSeasonUI"
end

function var0_0.Preload(arg0_2, arg1_2)
	pg.PoolMgr.GetInstance():PreloadUI("IslandSeasonActivityPanel", arg1_2)
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.blurTF = arg0_3._tf:Find("blur")

	setText(arg0_3.blurTF:Find("top/title/Text"), i18n("island_season_title"))

	arg0_3.ptTitleTF = arg0_3.blurTF:Find("pt_title")
	arg0_3.otherTitleTF = arg0_3.blurTF:Find("other_title")

	local var0_3 = arg0_3.blurTF:Find("pages")

	arg0_3.pages = {
		[var0_0.PAGE_ACTIVITY] = IslandSeasonActivityPanel.New(var0_3, arg0_3.event, arg0_3.contextData),
		[var0_0.PAGE_PT] = IslandSeasonPtPanel.New(var0_3, arg0_3.event, arg0_3.contextData),
		[var0_0.PAGE_TASK] = IslandSeasonTaskPanel.New(var0_3, arg0_3.event, arg0_3.contextData),
		[var0_0.PAGE_SHOP] = IslandSeasonShopPanel.New(var0_3, arg0_3.event, setmetatable({
			openBuyLayer = function(arg0_4, arg1_4)
				arg0_3:OpenPage(IslandShopItemLayer, arg0_4, arg1_4)
			end
		}, {
			__index = arg0_3.contextData
		})),
		[var0_0.PAGE_RANK] = IslandSeasonRankPanel.New(var0_3, arg0_3.event, arg0_3.contextData)
	}

	for iter0_3, iter1_3 in pairs(arg0_3.pages) do
		iter1_3:RegisterView(arg0_3.viewComponent)
	end

	local var1_3 = IslandSeasonAgency.GetCurrentSeason() == 1

	if not var1_3 then
		arg0_3.pages[var0_0.PAGE_REVIEW] = IslandSeasonReviewPanel.New(var0_3, arg0_3.event, arg0_3.contextData)
	end

	arg0_3.togglesTF = arg0_3.blurTF:Find("toggles/content")

	setActive(arg0_3.togglesTF:Find(var0_0.PAGE_REVIEW), not var1_3)

	local function var2_3(arg0_5, arg1_5)
		setText(arg0_5:Find("sel/Text"), arg1_5)
		setText(arg0_5:Find("sel/Text/shandw"), arg1_5)
		setText(arg0_5:Find("unsel/Text"), arg1_5)
		setText(arg0_5:Find("unsel/Text/shandw"), arg1_5)
	end

	var2_3(arg0_3.togglesTF:Find("activity"), i18n("island_season_activity"))
	var2_3(arg0_3.togglesTF:Find("pt"), i18n("island_season_pt"))
	var2_3(arg0_3.togglesTF:Find("task"), i18n("island_season_task"))
	var2_3(arg0_3.togglesTF:Find("shop"), i18n("island_season_shop"))
	var2_3(arg0_3.togglesTF:Find("rank"), i18n("island_season_charts"))
	var2_3(arg0_3.togglesTF:Find("review"), i18n("island_season_review"))
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6.blurTF:Find("top/back"), function()
		arg0_6:Hide()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.blurTF:Find("top/help"), function()
		arg0_6:ShowMsgBox({
			type = IslandMsgBox.TYPE_WHITOUT_BTN,
			content = i18n("island_season_help")
		})
	end, SFX_PANEL)
	eachChild(arg0_6.togglesTF, function(arg0_9)
		onToggle(arg0_6, arg0_9, function(arg0_10)
			if arg0_10 then
				arg0_6.curPage = arg0_9.name

				arg0_6:SwitchPage()
			end
		end, SFX_PANEL)
	end)
end

function var0_0.AddListeners(arg0_11)
	arg0_11:AddListener(ActivityProxy.ACTIVITY_UPDATED, arg0_11.FlushActivityPage)
	arg0_11:AddListener(IslandSeasonAgency.ADD_PT, arg0_11.FlushPtPage)
	arg0_11:AddListener(GAME.ISLAND_GET_SEASON_PT_AWARD_DONE, arg0_11.FlushPtPage)
	arg0_11:AddListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_11.FlushTaskPage)
	arg0_11:AddListener(GAME.ISLAND_SUBMIT_TASK_ONE_STEP_DONE, arg0_11.FlushTaskPage)
	arg0_11:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_11.FlushShopPage)
	arg0_11:AddListener(GAME.ISLAND_GET_SEASON_RANK_DONE, arg0_11.OnGetRankData)
end

function var0_0.RemoveListeners(arg0_12)
	arg0_12:RemoveListener(ActivityProxy.ACTIVITY_UPDATED, arg0_12.FlushActivityPage)
	arg0_12:RemoveListener(IslandSeasonAgency.ADD_PT, arg0_12.FlushPtPage)
	arg0_12:RemoveListener(GAME.ISLAND_GET_SEASON_PT_AWARD_DONE, arg0_12.FlushPtPage)
	arg0_12:RemoveListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_12.FlushTaskPage)
	arg0_12:RemoveListener(GAME.ISLAND_SUBMIT_TASK_ONE_STEP_DONE, arg0_12.FlushTaskPage)
	arg0_12:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_12.FlushShopPage)
	arg0_12:RemoveListener(GAME.ISLAND_GET_SEASON_RANK_DONE, arg0_12.OnGetRankData)
end

function var0_0.OnShow(arg0_13)
	arg0_13.contextData.season = getProxy(IslandProxy):GetIsland():GetSeasonAgency():GetSeason()

	triggerToggle(arg0_13.togglesTF:Find(var0_0.PAGE_ACTIVITY), true)
end

local var1_0 = {
	[var0_0.PAGE_ACTIVITY] = 1,
	[var0_0.PAGE_PT] = 2,
	[var0_0.PAGE_TASK] = 3,
	[var0_0.PAGE_SHOP] = 3,
	[var0_0.PAGE_RANK] = 3
}

function var0_0.SwitchPage(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.pages) do
		if iter0_14 == arg0_14.curPage then
			iter1_14:ExecuteAction("Show")
		else
			iter1_14:ExecuteAction("Hide")
		end

		local var0_14 = var1_0[arg0_14.curPage]

		SetCompomentEnabled(arg0_14.blurTF, "Image", var0_14 == 1 or var0_14 == 3)
		setActive(arg0_14.ptTitleTF, var0_14 == 2)
		setActive(arg0_14.otherTitleTF, var0_14 == 3)

		if var0_14 == 1 or var0_14 == 3 then
			arg0_14:OverlayPanel(arg0_14.blurTF, {
				pbList = {
					arg0_14.blurTF
				}
			})
		else
			arg0_14:UnOverlayPanel(arg0_14.blurTF, arg0_14._tf)
		end
	end
end

function var0_0.FlushActivityPage(arg0_15, arg1_15)
	arg0_15.pages[var0_0.PAGE_ACTIVITY]:ExecuteAction("updateActivity", arg1_15)
end

function var0_0.FlushPtPage(arg0_16)
	arg0_16.contextData.season = getProxy(IslandProxy):GetIsland():GetSeasonAgency():GetSeason()

	arg0_16.pages[var0_0.PAGE_PT]:ExecuteAction("Flush")
end

function var0_0.FlushTaskPage(arg0_17)
	arg0_17.pages[var0_0.PAGE_TASK]:ExecuteAction("Flush")
end

function var0_0.FlushShopPage(arg0_18, arg1_18)
	arg0_18.pages[var0_0.PAGE_SHOP]:ExecuteAction("Flush")

	if arg1_18.operation == IslandConst.SHOP_BUY_COMMODITY then
		arg0_18:OpenPage(IslandShopBuySuccessLayer, arg1_18.awards)
	end
end

function var0_0.OnGetRankData(arg0_19, arg1_19)
	arg0_19.pages[var0_0.PAGE_RANK]:ExecuteAction("UpdateRankVOs", arg1_19.seasonId, arg1_19.list, arg1_19.playerInfo)
	arg0_19.pages[var0_0.PAGE_RANK]:ExecuteAction("UpdataRankView")

	if arg0_19.pages[var0_0.PAGE_REVIEW] then
		arg0_19.pages[var0_0.PAGE_REVIEW]:ExecuteAction("UpdateRankVOs", arg1_19.seasonId, arg1_19.list, arg1_19.playerInfo)
		arg0_19.pages[var0_0.PAGE_REVIEW]:ExecuteAction("UpdataIcon")
	end
end

function var0_0.OnHide(arg0_20)
	arg0_20:UnOverlayPanel(arg0_20.blurTF, arg0_20._tf)
	arg0_20.pages[var0_0.PAGE_PT]:OnHide()
	arg0_20.pages[var0_0.PAGE_ACTIVITY]:Destroy()
	arg0_20.pages[var0_0.PAGE_ACTIVITY]:Reset()
end

function var0_0.OnDisable(arg0_21)
	arg0_21:OnHide()
end

function var0_0.OnDestroy(arg0_22)
	for iter0_22, iter1_22 in pairs(arg0_22.pages) do
		if iter1_22 then
			iter1_22:Destroy()

			iter1_22 = nil
		end
	end
end

return var0_0

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
		[var0_0.PAGE_PT] = IslandSeasonPtPanel.New(var0_3, arg0_3.event, setmetatable({
			ShowMsgBox = function(arg0_4, arg1_4)
				arg0_3:ShowMsgBox(arg1_4)
			end
		}, {
			__index = arg0_3.contextData
		})),
		[var0_0.PAGE_TASK] = IslandSeasonTaskPanel.New(var0_3, arg0_3.event, setmetatable({
			ShowMsgBox = function(arg0_5, arg1_5)
				arg0_3:ShowMsgBox(arg1_5)
			end
		}, {
			__index = arg0_3.contextData
		})),
		[var0_0.PAGE_SHOP] = IslandSeasonShopPanel.New(var0_3, arg0_3.event, setmetatable({
			openBuyLayer = function(arg0_6, arg1_6)
				arg0_3:OpenPage(IslandShopItemLayer, arg0_6, arg1_6)
			end
		}, {
			__index = arg0_3.contextData
		})),
		[var0_0.PAGE_RANK] = IslandSeasonRankPanel.New(var0_3, arg0_3.event, setmetatable({
			ShowMsgBox = function(arg0_7, arg1_7)
				arg0_3:ShowMsgBox(arg1_7)
			end
		}, {
			__index = arg0_3.contextData
		}))
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

	local function var2_3(arg0_8, arg1_8)
		setText(arg0_8:Find("sel/Text"), arg1_8)
		setText(arg0_8:Find("sel/Text/shandw"), arg1_8)
		setText(arg0_8:Find("unsel/Text"), arg1_8)
		setText(arg0_8:Find("unsel/Text/shandw"), arg1_8)
	end

	var2_3(arg0_3.togglesTF:Find("activity"), i18n("island_season_activity"))
	var2_3(arg0_3.togglesTF:Find("pt"), i18n("island_season_pt"))
	var2_3(arg0_3.togglesTF:Find("task"), i18n("island_season_task"))
	var2_3(arg0_3.togglesTF:Find("shop"), i18n("island_season_shop"))
	var2_3(arg0_3.togglesTF:Find("rank"), i18n("island_season_charts"))
	var2_3(arg0_3.togglesTF:Find("review"), i18n("island_season_review"))

	arg0_3.playRoomPop = PlayRoomPop.New(arg0_3.blurTF:Find("playRoomPop"), arg0_3)

	arg0_3.playRoomPop:didEnter()
end

function var0_0.OnInit(arg0_9)
	onButton(arg0_9, arg0_9.blurTF:Find("top/back"), function()
		arg0_9:emit(IslandMediator.PLAY_ROOM_MATCH_STOP)
		arg0_9:Hide()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.blurTF:Find("top/help"), function()
		arg0_9:ShowMsgBox({
			type = IslandMsgBox.TYPE_WHITOUT_BTN,
			content = i18n("island_season_help")
		})
	end, SFX_PANEL)
	eachChild(arg0_9.togglesTF, function(arg0_12)
		onToggle(arg0_9, arg0_12, function(arg0_13)
			if arg0_13 then
				arg0_9.curPage = arg0_12.name

				arg0_9:SwitchPage()
			end
		end, SFX_PANEL)
	end)
end

function var0_0.AddListeners(arg0_14)
	arg0_14:AddListener(ActivityProxy.ACTIVITY_UPDATED, arg0_14.FlushActivityPage)
	arg0_14:AddListener(IslandSeasonAgency.ADD_PT, arg0_14.FlushPtPage)
	arg0_14:AddListener(GAME.ISLAND_GET_SEASON_PT_AWARD_DONE, arg0_14.FlushPtPage)
	arg0_14:AddListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_14.OnSubmitTaskDone)
	arg0_14:AddListener(GAME.ISLAND_SUBMIT_TASK_ONE_STEP_DONE, arg0_14.OnSubmitTaskDone)
	arg0_14:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_14.FlushShopPage)
	arg0_14:AddListener(GAME.ISLAND_GET_SEASON_RANK_DONE, arg0_14.OnGetRankData)
end

function var0_0.RemoveListeners(arg0_15)
	arg0_15:RemoveListener(ActivityProxy.ACTIVITY_UPDATED, arg0_15.FlushActivityPage)
	arg0_15:RemoveListener(IslandSeasonAgency.ADD_PT, arg0_15.FlushPtPage)
	arg0_15:RemoveListener(GAME.ISLAND_GET_SEASON_PT_AWARD_DONE, arg0_15.FlushPtPage)
	arg0_15:RemoveListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_15.OnSubmitTaskDone)
	arg0_15:RemoveListener(GAME.ISLAND_SUBMIT_TASK_ONE_STEP_DONE, arg0_15.OnSubmitTaskDone)
	arg0_15:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_15.FlushShopPage)
	arg0_15:RemoveListener(GAME.ISLAND_GET_SEASON_RANK_DONE, arg0_15.OnGetRankData)
end

function var0_0.OnShow(arg0_16, arg1_16)
	arg0_16.contextData.season = getProxy(IslandProxy):GetIsland():GetSeasonAgency():GetSeason()

	local var0_16 = arg0_16.contextData

	if arg1_16 and arg1_16.target_act_id then
		triggerToggle(arg0_16.togglesTF:Find(var0_0.PAGE_ACTIVITY), true)
		arg0_16.pages[var0_0.PAGE_ACTIVITY]:ExecuteAction("verifyTabs", arg1_16.target_act_id)
	else
		triggerToggle(arg0_16.togglesTF:Find(var0_0.PAGE_ACTIVITY), true)
	end

	arg0_16.playRoomPop:Show(true)
end

local var1_0 = {
	[var0_0.PAGE_ACTIVITY] = 1,
	[var0_0.PAGE_PT] = 2,
	[var0_0.PAGE_TASK] = 3,
	[var0_0.PAGE_SHOP] = 3,
	[var0_0.PAGE_RANK] = 3,
	[var0_0.PAGE_REVIEW] = 4
}

function var0_0.SwitchPage(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.pages) do
		if iter0_17 == arg0_17.curPage then
			iter1_17:ExecuteAction("Show")
		else
			iter1_17:ExecuteAction("Hide")
		end

		local var0_17 = var1_0[arg0_17.curPage]

		SetCompomentEnabled(arg0_17.blurTF, "Image", var0_17 == 1 or var0_17 == 3 or var0_17 == 4)
		setActive(arg0_17.ptTitleTF, var0_17 == 2)
		setActive(arg0_17.otherTitleTF, var0_17 == 3)

		if var0_17 == 1 or var0_17 == 3 or var0_17 == 4 then
			arg0_17:OverlayPanel(arg0_17.blurTF, {
				pbList = {
					arg0_17.blurTF
				}
			})
		else
			arg0_17:UnOverlayPanel(arg0_17.blurTF, arg0_17._tf)
		end
	end
end

function var0_0.FlushActivityPage(arg0_18, arg1_18)
	arg0_18.pages[var0_0.PAGE_ACTIVITY]:ExecuteAction("updateActivity", arg1_18)
end

function var0_0.FlushPtPage(arg0_19)
	arg0_19.contextData.season = getProxy(IslandProxy):GetIsland():GetSeasonAgency():GetSeason()

	arg0_19.pages[var0_0.PAGE_PT]:ExecuteAction("Flush")
end

function var0_0.OnSubmitTaskDone(arg0_20)
	arg0_20:FlushTaskPage()
	arg0_20.pages[var0_0.PAGE_ACTIVITY]:ExecuteAction("flushTabs")
end

function var0_0.FlushTaskPage(arg0_21)
	arg0_21.pages[var0_0.PAGE_TASK]:ExecuteAction("Flush")
end

function var0_0.FlushShopPage(arg0_22, arg1_22)
	arg0_22.pages[var0_0.PAGE_SHOP]:ExecuteAction("Flush")

	if arg1_22.operation == IslandConst.SHOP_BUY_COMMODITY then
		arg0_22:OpenPage(IslandShopBuySuccessLayer, arg1_22.awards)
	end
end

function var0_0.OnGetRankData(arg0_23, arg1_23)
	arg0_23.pages[var0_0.PAGE_RANK]:ExecuteAction("UpdateRankVOs", arg1_23.seasonId, arg1_23.list, arg1_23.playerInfo)
	arg0_23.pages[var0_0.PAGE_RANK]:ExecuteAction("UpdataRankView")

	if arg0_23.pages[var0_0.PAGE_REVIEW] then
		arg0_23.pages[var0_0.PAGE_REVIEW]:ExecuteAction("UpdateRankVOs", arg1_23.seasonId, arg1_23.list, arg1_23.playerInfo)
		arg0_23.pages[var0_0.PAGE_REVIEW]:ExecuteAction("UpdataIcon")
	end
end

function var0_0.OnHide(arg0_24)
	arg0_24.playRoomPop:Show(false)
	arg0_24:UnOverlayPanel(arg0_24.blurTF, arg0_24._tf)
	arg0_24.pages[var0_0.PAGE_PT]:OnHide()
	arg0_24.pages[var0_0.PAGE_ACTIVITY]:OnHide()

	if arg0_24.pages[var0_0.PAGE_REVIEW] then
		arg0_24.pages[var0_0.PAGE_REVIEW]:Hide()
	end
end

function var0_0.OnDisable(arg0_25)
	arg0_25:OnHide()
end

function var0_0.OnDestroy(arg0_26)
	arg0_26:OnHide()
	arg0_26.playRoomPop:willExit()

	arg0_26.playRoomPop = nil

	for iter0_26, iter1_26 in pairs(arg0_26.pages) do
		if iter1_26 then
			iter1_26:Destroy()

			iter1_26 = nil
		end
	end
end

function var0_0.OnEnable(arg0_27)
	arg0_27:OnShow()
end

return var0_0

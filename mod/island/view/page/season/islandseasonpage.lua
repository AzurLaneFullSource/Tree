local var0_0 = class("IslandSeasonPage", import("...base.IslandBasePage"))

var0_0.CLOSE = "IslandSeasonPage:CLOSE"
var0_0.UPDATE_REDDOT = "IslandSeasonPage:UPDATE_REDDOT"
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

function var0_0.Close(arg0_9, arg1_9)
	arg0_9:emit(IslandMediator.PLAY_ROOM_MATCH_STOP)
	arg0_9:Hide(arg1_9)
end

function var0_0.OnInit(arg0_10)
	local var0_10 = arg0_10.blurTF:Find("top/back")

	onButton(arg0_10, var0_10, function()
		arg0_10:Close(true)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.blurTF:Find("top/help"), function()
		arg0_10:ShowMsgBox({
			type = IslandMsgBox.TYPE_WHITOUT_BTN,
			content = i18n("island_season_help")
		})
	end, SFX_PANEL)
	eachChild(arg0_10.togglesTF, function(arg0_13)
		onToggle(arg0_10, arg0_13, function(arg0_14)
			if arg0_14 then
				arg0_10.curPage = arg0_13.name

				arg0_10:SwitchPage()
			end
		end, SFX_PANEL)
	end)
	arg0_10:bind(var0_0.CLOSE, function()
		arg0_10:Close(false)
	end)
	arg0_10:bind(var0_0.UPDATE_REDDOT, function(arg0_16, arg1_16)
		arg0_10:UpdateRedDot(arg1_16)
	end)
	arg0_10:UpdateRedDot()
end

function var0_0.UpdateRedDot(arg0_17, arg1_17)
	eachChild(arg0_17.togglesTF, function(arg0_18)
		if not arg1_17 or arg0_18.name == arg1_17 then
			setActive(arg0_18:Find("red"), IslandSeasonRedDotHelper.TipTag(arg0_18.name))
		end
	end)
end

function var0_0.AddListeners(arg0_19)
	arg0_19:AddListener(ActivityProxy.ACTIVITY_UPDATED, arg0_19.FlushActivityPage)
	arg0_19:AddListener(IslandSeasonAgency.ADD_PT, arg0_19.FlushPtPage)
	arg0_19:AddListener(GAME.ISLAND_GET_SEASON_PT_AWARD_DONE, arg0_19.FlushPtPage)
	arg0_19:AddListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_19.OnSubmitTaskDone)
	arg0_19:AddListener(GAME.ISLAND_SUBMIT_TASK_ONE_STEP_DONE, arg0_19.OnSubmitTaskDone)
	arg0_19:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_19.FlushShopPage)
	arg0_19:AddListener(GAME.ISLAND_GET_SEASON_RANK_DONE, arg0_19.OnGetRankData)
	arg0_19:AddListener(IslandTaskAgency.TASK_ADDED, arg0_19.OnTaskAdded)
	arg0_19:AddListener(IslandTaskAgency.TASK_UPDATED, arg0_19.OnTaskUpdate)
	arg0_19:AddListener(IslandTaskAgency.TASK_REMOVED, arg0_19.OnTaskRemove)
	arg0_19:AddListener(IslandTaskAgency.TASK_FINISH, arg0_19.OnTaskFinish)
end

function var0_0.RemoveListeners(arg0_20)
	arg0_20:RemoveListener(ActivityProxy.ACTIVITY_UPDATED, arg0_20.FlushActivityPage)
	arg0_20:RemoveListener(IslandSeasonAgency.ADD_PT, arg0_20.FlushPtPage)
	arg0_20:RemoveListener(GAME.ISLAND_GET_SEASON_PT_AWARD_DONE, arg0_20.FlushPtPage)
	arg0_20:RemoveListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_20.OnSubmitTaskDone)
	arg0_20:RemoveListener(GAME.ISLAND_SUBMIT_TASK_ONE_STEP_DONE, arg0_20.OnSubmitTaskDone)
	arg0_20:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_20.FlushShopPage)
	arg0_20:RemoveListener(GAME.ISLAND_GET_SEASON_RANK_DONE, arg0_20.OnGetRankData)
	arg0_20:RemoveListener(IslandTaskAgency.TASK_ADDED, arg0_20.OnTaskAdded)
	arg0_20:RemoveListener(IslandTaskAgency.TASK_UPDATED, arg0_20.OnTaskUpdate)
	arg0_20:RemoveListener(IslandTaskAgency.TASK_REMOVED, arg0_20.OnTaskRemove)
	arg0_20:RemoveListener(IslandTaskAgency.TASK_FINISH, arg0_20.OnTaskFinish)
end

function var0_0.OnShow(arg0_21, arg1_21)
	arg0_21.contextData.season = getProxy(IslandProxy):GetIsland():GetSeasonAgency():GetSeason()

	local var0_21 = arg0_21.contextData

	if arg1_21 and arg1_21.target_act_id then
		triggerToggle(arg0_21.togglesTF:Find(var0_0.PAGE_ACTIVITY), true)
		arg0_21.pages[var0_0.PAGE_ACTIVITY]:ExecuteAction("verifyTabs", arg1_21.target_act_id)
	else
		triggerToggle(arg0_21.togglesTF:Find(var0_0.PAGE_ACTIVITY), true)
	end

	arg0_21.playRoomPop:Show(true)
end

local var1_0 = {
	[var0_0.PAGE_ACTIVITY] = 1,
	[var0_0.PAGE_PT] = 2,
	[var0_0.PAGE_TASK] = 3,
	[var0_0.PAGE_SHOP] = 3,
	[var0_0.PAGE_RANK] = 3,
	[var0_0.PAGE_REVIEW] = 4
}

function var0_0.SwitchPage(arg0_22)
	for iter0_22, iter1_22 in pairs(arg0_22.pages) do
		if iter0_22 == arg0_22.curPage then
			iter1_22:ExecuteAction("Show")
		else
			iter1_22:ExecuteAction("Hide")
		end

		local var0_22 = var1_0[arg0_22.curPage]

		SetCompomentEnabled(arg0_22.blurTF, "Image", var0_22 == 1 or var0_22 == 3 or var0_22 == 4)
		setActive(arg0_22.ptTitleTF, var0_22 == 2)
		setActive(arg0_22.otherTitleTF, var0_22 == 3)

		if var0_22 == 1 or var0_22 == 3 or var0_22 == 4 then
			arg0_22:OverlayPanel(arg0_22.blurTF, {
				pbList = {
					arg0_22.blurTF
				}
			})
		else
			arg0_22:UnOverlayPanel(arg0_22.blurTF, arg0_22._tf)
		end
	end
end

function var0_0.UpdateTaskAct(arg0_23, arg1_23)
	arg0_23.pages[var0_0.PAGE_ACTIVITY]:ExecuteAction("OnTaskUpdate", arg1_23)
end

function var0_0.OnTaskAdded(arg0_24, arg1_24)
	if not arg1_24 then
		return
	end

	arg0_24:UpdateTaskAct(arg1_24.id)
end

function var0_0.OnTaskUpdate(arg0_25, arg1_25)
	if not arg1_25 then
		return
	end

	arg0_25:UpdateTaskAct(arg1_25.id)
end

function var0_0.OnTaskRemove(arg0_26, arg1_26)
	if not arg1_26 then
		return
	end

	arg0_26:UpdateTaskAct(arg1_26.id)
end

function var0_0.OnTaskFinish(arg0_27, arg1_27)
	if not arg1_27 then
		return
	end

	arg0_27:UpdateTaskAct(arg1_27)
end

function var0_0.FlushActivityPage(arg0_28, arg1_28)
	arg0_28.pages[var0_0.PAGE_ACTIVITY]:ExecuteAction("updateActivity", arg1_28)
end

function var0_0.FlushPtPage(arg0_29)
	arg0_29.contextData.season = getProxy(IslandProxy):GetIsland():GetSeasonAgency():GetSeason()

	arg0_29.pages[var0_0.PAGE_PT]:ExecuteAction("Flush")
	arg0_29:UpdateRedDot(var0_0.PAGE_PT)
end

function var0_0.OnSubmitTaskDone(arg0_30)
	arg0_30:FlushTaskPage()
	arg0_30.pages[var0_0.PAGE_ACTIVITY]:ExecuteAction("flushTabs")
	arg0_30:UpdateRedDot(var0_0.PAGE_TASK)
end

function var0_0.FlushTaskPage(arg0_31)
	arg0_31.pages[var0_0.PAGE_TASK]:ExecuteAction("Flush")
end

function var0_0.FlushShopPage(arg0_32, arg1_32)
	arg0_32.pages[var0_0.PAGE_SHOP]:ExecuteAction("Flush")

	if arg1_32.operation == IslandConst.SHOP_BUY_COMMODITY then
		arg0_32:OpenPage(IslandShopBuySuccessLayer, arg1_32.awards)
	end
end

function var0_0.OnGetRankData(arg0_33, arg1_33)
	arg0_33.pages[var0_0.PAGE_RANK]:ExecuteAction("UpdateRankVOs", arg1_33.seasonId, arg1_33.list, arg1_33.playerInfo)
	arg0_33.pages[var0_0.PAGE_RANK]:ExecuteAction("UpdataRankView")

	if arg0_33.pages[var0_0.PAGE_REVIEW] then
		arg0_33.pages[var0_0.PAGE_REVIEW]:ExecuteAction("UpdateRankVOs", arg1_33.seasonId, arg1_33.list, arg1_33.playerInfo)
		arg0_33.pages[var0_0.PAGE_REVIEW]:ExecuteAction("UpdataIcon")
	end
end

function var0_0.OnHide(arg0_34)
	arg0_34.playRoomPop:Show(false)
	arg0_34:UnOverlayPanel(arg0_34.blurTF, arg0_34._tf)
	arg0_34.pages[var0_0.PAGE_PT]:OnHide()
	arg0_34.pages[var0_0.PAGE_ACTIVITY]:OnHide()

	if arg0_34.pages[var0_0.PAGE_REVIEW] then
		arg0_34.pages[var0_0.PAGE_REVIEW]:Hide()
	end
end

function var0_0.OnDisable(arg0_35)
	arg0_35:OnHide()
end

function var0_0.OnDestroy(arg0_36)
	arg0_36:OnHide()
	arg0_36.playRoomPop:willExit()

	arg0_36.playRoomPop = nil

	for iter0_36, iter1_36 in pairs(arg0_36.pages) do
		if iter1_36 then
			iter1_36:Destroy()

			iter1_36 = nil
		end
	end
end

function var0_0.OnEnable(arg0_37)
	arg0_37:OnShow()
end

return var0_0

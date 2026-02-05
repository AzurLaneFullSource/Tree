local var0_0 = class("IslandTradePage", import("...base.IslandBasePage"))

var0_0.OPEN_INVITE_PAGE = "IslandTradePage:OPEN_INVITE_PAGE"
var0_0.OPEN_CONFIRM_PAGE = "IslandTradePage:OPEN_CONFIRM_PAGE"
var0_0.MODE_SELL = 1
var0_0.MODE_PURCHAS = 2

local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4

function var0_0.getUIName(arg0_1)
	return "IslandTradeUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2._tf:Find("adapt/top/closeBtn")
	arg0_2.helpBtn = arg0_2._tf:Find("adapt/top/help")
	arg0_2.itemCntTxt = arg0_2._tf:Find("adapt/shopPage/res/9900/Text"):GetComponent(typeof(Text))
	arg0_2.goldCntTxt = arg0_2._tf:Find("adapt/shopPage/res/1/Text"):GetComponent(typeof(Text))
	arg0_2.pageContainer = arg0_2._tf:Find("adapt/shopPage")
	arg0_2.pagesUIList = UIItemList.New(arg0_2._tf:Find("adapt/tags"), arg0_2._tf:Find("adapt/tags/1"))
	arg0_2.limitTxt = arg0_2._tf:Find("adapt/shopPage/time/label"):GetComponent(typeof(Text))
	arg0_2.pages = {
		[var1_0] = IslandTradeProductListPage.New(arg0_2.pageContainer, arg0_2.event),
		[var2_0] = IslandTradeProductList4SellPage.New(arg0_2.pageContainer, arg0_2.event),
		[var3_0] = IslandTradePriceTrendPage.New(arg0_2.pageContainer, arg0_2.event),
		[var4_0] = IslandTradeRankPage.New(arg0_2.pageContainer, arg0_2.event)
	}
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.helpBtn, function()
		local var0_5 = arg0_3.mode
		local var1_5 = ""

		if var0_5 == IslandConst.TRADE_PURCHASE then
			var1_5 = i18n("island_trade_help_1")
		elseif var0_5 == IslandConst.TRADE_SELL then
			var1_5 = i18n("island_trade_help_2")
		end

		assert(var1_5)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var1_5
		})
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_6)
	arg0_6:AddListener(var0_0.OPEN_INVITE_PAGE, arg0_6.OnOpenInvitePage)
	arg0_6:AddListener(IslandTradegency.WEEK_NUM_UPDATE, arg0_6.OnWeekNumUpdate)
	arg0_6:AddListener(var0_0.OPEN_CONFIRM_PAGE, arg0_6.OnOpenConfirmPage)
	arg0_6:AddListener(GAME.ISLAND_TRADE_DONE, arg0_6.OnTradeDone)
	arg0_6:AddListener(IslandTradegency.RESET_PRICE, arg0_6.OnReset)
end

function var0_0.RemoveListeners(arg0_7)
	arg0_7:RemoveListener(var0_0.OPEN_INVITE_PAGE, arg0_7.OnOpenInvitePage)
	arg0_7:RemoveListener(IslandTradegency.WEEK_NUM_UPDATE, arg0_7.OnWeekNumUpdate)
	arg0_7:RemoveListener(var0_0.OPEN_CONFIRM_PAGE, arg0_7.OnOpenConfirmPage)
	arg0_7:RemoveListener(GAME.ISLAND_TRADE_DONE, arg0_7.OnTradeDone)
	arg0_7:RemoveListener(IslandTradegency.RESET_PRICE, arg0_7.OnReset)
end

function var0_0.OnReset(arg0_8)
	arg0_8:Hide()
	pg.TipsMgr.GetInstance():ShowTips(i18n("island_trade_reset_label"))
end

function var0_0.OnTradeDone(arg0_9)
	arg0_9:UpdateResource()
	arg0_9:UpdateLimit()
end

function var0_0.OnOpenConfirmPage(arg0_10, arg1_10)
	local var0_10 = arg0_10:GetIsland()
	local var1_10 = var0_10:GetTradeAgency()
	local var2_10 = 0
	local var3_10 = 0

	if arg1_10 == IslandConst.TRADE_PURCHASE then
		var2_10 = var1_10:GetTodayPrice()
		var3_10 = var1_10:GetCanPurchaseCnt()
	elseif arg1_10 == IslandConst.TRADE_SELL then
		var2_10 = var1_10:GetTodaySellPrice()
		var3_10 = var1_10:GetCanSellCnt(var0_10.id)
	end

	arg0_10:ShowMsgBox({
		type = IslandMsgBox.TYPE_TRADE_CONFRIM,
		mode = arg1_10,
		price = var2_10,
		maxCnt = var3_10,
		onYes = function(arg0_11)
			arg0_10:emit(IslandBaseMediator.TRADE_OP, arg1_10, arg0_11, var2_10)
		end
	})
end

function var0_0.OnWeekNumUpdate(arg0_12)
	arg0_12:UpdateLimit()
end

function var0_0.OnOpenInvitePage(arg0_13)
	arg0_13:OpenPage(IslandTradeInvitePage)
end

function var0_0.OnShow(arg0_14, arg1_14)
	arg0_14.mode = arg1_14

	arg0_14:UpdateResource()
	arg0_14:InitPageSwitcher(arg1_14)
	arg0_14:UpdateLabels()
	arg0_14:UpdateLimit()
	arg0_14:UpdateTitle(arg1_14)
end

function var0_0.UpdateTitle(arg0_15, arg1_15)
	if arg1_15 == var0_0.MODE_SELL then
		setText(arg0_15._tf:Find("adapt/toggles/tpl/shop2List/shop2Tpl/selected/name"), i18n("island_trade_sell_sub_label"))
		setText(arg0_15._tf:Find("adapt/toggles/tpl/shop1Tg/name"), i18n("island_trade_sell_sub_label"))
		setText(arg0_15._tf:Find("adapt/toggles/tpl/shop1Tg/name/en"), "SELL")
		setText(arg0_15._tf:Find("adapt/top/title/Text"), i18n("island_trade_title2"))
		setText(arg0_15._tf:Find("adapt/shopPage/time/Text"), i18n("island_trade_tip_label2"))
	elseif arg1_15 == var0_0.MODE_PURCHAS then
		setText(arg0_15._tf:Find("adapt/toggles/tpl/shop2List/shop2Tpl/selected/name"), i18n("island_trade_purchase_sub_label"))
		setText(arg0_15._tf:Find("adapt/toggles/tpl/shop1Tg/name"), i18n("island_trade_purchase_sub_label"))
		setText(arg0_15._tf:Find("adapt/toggles/tpl/shop1Tg/name/en"), "PURCHASE")
		setText(arg0_15._tf:Find("adapt/top/title/Text"), i18n("island_trade_title"))
		setText(arg0_15._tf:Find("adapt/shopPage/time/Text"), i18n("island_trade_tip_label"))
	end
end

function var0_0.UpdateLabels(arg0_16, arg1_16)
	local var0_16 = arg0_16:IsSellMode(arg1_16) and i18n("island_trade_sell_sub_label") or i18n("island_trade_purchase_sub_label")

	setText(arg0_16._tf:Find("adapt/toggles/tpl/shop1Tg/name"), var0_16)
	setText(arg0_16._tf:Find("adapt/toggles/tpl/shop2List/shop2Tpl/selected/name"), var0_16)
end

function var0_0.UpdateResource(arg0_17)
	local var0_17 = arg0_17:GetSelfIsland():GetInventoryAgency()

	arg0_17.itemCntTxt.text = var0_17:GetOwnCount(IslandItem.PEARL_ID)
	arg0_17.goldCntTxt.text = var0_17:GetOwnCount(IslandItem.GOLD_ID)
end

function var0_0.UpdateLimit(arg0_18)
	local var0_18 = arg0_18:GetSelfIsland():GetTradeAgency()

	if arg0_18.mode == var0_0.MODE_PURCHAS or arg0_18:IsSelfIsland() then
		local var1_18 = var0_18:GetWeekNumMax()

		arg0_18.limitTxt.text = i18n("island_trade_limit_label", var1_18 - var0_18:GetWeekNum() .. "/" .. var1_18)

		if arg0_18.mode == var0_0.MODE_SELL then
			arg0_18.limitTxt.text = ""
		end
	elseif arg0_18.mode == var0_0.MODE_SELL then
		local var2_18 = arg0_18:GetIsland()
		local var3_18 = var0_18:GetSellLimit(var2_18.id)
		local var4_18 = var0_18:GetSellLimitMax()

		arg0_18.limitTxt.text = i18n("island_trade_sell_tip_label", math.max(0, var4_18 - var3_18) .. "/" .. var4_18)
	end
end

function var0_0.IsSellMode(arg0_19, arg1_19)
	return arg1_19 == var0_0.MODE_SELL
end

function var0_0.Page2Name(arg0_20, arg1_20)
	if not var0_0.CH_NAMES then
		var0_0.CH_NAMES = {
			[var1_0] = i18n("island_trade_purchase_label"),
			[var2_0] = i18n("island_trade_sell_label"),
			[var3_0] = i18n("island_trade_trend_label"),
			[var4_0] = i18n("island_trade_rank_label")
		}
	end

	return var0_0.CH_NAMES[arg1_20]
end

function var0_0.InitPageSwitcher(arg0_21, arg1_21)
	local var0_21 = arg0_21:IsSellMode(arg1_21) and {
		var2_0,
		var3_0,
		var4_0
	} or {
		var1_0,
		var3_0,
		var4_0
	}

	arg0_21.pagesUIList:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = var0_21[arg1_22 + 1]
			local var1_22 = arg0_21:Page2Name(var0_22)

			setText(arg2_22:Find("name"), var1_22)
			setText(arg2_22:Find("selected/name"), var1_22)

			local var2_22 = arg2_22:GetComponent(typeof(Animation))

			onToggle(arg0_21, arg2_22, function(arg0_23)
				if arg0_23 then
					arg0_21:SwitchPage(var0_22)
				end

				if arg0_23 then
					var2_22:Play("anim_IslandTradeUI_selected_in")
				else
					var2_22:Play("anim_IslandTradeUI_selected_out")
				end
			end, SFX_PANEL)

			if arg1_22 == 0 then
				triggerToggle(arg2_22, true)
			end
		end
	end)
	arg0_21.pagesUIList:align(#var0_21)
end

function var0_0.SwitchPage(arg0_24, arg1_24)
	if arg0_24.page then
		arg0_24.page:ExecuteAction("Hide")
	end

	local var0_24 = arg0_24.pages[arg1_24]

	var0_24:ExecuteAction("Show", arg0_24:GetIsland(), arg0_24.mode)

	arg0_24.page = var0_24
end

function var0_0.OnHide(arg0_25)
	return
end

function var0_0.OnDestory(arg0_26)
	for iter0_26, iter1_26 in pairs(arg0_26.pages) do
		iter1_26:Destroy()
	end

	arg0_26.pages = nil
end

return var0_0

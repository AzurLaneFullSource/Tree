local var0_0 = class("FragmentShopPage", import(".ShamShopPage"))

function var0_0.GetPaintingCommodityUpdateVoice(arg0_1)
	return
end

function var0_0.CanOpen(arg0_2, arg1_2, arg2_2)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg2_2.level, "FragmentShop")
end

function var0_0.init(arg0_3)
	var0_0.super.init(arg0_3)
end

function var0_0.CustomInit(arg0_4)
	onButton(arg0_4, arg0_4.resolveBtn, function()
		if not arg0_4.resolvePanel then
			arg0_4.resolvePanel = FragResolvePanel.New(arg0_4)
			arg0_4.resolvePanel.event = arg0_4.event

			arg0_4.resolvePanel:Load()
		end

		arg0_4.resolvePanel.buffer:Reset()
		arg0_4.resolvePanel.buffer:Trigger("control")
	end, SFX_PANEL)
	getProxy(CommanderManualProxy):TaskProgressAdd(2023, 1)
end

function var0_0.OnUpdatePlayer(arg0_6)
	arg0_6:RefreshResItemList()
end

function var0_0.OnFragmentSellUpdate(arg0_7)
	if arg0_7.resolvePanel then
		arg0_7.resolvePanel.buffer:Reset()
		arg0_7.resolvePanel.buffer:Trigger("control")
	end
end

function var0_0.OnUpdateItems(arg0_8)
	arg0_8:RefreshResItemList()
end

function var0_0.GetResDataList(arg0_9)
	local var0_9 = {
		{
			type = DROP_TYPE_RESOURCE,
			resID = PlayerConst.ResBlueprintFragment,
			cnt = arg0_9.player:getResource(PlayerConst.ResBlueprintFragment)
		}
	}

	if not LOCK_UR_SHIP and arg0_9.items then
		local var1_9 = pg.gameset.urpt_chapter_max.description[1]
		local var2_9 = arg0_9.items[var1_9] or {
			count = 0
		}

		table.insert(var0_9, {
			type = DROP_TYPE_ITEM,
			resID = var1_9,
			cnt = var2_9.count
		})
	end

	return var0_9
end

function var0_0.OnUpdateCommodity(arg0_10, arg1_10)
	local var0_10

	for iter0_10, iter1_10 in pairs(arg0_10.cards) do
		if iter1_10.goodsVO.id == arg1_10.id then
			var0_10 = iter1_10

			break
		end
	end

	if var0_10 then
		var0_10.goodsVO = arg1_10

		ActivityGoodsCard.StaticUpdate(var0_10.tf, arg1_10, var0_0.TYPE_FRAGMENT)
	end
end

function var0_0.RefreshUI(arg0_11)
	arg0_11:UpdateTip()
	setActive(arg0_11.tipTextGo, true)
	setActive(arg0_11.helpBtn, false)
	setActive(arg0_11.resolveBtn, true)
	setActive(arg0_11.refreshBtn, false)
end

function var0_0.OnInitItem(arg0_12, arg1_12)
	local var0_12 = ActivityGoodsCard.New(arg1_12)

	onButton(arg0_12, var0_12.tf, function()
		if not var0_12.goodsVO:canPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		arg0_12:OnClickCommodity(var0_12.goodsVO, function(arg0_14, arg1_14)
			arg0_12:OnPurchase(arg0_14, arg1_14)
		end)
	end, SFX_PANEL)

	arg0_12.cards[arg1_12] = var0_12
end

function var0_0.OnUpdateItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.cards[arg2_15]

	if not var0_15 then
		arg0_15:OnInitItem(arg2_15)

		var0_15 = arg0_15.cards[arg2_15]
	end

	local var1_15 = arg0_15.displays[arg1_15 + 1]

	var0_15.goodsVO = var1_15

	ActivityGoodsCard.StaticUpdate(var0_15.tf, var1_15, var0_0.TYPE_FRAGMENT)
end

function var0_0.OnPurchase(arg0_16, arg1_16, arg2_16)
	arg0_16:emit(NewShopMainMediator.ON_FRAGMENT_SHOPPING, arg1_16.id, arg2_16)
end

function var0_0.OnDestroy(arg0_17)
	var0_0.super.OnDestroy(arg0_17)

	if arg0_17.resolvePanel then
		arg0_17.resolvePanel:Destroy()

		arg0_17.resolvePanel = nil
	end
end

return var0_0

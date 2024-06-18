local var0_0 = class("FragmentShopPage", import(".ShamShopPage"))

function var0_0.getUIName(arg0_1)
	return "FragmentShop"
end

function var0_0.GetPaintingCommodityUpdateVoice(arg0_2)
	return
end

function var0_0.CanOpen(arg0_3, arg1_3, arg2_3)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg2_3.level, "FragmentShop")
end

function var0_0.OnLoaded(arg0_4)
	arg0_4.dayTxt = arg0_4:findTF("time/day"):GetComponent(typeof(Text))
	arg0_4.fragment = arg0_4:findTF("res_fragment/count"):GetComponent(typeof(Text))
	arg0_4.resolveBtn = arg0_4:findTF("res_fragment/resolve")
	arg0_4.urRes = arg0_4:findTF("res_ur/count"):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_5)
	var0_0.super.OnInit(arg0_5)
	onButton(arg0_5, arg0_5.resolveBtn, function()
		if not arg0_5.resolvePanel then
			arg0_5.resolvePanel = FragResolvePanel.New(arg0_5)

			arg0_5.resolvePanel:Load()
		end

		arg0_5.resolvePanel.buffer:Reset()
		arg0_5.resolvePanel.buffer:Trigger("control")
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5:findTF("res_fragment"), function()
		arg0_5:emit(BaseUI.ON_ITEM, id2ItemId(PlayerConst.ResBlueprintFragment))
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5:findTF("res_ur"), function()
		local var0_8 = pg.gameset.urpt_chapter_max.description[1]

		arg0_5:emit(BaseUI.ON_ITEM, var0_8)
	end, SFX_PANEL)
end

function var0_0.OnUpdatePlayer(arg0_9)
	local var0_9 = arg0_9.player
	local var1_9 = arg0_9.player:getResource(PlayerConst.ResBlueprintFragment)

	arg0_9.fragment.text = var1_9
end

function var0_0.OnFragmentSellUpdate(arg0_10)
	if arg0_10.resolvePanel then
		arg0_10.resolvePanel.buffer:Reset()
		arg0_10.resolvePanel.buffer:Trigger("control")
	end
end

function var0_0.OnUpdateItems(arg0_11)
	if not LOCK_UR_SHIP then
		local var0_11 = pg.gameset.urpt_chapter_max.description[1]
		local var1_11 = arg0_11.items[var0_11] or {
			count = 0
		}

		arg0_11.urRes.text = var1_11.count
	else
		setActive(arg0_11:findTF("res_ur"), false)
		setAnchoredPosition(arg0_11:findTF("res_fragment"), {
			x = 938.5
		})
	end
end

function var0_0.OnUpdateCommodity(arg0_12, arg1_12)
	local var0_12

	for iter0_12, iter1_12 in pairs(arg0_12.cards) do
		if iter1_12.goodsVO.id == arg1_12.id then
			var0_12 = iter1_12

			break
		end
	end

	if var0_12 then
		var0_12.goodsVO = arg1_12

		ActivityGoodsCard.StaticUpdate(var0_12.tr, arg1_12, var0_0.TYPE_FRAGMENT)
	end
end

function var0_0.OnInitItem(arg0_13, arg1_13)
	local var0_13 = ActivityGoodsCard.New(arg1_13)

	onButton(arg0_13, var0_13.tr, function()
		if not var0_13.goodsVO:canPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		arg0_13:OnClickCommodity(var0_13.goodsVO, function(arg0_15, arg1_15)
			arg0_13:OnPurchase(arg0_15, arg1_15)
		end)
	end, SFX_PANEL)

	arg0_13.cards[arg1_13] = var0_13
end

function var0_0.OnUpdateItem(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.cards[arg2_16]

	if not var0_16 then
		arg0_16:OnInitItem(arg2_16)

		var0_16 = arg0_16.cards[arg2_16]
	end

	local var1_16 = arg0_16.displays[arg1_16 + 1]

	var0_16.goodsVO = var1_16

	ActivityGoodsCard.StaticUpdate(var0_16.tr, var1_16, var0_0.TYPE_FRAGMENT)
end

function var0_0.OnPurchase(arg0_17, arg1_17, arg2_17)
	arg0_17:emit(NewShopsMediator.ON_FRAGMENT_SHOPPING, arg1_17.id, arg2_17)
end

function var0_0.OnDestroy(arg0_18)
	var0_0.super.OnDestroy(arg0_18)

	if arg0_18.resolvePanel then
		arg0_18.resolvePanel:Destroy()

		arg0_18.resolvePanel = nil
	end
end

return var0_0

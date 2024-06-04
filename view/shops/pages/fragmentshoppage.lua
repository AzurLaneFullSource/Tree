local var0 = class("FragmentShopPage", import(".ShamShopPage"))

function var0.getUIName(arg0)
	return "FragmentShop"
end

function var0.GetPaintingCommodityUpdateVoice(arg0)
	return
end

function var0.CanOpen(arg0, arg1, arg2)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg2.level, "FragmentShop")
end

function var0.OnLoaded(arg0)
	arg0.dayTxt = arg0:findTF("time/day"):GetComponent(typeof(Text))
	arg0.fragment = arg0:findTF("res_fragment/count"):GetComponent(typeof(Text))
	arg0.resolveBtn = arg0:findTF("res_fragment/resolve")
	arg0.urRes = arg0:findTF("res_ur/count"):GetComponent(typeof(Text))
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	onButton(arg0, arg0.resolveBtn, function()
		if not arg0.resolvePanel then
			arg0.resolvePanel = FragResolvePanel.New(arg0)

			arg0.resolvePanel:Load()
		end

		arg0.resolvePanel.buffer:Reset()
		arg0.resolvePanel.buffer:Trigger("control")
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("res_fragment"), function()
		arg0:emit(BaseUI.ON_ITEM, id2ItemId(PlayerConst.ResBlueprintFragment))
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("res_ur"), function()
		local var0 = pg.gameset.urpt_chapter_max.description[1]

		arg0:emit(BaseUI.ON_ITEM, var0)
	end, SFX_PANEL)
end

function var0.OnUpdatePlayer(arg0)
	local var0 = arg0.player
	local var1 = arg0.player:getResource(PlayerConst.ResBlueprintFragment)

	arg0.fragment.text = var1
end

function var0.OnFragmentSellUpdate(arg0)
	if arg0.resolvePanel then
		arg0.resolvePanel.buffer:Reset()
		arg0.resolvePanel.buffer:Trigger("control")
	end
end

function var0.OnUpdateItems(arg0)
	if not LOCK_UR_SHIP then
		local var0 = pg.gameset.urpt_chapter_max.description[1]
		local var1 = arg0.items[var0] or {
			count = 0
		}

		arg0.urRes.text = var1.count
	else
		setActive(arg0:findTF("res_ur"), false)
		setAnchoredPosition(arg0:findTF("res_fragment"), {
			x = 938.5
		})
	end
end

function var0.OnUpdateCommodity(arg0, arg1)
	local var0

	for iter0, iter1 in pairs(arg0.cards) do
		if iter1.goodsVO.id == arg1.id then
			var0 = iter1

			break
		end
	end

	if var0 then
		var0.goodsVO = arg1

		ActivityGoodsCard.StaticUpdate(var0.tr, arg1, var0.TYPE_FRAGMENT)
	end
end

function var0.OnInitItem(arg0, arg1)
	local var0 = ActivityGoodsCard.New(arg1)

	onButton(arg0, var0.tr, function()
		if not var0.goodsVO:canPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		arg0:OnClickCommodity(var0.goodsVO, function(arg0, arg1)
			arg0:OnPurchase(arg0, arg1)
		end)
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.displays[arg1 + 1]

	var0.goodsVO = var1

	ActivityGoodsCard.StaticUpdate(var0.tr, var1, var0.TYPE_FRAGMENT)
end

function var0.OnPurchase(arg0, arg1, arg2)
	arg0:emit(NewShopsMediator.ON_FRAGMENT_SHOPPING, arg1.id, arg2)
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	if arg0.resolvePanel then
		arg0.resolvePanel:Destroy()

		arg0.resolvePanel = nil
	end
end

return var0

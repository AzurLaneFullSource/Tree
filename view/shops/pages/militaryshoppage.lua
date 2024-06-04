local var0 = class("MilitaryShopPage", import(".BaseShopPage"))

function var0.getUIName(arg0)
	return "MilitaryShop"
end

function var0.GetPaintingCommodityUpdateVoice(arg0)
	return
end

function var0.CanOpen(arg0, arg1, arg2)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg2.level, "MilitaryExerciseMediator")
end

function var0.OnLoaded(arg0)
	arg0.exploitTF = arg0:findTF("res_exploit/bg/Text"):GetComponent(typeof(Text))
	arg0.timerTF = arg0:findTF("timer_bg/Text"):GetComponent(typeof(Text))
	arg0.refreshBtn = arg0:findTF("refresh_btn")
end

function var0.OnInit(arg0)
	local var0 = pg.arena_data_shop[1]

	onButton(arg0, arg0.refreshBtn, function()
		if arg0.shop.refreshCount - 1 >= #var0.refresh_price then
			pg.TipsMgr.GetInstance():ShowTips(i18n("shopStreet_refresh_max_count"))

			return
		end

		local var0 = var0.refresh_price[arg0.shop.refreshCount] or var0.refresh_price[#var0.refresh_price]

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("refresh_shopStreet_question", i18n("word_gem_icon"), var0, arg0.shop.refreshCount - 1),
			onYes = function()
				if arg0.player:getTotalGem() < var0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

					return
				else
					arg0:emit(NewShopsMediator.REFRESH_MILITARY_SHOP, true)
				end
			end
		})
	end, SFX_PANEL)
end

function var0.OnUpdatePlayer(arg0)
	local var0 = arg0.player

	arg0.exploitTF.text = var0.exploit
end

function var0.OnSetUp(arg0)
	arg0:RemoveTimer()
	arg0:AddTimer()
end

function var0.OnUpdateAll(arg0)
	arg0:InitCommodities()
	arg0:OnSetUp()
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
		var0:update(arg1)
	end
end

function var0.OnInitItem(arg0, arg1)
	local var0 = GoodsCard.New(arg1)

	onButton(arg0, var0.go, function()
		if not var0.goodsVO:canPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		arg0:OnClickCommodity(var0.goodsVO)
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

	var0:update(var1)
end

function var0.OnClickCommodity(arg0, arg1)
	local var0 = arg1

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		yesText = "text_exchange",
		type = MSGBOX_TYPE_SINGLE_ITEM,
		drop = {
			id = var0:getConfig("effect_args")[1],
			type = var0:getConfig("type")
		},
		onYes = function()
			arg0:emit(NewShopsMediator.ON_SHOPPING, var0.id, 1)
		end
	})
end

function var0.AddTimer(arg0)
	local var0 = arg0.shop.nextTime + 1

	arg0.timer = Timer.New(function()
		local var0 = var0 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0 <= 0 then
			arg0:RemoveTimer()
			arg0:OnTimeOut()
		else
			local var1 = pg.TimeMgr.GetInstance():DescCDTime(var0)

			arg0.timerTF.text = var1
		end
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.OnTimeOut(arg0)
	arg0:emit(NewShopsMediator.REFRESH_MILITARY_SHOP)
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.OnDestroy(arg0)
	arg0:RemoveTimer()
end

return var0

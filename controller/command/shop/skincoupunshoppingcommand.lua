local var0_0 = class("SkinCoupunShoppingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shopId
	local var2_1 = var0_1.cnt
	local var3_1 = getProxy(ShipSkinProxy):GetAllSkins()
	local var4_1 = _.detect(var3_1, function(arg0_2)
		return arg0_2.id == var1_1
	end)

	if not var4_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_shopId_noFound"))

		return
	end

	if not var4_1:canPurchase() then
		return
	end

	local var5_1 = var4_1:getSkinId()
	local var6_1 = getProxy(ShipSkinProxy)
	local var7_1 = ShipSkin.New({
		id = var5_1
	})

	local function var8_1(arg0_3)
		local var0_3 = var4_1:getConfig("resource_num") - arg0_3.discount

		if var0_3 > getProxy(PlayerProxy):getRawData()[id2res(var4_1:getConfig("resource_type"))] then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)

			return
		end

		pg.ConnectionMgr.GetInstance():Send(11202, {
			cmd = 1,
			activity_id = arg0_3.actId,
			arg1 = var1_1,
			arg2 = var2_1,
			arg_list = {}
		}, 11203, function(arg0_4)
			if arg0_4.result == 0 then
				SkinCouponActivity.UseSkinCoupon(arg0_3.actId)
				var6_1:addSkin(var7_1)

				local var0_4 = getProxy(PlayerProxy):getData()

				var0_4:consume({
					[id2res(var4_1:getConfig("resource_type"))] = var0_3
				})
				getProxy(PlayerProxy):updatePlayer(var0_4)
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_buy_success"))
				arg0_1:sendNotification(GAME.SKIN_COUPON_SHOPPING_DONE, {
					id = var1_1,
					awards = {}
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_4.result] .. arg0_4.result)
			end
		end)
	end

	local var9_1 = {}
	local var10_1 = SkinCouponActivity.GetSkinCouponActivities(var1_1)

	if #var10_1 == 0 then
		return
	end

	table.sort(var10_1, CompareFuncs({
		function(arg0_5)
			return -arg0_5:GetDiscountPrice()
		end,
		function(arg0_6)
			return arg0_6.id
		end
	}))

	for iter0_1, iter1_1 in ipairs(var10_1) do
		if iter1_1:GetCanUsageCnt() > 0 then
			table.insert(var9_1, {
				actId = iter1_1.id,
				drop = Drop.New({
					type = DROP_TYPE_VITEM,
					id = iter1_1:GetItemId(),
					count = iter1_1:GetCanUsageCnt()
				}),
				discount = iter1_1:GetDiscountPrice()
			})
		end
	end

	SkinCouponMultiMsgBox.New(pg.UIMgr.GetInstance().OverlayMain):ExecuteAction("Show", {
		itemList = var9_1,
		skinId = var5_1,
		skinName = var7_1.skinName,
		price = var4_1:getConfig("resource_num"),
		onYes = var8_1
	})
end

return var0_0

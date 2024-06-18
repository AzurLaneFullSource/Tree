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

	local var5_1 = var4_1:GetPrice()

	if var5_1 > getProxy(PlayerProxy):getRawData()[id2res(var4_1:getConfig("resource_type"))] then
		GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)

		return
	end

	local var6_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SKIN_COUPON)

	if not var6_1 or var6_1:isEnd() then
		return
	end

	local var7_1 = var4_1:getSkinId()
	local var8_1 = getProxy(ShipSkinProxy)
	local var9_1 = ShipSkin.New({
		id = var7_1
	})

	local function var10_1()
		pg.ConnectionMgr.GetInstance():Send(11202, {
			cmd = 1,
			activity_id = var6_1.id,
			arg1 = var1_1,
			arg2 = var2_1,
			arg_list = {}
		}, 11203, function(arg0_4)
			if arg0_4.result == 0 then
				SkinCouponActivity.UseSkinCoupon()
				var8_1:addSkin(var9_1)

				local var0_4 = getProxy(PlayerProxy):getData()

				var0_4:consume({
					[id2res(var4_1:getConfig("resource_type"))] = var5_1
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

	SkinCouponMsgBox.New(pg.UIMgr.GetInstance().OverlayMain):ExecuteAction("Show", {
		skinName = var9_1.skinName,
		price = var5_1,
		itemConfig = SkinCouponActivity.StaticGetItemConfig(),
		onYes = var10_1
	})
end

return var0_0

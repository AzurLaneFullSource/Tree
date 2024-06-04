local var0 = class("SkinCoupunShoppingCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shopId
	local var2 = var0.cnt
	local var3 = getProxy(ShipSkinProxy):GetAllSkins()
	local var4 = _.detect(var3, function(arg0)
		return arg0.id == var1
	end)

	if not var4 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_shopId_noFound"))

		return
	end

	if not var4:canPurchase() then
		return
	end

	local var5 = var4:GetPrice()

	if var5 > getProxy(PlayerProxy):getRawData()[id2res(var4:getConfig("resource_type"))] then
		GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)

		return
	end

	local var6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SKIN_COUPON)

	if not var6 or var6:isEnd() then
		return
	end

	local var7 = var4:getSkinId()
	local var8 = getProxy(ShipSkinProxy)
	local var9 = ShipSkin.New({
		id = var7
	})

	local function var10()
		pg.ConnectionMgr.GetInstance():Send(11202, {
			cmd = 1,
			activity_id = var6.id,
			arg1 = var1,
			arg2 = var2,
			arg_list = {}
		}, 11203, function(arg0)
			if arg0.result == 0 then
				SkinCouponActivity.UseSkinCoupon()
				var8:addSkin(var9)

				local var0 = getProxy(PlayerProxy):getData()

				var0:consume({
					[id2res(var4:getConfig("resource_type"))] = var5
				})
				getProxy(PlayerProxy):updatePlayer(var0)
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_buy_success"))
				arg0:sendNotification(GAME.SKIN_COUPON_SHOPPING_DONE, {
					id = var1,
					awards = {}
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end
		end)
	end

	SkinCouponMsgBox.New(pg.UIMgr.GetInstance().OverlayMain):ExecuteAction("Show", {
		skinName = var9.skinName,
		price = var5,
		itemConfig = SkinCouponActivity.StaticGetItemConfig(),
		onYes = var10
	})
end

return var0

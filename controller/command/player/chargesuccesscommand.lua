local var0 = class("ChargeSuccessCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shopId
	local var2 = var0.payId
	local var3 = var0.gem
	local var4 = var0.gem_free
	local var5 = Goods.Create({
		shop_id = var1
	}, Goods.TYPE_CHARGE)
	local var6 = getProxy(PlayerProxy)
	local var7 = var6:getData()

	if var3 > 0 then
		var7:addResources({
			gem = var3
		})
	end

	if var4 > 0 then
		var7:addResources({
			freeGem = var4
		})
	end

	if var5:isMonthCard() then
		local var8 = var7:getCardById(VipCard.MONTH)
		local var9 = GetZeroTime() + 2419200

		if var8 and var8.leftDate ~= 0 then
			var8.leftDate = var8.leftDate + 2592000
		else
			var8 = VipCard.New({
				data = 0,
				type = VipCard.MONTH,
				left_date = var9
			})
		end

		var7:addVipCard(var8)
	end

	var6:updatePlayer(var7)

	if var5:isMonthCard() then
		MonthCardOutDateTipPanel.SetMonthCardEndDateLocal()
		MonthCardOutDateTipPanel.SetMonthCardTipDate(0)
	end

	local var10 = getProxy(ShopsProxy)
	local var11 = var10:getChargedList() or {}
	local var12 = false

	for iter0, iter1 in pairs(var11) do
		if iter1.id == var1 then
			var11[iter0]:increaseBuyCount()

			var12 = true

			break
		end
	end

	if not var12 then
		var11[var1] = Goods.Create({
			pay_count = 1,
			shop_id = var1
		}, Goods.TYPE_CHARGE)
	end

	var10:setChargedList(var11)

	local var13 = var10:getFirstChargeList() or {}

	if _.is_empty(var13) then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_PURCHASE_FIRST, var2)
	end

	if var5:firstPayDouble() then
		local var14 = var10:getFirstChargeList() or {}

		if not table.contains(var14, var1) then
			table.insert(var14, var1)
		end

		var10:setFirstChargeList(var14)
	end

	local var15 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHARGEAWARD)

	if var15 and var15.data1 == 0 then
		var15.data1 = 1
	end

	pg.TipsMgr.GetInstance():ShowTips(i18n("charge_success"))
end

return var0

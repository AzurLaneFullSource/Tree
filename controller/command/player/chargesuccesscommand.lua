local var0_0 = class("ChargeSuccessCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shopId
	local var2_1 = var0_1.payId
	local var3_1 = var0_1.gem
	local var4_1 = var0_1.gem_free
	local var5_1 = Goods.Create({
		shop_id = var1_1
	}, Goods.TYPE_CHARGE)
	local var6_1 = getProxy(PlayerProxy)
	local var7_1 = var6_1:getData()

	if var3_1 > 0 then
		var7_1:addResources({
			gem = var3_1
		})
	end

	if var4_1 > 0 then
		var7_1:addResources({
			freeGem = var4_1
		})
	end

	if var5_1:isMonthCard() then
		local var8_1 = var7_1:getCardById(VipCard.MONTH)
		local var9_1 = GetZeroTime() + 2419200

		if var8_1 and var8_1.leftDate ~= 0 then
			var8_1.leftDate = var8_1.leftDate + 2592000
		else
			var8_1 = VipCard.New({
				data = 0,
				type = VipCard.MONTH,
				left_date = var9_1
			})
		end

		var7_1:addVipCard(var8_1)
	end

	var6_1:updatePlayer(var7_1)

	if var5_1:isMonthCard() then
		MonthCardOutDateTipPanel.SetMonthCardEndDateLocal()
		MonthCardOutDateTipPanel.SetMonthCardTipDate(0)
	end

	local var10_1 = getProxy(ShopsProxy)
	local var11_1 = var10_1:getChargedList() or {}
	local var12_1 = false

	for iter0_1, iter1_1 in pairs(var11_1) do
		if iter1_1.id == var1_1 then
			var11_1[iter0_1]:increaseBuyCount()

			var12_1 = true

			break
		end
	end

	if not var12_1 then
		var11_1[var1_1] = Goods.Create({
			pay_count = 1,
			shop_id = var1_1
		}, Goods.TYPE_CHARGE)
	end

	var10_1:setChargedList(var11_1)

	local var13_1 = var10_1:getFirstChargeList() or {}

	if _.is_empty(var13_1) then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_PURCHASE_FIRST, var2_1)
	end

	if var5_1:firstPayDouble() then
		local var14_1 = var10_1:getFirstChargeList() or {}

		if not table.contains(var14_1, var1_1) then
			table.insert(var14_1, var1_1)
		end

		var10_1:setFirstChargeList(var14_1)
	end

	local var15_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHARGEAWARD)

	if var15_1 and var15_1.data1 == 0 then
		var15_1.data1 = 1
	end

	pg.TipsMgr.GetInstance():ShowTips(i18n("charge_success"))
end

return var0_0

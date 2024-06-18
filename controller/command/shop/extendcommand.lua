local var0_0 = class("ExtendCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.count
	local var3_1 = getProxy(PlayerProxy)
	local var4_1 = var3_1:getData()
	local var5_1 = pg.shop_template[var1_1]

	if var5_1.effect_args == ShopArgs.EffecetEquipBagSize then
		var4_1:addEquipmentBagCount(var5_1.num * var2_1)
	elseif var5_1.effect_args == ShopArgs.EffecetShipBagSize then
		var4_1:addShipBagCount(var5_1.num * var2_1)
	elseif var5_1.effect_args == ShopArgs.EffectDromExpPos then
		local var6_1 = getProxy(DormProxy)
		local var7_1 = var6_1:getData()

		var7_1:increaseTrainPos()
		var7_1:increaseRestPos()
		var6_1:updateDrom(var7_1, BackYardConst.DORM_UPDATE_TYPE_SHIP)
		arg0_1:sendNotification(GAME.EXTEND_BACKYARD_DONE)
	elseif var5_1.effect_args == ShopArgs.EffectDromFoodMax then
		local var8_1 = getProxy(DormProxy)
		local var9_1 = var8_1:getData()

		var9_1:extendFoodCapacity(var5_1.num)
		var9_1:increaseFoodExtendCount()
		var8_1:updateDrom(var9_1, BackYardConst.DORM_UPDATE_TYPE_EXTENDFOOD)
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_extendCapacity_ok", var5_1.num))
	elseif var5_1.effect_args == ShopArgs.EffectShopStreetFlash then
		pg.TipsMgr.GetInstance():ShowTips(i18n("refresh_shopStreet_ok"))
	elseif var5_1.effect_args == ShopArgs.EffectTradingPortLevel or var5_1.effect_args == ShopArgs.EffectOilFieldLevel or var5_1.effect_args == ShopArgs.EffectClassLevel then
		local var10_1
		local var11_1 = getProxy(NavalAcademyProxy)

		if var5_1.effect_args == ShopArgs.EffectTradingPortLevel then
			var10_1 = var11_1._goldVO
		elseif var5_1.effect_args == ShopArgs.EffectOilFieldLevel then
			var10_1 = var11_1._oilVO
		elseif var5_1.effect_args == ShopArgs.EffectClassLevel then
			var10_1 = var11_1._classVO

			local var12_1 = var10_1:GetLevel()

			if var12_1 == 7 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_CLASS_LEVEL_UP_8)
			elseif var12_1 == 8 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_CLASS_LEVEL_UP_9)
			elseif var12_1 == 9 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_CLASS_LEVEL_UP_10)
			end
		end

		var11_1:StartUpGradeSuccess(var10_1)

		if PLATFORM_CODE == PLATFORM_US then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_start") .. " " .. i18n("word_levelup"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_start") .. i18n("word_levelup"))
		end
	elseif var5_1.effect_args == ShopArgs.EffectGuildFlash then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_shop_flash_success"))
	elseif var5_1.effect_args == ShopArgs.EffectDormFloor then
		local var13_1 = getProxy(DormProxy)
		local var14_1 = var13_1:getData()

		var14_1:setFloorNum(var14_1.floorNum + 1)
		var13_1:updateDrom(var14_1, BackYardConst.DORM_UPDATE_TYPE_FLOOR)
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_buy_success"))
	elseif var5_1.effect_args == ShopArgs.EffectSkillPos then
		getProxy(NavalAcademyProxy):inCreaseKillClassNum()
		pg.TipsMgr.GetInstance():ShowTips(i18n("open_skill_class_success"))
	elseif var5_1.effect_args == ShopArgs.EffectCommanderBagSize then
		var4_1:updateCommanderBagMax(var5_1.num)
	elseif var5_1.effect_args == ShopArgs.EffectSpWeaponBagSize then
		getProxy(EquipmentProxy):AddSpWeaponCapacity(var5_1.num)
	else
		assert(false, "未处理类型")
	end

	var3_1:updatePlayer(var4_1)
end

return var0_0

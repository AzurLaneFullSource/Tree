local var0 = class("ExtendCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.count
	local var3 = getProxy(PlayerProxy)
	local var4 = var3:getData()
	local var5 = pg.shop_template[var1]

	if var5.effect_args == ShopArgs.EffecetEquipBagSize then
		var4:addEquipmentBagCount(var5.num * var2)
	elseif var5.effect_args == ShopArgs.EffecetShipBagSize then
		var4:addShipBagCount(var5.num * var2)
	elseif var5.effect_args == ShopArgs.EffectDromExpPos then
		local var6 = getProxy(DormProxy)
		local var7 = var6:getData()

		var7:increaseTrainPos()
		var7:increaseRestPos()
		var6:updateDrom(var7, BackYardConst.DORM_UPDATE_TYPE_SHIP)
		arg0:sendNotification(GAME.EXTEND_BACKYARD_DONE)
	elseif var5.effect_args == ShopArgs.EffectDromFoodMax then
		local var8 = getProxy(DormProxy)
		local var9 = var8:getData()

		var9:extendFoodCapacity(var5.num)
		var9:increaseFoodExtendCount()
		var8:updateDrom(var9, BackYardConst.DORM_UPDATE_TYPE_EXTENDFOOD)
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_extendCapacity_ok", var5.num))
	elseif var5.effect_args == ShopArgs.EffectShopStreetFlash then
		pg.TipsMgr.GetInstance():ShowTips(i18n("refresh_shopStreet_ok"))
	elseif var5.effect_args == ShopArgs.EffectTradingPortLevel or var5.effect_args == ShopArgs.EffectOilFieldLevel or var5.effect_args == ShopArgs.EffectClassLevel then
		local var10
		local var11 = getProxy(NavalAcademyProxy)

		if var5.effect_args == ShopArgs.EffectTradingPortLevel then
			var10 = var11._goldVO
		elseif var5.effect_args == ShopArgs.EffectOilFieldLevel then
			var10 = var11._oilVO
		elseif var5.effect_args == ShopArgs.EffectClassLevel then
			var10 = var11._classVO

			local var12 = var10:GetLevel()

			if var12 == 7 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_CLASS_LEVEL_UP_8)
			elseif var12 == 8 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_CLASS_LEVEL_UP_9)
			elseif var12 == 9 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_CLASS_LEVEL_UP_10)
			end
		end

		var11:StartUpGradeSuccess(var10)

		if PLATFORM_CODE == PLATFORM_US then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_start") .. " " .. i18n("word_levelup"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_start") .. i18n("word_levelup"))
		end
	elseif var5.effect_args == ShopArgs.EffectGuildFlash then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_shop_flash_success"))
	elseif var5.effect_args == ShopArgs.EffectDormFloor then
		local var13 = getProxy(DormProxy)
		local var14 = var13:getData()

		var14:setFloorNum(var14.floorNum + 1)
		var13:updateDrom(var14, BackYardConst.DORM_UPDATE_TYPE_FLOOR)
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_buy_success"))
	elseif var5.effect_args == ShopArgs.EffectSkillPos then
		getProxy(NavalAcademyProxy):inCreaseKillClassNum()
		pg.TipsMgr.GetInstance():ShowTips(i18n("open_skill_class_success"))
	elseif var5.effect_args == ShopArgs.EffectCommanderBagSize then
		var4:updateCommanderBagMax(var5.num)
	elseif var5.effect_args == ShopArgs.EffectSpWeaponBagSize then
		getProxy(EquipmentProxy):AddSpWeaponCapacity(var5.num)
	else
		assert(false, "未处理类型")
	end

	var3:updatePlayer(var4)
end

return var0

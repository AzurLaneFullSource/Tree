local var0_0 = class("NewEducateShoppingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.goodId
	local var3_1 = var0_1.num
	local var4_1 = var0_1.isUpgradeEntry
	local var5_1 = var0_1.callback

	if getProxy(NewEducateProxy):GetCurChar():GetFSM():CheckPriorityStystem() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("child2_priority_tip"))

		return
	end

	local var6_1 = getProxy(NewEducateProxy)
	local var7_1 = var6_1:GetCurChar()
	local var8_1 = NewEducateGoods.New(var2_1)
	local var9_1 = var7_1:GetGoodsDiscountInfos()
	local var10_1 = var8_1:GetCostWithBenefit(var9_1)

	var10_1.number = var10_1.number * var3_1

	if not var7_1:IsMatch(var10_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(29066, {
		id = var1_1,
		shop = var2_1,
		num = var3_1
	}, 29067, function(arg0_2)
		if arg0_2.result == 0 then
			var6_1:Cost(var10_1)
			var7_1:GetFSM():GetState(NewEducateFSM.SYSTEM.MAP):AddBuyCnt(var2_1, var3_1)

			local var0_2 = NewEducateDropHelper.HandleDrops(arg0_2.drop)

			arg0_1:sendNotification(GAME.NEW_EDUCATE_SHOPPING_DONE, {
				drops = var0_2,
				isUpgradeEntry = var4_1
			})
			pg.m02:sendNotification(GAME.NEW_EDUCATE_TRACK, NewEducateTrackCommand.BuildDataSite(var7_1.id, var7_1:GetGameCnt(), var7_1:GetRoundData().round, 4, var2_1))
			existCall(var5_1, var0_2)
		else
			pg.TipsMgr.GetInstance():ShowTips("NewEducate_Shopping: " .. arg0_2.result)
		end
	end)
end

return var0_0

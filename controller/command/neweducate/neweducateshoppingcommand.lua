local var0_0 = class("NewEducateShoppingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.goodId
	local var3_1 = var0_1.num

	pg.ConnectionMgr.GetInstance():Send(29066, {
		id = var1_1,
		shop = var2_1,
		num = var3_1
	}, 29067, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy)
			local var1_2 = NewEducateGoods.New(var2_1)
			local var2_2 = var0_2:GetCurChar()
			local var3_2 = var2_2:GetGoodsDiscountInfos()
			local var4_2 = var1_2:GetCostWithBenefit(var3_2)

			var4_2.number = var4_2.number * var3_1

			var0_2:Cost(var4_2)
			var2_2:GetFSM():GetState(NewEducateFSM.STYSTEM.MAP):AddBuyCnt(var2_1, var3_1)

			local var5_2 = NewEducateHelper.MergeDrops(arg0_2.drop)

			NewEducateHelper.UpdateDropsData(var5_2)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_SHOPPING_DONE, {
				drops = NewEducateHelper.FilterBenefit(var5_2)
			})
			pg.m02:sendNotification(GAME.NEW_EDUCATE_TRACK, NewEducateTrackCommand.BuildDataSite(var2_2.id, var2_2:GetGameCnt(), var2_2:GetRoundData().round, 4, var2_1))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_Shopping: ", arg0_2.result))
		end
	end)
end

return var0_0

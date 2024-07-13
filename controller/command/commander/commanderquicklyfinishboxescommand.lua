local var0_0 = class("CommanderQuicklyFinishBoxesCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.itemCnt
	local var2_1 = var0_1.finishCnt
	local var3_1 = var0_1.affectCnt

	pg.ConnectionMgr.GetInstance():Send(25037, {
		item_cnt = var1_1,
		finish_cnt = var2_1,
		affect_cnt = var3_1
	}, 25038, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(BagProxy):removeItemById(Item.COMMANDER_QUICKLY_TOOL_ID, var1_1)
			arg0_1:sendNotification(GAME.COMMANDER_QUICKLY_FINISH_BOXES_DONE)
			arg0_1:sendNotification(GAME.REFRESH_COMMANDER_BOXES)
		else
			arg0_1:sendNotification(GAME.COMMANDER_QUICKLY_FINISH_BOXES_ERROR)
		end
	end)
end

return var0_0

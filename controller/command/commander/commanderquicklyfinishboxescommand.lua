local var0 = class("CommanderQuicklyFinishBoxesCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.itemCnt
	local var2 = var0.finishCnt
	local var3 = var0.affectCnt

	pg.ConnectionMgr.GetInstance():Send(25037, {
		item_cnt = var1,
		finish_cnt = var2,
		affect_cnt = var3
	}, 25038, function(arg0)
		if arg0.result == 0 then
			getProxy(BagProxy):removeItemById(Item.COMMANDER_QUICKLY_TOOL_ID, var1)
			arg0:sendNotification(GAME.COMMANDER_QUICKLY_FINISH_BOXES_DONE)
			arg0:sendNotification(GAME.REFRESH_COMMANDER_BOXES)
		else
			arg0:sendNotification(GAME.COMMANDER_QUICKLY_FINISH_BOXES_ERROR)
		end
	end)
end

return var0

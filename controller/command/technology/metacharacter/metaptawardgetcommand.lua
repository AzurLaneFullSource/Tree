local var0 = class("MetaPTAwardGetCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = getProxy(MetaCharacterProxy)
	local var1 = arg1:getBody()
	local var2 = {
		group_id = var1.groupID,
		target_pt = var1.targetCount
	}

	print("34003 meta pt award send:", var1.groupID, var1.targetCount)
	pg.ConnectionMgr.GetInstance():Send(34003, var2, 34004, function(arg0)
		print("34004 meta pt award done:", arg0.result)

		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.drop_list)
			local var1 = var0:getMetaProgressVOByID(var1.groupID)
			local var2 = var1.metaPtData.targets
			local var3 = table.indexof(var2, var1.targetCount)

			var1:updatePTLevel(var3)
			arg0:sendNotification(GAME.GET_META_PT_AWARD_DONE, {
				awards = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(34004 + " : " + arg0.result)
		end
	end)
end

return var0

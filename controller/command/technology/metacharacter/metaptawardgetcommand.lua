local var0_0 = class("MetaPTAwardGetCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = getProxy(MetaCharacterProxy)
	local var1_1 = arg1_1:getBody()
	local var2_1 = {
		group_id = var1_1.groupID,
		target_pt = var1_1.targetCount
	}

	print("34003 meta pt award send:", var1_1.groupID, var1_1.targetCount)
	pg.ConnectionMgr.GetInstance():Send(34003, var2_1, 34004, function(arg0_2)
		print("34004 meta pt award done:", arg0_2.result)

		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)
			local var1_2 = var0_1:getMetaProgressVOByID(var1_1.groupID)
			local var2_2 = var1_2.metaPtData.targets
			local var3_2 = table.indexof(var2_2, var1_1.targetCount)

			var1_2:updatePTLevel(var3_2)
			arg0_1:sendNotification(GAME.GET_META_PT_AWARD_DONE, {
				awards = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(34004 + " : " + arg0_2.result)
		end
	end)
end

return var0_0

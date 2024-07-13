local var0_0 = class("ColoringAchieveCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.activityId
	local var2_1 = var0_1.id

	pg.ConnectionMgr.GetInstance():Send(26002, {
		act_id = var1_1,
		id = var2_1
	}, 26003, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)
			local var1_2 = getProxy(ColoringProxy)
			local var2_2 = var1_2:getColorGroup(var2_1)

			var2_2:setDrops(var0_2)
			var2_2:setState(ColorGroup.StateAchieved)
			var1_2:checkState()
			arg0_1:sendNotification(GAME.COLORING_ACHIEVE_DONE, {
				drops = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("coloring_achieve", arg0_2.result))
		end
	end)
end

return var0_0

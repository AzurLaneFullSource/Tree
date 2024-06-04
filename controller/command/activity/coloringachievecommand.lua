local var0 = class("ColoringAchieveCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.activityId
	local var2 = var0.id

	pg.ConnectionMgr.GetInstance():Send(26002, {
		act_id = var1,
		id = var2
	}, 26003, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.drop_list)
			local var1 = getProxy(ColoringProxy)
			local var2 = var1:getColorGroup(var2)

			var2:setDrops(var0)
			var2:setState(ColorGroup.StateAchieved)
			var1:checkState()
			arg0:sendNotification(GAME.COLORING_ACHIEVE_DONE, {
				drops = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("coloring_achieve", arg0.result))
		end
	end)
end

return var0

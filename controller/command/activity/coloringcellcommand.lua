local var0 = class("ColoringCellCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.activityId
	local var2 = var0.id
	local var3 = var0.cells

	pg.ConnectionMgr.GetInstance():Send(26004, {
		act_id = var1,
		id = var2,
		cell_list = var3
	}, 26005, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(ColoringProxy)
			local var1 = var0:getColorItems()
			local var2 = var0:getColorGroup(var2)
			local var3 = var2:getConfig("color_id_list")

			_.each(var3, function(arg0)
				var2:setFill(arg0.row, arg0.column, arg0.color)

				if not var2:canBeCustomised() and arg0.color > 0 then
					local var0 = var3[arg0.color]

					var1[var0] = math.max(var1[var0] - 1, 0)
				end
			end)

			local var4 = var0:checkState()

			arg0:sendNotification(GAME.COLORING_CELL_DONE, {
				cells = var3,
				stateChange = var4
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("coloring_cell", arg0.result))
		end
	end)
end

return var0

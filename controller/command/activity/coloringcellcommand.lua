local var0_0 = class("ColoringCellCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.activityId
	local var2_1 = var0_1.id
	local var3_1 = var0_1.cells

	pg.ConnectionMgr.GetInstance():Send(26004, {
		act_id = var1_1,
		id = var2_1,
		cell_list = var3_1
	}, 26005, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ColoringProxy)
			local var1_2 = var0_2:getColorItems()
			local var2_2 = var0_2:getColorGroup(var2_1)
			local var3_2 = var2_2:getConfig("color_id_list")

			_.each(var3_1, function(arg0_3)
				var2_2:setFill(arg0_3.row, arg0_3.column, arg0_3.color)

				if not var2_2:canBeCustomised() and arg0_3.color > 0 then
					local var0_3 = var3_2[arg0_3.color]

					var1_2[var0_3] = math.max(var1_2[var0_3] - 1, 0)
				end
			end)

			local var4_2 = var0_2:checkState()

			arg0_1:sendNotification(GAME.COLORING_CELL_DONE, {
				cells = var3_1,
				stateChange = var4_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("coloring_cell", arg0_2.result))
		end
	end)
end

return var0_0

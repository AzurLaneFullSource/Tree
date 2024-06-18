local var0_0 = class("WorldSubmitTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().taskId
	local var1_1 = nowWorld()
	local var2_1 = var1_1:GetInventoryProxy()
	local var3_1 = var1_1:GetTaskProxy()
	local var4_1 = var3_1:getTaskById(var0_1)

	if not var4_1 then
		return
	end

	local var5_1 = {}

	table.insert(var5_1, function(arg0_2)
		local var0_2, var1_2 = var4_1:canSubmit()

		if var0_2 then
			arg0_2()
		else
			pg.TipsMgr.GetInstance():ShowTips(var1_2)
		end
	end)

	local var6_1 = var4_1.config.complete_condition == WorldConst.TaskTypeSubmitItem and var4_1.config.item_retrieve == 1

	assert(var4_1:IsAutoSubmit(), "auto submit error")
	seriesAsync(var5_1, function()
		pg.ConnectionMgr.GetInstance():Send(33207, {
			taskId = var0_1
		}, 33208, function(arg0_4)
			if arg0_4.result == 0 then
				local function var0_4(arg0_5, arg1_5, arg2_5)
					local var0_5 = getProxy(BayProxy)
					local var1_5 = {}
					local var2_5 = {}
					local var3_5 = arg0_5:GetShipVOs()

					for iter0_5, iter1_5 in ipairs(var3_5) do
						table.insert(var1_5, iter1_5)

						local var4_5 = var0_5:getShipById(iter1_5.id)

						var4_5:setIntimacy(var4_5:getIntimacy() + arg2_5)
						var4_5:addExp(arg1_5)
						var0_5:updateShip(var4_5)

						local var5_5 = WorldConst.FetchShipVO(iter1_5.id)

						table.insert(var2_5, var5_5)
					end

					return {
						oldships = var1_5,
						newships = var2_5
					}
				end

				local var1_4 = {}
				local var2_4 = arg0_4.exp
				local var3_4 = arg0_4.intimacy
				local var4_4 = var1_1:GetFleets()

				for iter0_4, iter1_4 in pairs(var4_4) do
					local var5_4 = var0_4(iter1_4, var2_4, var3_4)

					if var2_4 > 0 then
						table.insert(var1_4, var5_4)
					end
				end

				local var6_4 = PlayerConst.addTranDrop(arg0_4.drops)

				var4_1:commited()
				var3_1:updateTask(var4_1)
				var3_1:riseTaskFinishCount()
				var1_1:UpdateProgress(var4_1.config.complete_stage)

				if var6_1 then
					var2_1:RemoveItem(var4_1.config.complete_parameter[1], var4_1:getMaxProgress())
				end

				arg0_1:sendNotification(GAME.WORLD_AUTO_SUMBMIT_TASK_DONE, {
					task = var4_1,
					drops = var6_4,
					expfleets = var1_4
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("task_submitTask", arg0_4.result))
			end
		end)
	end)
end

return var0_0

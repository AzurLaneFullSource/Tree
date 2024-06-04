local var0 = class("WorldSubmitTaskCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().taskId
	local var1 = nowWorld()
	local var2 = var1:GetInventoryProxy()
	local var3 = var1:GetTaskProxy()
	local var4 = var3:getTaskById(var0)

	if not var4 then
		return
	end

	local var5 = {}

	table.insert(var5, function(arg0)
		local var0, var1 = var4:canSubmit()

		if var0 then
			arg0()
		else
			pg.TipsMgr.GetInstance():ShowTips(var1)
		end
	end)

	local var6 = var4.config.complete_condition == WorldConst.TaskTypeSubmitItem and var4.config.item_retrieve == 1

	assert(var4:IsAutoSubmit(), "auto submit error")
	seriesAsync(var5, function()
		pg.ConnectionMgr.GetInstance():Send(33207, {
			taskId = var0
		}, 33208, function(arg0)
			if arg0.result == 0 then
				local function var0(arg0, arg1, arg2)
					local var0 = getProxy(BayProxy)
					local var1 = {}
					local var2 = {}
					local var3 = arg0:GetShipVOs()

					for iter0, iter1 in ipairs(var3) do
						table.insert(var1, iter1)

						local var4 = var0:getShipById(iter1.id)

						var4:setIntimacy(var4:getIntimacy() + arg2)
						var4:addExp(arg1)
						var0:updateShip(var4)

						local var5 = WorldConst.FetchShipVO(iter1.id)

						table.insert(var2, var5)
					end

					return {
						oldships = var1,
						newships = var2
					}
				end

				local var1 = {}
				local var2 = arg0.exp
				local var3 = arg0.intimacy
				local var4 = var1:GetFleets()

				for iter0, iter1 in pairs(var4) do
					local var5 = var0(iter1, var2, var3)

					if var2 > 0 then
						table.insert(var1, var5)
					end
				end

				local var6 = PlayerConst.addTranDrop(arg0.drops)

				var4:commited()
				var3:updateTask(var4)
				var3:riseTaskFinishCount()
				var1:UpdateProgress(var4.config.complete_stage)

				if var6 then
					var2:RemoveItem(var4.config.complete_parameter[1], var4:getMaxProgress())
				end

				arg0:sendNotification(GAME.WORLD_AUTO_SUMBMIT_TASK_DONE, {
					task = var4,
					drops = var6,
					expfleets = var1
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("task_submitTask", arg0.result))
			end
		end)
	end)
end

return var0

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

	if not var4_1:IsAutoSubmit() and var6_1 then
		table.insert(var5_1, function(arg0_3)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("sub_item_warning"),
				items = {
					{
						type = DROP_TYPE_WORLD_ITEM,
						id = var4_1.config.complete_parameter[1],
						count = var4_1:getMaxProgress()
					}
				},
				onYes = arg0_3
			})
		end)
	end

	seriesAsync(var5_1, function()
		pg.ConnectionMgr.GetInstance():Send(33207, {
			taskId = var0_1
		}, 33208, function(arg0_5)
			if arg0_5.result == 0 then
				local function var0_5(arg0_6, arg1_6, arg2_6)
					local var0_6 = getProxy(BayProxy)
					local var1_6 = {}
					local var2_6 = {}
					local var3_6 = arg0_6:GetShipVOs()

					for iter0_6, iter1_6 in ipairs(var3_6) do
						table.insert(var1_6, iter1_6)

						local var4_6 = var0_6:getShipById(iter1_6.id)

						var4_6:setIntimacy(var4_6:getIntimacy() + arg2_6)
						var4_6:addExp(arg1_6)
						var0_6:updateShip(var4_6)

						local var5_6 = WorldConst.FetchShipVO(iter1_6.id)

						table.insert(var2_6, var5_6)
					end

					return {
						oldships = var1_6,
						newships = var2_6
					}
				end

				local var1_5 = {}
				local var2_5 = arg0_5.exp
				local var3_5 = arg0_5.intimacy
				local var4_5 = var1_1:GetFleets()

				for iter0_5, iter1_5 in pairs(var4_5) do
					local var5_5 = var0_5(iter1_5, var2_5, var3_5)

					if var2_5 > 0 then
						table.insert(var1_5, var5_5)
					end
				end

				local var6_5 = PlayerConst.addTranDrop(arg0_5.drops)

				var4_1:commited()
				var3_1:updateTask(var4_1)
				var3_1:riseTaskFinishCount()
				var1_1:UpdateProgress(var4_1.config.complete_stage)

				if var6_1 then
					var2_1:RemoveItem(var4_1.config.complete_parameter[1], var4_1:getMaxProgress())
				end

				arg0_1:sendNotification(GAME.WORLD_SUMBMIT_TASK_DONE, {
					task = var4_1,
					drops = var6_5,
					expfleets = var1_5
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("task_submitTask", arg0_5.result))
			end
		end)
	end)
end

return var0_0

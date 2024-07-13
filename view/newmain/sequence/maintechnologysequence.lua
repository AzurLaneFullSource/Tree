local var0_0 = class("MainTechnologySequence")

var0_0.DontNotifyBluePrintTaskAgain = false

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = getProxy(TechnologyProxy):getBuildingBluePrint()

	if not var0_1 then
		arg1_1()

		return
	end

	local var1_1 = var0_1:getTaskIds()
	local var2_1 = false

	for iter0_1, iter1_1 in ipairs(var1_1) do
		if var0_1:getTaskOpenTimeStamp(iter1_1) <= pg.TimeMgr.GetInstance():GetServerTime() then
			local var3_1 = getProxy(TaskProxy):getTaskById(iter1_1) or getProxy(TaskProxy):getFinishTaskById(iter1_1)
			local var4_1 = getProxy(TaskProxy):isFinishPrevTasks(iter1_1)

			if not var3_1 and var4_1 then
				var2_1 = true

				arg0_1:TriggerTask(iter1_1)
			end
		end
	end

	if var2_1 and not var0_0.DontNotifyBluePrintTaskAgain then
		local var5_1 = var0_1:getShipVO()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("blueprint_task_update_tip", var5_1:getConfig("name")),
			weight = LayerWeightConst.SECOND_LAYER,
			onYes = function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPBLUEPRINT)
				arg1_1()
			end,
			onNo = function()
				var0_0.DontNotifyBluePrintTaskAgain = true

				arg1_1()
			end
		})
	else
		arg1_1()
	end
end

function var0_0.TriggerTask(arg0_4, arg1_4)
	if not getProxy(TaskProxy):isFinishPrevTasks(arg1_4) then
		return
	end

	pg.m02:sendNotification(GAME.TRIGGER_TASK, arg1_4)
end

return var0_0

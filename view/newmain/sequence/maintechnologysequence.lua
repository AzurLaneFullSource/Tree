local var0 = class("MainTechnologySequence")

var0.DontNotifyBluePrintTaskAgain = false

function var0.Execute(arg0, arg1)
	local var0 = getProxy(TechnologyProxy):getBuildingBluePrint()

	if not var0 then
		arg1()

		return
	end

	local var1 = var0:getTaskIds()
	local var2 = false

	for iter0, iter1 in ipairs(var1) do
		if var0:getTaskOpenTimeStamp(iter1) <= pg.TimeMgr.GetInstance():GetServerTime() then
			local var3 = getProxy(TaskProxy):getTaskById(iter1) or getProxy(TaskProxy):getFinishTaskById(iter1)
			local var4 = getProxy(TaskProxy):isFinishPrevTasks(iter1)

			if not var3 and var4 then
				var2 = true

				arg0:TriggerTask(iter1)
			end
		end
	end

	if var2 and not var0.DontNotifyBluePrintTaskAgain then
		local var5 = var0:getShipVO()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("blueprint_task_update_tip", var5:getConfig("name")),
			weight = LayerWeightConst.SECOND_LAYER,
			onYes = function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPBLUEPRINT)
				arg1()
			end,
			onNo = function()
				var0.DontNotifyBluePrintTaskAgain = true

				arg1()
			end
		})
	else
		arg1()
	end
end

function var0.TriggerTask(arg0, arg1)
	if not getProxy(TaskProxy):isFinishPrevTasks(arg1) then
		return
	end

	pg.m02:sendNotification(GAME.TRIGGER_TASK, arg1)
end

return var0

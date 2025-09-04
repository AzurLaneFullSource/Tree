local var0_0 = class("NodeCanvasBaseTask", import(".NodeCanvasBaseObject"))

function var0_0.Execute(arg0_1, arg1_1, arg2_1)
	arg0_1:Init(arg1_1, arg2_1)
	arg0_1:OnExecute()
end

function var0_0.Update(arg0_2)
	arg0_2:OnUpdate()
end

function var0_0.Stop(arg0_3)
	arg0_3:OnStop()
end

function var0_0.Pause(arg0_4)
	arg0_4:OnPause()
end

function var0_0.Resume(arg0_5)
	arg0_5:OnResume()
end

function var0_0.DrawGizmosSelected(arg0_6)
	arg0_6:OnDrawGizmosSelected()
end

function var0_0.EndAction(arg0_7, arg1_7)
	local var0_7 = arg0_7:GetNodeInstance()

	if var0_7 then
		var0_7:EndAction(defaultValue(arg1_7, true))
	end
end

function var0_0.SendEvent(arg0_8, arg1_8, arg2_8)
	if not _IslandCore then
		return
	end

	_IslandCore:GetController():NotifiyCore(arg1_8, arg2_8)
	_IslandCore:GetController():NotifiyIsland(arg1_8, arg2_8)
end

function var0_0.OnExecute(arg0_9)
	return
end

function var0_0.OnUpdate(arg0_10)
	return
end

function var0_0.OnStop(arg0_11)
	return
end

function var0_0.OnPause(arg0_12)
	return
end

function var0_0.OnResume(arg0_13)
	return
end

function var0_0.OnDrawGizmosSelected(arg0_14)
	return
end

return var0_0

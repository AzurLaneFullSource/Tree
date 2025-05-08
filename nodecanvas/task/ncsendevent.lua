local var0_0 = class("NcSendEvent", import("..base.NodeCanvasBaseTask"))

function var0_0.OnExecute(arg0_1)
	local var0_1 = arg0_1:GetStringArg("eventName")

	arg0_1:SendEvent(ISLAND_EVT[var0_1], {
		node = arg0_1
	})
	arg0_1:EndAction()
end

return var0_0

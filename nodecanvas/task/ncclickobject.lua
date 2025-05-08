local var0_0 = class("NcClickObject", import("..base.NodeCanvasBaseTask"))

function var0_0.OnExecute(arg0_1)
	function var0_0.Click(arg0_2)
		arg0_1:EndAction()
	end

	arg0_1:GetRouter().onMouseDown = arg0_1:GetRouter().onMouseDown + var0_0.Click
end

function var0_0.OnStop(arg0_3)
	if var0_0.Click then
		arg0_3:GetRouter().onMouseDown = arg0_3:GetRouter().onMouseDown - var0_0.Click
		var0_0.Click = nil
	end
end

return var0_0

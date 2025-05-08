local var0_0 = class("NcPlayGuide", import("..base.NodeCanvasBaseTask"))

function var0_0.OnExecute(arg0_1)
	local var0_1 = arg0_1:GetStringArg("guide")

	pg.NewGuideMgr.GetInstance():Play(var0_1, {}, function()
		arg0_1:EndAction()
	end, nil)
end

return var0_0

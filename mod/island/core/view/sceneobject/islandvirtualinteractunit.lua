local var0_0 = class("IslandVirtualInteractUnit", import(".IslandInteractUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.attach = "AgoraMainStage/furniture/" .. math.floor(arg2_1.id / 10) .. "/" .. arg2_1.config.attach
end

function var0_0.OnAttach(arg0_2, arg1_2)
	var0_0.super.OnAttach(arg0_2, arg1_2)
	arg0_2.signalReceiver:SetCommonEvent(function(arg0_3)
		if arg0_2.ignoreSignal then
			return
		end

		switch(arg0_3.stringParameter, {
			TimelineEnd = function()
				arg0_2:Op("AgoraVirtualInterActionEnd", arg0_2.id, arg0_2.view.player.id)
			end
		})
	end)
end

function var0_0.GetTargetRoot(arg0_5)
	if arg0_5.attachGo then
		return arg0_5.attachGo.transform
	else
		arg0_5.attachGo = GameObject.Find(arg0_5.attach)

		return arg0_5.attachGo.transform
	end
end

return var0_0

local var0_0 = class("IslandVirtualInteractUnit", import(".IslandInteractUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	local function var0_1()
		return math.floor(arg0_1.id / 10)
	end

	arg0_1.attach = "AgoraMainStage/furniture/" .. var0_1() .. "/" .. arg2_1.config.attach
end

function var0_0.OnAttach(arg0_3, arg1_3)
	var0_0.super.OnAttach(arg0_3, arg1_3)
	arg0_3.signalReceiver:SetCommonEvent(function(arg0_4)
		if arg0_3.ignoreSignal then
			return
		end

		switch(arg0_4.stringParameter, {
			TimelineEnd = function()
				arg0_3:Op("AgoraVirtualInterActionEnd", arg0_3.id, arg0_3.view.player.id)
			end
		})
	end)
end

function var0_0.GetTargetRoot(arg0_6)
	if arg0_6.attachGo then
		return arg0_6.attachGo.transform
	else
		arg0_6.attachGo = GameObject.Find(arg0_6.attach)

		return arg0_6.attachGo.transform
	end
end

function var0_0.GetPlayerParent(arg0_7)
	if arg0_7.tempPlayerParentPath == nil then
		return arg0_7:GetTargetRoot()
	else
		local var0_7 = arg0_7:GetTargetRoot():Find(arg0_7.tempPlayerParentPath)

		assert(var0_7, "can't find player parent with path: " .. arg0_7.tempPlayerParentPath)

		return var0_7
	end
end

function var0_0.StartInteract(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8, arg5_8, arg6_8, arg7_8, arg8_8)
	arg0_8.tempPlayerParentPath = arg8_8

	var0_0.super.StartInteract(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8, arg5_8, arg6_8, arg7_8)
end

return var0_0

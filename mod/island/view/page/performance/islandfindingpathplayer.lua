local var0_0 = class("IslandFindingPathPlayer", import(".IslandBasePerformancePlayer"))

function var0_0.Play(arg0_1, arg1_1, arg2_1)
	local var0_1 = {
		unitId = arg1_1.object,
		position = arg1_1.position,
		speed = arg1_1.speed,
		hide = arg1_1.hide,
		waitUntilDone = arg1_1.waitUntilDone,
		index = arg1_1.index
	}

	arg0_1:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.START_PATHFINDER, {
		navData = var0_1,
		callback = arg2_1,
		onEndAction = function()
			if arg0_1.endCallback then
				arg0_1.endCallback()
			end

			arg0_1.endCallback = nil
		end
	})
end

function var0_0.SetEndCallback(arg0_3, arg1_3)
	arg0_3.endCallback = arg1_3
end

return var0_0

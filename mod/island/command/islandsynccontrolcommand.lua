local var0_0 = class("IslandSyncControlCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(21209, {
		island_id = var0_1.islandId,
		obj_id = var0_1.objId,
		slot_id = var0_1.slotId,
		op = var0_1.op,
		status = var0_1.status,
		type = var0_1.type
	}, 21210, function(arg0_2)
		if IslandConst.SYNC_TEST_DELAY_ON then
			local var0_2 = math.random(IslandConst.SYNC_TEST_DELAY_L, IslandConst.SYNC_TEST_DELAY_R)

			LeanTween.delayedCall(var0_2 / 1000, System.Action(function()
				existCall(var0_1.onResult, arg0_2.result)
			end))
		else
			existCall(var0_1.onResult, arg0_2.result)
		end
	end)
end

return var0_0

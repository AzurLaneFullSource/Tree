local var0_0 = class("SyncUnitBuilder")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.view = arg1_1:GetCore().view
	arg0_1.playerId = getProxy(PlayerProxy):getPlayerId()
end

function var0_0.Build(arg0_2, arg1_2)
	return (switch(arg1_2.type, {
		[IslandConst.SYNC_TYPE_PLAYER] = function()
			local var0_3 = arg0_2.view:GetUnitModule(arg1_2.tid)

			warning(arg1_2.id, arg1_2.tid, var0_3)

			return SyncUnitPlayer.New(arg1_2, var0_3)
		end,
		[IslandConst.SYNC_TYPE_UNIT_MOVE] = function()
			local var0_4 = arg0_2.view:GetUnitModule(arg1_2.tid)

			warning(arg1_2.id, arg1_2.tid, var0_4)

			return SyncUnitInteraction.New(arg1_2, var0_4)
		end,
		[IslandConst.SYNC_TYPE_UNIT_STATIC] = function()
			warning(arg1_2.id, arg1_2.tid)

			return SyncUnitStatic.New(arg1_2)
		end,
		[IslandConst.SYNC_TYPE_AGORA] = function()
			warning(arg1_2.id, arg1_2.tid)

			return SyncUnitStatic.New(arg1_2)
		end
	}))
end

return var0_0

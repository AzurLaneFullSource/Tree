local var0_0 = class("IslandProxy", import("model.proxy.NetProxy"))

function var0_0.register(arg0_1)
	return
end

function var0_0.SetIsland(arg0_2, arg1_2)
	arg0_2.island = arg1_2
end

function var0_0.GetIsland(arg0_3)
	return arg0_3.island
end

function var0_0.remove(arg0_4)
	arg0_4.island = nil
end

function var0_0.CanUpgradeIsland(arg0_5)
	local var0_5 = arg0_5:GetIsland()

	return var0_5 and var0_5:CanLevelUp()
end

function var0_0.AnyProsperityAwardCanGet(arg0_6)
	local var0_6 = arg0_6:GetIsland()

	return var0_6 and var0_6:AnyProsperityAwardCanGet()
end

function var0_0.ShouldTip(arg0_7)
	return arg0_7:CanUpgradeIsland() or arg0_7:AnyProsperityAwardCanGet()
end

function var0_0.SetSharedIsland(arg0_8, arg1_8)
	arg0_8.sharedIsland = arg1_8
end

function var0_0.GetSharedIsland(arg0_9)
	return arg0_9.sharedIsland
end

function var0_0.SetSyncObjInitData(arg0_10, arg1_10)
	arg0_10.syncObjInitData = arg1_10
end

function var0_0.GetSyncObjInitData(arg0_11)
	return arg0_11.syncObjInitData and arg0_11.syncObjInitData or {}
end

function var0_0.timeCall(arg0_12)
	return {
		[ProxyRegister.SecondCall] = function(arg0_13)
			if not arg0_12.island then
				return
			end

			arg0_12.island:UpdatePerSecond()
		end,
		[ProxyRegister.DayCall] = function(arg0_14)
			if not arg0_12.island then
				return
			end

			arg0_12.island:UpdatePerDay()
		end
	}
end

return var0_0

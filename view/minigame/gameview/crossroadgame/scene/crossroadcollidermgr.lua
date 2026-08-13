local var0_0 = class("CrossRoadColliderMgr")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._runningData = arg1_1
	arg0_1._event = arg2_1
	arg0_1._playerMgr = arg3_1
	arg0_1.carList = nil
	arg0_1.roleList = nil
end

function var0_0.Step(arg0_2, arg1_2)
	arg0_2.carList = arg0_2._runningData:GetTrackCarGoList()
	arg0_2.roleList = arg0_2._runningData:GetRoleList()

	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.carList) do
		for iter2_2, iter3_2 in ipairs(iter1_2) do
			if iter3_2:GetTrack() == CrossRoadGameConst.FRONT_ROAD_NAME then
				table.insert(var0_2, iter3_2)
			end
		end
	end

	arg0_2.carList = var0_2
	arg0_2.roleList = underscore.select(arg0_2.roleList, function(arg0_3)
		return arg0_3:GetTrack() == CrossRoadGameConst.SCENE_ROAD_NAME and arg0_3:GetRunState() ~= CrossRoadGameConst.SHIP_STATE.crash
	end)

	for iter4_2, iter5_2 in ipairs(arg0_2.carList) do
		for iter6_2, iter7_2 in ipairs(arg0_2.roleList) do
			if arg0_2._runningData:CheckCarCarshRole(iter5_2, iter7_2) then
				arg0_2._runningData:TryUpdateUnion(iter7_2)
				iter7_2:SetRunState(CrossRoadGameConst.SHIP_STATE.crash)
				iter5_2:SetCarCrashList(iter7_2)
				arg0_2._event(CrossRoadGameConst.HIT_ROLER)
			end
		end

		if not arg0_2._playerMgr:GetCrashState() and arg0_2._runningData:CheckCarCarshPlayer(iter5_2) then
			if iter5_2:GetPosition().x < arg0_2._playerMgr:GetPosition().x then
				arg0_2._runningData:SetPlayerCrashDir({
					1,
					0
				})
			else
				arg0_2._runningData:SetPlayerCrashDir({
					-1,
					0
				})
			end

			local var1_2, var2_2, var3_2, var4_2 = iter5_2:GetCarRectPoint()

			arg0_2._runningData:SetPlayerCarshSize(var3_2 - var1_2)
			arg0_2._playerMgr:PlayZhihuiHit()
		end
	end
end

function var0_0.Clear(arg0_4)
	return
end

function var0_0.Dispose(arg0_5)
	return
end

return var0_0

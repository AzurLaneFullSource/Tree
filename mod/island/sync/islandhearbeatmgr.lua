local var0_0 = class("IslandHearBeatMgr")

var0_0.SERVER_HEART_BEAT_INTERVAL = 10

function var0_0.Ctor(arg0_1)
	arg0_1.heartBeatTimer = Timer.New(function()
		arg0_1:SendHeartBeat()
	end, IslandConst.HEART_BEAT_INTERVAL, -1)
	arg0_1.islandId = nil
	arg0_1.lastHeartBeatTime = 0
end

function var0_0.SendHeartBeat(arg0_3)
	if not arg0_3.islandId then
		return
	end

	local var0_3 = os.time()

	if arg0_3.lastHeartBeatTime ~= 0 and var0_3 - arg0_3.lastHeartBeatTime > var0_0.SERVER_HEART_BEAT_INTERVAL then
		warning("心跳时间间隔异常", arg0_3.lastHeartBeatTime, var0_3)
	end

	arg0_3.lastHeartBeatTime = var0_3

	pg.ConnectionMgr.GetInstance():Send(21215, {
		island_id = arg0_3.islandId
	})
end

function var0_0.EnterIsland(arg0_4, arg1_4)
	arg0_4.islandId = arg1_4

	arg0_4.heartBeatTimer:Stop()
	arg0_4.heartBeatTimer:Start()
	arg0_4:SendHeartBeat()
end

function var0_0.ExitIsland(arg0_5)
	arg0_5.heartBeatTimer:Stop()

	arg0_5.islandId = nil
end

function var0_0.Dispose(arg0_6)
	if arg0_6.heartBeatTimer then
		arg0_6.heartBeatTimer:Stop()

		arg0_6.heartBeatTimer = nil
	end
end

return var0_0

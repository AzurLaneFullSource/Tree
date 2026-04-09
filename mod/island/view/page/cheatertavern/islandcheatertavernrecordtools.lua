local var0_0 = {}

var0_0.LOST = 0
var0_0.WIN = 1
var0_0.LEAVE = 2

function var0_0.StartGame()
	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildCheaterTavernGame(0, 0))

	var0_0.startTime = pg.TimeMgr.GetInstance():GetServerTime()
	var0_0.scoreBefore = PlayRoomTools.GetPtScrore(PlayRoomTools.GetGameTypeID())
	var0_0.turnCnt = 0
	var0_0.roundCnt = 0
	var0_0.duration = 0
end

function var0_0.StopPlayTime()
	local var0_2 = pg.TimeMgr.GetInstance():GetServerTime() - var0_0.startTime

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildCheaterTavernGame(1, var0_2))
end

function var0_0.RecordResult(arg0_3)
	var0_0.StopPlayTime()

	local var0_3 = PlayRoomTools.GetPtScrore(PlayRoomTools.GetGameTypeID())

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildCheaterTavernResult(arg0_3, var0_0.scoreBefore, var0_3, var0_0.turnCnt, var0_0.roundCnt, var0_0.duration))
end

function var0_0.AddTurnCnt()
	var0_0.turnCnt = var0_0.turnCnt + 1
end

function var0_0.AddRoundCnt()
	var0_0.roundCnt = var0_0.roundCnt + 1
end

function var0_0.StartPutCardTime()
	var0_0.putCardTime = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.StopPutCardTime()
	var0_0.duration = var0_0.duration + (pg.TimeMgr.GetInstance():GetServerTime() - var0_0.putCardTime)
end

return var0_0

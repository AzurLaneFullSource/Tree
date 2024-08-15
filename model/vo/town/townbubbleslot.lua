local var0_0 = class("TownBubbleSlot")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.pos = arg1_1
	arg0_1.shipId = arg2_1 or 0
	arg0_1.startTime = arg3_1 or 0
	arg0_1.interval = pg.gameset.activity_town_bubble.description[1][1]
	arg0_1.maxCnt = pg.gameset.activity_town_bubble.description[2][1]
	arg0_1.passCnt = 0
end

function var0_0.OnUpdateTime(arg0_2, arg1_2)
	if arg0_2.startTime == 0 or arg0_2.passCnt >= arg0_2.maxCnt then
		return
	end

	arg0_2.passCnt = math.min(math.floor((arg1_2 - arg0_2.startTime) / arg0_2.interval), arg0_2.maxCnt)
end

function var0_0.GetPassCnt(arg0_3)
	return arg0_3.passCnt
end

function var0_0.ResetStartTime(arg0_4, arg1_4)
	arg0_4.startTime = arg1_4
	arg0_4.passCnt = 0
end

function var0_0.GetShipId(arg0_5)
	return arg0_5.shipId
end

function var0_0.IsNewEmpty(arg0_6)
	return arg0_6.startTime == 0
end

function var0_0.ChangeShip(arg0_7, arg1_7)
	arg0_7.shipId = arg1_7

	if arg0_7.startTime == 0 then
		arg0_7.startTime = pg.TimeMgr.GetInstance():GetServerTime()
	end
end

return var0_0

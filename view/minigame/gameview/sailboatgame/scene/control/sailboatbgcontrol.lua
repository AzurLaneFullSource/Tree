local var0_0 = class("SailBoatBgControl")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = SailBoatGameVo
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._followTarget = nil
	arg0_1._backGrounds = {}
	arg0_1._bgs = {}
	arg0_1._bgPool = {}
	arg0_1._bgMoveSpeed = Vector2(0, 0)
	arg0_1._bgMoveAmount = Vector2(0, 0)
end

function var0_0.start(arg0_2)
	for iter0_2 = #arg0_2._bgs, 1, -1 do
		local var0_2 = table.remove(arg0_2._bgs, iter0_2)

		var0_2:clear()
		table.insert(arg0_2._bgPool, var0_2)
	end

	arg0_2._bgMoveAmount = Vector2(0, 0)

	arg0_2:initBgRound()

	for iter1_2 = 1, #arg0_2._bgs do
		arg0_2._bgs[iter1_2]:start()
	end

	arg0_2._bgMoveSpeed.x = var1_0.moveAmount.x
	arg0_2._bgMoveSpeed.y = var1_0.moveAmount.y

	var1_0.SetGameBgs(arg0_2._bgs)
end

function var0_0.step(arg0_3, arg1_3)
	local var0_3 = var1_0.GetSceneSpeed()

	arg0_3._bgMoveAmount.x = arg0_3._bgMoveAmount.x + var0_3.x
	arg0_3._bgMoveAmount.y = arg0_3._bgMoveAmount.y + var0_3.y

	for iter0_3 = 1, #arg0_3._bgs do
		arg0_3._bgs[iter0_3]:setMoveAmount(arg0_3._bgMoveAmount)
		arg0_3._bgs[iter0_3]:step()
	end
end

function var0_0.setTarget(arg0_4, arg1_4)
	arg0_4._followTarget = arg1_4
end

function var0_0.setBackGround(arg0_5, arg1_5)
	return
end

function var0_0.clear(arg0_6)
	return
end

function var0_0.getBgRoundData(arg0_7, arg1_7)
	for iter0_7 = 1, #SailBoatGameConst.game_bg_round do
		local var0_7 = SailBoatGameConst.game_bg_round[iter0_7]

		if var0_7.round == arg1_7 then
			return Clone(var0_7)
		end
	end

	return nil
end

function var0_0.initBgRound(arg0_8)
	local var0_8 = var1_0.GetRoundData()

	if not var0_8 then
		return
	end

	for iter0_8 = 1, #var0_8.bg_rule do
		local var1_8 = SailBoatGameConst.bg_rule[var0_8.bg_rule[iter0_8]]
		local var2_8 = arg0_8:createAndInitBg(var1_8)

		table.insert(arg0_8._bgs, var2_8)
	end
end

function var0_0.createAndInitBg(arg0_9, arg1_9)
	local var0_9

	if arg0_9._bgPool and #arg0_9._bgPool > 0 then
		var0_9 = table.remove(arg0_9._bgPool, 1)
	end

	var0_9 = var0_9 or SailBoatBg.New(arg0_9._tf, arg0_9._event)

	var0_9:setRuleData(arg1_9)

	return var0_9
end

function var0_0.useTestBgMove(arg0_10)
	return
end

function var0_0.dispose(arg0_11)
	return
end

return var0_0

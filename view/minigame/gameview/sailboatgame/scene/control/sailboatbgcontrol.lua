local var0 = class("SailBoatBgControl")
local var1

function var0.Ctor(arg0, arg1, arg2)
	var1 = SailBoatGameVo
	arg0._tf = arg1
	arg0._event = arg2
	arg0._followTarget = nil
	arg0._backGrounds = {}
	arg0._bgs = {}
	arg0._bgPool = {}
	arg0._bgMoveSpeed = Vector2(0, 0)
	arg0._bgMoveAmount = Vector2(0, 0)
end

function var0.start(arg0)
	for iter0 = #arg0._bgs, 1, -1 do
		local var0 = table.remove(arg0._bgs, iter0)

		var0:clear()
		table.insert(arg0._bgPool, var0)
	end

	arg0._bgMoveAmount = Vector2(0, 0)

	arg0:initBgRound()

	for iter1 = 1, #arg0._bgs do
		arg0._bgs[iter1]:start()
	end

	arg0._bgMoveSpeed.x = var1.moveAmount.x
	arg0._bgMoveSpeed.y = var1.moveAmount.y

	var1.SetGameBgs(arg0._bgs)
end

function var0.step(arg0, arg1)
	local var0 = var1.GetSceneSpeed()

	arg0._bgMoveAmount.x = arg0._bgMoveAmount.x + var0.x
	arg0._bgMoveAmount.y = arg0._bgMoveAmount.y + var0.y

	for iter0 = 1, #arg0._bgs do
		arg0._bgs[iter0]:setMoveAmount(arg0._bgMoveAmount)
		arg0._bgs[iter0]:step()
	end
end

function var0.setTarget(arg0, arg1)
	arg0._followTarget = arg1
end

function var0.setBackGround(arg0, arg1)
	return
end

function var0.clear(arg0)
	return
end

function var0.getBgRoundData(arg0, arg1)
	for iter0 = 1, #SailBoatGameConst.game_bg_round do
		local var0 = SailBoatGameConst.game_bg_round[iter0]

		if var0.round == arg1 then
			return Clone(var0)
		end
	end

	return nil
end

function var0.initBgRound(arg0)
	local var0 = var1.GetRoundData()

	if not var0 then
		return
	end

	for iter0 = 1, #var0.bg_rule do
		local var1 = SailBoatGameConst.bg_rule[var0.bg_rule[iter0]]
		local var2 = arg0:createAndInitBg(var1)

		table.insert(arg0._bgs, var2)
	end
end

function var0.createAndInitBg(arg0, arg1)
	local var0

	if arg0._bgPool and #arg0._bgPool > 0 then
		var0 = table.remove(arg0._bgPool, 1)
	end

	var0 = var0 or SailBoatBg.New(arg0._tf, arg0._event)

	var0:setRuleData(arg1)

	return var0
end

function var0.useTestBgMove(arg0)
	return
end

function var0.dispose(arg0)
	return
end

return var0

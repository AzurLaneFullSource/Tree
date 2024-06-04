local var0 = class("EnemyScavenger", import("view.miniGame.gameView.RyzaMiniGame.character.MoveEnemy"))

function var0.InitUI(arg0, arg1)
	var0.super.InitUI(arg0, arg1)

	arg0.hp = arg1.hp or 1
	arg0.hpMax = arg0.hp
	arg0.speed = arg1.speed or 1
	arg0.skillCD = 0
	arg0.skillTime = 0
	arg0.rate = arg1.rate or 1.1
end

function var0.GetSpeedDis(arg0)
	return var0.super.GetSpeedDis(arg0) * (arg0.skillTime > 0 and arg0.rate or 1)
end

function var0.PlayMove(arg0, arg1)
	if arg0.skillTime > 0 then
		arg0:PlayAnim("Move2_" .. arg1)
	else
		arg0:PlayAnim("Move_" .. arg1)
	end
end

var0.loopDic = {
	Wait = true,
	Move2 = true,
	Move = true
}

function var0.TimeTrigger(arg0, arg1)
	var0.super.TimeTrigger(arg0, arg1)

	arg0.skillCD = arg0.skillCD - arg1
	arg0.skillTime = arg0.skillTime - arg1

	if not arg0.lock and arg0.skillCD <= 0 and arg0.responder:SearchRyza(arg0, arg0.search) then
		arg0.skillCD = 10
		arg0.skillTime = 5
	end
end

return var0

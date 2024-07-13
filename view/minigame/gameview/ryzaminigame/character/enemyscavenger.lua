local var0_0 = class("EnemyScavenger", import("view.miniGame.gameView.RyzaMiniGame.character.MoveEnemy"))

function var0_0.InitUI(arg0_1, arg1_1)
	var0_0.super.InitUI(arg0_1, arg1_1)

	arg0_1.hp = arg1_1.hp or 1
	arg0_1.hpMax = arg0_1.hp
	arg0_1.speed = arg1_1.speed or 1
	arg0_1.skillCD = 0
	arg0_1.skillTime = 0
	arg0_1.rate = arg1_1.rate or 1.1
end

function var0_0.GetSpeedDis(arg0_2)
	return var0_0.super.GetSpeedDis(arg0_2) * (arg0_2.skillTime > 0 and arg0_2.rate or 1)
end

function var0_0.PlayMove(arg0_3, arg1_3)
	if arg0_3.skillTime > 0 then
		arg0_3:PlayAnim("Move2_" .. arg1_3)
	else
		arg0_3:PlayAnim("Move_" .. arg1_3)
	end
end

var0_0.loopDic = {
	Wait = true,
	Move2 = true,
	Move = true
}

function var0_0.TimeTrigger(arg0_4, arg1_4)
	var0_0.super.TimeTrigger(arg0_4, arg1_4)

	arg0_4.skillCD = arg0_4.skillCD - arg1_4
	arg0_4.skillTime = arg0_4.skillTime - arg1_4

	if not arg0_4.lock and arg0_4.skillCD <= 0 and arg0_4.responder:SearchRyza(arg0_4, arg0_4.search) then
		arg0_4.skillCD = 10
		arg0_4.skillTime = 5
	end
end

return var0_0

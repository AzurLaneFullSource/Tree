local var0_0 = class("BeatMonsterModel")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.controller = arg1_1
	arg0_1.fuShun = nil
	arg0_1.mosterNian = nil
	arg0_1.attackCnt = 0
	arg0_1.actionStr = ""
end

function var0_0.AddFuShun(arg0_2)
	arg0_2.fuShun = {}
end

function var0_0.AddMonsterNian(arg0_3, arg1_3, arg2_3)
	arg0_3.mosterNian = {
		hp = arg1_3,
		maxHp = arg2_3
	}
end

function var0_0.UpdateMonsterHp(arg0_4, arg1_4)
	arg0_4.mosterNian.hp = arg1_4
end

function var0_0.UpdateData(arg0_5, arg1_5)
	arg0_5:UpdateMonsterHp(arg1_5.hp)

	arg0_5.mosterNian.maxHp = arg1_5.maxHp

	arg0_5:SetAttackCnt(arg1_5.leftCount)
end

function var0_0.SetAttackCnt(arg0_6, arg1_6)
	arg0_6.attackCnt = arg1_6
end

function var0_0.UpdateActionStr(arg0_7, arg1_7)
	if not arg1_7 or arg1_7 == "" then
		arg0_7.actionStr = ""
	else
		arg0_7.actionStr = arg0_7.actionStr .. arg1_7
	end
end

function var0_0.SetStorys(arg0_8, arg1_8)
	arg0_8.storys = arg1_8
end

function var0_0.GetPlayableStory(arg0_9)
	local var0_9 = arg0_9.storys

	if not var0_9 or type(var0_9) ~= "table" then
		return
	end

	local var1_9 = pg.NewStoryMgr.GetInstance()

	for iter0_9, iter1_9 in pairs(var0_9) do
		local var2_9 = iter1_9[1]
		local var3_9 = iter1_9[2]

		if var2_9 >= arg0_9.mosterNian.hp and not var1_9:IsPlayed(var3_9) then
			return var3_9
		end
	end
end

function var0_0.GetActionStr(arg0_10)
	return arg0_10.actionStr
end

function var0_0.IsMatchAction(arg0_11)
	return BeatMonsterNianConst.MatchAction(arg0_11.actionStr)
end

function var0_0.GetMatchAction(arg0_12)
	return BeatMonsterNianConst.GetMatchAction(arg0_12.actionStr)
end

function var0_0.GetMonsterAction(arg0_13)
	return BeatMonsterNianConst.GetMonsterAction(arg0_13.actionStr)
end

function var0_0.RandomDamage(arg0_14)
	local var0_14 = math.random(1, 2)

	return math.max(arg0_14.mosterNian.hp - var0_14, 0)
end

function var0_0.GetMonsterMaxHp(arg0_15)
	return arg0_15.mosterNian.maxHp
end

function var0_0.GetAttackCount(arg0_16)
	return arg0_16.attackCnt
end

function var0_0.Dispose(arg0_17)
	return
end

return var0_0

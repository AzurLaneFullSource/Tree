local var0 = class("BeatMonsterModel")

function var0.Ctor(arg0, arg1)
	arg0.controller = arg1
	arg0.fuShun = nil
	arg0.mosterNian = nil
	arg0.attackCnt = 0
	arg0.actionStr = ""
end

function var0.AddFuShun(arg0)
	arg0.fuShun = {}
end

function var0.AddMonsterNian(arg0, arg1, arg2)
	arg0.mosterNian = {
		hp = arg1,
		maxHp = arg2
	}
end

function var0.UpdateMonsterHp(arg0, arg1)
	arg0.mosterNian.hp = arg1
end

function var0.UpdateData(arg0, arg1)
	arg0:UpdateMonsterHp(arg1.hp)

	arg0.mosterNian.maxHp = arg1.maxHp

	arg0:SetAttackCnt(arg1.leftCount)
end

function var0.SetAttackCnt(arg0, arg1)
	arg0.attackCnt = arg1
end

function var0.UpdateActionStr(arg0, arg1)
	if not arg1 or arg1 == "" then
		arg0.actionStr = ""
	else
		arg0.actionStr = arg0.actionStr .. arg1
	end
end

function var0.SetStorys(arg0, arg1)
	arg0.storys = arg1
end

function var0.GetPlayableStory(arg0)
	local var0 = arg0.storys

	if not var0 or type(var0) ~= "table" then
		return
	end

	local var1 = pg.NewStoryMgr.GetInstance()

	for iter0, iter1 in pairs(var0) do
		local var2 = iter1[1]
		local var3 = iter1[2]

		if var2 >= arg0.mosterNian.hp and not var1:IsPlayed(var3) then
			return var3
		end
	end
end

function var0.GetActionStr(arg0)
	return arg0.actionStr
end

function var0.IsMatchAction(arg0)
	return BeatMonsterNianConst.MatchAction(arg0.actionStr)
end

function var0.GetMatchAction(arg0)
	return BeatMonsterNianConst.GetMatchAction(arg0.actionStr)
end

function var0.GetMonsterAction(arg0)
	return BeatMonsterNianConst.GetMonsterAction(arg0.actionStr)
end

function var0.RandomDamage(arg0)
	local var0 = math.random(1, 2)

	return math.max(arg0.mosterNian.hp - var0, 0)
end

function var0.GetMonsterMaxHp(arg0)
	return arg0.mosterNian.maxHp
end

function var0.GetAttackCount(arg0)
	return arg0.attackCnt
end

function var0.Dispose(arg0)
	return
end

return var0

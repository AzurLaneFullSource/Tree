local var0_0 = class("NewEducateTalentState", import(".NewEducateStateBase"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.talents = arg1_1.talents or {}
	arg0_1.reTalents = arg1_1.retalents or {}
	arg0_1.finishFlag = arg1_1.finished == 1 and true or false
end

function var0_0.SetTalents(arg0_2, arg1_2)
	arg0_2.talents = arg1_2
end

function var0_0.GetTalents(arg0_3)
	return arg0_3.talents
end

function var0_0.OnRefreshTalent(arg0_4, arg1_4, arg2_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.talents) do
		if iter1_4 == arg1_4 then
			arg0_4.talents[iter0_4] = arg2_4

			table.insert(arg0_4.reTalents, arg0_4.talents[iter0_4])
		end
	end
end

function var0_0.GetReTalents(arg0_5)
	return arg0_5.reTalents
end

function var0_0.MarkFinish(arg0_6)
	arg0_6.finishFlag = true
end

function var0_0.IsFinish(arg0_7)
	return arg0_7.finishFlag
end

function var0_0.Reset(arg0_8)
	arg0_8.talents = {}
	arg0_8.reTalents = {}
	arg0_8.finishFlag = false
end

return var0_0

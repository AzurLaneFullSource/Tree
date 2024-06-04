local var0 = class("LanternRiddlesModel")
local var1 = pg.activity_event_question

function var0.Ctor(arg0, arg1)
	arg0.controller = arg1
end

function var0.Init(arg0)
	arg0.questiones = {}

	for iter0, iter1 in ipairs(var1.all) do
		local var0 = var1[iter1]
		local var1 = arg0:GetNextTime(iter0)
		local var2 = arg0:WrapQuestion(var0, var1)

		table.insert(arg0.questiones, var2)
	end
end

function var0.WrapQuestion(arg0, arg1, arg2)
	local var0 = {
		{
			arg1.answer_false1,
			false
		},
		{
			arg1.answer_false2,
			false
		},
		{
			arg1.answer_false3,
			false
		}
	}
	local var1 = arg0:GetAnswerFlag(arg1.id, var0)

	shuffle(var1)

	local var2 = math.random(1, 4)

	table.insert(var1, var2, {
		arg1.answer_right,
		false
	})

	local var3 = arg0:IsFinishQuestion(arg1.id)
	local var4 = arg0.unlockCount > 0 or var3

	return {
		id = arg1.id,
		type = arg1.type,
		rightIndex = var2,
		answers = var1,
		text = arg1.question,
		nextTime = arg2 or 0,
		waitTime = arg1.wrong_time,
		isFinish = var3,
		isUnlock = var4
	}
end

function var0.IsFinishQuestion(arg0, arg1)
	return table.contains(arg0.finishList, arg1)
end

function var0.GetNextTime(arg0, arg1)
	return arg0.nextTimes[arg1] or 0
end

function var0.SetNextTime(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.questiones) do
		if iter1.id == arg1 then
			iter1.nextTime = pg.TimeMgr.GetInstance():GetServerTime() + iter1.waitTime
			var0 = iter1.waitTime

			break
		end
	end

	arg0.lockTime = pg.TimeMgr.GetInstance():GetServerTime() + var0
end

function var0.GetLockTime(arg0)
	return arg0.lockTime
end

function var0.GetAnswerFlag(arg0, arg1, arg2)
	local var0 = getProxy(PlayerProxy):getRawData().id

	local function var1(arg0, arg1)
		return PlayerPrefs.GetInt(arg0 .. "_" .. arg1 .. "_" .. var0, 0) > 0
	end

	return _.map(arg2, function(arg0)
		local var0 = var1(arg1, arg0[1])

		return {
			arg0[1],
			var0
		}
	end)
end

function var0.SetAnswerFlag(arg0, arg1, arg2)
	local var0 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(arg1 .. "_" .. arg2 .. "_" .. var0, 1)
	PlayerPrefs.Save()

	for iter0, iter1 in ipairs(arg0.questiones) do
		if iter1.id == arg1 then
			for iter2, iter3 in ipairs(iter1.answers) do
				if iter3[1] == arg2 then
					iter3[2] = true

					break
				end
			end
		end
	end
end

function var0.UpdateWrongAnswerFlag(arg0, arg1, arg2)
	local var0 = _.detect(arg0.questiones, function(arg0)
		return arg0.id == arg1
	end).answers[arg2]

	arg0:SetAnswerFlag(arg1, var0[1])
	arg0:SetNextTime(arg1)
end

function var0.UpdateRightAnswerFlag(arg0, arg1)
	if not table.contains(arg0.finishList, arg1) then
		table.insert(arg0.finishList, arg1)

		arg0.finishCount = arg0.finishCount + 1
	end

	arg0:GetQuestion(arg1).isFinish = true
	arg0.unlockCount = arg0.unlockCount - 1

	if arg0.unlockCount <= 0 then
		for iter0, iter1 in ipairs(arg0.questiones) do
			if not iter1.isFinish then
				iter1.isUnlock = false
			end
		end
	end
end

function var0.UpdateData(arg0, arg1)
	arg0.finishCount = arg1.finishCount or 0
	arg0.unlockCount = arg1.unlockCount or 0
	arg0.nextTimes = arg1.nextTimes
	arg0.finishList = arg1.finishList
	arg0.lockTime = arg0.nextTimes[#arg0.nextTimes]

	arg0:Init()
end

function var0.IsRight(arg0, arg1, arg2)
	return _.any(arg0.questiones, function(arg0)
		return arg1 == arg0.id and arg0.rightIndex == arg2
	end)
end

function var0.GetQuestiones(arg0)
	return arg0.questiones
end

function var0.GetQuestion(arg0, arg1)
	return _.detect(arg0.questiones, function(arg0)
		return arg0.id == arg1
	end)
end

function var0.Dispose(arg0)
	return
end

return var0

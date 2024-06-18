local var0_0 = class("LanternRiddlesModel")
local var1_0 = pg.activity_event_question

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.controller = arg1_1
end

function var0_0.Init(arg0_2)
	arg0_2.questiones = {}

	for iter0_2, iter1_2 in ipairs(var1_0.all) do
		local var0_2 = var1_0[iter1_2]
		local var1_2 = arg0_2:GetNextTime(iter0_2)
		local var2_2 = arg0_2:WrapQuestion(var0_2, var1_2)

		table.insert(arg0_2.questiones, var2_2)
	end
end

function var0_0.WrapQuestion(arg0_3, arg1_3, arg2_3)
	local var0_3 = {
		{
			arg1_3.answer_false1,
			false
		},
		{
			arg1_3.answer_false2,
			false
		},
		{
			arg1_3.answer_false3,
			false
		}
	}
	local var1_3 = arg0_3:GetAnswerFlag(arg1_3.id, var0_3)

	shuffle(var1_3)

	local var2_3 = math.random(1, 4)

	table.insert(var1_3, var2_3, {
		arg1_3.answer_right,
		false
	})

	local var3_3 = arg0_3:IsFinishQuestion(arg1_3.id)
	local var4_3 = arg0_3.unlockCount > 0 or var3_3

	return {
		id = arg1_3.id,
		type = arg1_3.type,
		rightIndex = var2_3,
		answers = var1_3,
		text = arg1_3.question,
		nextTime = arg2_3 or 0,
		waitTime = arg1_3.wrong_time,
		isFinish = var3_3,
		isUnlock = var4_3
	}
end

function var0_0.IsFinishQuestion(arg0_4, arg1_4)
	return table.contains(arg0_4.finishList, arg1_4)
end

function var0_0.GetNextTime(arg0_5, arg1_5)
	return arg0_5.nextTimes[arg1_5] or 0
end

function var0_0.SetNextTime(arg0_6, arg1_6)
	local var0_6 = 0

	for iter0_6, iter1_6 in ipairs(arg0_6.questiones) do
		if iter1_6.id == arg1_6 then
			iter1_6.nextTime = pg.TimeMgr.GetInstance():GetServerTime() + iter1_6.waitTime
			var0_6 = iter1_6.waitTime

			break
		end
	end

	arg0_6.lockTime = pg.TimeMgr.GetInstance():GetServerTime() + var0_6
end

function var0_0.GetLockTime(arg0_7)
	return arg0_7.lockTime
end

function var0_0.GetAnswerFlag(arg0_8, arg1_8, arg2_8)
	local var0_8 = getProxy(PlayerProxy):getRawData().id

	local function var1_8(arg0_9, arg1_9)
		return PlayerPrefs.GetInt(arg0_9 .. "_" .. arg1_9 .. "_" .. var0_8, 0) > 0
	end

	return _.map(arg2_8, function(arg0_10)
		local var0_10 = var1_8(arg1_8, arg0_10[1])

		return {
			arg0_10[1],
			var0_10
		}
	end)
end

function var0_0.SetAnswerFlag(arg0_11, arg1_11, arg2_11)
	local var0_11 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(arg1_11 .. "_" .. arg2_11 .. "_" .. var0_11, 1)
	PlayerPrefs.Save()

	for iter0_11, iter1_11 in ipairs(arg0_11.questiones) do
		if iter1_11.id == arg1_11 then
			for iter2_11, iter3_11 in ipairs(iter1_11.answers) do
				if iter3_11[1] == arg2_11 then
					iter3_11[2] = true

					break
				end
			end
		end
	end
end

function var0_0.UpdateWrongAnswerFlag(arg0_12, arg1_12, arg2_12)
	local var0_12 = _.detect(arg0_12.questiones, function(arg0_13)
		return arg0_13.id == arg1_12
	end).answers[arg2_12]

	arg0_12:SetAnswerFlag(arg1_12, var0_12[1])
	arg0_12:SetNextTime(arg1_12)
end

function var0_0.UpdateRightAnswerFlag(arg0_14, arg1_14)
	if not table.contains(arg0_14.finishList, arg1_14) then
		table.insert(arg0_14.finishList, arg1_14)

		arg0_14.finishCount = arg0_14.finishCount + 1
	end

	arg0_14:GetQuestion(arg1_14).isFinish = true
	arg0_14.unlockCount = arg0_14.unlockCount - 1

	if arg0_14.unlockCount <= 0 then
		for iter0_14, iter1_14 in ipairs(arg0_14.questiones) do
			if not iter1_14.isFinish then
				iter1_14.isUnlock = false
			end
		end
	end
end

function var0_0.UpdateData(arg0_15, arg1_15)
	arg0_15.finishCount = arg1_15.finishCount or 0
	arg0_15.unlockCount = arg1_15.unlockCount or 0
	arg0_15.nextTimes = arg1_15.nextTimes
	arg0_15.finishList = arg1_15.finishList
	arg0_15.lockTime = arg0_15.nextTimes[#arg0_15.nextTimes]

	arg0_15:Init()
end

function var0_0.IsRight(arg0_16, arg1_16, arg2_16)
	return _.any(arg0_16.questiones, function(arg0_17)
		return arg1_16 == arg0_17.id and arg0_17.rightIndex == arg2_16
	end)
end

function var0_0.GetQuestiones(arg0_18)
	return arg0_18.questiones
end

function var0_0.GetQuestion(arg0_19, arg1_19)
	return _.detect(arg0_19.questiones, function(arg0_20)
		return arg0_20.id == arg1_19
	end)
end

function var0_0.Dispose(arg0_21)
	return
end

return var0_0

local var0_0 = class("LanternRiddlesController")

function var0_0.Ctor(arg0_1)
	arg0_1.model = LanternRiddlesModel.New(arg0_1)
	arg0_1.view = LanternRiddlesView.New(arg0_1)
end

function var0_0.SetCallBack(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.exitCallback = arg1_2
	arg0_2.onHome = arg2_2
	arg0_2.onSuccess = arg3_2
	arg0_2.onSaveData = arg4_2
end

function var0_0.SetUp(arg0_3, arg1_3)
	arg0_3.model:UpdateData(arg1_3)

	local var0_3 = arg0_3.model:GetQuestiones()

	arg0_3.view:UpdateDay(arg0_3.model.finishCount)
	arg0_3.view:InitLanternRiddles(var0_3)
end

function var0_0.SelectAnswer(arg0_4, arg1_4, arg2_4)
	local var0_4 = false

	if arg0_4.model:IsRight(arg1_4, arg2_4) then
		var0_4 = true

		arg0_4.model:UpdateRightAnswerFlag(arg1_4)

		if arg0_4.onSuccess then
			arg0_4.onSuccess()
		end

		arg0_4.view:UpdateDay(arg0_4.model.finishCount)

		if arg0_4.model.unlockCount <= 0 then
			arg0_4.view:RefreshLanterRiddles(arg0_4.model.questiones)
		end
	else
		arg0_4.model:UpdateWrongAnswerFlag(arg1_4, arg2_4)
	end

	if arg0_4.onSaveData then
		arg0_4.onSaveData()
	end

	local var1_4 = arg0_4.model:GetQuestion(arg1_4)

	arg0_4.view:OnUpdateAnswer(var1_4, arg2_4, var0_4)
end

function var0_0.GetLockTime(arg0_5)
	return arg0_5.model:GetLockTime()
end

function var0_0.ExitGame(arg0_6)
	if arg0_6.exitCallback then
		arg0_6.exitCallback()
	end
end

function var0_0.ExitGameAndGoHome(arg0_7)
	if arg0_7.onHome then
		arg0_7.onHome()
	end
end

function var0_0.GetSaveData(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in ipairs(arg0_8.model.questiones) do
		table.insert(var0_8, iter1_8.nextTime)
	end

	table.insert(var0_8, arg0_8.model.lockTime)

	local var1_8 = arg0_8.model.finishCount

	for iter2_8, iter3_8 in ipairs(arg0_8.model.finishList) do
		if var1_8 > 0 then
			table.insert(var0_8, iter3_8)

			var1_8 = var1_8 - 1
		end
	end

	return var0_8
end

function var0_0.Dispose(arg0_9)
	arg0_9.model:Dispose()
	arg0_9.view:Dispose()
end

return var0_0

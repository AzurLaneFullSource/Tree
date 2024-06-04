local var0 = class("LanternRiddlesController")

function var0.Ctor(arg0)
	arg0.model = LanternRiddlesModel.New(arg0)
	arg0.view = LanternRiddlesView.New(arg0)
end

function var0.SetCallBack(arg0, arg1, arg2, arg3, arg4)
	arg0.exitCallback = arg1
	arg0.onHome = arg2
	arg0.onSuccess = arg3
	arg0.onSaveData = arg4
end

function var0.SetUp(arg0, arg1)
	arg0.model:UpdateData(arg1)

	local var0 = arg0.model:GetQuestiones()

	arg0.view:UpdateDay(arg0.model.finishCount)
	arg0.view:InitLanternRiddles(var0)
end

function var0.SelectAnswer(arg0, arg1, arg2)
	local var0 = false

	if arg0.model:IsRight(arg1, arg2) then
		var0 = true

		arg0.model:UpdateRightAnswerFlag(arg1)

		if arg0.onSuccess then
			arg0.onSuccess()
		end

		arg0.view:UpdateDay(arg0.model.finishCount)

		if arg0.model.unlockCount <= 0 then
			arg0.view:RefreshLanterRiddles(arg0.model.questiones)
		end
	else
		arg0.model:UpdateWrongAnswerFlag(arg1, arg2)
	end

	if arg0.onSaveData then
		arg0.onSaveData()
	end

	local var1 = arg0.model:GetQuestion(arg1)

	arg0.view:OnUpdateAnswer(var1, arg2, var0)
end

function var0.GetLockTime(arg0)
	return arg0.model:GetLockTime()
end

function var0.ExitGame(arg0)
	if arg0.exitCallback then
		arg0.exitCallback()
	end
end

function var0.ExitGameAndGoHome(arg0)
	if arg0.onHome then
		arg0.onHome()
	end
end

function var0.GetSaveData(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.model.questiones) do
		table.insert(var0, iter1.nextTime)
	end

	table.insert(var0, arg0.model.lockTime)

	local var1 = arg0.model.finishCount

	for iter2, iter3 in ipairs(arg0.model.finishList) do
		if var1 > 0 then
			table.insert(var0, iter3)

			var1 = var1 - 1
		end
	end

	return var0
end

function var0.Dispose(arg0)
	arg0.model:Dispose()
	arg0.view:Dispose()
end

return var0

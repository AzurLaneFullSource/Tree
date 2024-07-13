local var0_0 = class("CourtYardBridge")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.core = arg1_1.core
	arg0_1.isSetup = false
	arg0_1.controller = arg0_1:System2Controller(arg1_1.system, arg1_1)
	arg0_1.view = CourtYardView.New(arg1_1.name, arg0_1.controller:GetStorey())

	if not arg0_1.handle then
		arg0_1.handle = UpdateBeat:CreateListener(arg0_1.Update, arg0_1)
	end

	UpdateBeat:AddListener(arg0_1.handle)
end

function var0_0.SetUp(arg0_2)
	if arg0_2.controller then
		arg0_2.isSetup = true

		arg0_2.controller:SetUp()
	end
end

function var0_0.Update(arg0_3)
	if not arg0_3.isSetup and arg0_3.view:IsInit() then
		arg0_3:SetUp()
	end

	if arg0_3.isSetup and arg0_3.controller then
		arg0_3.controller:Update()
	end
end

function var0_0.IsLoaed(arg0_4)
	if not arg0_4.controller then
		return false
	end

	return arg0_4.controller:IsLoaed()
end

function var0_0.GetView(arg0_5)
	return arg0_5.view
end

function var0_0.GetController(arg0_6)
	return arg0_6.controller
end

function var0_0.Exit(arg0_7)
	if arg0_7.controller then
		arg0_7.controller:Dispose()

		arg0_7.controller = nil
	end

	if arg0_7.view then
		arg0_7.view:Dispose()

		arg0_7.view = nil
	end
end

function var0_0.SendNotification(arg0_8, arg1_8, arg2_8)
	if arg0_8.core then
		arg0_8.core:sendNotification(arg1_8, arg2_8)
	end
end

function var0_0.Dispose(arg0_9)
	if arg0_9.handle then
		UpdateBeat:RemoveListener(arg0_9.handle)
	end

	arg0_9:Exit()
end

function var0_0.System2Controller(arg0_10, arg1_10, arg2_10)
	if arg1_10 == CourtYardConst.SYSTEM_FEAST then
		return CourtYardFeastController.New(arg0_10, arg2_10)
	else
		return CourtYardController.New(arg0_10, arg2_10)
	end
end

return var0_0

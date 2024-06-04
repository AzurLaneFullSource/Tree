local var0 = class("CourtYardBridge")

function var0.Ctor(arg0, arg1)
	arg0.core = arg1.core
	arg0.isSetup = false
	arg0.controller = arg0:System2Controller(arg1.system, arg1)
	arg0.view = CourtYardView.New(arg1.name, arg0.controller:GetStorey())

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.SetUp(arg0)
	if arg0.controller then
		arg0.isSetup = true

		arg0.controller:SetUp()
	end
end

function var0.Update(arg0)
	if not arg0.isSetup and arg0.view:IsInit() then
		arg0:SetUp()
	end

	if arg0.isSetup and arg0.controller then
		arg0.controller:Update()
	end
end

function var0.IsLoaed(arg0)
	if not arg0.controller then
		return false
	end

	return arg0.controller:IsLoaed()
end

function var0.GetView(arg0)
	return arg0.view
end

function var0.GetController(arg0)
	return arg0.controller
end

function var0.Exit(arg0)
	if arg0.controller then
		arg0.controller:Dispose()

		arg0.controller = nil
	end

	if arg0.view then
		arg0.view:Dispose()

		arg0.view = nil
	end
end

function var0.SendNotification(arg0, arg1, arg2)
	if arg0.core then
		arg0.core:sendNotification(arg1, arg2)
	end
end

function var0.Dispose(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	arg0:Exit()
end

function var0.System2Controller(arg0, arg1, arg2)
	if arg1 == CourtYardConst.SYSTEM_FEAST then
		return CourtYardFeastController.New(arg0, arg2)
	else
		return CourtYardController.New(arg0, arg2)
	end
end

return var0

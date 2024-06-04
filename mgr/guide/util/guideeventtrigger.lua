local var0 = class("GuideEventTrigger")

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5)
	pg.DelegateInfo.New(arg0)

	local var0

	if arg1 == GuideFindUIStep.TRIGGER_TYPE_BUTTON then
		var0 = arg0:HandleBtnTrigger(arg2, arg3, arg5)
	elseif arg1 == GuideFindUIStep.TRIGGER_TYPE_TOGGLE then
		var0 = arg0:HandleToggleTrigger(arg2, arg3, arg4, arg5)
	elseif arg1 == GuideFindUIStep.EVENT_TYPE_CLICK then
		var0 = arg0:HandleClickTrigger(arg2, arg3, arg5)
	elseif arg1 == GuideFindUIStep.EVENT_TYPE_STICK then
		var0 = arg0:HandleStickTrigger(arg2, arg3, arg5)
	elseif arg1 == GuideFindUIStep.SHOW_UI then
		var0 = arg0:HandleShowUITrigger(arg2, arg3, arg5)
	elseif arg1 == GuideFindUIStep.TRIGGER_TYPE_BUTTONEX then
		var0 = arg0:HandleBtnExTrigger(arg2, arg3, arg4, arg5)
	elseif arg1 == GuideFindUIStep.SNAP_PAGE then
		var0 = arg0:HandleSnapPageTrigger(arg2, arg3, arg4, arg5)
	elseif arg1 == GuideFindUIStep.EVENT_TYPE_EVT_CLICK then
		var0 = arg0:HandleEvtClickTrigger(arg2, arg3, arg5)
	end

	arg0.trigger = var0
end

function var0.Trigger(arg0)
	if arg0.trigger then
		arg0.trigger(true)
	end
end

function var0.HandleSnapPageTrigger(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg4
	local var1 = arg4

	if arg3 == -1 then
		var0 = nil
	end

	if arg3 == 1 then
		var1 = nil
	end

	addSlip(SLIP_TYPE_HRZ, arg1, var0, var1)

	return function()
		arg4()
	end
end

function var0.HandleBtnTrigger(arg0, arg1, arg2, arg3)
	local function var0()
		if IsNil(arg2) then
			return
		end

		triggerButton(arg2)
		arg3()
	end

	onButton(arg0, arg1, var0, SFX_PANEL)

	return var0
end

function var0.HandleBtnExTrigger(arg0, arg1, arg2, arg3, arg4)
	local function var0()
		if IsNil(arg2) then
			return
		end

		arg3()
		arg4()
	end

	onButton(arg0, arg1, var0, SFX_PANEL)

	return var0
end

function var0.HandleToggleTrigger(arg0, arg1, arg2, arg3, arg4)
	local function var0(arg0)
		if IsNil(arg2) then
			return
		end

		arg4()
		triggerToggle(arg2, arg0)
	end

	onToggle(arg0, arg1, var0, SFX_PANEL)

	return var0
end

function var0.HandleClickTrigger(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetComponent(typeof(EventTriggerListener))

	local function var1(arg0, arg1)
		arg3()

		if not IsNil(arg2) then
			var0:OnPointerUp(arg1)
		end
	end

	local var2 = arg1:GetComponent(typeof(EventTriggerListener))

	var2:AddPointDownFunc(function(arg0, arg1)
		if not IsNil(arg2) then
			var0:OnPointerDown(arg1)
		end
	end)
	var2:AddPointUpFunc(var1)

	return var1
end

function var0.HandleEvtClickTrigger(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetComponent(typeof(EventTriggerListener))

	local function var1(arg0, arg1)
		arg3()

		if not IsNil(arg2) then
			var0:OnPointerUp(arg1)
		end
	end

	local var2 = arg1:GetComponent(typeof(EventTriggerListener))

	var2:AddPointDownFunc(function(arg0, arg1)
		if not IsNil(arg2) then
			var0:OnPointerClick(arg1)
		end
	end)
	var2:AddPointUpFunc(var1)

	return var1
end

function var0.HandleStickTrigger(arg0, arg1, arg2, arg3)
	local function var0(arg0, arg1)
		if IsNil(arg2) then
			return
		end

		arg3()
	end

	GetOrAddComponent(arg1, typeof(EventTriggerListener)):AddPointDownFunc(var0)

	return var0
end

function var0.HandleShowUITrigger(arg0, arg1, arg2, arg3)
	local function var0(arg0, arg1)
		if IsNil(arg2) then
			return
		end

		arg3()
	end

	GetOrAddComponent(arg1, typeof(EventTriggerListener)):AddPointUpFunc(var0)

	return var0
end

function var0.Clear(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

return var0

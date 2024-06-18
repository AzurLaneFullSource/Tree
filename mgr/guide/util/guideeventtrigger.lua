local var0_0 = class("GuideEventTrigger")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	pg.DelegateInfo.New(arg0_1)

	local var0_1

	if arg1_1 == GuideFindUIStep.TRIGGER_TYPE_BUTTON then
		var0_1 = arg0_1:HandleBtnTrigger(arg2_1, arg3_1, arg5_1)
	elseif arg1_1 == GuideFindUIStep.TRIGGER_TYPE_TOGGLE then
		var0_1 = arg0_1:HandleToggleTrigger(arg2_1, arg3_1, arg4_1, arg5_1)
	elseif arg1_1 == GuideFindUIStep.EVENT_TYPE_CLICK then
		var0_1 = arg0_1:HandleClickTrigger(arg2_1, arg3_1, arg5_1)
	elseif arg1_1 == GuideFindUIStep.EVENT_TYPE_STICK then
		var0_1 = arg0_1:HandleStickTrigger(arg2_1, arg3_1, arg5_1)
	elseif arg1_1 == GuideFindUIStep.SHOW_UI then
		var0_1 = arg0_1:HandleShowUITrigger(arg2_1, arg3_1, arg5_1)
	elseif arg1_1 == GuideFindUIStep.TRIGGER_TYPE_BUTTONEX then
		var0_1 = arg0_1:HandleBtnExTrigger(arg2_1, arg3_1, arg4_1, arg5_1)
	elseif arg1_1 == GuideFindUIStep.SNAP_PAGE then
		var0_1 = arg0_1:HandleSnapPageTrigger(arg2_1, arg3_1, arg4_1, arg5_1)
	elseif arg1_1 == GuideFindUIStep.EVENT_TYPE_EVT_CLICK then
		var0_1 = arg0_1:HandleEvtClickTrigger(arg2_1, arg3_1, arg5_1)
	end

	arg0_1.trigger = var0_1
end

function var0_0.Trigger(arg0_2)
	if arg0_2.trigger then
		arg0_2.trigger(true)
	end
end

function var0_0.HandleSnapPageTrigger(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	local var0_3 = arg4_3
	local var1_3 = arg4_3

	if arg3_3 == -1 then
		var0_3 = nil
	end

	if arg3_3 == 1 then
		var1_3 = nil
	end

	addSlip(SLIP_TYPE_HRZ, arg1_3, var0_3, var1_3)

	return function()
		arg4_3()
	end
end

function var0_0.HandleBtnTrigger(arg0_5, arg1_5, arg2_5, arg3_5)
	local function var0_5()
		if IsNil(arg2_5) then
			return
		end

		triggerButton(arg2_5)
		arg3_5()
	end

	onButton(arg0_5, arg1_5, var0_5, SFX_PANEL)

	return var0_5
end

function var0_0.HandleBtnExTrigger(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	local function var0_7()
		if IsNil(arg2_7) then
			return
		end

		arg3_7()
		arg4_7()
	end

	onButton(arg0_7, arg1_7, var0_7, SFX_PANEL)

	return var0_7
end

function var0_0.HandleToggleTrigger(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	local function var0_9(arg0_10)
		if IsNil(arg2_9) then
			return
		end

		arg4_9()
		triggerToggle(arg2_9, arg0_10)
	end

	onToggle(arg0_9, arg1_9, var0_9, SFX_PANEL)

	return var0_9
end

function var0_0.HandleClickTrigger(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = arg2_11:GetComponent(typeof(EventTriggerListener))

	local function var1_11(arg0_12, arg1_12)
		arg3_11()

		if not IsNil(arg2_11) then
			var0_11:OnPointerUp(arg1_12)
		end
	end

	local var2_11 = arg1_11:GetComponent(typeof(EventTriggerListener))

	var2_11:AddPointDownFunc(function(arg0_13, arg1_13)
		if not IsNil(arg2_11) then
			var0_11:OnPointerDown(arg1_13)
		end
	end)
	var2_11:AddPointUpFunc(var1_11)

	return var1_11
end

function var0_0.HandleEvtClickTrigger(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14 = arg2_14:GetComponent(typeof(EventTriggerListener))

	local function var1_14(arg0_15, arg1_15)
		arg3_14()

		if not IsNil(arg2_14) then
			var0_14:OnPointerUp(arg1_15)
		end
	end

	local var2_14 = arg1_14:GetComponent(typeof(EventTriggerListener))

	var2_14:AddPointDownFunc(function(arg0_16, arg1_16)
		if not IsNil(arg2_14) then
			var0_14:OnPointerClick(arg1_16)
		end
	end)
	var2_14:AddPointUpFunc(var1_14)

	return var1_14
end

function var0_0.HandleStickTrigger(arg0_17, arg1_17, arg2_17, arg3_17)
	local function var0_17(arg0_18, arg1_18)
		if IsNil(arg2_17) then
			return
		end

		arg3_17()
	end

	GetOrAddComponent(arg1_17, typeof(EventTriggerListener)):AddPointDownFunc(var0_17)

	return var0_17
end

function var0_0.HandleShowUITrigger(arg0_19, arg1_19, arg2_19, arg3_19)
	local function var0_19(arg0_20, arg1_20)
		if IsNil(arg2_19) then
			return
		end

		arg3_19()
	end

	GetOrAddComponent(arg1_19, typeof(EventTriggerListener)):AddPointUpFunc(var0_19)

	return var0_19
end

function var0_0.Clear(arg0_21)
	pg.DelegateInfo.Dispose(arg0_21)
end

return var0_0

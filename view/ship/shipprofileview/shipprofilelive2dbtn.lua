local var0_0 = class("ShipProfileLive2dBtn")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._tf = arg1_1
	arg0_1.live2dBtn = arg1_1
	arg0_1.live2dToggle = arg0_1.live2dBtn:Find("toggle")
	arg0_1.live2dState = arg0_1.live2dBtn:Find("state")
	arg0_1.live2dOn = arg0_1.live2dToggle:Find("on")
	arg0_1.live2dOff = arg0_1.live2dToggle:Find("off")
	arg0_1.manager = BundleWizard.Inst:GetGroupMgr("L2D")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.paintingName = arg1_2
	arg0_2.isOn = arg2_2

	local var0_2 = arg0_2.manager
	local var1_2 = "live2d/" .. arg1_2
	local var2_2 = HXSet.autoHxShiftPath(var1_2, nil, true)
	local var3_2 = var0_2.state

	if var3_2 == DownloadState.None or var3_2 == DownloadState.CheckFailure then
		var0_2:CheckD()
	end

	local var4_2 = var0_2:CheckF(var2_2)

	if var4_2 == DownloadState.CheckToUpdate or var4_2 == DownloadState.UpdateFailure then
		arg0_2:OnCheckToUpdate(var2_2)
	elseif var4_2 == DownloadState.Updating then
		arg0_2:OnUpdating()
	else
		arg0_2:OnUpdated(var2_2, arg2_2)
	end

	arg0_2:AddTimer(var2_2, var4_2, arg1_2, arg2_2)
end

function var0_0.RemoveTimer(arg0_3)
	if arg0_3.live2dTimer then
		arg0_3.live2dTimer:Stop()

		arg0_3.live2dTimer = nil
	end
end

function var0_0.AddTimer(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	arg0_4:RemoveTimer()

	if arg2_4 == DownloadState.CheckToUpdate or arg2_4 == DownloadState.UpdateFailure or arg2_4 == DownloadState.Updating then
		arg0_4.live2dTimer = Timer.New(function()
			local var0_5 = arg0_4.manager:CheckF(arg1_4)

			arg0_4:Update(arg3_4, var0_5 == DownloadState.UpdateSuccess and true or arg4_4)
		end, 0.5, 1)

		arg0_4.live2dTimer:Start()
	end
end

function var0_0.OnCheckToUpdate(arg0_6, arg1_6)
	setActive(arg0_6.live2dBtn, true)
	setActive(arg0_6.live2dState, false)
	setActive(arg0_6.live2dToggle, true)
	setActive(arg0_6.live2dOn, false)
	setActive(arg0_6.live2dOff, true)
	onButton(arg0_6, arg0_6.live2dBtn, function()
		VersionMgr.Inst:RequestUIForUpdateF("L2D", arg1_6, true)
	end, SFX_PANEL)
end

function var0_0.OnUpdating(arg0_8)
	setActive(arg0_8.live2dBtn, true)
	setActive(arg0_8.live2dToggle, false)
	setActive(arg0_8.live2dState, true)
	removeOnButton(arg0_8.live2dBtn)
end

function var0_0.OnUpdated(arg0_9, arg1_9, arg2_9)
	local var0_9 = checkABExist(arg1_9)

	setActive(arg0_9.live2dBtn, var0_9)
	setActive(arg0_9.live2dState, false)
	setActive(arg0_9.live2dToggle, true)
	setActive(arg0_9.live2dOn, arg2_9)
	setActive(arg0_9.live2dOff, not arg2_9)
	onButton(arg0_9, arg0_9.live2dBtn, function()
		arg0_9:Update(arg0_9.paintingName, not arg0_9.isOn)
	end, SFX_PANEL)

	if arg0_9.callback then
		arg0_9.callback(arg0_9.isOn)
	end
end

function var0_0.Disable(arg0_11)
	if arg0_11.isOn then
		triggerButton(arg0_11.live2dBtn)
	end
end

function var0_0.SetEnable(arg0_12, arg1_12)
	setButtonEnabled(arg0_12.live2dBtn, arg1_12)
end

function var0_0.AddListener(arg0_13, arg1_13)
	arg0_13.callback = arg1_13
end

function var0_0.Dispose(arg0_14)
	arg0_14.callback = nil

	arg0_14:RemoveTimer()
	pg.DelegateInfo.Dispose(arg0_14)
end

return var0_0

local var0 = class("ShipProfileLive2dBtn")

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0._tf = arg1
	arg0.live2dBtn = arg1
	arg0.live2dToggle = arg0.live2dBtn:Find("toggle")
	arg0.live2dState = arg0.live2dBtn:Find("state")
	arg0.live2dOn = arg0.live2dToggle:Find("on")
	arg0.live2dOff = arg0.live2dToggle:Find("off")
	arg0.manager = BundleWizard.Inst:GetGroupMgr("L2D")
end

function var0.Update(arg0, arg1, arg2)
	arg0.paintingName = arg1
	arg0.isOn = arg2

	local var0 = arg0.manager
	local var1 = "live2d/" .. arg1
	local var2 = HXSet.autoHxShiftPath(var1, nil, true)
	local var3 = var0.state

	if var3 == DownloadState.None or var3 == DownloadState.CheckFailure then
		var0:CheckD()
	end

	local var4 = var0:CheckF(var2)

	if var4 == DownloadState.CheckToUpdate or var4 == DownloadState.UpdateFailure then
		arg0:OnCheckToUpdate(var2)
	elseif var4 == DownloadState.Updating then
		arg0:OnUpdating()
	else
		arg0:OnUpdated(var2, arg2)
	end

	arg0:AddTimer(var2, var4, arg1, arg2)
end

function var0.RemoveTimer(arg0)
	if arg0.live2dTimer then
		arg0.live2dTimer:Stop()

		arg0.live2dTimer = nil
	end
end

function var0.AddTimer(arg0, arg1, arg2, arg3, arg4)
	arg0:RemoveTimer()

	if arg2 == DownloadState.CheckToUpdate or arg2 == DownloadState.UpdateFailure or arg2 == DownloadState.Updating then
		arg0.live2dTimer = Timer.New(function()
			local var0 = arg0.manager:CheckF(arg1)

			arg0:Update(arg3, var0 == DownloadState.UpdateSuccess and true or arg4)
		end, 0.5, 1)

		arg0.live2dTimer:Start()
	end
end

function var0.OnCheckToUpdate(arg0, arg1)
	setActive(arg0.live2dBtn, true)
	setActive(arg0.live2dState, false)
	setActive(arg0.live2dToggle, true)
	setActive(arg0.live2dOn, false)
	setActive(arg0.live2dOff, true)
	onButton(arg0, arg0.live2dBtn, function()
		VersionMgr.Inst:RequestUIForUpdateF("L2D", arg1, true)
	end, SFX_PANEL)
end

function var0.OnUpdating(arg0)
	setActive(arg0.live2dBtn, true)
	setActive(arg0.live2dToggle, false)
	setActive(arg0.live2dState, true)
	removeOnButton(arg0.live2dBtn)
end

function var0.OnUpdated(arg0, arg1, arg2)
	local var0 = checkABExist(arg1)

	setActive(arg0.live2dBtn, var0)
	setActive(arg0.live2dState, false)
	setActive(arg0.live2dToggle, true)
	setActive(arg0.live2dOn, arg2)
	setActive(arg0.live2dOff, not arg2)
	onButton(arg0, arg0.live2dBtn, function()
		arg0:Update(arg0.paintingName, not arg0.isOn)
	end, SFX_PANEL)

	if arg0.callback then
		arg0.callback(arg0.isOn)
	end
end

function var0.Disable(arg0)
	if arg0.isOn then
		triggerButton(arg0.live2dBtn)
	end
end

function var0.SetEnable(arg0, arg1)
	setButtonEnabled(arg0.live2dBtn, arg1)
end

function var0.AddListener(arg0, arg1)
	arg0.callback = arg1
end

function var0.Dispose(arg0)
	arg0.callback = nil

	arg0:RemoveTimer()
	pg.DelegateInfo.Dispose(arg0)
end

return var0

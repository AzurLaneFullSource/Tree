local var0 = class("SkinShopDownloadRequest")

function var0.Ctor(arg0)
	arg0.downloadui = GameObject.Find("/OverlayCamera/Overlay/UIMain/DialogPanel")
end

function var0.Start(arg0, arg1, arg2)
	arg0:Refresh(true, arg1, arg2)
end

function var0.Refresh(arg0, arg1, arg2, arg3)
	local var0 = BundleWizard.Inst:GetGroupMgr("L2D")
	local var1 = var0.state

	if var1 == DownloadState.None or var1 == DownloadState.CheckFailure then
		var0:CheckD()
	end

	local var2 = false
	local var3 = false
	local var4 = var0:CheckF(arg2)

	if var4 == DownloadState.None then
		-- block empty
	elseif var4 == DownloadState.Checking then
		-- block empty
	elseif var4 == DownloadState.CheckToUpdate and arg1 then
		VersionMgr.Inst:RequestUIForUpdateF("L2D", arg2, true)
	elseif var4 == DownloadState.CheckToUpdate and not isActive(arg0.downloadui) then
		var3 = true
	elseif var4 == DownloadState.CheckOver then
		-- block empty
	elseif var4 == DownloadState.CheckFailure then
		var3 = true
	elseif var4 == DownloadState.Updating then
		-- block empty
	elseif var4 == DownloadState.UpdateFailure then
		var3 = true
	elseif var4 == DownloadState.UpdateSuccess then
		var3 = true
		var2 = checkABExist(arg2)
	end

	if arg0.live2dTimer then
		arg0.live2dTimer:Stop()

		arg0.live2dTimer = nil
	end

	if var4 == DownloadState.CheckToUpdate or var4 == DownloadState.UpdateFailure or var4 == DownloadState.Updating then
		arg0.live2dTimer = Timer.New(function()
			arg0:Refresh(false, arg2, arg3)
		end, 0.5, 1)

		arg0.live2dTimer:Start()
	end

	if var3 then
		arg3(var2)
	end
end

function var0.Dispose(arg0)
	if arg0.live2dTimer then
		arg0.live2dTimer:Stop()

		arg0.live2dTimer = nil
	end
end

return var0

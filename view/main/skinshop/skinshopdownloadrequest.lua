local var0_0 = class("SkinShopDownloadRequest")

function var0_0.Ctor(arg0_1)
	arg0_1.downloadui = GameObject.Find("/OverlayCamera/Overlay/UIMain/DialogPanel")
end

function var0_0.Start(arg0_2, arg1_2, arg2_2)
	arg0_2:Refresh(true, arg1_2, arg2_2)
end

function var0_0.Refresh(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = BundleWizard.Inst:GetGroupMgr("L2D")
	local var1_3 = var0_3.state

	if var1_3 == DownloadState.None or var1_3 == DownloadState.CheckFailure then
		var0_3:CheckD()
	end

	local var2_3 = false
	local var3_3 = false
	local var4_3 = var0_3:CheckF(arg2_3)

	if var4_3 == DownloadState.None then
		-- block empty
	elseif var4_3 == DownloadState.Checking then
		-- block empty
	elseif var4_3 == DownloadState.CheckToUpdate and arg1_3 then
		VersionMgr.Inst:RequestUIForUpdateF("L2D", arg2_3, true)
	elseif var4_3 == DownloadState.CheckToUpdate and not isActive(arg0_3.downloadui) then
		var3_3 = true
	elseif var4_3 == DownloadState.CheckOver then
		-- block empty
	elseif var4_3 == DownloadState.CheckFailure then
		var3_3 = true
	elseif var4_3 == DownloadState.Updating then
		-- block empty
	elseif var4_3 == DownloadState.UpdateFailure then
		var3_3 = true
	elseif var4_3 == DownloadState.UpdateSuccess then
		var3_3 = true
		var2_3 = checkABExist(arg2_3)
	end

	if arg0_3.live2dTimer then
		arg0_3.live2dTimer:Stop()

		arg0_3.live2dTimer = nil
	end

	if var4_3 == DownloadState.CheckToUpdate or var4_3 == DownloadState.UpdateFailure or var4_3 == DownloadState.Updating then
		arg0_3.live2dTimer = Timer.New(function()
			arg0_3:Refresh(false, arg2_3, arg3_3)
		end, 0.5, 1)

		arg0_3.live2dTimer:Start()
	end

	if var3_3 then
		arg3_3(var2_3)
	end
end

function var0_0.Dispose(arg0_5)
	if arg0_5.live2dTimer then
		arg0_5.live2dTimer:Stop()

		arg0_5.live2dTimer = nil
	end
end

return var0_0

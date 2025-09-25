local var0_0 = class("SkinShopDownloadRequest")

var0_0.Live2DGroupName = "L2D"

function var0_0.CalcListSize(arg0_1)
	local var0_1 = GroupHelper.CreateArrByLuaFileList(var0_0.Live2DGroupName, arg0_1)
	local var1_1 = GroupHelper.CalcSizeWithFileArr(var0_0.Live2DGroupName, var0_1)
	local var2_1 = HashUtil.BytesToString(var1_1)

	return var1_1, var2_1
end

function var0_0.Ctor(arg0_2)
	return
end

function var0_0.Start(arg0_3, arg1_3, arg2_3)
	arg0_3.filePath = arg1_3
	arg0_3.fileList = {
		arg1_3
	}
	arg0_3.onSuccess = arg2_3

	local var0_3, var1_3 = var0_0.CalcListSize({
		arg1_3
	})

	if var0_3 > 0 then
		local function var2_3()
			arg0_3:Download()
		end

		local function var3_3()
			arg0_3:success()
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			locked = true,
			type = MSGBOX_TYPE_NORMAL,
			content = string.format(i18n("group_download_tip", var1_3)),
			onYes = var2_3,
			onNo = var3_3,
			onClose = var3_3
		})
	else
		arg0_3:success()
	end
end

function var0_0.Download(arg0_6)
	local var0_6 = BundleWizardUpdateInfo.New()

	var0_6:AddGroup(var0_0.Live2DGroupName, arg0_6.fileList)

	var0_6.infoName = arg0_6.filePath

	if BundleWizardUpdater.Inst:GetFileList(var0_6).Count > 0 then
		local function var1_6(arg0_7, arg1_7)
			if arg0_7 then
				arg0_6:success()
			else
				arg0_6:error(arg0_6.filePath, "")
			end
		end

		BundleWizardUpdater.Inst:StartUpdate(var0_6, nil, var1_6, nil)
	else
		arg0_6:success()
	end
end

function var0_0.success(arg0_8)
	if arg0_8.onSuccess then
		arg0_8.onSuccess(checkABExist(arg0_8.filePath))
	end
end

function var0_0.error(arg0_9, arg1_9, arg2_9)
	local function var0_9()
		arg0_9:Download()
	end

	local function var1_9()
		arg0_9:success()
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		locked = true,
		content = i18n("file_down_mgr_error", arg1_9, arg2_9),
		onYes = var0_9,
		onNo = var1_9,
		onClose = var1_9
	})
end

function var0_0.Refresh(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = BundleWizard.Inst:GetGroupMgr("L2D")
	local var1_12 = var0_12.state

	if var1_12 == DownloadState.None or var1_12 == DownloadState.CheckFailure then
		var0_12:CheckD()
	end

	local var2_12 = false
	local var3_12 = false
	local var4_12 = var0_12:CheckF(arg2_12)

	if var4_12 == DownloadState.None then
		-- block empty
	elseif var4_12 == DownloadState.Checking then
		-- block empty
	elseif var4_12 == DownloadState.CheckToUpdate and arg1_12 then
		VersionMgr.Inst:RequestUIForUpdateF("L2D", arg2_12, true)
	elseif var4_12 == DownloadState.CheckToUpdate and not isActive(arg0_12.downloadui) then
		var3_12 = true
	elseif var4_12 == DownloadState.CheckOver then
		-- block empty
	elseif var4_12 == DownloadState.CheckFailure then
		var3_12 = true
	elseif var4_12 == DownloadState.Updating then
		-- block empty
	elseif var4_12 == DownloadState.UpdateFailure then
		var3_12 = true
	elseif var4_12 == DownloadState.UpdateSuccess then
		var3_12 = true
		var2_12 = checkABExist(arg2_12)
	end

	if arg0_12.live2dTimer then
		arg0_12.live2dTimer:Stop()

		arg0_12.live2dTimer = nil
	end

	if var4_12 == DownloadState.CheckToUpdate or var4_12 == DownloadState.UpdateFailure or var4_12 == DownloadState.Updating then
		arg0_12.live2dTimer = Timer.New(function()
			arg0_12:Refresh(false, arg2_12, arg3_12)
		end, 0.5, 1)

		arg0_12.live2dTimer:Start()
	end

	if var3_12 then
		arg3_12(var2_12)
	end
end

function var0_0.Dispose(arg0_14)
	if arg0_14.live2dTimer then
		arg0_14.live2dTimer:Stop()

		arg0_14.live2dTimer = nil
	end
end

return var0_0

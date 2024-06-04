local var0 = class("PlayerVitaeLive2dBtn", import(".PlayerVitaeBaseBtn"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)
	arg0:Load(arg0.tf)
	setActive(arg0.tf, true)
end

function var0.InitBtn(arg0)
	return
end

function var0.GetBgName(arg0)
	local var0
	local var1
	local var2 = arg0:IsHrzType() and "share/btn_l2d_atlas" or "admiralui_atlas"

	if arg0.ship and arg0.ship:GetSkinConfig().spine_use_live2d == 1 then
		var1 = arg0:IsHrzType() and "spine_painting_bg" or "sp"
	else
		var1 = arg0:IsHrzType() and "live2d_bg" or "l2d"
	end

	return var2, var1
end

function var0.IsActive(arg0)
	return true
end

function var0.Update(arg0, arg1, arg2, arg3)
	var0.super.Update(arg0, arg1, arg2, arg3)
	arg0:NewGo()
	arg0:RequesetLive2dRes()
end

function var0.RequesetLive2dRes(arg0)
	local var0 = arg0.ship
	local var1 = "live2d/" .. string.lower(var0:getPainting())
	local var2 = HXSet.autoHxShiftPath(var1, nil, true)

	arg0:StartCheckUpdate(var2)
end

function var0.StartCheckUpdate(arg0, arg1)
	local var0 = BundleWizard.Inst:GetGroupMgr("L2D")
	local var1 = var0.state

	if var1 == DownloadState.None or var1 == DownloadState.CheckFailure then
		var0:CheckD()
	end

	local var2 = var0:CheckF(arg1)

	if var2 == DownloadState.CheckToUpdate or var2 == DownloadState.UpdateFailure then
		arg0:ShowOrHide(true)
		arg0:UpdateBtnState(false, false)
		onButton(arg0, arg0.tf, function()
			VersionMgr.Inst:RequestUIForUpdateF("L2D", arg1, true)
		end, SFX_PANEL)
	elseif var2 == DownloadState.Updating then
		arg0:ShowOrHide(true)
		arg0:UpdateBtnState(true, false)
		removeOnButton(arg0.tf)
	else
		local var3 = checkABExist(arg1)

		arg0:ShowOrHide(var3)

		if var3 then
			arg0:UpdateBtnState(false, false)
			var0.super.InitBtn(arg0)
		end
	end

	if arg0.live2dTimer then
		arg0.live2dTimer:Stop()

		arg0.live2dTimer = nil
	end

	if var2 == DownloadState.CheckToUpdate or var2 == DownloadState.UpdateFailure or var2 == DownloadState.Updating then
		arg0.live2dTimer = Timer.New(function()
			arg0:StartCheckUpdate(arg1)
		end, 0.5, 1)

		arg0.live2dTimer:Start()
	end
end

function var0.GetDefaultValue(arg0)
	return getProxy(SettingsProxy):getCharacterSetting(arg0.ship.id, SHIP_FLAG_L2D)
end

function var0.OnSwitch(arg0, arg1)
	getProxy(SettingsProxy):setCharacterSetting(arg0.ship.id, SHIP_FLAG_L2D, arg1)

	return true
end

function var0.OnDispose(arg0)
	if arg0.live2dTimer then
		arg0.live2dTimer:Stop()

		arg0.live2dTimer = nil
	end
end

function var0.Load(arg0, arg1)
	var0.super.Load(arg0, arg1)

	if arg0:IsHrzType() then
		arg1.gameObject.name = "live2d"
	end

	arg0.tf:GetComponent(typeof(Image)):SetNativeSize()
end

return var0

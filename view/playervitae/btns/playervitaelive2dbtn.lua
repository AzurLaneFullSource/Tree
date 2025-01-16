local var0_0 = class("PlayerVitaeLive2dBtn", import(".PlayerVitaeBaseBtn"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1:Load(arg0_1.tf)
	setActive(arg0_1.tf, true)
end

function var0_0.InitBtn(arg0_2)
	return
end

function var0_0.GetBgName(arg0_3)
	local var0_3
	local var1_3
	local var2_3 = arg0_3:IsHrzType() and "share/btn_l2d_atlas" or "admiralui_atlas"

	if arg0_3.ship and arg0_3.ship:GetSkinConfig().spine_use_live2d == 1 then
		var1_3 = arg0_3:IsHrzType() and "spine_painting_bg" or "sp"
	else
		var1_3 = arg0_3:IsHrzType() and "live2d_bg" or "l2d"
	end

	return var2_3, var1_3
end

function var0_0.IsActive(arg0_4)
	return true
end

function var0_0.Update(arg0_5, arg1_5, arg2_5, arg3_5)
	var0_0.super.Update(arg0_5, arg1_5, arg2_5, arg3_5)
	arg0_5:NewGo()
	arg0_5:RequesetLive2dRes()
end

function var0_0.RequesetLive2dRes(arg0_6)
	local var0_6 = arg0_6.ship
	local var1_6 = "live2d/" .. string.lower(var0_6:getPainting())
	local var2_6 = HXSet.autoHxShiftPath(var1_6, nil, true)

	arg0_6:StartCheckUpdate(var2_6)
end

function var0_0.StartCheckUpdate(arg0_7, arg1_7)
	local var0_7 = BundleWizard.Inst:GetGroupMgr("L2D")
	local var1_7 = var0_7.state

	if var1_7 == DownloadState.None or var1_7 == DownloadState.CheckFailure then
		var0_7:CheckD()
	end

	local var2_7 = var0_7:CheckF(arg1_7)

	if var2_7 == DownloadState.CheckToUpdate or var2_7 == DownloadState.UpdateFailure then
		arg0_7:ShowOrHide(true)
		arg0_7:UpdateBtnState(false, false)
		onButton(arg0_7, arg0_7.tf, function()
			VersionMgr.Inst:RequestUIForUpdateF("L2D", arg1_7, true)
		end, SFX_PANEL)
	elseif var2_7 == DownloadState.Updating then
		arg0_7:ShowOrHide(true)
		arg0_7:UpdateBtnState(true, false)
		removeOnButton(arg0_7.tf)
	else
		local var3_7 = checkABExist(arg1_7)

		arg0_7:ShowOrHide(var3_7)

		if var3_7 then
			arg0_7:UpdateBtnState(false, false)
			var0_0.super.InitBtn(arg0_7)
		end
	end

	if arg0_7.live2dTimer then
		arg0_7.live2dTimer:Stop()

		arg0_7.live2dTimer = nil
	end

	if var2_7 == DownloadState.CheckToUpdate or var2_7 == DownloadState.UpdateFailure or var2_7 == DownloadState.Updating then
		arg0_7.live2dTimer = Timer.New(function()
			arg0_7:StartCheckUpdate(arg1_7)
		end, 0.5, 1)

		arg0_7.live2dTimer:Start()
	end
end

function var0_0.GetDefaultValue(arg0_10)
	return getProxy(SettingsProxy):getCharacterSetting(arg0_10.ship.id, SHIP_FLAG_L2D)
end

function var0_0.OnSwitch(arg0_11, arg1_11)
	if ShipGroup.GetChangeSkinData(arg0_11.ship.skinId) and true or false then
		getProxy(SettingsProxy):setCharacterSetting(arg0_11.ship.id, SHIP_FLAG_SP, arg1_11)
	end

	getProxy(SettingsProxy):setCharacterSetting(arg0_11.ship.id, SHIP_FLAG_L2D, arg1_11)

	return true
end

function var0_0.OnDispose(arg0_12)
	if arg0_12.live2dTimer then
		arg0_12.live2dTimer:Stop()

		arg0_12.live2dTimer = nil
	end
end

function var0_0.Load(arg0_13, arg1_13)
	var0_0.super.Load(arg0_13, arg1_13)

	if arg0_13:IsHrzType() then
		arg1_13.gameObject.name = "live2d"
	end

	arg0_13.tf:GetComponent(typeof(Image)):SetNativeSize()
end

return var0_0

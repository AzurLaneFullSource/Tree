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
	local var0_7 = BundleWizard.Inst:GetGroupMgr("L2D"):CheckF(arg1_7)

	if var0_7 == DownloadState.CheckToUpdate or var0_7 == DownloadState.UpdateFailure then
		arg0_7:ShowOrHide(true)
		arg0_7:UpdateBtnState(false, false)
		onButton(arg0_7, arg0_7.tf, function()
			if arg0_7.isDownloading then
				return
			end

			local var0_8 = "L2D"
			local var1_8 = {
				arg1_7
			}
			local var2_8 = var0_8 .. arg1_7
			local var3_8 = GroupHelper.CalcSizeWithFileArr(var0_8, var1_8)
			local var4_8 = HashUtil.BytesToString(var3_8)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_NORMAL,
				content = string.format(i18n("group_download_tip", var4_8)),
				onYes = function()
					local function var0_9(arg0_10, arg1_10)
						if not arg0_7.isDisposed then
							local var0_10 = checkABExist(arg1_7)

							arg0_7:ShowOrHide(var0_10)

							if var0_10 then
								arg0_7:UpdateBtnState(false, false)
								var0_0.super.InitBtn(arg0_7)
							end
						end

						arg0_7.isDownloading = false
					end

					local var1_9 = BundleWizardUpdater.Inst:GetFileList(var0_8, var1_8)
					local var2_9 = BundleWizardUpdater.Inst:CreateListInfo(var2_8, var1_9, nil, var0_9, nil)

					BundleWizardUpdater.Inst:StartUpdate(var2_9)

					arg0_7.isDownloading = true
				end
			})
		end, SFX_PANEL)
	else
		local var1_7 = checkABExist(arg1_7)

		arg0_7:ShowOrHide(var1_7)

		if var1_7 then
			arg0_7:UpdateBtnState(false, false)
			var0_0.super.InitBtn(arg0_7)
		end
	end
end

function var0_0.GetDefaultValue(arg0_11)
	local var0_11 = getProxy(SettingsProxy):getCharacterSetting(arg0_11.ship.id, SHIP_FLAG_L2D)

	if Live2dConst.GetLive2DArm32MatchAble() then
		if var0_11 then
			arg0_11:OnSwitch(false)
		end

		return false
	end

	return getProxy(SettingsProxy):getCharacterSetting(arg0_11.ship.id, SHIP_FLAG_L2D)
end

function var0_0.OnSwitch(arg0_12, arg1_12)
	if Live2dConst.GetLive2DArm32MatchAble() and arg1_12 then
		Live2dConst.ShowLive2DArm32Tips()

		return false
	end

	if ShipSkin.GetChangeSkinData(arg0_12.ship:getSkinId()) and true or false then
		getProxy(SettingsProxy):setCharacterSetting(arg0_12.ship.id, SHIP_FLAG_SP, arg1_12)
	end

	getProxy(SettingsProxy):setCharacterSetting(arg0_12.ship.id, SHIP_FLAG_L2D, arg1_12)

	return true
end

function var0_0.OnDispose(arg0_13)
	arg0_13.isDisposed = true
end

function var0_0.Load(arg0_14, arg1_14)
	var0_0.super.Load(arg0_14, arg1_14)

	if arg0_14:IsHrzType() then
		arg1_14.gameObject.name = "live2d"
	end

	arg0_14.tf:GetComponent(typeof(Image)):SetNativeSize()
end

return var0_0

local var0_0 = class("ShipProfileLive2dBtn")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._tf = arg1_1
	arg0_1.live2dBtn = arg1_1
	arg0_1.live2dToggle = arg0_1.live2dBtn:Find("toggle")
	arg0_1.live2dState = arg0_1.live2dBtn:Find("state")
	arg0_1.live2dOn = arg0_1.live2dToggle:Find("on")
	arg0_1.live2dOff = arg0_1.live2dToggle:Find("off")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	if Live2dConst.GetLive2DArm32MatchAble() then
		arg2_2 = false
	end

	arg0_2.paintingName = arg1_2
	arg0_2.isOn = arg2_2

	local var0_2 = BundleWizard.Inst:GetGroupMgr("L2D")
	local var1_2 = "live2d/" .. string.lower(arg1_2)
	local var2_2 = HXSet.autoHxShiftPath(var1_2, nil, true)
	local var3_2 = var0_2:CheckF(var2_2)

	warning("OnCheckToUpdate state = " .. tostring(var3_2))

	if var3_2 == DownloadState.CheckToUpdate or var3_2 == DownloadState.UpdateFailure then
		arg0_2:OnCheckToUpdate(var2_2)
	else
		arg0_2:OnUpdated(var2_2, arg2_2)
	end
end

function var0_0.OnCheckToUpdate(arg0_3, arg1_3)
	setActive(arg0_3.live2dBtn, true)
	setActive(arg0_3.live2dState, false)
	setActive(arg0_3.live2dToggle, true)
	setActive(arg0_3.live2dOn, false)
	setActive(arg0_3.live2dOff, true)
	onButton(arg0_3, arg0_3.live2dBtn, function()
		local var0_4 = "L2D"
		local var1_4 = {
			arg1_3
		}
		local var2_4 = var0_4 .. arg1_3
		local var3_4 = GroupHelper.CalcSizeWithFileArr(var0_4, var1_4)
		local var4_4 = HashUtil.BytesToString(var3_4)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_NORMAL,
			content = string.format(i18n("group_download_tip", var4_4)),
			onYes = function()
				local function var0_5(arg0_6, arg1_6)
					if not arg0_3.isDisposed then
						arg0_3.isOn = arg0_6

						arg0_3:OnUpdated(arg1_3, arg0_3.isOn)
					end
				end

				local var1_5 = BundleWizardUpdater.Inst:GetFileList(var0_4, var1_4)
				local var2_5 = BundleWizardUpdater.Inst:CreateListInfo(var2_4, var1_5, nil, var0_5, nil)

				BundleWizardUpdater.Inst:StartUpdate(var2_5)
			end
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdated(arg0_7, arg1_7, arg2_7)
	local var0_7 = checkABExist(arg1_7)

	warning("fileExist = " .. tostring(var0_7))
	setActive(arg0_7.live2dBtn, var0_7)
	setActive(arg0_7.live2dState, false)
	setActive(arg0_7.live2dToggle, true)
	setActive(arg0_7.live2dOn, arg2_7)
	setActive(arg0_7.live2dOff, not arg2_7)
	onButton(arg0_7, arg0_7.live2dBtn, function()
		if Live2dConst.GetLive2DArm32MatchAble() then
			Live2dConst.ShowLive2DArm32Tips()
		end

		arg0_7:Update(arg0_7.paintingName, not arg0_7.isOn)
	end, SFX_PANEL)

	if arg0_7.callback then
		arg0_7.callback(arg0_7.isOn)
	end
end

function var0_0.Disable(arg0_9)
	if arg0_9.isOn then
		triggerButton(arg0_9.live2dBtn)
	end
end

function var0_0.SetEnable(arg0_10, arg1_10)
	setButtonEnabled(arg0_10.live2dBtn, arg1_10)
end

function var0_0.AddListener(arg0_11, arg1_11)
	arg0_11.callback = arg1_11
end

function var0_0.Dispose(arg0_12)
	arg0_12.callback = nil
	arg0_12.isDisposed = true

	pg.DelegateInfo.Dispose(arg0_12)
end

return var0_0

local var0_0 = class("CheckHotfixCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().mediatorName

	if var0_1 and (string.find(var0_1, "Combat") or string.find(var0_1, "Battle")) then
		return
	end

	local var1_1 = getProxy(SettingsProxy)

	if PLATFORM_CODE == PLATFORM_US and VersionMgr.Inst:OnProxyUsing() then
		return
	end

	local var2_1 = BundleWizard.Inst:GetGroupMgr("DEFAULT_RES")

	if var2_1.CurrentVersion.Major > 0 and (not var1_1.lastRequestVersionTime or Time.realtimeSinceStartup - var1_1.lastRequestVersionTime > 1800) then
		var1_1.lastRequestVersionTime = Time.realtimeSinceStartup

		pg.UIMgr.GetInstance():LoadingOn()

		local var3_1 = true

		VersionMgr.Inst:FetchVersion(function(arg0_2)
			pg.UIMgr.GetInstance():LoadingOff()

			var3_1 = false

			if arg0_2.Major > var2_1.CurrentVersion.Major or arg0_2.Major == var2_1.CurrentVersion.Major and arg0_2.Minor > var2_1.CurrentVersion.Minor or arg0_2.Major == var2_1.CurrentVersion.Major and arg0_2.Minor == var2_1.CurrentVersion.Minor and arg0_2.Build > var2_1.CurrentVersion.Build then
				nowWorld().forceLock = true

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					modal = true,
					locked = true,
					hideNo = true,
					content = i18n("new_version_tip"),
					weight = LayerWeightConst.TOP_LAYER,
					onYes = function()
						Application.Quit()
					end,
					onClose = function()
						Application.Quit()
					end
				})
			end
		end)
		LeanTween.delayedCall(3, System.Action(function()
			if var3_1 then
				pg.UIMgr.GetInstance():LoadingOff()
			end
		end))
	end

	if var0_1 and string.find(var0_1, "LoginMediator") then
		var1_1.lastRequestVersionTime = nil
	end
end

return var0_0

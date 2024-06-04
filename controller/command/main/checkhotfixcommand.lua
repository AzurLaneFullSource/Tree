local var0 = class("CheckHotfixCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().mediatorName

	if var0 and (string.find(var0, "Combat") or string.find(var0, "Battle")) then
		return
	end

	local var1 = getProxy(SettingsProxy)

	if PLATFORM_CODE == PLATFORM_US and VersionMgr.Inst:OnProxyUsing() then
		return
	end

	local var2 = BundleWizard.Inst:GetGroupMgr("DEFAULT_RES")

	if var2.CurrentVersion.Major > 0 and (not var1.lastRequestVersionTime or Time.realtimeSinceStartup - var1.lastRequestVersionTime > 1800) then
		var1.lastRequestVersionTime = Time.realtimeSinceStartup

		pg.UIMgr.GetInstance():LoadingOn()

		local var3 = true

		VersionMgr.Inst:FetchVersion(function(arg0)
			pg.UIMgr.GetInstance():LoadingOff()

			var3 = false

			if arg0.Major > var2.CurrentVersion.Major or arg0.Major == var2.CurrentVersion.Major and arg0.Minor > var2.CurrentVersion.Minor or arg0.Major == var2.CurrentVersion.Major and arg0.Minor == var2.CurrentVersion.Minor and arg0.Build > var2.CurrentVersion.Build then
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
			if var3 then
				pg.UIMgr.GetInstance():LoadingOff()
			end
		end))
	end

	if var0 and string.find(var0, "LoginMediator") then
		var1.lastRequestVersionTime = nil
	end
end

return var0

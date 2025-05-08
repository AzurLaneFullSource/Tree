local var0_0 = class("SettingsDownloadableBtn")

function var0_0.InitTpl(arg0_1, arg1_1)
	local var0_1 = arg1_1.tpl
	local var1_1 = arg1_1.container
	local var2_1 = arg1_1.iconSP

	arg0_1._tf = cloneTplTo(var0_1, var1_1, arg0_1:GetDownloadGroup())
	arg0_1._go = arg0_1._tf.gameObject

	setImageSprite(arg0_1._tf:Find("icon"), var2_1)
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2:InitTpl(arg1_2)
	pg.DelegateInfo.New(arg0_2)

	arg0_2.loadProgress = findTF(arg0_2._tf, "progress")
	arg0_2.loadProgressHandle = findTF(arg0_2._tf, "progress/handle")
	arg0_2.loadInfo1 = findTF(arg0_2._tf, "status")
	arg0_2.loadInfo2 = findTF(arg0_2._tf, "version")
	arg0_2.loadLabelNew = findTF(arg0_2._tf, "version/new")
	arg0_2.loadDot = findTF(arg0_2._tf, "new")
	arg0_2.loadLoading = findTF(arg0_2._tf, "loading")

	setText(arg0_2._tf:Find("title"), arg0_2:GetTitle())
	arg0_2:Init()
	arg0_2:InitPrefsBar()
end

function var0_0.Init(arg0_3)
	setSlider(arg0_3.loadProgress, 0, 1, 0)
	setActive(arg0_3.loadDot, false)
	setActive(arg0_3.loadLoading, false)
	onButton(arg0_3, arg0_3._tf, function()
		local var0_4 = arg0_3:GetDownloadGroup()
		local var1_4 = pg.SettingsGroupMgr:GetInstance():GetState(var0_4)

		if arg0_3:isNeedUpdate() and var1_4 ~= pg.SettingsGroupMgr.State.Updating then
			local var2_4 = {
				var0_4
			}
			local var3_4 = pg.SettingsGroupMgr:GetInstance():GetTotalSize(var2_4)
			local var4_4 = HashUtil.BytesToString(var3_4)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_NORMAL,
				content = string.format(i18n("group_download_tip", var4_4)),
				onYes = function()
					pg.SettingsGroupMgr:GetInstance():StartDownload(var0_4, var2_4)
				end
			})
		end
	end, SFX_PANEL)
	arg0_3:Check()
end

function var0_0.InitPrefsBar(arg0_6)
	arg0_6.prefsBar = findTF(arg0_6._tf, "PrefsBar")

	setText(findTF(arg0_6.prefsBar, "Text"), i18n("setting_group_prefs_tip"))
	setActive(arg0_6.prefsBar, true)

	local var0_6 = arg0_6:GetDownloadGroup()

	arg0_6.hideTip = true

	onToggle(arg0_6, arg0_6.prefsBar, function(arg0_7)
		if arg0_7 == true then
			GroupHelper.SetGroupPrefsByName(var0_6, DMFileChecker.Prefs.Max)
		else
			GroupHelper.SetGroupPrefsByName(var0_6, DMFileChecker.Prefs.Min)
		end

		if not arg0_6.hideTip then
			pg.TipsMgr.GetInstance():ShowTips(i18n("group_prefs_switch_tip"))
		end
	end, SFX_PANEL)
	triggerToggle(arg0_6.prefsBar, GroupHelper.GetGroupPrefsByName(var0_6) == DMFileChecker.Prefs.Max)

	arg0_6.hideTip = false
end

function var0_0.Check(arg0_8)
	arg0_8.timer = Timer.New(function()
		arg0_8:UpdateDownLoadState()
	end, 0.5, -1)

	arg0_8.timer:Start()
	arg0_8:UpdateDownLoadState()
end

function var0_0.UpdateDownLoadState(arg0_10)
	local var0_10 = arg0_10:GetDownloadGroup()
	local var1_10 = BundleWizard.Inst:GetGroupMgr(var0_10)
	local var2_10
	local var3_10
	local var4_10
	local var5_10
	local var6_10
	local var7_10 = false
	local var8_10 = pg.SettingsGroupMgr:GetInstance():GetState(var0_10)
	local var9_10
	local var10_10
	local var11_10

	if IsUnityEditor then
		var9_10 = 1
		var11_10 = 1
	else
		var9_10 = tonumber(var1_10.localVersion.Build)
		var11_10 = tonumber(var1_10.serverVersion.Build)
	end

	if var8_10 == pg.SettingsGroupMgr.State.None then
		if var9_10 < var11_10 then
			var3_10 = i18n("word_maingroup_checktoupdate")
			var4_10 = string.format("V.%d > V.%d", var9_10, var11_10)
			var6_10 = true
		else
			var3_10 = i18n("word_maingroup_updatesuccess")
			var4_10 = string.format("V.%d", var1_10.CurrentVersion.Build)
			var6_10 = false
		end

		var5_10 = 0
		var7_10 = false
	elseif var8_10 == pg.SettingsGroupMgr.State.Updating then
		local var12_10, var13_10 = pg.SettingsGroupMgr:GetInstance():GetCountProgress(var0_10)

		var3_10 = i18n("word_maingroup_updating")
		var4_10 = string.format("(%d/%d)", var12_10, var13_10)
		var5_10 = var12_10 / math.max(var13_10, 1)
		var6_10 = false
		var7_10 = true
	elseif var8_10 == pg.SettingsGroupMgr.State.Success then
		var3_10 = i18n("word_maingroup_updatesuccess")
		var4_10 = "V." .. var1_10.CurrentVersion.Build
		var5_10 = 1
		var6_10 = false
		var7_10 = false
	elseif var8_10 == pg.SettingsGroupMgr.State.Fail then
		var3_10 = i18n("word_maingroup_updatefailure")

		if var9_10 < var11_10 then
			var4_10 = string.format("V.%d > V.%d", var9_10, var11_10)
		else
			var4_10 = string.format("V.%d", var1_10.CurrentVersion.Build)
		end

		var5_10 = 0
		var6_10 = true
		var7_10 = false
	end

	setText(arg0_10.loadInfo1, var3_10)
	setText(arg0_10.loadInfo2, var4_10)
	setSlider(arg0_10.loadProgress, 0, 1, var5_10)
	setActive(arg0_10.loadProgressHandle, var5_10 ~= 0 and var5_10 ~= 1)
	setActive(arg0_10.loadDot, var6_10)
	setActive(arg0_10.loadLoading, var7_10)
	setActive(arg0_10.loadLabelNew, var9_10 < var11_10)
end

function var0_0.Dispose(arg0_11)
	pg.DelegateInfo.Dispose(arg0_11)

	if arg0_11.timer then
		arg0_11.timer:Stop()

		arg0_11.timer = nil
	end
end

function var0_0.GetDownloadGroup(arg0_12)
	assert(false, "overwrite me !!!")
end

function var0_0.GetTitle(arg0_13)
	assert(false, "overwrite me !!!")
end

function var0_0.isNeedUpdate(arg0_14)
	local var0_14 = arg0_14:GetDownloadGroup()
	local var1_14 = BundleWizard.Inst:GetGroupMgr(var0_14)

	return tonumber(var1_14.localVersion.Build) < tonumber(var1_14.serverVersion.Build)
end

return var0_0

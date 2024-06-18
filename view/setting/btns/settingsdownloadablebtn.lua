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
	arg0_3:Check()
end

function var0_0.InitPrefsBar(arg0_4)
	arg0_4.prefsBar = findTF(arg0_4._tf, "PrefsBar")

	setText(findTF(arg0_4.prefsBar, "Text"), i18n("setting_group_prefs_tip"))
	setActive(arg0_4.prefsBar, true)

	local var0_4 = arg0_4:GetDownloadGroup()

	arg0_4.hideTip = true

	onToggle(arg0_4, arg0_4.prefsBar, function(arg0_5)
		if arg0_5 == true then
			GroupHelper.SetGroupPrefsByName(var0_4, DMFileChecker.Prefs.Max)
		else
			GroupHelper.SetGroupPrefsByName(var0_4, DMFileChecker.Prefs.Min)
		end

		if not arg0_4.hideTip then
			pg.TipsMgr.GetInstance():ShowTips(i18n("group_prefs_switch_tip"))
		end
	end, SFX_PANEL)
	triggerToggle(arg0_4.prefsBar, GroupHelper.GetGroupPrefsByName(var0_4) == DMFileChecker.Prefs.Max)

	arg0_4.hideTip = false
end

function var0_0.Check(arg0_6)
	local var0_6 = arg0_6:GetDownloadGroup()
	local var1_6 = BundleWizard.Inst:GetGroupMgr(var0_6)

	arg0_6.timer = Timer.New(function()
		arg0_6:UpdateDownLoadState()
	end, 0.5, -1)

	arg0_6.timer:Start()
	arg0_6:UpdateDownLoadState()

	if var1_6.state == DownloadState.None then
		var1_6:CheckD()
	end

	onButton(arg0_6, arg0_6._tf, function()
		local var0_8 = var1_6.state

		if var0_8 == DownloadState.CheckFailure then
			var1_6:CheckD()
		elseif var0_8 == DownloadState.CheckToUpdate or var0_8 == DownloadState.UpdateFailure then
			VersionMgr.Inst:RequestUIForUpdateD(var0_6, true)
		end
	end, SFX_PANEL)
end

function var0_0.UpdateDownLoadState(arg0_9)
	local var0_9 = arg0_9:GetDownloadGroup()
	local var1_9 = BundleWizard.Inst:GetGroupMgr(var0_9)
	local var2_9 = var1_9.state
	local var3_9
	local var4_9
	local var5_9
	local var6_9
	local var7_9
	local var8_9 = false

	if var2_9 == DownloadState.None then
		local var9_9 = arg0_9:GetLocaltion(var2_9, 1)

		var4_9 = arg0_9:GetLocaltion(var2_9, 2)
		var5_9 = "DOWNLOAD"
		var6_9 = 0
		var7_9 = false
	elseif var2_9 == DownloadState.Checking then
		local var10_9 = arg0_9:GetLocaltion(var2_9, 1)

		var4_9 = arg0_9:GetLocaltion(var2_9, 2)
		var5_9 = "CHECKING"
		var6_9 = 0
		var7_9 = false
	elseif var2_9 == DownloadState.CheckToUpdate then
		local var11_9 = arg0_9:GetLocaltion(var2_9, 1)

		var4_9 = arg0_9:GetLocaltion(var2_9, 2)
		var5_9 = string.format("V.%d > V.%d", var1_9.localVersion.Build, var1_9.serverVersion.Build)
		var6_9 = 0
		var7_9 = true
	elseif var2_9 == DownloadState.CheckOver then
		local var12_9 = arg0_9:GetLocaltion(var2_9, 1)

		var4_9 = arg0_9:GetLocaltion(var2_9, 2)
		var5_9 = "V." .. var1_9.CurrentVersion.Build
		var6_9 = 1
		var7_9 = false
	elseif var2_9 == DownloadState.CheckFailure then
		local var13_9 = arg0_9:GetLocaltion(var2_9, 1)

		var4_9 = arg0_9:GetLocaltion(var2_9, 2)
		var5_9 = string.format("ERROR(CODE:%d)", var1_9.errorCode)
		var6_9 = 0
		var7_9 = false
	elseif var2_9 == DownloadState.Updating then
		local var14_9 = arg0_9:GetLocaltion(var2_9, 1)

		var4_9 = string.format("(%d/%d)", var1_9.downloadCount, var1_9.downloadTotal)
		var5_9 = var1_9.downPath
		var6_9 = var1_9.downloadCount / math.max(var1_9.downloadTotal, 1)
		var7_9 = false
		var8_9 = true
	elseif var2_9 == DownloadState.UpdateSuccess then
		local var15_9 = arg0_9:GetLocaltion(var2_9, 1)

		var4_9 = arg0_9:GetLocaltion(var2_9, 2)
		var5_9 = "V." .. var1_9.CurrentVersion.Build
		var6_9 = 1
		var7_9 = false
	elseif var2_9 == DownloadState.UpdateFailure then
		local var16_9 = arg0_9:GetLocaltion(var2_9, 1)

		var4_9 = arg0_9:GetLocaltion(var2_9, 2)
		var5_9 = string.format("ERROR(CODE:%d)", var1_9.errorCode)
		var6_9 = var1_9.downloadCount / math.max(var1_9.downloadTotal, 1)
		var7_9 = true
	end

	if var5_9:len() > 15 then
		var5_9 = var5_9:sub(1, 12) .. "..."
	end

	setText(arg0_9.loadInfo1, var4_9)
	setText(arg0_9.loadInfo2, var5_9)
	setSlider(arg0_9.loadProgress, 0, 1, var6_9)
	setActive(arg0_9.loadProgressHandle, var6_9 ~= 0 and var6_9 ~= 1)
	setActive(arg0_9.loadDot, var7_9)
	setActive(arg0_9.loadLoading, var8_9)
	setActive(arg0_9.loadLabelNew, var2_9 == DownloadState.CheckToUpdate)
end

function var0_0.Dispose(arg0_10)
	pg.DelegateInfo.Dispose(arg0_10)

	if arg0_10.timer then
		arg0_10.timer:Stop()

		arg0_10.timer = nil
	end
end

function var0_0.GetDownloadGroup(arg0_11)
	assert(false, "overwrite me !!!")
end

function var0_0.GetLocaltion(arg0_12, arg1_12, arg2_12)
	assert(false, "overwrite me !!!")
end

function var0_0.GetTitle(arg0_13)
	assert(false, "overwrite me !!!")
end

return var0_0

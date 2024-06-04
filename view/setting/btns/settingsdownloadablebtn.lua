local var0 = class("SettingsDownloadableBtn")

function var0.InitTpl(arg0, arg1)
	local var0 = arg1.tpl
	local var1 = arg1.container
	local var2 = arg1.iconSP

	arg0._tf = cloneTplTo(var0, var1, arg0:GetDownloadGroup())
	arg0._go = arg0._tf.gameObject

	setImageSprite(arg0._tf:Find("icon"), var2)
end

function var0.Ctor(arg0, arg1)
	arg0:InitTpl(arg1)
	pg.DelegateInfo.New(arg0)

	arg0.loadProgress = findTF(arg0._tf, "progress")
	arg0.loadProgressHandle = findTF(arg0._tf, "progress/handle")
	arg0.loadInfo1 = findTF(arg0._tf, "status")
	arg0.loadInfo2 = findTF(arg0._tf, "version")
	arg0.loadLabelNew = findTF(arg0._tf, "version/new")
	arg0.loadDot = findTF(arg0._tf, "new")
	arg0.loadLoading = findTF(arg0._tf, "loading")

	setText(arg0._tf:Find("title"), arg0:GetTitle())
	arg0:Init()
	arg0:InitPrefsBar()
end

function var0.Init(arg0)
	setSlider(arg0.loadProgress, 0, 1, 0)
	setActive(arg0.loadDot, false)
	setActive(arg0.loadLoading, false)
	arg0:Check()
end

function var0.InitPrefsBar(arg0)
	arg0.prefsBar = findTF(arg0._tf, "PrefsBar")

	setText(findTF(arg0.prefsBar, "Text"), i18n("setting_group_prefs_tip"))
	setActive(arg0.prefsBar, true)

	local var0 = arg0:GetDownloadGroup()

	arg0.hideTip = true

	onToggle(arg0, arg0.prefsBar, function(arg0)
		if arg0 == true then
			GroupHelper.SetGroupPrefsByName(var0, DMFileChecker.Prefs.Max)
		else
			GroupHelper.SetGroupPrefsByName(var0, DMFileChecker.Prefs.Min)
		end

		if not arg0.hideTip then
			pg.TipsMgr.GetInstance():ShowTips(i18n("group_prefs_switch_tip"))
		end
	end, SFX_PANEL)
	triggerToggle(arg0.prefsBar, GroupHelper.GetGroupPrefsByName(var0) == DMFileChecker.Prefs.Max)

	arg0.hideTip = false
end

function var0.Check(arg0)
	local var0 = arg0:GetDownloadGroup()
	local var1 = BundleWizard.Inst:GetGroupMgr(var0)

	arg0.timer = Timer.New(function()
		arg0:UpdateDownLoadState()
	end, 0.5, -1)

	arg0.timer:Start()
	arg0:UpdateDownLoadState()

	if var1.state == DownloadState.None then
		var1:CheckD()
	end

	onButton(arg0, arg0._tf, function()
		local var0 = var1.state

		if var0 == DownloadState.CheckFailure then
			var1:CheckD()
		elseif var0 == DownloadState.CheckToUpdate or var0 == DownloadState.UpdateFailure then
			VersionMgr.Inst:RequestUIForUpdateD(var0, true)
		end
	end, SFX_PANEL)
end

function var0.UpdateDownLoadState(arg0)
	local var0 = arg0:GetDownloadGroup()
	local var1 = BundleWizard.Inst:GetGroupMgr(var0)
	local var2 = var1.state
	local var3
	local var4
	local var5
	local var6
	local var7
	local var8 = false

	if var2 == DownloadState.None then
		local var9 = arg0:GetLocaltion(var2, 1)

		var4 = arg0:GetLocaltion(var2, 2)
		var5 = "DOWNLOAD"
		var6 = 0
		var7 = false
	elseif var2 == DownloadState.Checking then
		local var10 = arg0:GetLocaltion(var2, 1)

		var4 = arg0:GetLocaltion(var2, 2)
		var5 = "CHECKING"
		var6 = 0
		var7 = false
	elseif var2 == DownloadState.CheckToUpdate then
		local var11 = arg0:GetLocaltion(var2, 1)

		var4 = arg0:GetLocaltion(var2, 2)
		var5 = string.format("V.%d > V.%d", var1.localVersion.Build, var1.serverVersion.Build)
		var6 = 0
		var7 = true
	elseif var2 == DownloadState.CheckOver then
		local var12 = arg0:GetLocaltion(var2, 1)

		var4 = arg0:GetLocaltion(var2, 2)
		var5 = "V." .. var1.CurrentVersion.Build
		var6 = 1
		var7 = false
	elseif var2 == DownloadState.CheckFailure then
		local var13 = arg0:GetLocaltion(var2, 1)

		var4 = arg0:GetLocaltion(var2, 2)
		var5 = string.format("ERROR(CODE:%d)", var1.errorCode)
		var6 = 0
		var7 = false
	elseif var2 == DownloadState.Updating then
		local var14 = arg0:GetLocaltion(var2, 1)

		var4 = string.format("(%d/%d)", var1.downloadCount, var1.downloadTotal)
		var5 = var1.downPath
		var6 = var1.downloadCount / math.max(var1.downloadTotal, 1)
		var7 = false
		var8 = true
	elseif var2 == DownloadState.UpdateSuccess then
		local var15 = arg0:GetLocaltion(var2, 1)

		var4 = arg0:GetLocaltion(var2, 2)
		var5 = "V." .. var1.CurrentVersion.Build
		var6 = 1
		var7 = false
	elseif var2 == DownloadState.UpdateFailure then
		local var16 = arg0:GetLocaltion(var2, 1)

		var4 = arg0:GetLocaltion(var2, 2)
		var5 = string.format("ERROR(CODE:%d)", var1.errorCode)
		var6 = var1.downloadCount / math.max(var1.downloadTotal, 1)
		var7 = true
	end

	if var5:len() > 15 then
		var5 = var5:sub(1, 12) .. "..."
	end

	setText(arg0.loadInfo1, var4)
	setText(arg0.loadInfo2, var5)
	setSlider(arg0.loadProgress, 0, 1, var6)
	setActive(arg0.loadProgressHandle, var6 ~= 0 and var6 ~= 1)
	setActive(arg0.loadDot, var7)
	setActive(arg0.loadLoading, var8)
	setActive(arg0.loadLabelNew, var2 == DownloadState.CheckToUpdate)
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.GetDownloadGroup(arg0)
	assert(false, "overwrite me !!!")
end

function var0.GetLocaltion(arg0, arg1, arg2)
	assert(false, "overwrite me !!!")
end

function var0.GetTitle(arg0)
	assert(false, "overwrite me !!!")
end

return var0

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

	local var0_2 = arg1_2.isDel or false

	arg0_2.delBtn = findTF(arg0_2._tf, "DelBtn")

	setActive(arg0_2.delBtn, var0_2)

	local var1_2 = arg0_2.delBtn:Find("Text")

	setText(var1_2, i18n("resource_clear_generaltext"))

	local var2_2 = arg0_2._tf:Find("BG")
	local var3_2 = arg0_2._tf:Find("BGDel")

	setActive(var2_2, not var0_2)
	setActive(var3_2, var0_2)

	local var4_2 = arg0_2._tf:Find("status")
	local var5_2 = arg0_2._tf:Find("version")

	setAnchoredPosition(var4_2, var0_2 and {
		y = -106
	} or {
		y = -135
	})
	setAnchoredPosition(var5_2, var0_2 and {
		y = -160
	} or {
		y = -198
	})
	arg0_2:Init()
	arg0_2:InitPrefsBar()
end

function var0_0.Init(arg0_3)
	setSlider(arg0_3.loadProgress, 0, 1, 0)
	setActive(arg0_3.loadDot, false)
	setActive(arg0_3.loadLoading, false)
	onButton(arg0_3, arg0_3._tf, function()
		if Live2dConst.GetLive2DArm32MatchAble() then
			Live2dConst.ShowLive2DArm32Tips()

			return
		end

		local var0_4 = arg0_3:GetDownloadGroup()
		local var1_4 = pg.SettingsGroupMgr.GetInstance():GetState(var0_4)

		if arg0_3:isNeedUpdate() and var1_4 ~= pg.SettingsGroupMgr.State.Updating then
			local var2_4 = {
				var0_4
			}
			local var3_4 = pg.SettingsGroupMgr.GetInstance():GetTotalSize(var2_4)
			local var4_4 = HashUtil.BytesToString(var3_4)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_NORMAL,
				content = string.format(i18n("group_download_tip", var4_4)),
				onYes = function()
					pg.SettingsGroupMgr.GetInstance():StartDownload(var0_4, var2_4)
				end
			})
		end
	end, SFX_PANEL)

	if isActive(arg0_3.delBtn) then
		onButton(arg0_3, arg0_3.delBtn, function()
			local var0_6 = arg0_3:GetDownloadGroup()
			local var1_6 = GroupHelper.GetGroupMgrByName(var0_6)
			local var2_6 = HashUtil.BytesToString(var1_6:GetAllCacheFileSize())
			local var3_6 = arg0_3:getDelTipName()
			local var4_6 = i18n(var3_6, var2_6)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_CONFIRM,
				content = var4_6,
				onYes = function()
					GroupHelper.SetGroupPrefsByName(var0_6, DMFileChecker.Prefs.Min)

					local var0_7 = HotfixHelper.GetAllShortPathArrInGroup(var0_6)

					if var0_7 and var0_7.Length > 0 then
						HotfixHelper.DeleteFileByShortPathArr(var0_6, var0_7)
					end
				end
			})
		end, SFX_PANEL)
	end

	arg0_3:Check()
end

function var0_0.InitPrefsBar(arg0_8)
	arg0_8.prefsBar = findTF(arg0_8._tf, "PrefsBar")

	setText(findTF(arg0_8.prefsBar, "Text"), i18n("setting_group_prefs_tip"))
	setActive(arg0_8.prefsBar, true)

	local var0_8 = arg0_8:GetDownloadGroup()

	arg0_8.hideTip = true

	onToggle(arg0_8, arg0_8.prefsBar, function(arg0_9)
		if Live2dConst.GetLive2DArm32MatchAble() then
			if arg0_9 then
				Live2dConst.ShowLive2DArm32Tips()
				triggerToggle(arg0_8.prefsBar, false)
			end

			return
		end

		if arg0_9 == true then
			GroupHelper.SetGroupPrefsByName(var0_8, DMFileChecker.Prefs.Max)
		else
			GroupHelper.SetGroupPrefsByName(var0_8, DMFileChecker.Prefs.Min)
		end

		if not arg0_8.hideTip then
			pg.TipsMgr.GetInstance():ShowTips(i18n("group_prefs_switch_tip"))
		end
	end, SFX_PANEL)
	triggerToggle(arg0_8.prefsBar, GroupHelper.GetGroupPrefsByName(var0_8) == DMFileChecker.Prefs.Max)

	arg0_8.hideTip = false
end

function var0_0.Check(arg0_10)
	arg0_10.timer = Timer.New(function()
		arg0_10:UpdateDownLoadState()
	end, 0.5, -1)

	arg0_10.timer:Start()
	arg0_10:UpdateDownLoadState()
end

function var0_0.UpdateDownLoadState(arg0_12)
	local var0_12 = arg0_12:GetDownloadGroup()
	local var1_12 = BundleWizard.Inst:GetGroupMgr(var0_12)
	local var2_12
	local var3_12
	local var4_12
	local var5_12
	local var6_12
	local var7_12 = false
	local var8_12 = pg.SettingsGroupMgr.GetInstance():GetState(var0_12)
	local var9_12
	local var10_12
	local var11_12

	if IsUnityEditor then
		var9_12 = 1
		var11_12 = 1
	else
		var9_12 = tonumber(var1_12.localVersion.Build)
		var11_12 = tonumber(var1_12.serverVersion.Build)
	end

	if var8_12 == pg.SettingsGroupMgr.State.None then
		if var9_12 < var11_12 then
			var3_12 = i18n("word_maingroup_checktoupdate")
			var4_12 = string.format("V.%d > V.%d", var9_12, var11_12)
			var6_12 = true
		else
			var3_12 = i18n("word_maingroup_updatesuccess")
			var4_12 = string.format("V.%d", var1_12.CurrentVersion.Build)
			var6_12 = false
		end

		var5_12 = 0
		var7_12 = false
	elseif var8_12 == pg.SettingsGroupMgr.State.Updating then
		local var12_12, var13_12 = pg.SettingsGroupMgr.GetInstance():GetCountProgress(var0_12)

		var3_12 = i18n("word_maingroup_updating")
		var4_12 = string.format("(%d/%d)", var12_12, var13_12)
		var5_12 = var12_12 / math.max(var13_12, 1)
		var6_12 = false
		var7_12 = true
	elseif var8_12 == pg.SettingsGroupMgr.State.Success then
		var3_12 = i18n("word_maingroup_updatesuccess")
		var4_12 = "V." .. var1_12.CurrentVersion.Build
		var5_12 = 1
		var6_12 = false
		var7_12 = false
	elseif var8_12 == pg.SettingsGroupMgr.State.Fail then
		var3_12 = i18n("word_maingroup_updatefailure")

		if var9_12 < var11_12 then
			var4_12 = string.format("V.%d > V.%d", var9_12, var11_12)
		else
			var4_12 = string.format("V.%d", var1_12.CurrentVersion.Build)
		end

		var5_12 = 0
		var6_12 = true
		var7_12 = false
	end

	setText(arg0_12.loadInfo1, var3_12)
	setText(arg0_12.loadInfo2, var4_12)
	setSlider(arg0_12.loadProgress, 0, 1, var5_12)
	setActive(arg0_12.loadProgressHandle, var5_12 ~= 0 and var5_12 ~= 1)
	setActive(arg0_12.loadDot, var6_12)
	setActive(arg0_12.loadLoading, var7_12)
	setActive(arg0_12.loadLabelNew, var9_12 < var11_12)
end

function var0_0.Dispose(arg0_13)
	pg.DelegateInfo.Dispose(arg0_13)

	if arg0_13.timer then
		arg0_13.timer:Stop()

		arg0_13.timer = nil
	end
end

function var0_0.GetDownloadGroup(arg0_14)
	assert(false, "overwrite me !!!")
end

function var0_0.GetTitle(arg0_15)
	assert(false, "overwrite me !!!")
end

function var0_0.isNeedUpdate(arg0_16)
	if IsUnityEditor then
		return false
	end

	local var0_16 = arg0_16:GetDownloadGroup()
	local var1_16 = BundleWizard.Inst:GetGroupMgr(var0_16)

	return tonumber(var1_16.localVersion.Build) < tonumber(var1_16.serverVersion.Build)
end

function var0_0.getDelTipName(arg0_17)
	return ({
		DORM = "resource_clear_3ddorm",
		GALLERY_PIC = "resource_clear_gallery",
		MANGA = "resource_clear_manga",
		MAP = "resource_clear_3disland"
	})[arg0_17:GetDownloadGroup()]
end

return var0_0

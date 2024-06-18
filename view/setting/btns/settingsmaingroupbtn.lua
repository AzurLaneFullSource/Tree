local var0_0 = class("SettingsMainGroupBtn")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)
	arg0_1:initData()
	arg0_1:findUI(arg1_1)
	arg0_1:addListener()
	arg0_1:check()
end

function var0_0.Dispose(arg0_2)
	pg.DelegateInfo.Dispose(arg0_2)

	if arg0_2.timer then
		arg0_2.timer:Stop()

		arg0_2.timer = nil
	end
end

function var0_0.initData(arg0_3)
	arg0_3.mgr = pg.MainGroupMgr:GetInstance()
end

function var0_0.findUI(arg0_4, arg1_4)
	arg0_4._tf = arg1_4

	local var0_4 = findTF(arg0_4._tf, "Content")

	arg0_4.titleText = findTF(var0_4, "Title")
	arg0_4.progressBar = findTF(var0_4, "Progress")
	arg0_4.btn = findTF(var0_4, "Btn")
	arg0_4.btnText = findTF(arg0_4.btn, "Text")
	arg0_4.loadingIcon = findTF(var0_4, "Status/Loading")
	arg0_4.newIcon = findTF(var0_4, "Status/New")
	arg0_4.finishIcon = findTF(var0_4, "Status/Finish")

	setText(arg0_4.titleText, i18n("setting_resdownload_title_main_group"))
end

function var0_0.addListener(arg0_5)
	onButton(arg0_5, arg0_5._tf, function()
		local var0_6 = arg0_5.mgr:GetState()

		if var0_6 == DownloadState.CheckFailure then
			arg0_5.mgr:StartCheckD()
		elseif var0_6 == DownloadState.CheckToUpdate or var0_6 == DownloadState.UpdateFailure then
			local var1_6 = arg0_5.mgr:GetTotalSize()
			local var2_6 = HashUtil.BytesToString(var1_6)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_NORMAL,
				content = string.format(i18n("main_group_msgbox_content", var2_6)),
				onYes = function()
					GroupMainHelper.SavePrefs(DMFileChecker.Prefs.Max)
					arg0_5.mgr:StartUpdateD()
				end
			})
		end
	end, SFX_PANEL)
end

function var0_0.check(arg0_8)
	if arg0_8.mgr:GetState() == DownloadState.None then
		arg0_8.mgr:StartCheckD()
	end

	arg0_8.timer = Timer.New(function()
		arg0_8:updateUI()
	end, 0.5, -1)

	arg0_8.timer:Start()
	arg0_8:updateUI()
end

function var0_0.updateUI(arg0_10)
	local var0_10 = arg0_10.mgr:GetState()

	if var0_10 == DownloadState.None then
		setText(arg0_10.btnText, "无状态")
		setActive(arg0_10.loadingIcon, false)
		setActive(arg0_10.newIcon, false)
		setActive(arg0_10.finishIcon, false)
	elseif var0_10 == DownloadState.Checking then
		setText(arg0_10.btnText, i18n("word_maingroup_checking"))
		setActive(arg0_10.loadingIcon, false)
		setActive(arg0_10.newIcon, false)
		setActive(arg0_10.finishIcon, false)
	elseif var0_10 == DownloadState.CheckToUpdate then
		setText(arg0_10.btnText, i18n("word_maingroup_checktoupdate"))
		setActive(arg0_10.loadingIcon, false)
		setActive(arg0_10.newIcon, true)
		setActive(arg0_10.finishIcon, false)
	elseif var0_10 == DownloadState.CheckOver then
		setText(arg0_10.btnText, "无需更新")
		setActive(arg0_10.loadingIcon, false)
		setActive(arg0_10.newIcon, false)
		setActive(arg0_10.finishIcon, false)
	elseif var0_10 == DownloadState.CheckFailure then
		setText(arg0_10.btnText, i18n("word_maingroup_checkfailure"))
		setActive(arg0_10.loadingIcon, false)
		setActive(arg0_10.newIcon, false)
		setActive(arg0_10.finishIcon, false)
	elseif var0_10 == DownloadState.Updating then
		setText(arg0_10.btnText, i18n("word_maingroup_updating"))
		setActive(arg0_10.loadingIcon, true)
		setActive(arg0_10.newIcon, false)
		setActive(arg0_10.finishIcon, false)

		local var1_10, var2_10 = arg0_10.mgr:GetCountProgress()

		setSlider(arg0_10.progressBar, 0, var2_10, var1_10)
		setText(arg0_10.btnText, var1_10 .. "/" .. var2_10)
	elseif var0_10 == DownloadState.UpdateSuccess then
		setText(arg0_10.btnText, i18n("word_maingroup_updatesuccess"))
		setActive(arg0_10.loadingIcon, false)
		setActive(arg0_10.newIcon, false)
		setActive(arg0_10.finishIcon, true)
	elseif var0_10 == DownloadState.UpdateFailure then
		setText(arg0_10.btnText, i18n("word_maingroup_updatefailure"))
		setActive(arg0_10.loadingIcon, false)
		setActive(arg0_10.newIcon, false)
		setActive(arg0_10.finishIcon, false)
	end
end

return var0_0

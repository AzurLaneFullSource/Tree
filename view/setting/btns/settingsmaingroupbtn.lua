local var0 = class("SettingsMainGroupBtn")

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)
	arg0:initData()
	arg0:findUI(arg1)
	arg0:addListener()
	arg0:check()
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.initData(arg0)
	arg0.mgr = pg.MainGroupMgr:GetInstance()
end

function var0.findUI(arg0, arg1)
	arg0._tf = arg1

	local var0 = findTF(arg0._tf, "Content")

	arg0.titleText = findTF(var0, "Title")
	arg0.progressBar = findTF(var0, "Progress")
	arg0.btn = findTF(var0, "Btn")
	arg0.btnText = findTF(arg0.btn, "Text")
	arg0.loadingIcon = findTF(var0, "Status/Loading")
	arg0.newIcon = findTF(var0, "Status/New")
	arg0.finishIcon = findTF(var0, "Status/Finish")

	setText(arg0.titleText, i18n("setting_resdownload_title_main_group"))
end

function var0.addListener(arg0)
	onButton(arg0, arg0._tf, function()
		local var0 = arg0.mgr:GetState()

		if var0 == DownloadState.CheckFailure then
			arg0.mgr:StartCheckD()
		elseif var0 == DownloadState.CheckToUpdate or var0 == DownloadState.UpdateFailure then
			local var1 = arg0.mgr:GetTotalSize()
			local var2 = HashUtil.BytesToString(var1)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_NORMAL,
				content = string.format(i18n("main_group_msgbox_content", var2)),
				onYes = function()
					GroupMainHelper.SavePrefs(DMFileChecker.Prefs.Max)
					arg0.mgr:StartUpdateD()
				end
			})
		end
	end, SFX_PANEL)
end

function var0.check(arg0)
	if arg0.mgr:GetState() == DownloadState.None then
		arg0.mgr:StartCheckD()
	end

	arg0.timer = Timer.New(function()
		arg0:updateUI()
	end, 0.5, -1)

	arg0.timer:Start()
	arg0:updateUI()
end

function var0.updateUI(arg0)
	local var0 = arg0.mgr:GetState()

	if var0 == DownloadState.None then
		setText(arg0.btnText, "无状态")
		setActive(arg0.loadingIcon, false)
		setActive(arg0.newIcon, false)
		setActive(arg0.finishIcon, false)
	elseif var0 == DownloadState.Checking then
		setText(arg0.btnText, i18n("word_maingroup_checking"))
		setActive(arg0.loadingIcon, false)
		setActive(arg0.newIcon, false)
		setActive(arg0.finishIcon, false)
	elseif var0 == DownloadState.CheckToUpdate then
		setText(arg0.btnText, i18n("word_maingroup_checktoupdate"))
		setActive(arg0.loadingIcon, false)
		setActive(arg0.newIcon, true)
		setActive(arg0.finishIcon, false)
	elseif var0 == DownloadState.CheckOver then
		setText(arg0.btnText, "无需更新")
		setActive(arg0.loadingIcon, false)
		setActive(arg0.newIcon, false)
		setActive(arg0.finishIcon, false)
	elseif var0 == DownloadState.CheckFailure then
		setText(arg0.btnText, i18n("word_maingroup_checkfailure"))
		setActive(arg0.loadingIcon, false)
		setActive(arg0.newIcon, false)
		setActive(arg0.finishIcon, false)
	elseif var0 == DownloadState.Updating then
		setText(arg0.btnText, i18n("word_maingroup_updating"))
		setActive(arg0.loadingIcon, true)
		setActive(arg0.newIcon, false)
		setActive(arg0.finishIcon, false)

		local var1, var2 = arg0.mgr:GetCountProgress()

		setSlider(arg0.progressBar, 0, var2, var1)
		setText(arg0.btnText, var1 .. "/" .. var2)
	elseif var0 == DownloadState.UpdateSuccess then
		setText(arg0.btnText, i18n("word_maingroup_updatesuccess"))
		setActive(arg0.loadingIcon, false)
		setActive(arg0.newIcon, false)
		setActive(arg0.finishIcon, true)
	elseif var0 == DownloadState.UpdateFailure then
		setText(arg0.btnText, i18n("word_maingroup_updatefailure"))
		setActive(arg0.loadingIcon, false)
		setActive(arg0.newIcon, false)
		setActive(arg0.finishIcon, false)
	end
end

return var0

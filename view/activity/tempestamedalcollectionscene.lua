local var0 = class("TempestaMedalCollectionScene", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "TempestaMedalCollectionUI"
end

function var0.setActivity(arg0, arg1)
	arg0.activity = arg1
end

function var0.onBackPressed(arg0)
	if isActive(arg0.rtHelpPanel) then
		setActive(arg0.rtHelpPanel)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.rtHelpPanel, arg0._tf)

		return
	end

	arg0:closeView()
end

function var0.init(arg0)
	onButton(arg0, arg0._tf:Find("top/btn_back"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)

	arg0.rtMainPanel = arg0._tf:Find("main")

	onButton(arg0, arg0.rtMainPanel:Find("btn_help"), function()
		pg.UIMgr.GetInstance():BlurPanel(arg0.rtHelpPanel)
		setActive(arg0.rtHelpPanel, true)
	end, SFX_PANEL)

	arg0.rtHelpPanel = arg0._tf:Find("help_panel")

	setText(arg0.rtHelpPanel:Find("window/Text"), i18n("pirate_wanted_help"))
	onButton(arg0, arg0.rtHelpPanel:Find("bg"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
end

function var0.didEnter(arg0)
	arg0:updateTaskLayers()
end

function var0.updateTaskLayers(arg0)
	local var0 = getProxy(TaskProxy)
	local var1 = underscore.map(arg0.activity:getConfig("config_data"), function(arg0)
		return var0:getTaskVO(arg0)
	end)

	for iter0, iter1 in ipairs(var1) do
		local var2 = arg0.rtMainPanel:Find("tasks"):GetChild(iter0 - 1)

		if iter0 == #var1 then
			setActive(var2:Find("got"), iter1:isReceive())

			local var3 = Drop.Create(iter1:getConfig("award_display")[1])

			onButton(arg0, var2, function()
				arg0:emit(BaseUI.ON_DROP, var3)
			end, SFX_PANEL)
		else
			local var4 = {}

			var4.type, var4.id, var4.count = unpack(iter1:getConfig("award_display")[1])

			updateDrop(var2:Find("IconTpl"), var4)
			onButton(arg0, var2:Find("IconTpl"), function()
				arg0:emit(BaseUI.ON_DROP, var4)
			end, SFX_PANEL)
			setText(var2:Find("Text"), iter1:getConfig("desc"))

			local var5 = iter1:getTaskStatus()

			setActive(var2:Find("btn_go"), var5 == 0)
			setActive(var2:Find("btn_get"), var5 == 1)
			setActive(var2:Find("btn_got"), var5 == 2)
			onButton(arg0, var2:Find("btn_go"), function()
				arg0:emit(TempestaMedalCollectionMediator.ON_TASK_GO, iter1)
			end, SFX_PANEL)
			onButton(arg0, var2:Find("btn_get"), function()
				arg0:emit(TempestaMedalCollectionMediator.ON_TASK_SUBMIT, iter1)
			end, SFX_PANEL)
		end
	end

	local var6 = #var1 - 1
	local var7 = underscore.reduce(var1, 0, function(arg0, arg1)
		return arg0 + (arg1:isReceive() and 1 or 0)
	end)

	setText(arg0.rtMainPanel:Find("progress/Text"), math.min(var7, var6) .. "/" .. var6)

	if var6 <= var7 and not var1[#var1]:isReceive() then
		arg0:emit(TempestaMedalCollectionMediator.ON_TASK_SUBMIT, var1[#var1])
	end
end

function var0.willExit(arg0)
	if isActive(arg0.rtHelpPanel) then
		arg0:onBackPressed()
	end
end

return var0

local var0_0 = class("TempestaMedalCollectionScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "TempestaMedalCollectionUI"
end

function var0_0.setActivity(arg0_2, arg1_2)
	arg0_2.activity = arg1_2
end

function var0_0.onBackPressed(arg0_3)
	if isActive(arg0_3.rtHelpPanel) then
		setActive(arg0_3.rtHelpPanel)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_3.rtHelpPanel, arg0_3._tf)

		return
	end

	arg0_3:closeView()
end

function var0_0.init(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("top/btn_back"), function()
		arg0_4:onBackPressed()
	end, SFX_CANCEL)

	arg0_4.rtMainPanel = arg0_4._tf:Find("main")

	onButton(arg0_4, arg0_4.rtMainPanel:Find("btn_help"), function()
		pg.UIMgr.GetInstance():BlurPanel(arg0_4.rtHelpPanel)
		setActive(arg0_4.rtHelpPanel, true)
	end, SFX_PANEL)

	arg0_4.rtHelpPanel = arg0_4._tf:Find("help_panel")

	setText(arg0_4.rtHelpPanel:Find("window/Text"), i18n("pirate_wanted_help"))
	onButton(arg0_4, arg0_4.rtHelpPanel:Find("bg"), function()
		arg0_4:onBackPressed()
	end, SFX_CANCEL)
end

function var0_0.didEnter(arg0_8)
	arg0_8:updateTaskLayers()
end

function var0_0.updateTaskLayers(arg0_9)
	local var0_9 = getProxy(TaskProxy)
	local var1_9 = underscore.map(arg0_9.activity:getConfig("config_data"), function(arg0_10)
		local var0_10 = var0_9:getTaskVO(arg0_10)

		if not var0_10 then
			var0_10 = Task.New({
				submit_time = 1,
				id = arg0_10
			})

			var0_10:updateProgress(var0_10:getConfig("target_num"))
		end

		return var0_10
	end)

	for iter0_9, iter1_9 in ipairs(var1_9) do
		local var2_9 = arg0_9.rtMainPanel:Find("tasks"):GetChild(iter0_9 - 1)

		if iter0_9 == #var1_9 then
			setActive(var2_9:Find("got"), iter1_9:isReceive())

			local var3_9 = Drop.Create(iter1_9:getConfig("award_display")[1])

			onButton(arg0_9, var2_9, function()
				arg0_9:emit(BaseUI.ON_DROP, var3_9)
			end, SFX_PANEL)
		else
			local var4_9 = {}

			var4_9.type, var4_9.id, var4_9.count = unpack(iter1_9:getConfig("award_display")[1])

			updateDrop(var2_9:Find("IconTpl"), var4_9)
			onButton(arg0_9, var2_9:Find("IconTpl"), function()
				arg0_9:emit(BaseUI.ON_DROP, var4_9)
			end, SFX_PANEL)
			setText(var2_9:Find("Text"), iter1_9:getConfig("desc"))

			local var5_9 = iter1_9:getTaskStatus()

			setActive(var2_9:Find("btn_go"), var5_9 == 0)
			setActive(var2_9:Find("btn_get"), var5_9 == 1)
			setActive(var2_9:Find("btn_got"), var5_9 == 2)
			onButton(arg0_9, var2_9:Find("btn_go"), function()
				arg0_9:emit(TempestaMedalCollectionMediator.ON_TASK_GO, iter1_9)
			end, SFX_PANEL)
			onButton(arg0_9, var2_9:Find("btn_get"), function()
				arg0_9:emit(TempestaMedalCollectionMediator.ON_TASK_SUBMIT, iter1_9)
			end, SFX_PANEL)
		end
	end

	local var6_9 = #var1_9 - 1
	local var7_9 = underscore.reduce(var1_9, 0, function(arg0_15, arg1_15)
		return arg0_15 + (arg1_15:isReceive() and 1 or 0)
	end)

	setText(arg0_9.rtMainPanel:Find("progress/Text"), math.min(var7_9, var6_9) .. "/" .. var6_9)

	if var6_9 <= var7_9 and not var1_9[#var1_9]:isReceive() then
		arg0_9:emit(TempestaMedalCollectionMediator.ON_TASK_SUBMIT, var1_9[#var1_9])
	end
end

function var0_0.willExit(arg0_16)
	if isActive(arg0_16.rtHelpPanel) then
		arg0_16:onBackPressed()
	end
end

return var0_0

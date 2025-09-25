local var0_0 = class("AterialYumiaCoreBuffLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AterialYumiaCoreBuffLayer"
end

function var0_0.SetActivity(arg0_2, arg1_2)
	arg0_2.activity = arg1_2
	arg0_2.config = arg1_2:getConfig("config_client").core_tasks
end

function var0_0.init(arg0_3)
	arg0_3.rtBg = arg0_3._tf:Find("bg")
	arg0_3.btnReturn = arg0_3._tf:Find("adapt/bottom/btn_return")

	onButton(arg0_3, arg0_3.btnReturn, function()
		if arg0_3.inAnim then
			return
		end

		arg0_3.inAnim = true

		quickPlayAnimation(arg0_3._tf, "Anim_AteriaYumiaCoreBuffLayer_Out")
	end, SFX_CANCEL)

	arg0_3.rtUpgrade = arg0_3._tf:Find("upgrade")

	setActive(arg0_3.rtUpgrade, false)
	onButton(arg0_3, arg0_3.rtUpgrade:Find("top/btn_back"), function()
		if arg0_3.inAnim then
			return
		end

		arg0_3.inAnim = true

		quickPlayAnimation(arg0_3.rtUpgrade, "Anim_AteriaYumiaCoreBuffLayer_upgrade_Out")
	end, SFX_CANCEL)
	arg0_3.rtUpgrade:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_3.inAnim = false

		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_3.rtUpgrade, arg0_3._tf)
		setActive(arg0_3.rtUpgrade, false)
	end)
	arg0_3._tf:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_3.inAnim = false

		arg0_3:closeView()
	end)
end

function var0_0.didEnter(arg0_8)
	arg0_8:UpdateView()
end

function var0_0.UpdateView(arg0_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.config) do
		local var0_9 = {}

		for iter2_9, iter3_9 in ipairs(iter1_9) do
			local var1_9 = getProxy(TaskProxy):getTaskVO(iter3_9)

			if var1_9 and var1_9:isReceive() then
				table.insert(var0_9, var1_9)
			end
		end

		local var2_9 = #var0_9
		local var3_9 = arg0_9.rtBg:Find(tostring(iter0_9))

		setText(var3_9:Find("name/Text"), i18n("yumia_buff_name_" .. iter0_9))
		setText(var3_9:Find("name/level"), string.format("LV.<size=30>%s</size>", var2_9))
		UIItemList.StaticAlign(var3_9:Find("buffs"), var3_9:Find("buffs/tpl"), #var0_9, function(arg0_10, arg1_10, arg2_10)
			arg1_10 = arg1_10 + 1

			if arg0_10 == UIItemList.EventUpdate then
				local var0_10 = Drop.Create(var0_9[arg1_10]:getConfig("award_display")[1])

				GetImageSpriteFromAtlasAsync(var0_10:getIcon(), "", arg2_10, false)
			end
		end)
		onButton(arg0_9, var3_9, function()
			arg0_9:ShowUpgrade(iter0_9)
			pg.UIMgr.GetInstance():BlurPanel(arg0_9.rtUpgrade)
			setActive(arg0_9.rtUpgrade, true)

			for iter0_11 = 1, 4 do
				local var0_11 = arg0_9.rtUpgrade:Find("main/ring"):Find("lv" .. iter0_11)

				setCanvasGroupAlpha(var0_11, 0)

				local var1_11 = {}

				if iter0_11 > 1 then
					table.insert(var1_11, function(arg0_12)
						onDelayTick(arg0_12, (iter0_11 - 1) * 0.08)
					end)
				end

				seriesAsync(var1_11, function()
					quickPlayAnimation(var0_11, string.format("Anim_AteriaYumiaCoreBuffLayer_lv%d_In", iter0_11))
				end)
			end
		end, SFX_PANEL)
	end
end

function var0_0.ShowUpgrade(arg0_14, arg1_14, arg2_14)
	arg1_14 = arg1_14 or arg0_14.index
	arg0_14.index = arg1_14

	local var0_14 = arg0_14.config[arg1_14]
	local var1_14 = 0

	for iter0_14, iter1_14 in ipairs(var0_14) do
		local var2_14 = getProxy(TaskProxy):getTaskVO(iter1_14)
		local var3_14 = arg0_14.rtUpgrade:Find("main/ring"):Find("lv" .. iter0_14)
		local var4_14 = var2_14:isReceive()

		if var4_14 then
			var1_14 = iter0_14

			local var5_14 = Drop.Create(var2_14:getConfig("award_display")[1])

			GetImageSpriteFromAtlasAsync(var5_14:getIcon(), "", var3_14:Find("active/icon"), false)
			setText(var3_14:Find("active/icon/name"), var5_14:getName())
			setText(var3_14:Find("active/icon/Text"), var5_14.desc)
		else
			setText(var3_14:Find("inactive/Text"), i18n("yumia_buff_4", iter0_14))
		end

		if arg2_14 and not isActive(var3_14:Find("active")) and var4_14 then
			quickPlayAnimation(var3_14, "Anim_AteriaYumiaCoreBuffLayer_active")
		end

		setActive(var3_14:Find("active"), var4_14)
		setActive(var3_14:Find("inactive"), not var4_14)
	end

	local var6_14 = arg0_14.rtUpgrade:Find("main/content")

	setText(var6_14:Find("icon/core_name"), i18n("yumia_buff_name_" .. arg1_14))
	setText(var6_14:Find("icon/desc"), i18n("yumia_buff_desc_" .. arg1_14))

	if arg2_14 then
		var6_14:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setText(var6_14:Find("icon/level"), string.format("LV.<size=50><color=#ffffff00>%s</color></size>", var1_14))
			setText(var6_14:Find("icon/level/number"), string.format("<size=50>%s</size>", var1_14))
			onNextTick(function()
				setCanvasGroupAlpha(var6_14:Find("icon/level/number"), 1)
			end)
		end)
		quickPlayAnimation(var6_14, "Anim_AteriaYumiaCoreBuffLayer_active_Level")
	else
		setText(var6_14:Find("icon/level"), string.format("LV.<size=50><color=#ffffff00>%s</color></size>", var1_14))
		setText(var6_14:Find("icon/level/number"), string.format("<size=50>%s</size>", var1_14))
	end

	local var7_14 = getProxy(TaskProxy):getTaskVO(var0_14[math.min(var1_14 + 1, #var0_14)])
	local var8_14 = var7_14:getGiveDrops()

	setText(var6_14:Find("cost/Text"), i18n("yumia_buff_1"))
	UIItemList.StaticAlign(var6_14:Find("cost/container"), var6_14:Find("cost/container/IconTpl"), #var8_14, function(arg0_17, arg1_17, arg2_17)
		arg1_17 = arg1_17 + 1

		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = var8_14[arg1_17]

			updateDrop(arg2_17, var0_17)
			setText(arg2_17:Find("icon_bg/count"), string.format("%d/%d", var0_17:getOwnedCount(), var0_17.count))
			onButton(arg0_14, arg2_17, function()
				arg0_14:emit(BaseUI.ON_DROP, var0_17)
			end, SFX_PANEL)
			setCanvasGroupAlpha(arg2_17, 0)

			if arg1_17 > 1 then
				onDelayTick(function()
					quickPlayAnimation(arg2_17, "Anim_AteriaYumiaCoreBuffLayer_tpl")
				end, 0.08 * (arg1_17 - 1))
			else
				quickPlayAnimation(arg2_17, "Anim_AteriaYumiaCoreBuffLayer_tpl")
			end
		end
	end)

	local var9_14 = var7_14:getTaskStatus()

	setActive(var6_14:Find("btn_lock"), var9_14 == 0)
	setText(var6_14:Find("btn_lock/Text"), i18n("yumia_buff_2"))
	setActive(var6_14:Find("btn_confirm"), var9_14 == 1)
	setText(var6_14:Find("btn_confirm/Text"), i18n("yumia_buff_2"))
	setActive(var6_14:Find("btn_finish"), var9_14 == 2)
	setText(var6_14:Find("btn_finish/Text"), i18n("yumia_buff_3"))
	onButton(arg0_14, var6_14:Find("btn_confirm"), function()
		arg0_14:emit(AterialYumiaCoreBuffMediator.SUBMIT_TASK, var7_14.id)
	end, SFX_CONFIRM)
end

function var0_0.willExit(arg0_21)
	if isActive(arg0_21.rtUpgrade) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_21.rtUpgrade, arg0_21._tf)
		setActive(arg0_21.rtUpgrade, false)
	end
end

function var0_0.onBackPressed(arg0_22)
	if isActive(arg0_22.rtUpgrade) then
		triggerButton(arg0_22.rtUpgrade:Find("top/btn_back"))
	else
		triggerButton(arg0_22.btnReturn)
	end
end

return var0_0

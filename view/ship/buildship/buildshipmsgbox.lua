local var0_0 = class("BuildShipMsgBox", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "BuildShipMsgBoxUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.cancenlBtn = findTF(arg0_2._go, "window/btns/cancel_btn")
	arg0_2.confirmBtn = findTF(arg0_2._go, "window/btns/confirm_btn")
	arg0_2.closeBtn = findTF(arg0_2._go, "window/close_btn")
	arg0_2.count = 1
	arg0_2.minusBtn = findTF(arg0_2._go, "window/content/calc_panel/minus")
	arg0_2.addBtn = findTF(arg0_2._go, "window/content/calc_panel/add")
	arg0_2.maxBtn = findTF(arg0_2._go, "window/content/max")
	arg0_2.valueTxt = findTF(arg0_2._go, "window/content/calc_panel/Text"):GetComponent(typeof(Text))
	arg0_2.text = findTF(arg0_2._go, "window/content/Text"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("window/btns/cancel_btn/Image/Image (1)"), i18n("text_cancel"))
	setText(arg0_2:findTF("window/btns/confirm_btn/Image/Image (1)"), i18n("text_confirm"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancenlBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3.onConfirm then
			arg0_3.onConfirm(arg0_3.count)
		end

		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.minusBtn, function()
		arg0_3.count = math.max(arg0_3.count - 1, 1)

		arg0_3:updateTxt(arg0_3.count)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.addBtn, function()
		if arg0_3.buildType == "ticket" and arg0_3.count >= arg0_3.itemVO.count then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tip_build_ticket_not_enough", arg0_3.itemVO:getConfig("name")))

			return
		end

		arg0_3.count = math.clamp(arg0_3.count + 1, 1, MAX_BUILD_WORK_COUNT)

		arg0_3:updateTxt(arg0_3.count)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.maxBtn, function()
		arg0_3.count = MAX_BUILD_WORK_COUNT

		if arg0_3.buildType == "ticket" then
			arg0_3.count = math.clamp(arg0_3.itemVO.count, 1, MAX_BUILD_WORK_COUNT)
		end

		arg0_3:updateTxt(arg0_3.count)
	end, SFX_PANEL)
end

function var0_0.updateTxt(arg0_11, arg1_11)
	arg0_11.valueTxt.text = arg1_11

	local var0_11 = arg0_11:GetDesc(arg1_11)

	arg0_11.text.text = var0_11
end

function var0_0.GetDesc(arg0_12, arg1_12)
	local var0_12 = ""

	switch(arg0_12.buildType, {
		base = function()
			local var0_13 = arg0_12.buildPool

			if arg1_12 <= arg0_12.max and arg0_12.player.gold >= arg1_12 * var0_13.use_gold and arg0_12.itemVO.count >= arg1_12 * var0_13.number_1 then
				var0_12 = i18n("build_ship_tip", arg1_12, var0_13.name, arg1_12 * var0_13.use_gold, arg1_12 * var0_13.number_1, COLOR_GREEN)
			else
				var0_12 = i18n("build_ship_tip", arg1_12, var0_13.name, arg1_12 * var0_13.use_gold, arg1_12 * var0_13.number_1, COLOR_RED)
			end
		end,
		ticket = function()
			if arg1_12 <= arg0_12.max and arg0_12.itemVO.count >= arg1_12 then
				var0_12 = i18n("build_ship_tip_use_ticket", arg1_12, arg0_12.buildPool.name, arg1_12, arg0_12.itemVO:getConfig("name"), COLOR_GREEN)
			else
				var0_12 = i18n("build_ship_tip_use_ticket", arg1_12, arg0_12.buildPool.name, arg1_12, arg0_12.itemVO:getConfig("name"), COLOR_RED)
			end
		end,
		medal = function()
			if arg1_12 <= arg0_12.max and arg0_12.itemVO.count >= arg1_12 * arg0_12.cost then
				var0_12 = i18n("honor_medal_support_tips_confirm", arg1_12, arg1_12 * arg0_12.cost, COLOR_GREEN)
			else
				var0_12 = i18n("honor_medal_support_tips_confirm", arg1_12, arg1_12 * arg0_12.cost, COLOR_RED)
			end
		end
	})

	return var0_12
end

function var0_0.Show(arg0_16, arg1_16)
	arg0_16.showing = true

	for iter0_16, iter1_16 in pairs(arg1_16) do
		arg0_16[iter0_16] = iter1_16
	end

	arg0_16.count = 1

	arg0_16:updateTxt(arg0_16.count)
	setText(arg0_16._tf:Find("window/content/title"), i18n(arg0_16.buildType == "medal" and "support_times_tip" or "build_times_tip"))
	setActiveViaLayer(arg0_16._go, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_16._tf)
end

function var0_0.Hide(arg0_17)
	arg0_17.showing = false

	if arg0_17._go then
		arg0_17.onConfirm = nil
		arg0_17.count = 1
		arg0_17.max = 1

		setActiveViaLayer(arg0_17._go, false)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_17._tf, arg0_17._parentTf)
end

function var0_0.isShowing(arg0_18)
	return arg0_18.showing
end

function var0_0.OnDestroy(arg0_19)
	arg0_19:Hide()
end

return var0_0

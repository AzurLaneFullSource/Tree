local var0 = class("BuildShipMsgBox", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "BuildShipMsgBoxUI"
end

function var0.OnLoaded(arg0)
	arg0.cancenlBtn = findTF(arg0._go, "window/btns/cancel_btn")
	arg0.confirmBtn = findTF(arg0._go, "window/btns/confirm_btn")
	arg0.closeBtn = findTF(arg0._go, "window/close_btn")
	arg0.count = 1
	arg0.minusBtn = findTF(arg0._go, "window/content/calc_panel/minus")
	arg0.addBtn = findTF(arg0._go, "window/content/calc_panel/add")
	arg0.maxBtn = findTF(arg0._go, "window/content/max")
	arg0.valueTxt = findTF(arg0._go, "window/content/calc_panel/Text"):GetComponent(typeof(Text))
	arg0.text = findTF(arg0._go, "window/content/Text"):GetComponent(typeof(Text))

	setText(arg0:findTF("window/btns/cancel_btn/Image/Image (1)"), i18n("text_cancel"))
	setText(arg0:findTF("window/btns/confirm_btn/Image/Image (1)"), i18n("text_confirm"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancenlBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.onConfirm then
			arg0.onConfirm(arg0.count)
		end

		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.minusBtn, function()
		arg0.count = math.max(arg0.count - 1, 1)

		arg0:updateTxt(arg0.count)
	end, SFX_PANEL)
	onButton(arg0, arg0.addBtn, function()
		if arg0.buildType == "ticket" and arg0.count >= arg0.itemVO.count then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tip_build_ticket_not_enough", arg0.itemVO:getConfig("name")))

			return
		end

		arg0.count = math.clamp(arg0.count + 1, 1, MAX_BUILD_WORK_COUNT)

		arg0:updateTxt(arg0.count)
	end, SFX_PANEL)
	onButton(arg0, arg0.maxBtn, function()
		arg0.count = MAX_BUILD_WORK_COUNT

		if arg0.buildType == "ticket" then
			arg0.count = math.clamp(arg0.itemVO.count, 1, MAX_BUILD_WORK_COUNT)
		end

		arg0:updateTxt(arg0.count)
	end, SFX_PANEL)
end

function var0.updateTxt(arg0, arg1)
	arg0.valueTxt.text = arg1

	local var0 = arg0:GetDesc(arg1)

	arg0.text.text = var0
end

function var0.GetDesc(arg0, arg1)
	local var0 = ""

	switch(arg0.buildType, {
		base = function()
			local var0 = arg0.buildPool

			if arg1 <= arg0.max and arg0.player.gold >= arg1 * var0.use_gold and arg0.itemVO.count >= arg1 * var0.number_1 then
				var0 = i18n("build_ship_tip", arg1, var0.name, arg1 * var0.use_gold, arg1 * var0.number_1, COLOR_GREEN)
			else
				var0 = i18n("build_ship_tip", arg1, var0.name, arg1 * var0.use_gold, arg1 * var0.number_1, COLOR_RED)
			end
		end,
		ticket = function()
			if arg1 <= arg0.max and arg0.itemVO.count >= arg1 then
				var0 = i18n("build_ship_tip_use_ticket", arg1, arg0.buildPool.name, arg1, arg0.itemVO:getConfig("name"), COLOR_GREEN)
			else
				var0 = i18n("build_ship_tip_use_ticket", arg1, arg0.buildPool.name, arg1, arg0.itemVO:getConfig("name"), COLOR_RED)
			end
		end,
		medal = function()
			if arg1 <= arg0.max and arg0.itemVO.count >= arg1 * arg0.cost then
				var0 = i18n("honor_medal_support_tips_confirm", arg1, arg1 * arg0.cost, COLOR_GREEN)
			else
				var0 = i18n("honor_medal_support_tips_confirm", arg1, arg1 * arg0.cost, COLOR_RED)
			end
		end
	})

	return var0
end

function var0.Show(arg0, arg1)
	arg0.showing = true

	for iter0, iter1 in pairs(arg1) do
		arg0[iter0] = iter1
	end

	arg0.count = 1

	arg0:updateTxt(arg0.count)
	setText(arg0._tf:Find("window/content/title"), i18n(arg0.buildType == "medal" and "support_times_tip" or "build_times_tip"))
	setActiveViaLayer(arg0._go, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.Hide(arg0)
	arg0.showing = false

	if arg0._go then
		arg0.onConfirm = nil
		arg0.count = 1
		arg0.max = 1

		setActiveViaLayer(arg0._go, false)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.isShowing(arg0)
	return arg0.showing
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0

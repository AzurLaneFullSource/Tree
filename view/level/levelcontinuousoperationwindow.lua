local var0_0 = class("LevelContinuousOperationWindow", import("view.activity.worldboss.ContinuousOperationWindow"))

function var0_0.getUIName(arg0_1)
	return "LevelContinuousOperationWindowUI"
end

function var0_0.ResUISettings(arg0_2)
	return {
		reset = true,
		gemOffsetX = 628,
		showType = PlayerResUI.TYPE_OIL
	}
end

function var0_0.init(arg0_3)
	arg0_3.panel = arg0_3._tf:Find("window/panel")
	arg0_3._countSelect = arg0_3.panel:Find("content")
	arg0_3._pageUtil = PageUtil.New(arg0_3._countSelect:Find("value_bg/left"), arg0_3._countSelect:Find("value_bg/right"), arg0_3._countSelect:Find("max"), arg0_3._countSelect:Find("value_bg/value"))
	arg0_3.consumeText = arg0_3.panel:Find("content/consume"):GetComponent("RichText")

	setText(arg0_3._tf:Find("window/top/bg/title/title"), i18n("multiple_sorties_title"))
	setText(arg0_3._tf:Find("window/top/bg/title/title/title_en"), i18n("multiple_sorties_title_eng"))
	setText(arg0_3.panel:Find("content/desc_txt"), i18n("multiple_sorties_times"))
	setText(arg0_3.panel:Find("Tip"), i18n("multiple_sorties_main_tip"))
	setText(arg0_3.panel:Find("battle/pic"), i18n("msgbox_text_battle"))
	setText(arg0_3.panel:Find("bonus/Text"), i18n("expedition_extra_drop_tip"))
	setText(arg0_3.panel:Find("ticket/Text"), i18n("multiple_sorties_challenge_ticket_use"))
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("window/top/btnBack"), function()
		arg0_4:closeView()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4._tf:Find("bg"), function()
		arg0_4:closeView()
	end, SFX_CANCEL)

	local var0_4 = arg0_4.contextData.extraRate.enabled

	arg0_4.contextData.useTicket = defaultValue(arg0_4.contextData.useTicket, var0_4)

	triggerToggle(arg0_4.panel:Find("ticket/checkbox"), var0_4)
	onToggle(arg0_4, arg0_4.panel:Find("ticket/checkbox"), function(arg0_7)
		arg0_4.contextData.useTicket = arg0_7

		arg0_4:emit(LevelMediator2.ON_SPITEM_CHANGED, arg0_7)
		arg0_4:UpdateContent()
	end, SFX_PANEL, SFX_CANCEL)
	arg0_4._pageUtil:setNumUpdate(function(arg0_8)
		arg0_4.contextData.battleTimes = arg0_8

		arg0_4:UpdateContent()
	end)

	local var1_4 = arg0_4.contextData.maxCount

	arg0_4._pageUtil:setMaxNum(var1_4)

	if var1_4 >= 0 then
		arg0_4.contextData.battleTimes = math.min(var1_4, arg0_4.contextData.battleTimes or 1)
	end

	arg0_4._pageUtil:setDefaultNum(arg0_4.contextData.battleTimes)
	arg0_4:UpdateContent()
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)
end

function var0_0.UpdateContent(arg0_9)
	local var0_9 = arg0_9.contextData.battleTimes
	local var1_9 = arg0_9.contextData.extraRate
	local var2_9 = var1_9.extraCount
	local var3_9 = var1_9.freeBonus
	local var4_9 = math.clamp(var0_9 - var3_9, 0, var2_9)
	local var5_9 = arg0_9.contextData.useTicket and var4_9 or 0
	local var6_9 = var5_9

	if arg0_9.contextData.useTicket then
		local var7_9 = setColorStr(var6_9, var0_9 <= var2_9 and COLOR_GREEN or COLOR_RED)

		setText(arg0_9.panel:Find("ticket/Number"), var7_9 .. "/" .. var2_9)
	else
		setText(arg0_9.panel:Find("ticket/Number"), var2_9)
	end

	local var8_9 = var2_9 > 0 and var4_9 > 0

	setActive(arg0_9.panel:Find("ticket/checkboxBan"), not var8_9)
	setToggleEnabled(arg0_9.panel:Find("ticket/checkbox"), var8_9)

	if arg0_9.contextData.useTicket and not var8_9 then
		triggerToggle(arg0_9.panel:Find("ticket/checkbox"), false)
	end

	local var9_9 = arg0_9.contextData.oilCost * (var0_9 + (var1_9.rate - 1) * var5_9)
	local var10_9 = i18n("multiple_sorties_cost1", var9_9)
	local var11_9 = getProxy(PlayerProxy):getRawData()

	if var9_9 > var11_9.oil then
		var10_9 = string.gsub(var10_9, "#92fc63", COLOR_RED)
	end

	if var5_9 > 0 then
		var10_9 = var10_9 .. i18n("multiple_sorties_cost3", var5_9)
	end

	arg0_9.consumeText.text = var10_9

	onButton(arg0_9, arg0_9.panel:Find("battle"), function()
		if var9_9 > var11_9.oil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

			return
		end

		arg0_9:emit(PreCombatMediator.CONTINUOUS_OPERATION)
	end, SFX_PANEL)
end

return var0_0

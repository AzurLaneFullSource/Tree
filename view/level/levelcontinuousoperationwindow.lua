local var0 = class("LevelContinuousOperationWindow", import("view.activity.worldboss.ContinuousOperationWindow"))

function var0.getUIName(arg0)
	return "LevelContinuousOperationWindowUI"
end

function var0.ResUISettings(arg0)
	return {
		reset = true,
		gemOffsetX = 628,
		showType = PlayerResUI.TYPE_OIL
	}
end

function var0.init(arg0)
	arg0.panel = arg0._tf:Find("window/panel")
	arg0._countSelect = arg0.panel:Find("content")
	arg0._pageUtil = PageUtil.New(arg0._countSelect:Find("value_bg/left"), arg0._countSelect:Find("value_bg/right"), arg0._countSelect:Find("max"), arg0._countSelect:Find("value_bg/value"))
	arg0.consumeText = arg0.panel:Find("content/consume"):GetComponent("RichText")

	setText(arg0._tf:Find("window/top/bg/title/title"), i18n("multiple_sorties_title"))
	setText(arg0._tf:Find("window/top/bg/title/title/title_en"), i18n("multiple_sorties_title_eng"))
	setText(arg0.panel:Find("content/desc_txt"), i18n("multiple_sorties_times"))
	setText(arg0.panel:Find("Tip"), i18n("multiple_sorties_main_tip"))
	setText(arg0.panel:Find("battle/pic"), i18n("msgbox_text_battle"))
	setText(arg0.panel:Find("bonus/Text"), i18n("expedition_extra_drop_tip"))
	setText(arg0.panel:Find("ticket/Text"), i18n("multiple_sorties_challenge_ticket_use"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("window/top/btnBack"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:closeView()
	end, SFX_CANCEL)

	local var0 = arg0.contextData.extraRate.enabled

	arg0.contextData.useTicket = defaultValue(arg0.contextData.useTicket, var0)

	triggerToggle(arg0.panel:Find("ticket/checkbox"), var0)
	onToggle(arg0, arg0.panel:Find("ticket/checkbox"), function(arg0)
		arg0.contextData.useTicket = arg0

		arg0:emit(LevelMediator2.ON_SPITEM_CHANGED, arg0)
		arg0:UpdateContent()
	end, SFX_PANEL, SFX_CANCEL)
	arg0._pageUtil:setNumUpdate(function(arg0)
		arg0.contextData.battleTimes = arg0

		arg0:UpdateContent()
	end)

	local var1 = arg0.contextData.maxCount

	arg0._pageUtil:setMaxNum(var1)

	if var1 >= 0 then
		arg0.contextData.battleTimes = math.min(var1, arg0.contextData.battleTimes or 1)
	end

	arg0._pageUtil:setDefaultNum(arg0.contextData.battleTimes)
	arg0:UpdateContent()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.UpdateContent(arg0)
	local var0 = arg0.contextData.battleTimes
	local var1 = arg0.contextData.extraRate
	local var2 = var1.extraCount
	local var3 = var1.freeBonus
	local var4 = math.clamp(var0 - var3, 0, var2)
	local var5 = arg0.contextData.useTicket and var4 or 0
	local var6 = var5

	if arg0.contextData.useTicket then
		local var7 = setColorStr(var6, var0 <= var2 and COLOR_GREEN or COLOR_RED)

		setText(arg0.panel:Find("ticket/Number"), var7 .. "/" .. var2)
	else
		setText(arg0.panel:Find("ticket/Number"), var2)
	end

	local var8 = var2 > 0 and var4 > 0

	setActive(arg0.panel:Find("ticket/checkboxBan"), not var8)
	setToggleEnabled(arg0.panel:Find("ticket/checkbox"), var8)

	if arg0.contextData.useTicket and not var8 then
		triggerToggle(arg0.panel:Find("ticket/checkbox"), false)
	end

	local var9 = arg0.contextData.oilCost * (var0 + (var1.rate - 1) * var5)
	local var10 = i18n("multiple_sorties_cost1", var9)
	local var11 = getProxy(PlayerProxy):getRawData()

	if var9 > var11.oil then
		var10 = string.gsub(var10, "#92fc63", COLOR_RED)
	end

	if var5 > 0 then
		var10 = var10 .. i18n("multiple_sorties_cost3", var5)
	end

	arg0.consumeText.text = var10

	onButton(arg0, arg0.panel:Find("battle"), function()
		if var9 > var11.oil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

			return
		end

		arg0:emit(PreCombatMediator.CONTINUOUS_OPERATION)
	end, SFX_PANEL)
end

return var0

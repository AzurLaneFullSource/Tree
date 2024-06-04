local var0 = class("BossRushContinuousOperationWindow", import("view.activity.worldboss.ContinuousOperationWindow"))

function var0.getUIName(arg0)
	return "BossRushContinuousOperationWindowUI"
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
	setText(arg0.panel:Find("Tip"), i18n("multiple_sorties_tip"))
	setText(arg0.panel:Find("battle/pic"), i18n("msgbox_text_battle"))
	setText(arg0.panel:Find("bonus/Text"), i18n("expedition_extra_drop_tip"))
	setText(arg0.panel:Find("ticket/Text"), i18n("multiple_sorties_challenge_ticket_use"))
end

function var0.SetActivity(arg0, arg1)
	arg0.activity = arg1
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.panel:Find("battle"), function()
		local var0 = arg0.contextData.battleTimes

		if arg0.contextData.oilCost * var0 > getProxy(PlayerProxy):getRawData().oil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

			return
		end

		arg0:emit(PreCombatMediator.CONTINUOUS_OPERATION)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("window/top/btnBack"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	arg0._pageUtil:setNumUpdate(function(arg0)
		arg0.contextData.battleTimes = arg0

		arg0:UpdateContent()
	end)

	local var0 = arg0.contextData.maxCount

	arg0._pageUtil:setMaxNum(var0)

	arg0.contextData.battleTimes = arg0.contextData.battleTimes or 1

	arg0._pageUtil:setDefaultNum(arg0.contextData.battleTimes)
	arg0:UpdateContent()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.UpdateContent(arg0)
	local var0 = arg0.contextData.battleTimes
	local var1 = arg0.contextData.oilCost * var0
	local var2 = i18n("multiple_sorties_cost1", var1)

	if var1 > getProxy(PlayerProxy):getRawData().oil then
		var2 = string.gsub(var2, "#92fc63", COLOR_RED)
	end

	arg0.consumeText.text = var2
end

return var0

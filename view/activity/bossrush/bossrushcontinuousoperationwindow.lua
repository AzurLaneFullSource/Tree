local var0_0 = class("BossRushContinuousOperationWindow", import("view.activity.worldboss.ContinuousOperationWindow"))

function var0_0.getUIName(arg0_1)
	return "BossRushContinuousOperationWindowUI"
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
	setText(arg0_3.panel:Find("Tip"), i18n("multiple_sorties_tip"))
	setText(arg0_3.panel:Find("battle/pic"), i18n("msgbox_text_battle"))
	setText(arg0_3.panel:Find("bonus/Text"), i18n("expedition_extra_drop_tip"))
	setText(arg0_3.panel:Find("ticket/Text"), i18n("multiple_sorties_challenge_ticket_use"))
end

function var0_0.SetActivity(arg0_4, arg1_4)
	arg0_4.activity = arg1_4
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.panel:Find("battle"), function()
		local var0_6 = arg0_5.contextData.battleTimes

		if arg0_5.contextData.oilCost * var0_6 > getProxy(PlayerProxy):getRawData().oil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

			return
		end

		arg0_5:emit(PreCombatMediator.CONTINUOUS_OPERATION)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("window/top/btnBack"), function()
		arg0_5:closeView()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5._tf:Find("bg"), function()
		arg0_5:closeView()
	end, SFX_CANCEL)
	arg0_5._pageUtil:setNumUpdate(function(arg0_9)
		arg0_5.contextData.battleTimes = arg0_9

		arg0_5:UpdateContent()
	end)

	local var0_5 = arg0_5.contextData.maxCount

	arg0_5._pageUtil:setMaxNum(var0_5)

	arg0_5.contextData.battleTimes = arg0_5.contextData.battleTimes or 1

	arg0_5._pageUtil:setDefaultNum(arg0_5.contextData.battleTimes)
	arg0_5:UpdateContent()
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf)
end

function var0_0.UpdateContent(arg0_10)
	local var0_10 = arg0_10.contextData.battleTimes
	local var1_10 = arg0_10.contextData.oilCost * var0_10
	local var2_10 = i18n("multiple_sorties_cost1", var1_10)

	if var1_10 > getProxy(PlayerProxy):getRawData().oil then
		var2_10 = string.gsub(var2_10, "#92fc63", COLOR_RED)
	end

	arg0_10.consumeText.text = var2_10
end

return var0_0

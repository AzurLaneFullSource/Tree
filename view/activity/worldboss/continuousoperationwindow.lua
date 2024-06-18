local var0_0 = class("ContinuousOperationWindow", import("view.base.BaseUI"))
local var1_0 = 15

function var0_0.getUIName(arg0_1)
	return "ContinuousOperationWindowUI"
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

	local var0_5 = getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1

	arg0_5.contextData.useTicket = defaultValue(arg0_5.contextData.useTicket, var0_5)

	triggerToggle(arg0_5.panel:Find("ticket/checkbox"), var0_5)
	onToggle(arg0_5, arg0_5.panel:Find("ticket/checkbox"), function(arg0_9)
		arg0_5.contextData.useTicket = arg0_9

		arg0_5:UpdateContent()
	end, SFX_PANEL, SFX_CANCEL)

	local var1_5 = arg0_5.activity:getConfig("config_id")
	local var2_5 = pg.activity_event_worldboss[var1_5].ticket
	local var3_5 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var2_5
	}):getIcon()
	local var4_5 = LoadSprite(var3_5, "")

	arg0_5.consumeText:AddSprite("ticket", var4_5)
	setImageSprite(arg0_5.panel:Find("ticket/Text/Icon"), var4_5)
	arg0_5._pageUtil:setNumUpdate(function(arg0_10)
		arg0_5.contextData.battleTimes = arg0_10

		arg0_5:UpdateContent()
	end)
	arg0_5._pageUtil:setMaxNum(var1_0)

	arg0_5.contextData.battleTimes = arg0_5.contextData.battleTimes or 1

	arg0_5._pageUtil:setDefaultNum(arg0_5.contextData.battleTimes)
	arg0_5:UpdateContent()
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf)
end

function var0_0.UpdateContent(arg0_11)
	local var0_11 = arg0_11.contextData.battleTimes
	local var1_11 = arg0_11.contextData.stageId
	local var2_11 = arg0_11.activity:getConfig("config_id")
	local var3_11 = pg.activity_event_worldboss[var2_11].ticket
	local var4_11 = getProxy(PlayerProxy):getRawData():getResource(var3_11)
	local var5_11 = arg0_11.activity:GetStageBonus(var1_11)
	local var6_11 = math.clamp(var0_11 - var5_11, 0, var4_11)
	local var7_11 = arg0_11.contextData.useTicket and var6_11 or 0
	local var8_11 = tostring(var5_11)

	if var7_11 > 0 then
		var8_11 = var8_11 .. setColorStr("+" .. var7_11, COLOR_GREEN)
	end

	setText(arg0_11.panel:Find("bonus/Number"), var8_11)
	setText(arg0_11.panel:Find("ticket/Number"), var7_11 .. "/" .. var4_11)

	local var9_11 = var4_11 > 0 and var6_11 > 0

	setActive(arg0_11.panel:Find("ticket/checkboxBan"), not var9_11)
	setToggleEnabled(arg0_11.panel:Find("ticket/checkbox"), var9_11)

	local var10_11 = arg0_11.contextData.oilCost * var0_11
	local var11_11 = i18n("multiple_sorties_cost1", var10_11)

	if var10_11 > getProxy(PlayerProxy):getRawData().oil then
		var11_11 = string.gsub(var11_11, "#92fc63", COLOR_RED)
	end

	if var7_11 > 0 then
		var11_11 = var11_11 .. i18n("multiple_sorties_cost2", var7_11)
	end

	arg0_11.consumeText.text = var11_11
end

function var0_0.willExit(arg0_12)
	arg0_12._pageUtil:Dispose()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_12._tf)
end

return var0_0

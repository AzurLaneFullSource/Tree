local var0 = class("ContinuousOperationWindow", import("view.base.BaseUI"))
local var1 = 15

function var0.getUIName(arg0)
	return "ContinuousOperationWindowUI"
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

	local var0 = getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1

	arg0.contextData.useTicket = defaultValue(arg0.contextData.useTicket, var0)

	triggerToggle(arg0.panel:Find("ticket/checkbox"), var0)
	onToggle(arg0, arg0.panel:Find("ticket/checkbox"), function(arg0)
		arg0.contextData.useTicket = arg0

		arg0:UpdateContent()
	end, SFX_PANEL, SFX_CANCEL)

	local var1 = arg0.activity:getConfig("config_id")
	local var2 = pg.activity_event_worldboss[var1].ticket
	local var3 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var2
	}):getIcon()
	local var4 = LoadSprite(var3, "")

	arg0.consumeText:AddSprite("ticket", var4)
	setImageSprite(arg0.panel:Find("ticket/Text/Icon"), var4)
	arg0._pageUtil:setNumUpdate(function(arg0)
		arg0.contextData.battleTimes = arg0

		arg0:UpdateContent()
	end)
	arg0._pageUtil:setMaxNum(var1)

	arg0.contextData.battleTimes = arg0.contextData.battleTimes or 1

	arg0._pageUtil:setDefaultNum(arg0.contextData.battleTimes)
	arg0:UpdateContent()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.UpdateContent(arg0)
	local var0 = arg0.contextData.battleTimes
	local var1 = arg0.contextData.stageId
	local var2 = arg0.activity:getConfig("config_id")
	local var3 = pg.activity_event_worldboss[var2].ticket
	local var4 = getProxy(PlayerProxy):getRawData():getResource(var3)
	local var5 = arg0.activity:GetStageBonus(var1)
	local var6 = math.clamp(var0 - var5, 0, var4)
	local var7 = arg0.contextData.useTicket and var6 or 0
	local var8 = tostring(var5)

	if var7 > 0 then
		var8 = var8 .. setColorStr("+" .. var7, COLOR_GREEN)
	end

	setText(arg0.panel:Find("bonus/Number"), var8)
	setText(arg0.panel:Find("ticket/Number"), var7 .. "/" .. var4)

	local var9 = var4 > 0 and var6 > 0

	setActive(arg0.panel:Find("ticket/checkboxBan"), not var9)
	setToggleEnabled(arg0.panel:Find("ticket/checkbox"), var9)

	local var10 = arg0.contextData.oilCost * var0
	local var11 = i18n("multiple_sorties_cost1", var10)

	if var10 > getProxy(PlayerProxy):getRawData().oil then
		var11 = string.gsub(var11, "#92fc63", COLOR_RED)
	end

	if var7 > 0 then
		var11 = var11 .. i18n("multiple_sorties_cost2", var7)
	end

	arg0.consumeText.text = var11
end

function var0.willExit(arg0)
	arg0._pageUtil:Dispose()
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0

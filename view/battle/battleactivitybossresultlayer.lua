local var0_0 = class("BattleActivityBossResultLayer", import(".BattleResultLayer"))

function var0_0.showRightBottomPanel(arg0_1)
	local var0_1 = arg0_1._blurConatiner:Find("activitybossConfirmPanel")

	setActive(var0_1, true)
	var0_0.super.showRightBottomPanel(arg0_1)
	SetActive(arg0_1._rightBottomPanel, false)

	local var1_1 = arg0_1.contextData.system
	local var2_1 = var1_1 ~= SYSTEM_BOSS_EXPERIMENT

	setActive(var0_1:Find("playAgain"), var2_1)
	onButton(arg0_1, var0_1:Find("statisticsBtn"), function()
		setActive(var0_1:Find("playAgain"), arg0_1._atkBG.gameObject.activeSelf and var2_1)
		triggerButton(arg0_1._statisticsBtn)
	end, SFX_PANEL)
	setText(var0_1:Find("confirmBtn/Image"), i18n("text_confirm"))
	onButton(arg0_1, var0_1:Find("confirmBtn"), function()
		triggerButton(arg0_1._confirmBtn)
	end, SFX_CONFIRM)
	setText(var0_1:Find("confirmBtn/Image"), i18n("text_confirm"))
	setText(var0_1:Find("playAgain/Image"), i18n("re_battle"))
	setText(var0_1:Find("playAgain/bonus/title"), i18n("expedition_extra_drop_tip"))

	local var3_1 = getProxy(FleetProxy):getActivityFleets()[arg0_1.contextData.actId]
	local var4_1 = var0_1:Find("playAgain/bonus")
	local var5_1 = var0_1:Find("playAgain/ticket")
	local var6_1 = getProxy(ActivityProxy):getActivityById(arg0_1.contextData.actId)
	local var7_1 = arg0_1.contextData.stageId
	local var8_1 = var6_1:getConfig("config_id")
	local var9_1 = pg.activity_event_worldboss[var8_1]
	local var10_1 = var9_1.ticket
	local var11_1 = var6_1:GetStageBonus(var7_1)
	local var12_1 = var6_1:IsOilLimit(var7_1)
	local var13_1 = 0
	local var14_1 = var9_1.use_oil_limit[arg0_1.contextData.mainFleetId]

	;(function(arg0_4, arg1_4)
		local var0_4 = arg0_4:GetCostSum().oil

		if arg1_4 > 0 then
			var0_4 = math.min(var0_4, var14_1[1])
		end

		var13_1 = var13_1 + var0_4
	end)(var3_1[arg0_1.contextData.mainFleetId], var12_1 and var14_1[1] or 0)
	setText(var0_1:Find("playAgain/Text"), var13_1)

	local var15_1
	local var16_1

	setActive(var4_1, var11_1 > 0)
	setActive(var5_1, var11_1 <= 0)
	setText(var4_1:Find("Text"), var11_1)

	if var11_1 <= 0 then
		local var17_1 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var10_1
		}):getIcon()
		local var18_1 = GetSpriteFromAtlas(var17_1, "")

		setImageSprite(var5_1:Find("icon"), var18_1)

		local var19_1 = getProxy(PlayerProxy):getRawData():getResource(var10_1)

		var16_1 = getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1
		var15_1 = var19_1 > 0

		local var20_1 = 1
		local var21_1 = var5_1:Find("checkbox")

		if var1_1 == SYSTEM_BOSS_EXPERIMENT then
			var20_1 = 0

			triggerToggle(var21_1, false)
			setToggleEnabled(var21_1, false)
		elseif var1_1 == SYSTEM_HP_SHARE_ACT_BOSS then
			triggerToggle(var21_1, true)
			setToggleEnabled(var21_1, false)
		elseif var1_1 == SYSTEM_ACT_BOSS then
			setToggleEnabled(var21_1, var15_1)
			triggerToggle(var21_1, var15_1 and var16_1)
		end

		var19_1 = var19_1 < var20_1 and setColorStr(var19_1, COLOR_RED) or var19_1

		setText(var5_1:Find("Text"), var20_1 .. "/" .. var19_1)
		onToggle(arg0_1, var21_1, function(arg0_5)
			var16_1 = arg0_5

			getProxy(SettingsProxy):setActBossExchangeTicketTip(arg0_5 and 1 or 0)
		end, SFX_PANEL, SFX_CANCEL)
	end

	onButton(arg0_1, var0_1:Find("playAgain"), function()
		if arg0_1.contextData.isLastBonus then
			arg0_1:PassMsgbox("lastBonus", {
				content = i18n("expedition_drop_use_out")
			})

			return
		end

		if var1_1 == SYSTEM_HP_SHARE_ACT_BOSS and not var15_1 then
			pg.m02:sendNotification(GAME.GO_BACK)
			pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noTicket"))

			return
		end

		local var0_6 = pg.battle_cost_template[arg0_1.contextData.system].oil_cost > 0
		local var1_6 = getProxy(PlayerProxy):getRawData().oil

		if var0_6 and var1_6 < var13_1 then
			arg0_1:PassMsgbox("oil", var13_1)

			return
		end

		if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
			arg0_1:PassMsgbox("shipCapacity")

			return
		end

		local var2_6 = var3_1[arg0_1.contextData.mainFleetId]

		if _.any(_.values(var2_6.ships), function(arg0_7)
			local var0_7 = getProxy(BayProxy):getShipById(arg0_7)

			return var0_7 and var0_7.energy == Ship.ENERGY_LOW
		end) then
			arg0_1:PassMsgbox("energy", var2_6)

			return
		end

		if var1_1 == SYSTEM_ACT_BOSS and var15_1 and var16_1 then
			pg.m02:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
				stageId = var7_1
			})

			return
		end

		arg0_1:emit(NewBattleResultMediator.REENTER_STAGE)
	end)
end

function var0_0.PassMsgbox(arg0_8, arg1_8, arg2_8)
	getProxy(ContextProxy):GetPrevContext(1).data.msg = {
		type = arg1_8,
		param = arg2_8
	}

	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0_0.HideConfirmPanel(arg0_9)
	local var0_9 = arg0_9._blurConatiner:Find("activitybossConfirmPanel")

	setActive(var0_9, false)
end

return var0_0

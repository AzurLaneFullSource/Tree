local var0 = class("BattleActivityBossResultLayer", import(".BattleResultLayer"))

function var0.showRightBottomPanel(arg0)
	local var0 = arg0._blurConatiner:Find("activitybossConfirmPanel")

	setActive(var0, true)
	var0.super.showRightBottomPanel(arg0)
	SetActive(arg0._rightBottomPanel, false)

	local var1 = arg0.contextData.system
	local var2 = var1 ~= SYSTEM_BOSS_EXPERIMENT

	setActive(var0:Find("playAgain"), var2)
	onButton(arg0, var0:Find("statisticsBtn"), function()
		setActive(var0:Find("playAgain"), arg0._atkBG.gameObject.activeSelf and var2)
		triggerButton(arg0._statisticsBtn)
	end, SFX_PANEL)
	setText(var0:Find("confirmBtn/Image"), i18n("text_confirm"))
	onButton(arg0, var0:Find("confirmBtn"), function()
		triggerButton(arg0._confirmBtn)
	end, SFX_CONFIRM)
	setText(var0:Find("confirmBtn/Image"), i18n("text_confirm"))
	setText(var0:Find("playAgain/Image"), i18n("re_battle"))
	setText(var0:Find("playAgain/bonus/title"), i18n("expedition_extra_drop_tip"))

	local var3 = getProxy(FleetProxy):getActivityFleets()[arg0.contextData.actId]
	local var4 = var0:Find("playAgain/bonus")
	local var5 = var0:Find("playAgain/ticket")
	local var6 = getProxy(ActivityProxy):getActivityById(arg0.contextData.actId)
	local var7 = arg0.contextData.stageId
	local var8 = var6:getConfig("config_id")
	local var9 = pg.activity_event_worldboss[var8]
	local var10 = var9.ticket
	local var11 = var6:GetStageBonus(var7)
	local var12 = var6:IsOilLimit(var7)
	local var13 = 0
	local var14 = var9.use_oil_limit[arg0.contextData.mainFleetId]

	;(function(arg0, arg1)
		local var0 = arg0:GetCostSum().oil

		if arg1 > 0 then
			var0 = math.min(var0, var14[1])
		end

		var13 = var13 + var0
	end)(var3[arg0.contextData.mainFleetId], var12 and var14[1] or 0)
	setText(var0:Find("playAgain/Text"), var13)

	local var15
	local var16

	setActive(var4, var11 > 0)
	setActive(var5, var11 <= 0)
	setText(var4:Find("Text"), var11)

	if var11 <= 0 then
		local var17 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var10
		}):getIcon()
		local var18 = GetSpriteFromAtlas(var17, "")

		setImageSprite(var5:Find("icon"), var18)

		local var19 = getProxy(PlayerProxy):getRawData():getResource(var10)

		var16 = getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1
		var15 = var19 > 0

		local var20 = 1
		local var21 = var5:Find("checkbox")

		if var1 == SYSTEM_BOSS_EXPERIMENT then
			var20 = 0

			triggerToggle(var21, false)
			setToggleEnabled(var21, false)
		elseif var1 == SYSTEM_HP_SHARE_ACT_BOSS then
			triggerToggle(var21, true)
			setToggleEnabled(var21, false)
		elseif var1 == SYSTEM_ACT_BOSS then
			setToggleEnabled(var21, var15)
			triggerToggle(var21, var15 and var16)
		end

		var19 = var19 < var20 and setColorStr(var19, COLOR_RED) or var19

		setText(var5:Find("Text"), var20 .. "/" .. var19)
		onToggle(arg0, var21, function(arg0)
			var16 = arg0

			getProxy(SettingsProxy):setActBossExchangeTicketTip(arg0 and 1 or 0)
		end, SFX_PANEL, SFX_CANCEL)
	end

	onButton(arg0, var0:Find("playAgain"), function()
		if arg0.contextData.isLastBonus then
			arg0:PassMsgbox("lastBonus", {
				content = i18n("expedition_drop_use_out")
			})

			return
		end

		if var1 == SYSTEM_HP_SHARE_ACT_BOSS and not var15 then
			pg.m02:sendNotification(GAME.GO_BACK)
			pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noTicket"))

			return
		end

		local var0 = pg.battle_cost_template[arg0.contextData.system].oil_cost > 0
		local var1 = getProxy(PlayerProxy):getRawData().oil

		if var0 and var1 < var13 then
			arg0:PassMsgbox("oil", var13)

			return
		end

		if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
			arg0:PassMsgbox("shipCapacity")

			return
		end

		local var2 = var3[arg0.contextData.mainFleetId]

		if _.any(_.values(var2.ships), function(arg0)
			local var0 = getProxy(BayProxy):getShipById(arg0)

			return var0 and var0.energy == Ship.ENERGY_LOW
		end) then
			arg0:PassMsgbox("energy", var2)

			return
		end

		if var1 == SYSTEM_ACT_BOSS and var15 and var16 then
			pg.m02:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
				stageId = var7
			})

			return
		end

		arg0:emit(NewBattleResultMediator.REENTER_STAGE)
	end)
end

function var0.PassMsgbox(arg0, arg1, arg2)
	getProxy(ContextProxy):GetPrevContext(1).data.msg = {
		type = arg1,
		param = arg2
	}

	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0.HideConfirmPanel(arg0)
	local var0 = arg0._blurConatiner:Find("activitybossConfirmPanel")

	setActive(var0, false)
end

return var0

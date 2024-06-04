local var0 = class("NewHpShareActBossResultStatisticsPage", import("..activityBoss.NewActivityBossResultStatisticsPage"))

function var0.UpdateGrade(arg0)
	local var0 = "battlescore/grade_label_clear"

	LoadImageSpriteAsync(var0, arg0.gradeTxt, false)
	setActive(arg0.gradeIcon, false)
end

function var0.UpdateTicket(arg0, arg1)
	var0.super.UpdateTicket(arg0, arg1)

	local var0 = arg1:Find("playAgain/ticket/checkbox")

	triggerToggle(var0, true)
	setToggleEnabled(var0, false)
end

function var0.EnoughTicketCount(arg0)
	local var0 = arg0:GetTicketItemID(arg0.contextData.actId)

	return getProxy(PlayerProxy):getRawData():getResource(var0) > 0
end

function var0.OnPlayAgain(arg0, arg1)
	if arg0:IsLastBonus() then
		arg0:PassMsgbox("lastBonus", {
			content = i18n("expedition_drop_use_out")
		}, arg1)

		return
	end

	if not arg0:EnoughTicketCount() then
		arg1()
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noTicket"))

		return
	end

	local var0, var1 = arg0:NotEnoughOilCost()

	if var0 then
		arg0:PassMsgbox("oil", var1, arg1)

		return
	end

	if arg0:NotEnoughShipBag() then
		arg0:PassMsgbox("shipCapacity", nil, arg1)

		return
	end

	local var2, var3 = arg0:NotEnoughEnergy()

	if var2 then
		arg0:PassMsgbox("energy", var3, arg1)

		return
	end

	arg0:emit(NewBattleResultMediator.REENTER_STAGE)
end

return var0

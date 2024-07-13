local var0_0 = class("NewHpShareActBossResultStatisticsPage", import("..activityBoss.NewActivityBossResultStatisticsPage"))

function var0_0.UpdateGrade(arg0_1)
	local var0_1 = "battlescore/grade_label_clear"

	LoadImageSpriteAsync(var0_1, arg0_1.gradeTxt, false)
	setActive(arg0_1.gradeIcon, false)
end

function var0_0.UpdateTicket(arg0_2, arg1_2)
	var0_0.super.UpdateTicket(arg0_2, arg1_2)

	local var0_2 = arg1_2:Find("playAgain/ticket/checkbox")

	triggerToggle(var0_2, true)
	setToggleEnabled(var0_2, false)
end

function var0_0.EnoughTicketCount(arg0_3)
	local var0_3 = arg0_3:GetTicketItemID(arg0_3.contextData.actId)

	return getProxy(PlayerProxy):getRawData():getResource(var0_3) > 0
end

function var0_0.OnPlayAgain(arg0_4, arg1_4)
	if arg0_4:IsLastBonus() then
		arg0_4:PassMsgbox("lastBonus", {
			content = i18n("expedition_drop_use_out")
		}, arg1_4)

		return
	end

	if not arg0_4:EnoughTicketCount() then
		arg1_4()
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noTicket"))

		return
	end

	local var0_4, var1_4 = arg0_4:NotEnoughOilCost()

	if var0_4 then
		arg0_4:PassMsgbox("oil", var1_4, arg1_4)

		return
	end

	if arg0_4:NotEnoughShipBag() then
		arg0_4:PassMsgbox("shipCapacity", nil, arg1_4)

		return
	end

	local var2_4, var3_4 = arg0_4:NotEnoughEnergy()

	if var2_4 then
		arg0_4:PassMsgbox("energy", var3_4, arg1_4)

		return
	end

	arg0_4:emit(NewBattleResultMediator.REENTER_STAGE)
end

return var0_0

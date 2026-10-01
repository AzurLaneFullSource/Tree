local var0_0 = class("WorldCruiseAwardPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "WorldCruiseAwardPage"
end

function var0_0.UpdateActivity(arg0_2, arg1_2)
	arg0_2.activity = arg1_2 or getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	for iter0_2, iter1_2 in pairs(arg0_2.activity:GetCrusingInfo()) do
		arg0_2[iter0_2] = iter1_2
	end
end

function var0_0.OnLoaded(arg0_3)
	arg0_3:UpdateActivity()

	local var0_3 = arg0_3._tf:Find("frame")

	arg0_3.nextAwardTF = var0_3:Find("next")
	arg0_3.btnAll = var0_3:Find("btns/btn_all")

	setText(arg0_3.btnAll:Find("Text"), i18n("cruise_btn_all"))

	arg0_3.btnPay = var0_3:Find("btns/btn_pay")

	setText(arg0_3.btnPay:Find("Text"), i18n("cruise_btn_pay"))

	arg0_3.btnPayPrev = var0_3:Find("btns/btn_pay_prev")

	setText(arg0_3.btnPayPrev:Find("Text"), i18n("cruise_btn_pay_prev"))

	arg0_3.scrollCom = GetComponent(var0_3:Find("view/content"), "LScrollRect")

	function arg0_3.scrollCom.onUpdateItem(arg0_4, arg1_4)
		arg0_3:UpdateAwardInfo(arg0_4, tf(arg1_4), arg0_3.awardList[arg0_4 + 1])
	end
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5.btnAll, function()
		arg0_5:GetAllAward()
	end, SFX_CONFIRM)
	onButton(arg0_5, arg0_5.btnPay, function()
		arg0_5.contextData.windowForCharge:ExecuteAction("ShowBuyWindow")
	end, SFX_CONFIRM)
	onButton(arg0_5, arg0_5.btnPayPrev, function()
		arg0_5.contextData.prevChargePage:ExecuteAction("ShowBuyWindow")
	end, SFX_CONFIRM)

	local var0_5 = arg0_5.scrollCom.onValueChanged

	var0_5:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_5, var0_5)
	var0_5:AddListener(function(arg0_9)
		arg0_5:UpdateNextAward(arg0_9.x)
	end)
end

function var0_0.Flush(arg0_10, arg1_10)
	arg0_10:Show()

	if arg1_10 then
		arg0_10:UpdateActivity(arg1_10)
	end

	arg0_10:UpdateBtnPayPrev()
	arg0_10.scrollCom:SetTotalCount(#arg0_10.awardList - 1)
	arg0_10:BuildPhaseAwardScrollPos()

	if arg0_10.phase == 0 then
		arg0_10.scrollCom:ScrollTo(0)
	elseif arg0_10.phase == #arg0_10.awardList then
		arg0_10.scrollCom:ScrollTo(1)
	else
		arg0_10.scrollCom:ScrollTo(math.clamp(arg0_10.phasePos[arg0_10.phase], 0, 1), true)
	end

	arg0_10.nextAwardIndex = nil

	local var0_10 = #arg0_10.activity:GetCrusingUnreceiveAward() > 0

	setActive(arg0_10.btnAll, var0_10)
	setActive(arg0_10.btnPay, not arg0_10.isPay)

	if not arg0_10.isPay then
		local var1_10 = WorldCruiseChargePage.GetPassID()

		if not pg.TimeMgr.GetInstance():inTime(pg.pay_data_display[var1_10].time) then
			setActive(arg0_10.btnPay, false)
		end
	end

	arg0_10:UpdateNextAward(arg0_10.scrollCom.value)
end

function var0_0.UpdateBtnPayPrev(arg0_11)
	local var0_11 = PrevPeriodCrusingActivity.StaticExistPrevPeriodCrusingActivity()

	setActive(arg0_11.btnPayPrev, var0_11)
end

function var0_0.BuildPhaseAwardScrollPos(arg0_12)
	if arg0_12.phasePos then
		return
	end

	arg0_12.phasePos = {}
	arg0_12.nextPhasePos = {}

	local var0_12 = arg0_12.scrollCom:HeadIndexToValue(#arg0_12.awardList) - arg0_12.scrollCom:HeadIndexToValue(0)
	local var1_12 = arg0_12.scrollCom:HeadIndexToValue(#arg0_12.awardList - 6) - arg0_12.scrollCom:HeadIndexToValue(0)

	for iter0_12 = 1, #arg0_12.awardList - 1 do
		table.insert(arg0_12.phasePos, arg0_12.scrollCom:HeadIndexToValue(iter0_12 - 1) / var0_12)
		table.insert(arg0_12.nextPhasePos, arg0_12.scrollCom:HeadIndexToValue(iter0_12 - 1) / var1_12)
	end
end

function var0_0.IsSpecialMask(arg0_13, arg1_13)
	return arg1_13 == DROP_TYPE_COMBAT_UI_STYLE or arg1_13 == DROP_TYPE_SKIN or arg1_13 == DROP_TYPE_EQUIPMENT_SKIN
end

function var0_0.IsSkinFrame(arg0_14, arg1_14)
	return arg1_14 == DROP_TYPE_SKIN or arg1_14 == DROP_TYPE_EQUIPMENT_SKIN
end

function var0_0.IsBattleUIFrame(arg0_15, arg1_15)
	return arg1_15 == DROP_TYPE_COMBAT_UI_STYLE
end

function var0_0.UpdateAwardInfo(arg0_16, arg1_16, arg2_16, arg3_16)
	if arg2_16:Find("bg_cur") then
		setActive(arg2_16:Find("bg_cur"), arg1_16 + 2 == arg0_16.phase)
	end

	setText(arg2_16:Find("Text"), arg3_16.id)

	local var0_16 = arg3_16.pt <= arg0_16.pt
	local var1_16 = Drop.Create(arg3_16.award)

	onButton(arg0_16, arg2_16:Find("base"), function()
		arg0_16:emit(BaseUI.ON_NEW_STYLE_DROP, {
			drop = var1_16
		})
	end, SFX_CONFIRM)
	updateDrop(arg2_16:Find("base/mask/IconTpl"), var1_16)
	setActive(arg2_16:Find("base/frame_skin"), arg0_16:IsSkinFrame(var1_16.type))
	setActive(arg2_16:Find("base/frame_ui"), arg0_16:IsBattleUIFrame(var1_16.type))
	setActive(arg2_16:Find("base/lock"), not var0_16)
	setActive(arg2_16:Find("base/get"), var0_16 and not arg0_16.awardDic[arg3_16.pt])
	setActive(arg2_16:Find("base/got"), arg0_16.awardDic[arg3_16.pt] and not arg0_16:IsSpecialMask(var1_16.type))
	setActive(arg2_16:Find("base/got_frame"), arg0_16.awardDic[arg3_16.pt] and arg0_16:IsSpecialMask(var1_16.type))

	local var2_16 = Drop.Create(arg3_16.award_pay)

	onButton(arg0_16, arg2_16:Find("pay"), function()
		arg0_16:emit(BaseUI.ON_NEW_STYLE_DROP, {
			drop = var2_16
		})
	end, SFX_CONFIRM)
	updateDrop(arg2_16:Find("pay/mask/IconTpl"), var2_16)
	setActive(arg2_16:Find("pay/frame_skin"), arg0_16:IsSkinFrame(var2_16.type))
	setActive(arg2_16:Find("pay/frame_ui"), arg0_16:IsBattleUIFrame(var2_16.type))
	setActive(arg2_16:Find("pay/no_pay"), not arg0_16.isPay and not arg0_16:IsSpecialMask(var2_16.type))
	setActive(arg2_16:Find("pay/no_pay_frame"), not arg0_16.isPay and arg0_16:IsSpecialMask(var2_16.type))
	setActive(arg2_16:Find("pay/lock"), not var0_16 or not arg0_16.isPay)
	setActive(arg2_16:Find("pay/get"), arg0_16.isPay and var0_16 and not arg0_16.awardPayDic[arg3_16.pt])
	setActive(arg2_16:Find("pay/got"), arg0_16.awardPayDic[arg3_16.pt] and not arg0_16:IsSpecialMask(var2_16.type))
	setActive(arg2_16:Find("pay/got_frame"), arg0_16.awardPayDic[arg3_16.pt] and arg0_16:IsSpecialMask(var2_16.type))
end

function var0_0.UpdateNextAward(arg0_19, arg1_19)
	if not arg0_19.nextPhasePos then
		return
	end

	local var0_19 = arg0_19.nextPhasePos[#arg0_19.nextPhasePos] - 1
	local var1_19 = #arg0_19.awardList

	for iter0_19 = var1_19 - 1, 1, -1 do
		local var2_19 = arg0_19.awardList[iter0_19]

		if arg0_19.nextPhasePos[iter0_19] < arg1_19 + var0_19 or var2_19.pt <= arg0_19.pt then
			break
		elseif var2_19.isImportent then
			var1_19 = iter0_19
		end
	end

	if arg0_19.nextAwardIndex ~= var1_19 then
		arg0_19.nextAwardIndex = var1_19

		arg0_19:UpdateAwardInfo(arg0_19.nextAwardIndex, arg0_19.nextAwardTF, arg0_19.awardList[var1_19])
	end
end

function var0_0.GetAllAward(arg0_20)
	local var0_20 = arg0_20.activity:GetCrusingUnreceiveAward()

	if #var0_20 > 0 then
		local var1_20 = {}

		if arg0_20:CheckLimitMax(var0_20) then
			table.insert(var1_20, function(arg0_21)
				pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
					contentText = i18n("player_expResource_mail_fullBag"),
					onConfirm = arg0_21
				})
			end)
		end

		seriesAsync(var1_20, function()
			arg0_20:emit(WorldCruiseMediator.EVENT_GET_AWARD_ALL)
		end)
	end
end

function var0_0.CheckLimitMax(arg0_23, arg1_23)
	local var0_23 = getProxy(PlayerProxy):getData()

	for iter0_23, iter1_23 in ipairs(arg1_23) do
		if iter1_23.type == DROP_TYPE_RESOURCE then
			if iter1_23.id == 1 then
				if var0_23:GoldMax(iter1_23.count) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))

					return true
				end
			elseif iter1_23.id == 2 and var0_23:OilMax(iter1_23.count) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title"))

				return true
			end
		elseif iter1_23.type == DROP_TYPE_ITEM then
			local var1_23 = Item.getConfigData(iter1_23.id)

			if var1_23.type == Item.EXP_BOOK_TYPE and getProxy(BagProxy):getItemCountById(iter1_23.id) + iter1_23.count > var1_23.max_num then
				return true
			end
		end
	end

	return false
end

function var0_0.OnDestroy(arg0_24)
	return
end

return var0_0

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
		arg0_5:OpenBuyPanel()
	end, SFX_CONFIRM)

	local var0_5 = arg0_5.scrollCom.onValueChanged

	var0_5:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_5, var0_5)
	var0_5:AddListener(function(arg0_8)
		arg0_5:UpdateNextAward(arg0_8.x)
	end)
end

function var0_0.Flush(arg0_9, arg1_9)
	arg0_9:Show()

	if arg1_9 then
		arg0_9:UpdateActivity(arg1_9)
	end

	arg0_9.scrollCom:SetTotalCount(#arg0_9.awardList - 1)
	arg0_9:BuildPhaseAwardScrollPos()

	if arg0_9.phase == 0 then
		arg0_9.scrollCom:ScrollTo(0)
	elseif arg0_9.phase == #arg0_9.awardList then
		arg0_9.scrollCom:ScrollTo(1)
	else
		arg0_9.scrollCom:ScrollTo(math.clamp(arg0_9.phasePos[arg0_9.phase], 0, 1), true)
	end

	arg0_9.nextAwardIndex = nil

	local var0_9 = #arg0_9.activity:GetCrusingUnreceiveAward() > 0

	setActive(arg0_9.btnAll, var0_9)
	setActive(arg0_9.btnPay, not arg0_9.isPay)

	if not arg0_9.isPay then
		local var1_9 = arg0_9:GetPassID()

		if not pg.TimeMgr.GetInstance():inTime(pg.pay_data_display[var1_9].time) then
			setActive(arg0_9.btnPay, false)
		end
	end

	arg0_9:UpdateNextAward(arg0_9.scrollCom.value)
end

function var0_0.BuildPhaseAwardScrollPos(arg0_10)
	if arg0_10.phasePos then
		return
	end

	arg0_10.phasePos = {}
	arg0_10.nextPhasePos = {}

	local var0_10 = arg0_10.scrollCom:HeadIndexToValue(#arg0_10.awardList) - arg0_10.scrollCom:HeadIndexToValue(0)
	local var1_10 = arg0_10.scrollCom:HeadIndexToValue(#arg0_10.awardList - 6) - arg0_10.scrollCom:HeadIndexToValue(0)

	for iter0_10 = 1, #arg0_10.awardList - 1 do
		table.insert(arg0_10.phasePos, arg0_10.scrollCom:HeadIndexToValue(iter0_10 - 1) / var0_10)
		table.insert(arg0_10.nextPhasePos, arg0_10.scrollCom:HeadIndexToValue(iter0_10 - 1) / var1_10)
	end
end

function var0_0.IsSpecialMask(arg0_11, arg1_11)
	return arg1_11 == DROP_TYPE_COMBAT_UI_STYLE or arg1_11 == DROP_TYPE_SKIN or arg1_11 == DROP_TYPE_EQUIPMENT_SKIN
end

function var0_0.IsSkinFrame(arg0_12, arg1_12)
	return arg1_12 == DROP_TYPE_SKIN or arg1_12 == DROP_TYPE_EQUIPMENT_SKIN
end

function var0_0.IsBattleUIFrame(arg0_13, arg1_13)
	return arg1_13 == DROP_TYPE_COMBAT_UI_STYLE
end

function var0_0.UpdateAwardInfo(arg0_14, arg1_14, arg2_14, arg3_14)
	if arg2_14:Find("bg_cur") then
		setActive(arg2_14:Find("bg_cur"), arg1_14 + 2 == arg0_14.phase)
	end

	setText(arg2_14:Find("Text"), arg3_14.id)

	local var0_14 = arg3_14.pt <= arg0_14.pt
	local var1_14 = Drop.Create(arg3_14.award)

	onButton(arg0_14, arg2_14:Find("base"), function()
		arg0_14:emit(BaseUI.ON_DROP, var1_14)
	end, SFX_CONFIRM)
	updateDrop(arg2_14:Find("base/mask/IconTpl"), var1_14)
	setActive(arg2_14:Find("base/frame_skin"), arg0_14:IsSkinFrame(var1_14.type))
	setActive(arg2_14:Find("base/frame_ui"), arg0_14:IsBattleUIFrame(var1_14.type))
	setActive(arg2_14:Find("base/lock"), not var0_14)
	setActive(arg2_14:Find("base/get"), var0_14 and not arg0_14.awardDic[arg3_14.pt])
	setActive(arg2_14:Find("base/got"), arg0_14.awardDic[arg3_14.pt] and not arg0_14:IsSpecialMask(var1_14.type))
	setActive(arg2_14:Find("base/got_frame"), arg0_14.awardDic[arg3_14.pt] and arg0_14:IsSpecialMask(var1_14.type))

	local var2_14 = Drop.Create(arg3_14.award_pay)

	onButton(arg0_14, arg2_14:Find("pay"), function()
		arg0_14:emit(BaseUI.ON_DROP, var2_14)
	end, SFX_CONFIRM)
	updateDrop(arg2_14:Find("pay/mask/IconTpl"), var2_14)
	setActive(arg2_14:Find("pay/frame_skin"), arg0_14:IsSkinFrame(var2_14.type))
	setActive(arg2_14:Find("pay/frame_ui"), arg0_14:IsBattleUIFrame(var2_14.type))
	setActive(arg2_14:Find("pay/no_pay"), not arg0_14.isPay and not arg0_14:IsSpecialMask(var2_14.type))
	setActive(arg2_14:Find("pay/no_pay_frame"), not arg0_14.isPay and arg0_14:IsSpecialMask(var2_14.type))
	setActive(arg2_14:Find("pay/lock"), not var0_14 or not arg0_14.isPay)
	setActive(arg2_14:Find("pay/get"), arg0_14.isPay and var0_14 and not arg0_14.awardPayDic[arg3_14.pt])
	setActive(arg2_14:Find("pay/got"), arg0_14.awardPayDic[arg3_14.pt] and not arg0_14:IsSpecialMask(var2_14.type))
	setActive(arg2_14:Find("pay/got_frame"), arg0_14.awardPayDic[arg3_14.pt] and arg0_14:IsSpecialMask(var2_14.type))
end

function var0_0.UpdateNextAward(arg0_17, arg1_17)
	if not arg0_17.nextPhasePos then
		return
	end

	local var0_17 = arg0_17.nextPhasePos[#arg0_17.nextPhasePos] - 1
	local var1_17 = #arg0_17.awardList

	for iter0_17 = var1_17 - 1, 1, -1 do
		local var2_17 = arg0_17.awardList[iter0_17]

		if arg0_17.nextPhasePos[iter0_17] < arg1_17 + var0_17 or var2_17.pt <= arg0_17.pt then
			break
		elseif var2_17.isImportent then
			var1_17 = iter0_17
		end
	end

	if arg0_17.nextAwardIndex ~= var1_17 then
		arg0_17.nextAwardIndex = var1_17

		arg0_17:UpdateAwardInfo(arg0_17.nextAwardIndex, arg0_17.nextAwardTF, arg0_17.awardList[var1_17])
	end
end

function var0_0.GetAllAward(arg0_18)
	local var0_18 = arg0_18.activity:GetCrusingUnreceiveAward()

	if #var0_18 > 0 then
		local var1_18 = {}

		if arg0_18:CheckLimitMax(var0_18) then
			table.insert(var1_18, function(arg0_19)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("player_expResource_mail_fullBag"),
					onYes = arg0_19
				})
			end)
		end

		seriesAsync(var1_18, function()
			arg0_18:emit(WorldCruiseMediator.EVENT_GET_AWARD_ALL)
		end)
	end
end

function var0_0.CheckLimitMax(arg0_21, arg1_21)
	local var0_21 = getProxy(PlayerProxy):getData()

	for iter0_21, iter1_21 in ipairs(arg1_21) do
		if iter1_21.type == DROP_TYPE_RESOURCE then
			if iter1_21.id == 1 then
				if var0_21:GoldMax(iter1_21.count) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))

					return true
				end
			elseif iter1_21.id == 2 and var0_21:OilMax(iter1_21.count) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title"))

				return true
			end
		elseif iter1_21.type == DROP_TYPE_ITEM then
			local var1_21 = Item.getConfigData(iter1_21.id)

			if var1_21.type == Item.EXP_BOOK_TYPE and getProxy(BagProxy):getItemCountById(iter1_21.id) + iter1_21.count > var1_21.max_num then
				return true
			end
		end
	end

	return false
end

function var0_0.OpenBuyPanel(arg0_22)
	local var0_22 = arg0_22:GetPassID()
	local var1_22 = Goods.Create({
		shop_id = var0_22
	}, Goods.TYPE_CHARGE)
	local var2_22 = var1_22:getConfig("tag")
	local var3_22 = var1_22:GetExtraServiceItem()
	local var4_22 = var1_22:GetExtraDrop()
	local var5_22
	local var6_22
	local var7_22
	local var8_22 = i18n("battlepass_pay_tip")
	local var9_22 = {
		isChargeType = true,
		icon = "chargeicon/" .. var1_22:getConfig("picture"),
		name = var1_22:getConfig("name_display"),
		tipExtra = var8_22,
		extraItems = var3_22,
		price = var1_22:getConfig("money"),
		isLocalPrice = var1_22:IsLocalPrice(),
		tagType = var2_22,
		isMonthCard = var1_22:isMonthCard(),
		tipBonus = var7_22,
		bonusItem = var5_22,
		extraDrop = var4_22,
		descExtra = var1_22:getConfig("descrip_extra"),
		onYes = function()
			if ChargeConst.isNeedSetBirth() then
				arg0_22:emit(WorldCruiseMediator.EVENT_OPEN_BIRTHDAY)
			else
				pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
					shopId = var1_22.id
				})
			end
		end
	}

	arg0_22:emit(WorldCruiseMediator.EVENT_GO_CHARGE, var9_22)
end

function var0_0.GetPassID(arg0_24)
	local var0_24 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if var0_24 and not var0_24:isEnd() then
		for iter0_24, iter1_24 in ipairs(pg.pay_data_display.all) do
			local var1_24 = pg.pay_data_display[iter1_24]

			if var1_24.sub_display and type(var1_24.sub_display) == "table" and var1_24.sub_display[1] == var0_24.id then
				return iter1_24
			end
		end
	end
end

function var0_0.OnDestroy(arg0_25)
	return
end

return var0_0

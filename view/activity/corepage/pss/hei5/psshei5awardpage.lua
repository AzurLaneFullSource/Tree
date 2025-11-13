local var0_0 = class("PSSHei5AwardPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "PSSHei5AwardPage"
end

function var0_0.UpdateActivity(arg0_2, arg1_2)
	arg0_2.activity = arg1_2 or getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_HEI5)

	for iter0_2, iter1_2 in pairs(arg0_2.activity:GetHei5Info()) do
		arg0_2[iter0_2] = iter1_2
	end
end

function var0_0.OnLoaded(arg0_3)
	arg0_3:UpdateActivity()

	local var0_3 = arg0_3._tf:Find("frame")

	arg0_3.nextAwardTF = var0_3:Find("next")
	arg0_3.btnAll = var0_3:Find("btns/btn_all")

	setText(arg0_3.btnAll:Find("Text"), i18n("blackfriday_cruise_btn_all"))

	arg0_3.scrollCom = GetComponent(var0_3:Find("view/content"), "LScrollRect")

	function arg0_3.scrollCom.onUpdateItem(arg0_4, arg1_4)
		arg0_3:UpdateAwardInfo(arg0_4, tf(arg1_4), arg0_3.awardList[arg0_4 + 1])
	end
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5.btnAll, function()
		arg0_5:GetAllAward()
	end, SFX_CONFIRM)

	local var0_5 = arg0_5.scrollCom.onValueChanged

	var0_5:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_5, var0_5)
	var0_5:AddListener(function(arg0_7)
		arg0_5:UpdateNextAward(arg0_7.x)
	end)
end

function var0_0.Flush(arg0_8, arg1_8)
	arg0_8:Show()

	if arg1_8 then
		arg0_8:UpdateActivity(arg1_8)
	end

	arg0_8.scrollCom:SetTotalCount(#arg0_8.awardList)
	arg0_8:BuildPhaseAwardScrollPos()

	arg0_8.nextAwardIndex = nil

	local var0_8 = #arg0_8.activity:GetHei5UnreceiveAward() > 0

	setActive(arg0_8.btnAll, var0_8)
	arg0_8:UpdateNextAward(arg0_8.scrollCom.value)
end

function var0_0.BuildPhaseAwardScrollPos(arg0_9)
	if arg0_9.phasePos then
		return
	end

	arg0_9.phasePos = {}
	arg0_9.nextPhasePos = {}

	local var0_9 = arg0_9.scrollCom:HeadIndexToValue(#arg0_9.awardList) - arg0_9.scrollCom:HeadIndexToValue(0)
	local var1_9 = arg0_9.scrollCom:HeadIndexToValue(#arg0_9.awardList - 6) - arg0_9.scrollCom:HeadIndexToValue(0)

	for iter0_9 = 1, #arg0_9.awardList - 1 do
		table.insert(arg0_9.phasePos, arg0_9.scrollCom:HeadIndexToValue(iter0_9 - 1) / var0_9)
		table.insert(arg0_9.nextPhasePos, arg0_9.scrollCom:HeadIndexToValue(iter0_9 - 1) / var1_9)
	end
end

function var0_0.IsSpecialMask(arg0_10, arg1_10)
	return arg1_10 == DROP_TYPE_COMBAT_UI_STYLE or arg1_10 == DROP_TYPE_SKIN or arg1_10 == DROP_TYPE_EQUIPMENT_SKIN
end

function var0_0.UpdateAwardInfo(arg0_11, arg1_11, arg2_11, arg3_11)
	if arg3_11.id < 10 then
		setText(arg2_11:Find("Text"), "0" .. arg3_11.id)
	else
		setText(arg2_11:Find("Text"), arg3_11.id)
	end

	local var0_11 = arg3_11.pt <= arg0_11.pt
	local var1_11 = Drop.Create(arg3_11.award)

	onButton(arg0_11, arg2_11:Find("base"), function()
		arg0_11:emit(BaseUI.ON_NEW_STYLE_DROP, {
			drop = var1_11
		})
	end, SFX_CONFIRM)
	setActive(arg2_11:Find("base/lock"), not var0_11)
	updateDrop(arg2_11:Find("base/mask/IconTpl"), var1_11)
	setActive(arg2_11:Find("base/get"), var0_11 and not arg0_11.awardDic[arg3_11.pt])
	setActive(arg2_11:Find("base/got"), arg0_11.awardDic[arg3_11.pt])

	local var2_11 = Drop.Create(arg3_11.award_pay)

	onButton(arg0_11, arg2_11:Find("pay"), function()
		arg0_11:emit(BaseUI.ON_NEW_STYLE_DROP, {
			drop = var2_11
		})
	end, SFX_CONFIRM)
	updateDrop(arg2_11:Find("pay/mask/IconTpl"), var2_11)
	setActive(arg2_11:Find("pay/no_pay"), not arg0_11.isPay and not arg0_11:IsSpecialMask(var2_11.type))
	setActive(arg2_11:Find("pay/get"), arg0_11.isPay and var0_11 and not arg0_11.awardPayDic[arg3_11.pt])
	setActive(arg2_11:Find("pay/got"), arg0_11.awardPayDic[arg3_11.pt])
end

function var0_0.UpdateNextAward(arg0_14, arg1_14)
	if not arg0_14.nextPhasePos then
		return
	end

	local var0_14 = arg0_14.nextPhasePos[#arg0_14.nextPhasePos] - 1
	local var1_14 = #arg0_14.awardList

	for iter0_14 = var1_14 - 1, 1, -1 do
		local var2_14 = arg0_14.awardList[iter0_14]

		if arg0_14.nextPhasePos[iter0_14] < arg1_14 + var0_14 or var2_14.pt <= arg0_14.pt then
			break
		elseif var2_14.isImportent then
			var1_14 = iter0_14
		end
	end

	arg0_14:UpdateAwardInfo(arg0_14.nextAwardIndex, arg0_14.nextAwardTF, arg0_14.awardList[var1_14])
end

function var0_0.GetAllAward(arg0_15)
	local var0_15 = arg0_15.activity:GetHei5UnreceiveAward()

	if #var0_15 > 0 then
		local var1_15 = {}

		if arg0_15:CheckLimitMax(var0_15) then
			table.insert(var1_15, function(arg0_16)
				pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
					contentText = i18n("player_expResource_mail_fullBag"),
					onConfirm = arg0_16
				})
			end)
		end

		seriesAsync(var1_15, function()
			arg0_15:emit(PSSHei5Mediator.EVENT_GET_AWARD_ALL)
		end)
	end
end

function var0_0.CheckLimitMax(arg0_18, arg1_18)
	local var0_18 = getProxy(PlayerProxy):getData()

	for iter0_18, iter1_18 in ipairs(arg1_18) do
		if iter1_18.type == DROP_TYPE_RESOURCE then
			if iter1_18.id == 1 then
				if var0_18:GoldMax(iter1_18.count) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))

					return true
				end
			elseif iter1_18.id == 2 and var0_18:OilMax(iter1_18.count) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title"))

				return true
			end
		elseif iter1_18.type == DROP_TYPE_ITEM then
			local var1_18 = Item.getConfigData(iter1_18.id)

			if var1_18.type == Item.EXP_BOOK_TYPE and getProxy(BagProxy):getItemCountById(iter1_18.id) + iter1_18.count > var1_18.max_num then
				return true
			end
		end
	end

	return false
end

function var0_0.OnDestroy(arg0_19)
	return
end

return var0_0

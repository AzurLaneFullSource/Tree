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

function var0_0.initTplVar(arg0_3)
	arg0_3.btnAllTip = "blackfriday_cruise_btn_all"
end

function var0_0.OnLoaded(arg0_4)
	arg0_4:initTplVar()
	arg0_4:UpdateActivity()

	local var0_4 = arg0_4._tf:Find("frame")

	arg0_4.nextAwardTF = var0_4:Find("next")
	arg0_4.btnAll = var0_4:Find("btns/btn_all")

	setText(arg0_4.btnAll:Find("Text"), i18n(arg0_4.btnAllTip))

	arg0_4.scrollCom = GetComponent(var0_4:Find("view/content"), "LScrollRect")

	function arg0_4.scrollCom.onUpdateItem(arg0_5, arg1_5)
		arg0_4:UpdateAwardInfo(arg0_5, tf(arg1_5), arg0_4.awardList[arg0_5 + 1])
	end
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6.btnAll, function()
		arg0_6:GetAllAward()
	end, SFX_CONFIRM)

	local var0_6 = arg0_6.scrollCom.onValueChanged

	var0_6:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_6, var0_6)
	var0_6:AddListener(function(arg0_8)
		arg0_6:UpdateNextAward(arg0_8.x)
	end)
end

function var0_0.Flush(arg0_9, arg1_9)
	arg0_9:Show()

	if arg1_9 then
		arg0_9:UpdateActivity(arg1_9)
	end

	arg0_9.scrollCom:SetTotalCount(#arg0_9.awardList)
	arg0_9:BuildPhaseAwardScrollPos()

	arg0_9.nextAwardIndex = nil

	local var0_9 = #arg0_9.activity:GetHei5UnreceiveAward() > 0

	setGray(arg0_9.btnAll, not var0_9)
	setTextColor(arg0_9.btnAll:Find("Text"), var0_9 and Color.NewHex("#ffffff") or Color.NewHex("#7df39f"))
	setButtonEnabled(arg0_9.btnAll, var0_9)
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

function var0_0.UpdateAwardInfo(arg0_12, arg1_12, arg2_12, arg3_12)
	if arg3_12.id < 10 then
		setText(arg2_12:Find("Text"), "0" .. arg3_12.id)
	else
		setText(arg2_12:Find("Text"), arg3_12.id)
	end

	local var0_12 = arg3_12.pt <= arg0_12.pt
	local var1_12 = Drop.Create(arg3_12.award)

	var1_12.desc = cancelColorRich(var1_12.desc)

	onButton(arg0_12, arg2_12:Find("base"), function()
		arg0_12:emit(BaseUI.ON_NEW_STYLE_DROP, {
			drop = var1_12
		})
	end, SFX_CONFIRM)
	setActive(arg2_12:Find("base/lock"), not var0_12)
	updateDrop(arg2_12:Find("base/mask/IconTpl"), var1_12)
	setActive(arg2_12:Find("base/get"), var0_12 and not arg0_12.awardDic[arg3_12.pt])
	setActive(arg2_12:Find("base/got"), arg0_12.awardDic[arg3_12.pt])

	local var2_12 = Drop.Create(arg3_12.award_pay)

	onButton(arg0_12, arg2_12:Find("pay"), function()
		arg0_12:emit(BaseUI.ON_NEW_STYLE_DROP, {
			drop = var2_12
		})
	end, SFX_CONFIRM)
	updateDrop(arg2_12:Find("pay/mask/IconTpl"), var2_12)
	setActive(arg2_12:Find("pay/no_pay"), not arg0_12.isPay and not arg0_12:IsSpecialMask(var2_12.type))
	setActive(arg2_12:Find("pay/get"), arg0_12.isPay and var0_12 and not arg0_12.awardPayDic[arg3_12.pt])
	setActive(arg2_12:Find("pay/got"), arg0_12.awardPayDic[arg3_12.pt])
end

function var0_0.UpdateNextAward(arg0_15, arg1_15)
	if not arg0_15.nextPhasePos then
		return
	end

	local var0_15 = arg0_15.nextPhasePos[#arg0_15.nextPhasePos] - 1
	local var1_15 = #arg0_15.awardList

	for iter0_15 = var1_15 - 1, 1, -1 do
		local var2_15 = arg0_15.awardList[iter0_15]

		if arg0_15.nextPhasePos[iter0_15] < arg1_15 + var0_15 or var2_15.pt <= arg0_15.pt then
			break
		elseif var2_15.isImportent then
			var1_15 = iter0_15
		end
	end

	arg0_15:UpdateAwardInfo(arg0_15.nextAwardIndex, arg0_15.nextAwardTF, arg0_15.awardList[var1_15])
end

function var0_0.GetAllAward(arg0_16)
	local var0_16 = arg0_16.activity:GetHei5UnreceiveAward()

	if #var0_16 > 0 then
		local var1_16 = {}

		if arg0_16:CheckLimitMax(var0_16) then
			table.insert(var1_16, function(arg0_17)
				pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
					contentText = i18n("player_expResource_mail_fullBag"),
					onConfirm = arg0_17
				})
			end)
		end

		seriesAsync(var1_16, function()
			arg0_16:emit(PSSHei5Mediator.EVENT_GET_AWARD_ALL)
		end)
	end
end

function var0_0.CheckLimitMax(arg0_19, arg1_19)
	local var0_19 = getProxy(PlayerProxy):getData()

	for iter0_19, iter1_19 in ipairs(arg1_19) do
		if iter1_19.type == DROP_TYPE_RESOURCE then
			if iter1_19.id == 1 then
				if var0_19:GoldMax(iter1_19.count) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))

					return true
				end
			elseif iter1_19.id == 2 and var0_19:OilMax(iter1_19.count) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title"))

				return true
			end
		elseif iter1_19.type == DROP_TYPE_ITEM then
			local var1_19 = Item.getConfigData(iter1_19.id)

			if var1_19.type == Item.EXP_BOOK_TYPE and getProxy(BagProxy):getItemCountById(iter1_19.id) + iter1_19.count > var1_19.max_num then
				return true
			end
		end
	end

	return false
end

function var0_0.OnDestroy(arg0_20)
	return
end

return var0_0

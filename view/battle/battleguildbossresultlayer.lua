local var0_0 = class("BattleGuildBossResultLayer", import(".BattleResultLayer"))

function var0_0.showRightBottomPanel(arg0_1)
	var0_0.super.showRightBottomPanel(arg0_1)
	SetActive(arg0_1._rightBottomPanel, false)

	local var0_1 = arg0_1._blurConatiner:Find("activitybossConfirmPanel")

	setActive(var0_1, true)
	onButton(arg0_1, var0_1:Find("statisticsBtn"), function()
		triggerButton(arg0_1._statisticsBtn)
	end, SFX_PANEL)
	setText(var0_1:Find("confirmBtn/Image"), i18n("text_confirm"))
	onButton(arg0_1, var0_1:Find("confirmBtn"), function()
		triggerButton(arg0_1._confirmBtn)
	end, SFX_CONFIRM)
	setText(var0_1:Find("confirmBtn/Image"), i18n("text_confirm"))
end

function var0_0.didEnter(arg0_4)
	var0_0.super.didEnter(arg0_4)
	arg0_4:setPoint()
end

function var0_0.setGradeLabel(arg0_5)
	local var0_5 = arg0_5:findTF("grade/Xyz/bg13")
	local var1_5 = arg0_5:findTF("grade/Xyz/bg14")

	setActive(var0_5, false)

	local var2_5 = "battlescore/grade_label_clear"

	LoadImageSpriteAsync(var2_5, var1_5, false)
end

function var0_0.rankAnimaFinish(arg0_6)
	setActive(arg0_6._conditionBGNormal, false)
	setActive(arg0_6._conditionBGContribute, true)
	arg0_6:setCondition(i18n("battle_result_total_damage"), arg0_6.contextData.statistics.specificDamage, COLOR_BLUE)
	arg0_6:setCondition(i18n("battle_result_contribution"), arg0_6._contributionPoint, COLOR_YELLOW)

	local var0_6 = LeanTween.delayedCall(1, System.Action(function()
		arg0_6._stateFlag = var0_0.STATE_REPORTED

		SetActive(arg0_6:findTF("jieuan01/tips", arg0_6._bg), true)
	end))

	table.insert(arg0_6._delayLeanList, var0_6.id)

	arg0_6._stateFlag = var0_0.STATE_REPORT
end

function var0_0.setCondition(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = cloneTplTo(arg0_8._conditionContributeTpl, arg0_8._conditionContainer)

	setActive(var0_8, false)

	local var1_8

	var0_8:Find("text"):GetComponent(typeof(Text)).text = setColorStr(arg1_8, "#FFFFFFFF")
	var0_8:Find("value"):GetComponent(typeof(Text)).text = setColorStr(arg2_8, arg3_8)

	local var2_8 = arg0_8._conditionContainer.childCount - 1

	if var2_8 > 0 then
		local var3_8 = LeanTween.delayedCall(var0_0.CONDITIONS_FREQUENCE * var2_8, System.Action(function()
			setActive(var0_8, true)
		end))

		table.insert(arg0_8._delayLeanList, var3_8.id)
	else
		setActive(var0_8, true)
	end
end

function var0_0.setActId(arg0_10, arg1_10)
	return
end

function var0_0.showRewardInfo(arg0_11)
	arg0_11._stateFlag = var0_0.STATE_REWARD

	SetActive(arg0_11:findTF("jieuan01/tips", arg0_11._bg), false)
	arg0_11:displayBG()
end

function var0_0.setPoint(arg0_12)
	arg0_12._contributionPoint = 0

	local var0_12 = pg.guildset.guild_damage_resource.key_value

	for iter0_12, iter1_12 in ipairs(arg0_12.contextData.drops) do
		if iter1_12.configId == var0_12 then
			arg0_12._contributionPoint = iter1_12.count
		end
	end

	setActive(arg0_12:findTF("blur_container/activitybossConfirmPanel/playAgain"), false)
end

function var0_0.displayShips(arg0_13)
	local var0_13 = {}
	local var1_13 = arg0_13.shipVOs

	for iter0_13, iter1_13 in ipairs(var1_13) do
		var0_13[iter1_13.id] = iter1_13
	end

	local var2_13 = arg0_13.contextData.statistics

	for iter2_13, iter3_13 in ipairs(var1_13) do
		if var2_13[iter3_13.id] then
			var2_13[iter3_13.id].vo = iter3_13
		end
	end

	local var3_13
	local var4_13

	if var2_13.mvpShipID and var2_13.mvpShipID ~= 0 then
		var3_13 = var2_13[var2_13.mvpShipID]
		var4_13 = var3_13.output
	else
		var4_13 = 0
	end

	local var5_13 = arg0_13.contextData.oldMainShips

	arg0_13._atkFuncs = {}

	local var6_13
	local var7_13

	SetActive(arg0_13._atkToggle, #var5_13 > 6)

	if #var5_13 > 6 then
		onToggle(arg0_13, arg0_13._atkToggle, function(arg0_14)
			SetActive(arg0_13._atkContainer, arg0_14)
			SetActive(arg0_13._atkContainerNext, not arg0_14)

			if arg0_14 then
				arg0_13:skipAtkAnima(arg0_13._atkContainerNext)
			else
				arg0_13:skipAtkAnima(arg0_13._atkContainer)
			end
		end, SFX_PANEL)
	end

	local var8_13 = {}
	local var9_13 = {}

	for iter4_13, iter5_13 in ipairs(var5_13) do
		local var10_13 = var0_13[iter5_13.id] or iter5_13

		if var2_13[iter5_13.id] then
			local var11_13 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter5_13.configId).type
			local var12_13 = table.contains(TeamType.SubShipType, var11_13)
			local var13_13
			local var14_13
			local var15_13 = 0
			local var16_13

			if iter4_13 > 6 then
				var14_13 = arg0_13._atkContainerNext
				var16_13 = 7
			else
				var14_13 = arg0_13._atkContainer
				var16_13 = 1
			end

			local var17_13 = cloneTplTo(arg0_13._atkTpl, var14_13)
			local var18_13 = var17_13.localPosition

			var18_13.x = var18_13.x + (iter4_13 - var16_13) * 74
			var18_13.y = var18_13.y + (iter4_13 - var16_13) * -124
			var17_13.localPosition = var18_13

			local var19_13 = findTF(var17_13, "result/stars")
			local var20_13 = findTF(var17_13, "result/stars/star_tpl")
			local var21_13 = iter5_13:getStar()
			local var22_13 = iter5_13:getMaxStar()

			while var22_13 > 0 do
				local var23_13 = cloneTplTo(var20_13, var19_13)

				SetActive(var23_13:Find("empty"), var21_13 < var22_13)
				SetActive(var23_13:Find("star"), var22_13 <= var21_13)

				var22_13 = var22_13 - 1
			end

			local var24_13 = arg0_13:findTF("result/mask/icon", var17_13)
			local var25_13 = arg0_13:findTF("result/type", var17_13)

			var24_13:GetComponent(typeof(Image)).sprite = LoadSprite("herohrzicon/" .. iter5_13:getPainting())

			local var26_13 = var2_13[iter5_13.id].output / var4_13
			local var27_13 = GetSpriteFromAtlas("shiptype", shipType2print(iter5_13:getShipType()))

			setImageSprite(var25_13, var27_13, true)
			arg0_13:setAtkAnima(var17_13, var14_13, var26_13, var4_13, var3_13 and iter5_13.id == var3_13.id, var2_13[iter5_13.id].output, var2_13[iter5_13.id].kill_count)

			local var28_13
			local var29_13 = false

			if var3_13 and iter5_13.id == var3_13.id then
				var29_13 = true
				arg0_13.mvpShipVO = iter5_13

				local var30_13
				local var31_13
				local var32_13

				if arg0_13.contextData.score > 1 then
					local var33_13, var34_13

					var33_13, var32_13, var34_13 = ShipWordHelper.GetWordAndCV(arg0_13.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_MVP, nil, nil, arg0_13.mvpShipVO:getCVIntimacy())
				else
					local var35_13, var36_13

					var35_13, var32_13, var36_13 = ShipWordHelper.GetWordAndCV(arg0_13.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_LOSE)
				end

				if var32_13 then
					arg0_13:stopVoice()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var32_13, function(arg0_15)
						arg0_13._currentVoice = arg0_15
					end)
				end
			end

			if iter5_13.id == var2_13._flagShipID then
				arg0_13.flagShipVO = iter5_13
			end

			local var37_13
			local var38_13 = arg0_13.shipBuff and arg0_13.shipBuff[iter5_13:getGroupId()]

			if arg0_13.expBuff or var38_13 then
				var37_13 = arg0_13.expBuff and arg0_13.expBuff:getConfig("name") or var38_13 and i18n("Word_Ship_Exp_Buff")
			end

			local var39_13

			if not var12_13 then
				local var40_13 = cloneTplTo(arg0_13._extpl, arg0_13._expContainer)

				var39_13 = BattleResultShipCard.New(var40_13)

				table.insert(arg0_13._shipResultCardList, var39_13)

				if var7_13 then
					var7_13:ConfigCallback(function()
						var39_13:Play()
					end)
				else
					var39_13:Play()
				end

				var7_13 = var39_13
			else
				local var41_13 = cloneTplTo(arg0_13._extpl, arg0_13._subExpContainer)

				var39_13 = BattleResultShipCard.New(var41_13)

				table.insert(arg0_13._subShipResultCardList, var39_13)

				if not var6_13 then
					arg0_13._subFirstExpCard = var39_13
				else
					var6_13:ConfigCallback(function()
						var39_13:Play()
					end)
				end

				var6_13 = var39_13
			end

			var39_13:SetShipVO(iter5_13, var10_13, var29_13, var37_13)
		end
	end

	if var7_13 then
		var7_13:ConfigCallback(function()
			arg0_13._stateFlag = var0_0.STATE_DISPLAYED

			if not arg0_13._subFirstExpCard then
				arg0_13:skip()
			end
		end)
	end

	if var6_13 then
		var6_13:ConfigCallback(function()
			arg0_13._stateFlag = var0_0.STATE_SUB_DISPLAYED

			arg0_13:skip()
		end)
	end
end

return var0_0

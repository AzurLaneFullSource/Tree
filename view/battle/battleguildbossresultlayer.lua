local var0 = class("BattleGuildBossResultLayer", import(".BattleResultLayer"))

function var0.showRightBottomPanel(arg0)
	var0.super.showRightBottomPanel(arg0)
	SetActive(arg0._rightBottomPanel, false)

	local var0 = arg0._blurConatiner:Find("activitybossConfirmPanel")

	setActive(var0, true)
	onButton(arg0, var0:Find("statisticsBtn"), function()
		triggerButton(arg0._statisticsBtn)
	end, SFX_PANEL)
	setText(var0:Find("confirmBtn/Image"), i18n("text_confirm"))
	onButton(arg0, var0:Find("confirmBtn"), function()
		triggerButton(arg0._confirmBtn)
	end, SFX_CONFIRM)
	setText(var0:Find("confirmBtn/Image"), i18n("text_confirm"))
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)
	arg0:setPoint()
end

function var0.setGradeLabel(arg0)
	local var0 = arg0:findTF("grade/Xyz/bg13")
	local var1 = arg0:findTF("grade/Xyz/bg14")

	setActive(var0, false)

	local var2 = "battlescore/grade_label_clear"

	LoadImageSpriteAsync(var2, var1, false)
end

function var0.rankAnimaFinish(arg0)
	setActive(arg0._conditionBGNormal, false)
	setActive(arg0._conditionBGContribute, true)
	arg0:setCondition(i18n("battle_result_total_damage"), arg0.contextData.statistics.specificDamage, COLOR_BLUE)
	arg0:setCondition(i18n("battle_result_contribution"), arg0._contributionPoint, COLOR_YELLOW)

	local var0 = LeanTween.delayedCall(1, System.Action(function()
		arg0._stateFlag = var0.STATE_REPORTED

		SetActive(arg0:findTF("jieuan01/tips", arg0._bg), true)
	end))

	table.insert(arg0._delayLeanList, var0.id)

	arg0._stateFlag = var0.STATE_REPORT
end

function var0.setCondition(arg0, arg1, arg2, arg3)
	local var0 = cloneTplTo(arg0._conditionContributeTpl, arg0._conditionContainer)

	setActive(var0, false)

	local var1

	var0:Find("text"):GetComponent(typeof(Text)).text = setColorStr(arg1, "#FFFFFFFF")
	var0:Find("value"):GetComponent(typeof(Text)).text = setColorStr(arg2, arg3)

	local var2 = arg0._conditionContainer.childCount - 1

	if var2 > 0 then
		local var3 = LeanTween.delayedCall(var0.CONDITIONS_FREQUENCE * var2, System.Action(function()
			setActive(var0, true)
		end))

		table.insert(arg0._delayLeanList, var3.id)
	else
		setActive(var0, true)
	end
end

function var0.setActId(arg0, arg1)
	return
end

function var0.showRewardInfo(arg0)
	arg0._stateFlag = var0.STATE_REWARD

	SetActive(arg0:findTF("jieuan01/tips", arg0._bg), false)
	arg0:displayBG()
end

function var0.setPoint(arg0)
	arg0._contributionPoint = 0

	local var0 = pg.guildset.guild_damage_resource.key_value

	for iter0, iter1 in ipairs(arg0.contextData.drops) do
		if iter1.configId == var0 then
			arg0._contributionPoint = iter1.count
		end
	end

	setActive(arg0:findTF("blur_container/activitybossConfirmPanel/playAgain"), false)
end

function var0.displayShips(arg0)
	local var0 = {}
	local var1 = arg0.shipVOs

	for iter0, iter1 in ipairs(var1) do
		var0[iter1.id] = iter1
	end

	local var2 = arg0.contextData.statistics

	for iter2, iter3 in ipairs(var1) do
		if var2[iter3.id] then
			var2[iter3.id].vo = iter3
		end
	end

	local var3
	local var4

	if var2.mvpShipID and var2.mvpShipID ~= 0 then
		var3 = var2[var2.mvpShipID]
		var4 = var3.output
	else
		var4 = 0
	end

	local var5 = arg0.contextData.oldMainShips

	arg0._atkFuncs = {}

	local var6
	local var7

	SetActive(arg0._atkToggle, #var5 > 6)

	if #var5 > 6 then
		onToggle(arg0, arg0._atkToggle, function(arg0)
			SetActive(arg0._atkContainer, arg0)
			SetActive(arg0._atkContainerNext, not arg0)

			if arg0 then
				arg0:skipAtkAnima(arg0._atkContainerNext)
			else
				arg0:skipAtkAnima(arg0._atkContainer)
			end
		end, SFX_PANEL)
	end

	local var8 = {}
	local var9 = {}

	for iter4, iter5 in ipairs(var5) do
		local var10 = var0[iter5.id] or iter5

		if var2[iter5.id] then
			local var11 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter5.configId).type
			local var12 = table.contains(TeamType.SubShipType, var11)
			local var13
			local var14
			local var15 = 0
			local var16

			if iter4 > 6 then
				var14 = arg0._atkContainerNext
				var16 = 7
			else
				var14 = arg0._atkContainer
				var16 = 1
			end

			local var17 = cloneTplTo(arg0._atkTpl, var14)
			local var18 = var17.localPosition

			var18.x = var18.x + (iter4 - var16) * 74
			var18.y = var18.y + (iter4 - var16) * -124
			var17.localPosition = var18

			local var19 = findTF(var17, "result/stars")
			local var20 = findTF(var17, "result/stars/star_tpl")
			local var21 = iter5:getStar()
			local var22 = iter5:getMaxStar()

			while var22 > 0 do
				local var23 = cloneTplTo(var20, var19)

				SetActive(var23:Find("empty"), var21 < var22)
				SetActive(var23:Find("star"), var22 <= var21)

				var22 = var22 - 1
			end

			local var24 = arg0:findTF("result/mask/icon", var17)
			local var25 = arg0:findTF("result/type", var17)

			var24:GetComponent(typeof(Image)).sprite = LoadSprite("herohrzicon/" .. iter5:getPainting())

			local var26 = var2[iter5.id].output / var4
			local var27 = GetSpriteFromAtlas("shiptype", shipType2print(iter5:getShipType()))

			setImageSprite(var25, var27, true)
			arg0:setAtkAnima(var17, var14, var26, var4, var3 and iter5.id == var3.id, var2[iter5.id].output, var2[iter5.id].kill_count)

			local var28
			local var29 = false

			if var3 and iter5.id == var3.id then
				var29 = true
				arg0.mvpShipVO = iter5

				local var30
				local var31
				local var32

				if arg0.contextData.score > 1 then
					local var33, var34

					var33, var32, var34 = ShipWordHelper.GetWordAndCV(arg0.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_MVP, nil, nil, arg0.mvpShipVO:getCVIntimacy())
				else
					local var35, var36

					var35, var32, var36 = ShipWordHelper.GetWordAndCV(arg0.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_LOSE)
				end

				if var32 then
					arg0:stopVoice()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var32, function(arg0)
						arg0._currentVoice = arg0
					end)
				end
			end

			if iter5.id == var2._flagShipID then
				arg0.flagShipVO = iter5
			end

			local var37
			local var38 = arg0.shipBuff and arg0.shipBuff[iter5:getGroupId()]

			if arg0.expBuff or var38 then
				var37 = arg0.expBuff and arg0.expBuff:getConfig("name") or var38 and i18n("Word_Ship_Exp_Buff")
			end

			local var39

			if not var12 then
				local var40 = cloneTplTo(arg0._extpl, arg0._expContainer)

				var39 = BattleResultShipCard.New(var40)

				table.insert(arg0._shipResultCardList, var39)

				if var7 then
					var7:ConfigCallback(function()
						var39:Play()
					end)
				else
					var39:Play()
				end

				var7 = var39
			else
				local var41 = cloneTplTo(arg0._extpl, arg0._subExpContainer)

				var39 = BattleResultShipCard.New(var41)

				table.insert(arg0._subShipResultCardList, var39)

				if not var6 then
					arg0._subFirstExpCard = var39
				else
					var6:ConfigCallback(function()
						var39:Play()
					end)
				end

				var6 = var39
			end

			var39:SetShipVO(iter5, var10, var29, var37)
		end
	end

	if var7 then
		var7:ConfigCallback(function()
			arg0._stateFlag = var0.STATE_DISPLAYED

			if not arg0._subFirstExpCard then
				arg0:skip()
			end
		end)
	end

	if var6 then
		var6:ConfigCallback(function()
			arg0._stateFlag = var0.STATE_SUB_DISPLAYED

			arg0:skip()
		end)
	end
end

return var0

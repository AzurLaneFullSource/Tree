local var0_0 = class("BattleExperimentResultLayer", import(".BattleContributionResultLayer"))

function var0_0.setPoint(arg0_1)
	arg0_1._contributionPoint = 0
end

function var0_0.skip(arg0_2)
	for iter0_2, iter1_2 in ipairs(arg0_2._delayLeanList) do
		LeanTween.cancel(iter1_2)
	end

	if arg0_2._stateFlag == var0_0.STATE_RANK_ANIMA then
		-- block empty
	elseif arg0_2._stateFlag == var0_0.STATE_REPORT then
		local var0_2 = arg0_2._conditionContainer.childCount

		while var0_2 > 0 do
			SetActive(arg0_2._conditionContainer:GetChild(var0_2 - 1), true)

			var0_2 = var0_2 - 1
		end

		SetActive(arg0_2:findTF("jieuan01/tips", arg0_2._bg), true)

		arg0_2._stateFlag = var0_0.STATE_REPORTED
	elseif arg0_2._stateFlag == var0_0.STATE_REPORTED then
		arg0_2:displayBG()
		SetActive(arg0_2:findTF("jieuan01/tips", arg0_2._bg), false)
	end
end

function var0_0.displayBG(arg0_3)
	local var0_3 = rtf(arg0_3._grade)

	LeanTween.moveX(rtf(arg0_3._conditions), 1300, var0_0.DURATION_MOVE)
	LeanTween.scale(arg0_3._grade, Vector3(0.6, 0.6, 0), var0_0.DURATION_MOVE)
	LeanTween.moveLocal(go(var0_3), arg0_3._gradeUpperLeftPos, var0_0.DURATION_MOVE):setOnComplete(System.Action(function()
		arg0_3:displayShips()
		arg0_3:showRightBottomPanel()
		triggerButton(arg0_3._statisticsBtn)
		arg0_3:skipAtkAnima(arg0_3._atkContainerNext)
		arg0_3:skipAtkAnima(arg0_3._atkContainer)
		setActive(arg0_3._statisticsBtn, false)

		arg0_3._stateFlag = var0_0.STATE_DISPLAY
	end))
	setActive(arg0_3:findTF("jieuan01/Bomb", arg0_3._bg), false)
end

function var0_0.closeStatistics(arg0_5)
	return
end

function var0_0.displayShips(arg0_6)
	arg0_6._expTFs = {}
	arg0_6._nameTxts = {}
	arg0_6._initExp = {}
	arg0_6._skipExp = {}
	arg0_6._subSkipExp = {}
	arg0_6._subCardAnimaFuncList = {}

	local var0_6 = {}
	local var1_6 = arg0_6.shipVOs

	for iter0_6, iter1_6 in ipairs(var1_6) do
		var0_6[iter1_6.id] = iter1_6
	end

	local var2_6 = arg0_6.contextData.statistics

	for iter2_6, iter3_6 in ipairs(var1_6) do
		if var2_6[iter3_6.id] then
			var2_6[iter3_6.id].vo = iter3_6
		end
	end

	local var3_6 = arg0_6.contextData.oldMainShips
	local var4_6 = 0

	for iter4_6, iter5_6 in ipairs(var3_6) do
		local var5_6 = var2_6[iter5_6.id]

		if var5_6 and var4_6 < var5_6.output then
			arg0_6.mvpShipVO = iter5_6
			var4_6 = var5_6.output
		end
	end

	arg0_6._atkFuncs = {}
	arg0_6._commonAtkTplList = {}
	arg0_6._subAtkTplList = {}

	local var6_6
	local var7_6

	SetActive(arg0_6._atkToggle, #var3_6 > 6)

	if #var3_6 > 6 then
		onToggle(arg0_6, arg0_6._atkToggle, function(arg0_7)
			SetActive(arg0_6._atkContainer, arg0_7)
			SetActive(arg0_6._atkContainerNext, not arg0_7)

			if arg0_7 then
				arg0_6:skipAtkAnima(arg0_6._atkContainerNext)
			else
				arg0_6:skipAtkAnima(arg0_6._atkContainer)
			end
		end, SFX_PANEL)
	end

	local var8_6 = {}
	local var9_6 = {}

	for iter6_6, iter7_6 in ipairs(var3_6) do
		local var10_6 = var0_6[iter7_6.id]

		if var2_6[iter7_6.id] then
			local var11_6 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter7_6.configId).type
			local var12_6 = table.contains(TeamType.SubShipType, var11_6)
			local var13_6
			local var14_6
			local var15_6 = 0
			local var16_6

			if iter6_6 > 6 then
				var14_6 = arg0_6._atkContainerNext
				var16_6 = 7
			else
				var14_6 = arg0_6._atkContainer
				var16_6 = 1
			end

			local var17_6 = cloneTplTo(arg0_6._atkTpl, var14_6)
			local var18_6 = var17_6.localPosition

			var18_6.x = var18_6.x + (iter6_6 - var16_6) * 74
			var18_6.y = var18_6.y + (iter6_6 - var16_6) * -124
			var17_6.localPosition = var18_6

			local var19_6 = arg0_6:findTF("result/mask/icon", var17_6)
			local var20_6 = arg0_6:findTF("result/type", var17_6)

			var19_6:GetComponent(typeof(Image)).sprite = LoadSprite("herohrzicon/" .. iter7_6:getPainting())

			local var21_6 = var2_6[iter7_6.id].output / var4_6
			local var22_6 = GetSpriteFromAtlas("shiptype", shipType2print(iter7_6:getShipType()))

			setImageSprite(var20_6, var22_6, true)
			arg0_6:setAtkAnima(var17_6, var14_6, var21_6, var4_6, arg0_6.mvpShipVO == iter7_6, var2_6[iter7_6.id].output, var2_6[iter7_6.id].kill_count)

			if iter7_6.id == var2_6._flagShipID then
				arg0_6.flagShipVO = iter7_6
			end
		end
	end
end

return var0_0

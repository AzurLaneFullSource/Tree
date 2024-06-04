local var0 = class("BattleExperimentResultLayer", import(".BattleContributionResultLayer"))

function var0.setPoint(arg0)
	arg0._contributionPoint = 0
end

function var0.skip(arg0)
	for iter0, iter1 in ipairs(arg0._delayLeanList) do
		LeanTween.cancel(iter1)
	end

	if arg0._stateFlag == var0.STATE_RANK_ANIMA then
		-- block empty
	elseif arg0._stateFlag == var0.STATE_REPORT then
		local var0 = arg0._conditionContainer.childCount

		while var0 > 0 do
			SetActive(arg0._conditionContainer:GetChild(var0 - 1), true)

			var0 = var0 - 1
		end

		SetActive(arg0:findTF("jieuan01/tips", arg0._bg), true)

		arg0._stateFlag = var0.STATE_REPORTED
	elseif arg0._stateFlag == var0.STATE_REPORTED then
		arg0:displayBG()
		SetActive(arg0:findTF("jieuan01/tips", arg0._bg), false)
	end
end

function var0.displayBG(arg0)
	local var0 = rtf(arg0._grade)

	LeanTween.moveX(rtf(arg0._conditions), 1300, var0.DURATION_MOVE)
	LeanTween.scale(arg0._grade, Vector3(0.6, 0.6, 0), var0.DURATION_MOVE)
	LeanTween.moveLocal(go(var0), arg0._gradeUpperLeftPos, var0.DURATION_MOVE):setOnComplete(System.Action(function()
		arg0:displayShips()
		arg0:showRightBottomPanel()
		triggerButton(arg0._statisticsBtn)
		arg0:skipAtkAnima(arg0._atkContainerNext)
		arg0:skipAtkAnima(arg0._atkContainer)
		setActive(arg0._statisticsBtn, false)

		arg0._stateFlag = var0.STATE_DISPLAY
	end))
	setActive(arg0:findTF("jieuan01/Bomb", arg0._bg), false)
end

function var0.closeStatistics(arg0)
	return
end

function var0.displayShips(arg0)
	arg0._expTFs = {}
	arg0._nameTxts = {}
	arg0._initExp = {}
	arg0._skipExp = {}
	arg0._subSkipExp = {}
	arg0._subCardAnimaFuncList = {}

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

	local var3 = arg0.contextData.oldMainShips
	local var4 = 0

	for iter4, iter5 in ipairs(var3) do
		local var5 = var2[iter5.id]

		if var5 and var4 < var5.output then
			arg0.mvpShipVO = iter5
			var4 = var5.output
		end
	end

	arg0._atkFuncs = {}
	arg0._commonAtkTplList = {}
	arg0._subAtkTplList = {}

	local var6
	local var7

	SetActive(arg0._atkToggle, #var3 > 6)

	if #var3 > 6 then
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

	for iter6, iter7 in ipairs(var3) do
		local var10 = var0[iter7.id]

		if var2[iter7.id] then
			local var11 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter7.configId).type
			local var12 = table.contains(TeamType.SubShipType, var11)
			local var13
			local var14
			local var15 = 0
			local var16

			if iter6 > 6 then
				var14 = arg0._atkContainerNext
				var16 = 7
			else
				var14 = arg0._atkContainer
				var16 = 1
			end

			local var17 = cloneTplTo(arg0._atkTpl, var14)
			local var18 = var17.localPosition

			var18.x = var18.x + (iter6 - var16) * 74
			var18.y = var18.y + (iter6 - var16) * -124
			var17.localPosition = var18

			local var19 = arg0:findTF("result/mask/icon", var17)
			local var20 = arg0:findTF("result/type", var17)

			var19:GetComponent(typeof(Image)).sprite = LoadSprite("herohrzicon/" .. iter7:getPainting())

			local var21 = var2[iter7.id].output / var4
			local var22 = GetSpriteFromAtlas("shiptype", shipType2print(iter7:getShipType()))

			setImageSprite(var20, var22, true)
			arg0:setAtkAnima(var17, var14, var21, var4, arg0.mvpShipVO == iter7, var2[iter7.id].output, var2[iter7.id].kill_count)

			if iter7.id == var2._flagShipID then
				arg0.flagShipVO = iter7
			end
		end
	end
end

return var0

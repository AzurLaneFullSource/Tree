local var0_0 = class("NewDodgemResultGradePage", import("..NewBattleResultGradePage"))

function var0_0.LoadBG(arg0_1, arg1_1)
	local var0_1 = "CommonBg"

	ResourceMgr.Inst:getAssetAsync("BattleResultItems/" .. var0_1, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_2)
		if arg0_1.exited or IsNil(arg0_2) then
			if arg1_1 then
				arg1_1()
			end

			return
		end

		Object.Instantiate(arg0_2, arg0_1.bgTr).transform:SetAsFirstSibling()

		if arg1_1 then
			arg1_1()
		end
	end), false, false)
end

function var0_0.RegisterEvent(arg0_3, arg1_3)
	seriesAsync({
		function(arg0_4)
			var0_0.super.RegisterEvent(arg0_3, arg0_4)
		end,
		function(arg0_5)
			removeOnButton(arg0_3._tf)
			arg0_3:LoadPainitingContainer(arg0_5)
		end,
		function(arg0_6)
			arg0_3:MovePainting(arg0_6)
		end
	}, function()
		onButton(arg0_3, arg0_3._tf, function()
			arg1_3()
		end, SFX_PANEL)
	end)
end

function var0_0.MovePainting(arg0_9, arg1_9)
	local var0_9 = arg0_9.paintingTr.parent

	LeanTween.value(var0_9.gameObject, 2500, 587, 0.3):setOnUpdate(System.Action_float(function(arg0_10)
		var0_9.localPosition = Vector3(arg0_10, 0, 0)
	end)):setOnComplete(System.Action(arg1_9))

	local var1_9 = Vector2(-247, 213)
	local var2_9 = arg0_9.gradePanel.anchoredPosition

	LeanTween.value(arg0_9.gradePanel.gameObject, var2_9, var2_9 + var1_9, 0.29):setOnUpdate(System.Action_UnityEngine_Vector2(function(arg0_11)
		arg0_9.gradePanel.anchoredPosition3D = Vector3(arg0_11.x, arg0_11.y, 0)
	end))
end

function var0_0.GetGetObjectives(arg0_12)
	local var0_12 = arg0_12.contextData
	local var1_12 = {}
	local var2_12 = var0_12.statistics.dodgemResult
	local var3_12 = i18n("battle_result_total_score")

	table.insert(var1_12, {
		text = setColorStr(var3_12, "#FFFFFFFF"),
		value = setColorStr(var2_12.score, COLOR_BLUE)
	})

	local var4_12 = i18n("battle_result_max_combo")

	table.insert(var1_12, {
		text = setColorStr(var4_12, "#FFFFFFFF"),
		value = setColorStr(var2_12.maxCombo, COLOR_YELLOW)
	})

	return var1_12
end

function var0_0.LoadPainitingContainer(arg0_13, arg1_13)
	ResourceMgr.Inst:getAssetAsync("BattleResultItems/Painting", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_14)
		if arg0_13.exited then
			return
		end

		local var0_14 = Object.Instantiate(arg0_14, arg0_13.bgTr)

		arg0_13:UpdatePainting(var0_14, arg1_13)
	end), true, true)
end

function var0_0.UpdatePainting(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg1_15.transform:Find("painting")
	local var1_15 = arg0_15:GetFlagShip()
	local var2_15 = var1_15:getPainting()

	setPaintingPrefabAsync(var0_15, var2_15, "biandui", function()
		ShipExpressionHelper.SetExpression(findTF(var0_15, "fitter"):GetChild(0), var2_15, ShipWordHelper.WORD_TYPE_MVP)
		arg2_15()
	end)
	arg0_15:DisplayShipDialogue(arg1_15.transform:Find("chat"), var1_15)

	arg0_15.paintingTr = var0_15
	arg1_15.transform.localPosition = Vector3(2500, 0, 0)

	arg1_15.transform:SetSiblingIndex(2)
	setActive(arg0_15.objectiveContainer.parent, false)
end

function var0_0.DisplayShipDialogue(arg0_17, arg1_17, arg2_17)
	local var0_17
	local var1_17
	local var2_17

	if arg0_17.contextData.score > 1 then
		local var3_17, var4_17

		var3_17, var4_17, var1_17 = ShipWordHelper.GetWordAndCV(arg2_17.skinId, ShipWordHelper.WORD_TYPE_MVP)
	else
		local var5_17, var6_17

		var5_17, var6_17, var1_17 = ShipWordHelper.GetWordAndCV(arg2_17.skinId, ShipWordHelper.WORD_TYPE_LOSE)
	end

	local var7_17 = arg1_17:Find("Text"):GetComponent(typeof(Text))

	var7_17.text = var1_17
	var7_17.alignment = #var1_17 > CHAT_POP_STR_LEN and TextAnchor.MiddleLeft or TextAnchor.MiddleCenter
end

function var0_0.GetFlagShip(arg0_18)
	return Ship.New({
		id = 9999,
		configId = 205021,
		skin_id = 205020
	})
end

function var0_0.OnDestroy(arg0_19)
	if arg0_19.paintingTr then
		local var0_19 = arg0_19:GetFlagShip()

		retPaintingPrefab(arg0_19.paintingTr, var0_19:getPainting())
	end

	var0_0.super.OnDestroy(arg0_19)
end

return var0_0

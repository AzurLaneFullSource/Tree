local var0 = class("NewDodgemResultGradePage", import("..NewBattleResultGradePage"))

function var0.LoadBG(arg0, arg1)
	local var0 = "CommonBg"

	ResourceMgr.Inst:getAssetAsync("BattleResultItems/" .. var0, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.exited or IsNil(arg0) then
			if arg1 then
				arg1()
			end

			return
		end

		Object.Instantiate(arg0, arg0.bgTr).transform:SetAsFirstSibling()

		if arg1 then
			arg1()
		end
	end), false, false)
end

function var0.RegisterEvent(arg0, arg1)
	seriesAsync({
		function(arg0)
			var0.super.RegisterEvent(arg0, arg0)
		end,
		function(arg0)
			removeOnButton(arg0._tf)
			arg0:LoadPainitingContainer(arg0)
		end,
		function(arg0)
			arg0:MovePainting(arg0)
		end
	}, function()
		onButton(arg0, arg0._tf, function()
			arg1()
		end, SFX_PANEL)
	end)
end

function var0.MovePainting(arg0, arg1)
	local var0 = arg0.paintingTr.parent

	LeanTween.value(var0.gameObject, 2500, 587, 0.3):setOnUpdate(System.Action_float(function(arg0)
		var0.localPosition = Vector3(arg0, 0, 0)
	end)):setOnComplete(System.Action(arg1))

	local var1 = Vector2(-247, 213)
	local var2 = arg0.gradePanel.anchoredPosition

	LeanTween.value(arg0.gradePanel.gameObject, var2, var2 + var1, 0.29):setOnUpdate(System.Action_UnityEngine_Vector2(function(arg0)
		arg0.gradePanel.anchoredPosition3D = Vector3(arg0.x, arg0.y, 0)
	end))
end

function var0.GetGetObjectives(arg0)
	local var0 = arg0.contextData
	local var1 = {}
	local var2 = var0.statistics.dodgemResult
	local var3 = i18n("battle_result_total_score")

	table.insert(var1, {
		text = setColorStr(var3, "#FFFFFFFF"),
		value = setColorStr(var2.score, COLOR_BLUE)
	})

	local var4 = i18n("battle_result_max_combo")

	table.insert(var1, {
		text = setColorStr(var4, "#FFFFFFFF"),
		value = setColorStr(var2.maxCombo, COLOR_YELLOW)
	})

	return var1
end

function var0.LoadPainitingContainer(arg0, arg1)
	ResourceMgr.Inst:getAssetAsync("BattleResultItems/Painting", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.exited then
			return
		end

		local var0 = Object.Instantiate(arg0, arg0.bgTr)

		arg0:UpdatePainting(var0, arg1)
	end), true, true)
end

function var0.UpdatePainting(arg0, arg1, arg2)
	local var0 = arg1.transform:Find("painting")
	local var1 = arg0:GetFlagShip()
	local var2 = var1:getPainting()

	setPaintingPrefabAsync(var0, var2, "biandui", function()
		ShipExpressionHelper.SetExpression(findTF(var0, "fitter"):GetChild(0), var2, ShipWordHelper.WORD_TYPE_MVP)
		arg2()
	end)
	arg0:DisplayShipDialogue(arg1.transform:Find("chat"), var1)

	arg0.paintingTr = var0
	arg1.transform.localPosition = Vector3(2500, 0, 0)

	arg1.transform:SetSiblingIndex(2)
	setActive(arg0.objectiveContainer.parent, false)
end

function var0.DisplayShipDialogue(arg0, arg1, arg2)
	local var0
	local var1
	local var2

	if arg0.contextData.score > 1 then
		local var3, var4

		var3, var4, var1 = ShipWordHelper.GetWordAndCV(arg2.skinId, ShipWordHelper.WORD_TYPE_MVP)
	else
		local var5, var6

		var5, var6, var1 = ShipWordHelper.GetWordAndCV(arg2.skinId, ShipWordHelper.WORD_TYPE_LOSE)
	end

	local var7 = arg1:Find("Text"):GetComponent(typeof(Text))

	var7.text = var1
	var7.alignment = #var1 > CHAT_POP_STR_LEN and TextAnchor.MiddleLeft or TextAnchor.MiddleCenter
end

function var0.GetFlagShip(arg0)
	return Ship.New({
		id = 9999,
		configId = 205021,
		skin_id = 205020
	})
end

function var0.OnDestroy(arg0)
	if arg0.paintingTr then
		local var0 = arg0:GetFlagShip()

		retPaintingPrefab(arg0.paintingTr, var0:getPainting())
	end

	var0.super.OnDestroy(arg0)
end

return var0

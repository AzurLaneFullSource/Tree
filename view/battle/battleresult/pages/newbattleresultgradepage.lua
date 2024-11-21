local var0_0 = class("NewBattleResultGradePage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewBattleResultGradePage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.parentTr = arg0_2._tf.parent
	arg0_2.bgTr = arg0_2:findTF("bg")
	arg0_2.gradePanel = arg0_2.bgTr:Find("grade")
	arg0_2.gradeIcon = arg0_2.bgTr:Find("grade/icon")
	arg0_2.gradeTxt = arg0_2.bgTr:Find("grade/Text")
	arg0_2.gradeLabel = arg0_2.bgTr:Find("grade/label")
	arg0_2.gradeChapterName = arg0_2.bgTr:Find("grade/chapterName")
	arg0_2.gradeTxtCG = arg0_2.gradeTxt:GetComponent(typeof(CanvasGroup))
	arg0_2.gradeChapterNameCG = arg0_2.gradeChapterName:GetComponent(typeof(CanvasGroup))
	arg0_2.objectiveContainer = arg0_2.bgTr:Find("conditions/list")
	arg0_2.objectiveTpl = arg0_2.bgTr:Find("conditions/list/tpl")
	arg0_2.objectiveContainer.localPosition = Vector3(2000, arg0_2.objectiveContainer.localPosition.y, 0)

	setText(arg0_2.bgTr:Find("conditions/Text"), i18n("battle_result_targets"))
end

function var0_0.SetUp(arg0_3, arg1_3)
	arg0_3:Show()
	seriesAsync({
		function(arg0_4)
			arg0_3:LoadBGAndGrade(arg0_4)
		end,
		function(arg0_5)
			arg0_3:PlayEnterAnimation(arg0_5)
			arg0_3:UpdateChapterName()
		end,
		function(arg0_6)
			arg0_3:LoadEffects(arg0_6)
		end,
		function(arg0_7)
			arg0_3:UpdateObjectives(arg0_7)
		end,
		function(arg0_8)
			arg0_3:RegisterEvent(arg0_8)
		end
	}, function()
		arg0_3:Clear()
		arg0_3:Destroy()
		arg1_3()
	end)
end

function var0_0.RegisterEvent(arg0_10, arg1_10)
	if arg0_10.exited then
		return
	end

	onButton(arg0_10, arg0_10._tf, arg1_10, SFX_PANEL)

	if arg0_10.contextData.autoSkipFlag then
		triggerButton(arg0_10._tf)
	end
end

function var0_0.Clear(arg0_11)
	removeOnButton(arg0_11._tf)
end

local function var1_0(arg0_12, arg1_12)
	local var0_12 = arg1_12.text or ""
	local var1_12 = arg1_12.icon
	local var2_12 = arg1_12.value or ""
	local var3_12 = arg0_12.transform:Find("checkBox"):GetComponent(typeof(Image))

	setActive(var3_12.gameObject, var1_12)

	if var1_12 then
		var3_12.sprite = GetSpriteFromAtlas("ui/battleresult_atlas", var1_12)

		var3_12:SetNativeSize()
	end

	setText(arg0_12.transform:Find("text"), var0_12)
	setText(arg0_12.transform:Find("value"), var2_12)
	setActive(arg0_12:Find("fx"), true)
end

function var0_0.GetGetObjectives(arg0_13)
	return NewBattleResultUtil.GetObjectives(arg0_13.contextData)
end

function var0_0.UpdateObjectives(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetGetObjectives()

	if #var0_14 <= 0 then
		setActive(arg0_14.objectiveTpl, false)
		arg1_14()

		return
	end

	local var1_14 = {
		arg0_14.objectiveTpl
	}

	for iter0_14 = 2, #var0_14 do
		local var2_14 = Object.Instantiate(arg0_14.objectiveTpl, arg0_14.objectiveContainer)

		table.insert(var1_14, var2_14)
	end

	local var3_14 = {}

	for iter1_14 = 1, #var0_14 do
		table.insert(var3_14, function(arg0_15)
			if arg0_14.exited then
				return
			end

			var1_0(var1_14[iter1_14], var0_14[iter1_14])
			onDelayTick(arg0_15, 0.3)
		end)
	end

	seriesAsync(var3_14, arg1_14)
	LeanTween.value(arg0_14.objectiveContainer.gameObject, 2000, 237, 0.3):setOnUpdate(System.Action_float(function(arg0_16)
		arg0_14.objectiveContainer.localPosition = Vector3(arg0_16, arg0_14.objectiveContainer.localPosition.y, 0)
	end))
end

function var0_0.UpdateChapterName(arg0_17)
	local var0_17 = NewBattleResultUtil.GetChapterName(arg0_17.contextData)

	setText(arg0_17.gradeChapterName, var0_17)
end

function var0_0.LoadEffects(arg0_18, arg1_18)
	LoadAnyAsync("BattleResultItems/ResultEffect", "", nil, function(arg0_19)
		if arg0_18.exited or IsNil(arg0_19) then
			if arg1_18 then
				arg1_18()
			end

			return
		end

		local var0_19 = Object.Instantiate(arg0_19, arg0_18.bgTr)

		setText(var0_19.transform:Find("Tips/dianjijixu/bg20"), i18n("battle_result_continue"))

		var0_19.name = "ResultEffect"

		var0_19.transform:SetSiblingIndex(1)

		if arg1_18 then
			arg1_18()
		end
	end)
end

function var0_0.PlayEnterAnimation(arg0_20, arg1_20)
	arg0_20.gradeTxtCG.alpha = 0

	LeanTween.value(arg0_20.gradeTxt.gameObject, 0.2, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_21)
		arg0_20.gradeTxtCG.alpha = arg0_21
	end)):setDelay(0.2)
	LeanTween.value(arg0_20.gradeTxt.gameObject, 1.3, 1, 0.15):setOnUpdate(System.Action_float(function(arg0_22)
		arg0_20.gradeTxt.localScale = Vector3(arg0_22, arg0_22, 1)
	end)):setDelay(0.15)

	local var0_20 = arg0_20.gradeLabel.localPosition

	arg0_20.gradeLabel.localPosition = arg0_20.gradeLabel.localPosition + Vector3(20, 20)

	LeanTween.moveLocal(arg0_20.gradeLabel.gameObject, var0_20, 0.15):setDelay(0.15)

	arg0_20.gradeChapterNameCG.alpha = 0

	LeanTween.value(arg0_20.gradeChapterName.gameObject, 0.1, 0.7, 0.3):setOnUpdate(System.Action_float(function(arg0_23)
		arg0_20.gradeChapterNameCG.alpha = arg0_23
	end)):setOnComplete(System.Action(function()
		arg0_20.gradeChapterNameCG.alpha = 1
	end)):setLoopPingPong(2):setDelay(0.15)
	LeanTween.value(arg0_20.gradeIcon.gameObject, 15, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_25)
		arg0_20.gradeIcon.localScale = Vector3(arg0_25, arg0_25, 1)
	end)):setOnComplete(System.Action(arg1_20))
end

function var0_0.LoadBGAndGrade(arg0_26, arg1_26)
	parallelAsync({
		function(arg0_27)
			arg0_26:LoadBG(arg0_27)
		end,
		function(arg0_28)
			arg0_26:LoadGrade(arg0_28)
		end
	}, arg1_26)
end

function var0_0.LoadBG(arg0_29, arg1_29)
	local var0_29 = NewBattleResultUtil.Score2Bg(arg0_29.contextData.score)

	LoadAnyAsync("BattleResultItems/" .. var0_29, "", nil, function(arg0_30)
		if arg0_29.exited or IsNil(arg0_30) then
			if arg1_29 then
				arg1_29()
			end

			return
		end

		local var0_30 = Object.Instantiate(arg0_30, arg0_29._parentTf)

		var0_30.transform:SetAsFirstSibling()

		var0_30.name = "Effect"

		if arg1_29 then
			arg1_29()
		end
	end)
end

function var0_0.LoadGrade(arg0_31, arg1_31)
	local var0_31, var1_31 = NewBattleResultUtil.Score2Grade(arg0_31.contextData.score, arg0_31.contextData._scoreMark)

	LoadImageSpriteAsync(var0_31, arg0_31.gradeIcon, true)
	LoadImageSpriteAsync(var1_31, arg0_31.gradeTxt, true)

	if arg1_31 then
		arg1_31()
	end
end

function var0_0.OnDestroy(arg0_32)
	arg0_32.exited = true

	if arg0_32:isShowing() then
		arg0_32:Hide()
	end

	if LeanTween.isTweening(arg0_32.objectiveContainer.gameObject) then
		LeanTween.cancel(arg0_32.objectiveContainer.gameObject)
	end

	if LeanTween.isTweening(arg0_32.gradeTxt.gameObject) then
		LeanTween.cancel(arg0_32.gradeTxt.gameObject)
	end

	if LeanTween.isTweening(arg0_32.gradeIcon.gameObject) then
		LeanTween.cancel(arg0_32.gradeIcon.gameObject)
	end

	if LeanTween.isTweening(arg0_32.gradeLabel.gameObject) then
		LeanTween.cancel(arg0_32.gradeLabel.gameObject)
	end

	if LeanTween.isTweening(arg0_32.gradeChapterNameCG.gameObject) then
		LeanTween.cancel(arg0_32.gradeChapterNameCG.gameObject)
	end
end

return var0_0

local var0 = class("NewBattleResultGradePage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "NewBattleResultGradePage"
end

function var0.OnLoaded(arg0)
	arg0.parentTr = arg0._tf.parent
	arg0.bgTr = arg0:findTF("bg")
	arg0.gradePanel = arg0.bgTr:Find("grade")
	arg0.gradeIcon = arg0.bgTr:Find("grade/icon")
	arg0.gradeTxt = arg0.bgTr:Find("grade/Text")
	arg0.gradeLabel = arg0.bgTr:Find("grade/label")
	arg0.gradeChapterName = arg0.bgTr:Find("grade/chapterName")
	arg0.gradeTxtCG = arg0.gradeTxt:GetComponent(typeof(CanvasGroup))
	arg0.gradeChapterNameCG = arg0.gradeChapterName:GetComponent(typeof(CanvasGroup))
	arg0.objectiveContainer = arg0.bgTr:Find("conditions/list")
	arg0.objectiveTpl = arg0.bgTr:Find("conditions/list/tpl")
	arg0.objectiveContainer.localPosition = Vector3(2000, arg0.objectiveContainer.localPosition.y, 0)

	setText(arg0.bgTr:Find("conditions/Text"), i18n("battle_result_targets"))
end

function var0.SetUp(arg0, arg1)
	arg0:Show()
	seriesAsync({
		function(arg0)
			arg0:LoadBGAndGrade(arg0)
		end,
		function(arg0)
			arg0:PlayEnterAnimation(arg0)
			arg0:UpdateChapterName()
		end,
		function(arg0)
			arg0:LoadEffects(arg0)
		end,
		function(arg0)
			arg0:UpdateObjectives(arg0)
		end,
		function(arg0)
			arg0:RegisterEvent(arg0)
		end
	}, function()
		arg0:Clear()
		arg0:Destroy()
		arg1()
	end)
end

function var0.RegisterEvent(arg0, arg1)
	if arg0.exited then
		return
	end

	onButton(arg0, arg0._tf, arg1, SFX_PANEL)

	if arg0.contextData.autoSkipFlag then
		triggerButton(arg0._tf)
	end
end

function var0.Clear(arg0)
	removeOnButton(arg0._tf)
end

local function var1(arg0, arg1)
	local var0 = arg1.text or ""
	local var1 = arg1.icon
	local var2 = arg1.value or ""
	local var3 = arg0.transform:Find("checkBox"):GetComponent(typeof(Image))

	setActive(var3.gameObject, var1)

	if var1 then
		var3.sprite = GetSpriteFromAtlas("ui/battleresult_atlas", var1)

		var3:SetNativeSize()
	end

	setText(arg0.transform:Find("text"), var0)
	setText(arg0.transform:Find("value"), var2)
	setActive(arg0:Find("fx"), true)
end

function var0.GetGetObjectives(arg0)
	return NewBattleResultUtil.GetObjectives(arg0.contextData)
end

function var0.UpdateObjectives(arg0, arg1)
	local var0 = arg0:GetGetObjectives()

	if #var0 <= 0 then
		setActive(arg0.objectiveTpl, false)
		arg1()

		return
	end

	local var1 = {
		arg0.objectiveTpl
	}

	for iter0 = 2, #var0 do
		local var2 = Object.Instantiate(arg0.objectiveTpl, arg0.objectiveContainer)

		table.insert(var1, var2)
	end

	local var3 = {}

	for iter1 = 1, #var0 do
		table.insert(var3, function(arg0)
			if arg0.exited then
				return
			end

			var1(var1[iter1], var0[iter1])
			onDelayTick(arg0, 0.3)
		end)
	end

	seriesAsync(var3, arg1)
	LeanTween.value(arg0.objectiveContainer.gameObject, 2000, 237, 0.3):setOnUpdate(System.Action_float(function(arg0)
		arg0.objectiveContainer.localPosition = Vector3(arg0, arg0.objectiveContainer.localPosition.y, 0)
	end))
end

function var0.UpdateChapterName(arg0)
	local var0 = NewBattleResultUtil.GetChapterName(arg0.contextData)

	setText(arg0.gradeChapterName, var0)
end

function var0.LoadEffects(arg0, arg1)
	ResourceMgr.Inst:getAssetAsync("BattleResultItems/ResultEffect", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.exited or IsNil(arg0) then
			if arg1 then
				arg1()
			end

			return
		end

		local var0 = Object.Instantiate(arg0, arg0.bgTr)

		setText(var0.transform:Find("Tips/dianjijixu/bg20"), i18n("battle_result_continue"))

		var0.name = "ResultEffect"

		var0.transform:SetSiblingIndex(1)

		if arg1 then
			arg1()
		end
	end), true, true)
end

function var0.PlayEnterAnimation(arg0, arg1)
	arg0.gradeTxtCG.alpha = 0

	LeanTween.value(arg0.gradeTxt.gameObject, 0.2, 1, 0.3):setOnUpdate(System.Action_float(function(arg0)
		arg0.gradeTxtCG.alpha = arg0
	end)):setDelay(0.2)
	LeanTween.value(arg0.gradeTxt.gameObject, 1.3, 1, 0.15):setOnUpdate(System.Action_float(function(arg0)
		arg0.gradeTxt.localScale = Vector3(arg0, arg0, 1)
	end)):setDelay(0.15)

	local var0 = arg0.gradeLabel.localPosition

	arg0.gradeLabel.localPosition = arg0.gradeLabel.localPosition + Vector3(20, 20)

	LeanTween.moveLocal(arg0.gradeLabel.gameObject, var0, 0.15):setDelay(0.15)

	arg0.gradeChapterNameCG.alpha = 0

	LeanTween.value(arg0.gradeChapterName.gameObject, 0.1, 0.7, 0.3):setOnUpdate(System.Action_float(function(arg0)
		arg0.gradeChapterNameCG.alpha = arg0
	end)):setOnComplete(System.Action(function()
		arg0.gradeChapterNameCG.alpha = 1
	end)):setLoopPingPong(2):setDelay(0.15)
	LeanTween.value(arg0.gradeIcon.gameObject, 15, 1, 0.3):setOnUpdate(System.Action_float(function(arg0)
		arg0.gradeIcon.localScale = Vector3(arg0, arg0, 1)
	end)):setOnComplete(System.Action(arg1))
end

function var0.LoadBGAndGrade(arg0, arg1)
	parallelAsync({
		function(arg0)
			arg0:LoadBG(arg0)
		end,
		function(arg0)
			arg0:LoadGrade(arg0)
		end
	}, arg1)
end

function var0.LoadBG(arg0, arg1)
	local var0 = NewBattleResultUtil.Score2Bg(arg0.contextData.score)

	ResourceMgr.Inst:getAssetAsync("BattleResultItems/" .. var0, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.exited or IsNil(arg0) then
			if arg1 then
				arg1()
			end

			return
		end

		local var0 = Object.Instantiate(arg0, arg0._parentTf)

		var0.transform:SetAsFirstSibling()

		var0.name = "Effect"

		if arg1 then
			arg1()
		end
	end), false, false)
end

function var0.LoadGrade(arg0, arg1)
	local var0, var1 = NewBattleResultUtil.Score2Grade(arg0.contextData.score, arg0.contextData._scoreMark)

	LoadImageSpriteAsync(var0, arg0.gradeIcon, true)
	LoadImageSpriteAsync(var1, arg0.gradeTxt, true)

	if arg1 then
		arg1()
	end
end

function var0.OnDestroy(arg0)
	arg0.exited = true

	if arg0:isShowing() then
		arg0:Hide()
	end

	if LeanTween.isTweening(arg0.objectiveContainer.gameObject) then
		LeanTween.cancel(arg0.objectiveContainer.gameObject)
	end

	if LeanTween.isTweening(arg0.gradeTxt.gameObject) then
		LeanTween.cancel(arg0.gradeTxt.gameObject)
	end

	if LeanTween.isTweening(arg0.gradeIcon.gameObject) then
		LeanTween.cancel(arg0.gradeIcon.gameObject)
	end

	if LeanTween.isTweening(arg0.gradeLabel.gameObject) then
		LeanTween.cancel(arg0.gradeLabel.gameObject)
	end

	if LeanTween.isTweening(arg0.gradeChapterNameCG.gameObject) then
		LeanTween.cancel(arg0.gradeChapterNameCG.gameObject)
	end
end

return var0

local var0 = class("EducateCharProfileScene", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "EducateCharProfileUI"
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("adapt/top/back")
	arg0.homeBtn = arg0:findTF("adapt/top/home")
	arg0.paintingTr = arg0:findTF("main/mask/painting")
	arg0.chatTf = arg0:findTF("main/chat")
	arg0.chatTxt = arg0.chatTf:Find("Text"):GetComponent(typeof(Text))
	arg0.toggleUIItemList = UIItemList.New(arg0:findTF("main/tag"), arg0:findTF("main/tag/tpl"))
	arg0.wordUIItemList = UIItemList.New(arg0:findTF("main/list/content"), arg0:findTF("main/list/content/tpl"))
	arg0.cvLoader = EducateCharCvLoader.New()
	arg0.animation = arg0._tf:GetComponent(typeof(Animation))
	arg0.timers = {}
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0, arg0.homeBtn, function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	arg0:InitToggles()
end

function var0.InitToggles(arg0)
	local var0 = getProxy(EducateProxy):GetEducateGroupList()

	table.sort(var0, function(arg0, arg1)
		return arg0:GetSortWeight() < arg1:GetSortWeight()
	end)
	arg0.toggleUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateToggle(arg2, var0[arg1 + 1])

			if arg1 == 0 then
				arg0.isInit = true

				triggerToggle(arg2, true)
			end
		end
	end)
	arg0.toggleUIItemList:align(#var0)

	arg0.isInit = false
end

function var0.UpdateToggle(arg0, arg1, arg2)
	setImageSprite(arg1:Find("sel/Text"), GetSpriteFromAtlas("ui/EducateCharProfileUI_atlas", arg2:GetSpriteName()), true)
	setImageSprite(arg1:Find("Text"), GetSpriteFromAtlas("ui/EducateCharProfileUI_atlas", arg2:GetSpriteName()), true)
	setActive(arg1:Find("lock"), arg2:IsLock())
	onToggle(arg0, arg1, function(arg0)
		if arg0 then
			if not arg0.isInit then
				arg0.animation:Play("anim_educate_profile_change")

				arg0.isInit = nil
			end

			local var0 = arg2:GetShowId()

			arg0:ClearCurrentWord()
			arg0:InitPainting(var0)
			arg0:InitWordList(var0)
		end
	end, SFX_PANEL)
end

function var0.GetWordList(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(pg.character_voice_special.all) do
		local var1 = iter1

		if string.find(iter1, ShipWordHelper.WORD_TYPE_MAIN) then
			local var2 = string.gsub(iter1, ShipWordHelper.WORD_TYPE_MAIN, "")

			var1 = ShipWordHelper.WORD_TYPE_MAIN .. "_" .. var2
		end

		if EducateCharWordHelper.ExistWord(arg1, var1) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.InitWordList(arg0, arg1)
	local var0 = arg0:GetWordList(arg1)
	local var1 = pg.secretary_special_ship[arg1]

	arg0:RemoveAllTimer()
	arg0.wordUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateWordCard(arg2, arg1, var0[arg1 + 1], arg1)
		end
	end)
	arg0.wordUIItemList:align(#var0)
end

function var0.UpdateWordCard(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1:Find("bg")
	local var1 = pg.character_voice_special[arg3]

	setText(var0:Find("Text"), var1.voice_name)

	local var2 = -1

	onButton(arg0, var0, function()
		if arg0.chatting then
			return
		end

		local var0, var1, var2, var3 = EducateCharWordHelper.GetWordAndCV(arg2, var1.resource_key)

		seriesAsync({
			function(arg0)
				arg0:OnChatStart(var0, var2, arg0)
			end,
			function(arg0)
				arg0:UpdateExpression(arg2, var1.resource_key)
				arg0:PlayCV(var3, var0, function(arg0)
					var2 = arg0

					arg0()
				end)
			end,
			function(arg0)
				arg0:StartCharAnimation(var2, arg0)
			end
		}, function()
			arg0:OnChatEnd()
		end)
	end, SFX_PANEL)
	setActive(var0, false)

	arg0.timers[arg4] = Timer.New(function()
		setActive(var0, true)
		arg1:GetComponent(typeof(Animation)):Play("anim_educate_profile_tpl")
	end, math.max(1e-05, arg4 * 0.066), 1)

	arg0.timers[arg4]:Start()
end

function var0.RemoveAllTimer(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		iter1:Stop()

		iter1 = nil
	end

	arg0.timers = {}
end

function var0.OnChatStart(arg0, arg1, arg2, arg3)
	arg0.chatting = true
	arg0.chatTxt.text = arg2

	triggerToggle(arg1:Find("state"), true)

	arg0.selectedCard = arg1

	arg3()
end

function var0.UpdateExpression(arg0, arg1, arg2)
	local var0 = EducateCharWordHelper.GetExpression(arg1, arg2)

	if var0 and var0 ~= "" then
		ShipExpressionHelper.UpdateExpression(findTF(arg0.paintingTr, "fitter"):GetChild(0), arg0.paintingName, var0)
	else
		ShipExpressionHelper.UpdateExpression(findTF(arg0.paintingTr, "fitter"):GetChild(0), arg0.paintingName, "")
	end
end

function var0.OnChatEnd(arg0)
	arg0:ClearCurrentWord()
end

function var0.PlayCV(arg0, arg1, arg2, arg3)
	arg0.cvLoader:Play(arg1, arg2, 0, arg3)
end

function var0.StartCharAnimation(arg0, arg1, arg2)
	local var0 = 0.3
	local var1 = arg1 > 0 and arg1 or 3

	LeanTween.scale(rtf(arg0.chatTf.gameObject), Vector3.New(1, 1, 1), var0):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0.chatTf.gameObject), Vector3.New(0, 0, 1), var0):setEase(LeanTweenType.easeInBack):setDelay(var0 + var1):setOnComplete(System.Action(arg2))
	end))
end

function var0.InitPainting(arg0, arg1)
	arg0:ReturnPainting()

	local var0 = pg.secretary_special_ship[arg1]

	setPaintingPrefab(arg0.paintingTr, var0.prefab, "tb3")

	arg0.paintingName = var0.prefab
end

function var0.ReturnPainting(arg0)
	if arg0.paintingName then
		retPaintingPrefab(arg0.paintingTr, arg0.paintingName)

		arg0.paintingName = nil
	end
end

function var0.ClearCurrentWord(arg0)
	arg0.chatting = nil

	LeanTween.cancel(arg0.chatTf.gameObject)

	arg0.chatTf.localScale = Vector3.zero

	arg0.cvLoader:Stop()

	if not arg0.selectedCard then
		return
	end

	local var0 = arg0.selectedCard

	arg0.selectedCard = nil

	triggerToggle(var0:Find("state"), false)
end

function var0.onBackPressed(arg0)
	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	arg0:ClearCurrentWord()
	arg0:RemoveAllTimer()
	arg0:ReturnPainting()

	if arg0.cvLoader then
		arg0.cvLoader:Dispose()

		arg0.cvLoader = nil
	end
end

return var0

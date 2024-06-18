local var0_0 = class("EducateCharProfileScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateCharProfileUI"
end

function var0_0.init(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("adapt/top/back")
	arg0_2.homeBtn = arg0_2:findTF("adapt/top/home")
	arg0_2.paintingTr = arg0_2:findTF("main/mask/painting")
	arg0_2.chatTf = arg0_2:findTF("main/chat")
	arg0_2.chatTxt = arg0_2.chatTf:Find("Text"):GetComponent(typeof(Text))
	arg0_2.toggleUIItemList = UIItemList.New(arg0_2:findTF("main/tag"), arg0_2:findTF("main/tag/tpl"))
	arg0_2.wordUIItemList = UIItemList.New(arg0_2:findTF("main/list/content"), arg0_2:findTF("main/list/content/tpl"))
	arg0_2.cvLoader = EducateCharCvLoader.New()
	arg0_2.animation = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.timers = {}
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.homeBtn, function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	arg0_3:InitToggles()
end

function var0_0.InitToggles(arg0_6)
	local var0_6 = getProxy(EducateProxy):GetEducateGroupList()

	table.sort(var0_6, function(arg0_7, arg1_7)
		return arg0_7:GetSortWeight() < arg1_7:GetSortWeight()
	end)
	arg0_6.toggleUIItemList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			arg0_6:UpdateToggle(arg2_8, var0_6[arg1_8 + 1])

			if arg1_8 == 0 then
				arg0_6.isInit = true

				triggerToggle(arg2_8, true)
			end
		end
	end)
	arg0_6.toggleUIItemList:align(#var0_6)

	arg0_6.isInit = false
end

function var0_0.UpdateToggle(arg0_9, arg1_9, arg2_9)
	setImageSprite(arg1_9:Find("sel/Text"), GetSpriteFromAtlas("ui/EducateCharProfileUI_atlas", arg2_9:GetSpriteName()), true)
	setImageSprite(arg1_9:Find("Text"), GetSpriteFromAtlas("ui/EducateCharProfileUI_atlas", arg2_9:GetSpriteName()), true)
	setActive(arg1_9:Find("lock"), arg2_9:IsLock())
	onToggle(arg0_9, arg1_9, function(arg0_10)
		if arg0_10 then
			if not arg0_9.isInit then
				arg0_9.animation:Play("anim_educate_profile_change")

				arg0_9.isInit = nil
			end

			local var0_10 = arg2_9:GetShowId()

			arg0_9:ClearCurrentWord()
			arg0_9:InitPainting(var0_10)
			arg0_9:InitWordList(var0_10)
		end
	end, SFX_PANEL)
end

function var0_0.GetWordList(arg0_11, arg1_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(pg.character_voice_special.all) do
		local var1_11 = iter1_11

		if string.find(iter1_11, ShipWordHelper.WORD_TYPE_MAIN) then
			local var2_11 = string.gsub(iter1_11, ShipWordHelper.WORD_TYPE_MAIN, "")

			var1_11 = ShipWordHelper.WORD_TYPE_MAIN .. "_" .. var2_11
		end

		if EducateCharWordHelper.ExistWord(arg1_11, var1_11) then
			table.insert(var0_11, iter1_11)
		end
	end

	return var0_11
end

function var0_0.InitWordList(arg0_12, arg1_12)
	local var0_12 = arg0_12:GetWordList(arg1_12)
	local var1_12 = pg.secretary_special_ship[arg1_12]

	arg0_12:RemoveAllTimer()
	arg0_12.wordUIItemList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			arg0_12:UpdateWordCard(arg2_13, arg1_12, var0_12[arg1_13 + 1], arg1_13)
		end
	end)
	arg0_12.wordUIItemList:align(#var0_12)
end

function var0_0.UpdateWordCard(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	local var0_14 = arg1_14:Find("bg")
	local var1_14 = pg.character_voice_special[arg3_14]

	setText(var0_14:Find("Text"), var1_14.voice_name)

	local var2_14 = -1

	onButton(arg0_14, var0_14, function()
		if arg0_14.chatting then
			return
		end

		local var0_15, var1_15, var2_15, var3_15 = EducateCharWordHelper.GetWordAndCV(arg2_14, var1_14.resource_key)

		seriesAsync({
			function(arg0_16)
				arg0_14:OnChatStart(var0_14, var2_15, arg0_16)
			end,
			function(arg0_17)
				arg0_14:UpdateExpression(arg2_14, var1_14.resource_key)
				arg0_14:PlayCV(var3_15, var0_15, function(arg0_18)
					var2_14 = arg0_18

					arg0_17()
				end)
			end,
			function(arg0_19)
				arg0_14:StartCharAnimation(var2_14, arg0_19)
			end
		}, function()
			arg0_14:OnChatEnd()
		end)
	end, SFX_PANEL)
	setActive(var0_14, false)

	arg0_14.timers[arg4_14] = Timer.New(function()
		setActive(var0_14, true)
		arg1_14:GetComponent(typeof(Animation)):Play("anim_educate_profile_tpl")
	end, math.max(1e-05, arg4_14 * 0.066), 1)

	arg0_14.timers[arg4_14]:Start()
end

function var0_0.RemoveAllTimer(arg0_22)
	for iter0_22, iter1_22 in pairs(arg0_22.timers) do
		iter1_22:Stop()

		iter1_22 = nil
	end

	arg0_22.timers = {}
end

function var0_0.OnChatStart(arg0_23, arg1_23, arg2_23, arg3_23)
	arg0_23.chatting = true
	arg0_23.chatTxt.text = arg2_23

	triggerToggle(arg1_23:Find("state"), true)

	arg0_23.selectedCard = arg1_23

	arg3_23()
end

function var0_0.UpdateExpression(arg0_24, arg1_24, arg2_24)
	local var0_24 = EducateCharWordHelper.GetExpression(arg1_24, arg2_24)

	if var0_24 and var0_24 ~= "" then
		ShipExpressionHelper.UpdateExpression(findTF(arg0_24.paintingTr, "fitter"):GetChild(0), arg0_24.paintingName, var0_24)
	else
		ShipExpressionHelper.UpdateExpression(findTF(arg0_24.paintingTr, "fitter"):GetChild(0), arg0_24.paintingName, "")
	end
end

function var0_0.OnChatEnd(arg0_25)
	arg0_25:ClearCurrentWord()
end

function var0_0.PlayCV(arg0_26, arg1_26, arg2_26, arg3_26)
	arg0_26.cvLoader:Play(arg1_26, arg2_26, 0, arg3_26)
end

function var0_0.StartCharAnimation(arg0_27, arg1_27, arg2_27)
	local var0_27 = 0.3
	local var1_27 = arg1_27 > 0 and arg1_27 or 3

	LeanTween.scale(rtf(arg0_27.chatTf.gameObject), Vector3.New(1, 1, 1), var0_27):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_27.chatTf.gameObject), Vector3.New(0, 0, 1), var0_27):setEase(LeanTweenType.easeInBack):setDelay(var0_27 + var1_27):setOnComplete(System.Action(arg2_27))
	end))
end

function var0_0.InitPainting(arg0_29, arg1_29)
	arg0_29:ReturnPainting()

	local var0_29 = pg.secretary_special_ship[arg1_29]

	setPaintingPrefab(arg0_29.paintingTr, var0_29.prefab, "tb3")

	arg0_29.paintingName = var0_29.prefab
end

function var0_0.ReturnPainting(arg0_30)
	if arg0_30.paintingName then
		retPaintingPrefab(arg0_30.paintingTr, arg0_30.paintingName)

		arg0_30.paintingName = nil
	end
end

function var0_0.ClearCurrentWord(arg0_31)
	arg0_31.chatting = nil

	LeanTween.cancel(arg0_31.chatTf.gameObject)

	arg0_31.chatTf.localScale = Vector3.zero

	arg0_31.cvLoader:Stop()

	if not arg0_31.selectedCard then
		return
	end

	local var0_31 = arg0_31.selectedCard

	arg0_31.selectedCard = nil

	triggerToggle(var0_31:Find("state"), false)
end

function var0_0.onBackPressed(arg0_32)
	var0_0.super.onBackPressed(arg0_32)
end

function var0_0.willExit(arg0_33)
	arg0_33:ClearCurrentWord()
	arg0_33:RemoveAllTimer()
	arg0_33:ReturnPainting()

	if arg0_33.cvLoader then
		arg0_33.cvLoader:Dispose()

		arg0_33.cvLoader = nil
	end
end

return var0_0

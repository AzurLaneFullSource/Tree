local var0_0 = class("LoveLetterDisplayLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "LoveLetterDisplayUI"
end

function var0_0.preload(arg0_2, arg1_2)
	pg.PoolMgr.GetInstance():GetPrefab("LoveLetterStyle/" .. arg0_2.contextData.prefab, "", true, function(arg0_3)
		arg0_2.rtStyle = arg0_3.transform

		arg1_2()
	end)
end

var0_0.optionsPath = {}

function var0_0.SetLoveLetter(arg0_4, arg1_4)
	arg0_4.ll = getProxy(LoveLetterProxy):GetGroupData(arg1_4)
	arg0_4.letterIds = arg0_4.ll:GetDisplayLetterList()

	arg0_4:ShowLetter(arg0_4.contextData.letterId or arg0_4.letterIds[1])
end

function var0_0.init(arg0_5)
	setParent(arg0_5.rtStyle, arg0_5.rtPanel)
	onButton(arg0_5, arg0_5.rtBg, function()
		arg0_5:closeView()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.rtStyle:Find("before"), function()
		arg0_5:emit(LoveLetterDisplayMediator.ON_UNLOCK_LETTER, arg0_5.letterId)
	end, SFX_PANEL)
	arg0_5:addRingDragListenter()
	arg0_5:BlurPanel(arg0_5._tf)
end

function var0_0.didEnter(arg0_8)
	setText(arg0_8.rtStyle:Find("after/bg/paper_root/name"), arg0_8.ll:GetName())
end

function var0_0.ChangeLetter(arg0_9, arg1_9)
	local var0_9 = table.indexof(arg0_9.letterIds, arg0_9.letterId) + arg1_9

	if var0_9 ~= math.clamp(var0_9, 1, #arg0_9.letterIds) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("loveactivity_ui_15"))
	else
		arg0_9:ShowLetter(arg0_9.letterIds[var0_9])
	end
end

function var0_0.ShowLetter(arg0_10, arg1_10)
	arg0_10.letterId = arg1_10
	arg0_10.contextData.letterId = arg0_10.letterId

	setText(arg0_10.rtStyle:Find("after/bg/paper_root/content"), getProxy(LoveLetterProxy):GetLoveLetterContent(arg1_10))

	local var0_10 = table.indexof(arg0_10.letterIds, arg0_10.letterId)

	UIItemList.StaticAlign(arg0_10.rtPointsContainer, arg0_10.rtPointsTpl, #arg0_10.letterIds, function(arg0_11, arg1_11, arg2_11)
		arg1_11 = arg1_11 + 1

		if arg0_11 == UIItemList.EventUpdate then
			setActive(arg2_11:Find("short"), arg1_11 ~= var0_10)
			setActive(arg2_11:Find("long"), arg1_11 == var0_10)
			setActive(arg2_11:Find("short/pick_up"), not arg0_10.ll:GetLetterUnlock(arg0_10.letterIds[arg1_11]))
		end
	end)
	arg0_10:UpdateLetterDisplay(arg0_10.ll:GetLetterUnlock(arg0_10.letterId))
end

function var0_0.DoOpenLetter(arg0_12)
	onButton(arg0_12, arg0_12.rtAnim:Find("click"), function()
		local var0_13 = arg0_12.clickCall

		arg0_12.clickCall = nil

		existCall(var0_13)
	end, SFX_PANEL)

	GetOrAddComponent(arg0_12._tf, "EventTriggerListener").enabled = false

	setActive(arg0_12.rtPointsContainer, false)
	pg.UIMgr.GetInstance():LoadingOn()

	local var0_12 = {}

	table.insert(var0_12, function(arg0_14)
		local var0_14 = arg0_12.ll:GetDisplayInfo()

		parallelAsync({
			function(arg0_15)
				pg.PoolMgr.GetInstance():GetPrefab("loveletteranim/loveletteranim", "", true, function(arg0_16)
					arg0_12.rtAnimation = arg0_16.transform

					arg0_15()
				end)
			end,
			function(arg0_17)
				LoadSpriteAtlasAsync("bg/" .. arg0_12.contextData.bg, "", function(arg0_18)
					arg0_12.spriteBg = arg0_18

					arg0_17()
				end)
			end,
			function(arg0_19)
				LoadSpriteAtlasAsync("loveletterstyleatlas/mail_" .. arg0_12.contextData.prefab, "", function(arg0_20)
					arg0_12.spriteMail = arg0_20

					arg0_19()
				end)
			end,
			function(arg0_21)
				LoadSpriteAtlasAsync("loveletterstyleatlas/" .. var0_14.hand, "", function(arg0_22)
					arg0_12.spriteHand = arg0_22

					arg0_21()
				end)
			end,
			function(arg0_23)
				LoadSpriteAtlasAsync("loveletterstyleatlas/" .. var0_14.kiss, "", function(arg0_24)
					arg0_12.spriteKiss = arg0_24

					arg0_23()
				end)
			end
		}, function()
			setParent(arg0_12.rtAnimation, arg0_12.rtAnim:Find("content"))
			setImageSprite(arg0_12.rtAnimation:Find("bg_root/bg"), arg0_12.spriteBg)
			setImageSprite(arg0_12.rtAnimation:Find("fx_letter_in/deco_letter/deco_letter_1"), arg0_12.spriteMail)
			setImageSprite(arg0_12.rtAnimation:Find("fx_letter_in/deco_letter/lip_01"), arg0_12.spriteKiss, true)
			setImageSprite(arg0_12.rtAnimation:Find("hand/hand_deco"), arg0_12.spriteHand, true)
			arg0_12.rtAnimation:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_26)
				local var0_26 = arg0_12.nextCall

				arg0_12.nextCall = nil

				existCall(var0_26, arg0_26)
			end)
			eachChild(arg0_12.rtAnimation:Find("letter_style/root"), function(arg0_27, arg1_27)
				setActive(arg0_27, arg0_27.name == arg0_12.contextData.prefab)

				if arg0_27.name == arg0_12.contextData.prefab then
					setText(arg0_27:Find("after/bg/paper_root/name"), arg0_12.ll:GetName())
					setText(arg0_27:Find("after/bg/paper_root/content"), getProxy(LoveLetterProxy):GetLoveLetterContent(arg0_12.contextData.letterId))
				end
			end)
			arg0_14()
		end)
	end)
	table.insert(var0_12, function(arg0_28)
		setPaintingPrefab(arg0_12.rtAnimation:Find("painting_root/paint"), arg0_12.ll:GetPainting(), "mainNormal", nil, nil, arg0_28)
	end)
	table.insert(var0_12, function(arg0_29)
		pg.UIMgr.GetInstance():LoadingOff()
		setActive(arg0_12.rtAnim, true)

		function arg0_12.nextCall()
			setActive(arg0_12.rtAnim:Find("click"), true)
		end

		arg0_12.clickCall = arg0_29

		setActive(arg0_12.rtAnim:Find("click"), false)
		quickPlayAnimation(arg0_12.rtAnimation, "anim_LoveLetterDisplayUI_fadein_01")
	end)
	table.insert(var0_12, function(arg0_31)
		setActive(arg0_12.rtAnim, true)

		function arg0_12.nextCall()
			setActive(arg0_12.rtAnim:Find("click"), true)
		end

		arg0_12.clickCall = arg0_31

		setActive(arg0_12.rtAnim:Find("click"), false)
		quickPlayAnimation(arg0_12.rtAnimation, "anim_LoveLetterDisplayUI_fadein_02")
	end)
	table.insert(var0_12, function(arg0_33)
		setActive(arg0_12.rtAnim, true)

		arg0_12.nextCall = arg0_33

		setActive(arg0_12.rtAnim:Find("click"), false)
		quickPlayAnimation(arg0_12.rtAnimation, "anim_LoveLetterDisplayUI_fadeout_01")
	end)
	seriesAsync(var0_12, function()
		setActive(arg0_12.rtAnim, false)
		setActive(arg0_12.rtPointsContainer, true)
		arg0_12:UpdateLetterDisplay(true)

		GetOrAddComponent(arg0_12._tf, "EventTriggerListener").enabled = true
	end)
end

function var0_0.UpdateLetterDisplay(arg0_35, arg1_35)
	setActive(arg0_35.rtStyle:Find("after"), arg1_35)
	setActive(arg0_35.rtStyle:Find("before"), not arg1_35)
	setButtonEnabled(arg0_35.rtStyle:Find("before"), not arg1_35)

	if not arg1_35 then
		setLoveLetterMedal(arg0_35.rtStyle:Find("before/medal"), setmetatable({
			level = table.indexof(pg.lover_letter_content.get_id_list_by_ship_group[arg0_35.ll.groupId], arg0_35.contextData.letterId)
		}, {
			__index = arg0_35.ll
		}))
	end
end

function var0_0.addRingDragListenter(arg0_36)
	local var0_36 = GetOrAddComponent(arg0_36._tf, "EventTriggerListener")
	local var1_36
	local var2_36 = 0
	local var3_36

	var0_36:AddBeginDragFunc(function()
		var2_36 = 0
		var1_36 = nil
	end)
	var0_36:AddDragFunc(function(arg0_38, arg1_38)
		local var0_38 = arg1_38.position

		if not var1_36 then
			var1_36 = var0_38
		end

		var2_36 = var0_38.x - var1_36.x
	end)
	var0_36:AddDragEndFunc(function(arg0_39, arg1_39)
		if arg0_36.isBlock then
			return
		end

		if var2_36 < -50 then
			arg0_36:ChangeLetter(1)
		elseif var2_36 > 50 then
			arg0_36:ChangeLetter(-1)
		end
	end)
end

function var0_0.willExit(arg0_40)
	if arg0_40.rtStyle then
		eachChild(arg0_40.rtStyle:Find("before/medal"), function(arg0_41, arg1_41)
			returnLoveLetterMedal(arg0_41)
		end)
		pg.PoolMgr.GetInstance():ReturnPrefab("LoveLetterStyle/" .. arg0_40.contextData.prefab, "", arg0_40.rtStyle.gameObject)

		arg0_40.rtStyle = nil
	end

	if arg0_40.rtAnimation then
		retPaintingPrefab(arg0_40.rtAnimation:Find("painting_root/paint"), arg0_40.ll:GetPainting(), "mainNormal")
		pg.PoolMgr.GetInstance():ReturnPrefab("loveletteranim/loveletteranim", "", arg0_40.rtAnimation.gameObject)

		arg0_40.rtAnimation = nil
	end
end

return var0_0

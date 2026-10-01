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

function var0_0.getResource(arg0_4)
	local var0_4 = var0_0.super.getResource(arg0_4)
	local var1_4 = {}

	local function var2_4(arg0_5)
		if noEmptyStr(arg0_5) and not table.contains(var1_4, arg0_5) then
			table.insert(var1_4, arg0_5)
		end
	end

	var2_4("LoveLetterStyle/" .. arg0_4.contextData.prefab)
	var2_4("loveletteranim/loveletteranim")
	var2_4("bg/" .. arg0_4.contextData.bg)
	var2_4("loveletterstyleatlas/mail_" .. arg0_4.contextData.prefab)

	local var3_4 = getProxy(LoveLetterProxy)
	local var4_4 = var3_4 and var3_4:GetGroupData(arg0_4.contextData.groupId)

	if var4_4 then
		local var5_4 = var4_4:GetDisplayInfo()

		if var5_4 then
			var2_4("loveletterstyleatlas/" .. var5_4.hand)
			var2_4("loveletterstyleatlas/" .. var5_4.kiss)
		end

		local var6_4 = var4_4:GetPainting()

		if noEmptyStr(var6_4) then
			PaintingGroupConst.AddPaintingNameWithFilteMap(var1_4, var6_4)
		end
	end

	for iter0_4, iter1_4 in ipairs(var1_4) do
		if noEmptyStr(iter1_4) and not table.contains(var0_4, iter1_4) then
			table.insert(var0_4, iter1_4)
		end
	end

	return var0_4
end

var0_0.optionsPath = {}

function var0_0.SetLoveLetter(arg0_6, arg1_6)
	arg0_6.ll = getProxy(LoveLetterProxy):GetGroupData(arg1_6)
	arg0_6.letterIds = arg0_6.ll:GetDisplayLetterList()

	arg0_6:ShowLetter(arg0_6.contextData.letterId or arg0_6.letterIds[1])
end

function var0_0.init(arg0_7)
	setParent(arg0_7.rtStyle, arg0_7.rtPanel)
	onButton(arg0_7, arg0_7.rtBg, function()
		arg0_7:closeView()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.rtStyle:Find("before"), function()
		arg0_7:emit(LoveLetterDisplayMediator.ON_UNLOCK_LETTER, arg0_7.letterId)
	end, SFX_PANEL)
	arg0_7:addRingDragListenter()
	arg0_7:BlurPanel(arg0_7._tf)
end

function var0_0.didEnter(arg0_10)
	setText(arg0_10.rtStyle:Find("after/bg/paper_root/name"), arg0_10.ll:GetName())
end

function var0_0.ChangeLetter(arg0_11, arg1_11)
	local var0_11 = table.indexof(arg0_11.letterIds, arg0_11.letterId) + arg1_11

	if var0_11 ~= math.clamp(var0_11, 1, #arg0_11.letterIds) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("loveactivity_ui_15"))
	else
		arg0_11:ShowLetter(arg0_11.letterIds[var0_11])
	end
end

function var0_0.ShowLetter(arg0_12, arg1_12)
	arg0_12.letterId = arg1_12
	arg0_12.contextData.letterId = arg0_12.letterId

	setText(arg0_12.rtStyle:Find("after/bg/paper_root/content"), getProxy(LoveLetterProxy):GetLoveLetterContent(arg1_12))

	local var0_12 = table.indexof(arg0_12.letterIds, arg0_12.letterId)

	UIItemList.StaticAlign(arg0_12.rtPointsContainer, arg0_12.rtPointsTpl, #arg0_12.letterIds, function(arg0_13, arg1_13, arg2_13)
		arg1_13 = arg1_13 + 1

		if arg0_13 == UIItemList.EventUpdate then
			setActive(arg2_13:Find("short"), arg1_13 ~= var0_12)
			setActive(arg2_13:Find("long"), arg1_13 == var0_12)
			setActive(arg2_13:Find("short/pick_up"), not arg0_12.ll:GetLetterUnlock(arg0_12.letterIds[arg1_13]))
		end
	end)
	arg0_12:UpdateLetterDisplay(arg0_12.ll:GetLetterUnlock(arg0_12.letterId))
end

function var0_0.DoOpenLetter(arg0_14)
	onButton(arg0_14, arg0_14.rtAnim:Find("click"), function()
		local var0_15 = arg0_14.clickCall

		arg0_14.clickCall = nil

		existCall(var0_15)
	end, SFX_PANEL)

	GetOrAddComponent(arg0_14._tf, "EventTriggerListener").enabled = false

	setActive(arg0_14.rtPointsContainer, false)
	pg.UIMgr.GetInstance():LoadingOn()

	local var0_14 = {}

	table.insert(var0_14, function(arg0_16)
		local var0_16 = arg0_14.ll:GetDisplayInfo()

		parallelAsync({
			function(arg0_17)
				pg.PoolMgr.GetInstance():GetPrefab("loveletteranim/loveletteranim", "", true, function(arg0_18)
					arg0_14.rtAnimation = arg0_18.transform

					arg0_17()
				end)
			end,
			function(arg0_19)
				LoadSpriteAtlasAsync("bg/" .. arg0_14.contextData.bg, "", function(arg0_20)
					arg0_14.spriteBg = arg0_20

					arg0_19()
				end)
			end,
			function(arg0_21)
				LoadSpriteAtlasAsync("loveletterstyleatlas/mail_" .. arg0_14.contextData.prefab, "", function(arg0_22)
					arg0_14.spriteMail = arg0_22

					arg0_21()
				end)
			end,
			function(arg0_23)
				LoadSpriteAtlasAsync("loveletterstyleatlas/" .. var0_16.hand, "", function(arg0_24)
					arg0_14.spriteHand = arg0_24

					arg0_23()
				end)
			end,
			function(arg0_25)
				LoadSpriteAtlasAsync("loveletterstyleatlas/" .. var0_16.kiss, "", function(arg0_26)
					arg0_14.spriteKiss = arg0_26

					arg0_25()
				end)
			end
		}, function()
			setParent(arg0_14.rtAnimation, arg0_14.rtAnim:Find("content"))
			setImageSprite(arg0_14.rtAnimation:Find("bg_root/bg"), arg0_14.spriteBg)
			setImageSprite(arg0_14.rtAnimation:Find("fx_letter_in/deco_letter/deco_letter_1"), arg0_14.spriteMail)
			setImageSprite(arg0_14.rtAnimation:Find("fx_letter_in/deco_letter/lip_01"), arg0_14.spriteKiss, true)
			setImageSprite(arg0_14.rtAnimation:Find("hand/hand_deco"), arg0_14.spriteHand, true)
			arg0_14.rtAnimation:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_28)
				local var0_28 = arg0_14.nextCall

				arg0_14.nextCall = nil

				existCall(var0_28, arg0_28)
			end)
			eachChild(arg0_14.rtAnimation:Find("letter_style/root"), function(arg0_29, arg1_29)
				setActive(arg0_29, arg0_29.name == arg0_14.contextData.prefab)

				if arg0_29.name == arg0_14.contextData.prefab then
					setText(arg0_29:Find("after/bg/paper_root/name"), arg0_14.ll:GetName())
					setText(arg0_29:Find("after/bg/paper_root/content"), getProxy(LoveLetterProxy):GetLoveLetterContent(arg0_14.contextData.letterId))
				end
			end)
			arg0_16()
		end)
	end)
	table.insert(var0_14, function(arg0_30)
		setPaintingPrefab(arg0_14.rtAnimation:Find("painting_root/paint"), arg0_14.ll:GetPainting(), "mainNormal", nil, nil, arg0_30)
	end)
	table.insert(var0_14, function(arg0_31)
		pg.UIMgr.GetInstance():LoadingOff()
		setActive(arg0_14.rtAnim, true)

		function arg0_14.nextCall()
			setActive(arg0_14.rtAnim:Find("click"), true)
		end

		arg0_14.clickCall = arg0_31

		setActive(arg0_14.rtAnim:Find("click"), false)
		quickPlayAnimation(arg0_14.rtAnimation, "anim_LoveLetterDisplayUI_fadein_01")
	end)
	table.insert(var0_14, function(arg0_33)
		setActive(arg0_14.rtAnim, true)

		function arg0_14.nextCall()
			setActive(arg0_14.rtAnim:Find("click"), true)
		end

		arg0_14.clickCall = arg0_33

		setActive(arg0_14.rtAnim:Find("click"), false)
		quickPlayAnimation(arg0_14.rtAnimation, "anim_LoveLetterDisplayUI_fadein_02")
	end)
	table.insert(var0_14, function(arg0_35)
		setActive(arg0_14.rtAnim, true)

		arg0_14.nextCall = arg0_35

		setActive(arg0_14.rtAnim:Find("click"), false)
		quickPlayAnimation(arg0_14.rtAnimation, "anim_LoveLetterDisplayUI_fadeout_01")
	end)
	seriesAsync(var0_14, function()
		setActive(arg0_14.rtAnim, false)
		setActive(arg0_14.rtPointsContainer, true)
		arg0_14:UpdateLetterDisplay(true)

		GetOrAddComponent(arg0_14._tf, "EventTriggerListener").enabled = true
	end)
end

function var0_0.UpdateLetterDisplay(arg0_37, arg1_37)
	setActive(arg0_37.rtStyle:Find("after"), arg1_37)
	setActive(arg0_37.rtStyle:Find("before"), not arg1_37)
	setButtonEnabled(arg0_37.rtStyle:Find("before"), not arg1_37)

	if not arg1_37 then
		setLoveLetterMedal(arg0_37.rtStyle:Find("before/medal"), setmetatable({
			level = table.indexof(pg.lover_letter_content.get_id_list_by_ship_group[arg0_37.ll.groupId], arg0_37.contextData.letterId)
		}, {
			__index = arg0_37.ll
		}))
	end
end

function var0_0.addRingDragListenter(arg0_38)
	local var0_38 = GetOrAddComponent(arg0_38._tf, "EventTriggerListener")
	local var1_38
	local var2_38 = 0
	local var3_38

	var0_38:AddBeginDragFunc(function()
		var2_38 = 0
		var1_38 = nil
	end)
	var0_38:AddDragFunc(function(arg0_40, arg1_40)
		local var0_40 = arg1_40.position

		if not var1_38 then
			var1_38 = var0_40
		end

		var2_38 = var0_40.x - var1_38.x
	end)
	var0_38:AddDragEndFunc(function(arg0_41, arg1_41)
		if arg0_38.isBlock then
			return
		end

		if var2_38 < -50 then
			arg0_38:ChangeLetter(1)
		elseif var2_38 > 50 then
			arg0_38:ChangeLetter(-1)
		end
	end)
end

function var0_0.willExit(arg0_42)
	if arg0_42.rtStyle then
		eachChild(arg0_42.rtStyle:Find("before/medal"), function(arg0_43, arg1_43)
			returnLoveLetterMedal(arg0_43)
		end)
		pg.PoolMgr.GetInstance():ReturnPrefab("LoveLetterStyle/" .. arg0_42.contextData.prefab, "", arg0_42.rtStyle.gameObject)

		arg0_42.rtStyle = nil
	end

	if arg0_42.rtAnimation then
		retPaintingPrefab(arg0_42.rtAnimation:Find("painting_root/paint"), arg0_42.ll:GetPainting(), "mainNormal")
		pg.PoolMgr.GetInstance():ReturnPrefab("loveletteranim/loveletteranim", "", arg0_42.rtAnimation.gameObject)

		arg0_42.rtAnimation = nil
	end
end

return var0_0

local var0_0 = class("AsideStoryPlayer", import(".StoryPlayer"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.hrzList = UIItemList.New(arg0_1.asidePanel:Find("aside"), arg0_1.asidePanel:Find("aside/aside_txt_tpl"))
	arg0_1.vetList = UIItemList.New(arg0_1.asidePanel:Find("aside_2"), arg0_1.asidePanel:Find("aside_2/aside_txt_tpl_2"))
	arg0_1.leftBotomVetList = UIItemList.New(arg0_1.asidePanel:Find("aside_3"), arg0_1.asidePanel:Find("aside_3/aside_txt_tpl"))
	arg0_1.centerWithFrameVetList = UIItemList.New(arg0_1.asidePanel:Find("aside_4"), arg0_1.asidePanel:Find("aside_4/aside_txt_tpl"))
	arg0_1.centerWithFrameVetListMargin = UIItemList.New(arg0_1.asidePanel:Find("aside_4_1"), arg0_1.asidePanel:Find("aside_4_1/aside_txt_tpl"))
	arg0_1.dataTxt = arg0_1.asidePanel:Find("aside_sign_date")
	arg0_1.meshImagePaintingContainer = arg0_1.asidePanel:Find("actor_middle")
end

function var0_0.OnReset(arg0_2, arg1_2, arg2_2, arg3_2)
	setActive(arg0_2.asidePanel, true)
	setActive(arg0_2.curtain, true)
	setActive(arg0_2.hrzList.container, false)
	setActive(arg0_2.vetList.container, false)
	setActive(arg0_2.leftBotomVetList.container, false)
	setActive(arg0_2.centerWithFrameVetList.container, false)
	setActive(arg0_2.centerWithFrameVetListMargin.container, false)
	setActive(arg0_2.actorPanel, false)

	arg0_2.curtainCg.alpha = 1

	setText(arg0_2.dataTxt, "")
	arg3_2()
end

function var0_0.OnInit(arg0_3, arg1_3, arg2_3, arg3_3)
	if arg1_3:ShouldHideBGAlpha() then
		arg0_3.color = arg0_3.mainImg.color
		arg0_3.mainImg.color = Color.New(1, 1, 1, 0)
	end

	local var0_3 = {
		function(arg0_4)
			arg0_3:LoadPainting(arg1_3, arg0_4)
		end,
		function(arg0_5)
			if arg1_3:GetShowMode() == AsideStep.SHOW_MODE_DEFAUT then
				arg0_3:PlayAside(arg1_3, arg0_5)
			else
				arg0_3:PlayBubbleAside(arg1_3, arg0_5)
			end
		end,
		function(arg0_6)
			arg0_3:PlayDateSign(arg1_3, arg0_6)
		end
	}

	seriesAsync(var0_3, arg3_3)
end

function var0_0.LoadPainting(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg1_7:GetPainting()

	if not var0_7 or var0_7 == "" then
		arg2_7()

		return
	end

	arg0_7.paitingName = var0_7

	setPaintingPrefabAsync(arg0_7.meshImagePaintingContainer, var0_7, "duihua", function(arg0_8)
		arg0_7.rtPaint = arg0_8

		if arg0_7.paitingName == nil then
			retPaintingPrefab(arg0_7.rtPaint, var0_7)

			return
		end

		arg2_7()
	end)
end

function var0_0.GetAsideList(arg0_9, arg1_9, arg2_9)
	local var0_9

	if arg1_9 == AsideStep.ASIDE_TYPE_HRZ then
		var0_9 = arg0_9.hrzList
	elseif arg1_9 == AsideStep.ASIDE_TYPE_VEC then
		var0_9 = arg0_9.vetList
	elseif arg1_9 == AsideStep.ASIDE_TYPE_LEFTBOTTOMVEC then
		var0_9 = arg0_9.leftBotomVetList
	elseif arg1_9 == AsideStep.ASIDE_TYPE_CENTERWITHFRAME then
		if arg2_9:ShouldUpdateMargin() then
			var0_9 = arg0_9.centerWithFrameVetListMargin
		else
			var0_9 = arg0_9.centerWithFrameVetList
		end
	end

	return var0_9
end

function var0_0.PlayAside(arg0_10, arg1_10, arg2_10)
	local var0_10 = {}
	local var1_10 = arg0_10:GetAsideList(arg1_10:GetAsideType(), arg1_10)

	arg0_10:UpdateLayoutPaddingAndSpacing(arg1_10, var1_10.container)

	local var2_10 = Mathf.Sign(var1_10.container.localScale.x)

	setActive(var1_10.container, true)

	local var3_10 = arg1_10:GetSequence()

	var1_10:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = var3_10[arg1_11 + 1]
			local var1_11 = HXSet.hxLan(var0_11[1])
			local var2_11 = var0_11[2]

			setText(arg2_11, var1_11)

			local var3_11 = GetOrAddComponent(arg2_11, typeof(CanvasGroup))

			var3_11.alpha = 0

			table.insert(var0_10, function(arg0_12)
				arg0_10:TweenValueForcanvasGroup(var3_11, 0, 1, arg1_10.sequenceSpd or 1, var2_11, arg0_12)
			end)

			if var2_10 ~= Mathf.Sign(arg2_11.localScale.x) then
				arg2_11.localScale = Vector3(var2_10 * arg2_11.localScale.x, arg2_11.localScale.y, 1)
			end
		end
	end)
	var1_10:align(#var3_10)
	parallelAsync(var0_10, arg2_10)
end

function var0_0.PlayBubbleAside(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13:GetAsideList(arg1_13:GetAsideType(), arg1_13)

	arg0_13:UpdateLayoutPaddingAndSpacing(arg1_13, var0_13.container)

	local var1_13 = Mathf.Sign(var0_13.container.localScale.x)
	local var2_13 = arg1_13:GetSequence()

	setActive(var0_13.container, true)

	for iter0_13 = var0_13.container.childCount, 1, -1 do
		local var3_13 = var0_13.container:GetChild(iter0_13 - 1)

		if var3_13 ~= var0_13.item then
			Object.Destroy(var3_13.gameObject)
		end
	end

	local var4_13 = {}
	local var5_13 = 0

	for iter1_13 = 1, #var2_13 do
		table.insert(var4_13, function(arg0_14)
			local var0_14 = cloneTplTo(var0_13.item, var0_13.container, iter1_13)

			setText(var0_14, HXSet.hxLan(var2_13[iter1_13][1]))

			local var1_14 = GetOrAddComponent(var0_14, typeof(Typewriter))

			function var1_14.endFunc()
				arg0_14()
			end

			var1_14:setSpeed(arg1_13:GetTypewriterSpeed())
			var1_14:Play()
		end)
	end

	seriesAsync(var4_13, arg2_13)
end

function var0_0.UpdateLayoutPaddingAndSpacing(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg1_16:ShouldUpdateSpacing()
	local var1_16 = arg1_16:ShouldUpdatePadding()
	local var2_16 = arg1_16:ShouldUpdateMargin()

	if (var0_16 or var1_16) and not var2_16 then
		local var3_16 = arg2_16:GetComponent(typeof(UnityEngine.UI.HorizontalOrVerticalLayoutGroup))

		if var0_16 then
			var3_16.spacing, arg0_16.spacing = arg1_16:GetSpacing(), var3_16.spacing
		end

		if var1_16 then
			local var4_16, var5_16, var6_16, var7_16 = arg1_16:GetPadding()
			local var8_16 = UnityEngine.RectOffset.New()

			var8_16.bottom = var5_16
			var8_16.left = var6_16
			var8_16.right = var7_16
			var8_16.top = var4_16
			arg0_16.padding = var3_16.padding
			var3_16.padding = var8_16
		end
	elseif var2_16 then
		local var9_16 = 0
		local var10_16 = arg2_16:GetComponent(typeof(UnityEngine.UI.HorizontalOrVerticalLayoutGroup))

		if var0_16 then
			var9_16 = arg1_16:GetSpacing()
		end

		var10_16.spacing = var9_16

		local var11_16, var12_16, var13_16, var14_16 = arg1_16:GetMargin()
		local var15_16 = rtf(arg2_16)

		var15_16.offsetMin = Vector2(var13_16, var12_16)
		var15_16.offsetMax = Vector2(-var14_16, -var11_16)

		eachChild(arg2_16, function(arg0_17)
			GetOrAddComponent(arg0_17, typeof(LayoutElement)).preferredWidth = var15_16.rect.width - 50
		end)
	end

	arg0_16:UpdateRectAlhpa(arg1_16, arg2_16)
end

function var0_0.UpdateRectAlhpa(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg2_18:GetComponent(typeof(Image))

	if not var0_18 then
		return
	end

	local var1_18 = arg1_18:GetRectAlpha()

	var0_18.color = Color.New(1, 1, 1, var1_18)
end

function var0_0.PlayDateSign(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg1_19:GetDateSign()

	if not var0_19 then
		arg2_19()

		return
	end

	local var1_19 = HXSet.hxLan(var0_19[1])
	local var2_19 = var0_19[2]
	local var3_19 = var0_19[3] or {}

	setText(arg0_19.dataTxt, var1_19)

	local var4_19 = GetOrAddComponent(arg0_19.dataTxt, typeof(CanvasGroup))

	var4_19.alpha = 0

	arg0_19:TweenValueForcanvasGroup(var4_19, 1, 0, arg1_19.sequenceSpd or 1, var2_19, arg2_19)
	setAnchoredPosition(arg0_19.dataTxt, Vector3(var3_19[1], var3_19[2], 0))
end

function var0_0.OnWillClear(arg0_20, arg1_20, arg2_20, arg3_20)
	if arg0_20.color then
		arg0_20.mainImg.color = arg0_20.color
	end

	arg0_20.color = nil

	if arg0_20.padding or arg0_20.spacing then
		local var0_20 = arg0_20:GetAsideList(arg1_20:GetAsideType(), arg1_20)

		arg0_20:ResetPaddingAndSpacing(var0_20.container, arg0_20.padding, arg0_20.spacing)
	end

	arg0_20.padding = nil
	arg0_20.spacing = nil

	if arg0_20.paitingName and arg0_20.rtPaint then
		retPaintingPrefab(arg0_20.meshImagePaintingContainer, arg0_20.paitingName)
	end

	arg0_20.paitingName = nil
	arg0_20.rtPaint = nil
end

function var0_0.ResetPaddingAndSpacing(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21 = arg1_21:GetComponent(typeof(UnityEngine.UI.HorizontalOrVerticalLayoutGroup))

	if arg2_21 then
		var0_21.padding = arg2_21
	end

	if arg3_21 then
		var0_21.spacing = arg3_21
	end
end

function var0_0.OnEnd(arg0_22)
	return
end

return var0_0

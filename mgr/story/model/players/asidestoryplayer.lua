local var0_0 = class("AsideStoryPlayer", import(".StoryPlayer"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.hrzList = UIItemList.New(arg0_1:findTF("aside", arg0_1.asidePanel), arg0_1:findTF("aside/aside_txt_tpl", arg0_1.asidePanel))
	arg0_1.vetList = UIItemList.New(arg0_1:findTF("aside_2", arg0_1.asidePanel), arg0_1:findTF("aside_2/aside_txt_tpl_2", arg0_1.asidePanel))
	arg0_1.leftBotomVetList = UIItemList.New(arg0_1:findTF("aside_3", arg0_1.asidePanel), arg0_1:findTF("aside_3/aside_txt_tpl", arg0_1.asidePanel))
	arg0_1.centerWithFrameVetList = UIItemList.New(arg0_1:findTF("aside_4", arg0_1.asidePanel), arg0_1:findTF("aside_4/aside_txt_tpl", arg0_1.asidePanel))
	arg0_1.dataTxt = arg0_1:findTF("aside_sign_date", arg0_1.asidePanel)
end

function var0_0.OnReset(arg0_2, arg1_2, arg2_2, arg3_2)
	setActive(arg0_2.asidePanel, true)
	setActive(arg0_2.curtain, true)
	setActive(arg0_2.hrzList.container, false)
	setActive(arg0_2.vetList.container, false)
	setActive(arg0_2.leftBotomVetList.container, false)
	setActive(arg0_2.centerWithFrameVetList.container, false)
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
			if arg1_3:GetShowMode() == AsideStep.SHOW_MODE_DEFAUT then
				arg0_3:PlayAside(arg1_3, arg0_4)
			else
				arg0_3:PlayBubbleAside(arg1_3, arg0_4)
			end
		end,
		function(arg0_5)
			arg0_3:PlayDateSign(arg1_3, arg0_5)
		end
	}

	parallelAsync(var0_3, arg3_3)
end

function var0_0.GetAsideList(arg0_6, arg1_6)
	local var0_6

	if arg1_6 == AsideStep.ASIDE_TYPE_HRZ then
		var0_6 = arg0_6.hrzList
	elseif arg1_6 == AsideStep.ASIDE_TYPE_VEC then
		var0_6 = arg0_6.vetList
	elseif arg1_6 == AsideStep.ASIDE_TYPE_LEFTBOTTOMVEC then
		var0_6 = arg0_6.leftBotomVetList
	elseif arg1_6 == AsideStep.ASIDE_TYPE_CENTERWITHFRAME then
		var0_6 = arg0_6.centerWithFrameVetList
	end

	return var0_6
end

function var0_0.PlayAside(arg0_7, arg1_7, arg2_7)
	local var0_7 = {}
	local var1_7 = arg0_7:GetAsideList(arg1_7:GetAsideType())

	arg0_7:UpdateLayoutPaddingAndSpacing(arg1_7, var1_7.container)

	local var2_7 = Mathf.Sign(var1_7.container.localScale.x)

	setActive(var1_7.container, true)

	local var3_7 = arg1_7:GetSequence()

	var1_7:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = var3_7[arg1_8 + 1]
			local var1_8 = HXSet.hxLan(var0_8[1])
			local var2_8 = var0_8[2]

			setText(arg2_8, var1_8)

			local var3_8 = GetOrAddComponent(arg2_8, typeof(CanvasGroup))

			var3_8.alpha = 0

			table.insert(var0_7, function(arg0_9)
				arg0_7:TweenValueForcanvasGroup(var3_8, 0, 1, arg1_7.sequenceSpd or 1, var2_8, arg0_9)
			end)

			if var2_7 ~= Mathf.Sign(arg2_8.localScale.x) then
				arg2_8.localScale = Vector3(var2_7 * arg2_8.localScale.x, arg2_8.localScale.y, 1)
			end
		end
	end)
	var1_7:align(#var3_7)
	parallelAsync(var0_7, arg2_7)
end

function var0_0.PlayBubbleAside(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10:GetAsideList(arg1_10:GetAsideType())

	arg0_10:UpdateLayoutPaddingAndSpacing(arg1_10, var0_10.container)

	local var1_10 = Mathf.Sign(var0_10.container.localScale.x)
	local var2_10 = arg1_10:GetSequence()

	setActive(var0_10.container, true)

	for iter0_10 = var0_10.container.childCount, 1, -1 do
		local var3_10 = var0_10.container:GetChild(iter0_10 - 1)

		if var3_10 ~= var0_10.item then
			Object.Destroy(var3_10.gameObject)
		end
	end

	local var4_10 = {}
	local var5_10 = 0

	for iter1_10 = 1, #var2_10 do
		table.insert(var4_10, function(arg0_11)
			local var0_11 = cloneTplTo(var0_10.item, var0_10.container, iter1_10)

			setText(var0_11, var2_10[iter1_10][1])

			local var1_11 = GetOrAddComponent(var0_11, typeof(Typewriter))

			function var1_11.endFunc()
				arg0_11()
			end

			var1_11:setSpeed(arg1_10:GetTypewriterSpeed())
			var1_11:Play()
		end)
	end

	seriesAsync(var4_10, arg2_10)
end

function var0_0.UpdateLayoutPaddingAndSpacing(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg1_13:ShouldUpdateSpacing()
	local var1_13 = arg1_13:ShouldUpdatePadding()

	if var0_13 or var1_13 then
		local var2_13 = arg2_13:GetComponent(typeof(UnityEngine.UI.HorizontalOrVerticalLayoutGroup))

		if var0_13 then
			var2_13.spacing, arg0_13.spacing = arg1_13:GetSpacing(), var2_13.spacing
		end

		if var1_13 then
			local var3_13, var4_13, var5_13, var6_13 = arg1_13:GetPadding()
			local var7_13 = UnityEngine.RectOffset.New()

			var7_13.bottom = var4_13
			var7_13.left = var5_13
			var7_13.right = var6_13
			var7_13.top = var3_13
			arg0_13.padding = var2_13.padding
			var2_13.padding = var7_13
		end
	end
end

function var0_0.PlayDateSign(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg1_14:GetDateSign()

	if not var0_14 then
		arg2_14()

		return
	end

	local var1_14 = HXSet.hxLan(var0_14[1])
	local var2_14 = var0_14[2]
	local var3_14 = var0_14[3] or {}

	setText(arg0_14.dataTxt, var1_14)

	local var4_14 = GetOrAddComponent(arg0_14.dataTxt, typeof(CanvasGroup))

	var4_14.alpha = 0

	arg0_14:TweenValueForcanvasGroup(var4_14, 1, 0, arg1_14.sequenceSpd or 1, var2_14, arg2_14)
	setAnchoredPosition(arg0_14.dataTxt, Vector3(var3_14[1], var3_14[2], 0))
end

function var0_0.OnWillClear(arg0_15, arg1_15, arg2_15, arg3_15)
	if arg0_15.color then
		arg0_15.mainImg.color = arg0_15.color
	end

	arg0_15.color = nil

	if arg0_15.padding or arg0_15.spacing then
		local var0_15 = arg0_15:GetAsideList(arg1_15:GetAsideType())

		arg0_15:ResetPaddingAndSpacing(var0_15.container, arg0_15.padding, arg0_15.spacing)
	end

	arg0_15.padding = nil
	arg0_15.spacing = nil
end

function var0_0.ResetPaddingAndSpacing(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = arg1_16:GetComponent(typeof(UnityEngine.UI.HorizontalOrVerticalLayoutGroup))

	if arg2_16 then
		var0_16.padding = arg2_16
	end

	if arg3_16 then
		var0_16.spacing = arg3_16
	end
end

function var0_0.OnEnd(arg0_17)
	return
end

return var0_0

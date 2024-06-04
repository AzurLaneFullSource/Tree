local var0 = class("AsideStoryPlayer", import(".StoryPlayer"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.hrzList = UIItemList.New(arg0:findTF("aside", arg0.asidePanel), arg0:findTF("aside/aside_txt_tpl", arg0.asidePanel))
	arg0.vetList = UIItemList.New(arg0:findTF("aside_2", arg0.asidePanel), arg0:findTF("aside_2/aside_txt_tpl_2", arg0.asidePanel))
	arg0.leftBotomVetList = UIItemList.New(arg0:findTF("aside_3", arg0.asidePanel), arg0:findTF("aside_3/aside_txt_tpl", arg0.asidePanel))
	arg0.centerWithFrameVetList = UIItemList.New(arg0:findTF("aside_4", arg0.asidePanel), arg0:findTF("aside_4/aside_txt_tpl", arg0.asidePanel))
	arg0.dataTxt = arg0:findTF("aside_sign_date", arg0.asidePanel)
end

function var0.OnReset(arg0, arg1, arg2, arg3)
	setActive(arg0.asidePanel, true)
	setActive(arg0.curtain, true)
	setActive(arg0.hrzList.container, false)
	setActive(arg0.vetList.container, false)
	setActive(arg0.leftBotomVetList.container, false)
	setActive(arg0.centerWithFrameVetList.container, false)
	setActive(arg0.actorPanel, false)

	arg0.curtainCg.alpha = 1

	setText(arg0.dataTxt, "")
	arg3()
end

function var0.OnInit(arg0, arg1, arg2, arg3)
	if arg1:ShouldHideBGAlpha() then
		arg0.color = arg0.mainImg.color
		arg0.mainImg.color = Color.New(1, 1, 1, 0)
	end

	local var0 = {
		function(arg0)
			if arg1:GetShowMode() == AsideStep.SHOW_MODE_DEFAUT then
				arg0:PlayAside(arg1, arg0)
			else
				arg0:PlayBubbleAside(arg1, arg0)
			end
		end,
		function(arg0)
			arg0:PlayDateSign(arg1, arg0)
		end
	}

	parallelAsync(var0, arg3)
end

function var0.GetAsideList(arg0, arg1)
	local var0

	if arg1 == AsideStep.ASIDE_TYPE_HRZ then
		var0 = arg0.hrzList
	elseif arg1 == AsideStep.ASIDE_TYPE_VEC then
		var0 = arg0.vetList
	elseif arg1 == AsideStep.ASIDE_TYPE_LEFTBOTTOMVEC then
		var0 = arg0.leftBotomVetList
	elseif arg1 == AsideStep.ASIDE_TYPE_CENTERWITHFRAME then
		var0 = arg0.centerWithFrameVetList
	end

	return var0
end

function var0.PlayAside(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg0:GetAsideList(arg1:GetAsideType())

	arg0:UpdateLayoutPaddingAndSpacing(arg1, var1.container)

	local var2 = Mathf.Sign(var1.container.localScale.x)

	setActive(var1.container, true)

	local var3 = arg1:GetSequence()

	var1:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var3[arg1 + 1]
			local var1 = HXSet.hxLan(var0[1])
			local var2 = var0[2]

			setText(arg2, var1)

			local var3 = GetOrAddComponent(arg2, typeof(CanvasGroup))

			var3.alpha = 0

			table.insert(var0, function(arg0)
				arg0:TweenValueForcanvasGroup(var3, 0, 1, arg1.sequenceSpd or 1, var2, arg0)
			end)

			if var2 ~= Mathf.Sign(arg2.localScale.x) then
				arg2.localScale = Vector3(var2 * arg2.localScale.x, arg2.localScale.y, 1)
			end
		end
	end)
	var1:align(#var3)
	parallelAsync(var0, arg2)
end

function var0.PlayBubbleAside(arg0, arg1, arg2)
	local var0 = arg0:GetAsideList(arg1:GetAsideType())

	arg0:UpdateLayoutPaddingAndSpacing(arg1, var0.container)

	local var1 = Mathf.Sign(var0.container.localScale.x)
	local var2 = arg1:GetSequence()

	setActive(var0.container, true)

	for iter0 = var0.container.childCount, 1, -1 do
		local var3 = var0.container:GetChild(iter0 - 1)

		if var3 ~= var0.item then
			Object.Destroy(var3.gameObject)
		end
	end

	local var4 = {}
	local var5 = 0

	for iter1 = 1, #var2 do
		table.insert(var4, function(arg0)
			local var0 = cloneTplTo(var0.item, var0.container, iter1)

			setText(var0, var2[iter1][1])

			local var1 = GetOrAddComponent(var0, typeof(Typewriter))

			function var1.endFunc()
				arg0()
			end

			var1:setSpeed(arg1:GetTypewriterSpeed())
			var1:Play()
		end)
	end

	seriesAsync(var4, arg2)
end

function var0.UpdateLayoutPaddingAndSpacing(arg0, arg1, arg2)
	local var0 = arg1:ShouldUpdateSpacing()
	local var1 = arg1:ShouldUpdatePadding()

	if var0 or var1 then
		local var2 = arg2:GetComponent(typeof(UnityEngine.UI.HorizontalOrVerticalLayoutGroup))

		if var0 then
			var2.spacing, arg0.spacing = arg1:GetSpacing(), var2.spacing
		end

		if var1 then
			local var3, var4, var5, var6 = arg1:GetPadding()
			local var7 = UnityEngine.RectOffset.New()

			var7.bottom = var4
			var7.left = var5
			var7.right = var6
			var7.top = var3
			arg0.padding = var2.padding
			var2.padding = var7
		end
	end
end

function var0.PlayDateSign(arg0, arg1, arg2)
	local var0 = arg1:GetDateSign()

	if not var0 then
		arg2()

		return
	end

	local var1 = HXSet.hxLan(var0[1])
	local var2 = var0[2]
	local var3 = var0[3] or {}

	setText(arg0.dataTxt, var1)

	local var4 = GetOrAddComponent(arg0.dataTxt, typeof(CanvasGroup))

	var4.alpha = 0

	arg0:TweenValueForcanvasGroup(var4, 1, 0, arg1.sequenceSpd or 1, var2, arg2)
	setAnchoredPosition(arg0.dataTxt, Vector3(var3[1], var3[2], 0))
end

function var0.OnWillClear(arg0, arg1, arg2, arg3)
	if arg0.color then
		arg0.mainImg.color = arg0.color
	end

	arg0.color = nil

	if arg0.padding or arg0.spacing then
		local var0 = arg0:GetAsideList(arg1:GetAsideType())

		arg0:ResetPaddingAndSpacing(var0.container, arg0.padding, arg0.spacing)
	end

	arg0.padding = nil
	arg0.spacing = nil
end

function var0.ResetPaddingAndSpacing(arg0, arg1, arg2, arg3)
	local var0 = arg1:GetComponent(typeof(UnityEngine.UI.HorizontalOrVerticalLayoutGroup))

	if arg2 then
		var0.padding = arg2
	end

	if arg3 then
		var0.spacing = arg3
	end
end

function var0.OnEnd(arg0)
	return
end

return var0

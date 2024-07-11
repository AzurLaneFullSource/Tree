local var0_0 = class("CastStoryPlayer", import(".StoryPlayer"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.tpls = {
		arg0_1._tf:Find("resource/text_tpl"),
		arg0_1._tf:Find("resource/image_tpl"),
		arg0_1._tf:Find("resource/list_tpl"),
		arg0_1._tf:Find("resource/cast_tpl")
	}
	arg0_1.layoutContainer = arg0_1.castPanel:Find("Image")
end

function var0_0.OnReset(arg0_2, arg1_2, arg2_2, arg3_2)
	setActive(arg0_2.castPanel, true)
	setAnchoredPosition(arg0_2.layoutContainer, {
		x = 0,
		y = 0
	})
	arg3_2()
end

function var0_0.OnEnter(arg0_3, arg1_3, arg2_3, arg3_3)
	seriesAsync({
		function(arg0_4)
			arg0_3:SetLayout(arg1_3, arg0_4)
		end,
		function(arg0_5)
			onNextTick(arg0_5)
		end,
		function(arg0_6)
			arg0_3:StartAnimation(arg1_3, arg0_6)
		end
	}, arg3_3)
end

function var0_0.SetLayout(arg0_7, arg1_7, arg2_7)
	removeAllChildren(arg0_7.layoutContainer)

	local var0_7 = arg1_7:GetSpacing()

	arg0_7.layoutContainer:GetComponent(typeof(VerticalLayoutGroup)).spacing = var0_7

	local var1_7 = arg1_7:GetLayout()

	for iter0_7, iter1_7 in pairs(var1_7) do
		local var2_7 = arg0_7.tpls[iter1_7.type]
		local var3_7 = cloneTplTo(var2_7, arg0_7.layoutContainer)
		local var4_7 = "InitLayoutForType" .. iter1_7.type

		assert(arg0_7[var4_7], "need function >>>" .. var4_7)
		arg0_7[var4_7](arg0_7, var3_7, iter1_7)
	end

	arg2_7()
end

function var0_0.InitLayoutForType1(arg0_8, arg1_8, arg2_8)
	setText(arg1_8, arg2_8.text)
end

function var0_0.InitLayoutForType2(arg0_9, arg1_9, arg2_9)
	local var0_9 = LoadSprite("bg/" .. arg2_9.path)
	local var1_9 = arg1_9:Find("image"):GetComponent(typeof(Image))
	local var2_9 = arg1_9:GetComponent(typeof(LayoutElement))

	var1_9.sprite = var0_9

	if arg2_9.size == Vector2.zero then
		var1_9:SetNativeSize()

		var2_9.preferredHeight = var1_9.gameObject.transform.sizeDelta.y
	else
		var1_9.gameObject.transform.sizeDelta = arg2_9.size
		var2_9.preferredHeight = arg2_9.size.y
	end
end

function var0_0.InitLayoutForType3(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg2_10.names
	local var1_10 = arg2_10.column
	local var2_10 = arg1_10:GetComponent(typeof(GridLayoutGroup))

	var2_10.constraintCount = var1_10

	local var3_10 = var2_10.spacing.x
	local var4_10 = 1920 / var1_10 - var3_10 * (var1_10 - 1)

	var2_10.cellSize = Vector2(var4_10, 30)

	local var5_10 = var1_10 % 2 ~= 0
	local var6_10 = UIItemList.New(arg1_10, arg1_10:Find("1"))

	var6_10:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = arg2_11:GetComponent(typeof(Text))
			local var1_11 = COLOR_WHITE

			if var5_10 then
				var0_11.alignment = TextAnchor.MiddleCenter
			else
				local var2_11 = arg1_11 % 2 == 0

				var0_11.alignment = var2_11 and TextAnchor.MiddleRight or TextAnchor.MiddleLeft

				if var2_11 then
					var1_11 = arg2_10.evenColumnColor
				end
			end

			var0_11.text = setColorStr(var0_10[arg1_11 + 1], var1_11)
		end
	end)
	var6_10:align(#var0_10)
end

function var0_0.InitLayoutForType4(arg0_12, arg1_12, arg2_12)
	return
end

function var0_0.StartAnimation(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg1_13:GetPlayTime()

	arg0_13:PlayAnimation(var0_13, arg2_13)
	onButton(arg0_13, arg0_13._tf, function()
		removeOnButton(arg0_13._tf)
		arg0_13:SpeedUp(var0_13, arg2_13)
	end, SFX_PANEL)
end

function var0_0.PlayAnimation(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.castPanel.rect.height + arg0_15.layoutContainer.sizeDelta.y
	local var1_15 = getAnchoredPosition(arg0_15.layoutContainer).y

	arg0_15:TweenValue(arg0_15.layoutContainer, var1_15, var0_15, arg1_15, 0, function(arg0_16)
		setAnchoredPosition(arg0_15.layoutContainer, {
			y = arg0_16
		})
	end, function()
		removeOnButton(arg0_15._tf)
		arg2_15()
	end)
end

function var0_0.SpeedUp(arg0_18, arg1_18, arg2_18)
	arg0_18:CancelTween(arg0_18.layoutContainer)
	arg0_18:PlayAnimation(arg1_18 * 0.2, arg2_18)
end

function var0_0.RegisetEvent(arg0_19, arg1_19, arg2_19)
	var0_0.super.RegisetEvent(arg0_19, arg1_19, arg2_19)
	triggerButton(arg0_19._go)
end

return var0_0

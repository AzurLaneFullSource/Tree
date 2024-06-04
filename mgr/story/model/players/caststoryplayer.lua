local var0 = class("CastStoryPlayer", import(".StoryPlayer"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.tpls = {
		arg0._tf:Find("resource/text_tpl"),
		arg0._tf:Find("resource/image_tpl"),
		arg0._tf:Find("resource/list_tpl"),
		arg0._tf:Find("resource/cast_tpl")
	}
	arg0.layoutContainer = arg0.castPanel:Find("Image")
end

function var0.OnReset(arg0, arg1, arg2, arg3)
	setActive(arg0.castPanel, true)
	setAnchoredPosition(arg0.layoutContainer, {
		x = 0,
		y = 0
	})
	arg3()
end

function var0.OnEnter(arg0, arg1, arg2, arg3)
	seriesAsync({
		function(arg0)
			arg0:SetLayout(arg1, arg0)
		end,
		function(arg0)
			onNextTick(arg0)
		end,
		function(arg0)
			arg0:StartAnimation(arg1, arg0)
		end
	}, arg3)
end

function var0.SetLayout(arg0, arg1, arg2)
	removeAllChildren(arg0.layoutContainer)

	local var0 = arg1:GetSpacing()

	arg0.layoutContainer:GetComponent(typeof(VerticalLayoutGroup)).spacing = var0

	local var1 = arg1:GetLayout()

	for iter0, iter1 in pairs(var1) do
		local var2 = arg0.tpls[iter1.type]
		local var3 = cloneTplTo(var2, arg0.layoutContainer)
		local var4 = "InitLayoutForType" .. iter1.type

		assert(arg0[var4], "need function >>>" .. var4)
		arg0[var4](arg0, var3, iter1)
	end

	arg2()
end

function var0.InitLayoutForType1(arg0, arg1, arg2)
	setText(arg1, arg2.text)
end

function var0.InitLayoutForType2(arg0, arg1, arg2)
	local var0 = LoadSprite("bg/" .. arg2.path)
	local var1 = arg1:Find("image"):GetComponent(typeof(Image))
	local var2 = arg1:GetComponent(typeof(LayoutElement))

	var1.sprite = var0

	if arg2.size == Vector2.zero then
		var1:SetNativeSize()

		var2.preferredHeight = var1.gameObject.transform.sizeDelta.y
	else
		var1.gameObject.transform.sizeDelta = arg2.size
		var2.preferredHeight = arg2.size.y
	end
end

function var0.InitLayoutForType3(arg0, arg1, arg2)
	local var0 = arg2.names
	local var1 = arg2.column
	local var2 = arg1:GetComponent(typeof(GridLayoutGroup))

	var2.constraintCount = var1

	local var3 = var2.spacing.x
	local var4 = 1920 / var1 - var3 * (var1 - 1)

	var2.cellSize = Vector2(var4, 30)

	local var5 = var1 % 2 ~= 0
	local var6 = UIItemList.New(arg1, arg1:Find("1"))

	var6:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg2:GetComponent(typeof(Text))
			local var1 = COLOR_WHITE

			if var5 then
				var0.alignment = TextAnchor.MiddleCenter
			else
				local var2 = arg1 % 2 == 0

				var0.alignment = var2 and TextAnchor.MiddleRight or TextAnchor.MiddleLeft

				if var2 then
					var1 = arg2.evenColumnColor
				end
			end

			var0.text = setColorStr(var0[arg1 + 1], var1)
		end
	end)
	var6:align(#var0)
end

function var0.InitLayoutForType4(arg0, arg1, arg2)
	return
end

function var0.StartAnimation(arg0, arg1, arg2)
	local var0 = arg1:GetPlayTime()

	arg0:PlayAnimation(var0, arg2)
	onButton(arg0, arg0._tf, function()
		removeOnButton(arg0._tf)
		arg0:SpeedUp(var0, arg2)
	end, SFX_PANEL)
end

function var0.PlayAnimation(arg0, arg1, arg2)
	local var0 = arg0.castPanel.rect.height + arg0.layoutContainer.sizeDelta.y
	local var1 = getAnchoredPosition(arg0.layoutContainer).y

	arg0:TweenValue(arg0.layoutContainer, var1, var0, arg1, 0, function(arg0)
		setAnchoredPosition(arg0.layoutContainer, {
			y = arg0
		})
	end, function()
		removeOnButton(arg0._tf)
		arg2()
	end)
end

function var0.SpeedUp(arg0, arg1, arg2)
	arg0:CancelTween(arg0.layoutContainer)
	arg0:PlayAnimation(arg1 * 0.2, arg2)
end

function var0.RegisetEvent(arg0, arg1)
	var0.super.RegisetEvent(arg0, arg1)
	triggerButton(arg0._go)
end

return var0

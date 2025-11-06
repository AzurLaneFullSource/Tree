local var0_0 = class("IslandChatBubblePlayer", import("Mgr.Story.model.animation.StoryAnimtion"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.tpl = arg1_1
	arg0_1.role = arg2_1
	arg0_1.contentTr = arg0_1.tpl.transform:Find("content")
	arg0_1.emojiContainer = arg0_1.tpl.transform:Find("face")
	arg0_1.expressionContainer = arg0_1.tpl.transform:Find("expression")
	arg0_1.contentTxt = arg0_1.contentTr:Find("Text"):GetComponent("RichText")
	arg0_1.isPlaying = false
	arg0_1.canShowFlag = true
end

function var0_0.Play(arg0_2, arg1_2, arg2_2)
	arg0_2:Stop()

	arg0_2.canShowFlag = true
	arg0_2.isPlaying = true

	seriesAsync({
		function(arg0_3)
			arg0_2:ClearEmojiAndExpressionEmoji()
			arg0_2:ShowOrHide(true)
			arg0_2:UpdateBubble(arg1_2, arg0_3)
		end,
		function(arg0_4)
			arg0_2:WaitForNextOne(arg1_2, arg0_4)
		end,
		function(arg0_5)
			arg0_2:EneAction(arg1_2)

			arg0_2.isPlaying = false
			arg0_2.canShowFlag = false

			arg0_5()
		end
	}, arg2_2)
end

function var0_0.UpdateBubble(arg0_6, arg1_6, arg2_6)
	arg0_6:PlayCharatorAnimation(arg1_6)

	local var0_6 = arg1_6:ExistEmoji()
	local var1_6 = arg1_6:GetEmojiType()

	setActive(arg0_6.contentTr, not var0_6)
	setActive(arg0_6.emojiContainer, var0_6 and var1_6 == BubbleStep.EMOJI_TYPE_CHAT)
	setActive(arg0_6.expressionContainer, var0_6 and var1_6 == BubbleStep.EMOJI_TYPE_EXPRESSION)

	if var0_6 then
		arg0_6:UpdateEmoji(arg1_6, arg2_6)
	else
		arg0_6:UpdateContent(arg1_6, arg2_6)
	end
end

function var0_0.UpdateContent(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg1_7:GetSay()

	if var0_7 == "" then
		if arg2_7 then
			arg2_7()
		end

		return
	end

	arg0_7.contentTxt.text = arg0_7:GetContent(arg0_7.contentTr, var0_7)

	arg2_7()
end

function var0_0.GetContent(arg0_8, arg1_8, arg2_8)
	local var0_8 = tf(arg1_8):Find("Text"):GetComponent("RichText")

	var0_8.supportRichText = false

	eachChild(tf(arg1_8):Find("Text"), function(arg0_9)
		Destroy(arg0_9)
	end)

	local var1_8 = string.gmatch(arg2_8, ChatConst.EmojiIconCodeMatch)
	local var2_8 = false

	for iter0_8 in var1_8 do
		if table.contains(pg.emoji_small_template.all, tonumber(iter0_8)) then
			local var3_8 = true
			local var4_8 = pg.emoji_small_template[tonumber(iter0_8)]
			local var5_8 = LoadSprite("emoji/" .. var4_8.pic .. "_small", nil)

			var0_8:AddSprite(iter0_8, var5_8)
		end
	end

	local var6_8 = arg2_8

	return (string.gsub(var6_8, ChatConst.EmojiIconCodeMatch, function(arg0_10)
		if table.contains(pg.emoji_small_template.all, tonumber(arg0_10)) then
			return string.format("<icon name=%s w=1 h=1/>", arg0_10)
		end
	end))
end

function var0_0.UpdateEmoji(arg0_11, arg1_11, arg2_11)
	arg0_11:ClearEmojiAndExpressionEmoji()

	local var0_11, var1_11 = arg1_11:GetEmoji()

	if var1_11 == BubbleStep.EMOJI_TYPE_CHAT then
		arg0_11:UpdateChatTypeEmoji(var0_11, arg2_11)
	elseif var1_11 == BubbleStep.EMOJI_TYPE_EXPRESSION then
		arg0_11:UpdateExpressionTypeEmoji(var0_11, arg2_11)
	end
end

function var0_0.UpdateChatTypeEmoji(arg0_12, arg1_12, arg2_12)
	local var0_12 = pg.emoji_template[arg1_12]

	PoolMgr.GetInstance():GetPrefab("emoji/" .. var0_12.pic, var0_12.pic, true, function(arg0_13)
		local var0_13 = arg0_13:GetComponent("Animator")

		if var0_13 then
			var0_13.enabled = true
		end

		setParent(arg0_13, arg0_12.emojiContainer, false)

		if arg0_13:GetComponent(typeof(CriManaEffectUI)) or var0_13 then
			arg0_13.transform.localScale = Vector3(0.72, 0.72, 1)
		else
			arg0_13.transform.localScale = Vector3(0.72, 0.72, 1)
		end

		setAnchoredPosition3D(arg0_13, Vector3(0, 9, 0))

		if arg0_13:GetComponent(typeof(Image)) then
			local var1_13 = GetOrAddComponent(arg0_13, typeof(Outline))

			var1_13.effectColor = Color.NewHex("707275")
			var1_13.effectDistance = Vector2(2, -2)
		end

		arg0_12.emojiGo = arg0_13
		arg0_12.template = var0_12

		arg2_12()
	end)
end

function var0_0.ClearExpressionEmoji(arg0_14)
	if arg0_14.expressionTr then
		Object.Destroy(arg0_14.expressionTr)

		arg0_14.expressionTr = nil
	end
end

function var0_0.UpdateExpressionTypeEmoji(arg0_15, arg1_15, arg2_15)
	ResourceMgr.Inst:getAssetAsync("Island/emoji/" .. arg1_15, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_16)
		local var0_16 = Object.Instantiate(arg0_16)

		setParent(var0_16, arg0_15.expressionContainer, false)
		setAnchoredPosition3D(var0_16, Vector3(0, 9, 0))

		arg0_15.expressionTr = var0_16

		arg2_15()
	end), true, true)
end

function var0_0.ClearEmoji(arg0_17)
	if arg0_17.emojiGo and arg0_17.template then
		arg0_17.emojiGo.transform.localPosition = Vector3(0, 0, 0)
		arg0_17.emojiGo.transform.localScale = Vector3(1, 1, 1)

		local var0_17 = GetOrAddComponent(arg0_17.emojiGo, typeof(Outline))

		if var0_17 then
			Object.Destroy(var0_17)
		end

		PoolMgr.GetInstance():ReturnPrefab("emoji/" .. arg0_17.template.pic, arg0_17.template.pic, arg0_17.emojiGo)
	end

	arg0_17.emojiGo = nil
	arg0_17.template = nil
end

function var0_0.WaitForNextOne(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg1_18:GetTime()

	arg0_18:UnscaleDelayCall(var0_18, arg2_18)
end

function var0_0.PlayCharatorAnimation(arg0_19, arg1_19)
	if not arg1_19:ExistAnimation() then
		return
	end

	local var0_19 = arg0_19.role
	local var1_19 = arg1_19:GetAnimation()
	local var2_19 = var0_19:GetComponent(typeof(Animator)) or var0_19.transform:GetChild(0):GetComponent(typeof(Animator))

	if not var2_19:GetCurrentAnimatorStateInfo(0):IsName(var1_19) then
		local var3_19 = Animator.StringToHash(var1_19)

		for iter0_19 = 1, var2_19.layerCount do
			var2_19:CrossFadeInFixedTime(var3_19, 0.2, iter0_19 - 1)
		end
	end
end

function var0_0.EneAction(arg0_20, arg1_20)
	arg0_20:RemnoveTimer()

	local var0_20, var1_20 = arg1_20:GetHideType()

	if var0_20 == BubbleStep.HIDE_TYPE_IMMEDIATELY then
		arg0_20:ClearEmojiAndExpressionEmoji()
		arg0_20:ShowOrHide(false)
	elseif var0_20 == BubbleStep.HIDE_TYPE_NEVER then
		-- block empty
	elseif var0_20 == BubbleStep.HIDE_TYPE_TIME then
		arg0_20.timer = arg0_20:CreateDelayTimer(var1_20, function()
			if not IsNil(arg0_20.tpl) then
				arg0_20:ClearEmojiAndExpressionEmoji()
				arg0_20:ShowOrHide(false)
			end
		end)
	end
end

function var0_0.RemnoveTimer(arg0_22)
	if arg0_22.timer then
		arg0_22.timer:Stop()

		arg0_22.timer = nil
	end
end

function var0_0.ClearEmojiAndExpressionEmoji(arg0_23)
	arg0_23:ClearEmoji()
	arg0_23:ClearExpressionEmoji()
end

function var0_0.Stop(arg0_24)
	arg0_24:RemnoveTimer()
	arg0_24:ClearEmojiAndExpressionEmoji()
	arg0_24:ClearAnimation()
	arg0_24:ShowOrHide(show)

	arg0_24.isPlaying = false
	arg0_24.canShowFlag = true
end

function var0_0.IsPlaying(arg0_25)
	return arg0_25.isPlaying
end

function var0_0.SetShowFlag(arg0_26, arg1_26)
	if arg0_26:IsPlaying() then
		return
	end

	arg0_26.canShowFlag = arg1_26

	setActive(arg0_26.tpl, arg1_26)
end

function var0_0.ShowOrHide(arg0_27, arg1_27)
	if arg1_27 and not arg0_27.canShowFlag then
		return
	end

	setActive(arg0_27.tpl, arg1_27)
end

function var0_0.Dispose(arg0_28)
	Object.Destroy(arg0_28.tpl)

	arg0_28.tpl = nil
	arg0_28.role = nil
	arg0_28.contentTxt = nil
	arg0_28.isPlaying = false
	arg0_28.canShowFlag = true

	arg0_28:RemnoveTimer()
	arg0_28:ClearAnimation()
end

return var0_0

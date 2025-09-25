local var0_0 = class("IslandChatBubblePlayer", import("Mgr.Story.model.animation.StoryAnimtion"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.tpl = arg1_1
	arg0_1.role = arg2_1
	arg0_1.contentTr = arg0_1.tpl.transform:Find("content")
	arg0_1.emojiTr = arg0_1.tpl.transform:Find("face")
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
			arg0_2:ClearEmoji()
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

	setActive(arg0_6.contentTr, not var0_6)
	setActive(arg0_6.emojiTr, var0_6)

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
	arg0_11:ClearEmoji()

	local var0_11 = arg1_11:GetEmoji()
	local var1_11 = pg.emoji_template[var0_11]

	PoolMgr.GetInstance():GetPrefab("emoji/" .. var1_11.pic, var1_11.pic, true, function(arg0_12)
		local var0_12 = arg0_12:GetComponent("Animator")

		if var0_12 then
			var0_12.enabled = true
		end

		setParent(arg0_12, arg0_11.emojiTr, false)

		if arg0_12:GetComponent(typeof(CriManaEffectUI)) or var0_12 then
			arg0_12.transform.localScale = Vector3(0.48, 0.48, 1)
		else
			arg0_12.transform.localScale = Vector3(0.48, 0.48, 1)
		end

		setAnchoredPosition3D(arg0_12, Vector3(0, 9, 0))

		if arg0_12:GetComponent(typeof(Image)) then
			local var1_12 = GetOrAddComponent(arg0_12, typeof(Outline))

			var1_12.effectColor = Color.NewHex("707275")
			var1_12.effectDistance = Vector2(2, -2)
		end

		arg0_11.emojiGo = arg0_12
		arg0_11.template = var1_11

		arg2_11()
	end)
end

function var0_0.ClearEmoji(arg0_13)
	if arg0_13.emojiGo and arg0_13.template then
		arg0_13.emojiGo.transform.localPosition = Vector3(0, 0, 0)
		arg0_13.emojiGo.transform.localScale = Vector3(1, 1, 1)

		local var0_13 = GetOrAddComponent(arg0_13.emojiGo, typeof(Outline))

		if var0_13 then
			Object.Destroy(var0_13)
		end

		PoolMgr.GetInstance():ReturnPrefab("emoji/" .. arg0_13.template.pic, arg0_13.template.pic, arg0_13.emojiGo)
	end

	arg0_13.emojiGo = nil
	arg0_13.template = nil
end

function var0_0.WaitForNextOne(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg1_14:GetTime()

	arg0_14:UnscaleDelayCall(var0_14, arg2_14)
end

function var0_0.PlayCharatorAnimation(arg0_15, arg1_15)
	if not arg1_15:ExistAnimation() then
		return
	end

	local var0_15 = arg0_15.role
	local var1_15 = arg1_15:GetAnimation()
	local var2_15 = var0_15:GetComponent(typeof(Animator)) or var0_15.transform:GetChild(0):GetComponent(typeof(Animator))

	if not var2_15:GetCurrentAnimatorStateInfo(0):IsName(var1_15) then
		local var3_15 = Animator.StringToHash(var1_15)

		for iter0_15 = 1, var2_15.layerCount do
			var2_15:CrossFadeInFixedTime(var3_15, 0.2, iter0_15 - 1)
		end
	end
end

function var0_0.EneAction(arg0_16, arg1_16)
	arg0_16:RemnoveTimer()

	local var0_16, var1_16 = arg1_16:GetHideType()

	if var0_16 == BubbleStep.HIDE_TYPE_IMMEDIATELY then
		arg0_16:ClearEmoji()
		arg0_16:ShowOrHide(false)
	elseif var0_16 == BubbleStep.HIDE_TYPE_NEVER then
		-- block empty
	elseif var0_16 == BubbleStep.HIDE_TYPE_TIME then
		arg0_16.timer = arg0_16:CreateDelayTimer(var1_16, function()
			if not IsNil(arg0_16.tpl) then
				arg0_16:ClearEmoji()
				arg0_16:ShowOrHide(false)
			end
		end)
	end
end

function var0_0.RemnoveTimer(arg0_18)
	if arg0_18.timer then
		arg0_18.timer:Stop()

		arg0_18.timer = nil
	end
end

function var0_0.Stop(arg0_19)
	arg0_19:RemnoveTimer()
	arg0_19:ClearEmoji()
	arg0_19:ClearAnimation()
	arg0_19:ShowOrHide(show)

	arg0_19.isPlaying = false
	arg0_19.canShowFlag = true
end

function var0_0.IsPlaying(arg0_20)
	return arg0_20.isPlaying
end

function var0_0.SetShowFlag(arg0_21, arg1_21)
	if arg0_21:IsPlaying() then
		return
	end

	arg0_21.canShowFlag = arg1_21

	setActive(arg0_21.tpl, arg1_21)
end

function var0_0.ShowOrHide(arg0_22, arg1_22)
	if arg1_22 and not arg0_22.canShowFlag then
		return
	end

	setActive(arg0_22.tpl, arg1_22)
end

function var0_0.Dispose(arg0_23)
	Object.Destroy(arg0_23.tpl)

	arg0_23.tpl = nil
	arg0_23.role = nil
	arg0_23.contentTxt = nil
	arg0_23.isPlaying = false
	arg0_23.canShowFlag = true

	arg0_23:RemnoveTimer()
	arg0_23:ClearAnimation()
end

return var0_0

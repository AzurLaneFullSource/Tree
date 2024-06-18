local var0_0 = class("DialoguePerformPlayer", import(".BasePerformPlayer"))

var0_0.TYPEWRITE_SPEED = 0.05

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.eventTipBig = arg0_1:findTF("event_tip", arg0_1._tf)
	arg0_1.content = arg0_1:findTF("content", arg0_1._tf)
	arg0_1.image = arg0_1:findTF("Image", arg0_1.content)
	arg0_1.nameTF = arg0_1:findTF("name_bg", arg0_1.content)
	arg0_1.nameText = arg0_1:findTF("name", arg0_1.nameTF)
	arg0_1.next = arg0_1:findTF("next", arg0_1.content)
	arg0_1.eventTipSmall = arg0_1:findTF("event_tip", arg0_1.content)
	arg0_1.text = arg0_1:findTF("Text", arg0_1.content)
	arg0_1.text2 = arg0_1:findTF("Text2", arg0_1.content)
	arg0_1.resultTF = arg0_1:findTF("result", arg0_1.content)
	arg0_1.resultTpl = arg0_1:findTF("tpl", arg0_1.content)
end

function var0_0.Play(arg0_2, arg1_2, arg2_2)
	arg0_2:checkName()
	arg0_2:Show()

	local var0_2 = arg1_2.param[1]
	local var1_2 = pg.child_word[var0_2]

	assert(var0_2 and var1_2, "child_word not exist id: " .. var0_2)
	setActive(arg0_2.eventTipBig, arg1_2.show_event == 1)

	if arg1_2.show_event == 1 then
		onDelayTick(function()
			if arg0_2._anim then
				arg0_2._anim:Play()
			end

			arg0_2:_play(arg1_2, var1_2, arg2_2)
		end, 0.66)
	else
		setActive(arg0_2.eventTipBig, false)

		if arg0_2._anim then
			arg0_2._anim:Play()
		end

		arg0_2:_play(arg1_2, var1_2, arg2_2)
	end
end

function var0_0._play(arg0_4, arg1_4, arg2_4, arg3_4)
	setActive(arg0_4.eventTipSmall, arg1_4.show_event == 1)
	setActive(arg0_4.next, arg1_4.show_next == 1)

	arg0_4.drops = arg1_4.show_drops == 1 and arg1_4.drops or {}

	local var0_4 = arg2_4.char_type ~= EducateConst.WORD_TYPE_CHILD
	local var1_4 = arg0_4.text

	setActive(arg0_4.text, not var0_4)
	setActive(arg0_4.text2, var0_4)
	setActive(arg0_4.image, not var0_4)

	if not var0_4 then
		local var2_4 = getProxy(EducateProxy):GetCharData():GetPaintingName()

		setImageSprite(arg0_4.image, LoadSprite("storyicon/" .. var2_4), true)
	end

	local var3_4 = var0_4 and arg0_4.text2 or arg0_4.text
	local var4_4 = arg2_4.word
	local var5_4 = string.gsub(var4_4, "$1", arg0_4.callName)

	setText(var3_4, var5_4)

	local var6_4 = GetComponent(var3_4, typeof(Typewriter))

	if arg2_4.char_type == EducateConst.WORD_TYPE_ASIDE then
		setActive(arg0_4.nameTF, false)
	else
		setActive(arg0_4.nameTF, true)

		local var7_4 = ""

		if arg2_4.char_type == EducateConst.WORD_TYPE_CHILD then
			var7_4 = arg0_4.name
		elseif arg2_4.char_type == EducateConst.WORD_TYPE_PLAYER then
			var7_4 = arg0_4.playerName
		end

		setText(arg0_4.nameText, var7_4)
	end

	function var6_4.endFunc()
		setActive(arg0_4.resultTF, true)

		local var0_5 = {}

		for iter0_5 = 1, #arg0_4.drops do
			table.insert(var0_5, function(arg0_6)
				arg0_4.resultTF = arg0_4:findTF("result", arg0_4.content)
				arg0_4.resultTpl = arg0_4:findTF("tpl", arg0_4.content)

				local var0_6 = arg0_4.drops[iter0_5]
				local var1_6 = iter0_5 < arg0_4.resultTF.childCount and arg0_4.resultTF:GetChild(iter0_5 - 1) or cloneTplTo(arg0_4.resultTpl, arg0_4.resultTF)

				if var0_6.type == EducateConst.DROP_TYPE_BUFF then
					setActive(arg0_4:findTF("icon", var1_6), false)
					setText(arg0_4:findTF("name", var1_6), pg.child_buff[var0_6.id].name)
					setText(arg0_4:findTF("value", var1_6), "")
				else
					setActive(arg0_4:findTF("icon", var1_6), true)
					EducateHelper.UpdateDropShowForAttr(var1_6, var0_6)
				end

				setActive(var1_6, true)
				var1_6:GetComponent(typeof(Animation)):Play("anim_educate_attr_in")
				onDelayTick(function()
					arg0_6()
				end, 0.033)
			end)
		end

		seriesAsync(var0_5, function()
			onDelayTick(function()
				setActive(arg0_4.resultTF, false)
				eachChild(arg0_4.resultTF, function(arg0_10)
					setActive(arg0_10, false)
				end)

				if arg3_4 then
					arg3_4()
				end
			end, 1)
		end)
	end

	var6_4:setSpeed(var0_0.TYPEWRITE_SPEED)
	var6_4:Play()
end

function var0_0.checkName(arg0_11)
	if not arg0_11.callName then
		arg0_11.callName = getProxy(EducateProxy):GetCharData():GetCallName()
	end

	if not arg0_11.name then
		arg0_11.name = getProxy(EducateProxy):GetCharData():GetName()
	end

	if not arg0_11.playerName then
		arg0_11.playerName = getProxy(PlayerProxy):getRawData():GetName()
	end
end

function var0_0.Clear(arg0_12)
	setText(arg0_12.text, "")
	setText(arg0_12.text2, "")
	setActive(arg0_12.eventTipBig, false)
	setActive(arg0_12.eventTipSmall, false)
	arg0_12:Hide()
end

return var0_0

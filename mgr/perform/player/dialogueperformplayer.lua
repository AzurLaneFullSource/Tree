local var0 = class("DialoguePerformPlayer", import(".BasePerformPlayer"))

var0.TYPEWRITE_SPEED = 0.05

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.eventTipBig = arg0:findTF("event_tip", arg0._tf)
	arg0.content = arg0:findTF("content", arg0._tf)
	arg0.image = arg0:findTF("Image", arg0.content)
	arg0.nameTF = arg0:findTF("name_bg", arg0.content)
	arg0.nameText = arg0:findTF("name", arg0.nameTF)
	arg0.next = arg0:findTF("next", arg0.content)
	arg0.eventTipSmall = arg0:findTF("event_tip", arg0.content)
	arg0.text = arg0:findTF("Text", arg0.content)
	arg0.text2 = arg0:findTF("Text2", arg0.content)
	arg0.resultTF = arg0:findTF("result", arg0.content)
	arg0.resultTpl = arg0:findTF("tpl", arg0.content)
end

function var0.Play(arg0, arg1, arg2)
	arg0:checkName()
	arg0:Show()

	local var0 = arg1.param[1]
	local var1 = pg.child_word[var0]

	assert(var0 and var1, "child_word not exist id: " .. var0)
	setActive(arg0.eventTipBig, arg1.show_event == 1)

	if arg1.show_event == 1 then
		onDelayTick(function()
			if arg0._anim then
				arg0._anim:Play()
			end

			arg0:_play(arg1, var1, arg2)
		end, 0.66)
	else
		setActive(arg0.eventTipBig, false)

		if arg0._anim then
			arg0._anim:Play()
		end

		arg0:_play(arg1, var1, arg2)
	end
end

function var0._play(arg0, arg1, arg2, arg3)
	setActive(arg0.eventTipSmall, arg1.show_event == 1)
	setActive(arg0.next, arg1.show_next == 1)

	arg0.drops = arg1.show_drops == 1 and arg1.drops or {}

	local var0 = arg2.char_type ~= EducateConst.WORD_TYPE_CHILD
	local var1 = arg0.text

	setActive(arg0.text, not var0)
	setActive(arg0.text2, var0)
	setActive(arg0.image, not var0)

	if not var0 then
		local var2 = getProxy(EducateProxy):GetCharData():GetPaintingName()

		setImageSprite(arg0.image, LoadSprite("storyicon/" .. var2), true)
	end

	local var3 = var0 and arg0.text2 or arg0.text
	local var4 = arg2.word
	local var5 = string.gsub(var4, "$1", arg0.callName)

	setText(var3, var5)

	local var6 = GetComponent(var3, typeof(Typewriter))

	if arg2.char_type == EducateConst.WORD_TYPE_ASIDE then
		setActive(arg0.nameTF, false)
	else
		setActive(arg0.nameTF, true)

		local var7 = ""

		if arg2.char_type == EducateConst.WORD_TYPE_CHILD then
			var7 = arg0.name
		elseif arg2.char_type == EducateConst.WORD_TYPE_PLAYER then
			var7 = arg0.playerName
		end

		setText(arg0.nameText, var7)
	end

	function var6.endFunc()
		setActive(arg0.resultTF, true)

		local var0 = {}

		for iter0 = 1, #arg0.drops do
			table.insert(var0, function(arg0)
				arg0.resultTF = arg0:findTF("result", arg0.content)
				arg0.resultTpl = arg0:findTF("tpl", arg0.content)

				local var0 = arg0.drops[iter0]
				local var1 = iter0 < arg0.resultTF.childCount and arg0.resultTF:GetChild(iter0 - 1) or cloneTplTo(arg0.resultTpl, arg0.resultTF)

				if var0.type == EducateConst.DROP_TYPE_BUFF then
					setActive(arg0:findTF("icon", var1), false)
					setText(arg0:findTF("name", var1), pg.child_buff[var0.id].name)
					setText(arg0:findTF("value", var1), "")
				else
					setActive(arg0:findTF("icon", var1), true)
					EducateHelper.UpdateDropShowForAttr(var1, var0)
				end

				setActive(var1, true)
				var1:GetComponent(typeof(Animation)):Play("anim_educate_attr_in")
				onDelayTick(function()
					arg0()
				end, 0.033)
			end)
		end

		seriesAsync(var0, function()
			onDelayTick(function()
				setActive(arg0.resultTF, false)
				eachChild(arg0.resultTF, function(arg0)
					setActive(arg0, false)
				end)

				if arg3 then
					arg3()
				end
			end, 1)
		end)
	end

	var6:setSpeed(var0.TYPEWRITE_SPEED)
	var6:Play()
end

function var0.checkName(arg0)
	if not arg0.callName then
		arg0.callName = getProxy(EducateProxy):GetCharData():GetCallName()
	end

	if not arg0.name then
		arg0.name = getProxy(EducateProxy):GetCharData():GetName()
	end

	if not arg0.playerName then
		arg0.playerName = getProxy(PlayerProxy):getRawData():GetName()
	end
end

function var0.Clear(arg0)
	setText(arg0.text, "")
	setText(arg0.text2, "")
	setActive(arg0.eventTipBig, false)
	setActive(arg0.eventTipSmall, false)
	arg0:Hide()
end

return var0

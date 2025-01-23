local var0_0 = class("NewEducateWordHandler")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._anim = arg0_1._tf:GetComponent(typeof(Animation))
	arg0_1.content = arg0_1._tf:Find("content")
	arg0_1.image = arg0_1.content:Find("Image")
	arg0_1.nameTF = arg0_1.content:Find("name_bg")
	arg0_1.nameText = arg0_1.nameTF:Find("name")
	arg0_1.next = arg0_1.content:Find("next")
	arg0_1.text = arg0_1.content:Find("Text")
	arg0_1.text2 = arg0_1.content:Find("Text2")
	arg0_1.resultTF = arg0_1.content:Find("result")
	arg0_1.resultTpl = arg0_1.content:Find("tpl")
	arg0_1.nextClickTF = arg0_1._tf:Find("click")
	arg0_1.speed = NewEducateConst.TYPEWRITE_SPEED
end

function var0_0.Play(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2)
	arg0_2.speed = NewEducateConst.TYPEWRITE_SPEED

	local var0_2 = pg.child2_word[arg1_2]

	assert(var0_2, "child2_word not exist id: " .. arg1_2)
	arg0_2:CheckName()

	local var1_2 = not isActive(arg0_2._go)

	setActive(arg0_2._go, true)

	if var1_2 and arg0_2._anim then
		arg0_2._anim:Play()
	end

	arg0_2.needClick = arg5_2

	setActive(arg0_2.next, arg4_2)

	arg0_2.drops = arg3_2 or {}

	local var2_2 = var0_2.char_type ~= NewEducateConst.WORD_TYPE.CHILD or var0_2.char_type == NewEducateConst.WORD_TYPE.HIDE_IMAGE

	setActive(arg0_2.text, not var2_2)
	setActive(arg0_2.text2, var2_2)
	setActive(arg0_2.image, not var2_2)

	if not var2_2 then
		local var3_2 = getProxy(NewEducateProxy):GetCurChar():GetPaintingName()

		setImageSprite(arg0_2.image, LoadSprite("storyicon/" .. var3_2), true)
	end

	local var4_2 = var2_2 and arg0_2.text2 or arg0_2.text
	local var5_2 = var0_2.word
	local var6_2 = string.gsub(var5_2, "$1", arg0_2.callName)

	setText(var4_2, var6_2)
	setActive(arg0_2.nameTF, var0_2.char_type ~= NewEducateConst.WORD_TYPE.ASIDE)

	if var0_2.char_type ~= NewEducateConst.WORD_TYPE.ASIDE then
		local var7_2 = ""

		if var0_2.char_type == NewEducateConst.WORD_TYPE.CHILD or var0_2.char_type == NewEducateConst.WORD_TYPE.HIDE_IMAGE then
			var7_2 = arg0_2.name
		elseif var0_2.char_type == NewEducateConst.WORD_TYPE.PLAYER then
			var7_2 = arg0_2.playerName
		end

		setText(arg0_2.nameText, var7_2)
	end

	local var8_2 = GetComponent(var4_2, typeof(Typewriter))

	function var8_2.endFunc()
		setActive(arg0_2.resultTF, true)

		local var0_3 = {}

		for iter0_3 = 1, #arg0_2.drops do
			table.insert(var0_3, function(arg0_4)
				local var0_4 = arg0_2.drops[iter0_3]
				local var1_4 = iter0_3 < arg0_2.resultTF.childCount and arg0_2.resultTF:GetChild(iter0_3 - 1) or cloneTplTo(arg0_2.resultTpl, arg0_2.resultTF)

				if var0_4.type == NewEducateConst.DROP_TYPE.BUFF then
					setActive(var1_4:Find("icon"), false)
					setText(var1_4:Find("name"), pg.child2_benefit_list[var0_4.id].name)
					setText(var1_4:Find("value"), "")
				else
					setActive(var1_4:Find("icon"), true)
					NewEducateHelper.UpdateVectorItem(var1_4, var0_4)
				end

				setActive(var1_4, true)
				var1_4:GetComponent(typeof(Animation)):Play("anim_educate_attr_in")
				onDelayTick(function()
					arg0_4()
				end, 0.033)
			end)
		end

		seriesAsync(var0_3, function()
			if not arg0_2.needClick then
				onDelayTick(function()
					setActive(arg0_2.resultTF, false)
					eachChild(arg0_2.resultTF, function(arg0_8)
						setActive(arg0_8, false)
					end)
					existCall(arg2_2)
				end, 1)
			else
				onButton(arg0_2, arg0_2.nextClickTF, function()
					removeOnButton(arg0_2.nextClickTF)
					existCall(arg2_2)
				end, SFX_PANEL)
			end
		end)
	end

	var8_2:setSpeed(arg0_2.speed)
	var8_2:Play()

	if arg0_2.speed ~= NewEducateConst.TYPEWRITE_SPEED_UP then
		onButton(arg0_2, arg0_2.nextClickTF, function()
			removeOnButton(arg0_2.nextClickTF)

			arg0_2.speed = NewEducateConst.TYPEWRITE_SPEED_UP

			var8_2:setSpeed(arg0_2.speed)
		end)
	end
end

function var0_0.PlayWordIds(arg0_11, arg1_11, arg2_11)
	arg0_11:CheckName()

	local var0_11 = not isActive(arg0_11._go)

	setActive(arg0_11._go, true)

	if var0_11 and arg0_11._anim then
		arg0_11._anim:Play()
	end

	arg0_11.needClick = true

	setActive(arg0_11.next, false)

	local var1_11 = true

	setActive(arg0_11.text, not var1_11)
	setActive(arg0_11.text2, var1_11)
	setActive(arg0_11.image, not var1_11)
	setActive(arg0_11.nameTF, false)
	setActive(arg0_11.resultTF, false)

	local var2_11 = var1_11 and arg0_11.text2 or arg0_11.text
	local var3_11 = {}

	for iter0_11, iter1_11 in ipairs(arg1_11) do
		table.insert(var3_11, function(arg0_12)
			arg0_11.speed = NewEducateConst.TYPEWRITE_SPEED

			local var0_12 = pg.child2_word[iter1_11].word
			local var1_12 = string.gsub(var0_12, "$1", arg0_11.callName)

			setText(var2_11, var1_12)
			setActive(arg0_11.next, iter0_11 ~= #arg1_11)

			local var2_12 = GetComponent(var2_11, typeof(Typewriter))

			function var2_12.endFunc()
				if not arg0_11.needClick then
					onDelayTick(function()
						arg0_12()
					end, 1)
				else
					onButton(arg0_11, arg0_11.nextClickTF, function()
						removeOnButton(arg0_11.nextClickTF)
						arg0_12()
					end, SFX_PANEL)
				end
			end

			var2_12:setSpeed(arg0_11.speed)
			var2_12:Play()

			if arg0_11.speed ~= NewEducateConst.TYPEWRITE_SPEED_UP then
				onButton(arg0_11, arg0_11.nextClickTF, function()
					removeOnButton(arg0_11.nextClickTF)

					arg0_11.speed = NewEducateConst.TYPEWRITE_SPEED_UP

					var2_12:setSpeed(arg0_11.speed)
				end)
			end
		end)
	end

	seriesAsync(var3_11, function()
		existCall(arg2_11)
	end)
end

function var0_0.CheckName(arg0_18)
	if not arg0_18.callName then
		arg0_18.callName = getProxy(NewEducateProxy):GetCurChar():GetCallName()
	end

	if not arg0_18.name then
		arg0_18.name = getProxy(NewEducateProxy):GetCurChar():GetName()
	end

	if not arg0_18.playerName then
		arg0_18.playerName = getProxy(PlayerProxy):getRawData():GetName()
	end
end

function var0_0.Reset(arg0_19)
	setActive(arg0_19._go, false)
	removeOnButton(arg0_19.nextClickTF)

	arg0_19.speed = NewEducateConst.TYPEWRITE_SPEED
end

function var0_0.UpdateCallName(arg0_20)
	arg0_20.callName = getProxy(NewEducateProxy):GetCurChar():GetCallName()
end

function var0_0.Destroy(arg0_21)
	pg.DelegateInfo.Dispose(arg0_21)
end

return var0_0

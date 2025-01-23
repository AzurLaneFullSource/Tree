local var0_0 = class("NewEducateDropHandler")
local var1_0 = 1

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.dropsTF = arg0_1._tf:Find("drops")
	arg0_1.dropUIList = UIItemList.New(arg0_1.dropsTF, arg0_1.dropsTF:Find("tpl"))

	arg0_1.dropUIList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			local var0_2 = arg0_1.drops[arg1_2 + 1]
			local var1_2 = NewEducateHelper.GetDropConfig(var0_2)
			local var2_2 = var1_2.icon or var1_2.item_icon

			LoadImageSpriteAsync("neweducateicon/" .. var2_2, arg2_2:Find("icon"))
			setText(arg2_2:Find("name"), var1_2.name)

			if var0_2.number > 0 then
				setActive(arg2_2:Find("reduce"), false)
				setActive(arg2_2:Find("increase"), true)
				setText(arg2_2:Find("increase/value"), "+" .. var0_2.number)
			else
				setActive(arg2_2:Find("reduce"), true)
				setActive(arg2_2:Find("increase"), false)
				setText(arg2_2:Find("reduce/value"), var0_2.number)
			end

			setActive(arg2_2:Find("benefit"), false)
		end
	end)

	arg0_1.polaroidTF = arg0_1._tf:Find("polaroid")
end

function var0_0.Play(arg0_3, arg1_3, arg2_3)
	setActive(arg0_3._go, true)
	setActive(arg0_3.dropsTF, true)
	setActive(arg0_3.polaroidTF, false)

	arg0_3.drops = arg0_3:FilterPersonality(arg1_3)

	arg0_3.dropUIList:align(#arg0_3.drops)

	arg0_3.timer = Timer.New(function()
		existCall(arg2_3)
	end, var1_0)

	arg0_3.timer:Start()
end

function var0_0.FilterPersonality(arg0_5, arg1_5)
	return underscore.select(arg1_5, function(arg0_6)
		return arg0_6.type ~= NewEducateConst.DROP_TYPE.ATTR or arg0_6.type == NewEducateConst.DROP_TYPE.ATTR and pg.child2_attr[arg0_6.id].type ~= NewEducateChar.ATTR_TYPE.PERSONALITY
	end)
end

function var0_0.PlayPolaroid(arg0_7, arg1_7, arg2_7)
	setActive(arg0_7._go, true)
	setActive(arg0_7.dropsTF, false)
	setActive(arg0_7.polaroidTF, true)
	seriesAsync({
		function(arg0_8)
			local var0_8 = pg.child2_polaroid[arg1_7.id]

			LoadImageSpriteAsync("neweducateicon/" .. var0_8.pic, arg0_7.polaroidTF:Find("content/mask/icon"), true)
			setText(arg0_7.polaroidTF:Find("content/desc"), var0_8.title)
			onDelayTick(function()
				arg0_8()
			end, var1_0)
		end
	}, function()
		existCall(arg2_7)
	end)
end

function var0_0.Reset(arg0_11)
	setActive(arg0_11._go, false)
	setActive(arg0_11.polaroidTF, false)
	setActive(arg0_11.dropsTF, false)

	arg0_11.drops = {}

	if arg0_11.timer ~= nil then
		arg0_11.timer:Stop()

		arg0_11.timer = nil
	end
end

function var0_0.Destroy(arg0_12)
	return
end

return var0_0

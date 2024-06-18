local var0_0 = class("CatteryCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)
	arg0_1.lockTF = findTF(arg0_1._tf, "lock")
	arg0_1.unlockTF = findTF(arg0_1._tf, "unlock")
	arg0_1.style = arg0_1.unlockTF:Find("mask/bg"):GetComponent(typeof(Image))
	arg0_1.char = findTF(arg0_1.unlockTF, "char")
	arg0_1.empty = findTF(arg0_1.unlockTF, "empty")
	arg0_1.commanderExp = findTF(arg0_1.unlockTF, "commander_exp")
	arg0_1.bubble = findTF(arg0_1.unlockTF, "bubble")
	arg0_1.levelTxt = findTF(arg0_1.commanderExp, "level/Text"):GetComponent(typeof(Text))
	arg0_1.expTxt = findTF(arg0_1.commanderExp, "exp/Text"):GetComponent(typeof(Text))
	arg0_1.clean = findTF(arg0_1.bubble, "clean")
	arg0_1.feed = findTF(arg0_1.bubble, "feed")
	arg0_1.play = findTF(arg0_1.bubble, "play")
	arg0_1.expAddition = findTF(arg0_1.unlockTF, "exp_addition")
	arg0_1.expAdditionTxt = arg0_1.expAddition:Find("Text"):GetComponent(typeof(Text))
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2.cattery = arg1_2

	local var0_2 = arg1_2:GetState()
	local var1_2 = var0_2 == Cattery.STATE_LOCK

	if var1_2 then
		setActive(arg0_2.bubble, false)
	elseif var0_2 == Cattery.STATE_EMPTY then
		arg0_2:FlushEmpty()
	elseif var0_2 == Cattery.STATE_OCCUPATION then
		arg0_2:FlushCommander()
	end

	setActive(arg0_2.lockTF, var1_2)
	setActive(arg0_2.unlockTF, not var1_2)
	arg0_2:UpdateStyle()
end

function var0_0.UpdateStyle(arg0_3)
	local var0_3 = arg0_3.cattery
	local var1_3 = var0_3:GetState()

	if not (var1_3 == Cattery.STATE_LOCK) then
		local var2_3 = var0_3:_GetStyle_()

		if var1_3 == Cattery.STATE_EMPTY then
			arg0_3.style.sprite = GetSpriteFromAtlas("CatteryStyle/" .. var2_3:GetName(false), "")
		else
			arg0_3.style.sprite = GetSpriteFromAtlas("CatteryStyle/" .. var2_3:GetName(var0_3:IsDirty()), "")
		end
	end
end

function var0_0.FlushEmpty(arg0_4)
	setActive(arg0_4.empty, true)
	setActive(arg0_4.commanderExp, false)
	setActive(arg0_4.bubble, false)
	arg0_4:ReturnChar()
	arg0_4:InitBubble()
end

function var0_0.FlushCommander(arg0_5)
	setActive(arg0_5.empty, false)
	setActive(arg0_5.commanderExp, true)
	setActive(arg0_5.bubble, true)

	local var0_5 = arg0_5.cattery:GetCommander()

	arg0_5.levelTxt.text = "LV." .. var0_5:getLevel()
	arg0_5.expTxt.text = var0_5.exp .. "/" .. var0_5:getNextLevelExp()

	arg0_5:LoadChar(var0_5)
	arg0_5:InitBubble()
end

function var0_0.LoadChar(arg0_6, arg1_6)
	arg0_6.painting = arg1_6:getPainting()

	setCommanderPaintingPrefab(arg0_6.char, arg0_6.painting, "info")
end

function var0_0.ReturnChar(arg0_7)
	if arg0_7.painting then
		retCommanderPaintingPrefab(arg0_7.char, arg0_7.painting)

		arg0_7.painting = nil
	end
end

function var0_0.InitBubble(arg0_8)
	local var0_8 = arg0_8.cattery
	local var1_8 = var0_8:ExistCleanOP()
	local var2_8 = var0_8:ExiseFeedOP()
	local var3_8 = var0_8:ExistPlayOP()

	setActive(arg0_8.clean, var1_8)
	setActive(arg0_8.feed, var2_8)
	setActive(arg0_8.play, var3_8)
	setActive(arg0_8.bubble, var1_8 or var2_8 or var3_8)
end

function var0_0.AddExpAnim(arg0_9, arg1_9, arg2_9)
	arg0_9:RemoveTimer()

	arg0_9.expAdditionTxt.text = arg1_9

	setActive(arg0_9.expAddition, true)

	arg0_9.timer = Timer.New(function()
		arg0_9:RemoveTimer()
		setActive(arg0_9.expAddition, false)
		arg2_9()
	end, 1, 1)

	arg0_9.timer:Start()
end

function var0_0.RemoveTimer(arg0_11)
	if arg0_11.timer then
		arg0_11.timer:Stop()

		arg0_11.timer = nil
	end
end

function var0_0.Dispose(arg0_12)
	arg0_12:ReturnChar()
	arg0_12:RemoveTimer()
end

return var0_0

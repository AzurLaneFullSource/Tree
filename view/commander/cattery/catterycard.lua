local var0 = class("CatteryCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0.lockTF = findTF(arg0._tf, "lock")
	arg0.unlockTF = findTF(arg0._tf, "unlock")
	arg0.style = arg0.unlockTF:Find("mask/bg"):GetComponent(typeof(Image))
	arg0.char = findTF(arg0.unlockTF, "char")
	arg0.empty = findTF(arg0.unlockTF, "empty")
	arg0.commanderExp = findTF(arg0.unlockTF, "commander_exp")
	arg0.bubble = findTF(arg0.unlockTF, "bubble")
	arg0.levelTxt = findTF(arg0.commanderExp, "level/Text"):GetComponent(typeof(Text))
	arg0.expTxt = findTF(arg0.commanderExp, "exp/Text"):GetComponent(typeof(Text))
	arg0.clean = findTF(arg0.bubble, "clean")
	arg0.feed = findTF(arg0.bubble, "feed")
	arg0.play = findTF(arg0.bubble, "play")
	arg0.expAddition = findTF(arg0.unlockTF, "exp_addition")
	arg0.expAdditionTxt = arg0.expAddition:Find("Text"):GetComponent(typeof(Text))
end

function var0.Update(arg0, arg1)
	arg0.cattery = arg1

	local var0 = arg1:GetState()
	local var1 = var0 == Cattery.STATE_LOCK

	if var1 then
		setActive(arg0.bubble, false)
	elseif var0 == Cattery.STATE_EMPTY then
		arg0:FlushEmpty()
	elseif var0 == Cattery.STATE_OCCUPATION then
		arg0:FlushCommander()
	end

	setActive(arg0.lockTF, var1)
	setActive(arg0.unlockTF, not var1)
	arg0:UpdateStyle()
end

function var0.UpdateStyle(arg0)
	local var0 = arg0.cattery
	local var1 = var0:GetState()

	if not (var1 == Cattery.STATE_LOCK) then
		local var2 = var0:_GetStyle_()

		if var1 == Cattery.STATE_EMPTY then
			arg0.style.sprite = GetSpriteFromAtlas("CatteryStyle/" .. var2:GetName(false), "")
		else
			arg0.style.sprite = GetSpriteFromAtlas("CatteryStyle/" .. var2:GetName(var0:IsDirty()), "")
		end
	end
end

function var0.FlushEmpty(arg0)
	setActive(arg0.empty, true)
	setActive(arg0.commanderExp, false)
	setActive(arg0.bubble, false)
	arg0:ReturnChar()
	arg0:InitBubble()
end

function var0.FlushCommander(arg0)
	setActive(arg0.empty, false)
	setActive(arg0.commanderExp, true)
	setActive(arg0.bubble, true)

	local var0 = arg0.cattery:GetCommander()

	arg0.levelTxt.text = "LV." .. var0:getLevel()
	arg0.expTxt.text = var0.exp .. "/" .. var0:getNextLevelExp()

	arg0:LoadChar(var0)
	arg0:InitBubble()
end

function var0.LoadChar(arg0, arg1)
	arg0.painting = arg1:getPainting()

	setCommanderPaintingPrefab(arg0.char, arg0.painting, "info")
end

function var0.ReturnChar(arg0)
	if arg0.painting then
		retCommanderPaintingPrefab(arg0.char, arg0.painting)

		arg0.painting = nil
	end
end

function var0.InitBubble(arg0)
	local var0 = arg0.cattery
	local var1 = var0:ExistCleanOP()
	local var2 = var0:ExiseFeedOP()
	local var3 = var0:ExistPlayOP()

	setActive(arg0.clean, var1)
	setActive(arg0.feed, var2)
	setActive(arg0.play, var3)
	setActive(arg0.bubble, var1 or var2 or var3)
end

function var0.AddExpAnim(arg0, arg1, arg2)
	arg0:RemoveTimer()

	arg0.expAdditionTxt.text = arg1

	setActive(arg0.expAddition, true)

	arg0.timer = Timer.New(function()
		arg0:RemoveTimer()
		setActive(arg0.expAddition, false)
		arg2()
	end, 1, 1)

	arg0.timer:Start()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Dispose(arg0)
	arg0:ReturnChar()
	arg0:RemoveTimer()
end

return var0

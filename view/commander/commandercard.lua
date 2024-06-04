local var0 = class("CommanderCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0.infoTF = arg0._tf:Find("info")
	arg0.emptyTF = arg0._tf:Find("empty")
	arg0.quitTF = arg0._tf:Find("quit")
	arg0.scrollTxt = arg0.infoTF:Find("name_bg/mask/Text"):GetComponent("ScrollText")
	arg0.levelTF = arg0.infoTF:Find("level_bg/Text"):GetComponent(typeof(Text))
	arg0.iconTF = arg0.infoTF:Find("icon")
	arg0.mark2 = arg0.infoTF:Find("mark1")
	arg0.mark1 = arg0.infoTF:Find("mark2")

	setActive(arg0.mark1, false)
	setActive(arg0.mark2, false)

	arg0.expUp = arg0._tf:Find("up")

	setActive(arg0.expUp, false)

	arg0.formationTF = arg0.infoTF:Find("formation")
	arg0.inbattleTF = arg0.infoTF:Find("inbattle")

	setActive(arg0.inbattleTF, false)
	setActive(arg0.formationTF, false)

	arg0.tip = arg0._tf:Find("tip")

	setActive(arg0.tip, false)

	arg0.lockTr = arg0._tf:Find("lock")
end

function var0.clearSelected(arg0)
	setActive(arg0.mark1, false)
	setActive(arg0.mark2, false)
	setActive(arg0.expUp, false)
	arg0:UpdateCommanderName(arg0.commanderVO, false)
end

function var0.selectedAnim(arg0)
	if LeanTween.isTweening(arg0.infoTF) then
		LeanTween.cancel(arg0.infoTF)
	end

	local var0 = 20

	LeanTween.moveY(rtf(arg0.infoTF), var0, 0.1):setOnComplete(System.Action(function()
		LeanTween.moveY(rtf(arg0.infoTF), 0, 0.1)
	end))
	arg0:UpdateCommanderName(arg0.commanderVO, true)
end

function var0.update(arg0, arg1)
	if not IsNil(arg0.lockTr) then
		setActive(arg0.lockTr, false)
	end

	if arg1 then
		arg0.commanderVO = arg1

		if arg1.id ~= 0 then
			arg0:updateCommander()
		end
	end

	setActive(arg0.formationTF, arg1 and arg1.inFleet and not arg1.inBattle)
	setActive(arg0.inbattleTF, arg1 and arg1.inBattle)
	setActive(arg0.infoTF, arg1 and arg1.id ~= 0)
	setActive(arg0.emptyTF, not arg1)
	setActive(arg0.quitTF, arg1 and arg1.id == 0)
	setActive(arg0.tip, arg1 and arg1.id ~= 0 and arg1:getTalentPoint() > 0 and not LOCK_COMMANDER_TALENT_TIP)
end

function var0.updateCommander(arg0)
	local var0 = arg0.commanderVO

	arg0:UpdateCommanderName(var0, false)

	arg0.levelTF.text = var0.level

	GetImageSpriteFromAtlasAsync("commandericon/" .. var0:getPainting(), "", arg0.iconTF)

	if not IsNil(arg0.lockTr) then
		setActive(arg0.lockTr, var0:isLocked())
	end
end

function var0.UpdateCommanderName(arg0, arg1, arg2)
	if not arg1 or arg1.id == 0 then
		return
	end

	if arg2 then
		arg0.scrollTxt:SetText(arg1:getName())
	else
		arg0.scrollTxt:SetText(arg0:ShortenString(arg1:getName(), 6))
	end
end

function var0.ShortenString(arg0, arg1, arg2)
	local function var0(arg0)
		if not arg0 then
			return 0, 1
		elseif arg0 > 240 then
			return 4, 1
		elseif arg0 > 225 then
			return 3, 1
		elseif arg0 > 192 then
			return 2, 1
		elseif arg0 < 126 then
			return 1, 0.75
		else
			return 1, 1
		end
	end

	local var1 = 1
	local var2 = 0
	local var3 = 0
	local var4 = #arg1
	local var5 = false

	while var1 <= var4 do
		local var6 = string.byte(arg1, var1)
		local var7, var8 = var0(var6)

		var1 = var1 + var7
		var2 = var2 + var8

		local var9 = math.ceil(var2)

		if var9 == arg2 - 1 then
			var3 = var1
		elseif arg2 < var9 then
			var5 = true

			break
		end
	end

	if var3 == 0 or var4 < var3 or not var5 then
		return arg1
	end

	return string.sub(arg1, 1, var3 - 1) .. ".."
end

function var0.clear(arg0)
	if LeanTween.isTweening(arg0.infoTF) then
		LeanTween.cancel(arg0.infoTF)
	end
end

function var0.Dispose(arg0)
	arg0:clear()
end

return var0

local var0_0 = class("CommanderCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)
	arg0_1.infoTF = arg0_1._tf:Find("info")
	arg0_1.emptyTF = arg0_1._tf:Find("empty")
	arg0_1.quitTF = arg0_1._tf:Find("quit")
	arg0_1.scrollTxt = arg0_1.infoTF:Find("name_bg/mask/Text"):GetComponent("ScrollText")
	arg0_1.levelTF = arg0_1.infoTF:Find("level_bg/Text"):GetComponent(typeof(Text))
	arg0_1.iconTF = arg0_1.infoTF:Find("icon")
	arg0_1.mark2 = arg0_1.infoTF:Find("mark1")
	arg0_1.mark1 = arg0_1.infoTF:Find("mark2")

	setActive(arg0_1.mark1, false)
	setActive(arg0_1.mark2, false)

	arg0_1.expUp = arg0_1._tf:Find("up")

	setActive(arg0_1.expUp, false)

	arg0_1.formationTF = arg0_1.infoTF:Find("formation")
	arg0_1.inbattleTF = arg0_1.infoTF:Find("inbattle")

	setActive(arg0_1.inbattleTF, false)
	setActive(arg0_1.formationTF, false)

	arg0_1.tip = arg0_1._tf:Find("tip")

	setActive(arg0_1.tip, false)

	arg0_1.lockTr = arg0_1._tf:Find("lock")
end

function var0_0.clearSelected(arg0_2)
	setActive(arg0_2.mark1, false)
	setActive(arg0_2.mark2, false)
	setActive(arg0_2.expUp, false)
	arg0_2:UpdateCommanderName(arg0_2.commanderVO, false)
end

function var0_0.selectedAnim(arg0_3)
	if LeanTween.isTweening(arg0_3.infoTF) then
		LeanTween.cancel(arg0_3.infoTF)
	end

	local var0_3 = 20

	LeanTween.moveY(rtf(arg0_3.infoTF), var0_3, 0.1):setOnComplete(System.Action(function()
		LeanTween.moveY(rtf(arg0_3.infoTF), 0, 0.1)
	end))
	arg0_3:UpdateCommanderName(arg0_3.commanderVO, true)
end

function var0_0.update(arg0_5, arg1_5)
	if not IsNil(arg0_5.lockTr) then
		setActive(arg0_5.lockTr, false)
	end

	if arg1_5 then
		arg0_5.commanderVO = arg1_5

		if arg1_5.id ~= 0 then
			arg0_5:updateCommander()
		end
	end

	setActive(arg0_5.formationTF, arg1_5 and arg1_5.inFleet and not arg1_5.inBattle)
	setActive(arg0_5.inbattleTF, arg1_5 and arg1_5.inBattle)
	setActive(arg0_5.infoTF, arg1_5 and arg1_5.id ~= 0)
	setActive(arg0_5.emptyTF, not arg1_5)
	setActive(arg0_5.quitTF, arg1_5 and arg1_5.id == 0)
	setActive(arg0_5.tip, arg1_5 and arg1_5.id ~= 0 and arg1_5:getTalentPoint() > 0 and not LOCK_COMMANDER_TALENT_TIP)
end

function var0_0.updateCommander(arg0_6)
	local var0_6 = arg0_6.commanderVO

	arg0_6:UpdateCommanderName(var0_6, false)

	arg0_6.levelTF.text = var0_6.level

	GetImageSpriteFromAtlasAsync("commandericon/" .. var0_6:getPainting(), "", arg0_6.iconTF)

	if not IsNil(arg0_6.lockTr) then
		setActive(arg0_6.lockTr, var0_6:isLocked())
	end
end

function var0_0.UpdateCommanderName(arg0_7, arg1_7, arg2_7)
	if not arg1_7 or arg1_7.id == 0 then
		return
	end

	if arg2_7 then
		arg0_7.scrollTxt:SetText(arg1_7:getName())
	else
		arg0_7.scrollTxt:SetText(arg0_7:ShortenString(arg1_7:getName(), 6))
	end
end

function var0_0.ShortenString(arg0_8, arg1_8, arg2_8)
	local function var0_8(arg0_9)
		if not arg0_9 then
			return 0, 1
		elseif arg0_9 > 240 then
			return 4, 1
		elseif arg0_9 > 225 then
			return 3, 1
		elseif arg0_9 > 192 then
			return 2, 1
		elseif arg0_9 < 126 then
			return 1, 0.75
		else
			return 1, 1
		end
	end

	local var1_8 = 1
	local var2_8 = 0
	local var3_8 = 0
	local var4_8 = #arg1_8
	local var5_8 = false

	while var1_8 <= var4_8 do
		local var6_8 = string.byte(arg1_8, var1_8)
		local var7_8, var8_8 = var0_8(var6_8)

		var1_8 = var1_8 + var7_8
		var2_8 = var2_8 + var8_8

		local var9_8 = math.ceil(var2_8)

		if var9_8 == arg2_8 - 1 then
			var3_8 = var1_8
		elseif arg2_8 < var9_8 then
			var5_8 = true

			break
		end
	end

	if var3_8 == 0 or var4_8 < var3_8 or not var5_8 then
		return arg1_8
	end

	return string.sub(arg1_8, 1, var3_8 - 1) .. ".."
end

function var0_0.clear(arg0_10)
	if LeanTween.isTweening(arg0_10.infoTF) then
		LeanTween.cancel(arg0_10.infoTF)
	end
end

function var0_0.Dispose(arg0_11)
	arg0_11:clear()
end

return var0_0

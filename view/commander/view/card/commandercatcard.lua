local var0_0 = class("CommanderCatCard")

var0_0.MARK_TYPE_CIRCLE = 1
var0_0.MARK_TYPE_TICK = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)
	arg0_1.infoTF = arg0_1._tf:Find("info")
	arg0_1.emptyTF = arg0_1._tf:Find("empty")
	arg0_1.quitTF = arg0_1._tf:Find("quit")
	arg0_1.scrollTxt = arg0_1.infoTF:Find("name_bg/mask/Text"):GetComponent("ScrollText")
	arg0_1.levelTF = arg0_1.infoTF:Find("level_bg/Text"):GetComponent(typeof(Text))
	arg0_1.iconTF = arg0_1.infoTF:Find("icon")
	arg0_1.marks = {
		arg0_1.infoTF:Find("mark1"),
		arg0_1.infoTF:Find("mark2")
	}
	arg0_1.expUp = arg0_1._tf:Find("up")
	arg0_1.formationTF = arg0_1.infoTF:Find("formation")

	setActive(arg0_1.formationTF, false)

	arg0_1.inbattleTF = arg0_1.infoTF:Find("inbattle")

	setActive(arg0_1.inbattleTF, false)

	arg0_1.tip = arg0_1._tf:Find("tip")

	setActive(arg0_1.tip, false)

	arg0_1.lockTr = arg0_1._tf:Find("lock")

	for iter0_1, iter1_1 in ipairs(arg0_1.marks) do
		setActive(iter1_1, false)
	end

	arg0_1.mark = arg0_1.marks[arg2_1] or arg0_1.marks[1]

	setActive(arg0_1.expUp, false)
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2)
	if not IsNil(arg0_2.lockTr) then
		setActive(arg0_2.lockTr, false)
	end

	if arg1_2 then
		arg0_2.commanderVO = arg1_2

		if arg1_2.id ~= 0 then
			arg0_2:UpdateCommander(arg2_2, arg3_2)
		end
	end

	setActive(arg0_2.formationTF, arg1_2 and arg1_2.inFleet and not arg1_2.inBattle)
	setActive(arg0_2.inbattleTF, arg1_2 and arg1_2.inBattle)
	setActive(arg0_2.infoTF, arg1_2 and arg1_2.id ~= 0)
	setActive(arg0_2.emptyTF, not arg1_2)
	setActive(arg0_2.quitTF, arg1_2 and arg1_2.id == 0)
	setActive(arg0_2.tip, arg1_2 and arg1_2.id ~= 0 and arg1_2:getTalentPoint() > 0 and not LOCK_COMMANDER_TALENT_TIP)
end

function var0_0.UpdateCommander(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3.commanderVO

	arg0_3.levelTF.text = var0_3.level

	GetImageSpriteFromAtlasAsync("commandericon/" .. var0_3:getPainting(), "", arg0_3.iconTF)

	if not IsNil(arg0_3.lockTr) then
		setActive(arg0_3.lockTr, var0_3:isLocked())
	end

	arg0_3:UpdateSelected(arg1_3, arg2_3)
end

function var0_0.UpdateSelected(arg0_4, arg1_4, arg2_4)
	if not arg0_4.commanderVO then
		setActive(arg0_4.mark, false)

		return
	end

	local var0_4 = arg1_4 or {}
	local var1_4 = table.contains(var0_4, arg0_4.commanderVO.id)

	setActive(arg0_4.mark, var1_4)
	arg0_4:UpdateCommanderName(var1_4, arg2_4)
end

function var0_0.UpdateCommanderName(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5.commanderVO

	if not var0_5 or var0_5.id == 0 then
		arg0_5.scrollTxt:SetText("")

		return
	end

	if arg1_5 then
		arg0_5.scrollTxt:SetText(var0_5:getName(arg2_5))
	else
		arg0_5.scrollTxt:SetText(CommanderCatUtil.ShortenString(var0_5:getName(arg2_5), 6))
	end
end

function var0_0.Dispose(arg0_6)
	return
end

return var0_0

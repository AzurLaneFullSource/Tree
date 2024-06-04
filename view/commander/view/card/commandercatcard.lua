local var0 = class("CommanderCatCard")

var0.MARK_TYPE_CIRCLE = 1
var0.MARK_TYPE_TICK = 2

function var0.Ctor(arg0, arg1, arg2)
	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0.infoTF = arg0._tf:Find("info")
	arg0.emptyTF = arg0._tf:Find("empty")
	arg0.quitTF = arg0._tf:Find("quit")
	arg0.scrollTxt = arg0.infoTF:Find("name_bg/mask/Text"):GetComponent("ScrollText")
	arg0.levelTF = arg0.infoTF:Find("level_bg/Text"):GetComponent(typeof(Text))
	arg0.iconTF = arg0.infoTF:Find("icon")
	arg0.marks = {
		arg0.infoTF:Find("mark1"),
		arg0.infoTF:Find("mark2")
	}
	arg0.expUp = arg0._tf:Find("up")
	arg0.formationTF = arg0.infoTF:Find("formation")

	setActive(arg0.formationTF, false)

	arg0.inbattleTF = arg0.infoTF:Find("inbattle")

	setActive(arg0.inbattleTF, false)

	arg0.tip = arg0._tf:Find("tip")

	setActive(arg0.tip, false)

	arg0.lockTr = arg0._tf:Find("lock")

	for iter0, iter1 in ipairs(arg0.marks) do
		setActive(iter1, false)
	end

	arg0.mark = arg0.marks[arg2] or arg0.marks[1]

	setActive(arg0.expUp, false)
end

function var0.Update(arg0, arg1, arg2, arg3)
	if not IsNil(arg0.lockTr) then
		setActive(arg0.lockTr, false)
	end

	if arg1 then
		arg0.commanderVO = arg1

		if arg1.id ~= 0 then
			arg0:UpdateCommander(arg2, arg3)
		end
	end

	setActive(arg0.formationTF, arg1 and arg1.inFleet and not arg1.inBattle)
	setActive(arg0.inbattleTF, arg1 and arg1.inBattle)
	setActive(arg0.infoTF, arg1 and arg1.id ~= 0)
	setActive(arg0.emptyTF, not arg1)
	setActive(arg0.quitTF, arg1 and arg1.id == 0)
	setActive(arg0.tip, arg1 and arg1.id ~= 0 and arg1:getTalentPoint() > 0 and not LOCK_COMMANDER_TALENT_TIP)
end

function var0.UpdateCommander(arg0, arg1, arg2)
	local var0 = arg0.commanderVO

	arg0.levelTF.text = var0.level

	GetImageSpriteFromAtlasAsync("commandericon/" .. var0:getPainting(), "", arg0.iconTF)

	if not IsNil(arg0.lockTr) then
		setActive(arg0.lockTr, var0:isLocked())
	end

	arg0:UpdateSelected(arg1, arg2)
end

function var0.UpdateSelected(arg0, arg1, arg2)
	if not arg0.commanderVO then
		setActive(arg0.mark, false)

		return
	end

	local var0 = arg1 or {}
	local var1 = table.contains(var0, arg0.commanderVO.id)

	setActive(arg0.mark, var1)
	arg0:UpdateCommanderName(var1, arg2)
end

function var0.UpdateCommanderName(arg0, arg1, arg2)
	local var0 = arg0.commanderVO

	if not var0 or var0.id == 0 then
		arg0.scrollTxt:SetText("")

		return
	end

	if arg1 then
		arg0.scrollTxt:SetText(var0:getName(arg2))
	else
		arg0.scrollTxt:SetText(CommanderCatUtil.ShortenString(var0:getName(arg2), 6))
	end
end

function var0.Dispose(arg0)
	return
end

return var0

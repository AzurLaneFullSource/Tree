local var0_0 = class("RandomDockYardCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.npcTr = findTF(arg0_1._tf, "content/dockyard/npc")
	arg0_1.nameTF = findTF(arg0_1._tf, "content/info/name_mask/name")
	arg0_1.lockTr = findTF(arg0_1._tf, "content/dockyard/container/lock")
	arg0_1.selected = findTF(arg0_1._tf, "content/front/selected")
	arg0_1.existAnim = false

	ClearTweenItemAlphaAndWhite(arg0_1._go)
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	TweenItemAlphaAndWhite(arg0_2._go)

	if not arg0_2.ship or arg0_2.ship.id ~= arg1_2.id then
		arg0_2.ship = arg1_2

		arg0_2:Flush()
	end

	arg0_2:UpdateSelected(arg2_2)
end

function var0_0.UpdateSelected(arg0_3, arg1_3)
	setActive(arg0_3.selected, arg1_3)

	if not arg1_3 then
		arg0_3.existAnim = false

		LeanTween.cancel(arg0_3.selected.gameObject)
	elseif arg0_3.existAnim then
		-- block empty
	else
		arg0_3.existAnim = true

		blinkAni(arg0_3.selected, 0.6, -1, 0.3):setFrom(1)
	end
end

function var0_0.Flush(arg0_4)
	local var0_4 = arg0_4.ship

	flushShipCard(arg0_4._tf, var0_4)
	setActive(arg0_4.npcTr, var0_4:isActivityNpc())
	setText(arg0_4.nameTF, var0_4:GetColorName(shortenString(var0_4:getName(), PLATFORM_CODE == PLATFORM_US and 6 or 7)))
	arg0_4.lockTr.gameObject:SetActive(var0_4:GetLockState() == Ship.LOCK_STATE_LOCK)
end

function var0_0.Dispose(arg0_5)
	ClearTweenItemAlphaAndWhite(arg0_5._go)
	arg0_5:UpdateSelected(false)
end

return var0_0

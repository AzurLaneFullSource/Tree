local var0 = class("RandomDockYardCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.npcTr = findTF(arg0._tf, "content/dockyard/npc")
	arg0.nameTF = findTF(arg0._tf, "content/info/name_mask/name")
	arg0.lockTr = findTF(arg0._tf, "content/dockyard/container/lock")
	arg0.selected = findTF(arg0._tf, "content/front/selected")
	arg0.existAnim = false

	ClearTweenItemAlphaAndWhite(arg0._go)
end

function var0.Update(arg0, arg1, arg2)
	TweenItemAlphaAndWhite(arg0._go)

	if not arg0.ship or arg0.ship.id ~= arg1.id then
		arg0.ship = arg1

		arg0:Flush()
	end

	arg0:UpdateSelected(arg2)
end

function var0.UpdateSelected(arg0, arg1)
	setActive(arg0.selected, arg1)

	if not arg1 then
		arg0.existAnim = false

		LeanTween.cancel(arg0.selected.gameObject)
	elseif arg0.existAnim then
		-- block empty
	else
		arg0.existAnim = true

		blinkAni(arg0.selected, 0.6, -1, 0.3):setFrom(1)
	end
end

function var0.Flush(arg0)
	local var0 = arg0.ship

	flushShipCard(arg0._tf, var0)
	setActive(arg0.npcTr, var0:isActivityNpc())
	setText(arg0.nameTF, var0:GetColorName(shortenString(var0:getName(), PLATFORM_CODE == PLATFORM_US and 6 or 7)))
	arg0.lockTr.gameObject:SetActive(var0:GetLockState() == Ship.LOCK_STATE_LOCK)
end

function var0.Dispose(arg0)
	ClearTweenItemAlphaAndWhite(arg0._go)
	arg0:UpdateSelected(false)
end

return var0

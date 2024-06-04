local var0 = class("ShipDetailCard")
local var1 = 0.5

function var0.Ctor(arg0, arg1, arg2)
	arg0.go = arg1
	arg0.tr = arg1.transform
	arg0.tagFlags = arg2 or {}
	arg0.toggle = GetOrAddComponent(arg0.tr, typeof(Toggle))
	arg0.content = findTF(arg0.tr, "content").gameObject
	arg0.quit = findTF(arg0.tr, "quit_button").gameObject
	arg0.detail = findTF(arg0.tr, "content/dockyard/detail").gameObject
	arg0.detailLayoutTr = findTF(arg0.detail, "layout")
	arg0.imageQuit = arg0.quit:GetComponent("Image")
	arg0.imageFrame = findTF(arg0.tr, "content/front/frame"):GetComponent("Image")
	arg0.labelName = findTF(arg0.tr, "content/info/name_mask/name")
	arg0.npc = findTF(arg0.tr, "content/dockyard/npc")

	setActive(arg0.npc, false)

	arg0.lock = findTF(arg0.tr, "content/dockyard/container/lock")
	arg0.maskStatusOb = findTF(arg0.tr, "content/front/status_mask")
	arg0.iconStatus = findTF(arg0.tr, "content/dockyard/status")
	arg0.iconStatusTxt = findTF(arg0.tr, "content/dockyard/status/Text"):GetComponent("Text")
	arg0.selectedGo = findTF(arg0.tr, "content/front/selected").gameObject
	arg0.energyTF = findTF(arg0.tr, "content/dockyard/container/energy")
	arg0.proposeTF = findTF(arg0.tr, "content/dockyard/propose")

	arg0.selectedGo:SetActive(false)

	arg0.hpBar = findTF(arg0.tr, "content/dockyard/blood")
end

function var0.update(arg0, arg1)
	if arg0.shipVO ~= arg1 then
		arg0.shipVO = arg1

		arg0:flush()
	end
end

function var0.updateSelected(arg0, arg1)
	arg0.selected = arg1

	arg0.selectedGo:SetActive(arg0.selected)

	if arg0.selected then
		if not arg0.selectedTw then
			arg0.selectedTw = LeanTween.alpha(arg0.selectedGo.transform, 1, var1):setFrom(0):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
		end
	elseif arg0.selectedTw then
		LeanTween.cancel(arg0.selectedTw.uniqueId)

		arg0.selectedTw = nil
	end
end

function var0.flush(arg0)
	local var0 = arg0.shipVO
	local var1 = tobool(var0)

	if var1 then
		if not var0:getConfigTable() then
			return
		end

		flushShipCard(arg0.tr, var0)

		local var2 = var0:isActivityNpc()

		setActive(arg0.npc, var2)

		if arg0.lock then
			arg0.lock.gameObject:SetActive(var0:GetLockState() == Ship.LOCK_STATE_LOCK)
		end

		local var3 = var0.energy <= Ship.ENERGY_MID

		if var3 then
			local var4 = GetSpriteFromAtlas("energy", var0:getEnergyPrint())

			if not var4 then
				warning("找不到疲劳")
			end

			setImageSprite(arg0.energyTF, var4)
		end

		setActive(arg0.energyTF, var3)
		setScrollText(arg0.labelName, var0:getName())

		local var5 = ShipStatus.ShipStatusToTag(var0, arg0.tagFlags)

		if var5 then
			arg0.iconStatusTxt.text = var5[3]

			GetSpriteFromAtlasAsync(var5[1], var5[2], function(arg0)
				setImageSprite(arg0.iconStatus, arg0, true)
				setActive(arg0.iconStatus, true)

				if var5[1] == "shipstatus" then
					arg0.iconStatus.sizeDelta = Vector2(195, 36)
					arg0.iconStatusTxt.fontSize = 30
				end
			end)
		else
			setActive(arg0.iconStatus, false)
		end

		local var6, var7 = var0:getIntimacyIcon()

		setActive(arg0.proposeTF, tobool(var7 and not var2))
	end

	arg0.content:SetActive(var1)
end

function var0.clear(arg0)
	if arg0.selectedTw then
		LeanTween.cancel(arg0.selectedTw.uniqueId)

		arg0.selectedTw = nil
	end
end

return var0

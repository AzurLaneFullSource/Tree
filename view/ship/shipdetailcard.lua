local var0_0 = class("ShipDetailCard")
local var1_0 = 0.5

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.go = arg1_1
	arg0_1.tr = arg1_1.transform
	arg0_1.tagFlags = arg2_1 or {}
	arg0_1.toggle = GetOrAddComponent(arg0_1.tr, typeof(Toggle))
	arg0_1.content = findTF(arg0_1.tr, "content").gameObject
	arg0_1.quit = findTF(arg0_1.tr, "quit_button").gameObject
	arg0_1.detail = findTF(arg0_1.tr, "content/dockyard/detail").gameObject
	arg0_1.detailLayoutTr = findTF(arg0_1.detail, "layout")
	arg0_1.imageQuit = arg0_1.quit:GetComponent("Image")
	arg0_1.imageFrame = findTF(arg0_1.tr, "content/front/frame"):GetComponent("Image")
	arg0_1.labelName = findTF(arg0_1.tr, "content/info/name_mask/name")
	arg0_1.npc = findTF(arg0_1.tr, "content/dockyard/npc")

	setActive(arg0_1.npc, false)

	arg0_1.lock = findTF(arg0_1.tr, "content/dockyard/container/lock")
	arg0_1.maskStatusOb = findTF(arg0_1.tr, "content/front/status_mask")
	arg0_1.iconStatus = findTF(arg0_1.tr, "content/dockyard/status")
	arg0_1.iconStatusTxt = findTF(arg0_1.tr, "content/dockyard/status/Text"):GetComponent("Text")
	arg0_1.selectedGo = findTF(arg0_1.tr, "content/front/selected").gameObject
	arg0_1.energyTF = findTF(arg0_1.tr, "content/dockyard/container/energy")
	arg0_1.proposeTF = findTF(arg0_1.tr, "content/dockyard/propose")

	arg0_1.selectedGo:SetActive(false)

	arg0_1.hpBar = findTF(arg0_1.tr, "content/dockyard/blood")
end

function var0_0.update(arg0_2, arg1_2)
	if arg0_2.shipVO ~= arg1_2 then
		arg0_2.shipVO = arg1_2

		arg0_2:flush()
	end
end

function var0_0.updateSelected(arg0_3, arg1_3)
	arg0_3.selected = arg1_3

	arg0_3.selectedGo:SetActive(arg0_3.selected)

	if arg0_3.selected then
		if not arg0_3.selectedTw then
			arg0_3.selectedTw = LeanTween.alpha(arg0_3.selectedGo.transform, 1, var1_0):setFrom(0):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
		end
	elseif arg0_3.selectedTw then
		LeanTween.cancel(arg0_3.selectedTw.uniqueId)

		arg0_3.selectedTw = nil
	end
end

function var0_0.flush(arg0_4)
	local var0_4 = arg0_4.shipVO
	local var1_4 = tobool(var0_4)

	if var1_4 then
		if not var0_4:getConfigTable() then
			return
		end

		flushShipCard(arg0_4.tr, var0_4)

		local var2_4 = var0_4:isActivityNpc()

		setActive(arg0_4.npc, var2_4)

		if arg0_4.lock then
			arg0_4.lock.gameObject:SetActive(var0_4:GetLockState() == Ship.LOCK_STATE_LOCK)
		end

		local var3_4 = var0_4.energy <= Ship.ENERGY_MID

		if var3_4 then
			local var4_4 = GetSpriteFromAtlas("energy", var0_4:getEnergyPrint())

			if not var4_4 then
				warning("找不到疲劳")
			end

			setImageSprite(arg0_4.energyTF, var4_4)
		end

		setActive(arg0_4.energyTF, var3_4)
		setScrollText(arg0_4.labelName, var0_4:getName())

		local var5_4 = ShipStatus.ShipStatusToTag(var0_4, arg0_4.tagFlags)

		if var5_4 then
			arg0_4.iconStatusTxt.text = var5_4[3]

			GetSpriteFromAtlasAsync(var5_4[1], var5_4[2], function(arg0_5)
				setImageSprite(arg0_4.iconStatus, arg0_5, true)
				setActive(arg0_4.iconStatus, true)

				if var5_4[1] == "shipstatus" then
					arg0_4.iconStatus.sizeDelta = Vector2(195, 36)
					arg0_4.iconStatusTxt.fontSize = 30
				end
			end)
		else
			setActive(arg0_4.iconStatus, false)
		end

		local var6_4, var7_4 = var0_4:getIntimacyIcon()

		setActive(arg0_4.proposeTF, tobool(var7_4 and not var2_4))
	end

	arg0_4.content:SetActive(var1_4)
end

function var0_0.clear(arg0_6)
	if arg0_6.selectedTw then
		LeanTween.cancel(arg0_6.selectedTw.uniqueId)

		arg0_6.selectedTw = nil
	end
end

return var0_0

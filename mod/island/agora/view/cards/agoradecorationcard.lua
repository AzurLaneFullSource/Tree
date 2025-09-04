local var0_0 = class("AgoraDecorationCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1.tr = arg1_1.transform
	arg0_1.icon = arg0_1.tr:Find("mask/icon"):GetComponent(typeof(Image))
	arg0_1.mark = arg0_1.tr:Find("mark")
	arg0_1.nameTxt = arg0_1.tr:Find("name"):GetComponent(typeof(Text))
	arg0_1.using = arg0_1.tr:Find("using")
	arg0_1.usingText = arg0_1.using:Find("Text"):GetComponent(typeof(Text))
	arg0_1.cntTr = arg0_1.tr:Find("cnt")
	arg0_1.cntTxt = arg0_1.tr:Find("cnt/Text"):GetComponent(typeof(Text))
	arg0_1.capcityTxt = arg0_1.tr:Find("capcity/Text"):GetComponent(typeof(Text))
	arg0_1.rarityTr = arg0_1.tr:Find("rarity"):GetComponent(typeof(Image))
	arg0_1.canInteractionTF = arg0_1.tr:Find("interaction")
	arg0_1.usingText.text = i18n("island_agora_using")
	arg0_1.longPressTriggerEvent = GetOrAddComponent(arg0_1._go, "LongPressTrigger").onLongPressed
	arg0_1.onReleasedEvent = GetOrAddComponent(arg0_1._go, "LongPressTrigger").onReleased
	arg0_1.onClickEvent = GetOrAddComponent(arg0_1._go, "LongPressTrigger").onClick
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.valueObject = arg1_2

	local var0_2 = arg1_2:GetFirstItem()

	arg0_2.nameTxt.text = shortenString(var0_2:GetName(), 5)

	setActive(arg0_2.using, arg1_2:IsUsing())
	arg0_2:UpdateSelected(arg2_2)

	local var1_2 = arg1_2:GetMaxCnt()

	arg0_2.cntTxt.text = var1_2 - arg1_2:GetAvailableCnt() .. "/" .. var1_2
	arg0_2.capcityTxt.text = var0_2:GetCost()

	local var2_2 = GetSpriteFromAtlas("ui/IslandDecorationUI_atlas", "r" .. var0_2:GetRarity())

	arg0_2.rarityTr.sprite = var2_2

	setActive(arg0_2.cntTr, not var0_2:IsOptionalShapeType())
	setActive(arg0_2.canInteractionTF, var0_2:CanInteraction())
	LoadSpriteAsync("island/IslandFurnitureIcon/" .. var0_2:GetIcon(), function(arg0_3)
		arg0_2.icon.sprite = arg0_3

		arg0_2.icon:SetNativeSize()
	end)
end

function var0_0.UpdateSelected(arg0_4, arg1_4)
	local var0_4 = arg0_4.valueObject:GetFirstItem()

	setActive(arg0_4.mark, var0_4.id == arg1_4)
end

function var0_0.Dispose(arg0_5)
	arg0_5.longPressTriggerEvent:RemoveAllListeners()
	arg0_5.onReleasedEvent:RemoveAllListeners()
	arg0_5.onClickEvent:RemoveAllListeners()
end

return var0_0

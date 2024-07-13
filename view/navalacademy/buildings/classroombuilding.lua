local var0_0 = class("ClassRoomBuilding", import(".NavalAcademyUpgradableBuilding"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.bubbleImg = arg0_1.bubble:Find("icon"):GetComponent(typeof(Image))
	arg0_1.floatImg = arg0_1.floatTF:GetComponent(typeof(Image))
	arg0_1.isUpdateIcon = false
end

function var0_0.UpdateBubble(arg0_2)
	local var0_2 = arg0_2:GetResField()
	local var1_2 = var0_2:GetGenResCnt() > 0

	setActive(arg0_2.bubble, var1_2)

	if var1_2 then
		arg0_2:FloatAni()
	end

	if not arg0_2.isUpdateIcon then
		local var2_2 = var0_2:GetResourceType()
		local var3_2 = Item.getConfigData(var2_2).icon

		arg0_2.bubbleImg.sprite = LoadSprite(var3_2)
		arg0_2.floatImg.sprite = LoadSprite(var3_2)

		onButton(arg0_2, arg0_2.bubble, function()
			local var0_3 = arg0_2:GetResField()

			arg0_2:emit(NavalAcademyMediator.ON_GET_CLASS_RES)
		end, SFX_PANEL)

		arg0_2.isUpdateIcon = true
	end
end

function var0_0.GetGameObjectName(arg0_4)
	return "classRoom"
end

function var0_0.GetTitle(arg0_5)
	return i18n("school_title_dajiangtang")
end

function var0_0.OnClick(arg0_6)
	arg0_6:emit(NavalAcademyMediator.ON_OPEN_CLASSROOM)
end

function var0_0.GetResField(arg0_7)
	return arg0_7.parent.classResField
end

return var0_0

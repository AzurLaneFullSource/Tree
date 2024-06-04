local var0 = class("ClassRoomBuilding", import(".NavalAcademyUpgradableBuilding"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.bubbleImg = arg0.bubble:Find("icon"):GetComponent(typeof(Image))
	arg0.floatImg = arg0.floatTF:GetComponent(typeof(Image))
	arg0.isUpdateIcon = false
end

function var0.UpdateBubble(arg0)
	local var0 = arg0:GetResField()
	local var1 = var0:GetGenResCnt() > 0

	setActive(arg0.bubble, var1)

	if var1 then
		arg0:FloatAni()
	end

	if not arg0.isUpdateIcon then
		local var2 = var0:GetResourceType()
		local var3 = Item.getConfigData(var2).icon

		arg0.bubbleImg.sprite = LoadSprite(var3)
		arg0.floatImg.sprite = LoadSprite(var3)

		onButton(arg0, arg0.bubble, function()
			local var0 = arg0:GetResField()

			arg0:emit(NavalAcademyMediator.ON_GET_CLASS_RES)
		end, SFX_PANEL)

		arg0.isUpdateIcon = true
	end
end

function var0.GetGameObjectName(arg0)
	return "classRoom"
end

function var0.GetTitle(arg0)
	return i18n("school_title_dajiangtang")
end

function var0.OnClick(arg0)
	arg0:emit(NavalAcademyMediator.ON_OPEN_CLASSROOM)
end

function var0.GetResField(arg0)
	return arg0.parent.classResField
end

return var0

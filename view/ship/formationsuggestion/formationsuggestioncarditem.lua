local var0_0 = class("FormationSuggestionCardItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.uiBtn, function()
		if arg0_2.id == nil or type(arg0_2.id) == "string" or pg.chapter_suggestion_char[arg0_2.id] == nil then
			return
		end

		arg0_2:emit(FormationSuggestionScene.OPEN_SHIP_INFO, arg0_2.id)
	end, SFX_PANEL)

	arg0_2.shipView = FormationSuggestionShipItem.New(tf(arg0_2.uiContentGo), arg0_2)
end

function var0_0.didEnter(arg0_4)
	return
end

function var0_0.SetData(arg0_5, arg1_5, arg2_5)
	arg0_5.id = arg1_5

	if arg1_5 == nil then
		arg0_5:ShowLock(true)

		return
	end

	arg0_5:ShowLock(false)

	if arg1_5 == 0 then
		arg0_5:ShowEmpty()

		return
	end

	if type(arg1_5) == "string" then
		arg0_5:ShowBundle()

		return
	end

	if pg.chapter_suggestion_char[arg1_5] == nil then
		arg0_5:ShowAnyType()

		return
	end

	arg0_5:ShowShip(arg2_5 == 1)
end

function var0_0.ShowLock(arg0_6, arg1_6)
	setActive(arg0_6.uiLockGo, arg1_6)
	setActive(arg0_6.uiUnLockGo, not arg1_6)
end

function var0_0.ShowEmpty(arg0_7)
	setActive(arg0_7.uiAnyGo, false)
	setActive(arg0_7.uiEmptyGo, true)
	setActive(arg0_7.uiContentGo, false)
end

function var0_0.ShowBundle(arg0_8)
	setActive(arg0_8.uiAnyGo, true)
	setActive(arg0_8.uiEmptyGo, true)
	setActive(arg0_8.uiContentGo, false)

	local var0_8 = ShipType.BundleList[arg0_8.id]

	setImageSprite(arg0_8.uiAnyTypeImage, GetSpriteFromAtlas("shiptype", shipType2print(var0_8[1])))

	local var1_8 = ""

	for iter0_8, iter1_8 in ipairs(var0_8) do
		if iter0_8 > 1 then
			var1_8 = var1_8 .. "/"
		end

		var1_8 = var1_8 .. pg.ship_data_by_type[iter1_8].type_name
	end

	setScrollText(arg0_8.uiAnyText, i18n("formation_suggestion_any_type_ship", var1_8))
end

function var0_0.ShowAnyType(arg0_9)
	setActive(arg0_9.uiAnyGo, true)
	setActive(arg0_9.uiEmptyGo, true)
	setActive(arg0_9.uiContentGo, false)
	setImageSprite(arg0_9.uiAnyTypeImage, GetSpriteFromAtlas("shiptype", shipType2print(arg0_9.id)))
	setScrollText(arg0_9.uiAnyText, i18n("formation_suggestion_any_type_ship", pg.ship_data_by_type[arg0_9.id].type_name))
end

function var0_0.ShowShip(arg0_10, arg1_10)
	setActive(arg0_10.uiAnyGo, false)
	setActive(arg0_10.uiEmptyGo, false)
	setActive(arg0_10.uiContentGo, true)
	arg0_10.shipView:SetData(arg0_10.id, arg1_10)
end

function var0_0.willExit(arg0_11)
	arg0_11.shipView:willExit()

	arg0_11.shipView = nil

	arg0_11:detach()
end

return var0_0

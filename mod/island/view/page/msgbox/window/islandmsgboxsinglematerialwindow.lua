local var0_0 = class("IslandMsgBoxSingleMaterialWindow", import(".IslandMsgBoxSingleItemWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxWithSingleMaterial"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.valueInput = arg0_2:findTF("calc/value/InputField")
	arg0_2.addBtn = arg0_2:findTF("calc/add")
	arg0_2.reduceBtn = arg0_2:findTF("calc/reduce")
	arg0_2.sellBtn = arg0_2:findTF("calc/sell_btn")
	arg0_2.priceTxt = arg0_2:findTF("calc/sell_btn/price/Text"):GetComponent(typeof(Text))

	LoadImageSpriteAsync("island/" .. getIslandSeasonPtInfo().icon, arg0_2:findTF("calc/sell_btn/price/res"))
	setText(arg0_2:findTF("calc/sell_btn/Text"), i18n("island_word_convert"))
end

function var0_0.OnShow(arg0_3)
	var0_0.super.OnShow(arg0_3)

	local var0_3 = arg0_3.settings

	onButton(arg0_3, arg0_3.addBtn, function()
		local var0_4 = arg0_3.value + 1

		arg0_3:UpdateValue(var0_4)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.reduceBtn, function()
		local var0_5 = arg0_3.value - 1

		arg0_3:UpdateValue(var0_5)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.sellBtn, function()
		arg0_3:Hide()

		if _IslandCore then
			_IslandCore:GetView():NotifiyIsland(ISLAND_EX_EVT.SHOW_MSG, {
				content = i18n("island_season_window_transformtip"),
				onYes = function()
					arg0_3:emit(IslandMediator.ON_CONVERT_SEASON_PT, {
						{
							id = arg0_3.item.id,
							num = arg0_3.value
						}
					})
				end
			})
		end
	end, SFX_PANEL)
	onInputEndEdit(arg0_3, arg0_3.valueInput, function(arg0_8)
		local var0_8 = 0

		if not arg0_8 or arg0_8 == "" or not tonumber(arg0_8) then
			local var1_8 = 1
		end

		local var2_8 = tonumber(arg0_8)

		arg0_3:UpdateValue(var2_8)
	end)
	arg0_3:bind(GAME.ISLAND_CONVERT_SEASON_PT_DONE, function()
		arg0_3:FlushCalc(arg0_3.item.id)
	end)

	local var1_3 = var0_3.itemId

	arg0_3:FlushCalc(var1_3)
end

function var0_0.FlushCalc(arg0_10, arg1_10)
	arg0_10.item = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetItemById(arg1_10) or IslandItem.New({
		id = arg1_10
	})
	arg0_10.value = 1

	arg0_10:UpdateValue(arg0_10.value)
end

function var0_0.UpdateValue(arg0_11, arg1_11)
	arg0_11.value = math.max(1, math.min(arg1_11, arg0_11.item:GetCount()))
	arg0_11.priceTxt.text = "x" .. arg0_11.item:GetConvertPt() * arg0_11.value

	setInputText(arg0_11.valueInput, arg0_11.value)
end

return var0_0

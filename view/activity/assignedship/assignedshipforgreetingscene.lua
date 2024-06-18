local var0_0 = class("AssignedShipForGreetingScene", import(".BaseAssignedShipScene"))
local var1_0 = {
	select_panel_7 = {
		Vector2(80, -110),
		Vector2(80, -330),
		Vector2(80, -550),
		Vector2(80, -770),
		Vector2(240, -160),
		Vector2(240, -380),
		Vector2(240, -600)
	}
}

function var0_0.getUIName(arg0_1)
	return "AssignedShipUI6"
end

function var0_0.init(arg0_2)
	local var0_2 = arg0_2._tf:Find("layer")

	arg0_2.backBtn = var0_2:Find("top/back")
	arg0_2.confirmBtn = var0_2:Find("confirm")
	arg0_2.print = var0_2:Find("print")
	arg0_2.rtName = var0_2:Find("name")
	arg0_2.rtTitle = var0_2:Find("top/title")
	arg0_2.selectTarget = nil
	arg0_2.count = 1
	arg0_2.spList = {}
	arg0_2.afterAnima = {}
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n(arg0_3.strTip, pg.ship_data_statistics[arg0_3.selectedShipNumber].name),
			onYes = function()
				arg0_3:emit(AssignedShipMediator.ON_USE_ITEM, arg0_3.itemVO.id, arg0_3.count, {
					arg0_3.idList[arg0_3.selectTarget]
				})
			end
		})
	end, SFX_PANEL)
	setActive(arg0_3.rtTitle, arg0_3.title)

	if arg0_3.title then
		GetImageSpriteFromAtlasAsync("extra_page/" .. arg0_3.style .. "/" .. arg0_3.title, "", arg0_3.rtTitle, true)
	end

	local var0_3 = #arg0_3.shipIdList
	local var1_3 = "select_panel_" .. var0_3

	setActive(arg0_3._tf:Find("layer/" .. var1_3), true)

	arg0_3.selectPanel = arg0_3._tf:Find("layer/" .. var1_3 .. "/layout")
	arg0_3.itemList = UIItemList.New(arg0_3.selectPanel, arg0_3.selectPanel:Find("item"))

	arg0_3.itemList:make(function(arg0_7, arg1_7, arg2_7)
		arg1_7 = arg1_7 + 1

		if var1_0[var1_3] then
			setAnchoredPosition(arg2_7, var1_0[var1_3][arg1_7])
		end

		local var0_7 = arg0_3.shipIdList[arg1_7]

		if arg0_7 == UIItemList.EventUpdate then
			GetImageSpriteFromAtlasAsync("extra_page/" .. arg0_3.style .. "/i_" .. var0_7, "", arg2_7:Find("unselected/icon"))
			GetImageSpriteFromAtlasAsync("extra_page/" .. arg0_3.style .. "/i_" .. var0_7, "", arg2_7:Find("selected/icon"))
			onToggle(arg0_3, arg2_7, function(arg0_8)
				if arg0_8 and arg0_3.selectTarget ~= arg1_7 then
					LeanTween.cancel(arg0_3.print)

					if arg0_3.rtName then
						LeanTween.cancel(arg0_3.rtName)
					end

					arg0_3:setSelectTarget(arg1_7)
				end
			end, SFX_PANEL)
		end
	end)
	arg0_3.itemList:align(#arg0_3.idList)
	triggerToggle(arg0_3.selectPanel:GetChild(0), true)
end

return var0_0

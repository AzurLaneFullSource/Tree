local var0 = class("AssignedShipForGreetingScene", import(".BaseAssignedShipScene"))
local var1 = {
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

function var0.getUIName(arg0)
	return "AssignedShipUI6"
end

function var0.init(arg0)
	local var0 = arg0._tf:Find("layer")

	arg0.backBtn = var0:Find("top/back")
	arg0.confirmBtn = var0:Find("confirm")
	arg0.print = var0:Find("print")
	arg0.rtName = var0:Find("name")
	arg0.rtTitle = var0:Find("top/title")
	arg0.selectTarget = nil
	arg0.count = 1
	arg0.spList = {}
	arg0.afterAnima = {}
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0, arg0.confirmBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n(arg0.strTip, pg.ship_data_statistics[arg0.selectedShipNumber].name),
			onYes = function()
				arg0:emit(AssignedShipMediator.ON_USE_ITEM, arg0.itemVO.id, arg0.count, {
					arg0.idList[arg0.selectTarget]
				})
			end
		})
	end, SFX_PANEL)
	setActive(arg0.rtTitle, arg0.title)

	if arg0.title then
		GetImageSpriteFromAtlasAsync("extra_page/" .. arg0.style .. "/" .. arg0.title, "", arg0.rtTitle, true)
	end

	local var0 = #arg0.shipIdList
	local var1 = "select_panel_" .. var0

	setActive(arg0._tf:Find("layer/" .. var1), true)

	arg0.selectPanel = arg0._tf:Find("layer/" .. var1 .. "/layout")
	arg0.itemList = UIItemList.New(arg0.selectPanel, arg0.selectPanel:Find("item"))

	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if var1[var1] then
			setAnchoredPosition(arg2, var1[var1][arg1])
		end

		local var0 = arg0.shipIdList[arg1]

		if arg0 == UIItemList.EventUpdate then
			GetImageSpriteFromAtlasAsync("extra_page/" .. arg0.style .. "/i_" .. var0, "", arg2:Find("unselected/icon"))
			GetImageSpriteFromAtlasAsync("extra_page/" .. arg0.style .. "/i_" .. var0, "", arg2:Find("selected/icon"))
			onToggle(arg0, arg2, function(arg0)
				if arg0 and arg0.selectTarget ~= arg1 then
					LeanTween.cancel(arg0.print)

					if arg0.rtName then
						LeanTween.cancel(arg0.rtName)
					end

					arg0:setSelectTarget(arg1)
				end
			end, SFX_PANEL)
		end
	end)
	arg0.itemList:align(#arg0.idList)
	triggerToggle(arg0.selectPanel:GetChild(0), true)
end

return var0

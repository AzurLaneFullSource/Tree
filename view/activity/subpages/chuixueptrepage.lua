local var0 = class("ChuixuePTRePage", import(".TemplatePage.PtTemplatePage"))

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)

	var0.scrolltext = arg0:findTF("name", arg0.awardTF)

	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.GO_SHOPS_LAYER_STEEET, {
			warp = NewShopsScene.TYPE_SHOP_STREET
		})
	end)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	arg0:SetAwardName()

	local var0, var1, var2 = arg0.ptData:GetResProgress()

	setText(arg0.progress, (var2 >= 1 and setColorStr(var0, "#A2A2A2FF") or var0) .. "/" .. var1)
end

function var0.SetAwardName(arg0)
	local var0 = arg0.ptData:GetAward()

	if Item.getConfigData(var0.id) then
		changeToScrollText(var0.scrolltext, var0:getName())
	else
		setActive(arg0:findTF("name", arg0.awardTF), false)
	end
end

return var0

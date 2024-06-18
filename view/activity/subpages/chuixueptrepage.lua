local var0_0 = class("ChuixuePTRePage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)

	var0_0.scrolltext = arg0_1:findTF("name", arg0_1.awardTF)

	onButton(arg0_1, arg0_1.battleBtn, function()
		arg0_1:emit(ActivityMediator.GO_SHOPS_LAYER_STEEET, {
			warp = NewShopsScene.TYPE_SHOP_STREET
		})
	end)
end

function var0_0.OnUpdateFlush(arg0_3)
	var0_0.super.OnUpdateFlush(arg0_3)
	arg0_3:SetAwardName()

	local var0_3, var1_3, var2_3 = arg0_3.ptData:GetResProgress()

	setText(arg0_3.progress, (var2_3 >= 1 and setColorStr(var0_3, "#A2A2A2FF") or var0_3) .. "/" .. var1_3)
end

function var0_0.SetAwardName(arg0_4)
	local var0_4 = arg0_4.ptData:GetAward()

	if Item.getConfigData(var0_4.id) then
		changeToScrollText(var0_0.scrolltext, var0_4:getName())
	else
		setActive(arg0_4:findTF("name", arg0_4.awardTF), false)
	end
end

return var0_0

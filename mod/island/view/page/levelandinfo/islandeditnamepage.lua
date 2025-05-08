local var0_0 = class("IslandEditNamePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandEditNameui"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.input = arg0_2:findTF("frame/name/InputField")
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.confirmBtn = arg0_2:findTF("frame/confirm")
	arg0_2.content = arg0_2:findTF("frame/Text")

	setText(arg0_2:findTF("frame/title"), i18n1("岛屿名称修改"))
	setText(arg0_2:findTF("frame/confirm/Text"), i18n1("确定"))
	setText(arg0_2:findTF("frame/name/InputField/Placeholder"), i18n1("点击输入名称"))
end

function var0_0.AddListeners(arg0_3)
	arg0_3:AddListener(GAME.ISLAND_SET_NAME_DONE, arg0_3.OnModifyName)
end

function var0_0.RemoveListeners(arg0_4)
	arg0_4:RemoveListener(GAME.ISLAND_SET_NAME_DONE, arg0_4.OnModifyName)
end

function var0_0.OnModifyName(arg0_5)
	arg0_5:Hide()

	if arg0_5.callback then
		arg0_5.callback()
	end
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6._tf, function()
		arg0_6:Hide()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.closeBtn, function()
		arg0_6:Hide()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.confirmBtn, function()
		local var0_9 = getInputText(arg0_6.input)

		arg0_6:emit(IslandMediator.SET_NAME, var0_9, 1)
	end, SFX_PANEL)
end

function var0_0.Show(arg0_10, arg1_10)
	var0_0.super.Show(arg0_10)

	arg0_10.callback = arg1_10

	arg0_10:UpdateContent()
	pg.UIMgr.GetInstance():OverlayPanel(arg0_10._tf, {
		weight = LayerWeightConst.SECOND_LAYER + 1
	})
end

function var0_0.Hide(arg0_11)
	var0_0.super.Hide(arg0_11)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11._tf, arg0_11._parentTf)
end

function var0_0.UpdateContent(arg0_12)
	setInputText(arg0_12.input, "")

	local var0_12 = getProxy(IslandProxy):GetIsland():GetModifyNameConsume()
	local var1_12 = Drop.New({
		type = var0_12[1],
		id = var0_12[2],
		count = var0_12[3]
	})
	local var2_12 = var1_12:getName()
	local var3_12 = var1_12:getOwnedCount()
	local var4_12 = var3_12 < var1_12.count and "#f36c6e" or "#39bfff"
	local var5_12 = setColorStr(var3_12 .. "/" .. var1_12.count, var4_12)

	setText(arg0_12.content, i18n1("名称最长为9个汉字，更名需要消耗") .. var2_12 .. var5_12)
end

function var0_0.OnDestroy(arg0_13)
	arg0_13.callback = nil
end

return var0_0

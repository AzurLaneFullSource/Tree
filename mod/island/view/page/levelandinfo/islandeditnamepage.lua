local var0_0 = class("IslandEditNamePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandEditNameui"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.input = arg0_2:findTF("frame/name/InputField")
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.confirmBtn = arg0_2:findTF("frame/confirm")
	arg0_2.content = arg0_2:findTF("frame/Text")

	setText(arg0_2:findTF("frame/title"), i18n("island_rename_title"))
	setText(arg0_2:findTF("frame/confirm/Text"), i18n("word_ok"))
	setText(arg0_2:findTF("frame/name/InputField/Placeholder"), i18n("island_rename_input_tip"))

	arg0_2.animator = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.aniDft = arg0_2._tf:GetComponent(typeof(DftAniEvent))
	arg0_2.isPlayingAnimation = false
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

	arg0_10.isPlayingAnimation = false
	arg0_10.callback = arg1_10

	arg0_10:UpdateContent()
	pg.UIMgr.GetInstance():OverlayPanel(arg0_10._tf, {
		weight = LayerWeightConst.SECOND_LAYER + 1
	})
end

function var0_0.Hide(arg0_11)
	if arg0_11.isPlayingAnimation then
		return
	end

	arg0_11:PlayExitAniamtion(function()
		arg0_11.isPlayingAnimation = false

		arg0_11.aniDft:SetEndEvent(nil)
		var0_0.super.Hide(arg0_11)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11._tf, arg0_11._parentTf)
	end)
end

function var0_0.PlayExitAniamtion(arg0_13, arg1_13)
	arg0_13.isPlayingAnimation = true

	arg0_13.aniDft:SetEndEvent(function()
		if arg1_13 then
			arg1_13()
		end
	end)
	arg0_13.animator:Play("anim_IslandEditNameUI_Out")
end

function var0_0.UpdateContent(arg0_15)
	setInputText(arg0_15.input, "")

	local var0_15 = getProxy(IslandProxy):GetIsland():GetModifyNameConsume()
	local var1_15 = Drop.New({
		type = var0_15[1],
		id = var0_15[2],
		count = var0_15[3]
	})
	local var2_15 = var1_15:getName()
	local var3_15 = var1_15:getOwnedCount()
	local var4_15 = var3_15 < var1_15.count and "#f36c6e" or "#39bfff"
	local var5_15 = setColorStr(var3_15 .. "/" .. var1_15.count, var4_15)

	setText(arg0_15.content, i18n("island_rename_consutme_tip", var2_15 .. var5_15))
end

function var0_0.OnDestroy(arg0_16)
	arg0_16.callback = nil

	arg0_16.aniDft:SetEndEvent(nil)
end

return var0_0

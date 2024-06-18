local var0_0 = class("CommanderResetTalentPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderCatResetTalentUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.resetCancelBtn = arg0_2:findTF("bg/frame/cancel_btn")
	arg0_2.resetConfirmBtn = arg0_2:findTF("bg/frame/confirm_btn")
	arg0_2.resetCloseBtn = arg0_2:findTF("bg/frame/close_btn")
	arg0_2.resetGoldTxt = arg0_2:findTF("bg/frame/bg/tip/texts/Text"):GetComponent(typeof(Text))
	arg0_2.resetPointTxt = arg0_2:findTF("bg/frame/bg/tip/texts1/Text"):GetComponent(typeof(Text))
	arg0_2.resetList = UIItemList.New(arg0_2:findTF("bg/frame/bg/talents/content"), arg0_2:findTF("bg/frame/bg/talents/content/talent_tpl"))

	local var0_2 = i18n("commander_choice_talent_reset")
	local var1_2 = string.split(var0_2, "$1")
	local var2_2 = string.split(var1_2[2], "\t")
	local var3_2 = string.split(var2_2[2], "$2")

	setText(arg0_2:findTF("bg/frame/bg/tip/texts/label"), var1_2[1] .. " ")
	setText(arg0_2:findTF("bg/frame/bg/tip/texts/label1"), " " .. var2_2[1])
	setText(arg0_2:findTF("bg/frame/bg/tip/texts1/label"), var3_2[1] .. " ")
	setText(arg0_2:findTF("bg/frame/bg/tip/texts1/label1"), " " .. var3_2[2])
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.resetCloseBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.resetCancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.resetConfirmBtn, function()
		if arg0_3.commanderVO then
			local var0_7 = getProxy(PlayerProxy):getRawData()

			if var0_7.gold < arg0_3.total then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
					{
						59001,
						arg0_3.total - var0_7.gold,
						arg0_3.total
					}
				})

				return
			end

			arg0_3.contextData.msgBox:ExecuteAction("Show", {
				content = i18n("commander_reset_talent_tip"),
				onYes = function()
					arg0_3:emit(CommanderCatMediator.RESET_TALENT, arg0_3.commanderVO.id)
					arg0_3:Hide()
				end
			})
		end
	end, SFX_PANEL)
end

function var0_0.Show(arg0_9, arg1_9)
	var0_0.super.Show(arg0_9)
	arg0_9._tf:SetAsLastSibling()

	arg0_9.commanderVO = arg1_9

	arg0_9:Flush()
end

function var0_0.Flush(arg0_10)
	local var0_10 = arg0_10.commanderVO
	local var1_10 = var0_10:getTalentOrigins()

	arg0_10.resetList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg0_10:UpdateTalentCard(arg2_11, var1_10[arg1_11 + 1])
		end
	end)
	arg0_10.resetList:align(#var1_10)

	local var2_10 = getProxy(PlayerProxy):getRawData()

	arg0_10.total = var0_10:getResetTalentConsume()
	arg0_10.resetGoldTxt.text = var2_10.gold < arg0_10.total and "<color=" .. COLOR_RED .. ">" .. arg0_10.total .. "</color>" or arg0_10.total
	arg0_10.resetPointTxt.text = var0_10:getTotalPoint()
	GetComponent(arg0_10.resetGoldTxt, typeof(Outline)).enabled = var2_10.gold >= arg0_10.total
end

function var0_0.UpdateTalentCard(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg1_12:Find("unlock")
	local var1_12 = arg1_12:Find("lock")

	if arg2_12 then
		GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. arg2_12:getConfig("icon"), "", var0_12:Find("icon"))

		local var2_12 = var0_12:Find("tree_btn")

		if var2_12 then
			onButton(arg0_12, var2_12, function()
				arg0_12.contextData.treePanel:ExecuteAction("Show", arg2_12)
			end, SFX_PANEL)
		end

		setText(var0_12:Find("name_bg/Text"), arg2_12:getConfig("name"))
		setScrollText(var0_12:Find("desc/Text"), arg2_12:getConfig("desc"))
	end

	setActive(var0_12, arg2_12)

	if var1_12 then
		setActive(var1_12, not arg2_12)
	end
end

function var0_0.OnDestroy(arg0_14)
	return
end

return var0_0

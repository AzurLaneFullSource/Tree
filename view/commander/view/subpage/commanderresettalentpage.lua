local var0 = class("CommanderResetTalentPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "CommanderCatResetTalentUI"
end

function var0.OnLoaded(arg0)
	arg0.resetCancelBtn = arg0:findTF("bg/frame/cancel_btn")
	arg0.resetConfirmBtn = arg0:findTF("bg/frame/confirm_btn")
	arg0.resetCloseBtn = arg0:findTF("bg/frame/close_btn")
	arg0.resetGoldTxt = arg0:findTF("bg/frame/bg/tip/texts/Text"):GetComponent(typeof(Text))
	arg0.resetPointTxt = arg0:findTF("bg/frame/bg/tip/texts1/Text"):GetComponent(typeof(Text))
	arg0.resetList = UIItemList.New(arg0:findTF("bg/frame/bg/talents/content"), arg0:findTF("bg/frame/bg/talents/content/talent_tpl"))

	local var0 = i18n("commander_choice_talent_reset")
	local var1 = string.split(var0, "$1")
	local var2 = string.split(var1[2], "\t")
	local var3 = string.split(var2[2], "$2")

	setText(arg0:findTF("bg/frame/bg/tip/texts/label"), var1[1] .. " ")
	setText(arg0:findTF("bg/frame/bg/tip/texts/label1"), " " .. var2[1])
	setText(arg0:findTF("bg/frame/bg/tip/texts1/label"), var3[1] .. " ")
	setText(arg0:findTF("bg/frame/bg/tip/texts1/label1"), " " .. var3[2])
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.resetCloseBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.resetCancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.resetConfirmBtn, function()
		if arg0.commanderVO then
			local var0 = getProxy(PlayerProxy):getRawData()

			if var0.gold < arg0.total then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
					{
						59001,
						arg0.total - var0.gold,
						arg0.total
					}
				})

				return
			end

			arg0.contextData.msgBox:ExecuteAction("Show", {
				content = i18n("commander_reset_talent_tip"),
				onYes = function()
					arg0:emit(CommanderCatMediator.RESET_TALENT, arg0.commanderVO.id)
					arg0:Hide()
				end
			})
		end
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	arg0._tf:SetAsLastSibling()

	arg0.commanderVO = arg1

	arg0:Flush()
end

function var0.Flush(arg0)
	local var0 = arg0.commanderVO
	local var1 = var0:getTalentOrigins()

	arg0.resetList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateTalentCard(arg2, var1[arg1 + 1])
		end
	end)
	arg0.resetList:align(#var1)

	local var2 = getProxy(PlayerProxy):getRawData()

	arg0.total = var0:getResetTalentConsume()
	arg0.resetGoldTxt.text = var2.gold < arg0.total and "<color=" .. COLOR_RED .. ">" .. arg0.total .. "</color>" or arg0.total
	arg0.resetPointTxt.text = var0:getTotalPoint()
	GetComponent(arg0.resetGoldTxt, typeof(Outline)).enabled = var2.gold >= arg0.total
end

function var0.UpdateTalentCard(arg0, arg1, arg2)
	local var0 = arg1:Find("unlock")
	local var1 = arg1:Find("lock")

	if arg2 then
		GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. arg2:getConfig("icon"), "", var0:Find("icon"))

		local var2 = var0:Find("tree_btn")

		if var2 then
			onButton(arg0, var2, function()
				arg0.contextData.treePanel:ExecuteAction("Show", arg2)
			end, SFX_PANEL)
		end

		setText(var0:Find("name_bg/Text"), arg2:getConfig("name"))
		setScrollText(var0:Find("desc/Text"), arg2:getConfig("desc"))
	end

	setActive(var0, arg2)

	if var1 then
		setActive(var1, not arg2)
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0

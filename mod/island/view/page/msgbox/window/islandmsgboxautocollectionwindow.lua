local var0_0 = class("IslandMsgBoxAutoCollectionWindow", import(".IslandBaseMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandAutomaticCollectionMsgBox"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.confirmBtn = arg0_2._tf:Find("container/btns/confirm")
	arg0_2.cancelBtn = arg0_2._tf:Find("container/btns/cancel")
	arg0_2.closeBtn = arg0_2._tf:Find("container/close")
	arg0_2.cancelTxt = arg0_2._tf:Find("container/btns/cancel/Text"):GetComponent(typeof(Text))
	arg0_2.confirmTxt = arg0_2._tf:Find("container/btns/confirm/Text"):GetComponent(typeof(Text))
	arg0_2.cancelTxt.text = i18n("word_cancel")
	arg0_2.confirmTxt.text = i18n("word_ok")

	setText(arg0_2.uigatherText, i18n("island_chara_gather_tag_1"))
	setText(arg0_2.uimineText, i18n("island_chara_gather_tag_2"))

	arg0_2.titleTxt = arg0_2._tf:Find("container/title"):GetComponent(typeof(Text))
	arg0_2.titleTxt.text = i18n("island_msg_info")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.uigather, function()
		local var0_6 = not (arg0_3.selectTypeDic[IslandAutoCollectHelper.SelectType.Gather] or false)

		arg0_3.selectTypeDic[IslandAutoCollectHelper.SelectType.Gather] = var0_6

		setActive(arg0_3.uigatherselected, var0_6)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.uimine, function()
		local var0_7 = not (arg0_3.selectTypeDic[IslandAutoCollectHelper.SelectType.HandCollection] or false)

		arg0_3.selectTypeDic[IslandAutoCollectHelper.SelectType.HandCollection] = var0_7

		setActive(arg0_3.uimineselected, var0_7)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		local var0_9 = arg0_3.selectTypeDic[IslandAutoCollectHelper.SelectType.Gather]
		local var1_9 = arg0_3.selectTypeDic[IslandAutoCollectHelper.SelectType.HandCollection]
		local var2_9 = IslandAutoCollectHelper.SelectType.None

		if var0_9 and var1_9 then
			var2_9 = IslandAutoCollectHelper.SelectType.Both
		elseif var0_9 then
			var2_9 = IslandAutoCollectHelper.SelectType.Gather
		elseif var1_9 then
			var2_9 = IslandAutoCollectHelper.SelectType.HandCollection
		end

		arg0_3.onYes(var2_9, function()
			arg0_3:Hide()
		end)
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_11)
	local var0_11 = arg0_11.settings

	arg0_11.onYes = var0_11.onYes
	arg0_11.onNo = var0_11.onNo
	arg0_11.onHide = var0_11.onHide
	arg0_11.selectTypeDic = {}

	setActive(arg0_11.uigatherselected, false)
	setActive(arg0_11.uimineselected, false)
end

function var0_0.OnHide(arg0_12)
	arg0_12.onYes = nil
	arg0_12.onNo = nil

	if arg0_12.onHide then
		arg0_12.onHide()

		arg0_12.onHide = nil
	end
end

return var0_0

local var0_0 = class("SculptureMsgBoxPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SculptureMsgboxUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.contentTxt = arg0_2:findTF("frame/Text"):GetComponent(typeof(Text))
	arg0_2.nextBtn = arg0_2:findTF("frame/btn")
	arg0_2.confirmBtn = arg0_2:findTF("frame/btn_confrim")
	arg0_2.consumeTr = arg0_2:findTF("frame/consume")
	arg0_2.consumeTxt = arg0_2:findTF("frame/consume/Text"):GetComponent(typeof(Text))
	arg0_2.consumeIcon = arg0_2:findTF("frame/consume/icon"):GetComponent(typeof(Image))
	arg0_2.role = arg0_2:findTF("frame/role"):GetComponent(typeof(Image))
	arg0_2.title = arg0_2:findTF("frame/title/Text"):GetComponent(typeof(Image))

	setText(arg0_2:findTF("frame/tip"), i18n("sculpture_close_tip"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3.settings.onYes then
			arg0_3.settings.onYes()
		end

		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.nextBtn, function()
		if arg0_3.settings.onYes then
			arg0_3.settings.onYes()
		end

		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7)
	var0_0.super.Show(arg0_7)

	arg0_7.settings = arg1_7
	arg0_7.contentTxt.text = HXSet.hxLan(arg1_7.content)

	setActive(arg0_7.consumeTr, arg1_7.consume)

	if arg1_7.consume then
		arg0_7.consumeTxt.text = arg1_7.consume

		local var0_7 = arg1_7.consumeId
		local var1_7 = pg.activity_workbench_item[var0_7]

		arg0_7.consumeIcon.sprite = LoadSprite("props/" .. var1_7.icon)
		rtf(arg0_7.consumeIcon.gameObject).sizeDelta = Vector2(60, 60)
	else
		rtf(arg0_7.consumeIcon.gameObject).sizeDelta = Vector2(0, 0)
	end

	if arg1_7.iconName then
		arg0_7:LoadChar(arg1_7.iconName)
	else
		arg0_7:ClearChar()
	end

	if arg1_7.title then
		arg0_7.title.sprite = GetSpriteFromAtlas("ui/SculptureUI_atlas", arg1_7.title)
	else
		arg0_7.title.sprite = GetSpriteFromAtlas("ui/SculptureUI_atlas", "item_title")
	end

	arg0_7.title:SetNativeSize()
	setActive(arg0_7.nextBtn, arg1_7.nextBtn)
	setActive(arg0_7.confirmBtn, not arg1_7.nextBtn)
end

function var0_0.LoadChar(arg0_8, arg1_8)
	if arg0_8.charName == arg1_8 then
		return
	end

	arg0_8:ClearChar()
	PoolMgr.GetInstance():GetSpineChar("takegift_" .. arg1_8, true, function(arg0_9)
		arg0_9.transform:SetParent(arg0_8.role.gameObject.transform.parent)

		arg0_9.transform.localScale = Vector3(0.8, 0.8, 0)
		arg0_9.transform.localPosition = Vector3(550, -300, 0)

		arg0_9:GetComponent(typeof(SpineAnimUI)):SetAction("gift_wait_" .. arg1_8, 0)

		arg0_8.charGo = arg0_9
	end)

	arg0_8.charName = arg1_8
end

function var0_0.ClearChar(arg0_10)
	if arg0_10.charName and arg0_10.charGo then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_10.charName, arg0_10.charGo)

		arg0_10.charName = nil
		arg0_10.charGo = nil
	end
end

function var0_0.OnDestroy(arg0_11)
	arg0_11:ClearChar()
end

return var0_0

local var0 = class("SculptureMsgBoxPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "SculptureMsgboxUI"
end

function var0.OnLoaded(arg0)
	arg0.contentTxt = arg0:findTF("frame/Text"):GetComponent(typeof(Text))
	arg0.nextBtn = arg0:findTF("frame/btn")
	arg0.confirmBtn = arg0:findTF("frame/btn_confrim")
	arg0.consumeTr = arg0:findTF("frame/consume")
	arg0.consumeTxt = arg0:findTF("frame/consume/Text"):GetComponent(typeof(Text))
	arg0.consumeIcon = arg0:findTF("frame/consume/icon"):GetComponent(typeof(Image))
	arg0.role = arg0:findTF("frame/role"):GetComponent(typeof(Image))
	arg0.title = arg0:findTF("frame/title/Text"):GetComponent(typeof(Image))

	setText(arg0:findTF("frame/tip"), i18n("sculpture_close_tip"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.settings.onYes then
			arg0.settings.onYes()
		end

		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.nextBtn, function()
		if arg0.settings.onYes then
			arg0.settings.onYes()
		end

		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	arg0.settings = arg1
	arg0.contentTxt.text = HXSet.hxLan(arg1.content)

	setActive(arg0.consumeTr, arg1.consume)

	if arg1.consume then
		arg0.consumeTxt.text = arg1.consume

		local var0 = arg1.consumeId
		local var1 = pg.activity_workbench_item[var0]

		arg0.consumeIcon.sprite = LoadSprite("props/" .. var1.icon)
		rtf(arg0.consumeIcon.gameObject).sizeDelta = Vector2(60, 60)
	else
		rtf(arg0.consumeIcon.gameObject).sizeDelta = Vector2(0, 0)
	end

	if arg1.iconName then
		arg0:LoadChar(arg1.iconName)
	else
		arg0:ClearChar()
	end

	if arg1.title then
		arg0.title.sprite = GetSpriteFromAtlas("ui/SculptureUI_atlas", arg1.title)
	else
		arg0.title.sprite = GetSpriteFromAtlas("ui/SculptureUI_atlas", "item_title")
	end

	arg0.title:SetNativeSize()
	setActive(arg0.nextBtn, arg1.nextBtn)
	setActive(arg0.confirmBtn, not arg1.nextBtn)
end

function var0.LoadChar(arg0, arg1)
	if arg0.charName == arg1 then
		return
	end

	arg0:ClearChar()
	PoolMgr.GetInstance():GetSpineChar("takegift_" .. arg1, true, function(arg0)
		arg0.transform:SetParent(arg0.role.gameObject.transform.parent)

		arg0.transform.localScale = Vector3(0.8, 0.8, 0)
		arg0.transform.localPosition = Vector3(550, -300, 0)

		arg0:GetComponent(typeof(SpineAnimUI)):SetAction("gift_wait_" .. arg1, 0)

		arg0.charGo = arg0
	end)

	arg0.charName = arg1
end

function var0.ClearChar(arg0)
	if arg0.charName and arg0.charGo then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.charName, arg0.charGo)

		arg0.charName = nil
		arg0.charGo = nil
	end
end

function var0.OnDestroy(arg0)
	arg0:ClearChar()
end

return var0

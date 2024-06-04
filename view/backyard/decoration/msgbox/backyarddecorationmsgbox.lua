local var0 = class("BackYardDecorationMsgBox", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "BackYardDecorationMsgBox"
end

function var0.OnLoaded(arg0)
	arg0.frame = arg0:findTF("frame")
	arg0.cancelBtn = arg0:findTF("frame/control/cancel_btn")
	arg0.deleteBtn = arg0:findTF("frame/control/delete_btn")
	arg0.saveBtn = arg0:findTF("frame/control/save_btn")
	arg0.applyBtn = arg0:findTF("frame/control/set_btn")
	arg0.input = arg0:findTF("frame/bound/input")
	arg0.inputField = arg0:findTF("frame/bound/input/InputField")
	arg0.desc = arg0:findTF("frame/bound/desc"):GetComponent(typeof(Text))
	arg0.icon = arg0:findTF("frame/bound/mask/Icon"):GetComponent(typeof(Image))
	arg0.iconRaw = arg0:findTF("frame/bound/mask/Icon_raw"):GetComponent(typeof(RawImage))
	arg0.title = arg0:findTF("frame/title"):GetComponent(typeof(Text))
	arg0.closeBtn = arg0:findTF("frame/close")
	arg0.innerMsgbox = arg0:findTF("msg")
	arg0.innerMsgboxContent = arg0.innerMsgbox:Find("bound/Text"):GetComponent(typeof(Text))
	arg0.innerMsgboxComfirmBtn = arg0.innerMsgbox:Find("btns/btn1")
	arg0.innerMsgboxCancelBtn = arg0.innerMsgbox:Find("btns/btn2")
	arg0.innerCloseBtn = arg0:findTF("msg/close")
	arg0.scrollTitleText = arg0.innerMsgbox:Find("bound/title"):GetComponent(typeof(Text))
	arg0.scrollText = arg0.innerMsgbox:Find("bound/scrollrect/Text"):GetComponent(typeof(Text))

	setText(arg0.cancelBtn:Find("Text"), i18n("word_cancel"))
	setText(arg0.deleteBtn:Find("Text"), i18n("word_delete"))
	setText(arg0.saveBtn:Find("Text"), i18n("word_save"))
	setText(arg0.applyBtn:Find("Text"), i18n("backyard_theme_word_apply"))
	setText(arg0.innerMsgboxComfirmBtn:Find("Text"), i18n("word_ok"))
	setText(arg0.innerMsgboxCancelBtn:Find("Text"), i18n("word_cancel"))
	setText(arg0.inputField:Find("Placeholder"), i18n("enter_theme_name"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		if arg0.showInnerMsg then
			arg0:HideInnerMsgBox()
		else
			arg0:Hide()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.innerCloseBtn, function()
		arg0:HideInnerMsgBox()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.deleteBtn, function()
		if arg0.theme:IsPushed() then
			arg0:ShowInnerMsgBox(i18n("backyard_decoration_theme_template_delete_tip"), function()
				arg0:emit(BackYardDecorationMediator.DELETE_THEME, arg0.theme.id)
				arg0:Hide()
			end, true)
		else
			arg0:emit(BackYardDecorationMediator.DELETE_THEME, arg0.theme.id)
			arg0:Hide()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.saveBtn, function()
		local var0 = getInputText(arg0.inputField)

		if wordVer(var0) > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_name_forbid"))

			return
		end

		arg0:emit(BackYardDecorationMediator.SAVE_THEME, arg0.theme.id, var0)
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.applyBtn, function()
		local function var0(arg0)
			return
		end

		arg0:emit(BackYardDecorationMediator.APPLY_THEME, arg0.theme, function(arg0, arg1)
			gcAll(false)

			if arg0 then
				arg0:emit(BackYardDecorationMediator.ADD_FURNITURES, arg0.theme.id, arg1, var0)
				arg0:Hide()
			else
				arg0:ShowInnerMsgBox(i18n("backyarad_theme_replace", arg0.theme:getName()), function()
					arg0:emit(BackYardDecorationMediator.ADD_FURNITURES, arg0.theme.id, arg1, var0)
					arg0:HideInnerMsgBox()
					arg0:Hide()
				end)
			end
		end)
	end, SFX_PANEL)
	onInputChanged(arg0, arg0.inputField, function()
		if not arg0.unEmpty then
			setText(arg0.desc, i18n("backyard_theme_save_tip"))
		end
	end)
end

function var0.Show(arg0, arg1, arg2)
	var0.super.Show(arg0)

	arg0.theme = arg1
	arg0.unEmpty = arg2

	if arg2 then
		arg0:ApplyTheme()
	else
		arg0:NewTheme()
	end

	arg0.title.text = arg2 and arg1:IsSystem() and i18n("courtyard_label_system_theme") or i18n("courtyard_label_custom_theme")

	setActive(arg0.frame, true)
	setActive(arg0._tf, true)
	setActive(arg0.innerMsgbox, false)
	setActive(arg0.input, not arg2)
	setActive(arg0.cancelBtn, not arg2)
	setActive(arg0.deleteBtn, arg2 and not arg1:IsSystem())
	setActive(arg0.applyBtn, arg2)
	setActive(arg0.saveBtn, not arg2)
	arg0._tf:SetAsLastSibling()
end

function var0.RemoveSizeTag(arg0, arg1)
	local var0 = string.gsub(arg1, "</size>", "")

	return string.gsub(var0, "<size=%d+>", "")
end

function var0.ApplyTheme(arg0)
	local var0 = arg0.theme
	local var1 = var0:getName()

	arg0.desc.text = i18n("backyard_theme_set_tip", var1)

	if not var0:IsSystem() and (BackYardThemeTempalteUtil.FileExists(var0:GetTextureIconName()) or var0:IsPushed()) then
		setActive(arg0.iconRaw.gameObject, false)
		setActive(arg0.icon.gameObject, false)

		local var2 = var0:GetIconMd5()

		BackYardThemeTempalteUtil.GetTexture(var0:GetTextureIconName(), var2, function(arg0)
			if not IsNil(arg0.iconRaw) and arg0 then
				setActive(arg0.iconRaw.gameObject, true)

				arg0.iconRaw.texture = arg0
			end
		end)
	else
		setActive(arg0.iconRaw.gameObject, false)
		setActive(arg0.icon.gameObject, true)

		arg0.icon.sprite = LoadSprite("furnitureicon/" .. var0:getIcon())
	end
end

function var0.NewTheme(arg0)
	local var0 = arg0.theme.id

	setInputText(arg0.inputField, i18n("backyard_theme_defaultname") .. var0)

	arg0.desc.text = i18n("backyard_theme_save_tip", i18n("backyard_theme_defaultname") .. var0)
	arg0.icon.sprite = LoadSprite("furnitureicon/default_theme")

	setActive(arg0.iconRaw.gameObject, false)
	setActive(arg0.icon.gameObject, true)
end

function var0.ShowInnerMsgBox(arg0, arg1, arg2, arg3, arg4)
	setActive(arg0.frame, false)
	setActive(arg0.innerMsgbox, true)
	setActive(arg0.innerMsgboxCancelBtn, arg3)

	if arg4 then
		arg0.innerMsgboxContent.text = ""
		arg0.scrollTitleText.text = arg4
		arg0.scrollText.text = arg1
	else
		arg0.scrollTitleText.text = ""
		arg0.scrollText.text = ""
		arg0.innerMsgboxContent.text = arg1
	end

	onButton(arg0, arg0.innerMsgboxComfirmBtn, function()
		if arg2 then
			arg2()
		end
	end, SFX_PANEL)

	if arg3 then
		onButton(arg0, arg0.innerMsgboxCancelBtn, function()
			setActive(arg0.innerMsgbox, false)
			setActive(arg0.frame, true)
		end, SFX_PANEL)
	end

	arg0.showInnerMsg = true
end

function var0.HideInnerMsgBox(arg0)
	setActive(arg0.frame, true)
	setActive(arg0.innerMsgbox, false)

	arg0.showInnerMsg = false
end

function var0.OnDestroy(arg0)
	if not IsNil(arg0.iconRaw.texture) then
		Object.Destroy(arg0.iconRaw.texture)

		arg0.iconRaw.texture = nil
	end
end

return var0

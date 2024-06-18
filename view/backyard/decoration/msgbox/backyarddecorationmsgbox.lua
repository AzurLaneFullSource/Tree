local var0_0 = class("BackYardDecorationMsgBox", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "BackYardDecorationMsgBox"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.frame = arg0_2:findTF("frame")
	arg0_2.cancelBtn = arg0_2:findTF("frame/control/cancel_btn")
	arg0_2.deleteBtn = arg0_2:findTF("frame/control/delete_btn")
	arg0_2.saveBtn = arg0_2:findTF("frame/control/save_btn")
	arg0_2.applyBtn = arg0_2:findTF("frame/control/set_btn")
	arg0_2.input = arg0_2:findTF("frame/bound/input")
	arg0_2.inputField = arg0_2:findTF("frame/bound/input/InputField")
	arg0_2.desc = arg0_2:findTF("frame/bound/desc"):GetComponent(typeof(Text))
	arg0_2.icon = arg0_2:findTF("frame/bound/mask/Icon"):GetComponent(typeof(Image))
	arg0_2.iconRaw = arg0_2:findTF("frame/bound/mask/Icon_raw"):GetComponent(typeof(RawImage))
	arg0_2.title = arg0_2:findTF("frame/title"):GetComponent(typeof(Text))
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.innerMsgbox = arg0_2:findTF("msg")
	arg0_2.innerMsgboxContent = arg0_2.innerMsgbox:Find("bound/Text"):GetComponent(typeof(Text))
	arg0_2.innerMsgboxComfirmBtn = arg0_2.innerMsgbox:Find("btns/btn1")
	arg0_2.innerMsgboxCancelBtn = arg0_2.innerMsgbox:Find("btns/btn2")
	arg0_2.innerCloseBtn = arg0_2:findTF("msg/close")
	arg0_2.scrollTitleText = arg0_2.innerMsgbox:Find("bound/title"):GetComponent(typeof(Text))
	arg0_2.scrollText = arg0_2.innerMsgbox:Find("bound/scrollrect/Text"):GetComponent(typeof(Text))

	setText(arg0_2.cancelBtn:Find("Text"), i18n("word_cancel"))
	setText(arg0_2.deleteBtn:Find("Text"), i18n("word_delete"))
	setText(arg0_2.saveBtn:Find("Text"), i18n("word_save"))
	setText(arg0_2.applyBtn:Find("Text"), i18n("backyard_theme_word_apply"))
	setText(arg0_2.innerMsgboxComfirmBtn:Find("Text"), i18n("word_ok"))
	setText(arg0_2.innerMsgboxCancelBtn:Find("Text"), i18n("word_cancel"))
	setText(arg0_2.inputField:Find("Placeholder"), i18n("enter_theme_name"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		if arg0_3.showInnerMsg then
			arg0_3:HideInnerMsgBox()
		else
			arg0_3:Hide()
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.innerCloseBtn, function()
		arg0_3:HideInnerMsgBox()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.deleteBtn, function()
		if arg0_3.theme:IsPushed() then
			arg0_3:ShowInnerMsgBox(i18n("backyard_decoration_theme_template_delete_tip"), function()
				arg0_3:emit(BackYardDecorationMediator.DELETE_THEME, arg0_3.theme.id)
				arg0_3:Hide()
			end, true)
		else
			arg0_3:emit(BackYardDecorationMediator.DELETE_THEME, arg0_3.theme.id)
			arg0_3:Hide()
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.saveBtn, function()
		local var0_10 = getInputText(arg0_3.inputField)

		if wordVer(var0_10) > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_name_forbid"))

			return
		end

		arg0_3:emit(BackYardDecorationMediator.SAVE_THEME, arg0_3.theme.id, var0_10)
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.applyBtn, function()
		local function var0_11(arg0_12)
			return
		end

		arg0_3:emit(BackYardDecorationMediator.APPLY_THEME, arg0_3.theme, function(arg0_13, arg1_13)
			gcAll(false)

			if arg0_13 then
				arg0_3:emit(BackYardDecorationMediator.ADD_FURNITURES, arg0_3.theme.id, arg1_13, var0_11)
				arg0_3:Hide()
			else
				arg0_3:ShowInnerMsgBox(i18n("backyarad_theme_replace", arg0_3.theme:getName()), function()
					arg0_3:emit(BackYardDecorationMediator.ADD_FURNITURES, arg0_3.theme.id, arg1_13, var0_11)
					arg0_3:HideInnerMsgBox()
					arg0_3:Hide()
				end)
			end
		end)
	end, SFX_PANEL)
	onInputChanged(arg0_3, arg0_3.inputField, function()
		if not arg0_3.unEmpty then
			setText(arg0_3.desc, i18n("backyard_theme_save_tip"))
		end
	end)
end

function var0_0.Show(arg0_16, arg1_16, arg2_16)
	var0_0.super.Show(arg0_16)

	arg0_16.theme = arg1_16
	arg0_16.unEmpty = arg2_16

	if arg2_16 then
		arg0_16:ApplyTheme()
	else
		arg0_16:NewTheme()
	end

	arg0_16.title.text = arg2_16 and arg1_16:IsSystem() and i18n("courtyard_label_system_theme") or i18n("courtyard_label_custom_theme")

	setActive(arg0_16.frame, true)
	setActive(arg0_16._tf, true)
	setActive(arg0_16.innerMsgbox, false)
	setActive(arg0_16.input, not arg2_16)
	setActive(arg0_16.cancelBtn, not arg2_16)
	setActive(arg0_16.deleteBtn, arg2_16 and not arg1_16:IsSystem())
	setActive(arg0_16.applyBtn, arg2_16)
	setActive(arg0_16.saveBtn, not arg2_16)
	arg0_16._tf:SetAsLastSibling()
end

function var0_0.RemoveSizeTag(arg0_17, arg1_17)
	local var0_17 = string.gsub(arg1_17, "</size>", "")

	return string.gsub(var0_17, "<size=%d+>", "")
end

function var0_0.ApplyTheme(arg0_18)
	local var0_18 = arg0_18.theme
	local var1_18 = var0_18:getName()

	arg0_18.desc.text = i18n("backyard_theme_set_tip", var1_18)

	if not var0_18:IsSystem() and (BackYardThemeTempalteUtil.FileExists(var0_18:GetTextureIconName()) or var0_18:IsPushed()) then
		setActive(arg0_18.iconRaw.gameObject, false)
		setActive(arg0_18.icon.gameObject, false)

		local var2_18 = var0_18:GetIconMd5()

		BackYardThemeTempalteUtil.GetTexture(var0_18:GetTextureIconName(), var2_18, function(arg0_19)
			if not IsNil(arg0_18.iconRaw) and arg0_19 then
				setActive(arg0_18.iconRaw.gameObject, true)

				arg0_18.iconRaw.texture = arg0_19
			end
		end)
	else
		setActive(arg0_18.iconRaw.gameObject, false)
		setActive(arg0_18.icon.gameObject, true)

		arg0_18.icon.sprite = LoadSprite("furnitureicon/" .. var0_18:getIcon())
	end
end

function var0_0.NewTheme(arg0_20)
	local var0_20 = arg0_20.theme.id

	setInputText(arg0_20.inputField, i18n("backyard_theme_defaultname") .. var0_20)

	arg0_20.desc.text = i18n("backyard_theme_save_tip", i18n("backyard_theme_defaultname") .. var0_20)
	arg0_20.icon.sprite = LoadSprite("furnitureicon/default_theme")

	setActive(arg0_20.iconRaw.gameObject, false)
	setActive(arg0_20.icon.gameObject, true)
end

function var0_0.ShowInnerMsgBox(arg0_21, arg1_21, arg2_21, arg3_21, arg4_21)
	setActive(arg0_21.frame, false)
	setActive(arg0_21.innerMsgbox, true)
	setActive(arg0_21.innerMsgboxCancelBtn, arg3_21)

	if arg4_21 then
		arg0_21.innerMsgboxContent.text = ""
		arg0_21.scrollTitleText.text = arg4_21
		arg0_21.scrollText.text = arg1_21
	else
		arg0_21.scrollTitleText.text = ""
		arg0_21.scrollText.text = ""
		arg0_21.innerMsgboxContent.text = arg1_21
	end

	onButton(arg0_21, arg0_21.innerMsgboxComfirmBtn, function()
		if arg2_21 then
			arg2_21()
		end
	end, SFX_PANEL)

	if arg3_21 then
		onButton(arg0_21, arg0_21.innerMsgboxCancelBtn, function()
			setActive(arg0_21.innerMsgbox, false)
			setActive(arg0_21.frame, true)
		end, SFX_PANEL)
	end

	arg0_21.showInnerMsg = true
end

function var0_0.HideInnerMsgBox(arg0_24)
	setActive(arg0_24.frame, true)
	setActive(arg0_24.innerMsgbox, false)

	arg0_24.showInnerMsg = false
end

function var0_0.OnDestroy(arg0_25)
	if not IsNil(arg0_25.iconRaw.texture) then
		Object.Destroy(arg0_25.iconRaw.texture)

		arg0_25.iconRaw.texture = nil
	end
end

return var0_0

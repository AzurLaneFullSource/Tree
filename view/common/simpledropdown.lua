local var0_0 = class("SimpleDropdown", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IndexDropdownUI"
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2, arg6_2, arg7_2, arg8_2, arg9_2)
	var0_0.super.Ctor(arg0_2, arg1_2, arg2_2, arg3_2)

	arg0_2.tag = arg4_2
	arg0_2.virtualBtn = arg5_2
	arg0_2.virtualBtnTitle = findTF(arg0_2.virtualBtn, "Image")
	arg0_2.virtualBtnDropdownSign = findTF(arg0_2.virtualBtn, "dropdown")
	arg0_2.setting = arg6_2
	arg0_2.options = arg0_2.setting.options
	arg0_2.names = arg0_2.setting.names
	arg0_2.isSelected = true
	arg0_2.onUpdate = arg7_2
	arg0_2.greySprite = arg8_2
	arg0_2.yellowSprite = arg9_2

	arg0_2:UpdateVirtualBtn()
end

function var0_0.UpdateVirtualBtn(arg0_3)
	local var0_3 = arg0_3.contextData.indexDatas[arg0_3.tag]

	arg0_3.preIndex = table.indexof(arg0_3.options, var0_3) or 1

	setText(arg0_3.virtualBtnTitle, i18n(arg0_3.names[arg0_3.preIndex]))
	setImageSprite(arg0_3.virtualBtn, arg0_3.preIndex == 1 and arg0_3.greySprite or arg0_3.yellowSprite)
end

function var0_0.OnInit(arg0_4)
	arg0_4.btnTpl = arg0_4:findTF("resource/tpl")
	arg0_4.btnList = {}
	arg0_4.mainBtn = tf(instantiate(arg0_4.btnTpl))
	arg0_4.mainTitle = arg0_4:findTF("Image", arg0_4.mainBtn)

	setImageSprite(arg0_4.mainBtn, arg0_4.yellowSprite)
	setParent(arg0_4.mainBtn, arg0_4._tf)
	setActive(arg0_4.mainBtn, true)

	arg0_4:findTF("dropdown", arg0_4.mainBtn).localEulerAngles = Vector3.New(0, 0, 0)

	onButton(arg0_4, arg0_4.mainBtn, function()
		arg0_4:Hide()
	end)

	local var0_4 = arg0_4:findTF("mask", arg0_4._tf)

	onButton(arg0_4, var0_4, function()
		arg0_4:Hide()
	end)

	arg0_4.attrs = arg0_4:findTF("Attrs", arg0_4._tf)
	GetComponent(arg0_4.attrs, typeof(GridLayoutGroup)).constraintCount = 1

	for iter0_4 = 1, #arg0_4.options do
		local var1_4 = arg0_4.options[iter0_4]

		if iter0_4 == 1 then
			-- block empty
		else
			local var2_4 = tf(instantiate(arg0_4.btnTpl))
			local var3_4 = arg0_4:findTF("Image", var2_4)

			go(var2_4).name = i18n(arg0_4.names[iter0_4])

			setActive(var2_4, true)
			setActive(arg0_4:findTF("dropdown", var2_4), false)
			setText(var3_4, i18n(arg0_4.names[iter0_4]))
			setParent(var2_4, arg0_4.attrs)
			onButton(arg0_4, var2_4, function()
				arg0_4:UpdateData(iter0_4)
				arg0_4:UpdateBtnState()
			end, SFX_UI_TAG)
			table.insert(arg0_4.btnList, var2_4)
		end
	end

	arg0_4:UpdateVirtualBtn()
	arg0_4:SelectLast()
end

function var0_0.SelectLast(arg0_8)
	arg0_8:UpdateBtnState()
end

function var0_0.UpdateData(arg0_9, arg1_9)
	arg0_9.contextData.indexDatas[arg0_9.tag] = arg0_9.options[arg1_9]

	if arg0_9.onUpdate then
		arg0_9.onUpdate()
	end
end

function var0_0.UpdateBtnState(arg0_10)
	local function var0_10(arg0_11)
		setText(arg0_10.mainTitle, i18n(arg0_10.names[arg0_11]))
		setText(arg0_10.virtualBtnTitle, i18n(arg0_10.names[arg0_11]))
	end

	local var1_10 = false

	for iter0_10, iter1_10 in ipairs(arg0_10.btnList) do
		local var2_10 = arg0_10.options[iter0_10 + 1] == arg0_10.contextData.indexDatas[arg0_10.tag]

		setImageSprite(iter1_10, var2_10 and arg0_10.yellowSprite or arg0_10.greySprite)

		if var2_10 then
			var1_10 = true

			var0_10(iter0_10 + 1)
		end
	end

	if not var1_10 then
		var0_10(1)
	end
end

function var0_0.Show(arg0_12, arg1_12)
	arg0_12.attrs.localPosition = arg1_12
	arg0_12.mainBtn.anchoredPosition = arg0_12.attrs.anchoredPosition
	arg0_12.attrs.anchoredPosition = arg0_12.attrs.anchoredPosition + Vector2.New(0, -45)

	setActive(arg0_12._tf, true)
	setActive(arg0_12.virtualBtnDropdownSign, false)
	arg0_12:UpdateBtnState()
end

function var0_0.Hide(arg0_13)
	var0_0.super.Hide(arg0_13)
	setActive(arg0_13.virtualBtnDropdownSign, true)
end

function var0_0.OnDestroy(arg0_14)
	arg0_14.btnList = nil
end

return var0_0

local var0 = class("SimpleDropdown", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "IndexDropdownUI"
end

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	var0.super.Ctor(arg0, arg1, arg2, arg3)

	arg0.tag = arg4
	arg0.virtualBtn = arg5
	arg0.virtualBtnTitle = findTF(arg0.virtualBtn, "Image")
	arg0.virtualBtnDropdownSign = findTF(arg0.virtualBtn, "dropdown")
	arg0.setting = arg6
	arg0.options = arg0.setting.options
	arg0.names = arg0.setting.names
	arg0.isSelected = true
	arg0.onUpdate = arg7
	arg0.greySprite = arg8
	arg0.yellowSprite = arg9

	arg0:UpdateVirtualBtn()
end

function var0.UpdateVirtualBtn(arg0)
	local var0 = arg0.contextData.indexDatas[arg0.tag]

	arg0.preIndex = table.indexof(arg0.options, var0) or 1

	setText(arg0.virtualBtnTitle, i18n(arg0.names[arg0.preIndex]))
	setImageSprite(arg0.virtualBtn, arg0.preIndex == 1 and arg0.greySprite or arg0.yellowSprite)
end

function var0.OnInit(arg0)
	arg0.btnTpl = arg0:findTF("resource/tpl")
	arg0.btnList = {}
	arg0.mainBtn = tf(instantiate(arg0.btnTpl))
	arg0.mainTitle = arg0:findTF("Image", arg0.mainBtn)

	setImageSprite(arg0.mainBtn, arg0.yellowSprite)
	setParent(arg0.mainBtn, arg0._tf)
	setActive(arg0.mainBtn, true)

	arg0:findTF("dropdown", arg0.mainBtn).localEulerAngles = Vector3.New(0, 0, 0)

	onButton(arg0, arg0.mainBtn, function()
		arg0:Hide()
	end)

	local var0 = arg0:findTF("mask", arg0._tf)

	onButton(arg0, var0, function()
		arg0:Hide()
	end)

	arg0.attrs = arg0:findTF("Attrs", arg0._tf)
	GetComponent(arg0.attrs, typeof(GridLayoutGroup)).constraintCount = 1

	for iter0 = 1, #arg0.options do
		local var1 = arg0.options[iter0]

		if iter0 == 1 then
			-- block empty
		else
			local var2 = tf(instantiate(arg0.btnTpl))
			local var3 = arg0:findTF("Image", var2)

			go(var2).name = i18n(arg0.names[iter0])

			setActive(var2, true)
			setActive(arg0:findTF("dropdown", var2), false)
			setText(var3, i18n(arg0.names[iter0]))
			setParent(var2, arg0.attrs)
			onButton(arg0, var2, function()
				arg0:UpdateData(iter0)
				arg0:UpdateBtnState()
			end, SFX_UI_TAG)
			table.insert(arg0.btnList, var2)
		end
	end

	arg0:UpdateVirtualBtn()
	arg0:SelectLast()
end

function var0.SelectLast(arg0)
	arg0:UpdateBtnState()
end

function var0.UpdateData(arg0, arg1)
	arg0.contextData.indexDatas[arg0.tag] = arg0.options[arg1]

	if arg0.onUpdate then
		arg0.onUpdate()
	end
end

function var0.UpdateBtnState(arg0)
	local function var0(arg0)
		setText(arg0.mainTitle, i18n(arg0.names[arg0]))
		setText(arg0.virtualBtnTitle, i18n(arg0.names[arg0]))
	end

	local var1 = false

	for iter0, iter1 in ipairs(arg0.btnList) do
		local var2 = arg0.options[iter0 + 1] == arg0.contextData.indexDatas[arg0.tag]

		setImageSprite(iter1, var2 and arg0.yellowSprite or arg0.greySprite)

		if var2 then
			var1 = true

			var0(iter0 + 1)
		end
	end

	if not var1 then
		var0(1)
	end
end

function var0.Show(arg0, arg1)
	arg0.attrs.localPosition = arg1
	arg0.mainBtn.anchoredPosition = arg0.attrs.anchoredPosition
	arg0.attrs.anchoredPosition = arg0.attrs.anchoredPosition + Vector2.New(0, -45)

	setActive(arg0._tf, true)
	setActive(arg0.virtualBtnDropdownSign, false)
	arg0:UpdateBtnState()
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	setActive(arg0.virtualBtnDropdownSign, true)
end

function var0.OnDestroy(arg0)
	arg0.btnList = nil
end

return var0

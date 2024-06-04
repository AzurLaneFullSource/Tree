local var0 = class("CustomDropdown", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "IndexDropdownUI"
end

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5)
	var0.super.Ctor(arg0, arg1, arg2, arg3)

	arg0.tag = arg4
	arg0.virtualBtn = arg5
	arg0.virtualBtnTitle = findTF(arg0.virtualBtn, "Image")
	arg0.virtualBtnDropdownSign = findTF(arg0.virtualBtn, "dropdown")
	arg0.setting = arg0.contextData.customPanels[arg0.tag]
	arg0.mode = arg0.setting.mode or CustomIndexLayer.Mode.OR
	arg0.options = arg0.setting.options
	arg0.names = arg0.setting.names

	arg0:UpdateVirtualBtn()
end

function var0.UpdateVirtualBtn(arg0)
	arg0.contextData.indexDatas[arg0.tag] = arg0.contextData.indexDatas[arg0.tag] or arg0.options[1]
	arg0.preIndex = table.indexof(arg0.options, arg0.contextData.indexDatas[arg0.tag])

	setText(arg0.virtualBtnTitle, i18n(arg0.names[arg0.preIndex]))
end

function var0.OnInit(arg0)
	arg0.btnTpl = arg0:findTF("resource/tpl")
	arg0.btnList = {}
	arg0.greySprite = arg0:findTF("resource/grey"):GetComponent(typeof(Image)).sprite
	arg0.yellowSprite = arg0:findTF("resource/yellow"):GetComponent(typeof(Image)).sprite
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

	local var1 = GetComponent(arg0.attrs, typeof(GridLayoutGroup))

	if #arg0.options > 6 then
		var1.constraintCount = 2
	else
		var1.constraintCount = 1
	end

	for iter0 = 1, #arg0.options do
		local var2 = arg0.options[iter0]

		if iter0 == 1 then
			-- block empty
		else
			local var3 = tf(instantiate(arg0.btnTpl))
			local var4 = arg0:findTF("Image", var3)

			go(var3).name = i18n(arg0.names[iter0])

			setActive(var3, true)
			setActive(arg0:findTF("dropdown", var3), false)
			setText(var4, i18n(arg0.names[iter0]))
			setParent(var3, arg0.attrs)
			onButton(arg0, var3, function()
				arg0:UpdateData(iter0)
				arg0:UpdateBtnState()
			end, SFX_UI_TAG)
			table.insert(arg0.btnList, var3)
		end
	end

	arg0:SelectLast()
end

function var0.SelectLast(arg0)
	arg0:UpdateBtnState()
end

function var0.UpdateData(arg0, arg1)
	local var0 = arg0.contextData.indexDatas[arg0.tag]
	local var1 = bit.band(var0, arg0.options[arg1]) > 0

	if arg0.mode == CustomIndexLayer.Mode.AND then
		if var1 then
			arg0.contextData.indexDatas[arg0.tag] = var0 - arg0.options[arg1]
		else
			arg0.contextData.indexDatas[arg0.tag] = bit.bxor(var0, arg0.options[arg1])
		end
	elseif arg0.mode == CustomIndexLayer.Mode.OR then
		if var0 ~= arg0.options[1] and var1 then
			arg0.contextData.indexDatas[arg0.tag] = var0 - arg0.options[arg1]
		else
			arg0.contextData.indexDatas[arg0.tag] = arg0.options[arg1]
		end

		if arg0.contextData.indexDatas[arg0.tag] == 0 then
			arg0.contextData.indexDatas[arg0.tag] = arg0.options[1]
		end
	end
end

function var0.UpdateBtnState(arg0)
	local function var0(arg0)
		setText(arg0.mainTitle, i18n(arg0.names[arg0]))
		setText(arg0.virtualBtnTitle, i18n(arg0.names[arg0]))
	end

	if arg0.mode == CustomIndexLayer.Mode.AND then
		if arg0.contextData.indexDatas[arg0.tag] == arg0.options[1] then
			for iter0, iter1 in ipairs(arg0.btnList) do
				setImageSprite(iter1, arg0.greySprite)
			end
		else
			for iter2, iter3 in ipairs(arg0.btnList) do
				local var1 = bit.band(arg0.contextData.indexDatas[arg0.tag], arg0.options[iter2 + 1]) > 0

				setImageSprite(iter3, var1 and arg0.yellowSprite or arg0.greySprite)
			end
		end

		var0(1)
	elseif arg0.mode == CustomIndexLayer.Mode.OR then
		local var2 = false

		for iter4, iter5 in ipairs(arg0.btnList) do
			local var3 = arg0.options[iter4 + 1] == arg0.contextData.indexDatas[arg0.tag]

			setImageSprite(iter5, var3 and arg0.yellowSprite or arg0.greySprite)

			if var3 then
				var2 = true

				var0(iter4 + 1)
			end
		end

		if not var2 then
			var0(1)
		end
	end
end

function var0.Show(arg0, arg1)
	arg0.attrs.localPosition = arg1
	arg0.mainBtn.anchoredPosition = arg0.attrs.anchoredPosition
	arg0.attrs.anchoredPosition = arg0.attrs.anchoredPosition + Vector2.New(0, -45)

	setActive(arg0._tf, true)
	setActive(arg0.virtualBtnDropdownSign, false)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	setActive(arg0.virtualBtnDropdownSign, true)
end

function var0.OnDestroy(arg0)
	arg0.btnList = nil
end

return var0

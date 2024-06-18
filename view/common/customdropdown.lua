local var0_0 = class("CustomDropdown", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IndexDropdownUI"
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2)
	var0_0.super.Ctor(arg0_2, arg1_2, arg2_2, arg3_2)

	arg0_2.tag = arg4_2
	arg0_2.virtualBtn = arg5_2
	arg0_2.virtualBtnTitle = findTF(arg0_2.virtualBtn, "Image")
	arg0_2.virtualBtnDropdownSign = findTF(arg0_2.virtualBtn, "dropdown")
	arg0_2.setting = arg0_2.contextData.customPanels[arg0_2.tag]
	arg0_2.mode = arg0_2.setting.mode or CustomIndexLayer.Mode.OR
	arg0_2.options = arg0_2.setting.options
	arg0_2.names = arg0_2.setting.names

	arg0_2:UpdateVirtualBtn()
end

function var0_0.UpdateVirtualBtn(arg0_3)
	arg0_3.contextData.indexDatas[arg0_3.tag] = arg0_3.contextData.indexDatas[arg0_3.tag] or arg0_3.options[1]
	arg0_3.preIndex = table.indexof(arg0_3.options, arg0_3.contextData.indexDatas[arg0_3.tag])

	setText(arg0_3.virtualBtnTitle, i18n(arg0_3.names[arg0_3.preIndex]))
end

function var0_0.OnInit(arg0_4)
	arg0_4.btnTpl = arg0_4:findTF("resource/tpl")
	arg0_4.btnList = {}
	arg0_4.greySprite = arg0_4:findTF("resource/grey"):GetComponent(typeof(Image)).sprite
	arg0_4.yellowSprite = arg0_4:findTF("resource/yellow"):GetComponent(typeof(Image)).sprite
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

	local var1_4 = GetComponent(arg0_4.attrs, typeof(GridLayoutGroup))

	if #arg0_4.options > 6 then
		var1_4.constraintCount = 2
	else
		var1_4.constraintCount = 1
	end

	for iter0_4 = 1, #arg0_4.options do
		local var2_4 = arg0_4.options[iter0_4]

		if iter0_4 == 1 then
			-- block empty
		else
			local var3_4 = tf(instantiate(arg0_4.btnTpl))
			local var4_4 = arg0_4:findTF("Image", var3_4)

			go(var3_4).name = i18n(arg0_4.names[iter0_4])

			setActive(var3_4, true)
			setActive(arg0_4:findTF("dropdown", var3_4), false)
			setText(var4_4, i18n(arg0_4.names[iter0_4]))
			setParent(var3_4, arg0_4.attrs)
			onButton(arg0_4, var3_4, function()
				arg0_4:UpdateData(iter0_4)
				arg0_4:UpdateBtnState()
			end, SFX_UI_TAG)
			table.insert(arg0_4.btnList, var3_4)
		end
	end

	arg0_4:SelectLast()
end

function var0_0.SelectLast(arg0_8)
	arg0_8:UpdateBtnState()
end

function var0_0.UpdateData(arg0_9, arg1_9)
	local var0_9 = arg0_9.contextData.indexDatas[arg0_9.tag]
	local var1_9 = bit.band(var0_9, arg0_9.options[arg1_9]) > 0

	if arg0_9.mode == CustomIndexLayer.Mode.AND then
		if var1_9 then
			arg0_9.contextData.indexDatas[arg0_9.tag] = var0_9 - arg0_9.options[arg1_9]
		else
			arg0_9.contextData.indexDatas[arg0_9.tag] = bit.bxor(var0_9, arg0_9.options[arg1_9])
		end
	elseif arg0_9.mode == CustomIndexLayer.Mode.OR then
		if var0_9 ~= arg0_9.options[1] and var1_9 then
			arg0_9.contextData.indexDatas[arg0_9.tag] = var0_9 - arg0_9.options[arg1_9]
		else
			arg0_9.contextData.indexDatas[arg0_9.tag] = arg0_9.options[arg1_9]
		end

		if arg0_9.contextData.indexDatas[arg0_9.tag] == 0 then
			arg0_9.contextData.indexDatas[arg0_9.tag] = arg0_9.options[1]
		end
	end
end

function var0_0.UpdateBtnState(arg0_10)
	local function var0_10(arg0_11)
		setText(arg0_10.mainTitle, i18n(arg0_10.names[arg0_11]))
		setText(arg0_10.virtualBtnTitle, i18n(arg0_10.names[arg0_11]))
	end

	if arg0_10.mode == CustomIndexLayer.Mode.AND then
		if arg0_10.contextData.indexDatas[arg0_10.tag] == arg0_10.options[1] then
			for iter0_10, iter1_10 in ipairs(arg0_10.btnList) do
				setImageSprite(iter1_10, arg0_10.greySprite)
			end
		else
			for iter2_10, iter3_10 in ipairs(arg0_10.btnList) do
				local var1_10 = bit.band(arg0_10.contextData.indexDatas[arg0_10.tag], arg0_10.options[iter2_10 + 1]) > 0

				setImageSprite(iter3_10, var1_10 and arg0_10.yellowSprite or arg0_10.greySprite)
			end
		end

		var0_10(1)
	elseif arg0_10.mode == CustomIndexLayer.Mode.OR then
		local var2_10 = false

		for iter4_10, iter5_10 in ipairs(arg0_10.btnList) do
			local var3_10 = arg0_10.options[iter4_10 + 1] == arg0_10.contextData.indexDatas[arg0_10.tag]

			setImageSprite(iter5_10, var3_10 and arg0_10.yellowSprite or arg0_10.greySprite)

			if var3_10 then
				var2_10 = true

				var0_10(iter4_10 + 1)
			end
		end

		if not var2_10 then
			var0_10(1)
		end
	end
end

function var0_0.Show(arg0_12, arg1_12)
	arg0_12.attrs.localPosition = arg1_12
	arg0_12.mainBtn.anchoredPosition = arg0_12.attrs.anchoredPosition
	arg0_12.attrs.anchoredPosition = arg0_12.attrs.anchoredPosition + Vector2.New(0, -45)

	setActive(arg0_12._tf, true)
	setActive(arg0_12.virtualBtnDropdownSign, false)
end

function var0_0.Hide(arg0_13)
	var0_0.super.Hide(arg0_13)
	setActive(arg0_13.virtualBtnDropdownSign, true)
end

function var0_0.OnDestroy(arg0_14)
	arg0_14.btnList = nil
end

return var0_0

local var0_0 = class("CustomIndexLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CustomIndexUI"
end

var0_0.Mode = {
	OR = 2,
	AND = 1,
	NUM = 3
}

function var0_0.init(arg0_2)
	arg0_2.panel = arg0_2._tf:Find("index_panel")
	arg0_2.layout = arg0_2.panel:Find("layout")
	arg0_2.contianer = arg0_2.layout:Find("container")

	eachChild(arg0_2.contianer, function(arg0_3)
		setActive(arg0_3, false)
	end)

	arg0_2.panelTemplate = arg0_2.layout:Find("container/Template")
	arg0_2.displayList = {}
	arg0_2.typeList = {}
	arg0_2.btnConfirm = arg0_2:findTF("layout/btns/ok", arg0_2.panel)
	arg0_2.btnCancel = arg0_2:findTF("layout/btns/cancel", arg0_2.panel)

	setText(arg0_2:findTF("Image", arg0_2.btnConfirm), i18n("text_confirm"))
	setText(arg0_2:findTF("Image", arg0_2.btnCancel), i18n("text_cancel"))

	arg0_2.greySprite = arg0_2:findTF("resource/grey", arg0_2.panel):GetComponent(typeof(Image)).sprite
	arg0_2.blueSprite = arg0_2:findTF("resource/blue", arg0_2.panel):GetComponent(typeof(Image)).sprite
	arg0_2.yellowSprite = arg0_2:findTF("resource/yellow", arg0_2.panel):GetComponent(typeof(Image)).sprite
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4.btnConfirm, function()
		if arg0_4.contextData.callback then
			arg0_4.contextData.callback(arg0_4.contextData.indexDatas)

			arg0_4.contextData.callback = nil
		end

		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_CONFIRM)
	onButton(arg0_4, arg0_4.btnCancel, function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4:findTF("btn", arg0_4.panel), function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	arg0_4:DoEnterAnimation()
	setText(arg0_4.panel:Find("layout/tip"), arg0_4.contextData.tip or "")
	arg0_4:InitGroup()
	arg0_4:BlurPanel()
end

function var0_0.DoEnterAnimation(arg0_8)
	arg0_8.panel.localScale = Vector3.zero

	LeanTween.scale(arg0_8.panel, Vector3(1, 1, 1), 0.2)
end

function var0_0.BlurPanel(arg0_9)
	pg.UIMgr.GetInstance():BlurPanel(arg0_9._tf)
end

function var0_0.InitGroup(arg0_10)
	arg0_10.onInit = true
	arg0_10.contextData.indexDatas = arg0_10.contextData.indexDatas or {}
	arg0_10.dropdownDic = {}
	arg0_10.updateList = {}
	arg0_10.simpleDropdownDic = {}

	for iter0_10, iter1_10 in pairs(arg0_10.contextData.groupList) do
		if iter1_10.dropdown then
			arg0_10:InitDropdown(iter1_10)
		else
			arg0_10:InitCustoms(iter1_10)
		end
	end

	for iter2_10, iter3_10 in ipairs(arg0_10.updateList) do
		iter3_10()
	end

	if arg0_10.contextData.customPanels.minHeight then
		GetOrAddComponent(arg0_10.layout, typeof(LayoutElement)).minHeight = arg0_10.contextData.customPanels.minHeight
	end

	if arg0_10.contextData.customPanels.layoutPos then
		setLocalPosition(arg0_10.layout, arg0_10.contextData.customPanels.layoutPos)
	end

	arg0_10.onInit = false
end

function var0_0.InitDropdown(arg0_11, arg1_11)
	local var0_11 = arg1_11.tags
	local var1_11 = tf(Instantiate(arg0_11.panelTemplate))

	setParent(var1_11, arg0_11.contianer, false)
	setActive(var1_11, true)

	local var2_11 = var0_0.Clone2Full(var1_11:Find("bg"), #var0_11)

	go(var1_11).name = arg1_11.titleTxt

	setText(var1_11:Find("title/Image"), i18n(arg1_11.titleTxt))
	setText(var1_11:Find("title/Image/Image_en"), i18n(arg1_11.titleENTxt))

	var1_11:Find("bg"):GetComponent(typeof(ScrollRect)).enabled = false

	for iter0_11, iter1_11 in ipairs(var0_11) do
		local var3_11 = var2_11[iter0_11]

		setActive(arg0_11:findTF("dropdown", var3_11), true)

		local var4_11 = CustomDropdown.New(arg0_11.panel, arg0_11.event, arg0_11.contextData, iter1_11, var3_11)

		onButton(arg0_11, var3_11, function()
			local var0_12 = arg0_11.panel:InverseTransformPoint(var3_11.position)

			if not var4_11:GetLoaded() then
				var4_11:Load()
			end

			var4_11:ActionInvoke("Show", var0_12)
		end)

		arg0_11.dropdownDic[iter1_11] = var4_11
	end
end

function var0_0.InitCustoms(arg0_13, arg1_13)
	local var0_13 = arg1_13.tags[1]
	local var1_13 = arg0_13.contextData.customPanels[var0_13]
	local var2_13 = tf(Instantiate(arg0_13.panelTemplate))

	setParent(var2_13, arg0_13.contianer, false)
	setActive(var2_13, true)

	go(var2_13).name = arg1_13.titleTxt

	setText(var2_13:Find("title/Image"), i18n(arg1_13.titleTxt))
	setText(var2_13:Find("title/Image/Image_en"), i18n(arg1_13.titleENTxt))

	var2_13:Find("bg"):GetComponent(typeof(ScrollRect)).enabled = false

	local var3_13 = var1_13.options
	local var4_13 = var1_13.mode or var0_0.Mode.OR
	local var5_13 = 0
	local var6_13 = var1_13.blueSeleted and arg0_13.blueSprite or arg0_13.yellowSprite

	for iter0_13, iter1_13 in ipairs(var3_13) do
		var5_13 = bit.bor(iter1_13, var5_13)
	end

	arg0_13.contextData.indexDatas[var0_13] = arg0_13.contextData.indexDatas[var0_13] or var3_13[1]

	local var7_13
	local var8_13 = var0_0.Clone2Full(var2_13:Find("bg"), #var3_13)

	for iter2_13, iter3_13 in ipairs(var8_13) do
		local var9_13 = var3_13[iter2_13]

		setText(findTF(iter3_13, "Image"), i18n(var1_13.names[iter2_13]))
		arg0_13:UpdateBtnStyle(iter3_13, arg0_13.greySprite)
		onButton(arg0_13, iter3_13, function()
			switch(var4_13, {
				[var0_0.Mode.AND] = function()
					if iter2_13 == 1 or arg0_13.contextData.indexDatas[var0_13] == var3_13[1] then
						arg0_13.contextData.indexDatas[var0_13] = var9_13
					else
						arg0_13.contextData.indexDatas[var0_13] = bit.bxor(arg0_13.contextData.indexDatas[var0_13], var9_13)
					end

					if arg0_13.contextData.indexDatas[var0_13] == 0 or arg0_13.contextData.indexDatas[var0_13] == var5_13 then
						arg0_13.contextData.indexDatas[var0_13] = var3_13[1]
					end
				end,
				[var0_0.Mode.OR] = function()
					if var1_13.isSort then
						arg0_13.contextData.indexDatas[var0_13] = var9_13
					else
						local var0_16 = arg0_13.contextData.indexDatas[var0_13]

						arg0_13.contextData.indexDatas[var0_13] = var9_13 == var0_16 and var3_13[1] or var9_13
					end
				end,
				[var0_0.Mode.NUM] = function()
					local var0_17 = arg0_13.contextData.indexDatas[var0_13]
					local var1_17 = 0

					while var0_17 > 0 do
						var1_17 = var1_17 + 1
						var0_17 = bit.band(var0_17, var0_17 - 1)
					end

					if var1_17 < var1_13.num or bit.band(arg0_13.contextData.indexDatas[var0_13], var9_13) > 0 then
						arg0_13.contextData.indexDatas[var0_13] = bit.bxor(arg0_13.contextData.indexDatas[var0_13], var9_13)
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_share_exceedlimit"))
					end
				end
			})
			var7_13()
		end, SFX_UI_TAG)
	end

	function var7_13()
		switch(var4_13, {
			[var0_0.Mode.AND] = function()
				if arg0_13.contextData.indexDatas[var0_13] == var3_13[1] then
					for iter0_19, iter1_19 in ipairs(var8_13) do
						local var0_19 = var3_13[iter0_19] == var3_13[1]
						local var1_19 = findTF(iter1_19, "Image")

						arg0_13:UpdateBtnStyle(iter1_19, var0_19 and var6_13 or arg0_13.greySprite)
					end
				else
					for iter2_19, iter3_19 in ipairs(var8_13) do
						local var2_19 = var3_13[iter2_19] ~= var3_13[1] and bit.band(arg0_13.contextData.indexDatas[var0_13], var3_13[iter2_19]) > 0
						local var3_19 = findTF(iter3_19, "Image")

						arg0_13:UpdateBtnStyle(iter3_19, var2_19 and var6_13 or arg0_13.greySprite)
					end
				end
			end,
			[var0_0.Mode.OR] = function()
				for iter0_20, iter1_20 in ipairs(var8_13) do
					local var0_20 = var3_13[iter0_20] == arg0_13.contextData.indexDatas[var0_13]
					local var1_20 = findTF(iter1_20, "Image")

					arg0_13:UpdateBtnStyle(iter1_20, var0_20 and var6_13 or arg0_13.greySprite)
				end
			end,
			[var0_0.Mode.NUM] = function()
				for iter0_21, iter1_21 in ipairs(var8_13) do
					local var0_21 = bit.band(arg0_13.contextData.indexDatas[var0_13], var3_13[iter0_21]) > 0
					local var1_21 = findTF(iter1_21, "Image")

					arg0_13:UpdateBtnStyle(iter1_21, var0_21 and var6_13 or arg0_13.greySprite)
				end
			end
		})
		arg0_13:OnDatasChange(var0_13)

		if arg0_13.simpleDropdownDic[var0_13] then
			for iter0_18, iter1_18 in pairs(arg0_13.simpleDropdownDic[var0_13]) do
				iter1_18:UpdateVirtualBtn()
			end
		end
	end

	table.insert(arg0_13.updateList, var7_13)

	if arg1_13.simpleDropdown then
		assert(var4_13 == var0_0.Mode.OR, "simpleDropdown目前只支持OR模式")

		local var10_13 = var2_13:Find("bg"):GetChild(0)

		for iter4_13, iter5_13 in ipairs(arg1_13.simpleDropdown) do
			local var11_13 = arg0_13.contextData.customPanels[iter5_13]
			local var12_13 = cloneTplTo(var10_13, var2_13:Find("bg"))

			var12_13.name = iter5_13 .. "_simple"

			local var13_13 = SimpleDropdown.New(arg0_13.panel, arg0_13.event, arg0_13.contextData, var0_13, var12_13, var11_13, var7_13, arg0_13.greySprite, arg0_13.yellowSprite)

			setActive(arg0_13:findTF("dropdown", var12_13), true)
			onButton(arg0_13, var12_13, function()
				local var0_22 = arg0_13.panel:InverseTransformPoint(var12_13.position)

				if not var13_13:GetLoaded() then
					var13_13:Load()
				end

				var13_13:ActionInvoke("Show", var0_22)
			end)

			arg0_13.simpleDropdownDic[var0_13] = arg0_13.simpleDropdownDic[var0_13] or {}
			arg0_13.simpleDropdownDic[var0_13][iter5_13] = var13_13
		end
	end
end

function var0_0.UpdateBtnStyle(arg0_23, arg1_23, arg2_23)
	setImageSprite(arg1_23, arg2_23)
end

function var0_0.OnDatasChange(arg0_24, arg1_24)
	local var0_24 = arg0_24.contextData.dropdownLimit or {}

	for iter0_24, iter1_24 in pairs(arg0_24.dropdownDic) do
		if var0_24[iter0_24] ~= nil then
			local var1_24 = var0_24[iter0_24].include
			local var2_24 = var0_24[iter0_24].exclude

			if var2_24[arg1_24] ~= nil or var1_24[arg1_24] ~= nil then
				local var3_24 = arg0_24.contextData.indexDatas[arg1_24]
				local var4_24 = false

				if var2_24[arg1_24] ~= nil and var3_24 == var2_24[arg1_24] then
					var4_24 = false
				elseif var1_24[arg1_24] ~= nil then
					var4_24 = bit.band(var3_24, var1_24[arg1_24]) > 0
				end

				setActive(arg0_24.dropdownDic[iter0_24].virtualBtn, var4_24)

				if not arg0_24.onInit then
					arg0_24.contextData.indexDatas[iter0_24] = arg0_24.contextData.customPanels[iter0_24].options[1]
				end

				arg0_24.dropdownDic[iter0_24]:UpdateVirtualBtn()
				arg0_24.dropdownDic[iter0_24]:ActionInvoke("SelectLast")
			end
		end
	end
end

function var0_0.willExit(arg0_25)
	LeanTween.cancel(go(arg0_25.panel))

	for iter0_25, iter1_25 in pairs(arg0_25.dropdownDic) do
		iter1_25:Destroy()
	end

	for iter2_25, iter3_25 in pairs(arg0_25.simpleDropdownDic) do
		for iter4_25, iter5_25 in pairs(iter3_25) do
			iter5_25:Destroy()
		end
	end

	arg0_25.updateList = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_25._tf)
end

function var0_0.Clone2Full(arg0_26, arg1_26)
	local var0_26 = {}
	local var1_26 = arg0_26:GetChild(0)
	local var2_26 = arg0_26.childCount

	for iter0_26 = 0, var2_26 - 1 do
		table.insert(var0_26, arg0_26:GetChild(iter0_26))
	end

	for iter1_26 = var2_26, arg1_26 - 1 do
		local var3_26 = cloneTplTo(var1_26, arg0_26)

		var3_26.name = iter1_26

		table.insert(var0_26, tf(var3_26))
	end

	local var4_26 = arg0_26.childCount

	for iter2_26 = 0, var4_26 - 1 do
		setActive(arg0_26:GetChild(iter2_26), iter2_26 < arg1_26)
	end

	for iter3_26 = var4_26, arg1_26 + 1, -1 do
		table.remove(var0_26)
	end

	return var0_26
end

return var0_0

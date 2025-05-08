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

	arg0_4.panel.localScale = Vector3.zero

	LeanTween.scale(arg0_4.panel, Vector3(1, 1, 1), 0.2)
	setText(arg0_4.panel:Find("layout/tip"), arg0_4.contextData.tip or "")
	arg0_4:InitGroup()
	arg0_4:BlurPanel()
end

function var0_0.BlurPanel(arg0_8)
	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf)
end

function var0_0.InitGroup(arg0_9)
	arg0_9.onInit = true
	arg0_9.contextData.indexDatas = arg0_9.contextData.indexDatas or {}
	arg0_9.dropdownDic = {}
	arg0_9.updateList = {}
	arg0_9.simpleDropdownDic = {}

	for iter0_9, iter1_9 in pairs(arg0_9.contextData.groupList) do
		if iter1_9.dropdown then
			arg0_9:InitDropdown(iter1_9)
		else
			arg0_9:InitCustoms(iter1_9)
		end
	end

	for iter2_9, iter3_9 in ipairs(arg0_9.updateList) do
		iter3_9()
	end

	if arg0_9.contextData.customPanels.minHeight then
		GetOrAddComponent(arg0_9.layout, typeof(LayoutElement)).minHeight = arg0_9.contextData.customPanels.minHeight
	end

	if arg0_9.contextData.customPanels.layoutPos then
		setLocalPosition(arg0_9.layout, arg0_9.contextData.customPanels.layoutPos)
	end

	arg0_9.onInit = false
end

function var0_0.InitDropdown(arg0_10, arg1_10)
	local var0_10 = arg1_10.tags
	local var1_10 = tf(Instantiate(arg0_10.panelTemplate))

	setParent(var1_10, arg0_10.contianer, false)
	setActive(var1_10, true)

	local var2_10 = var0_0.Clone2Full(var1_10:Find("bg"), #var0_10)

	go(var1_10).name = arg1_10.titleTxt

	setText(var1_10:Find("title/Image"), i18n(arg1_10.titleTxt))
	setText(var1_10:Find("title/Image/Image_en"), i18n(arg1_10.titleENTxt))

	var1_10:Find("bg"):GetComponent(typeof(ScrollRect)).enabled = false

	for iter0_10, iter1_10 in ipairs(var0_10) do
		local var3_10 = var2_10[iter0_10]

		setActive(arg0_10:findTF("dropdown", var3_10), true)

		local var4_10 = CustomDropdown.New(arg0_10.panel, arg0_10.event, arg0_10.contextData, iter1_10, var3_10)

		onButton(arg0_10, var3_10, function()
			local var0_11 = arg0_10.panel:InverseTransformPoint(var3_10.position)

			if not var4_10:GetLoaded() then
				var4_10:Load()
			end

			var4_10:ActionInvoke("Show", var0_11)
		end)

		arg0_10.dropdownDic[iter1_10] = var4_10
	end
end

function var0_0.InitCustoms(arg0_12, arg1_12)
	local var0_12 = arg1_12.tags[1]
	local var1_12 = arg0_12.contextData.customPanels[var0_12]
	local var2_12 = tf(Instantiate(arg0_12.panelTemplate))

	setParent(var2_12, arg0_12.contianer, false)
	setActive(var2_12, true)

	go(var2_12).name = arg1_12.titleTxt

	setText(var2_12:Find("title/Image"), i18n(arg1_12.titleTxt))
	setText(var2_12:Find("title/Image/Image_en"), i18n(arg1_12.titleENTxt))

	var2_12:Find("bg"):GetComponent(typeof(ScrollRect)).enabled = false

	local var3_12 = var1_12.options
	local var4_12 = var1_12.mode or var0_0.Mode.OR
	local var5_12 = 0
	local var6_12 = var1_12.blueSeleted and arg0_12.blueSprite or arg0_12.yellowSprite

	for iter0_12, iter1_12 in ipairs(var3_12) do
		var5_12 = bit.bor(iter1_12, var5_12)
	end

	arg0_12.contextData.indexDatas[var0_12] = arg0_12.contextData.indexDatas[var0_12] or var3_12[1]

	local var7_12
	local var8_12 = var0_0.Clone2Full(var2_12:Find("bg"), #var3_12)

	for iter2_12, iter3_12 in ipairs(var8_12) do
		local var9_12 = var3_12[iter2_12]

		setText(findTF(iter3_12, "Image"), i18n(var1_12.names[iter2_12]))
		arg0_12:UpdateBtnStyle(iter3_12, arg0_12.greySprite)
		onButton(arg0_12, iter3_12, function()
			switch(var4_12, {
				[var0_0.Mode.AND] = function()
					if iter2_12 == 1 or arg0_12.contextData.indexDatas[var0_12] == var3_12[1] then
						arg0_12.contextData.indexDatas[var0_12] = var9_12
					else
						arg0_12.contextData.indexDatas[var0_12] = bit.bxor(arg0_12.contextData.indexDatas[var0_12], var9_12)
					end

					if arg0_12.contextData.indexDatas[var0_12] == 0 or arg0_12.contextData.indexDatas[var0_12] == var5_12 then
						arg0_12.contextData.indexDatas[var0_12] = var3_12[1]
					end
				end,
				[var0_0.Mode.OR] = function()
					if var1_12.isSort then
						arg0_12.contextData.indexDatas[var0_12] = var9_12
					else
						local var0_15 = arg0_12.contextData.indexDatas[var0_12]

						arg0_12.contextData.indexDatas[var0_12] = var9_12 == var0_15 and var3_12[1] or var9_12
					end
				end,
				[var0_0.Mode.NUM] = function()
					local var0_16 = arg0_12.contextData.indexDatas[var0_12]
					local var1_16 = 0

					while var0_16 > 0 do
						var1_16 = var1_16 + 1
						var0_16 = bit.band(var0_16, var0_16 - 1)
					end

					if var1_16 < var1_12.num or bit.band(arg0_12.contextData.indexDatas[var0_12], var9_12) > 0 then
						arg0_12.contextData.indexDatas[var0_12] = bit.bxor(arg0_12.contextData.indexDatas[var0_12], var9_12)
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_share_exceedlimit"))
					end
				end
			})
			var7_12()
		end, SFX_UI_TAG)
	end

	function var7_12()
		switch(var4_12, {
			[var0_0.Mode.AND] = function()
				if arg0_12.contextData.indexDatas[var0_12] == var3_12[1] then
					for iter0_18, iter1_18 in ipairs(var8_12) do
						local var0_18 = var3_12[iter0_18] == var3_12[1]
						local var1_18 = findTF(iter1_18, "Image")

						arg0_12:UpdateBtnStyle(iter1_18, var0_18 and var6_12 or arg0_12.greySprite)
					end
				else
					for iter2_18, iter3_18 in ipairs(var8_12) do
						local var2_18 = var3_12[iter2_18] ~= var3_12[1] and bit.band(arg0_12.contextData.indexDatas[var0_12], var3_12[iter2_18]) > 0
						local var3_18 = findTF(iter3_18, "Image")

						arg0_12:UpdateBtnStyle(iter3_18, var2_18 and var6_12 or arg0_12.greySprite)
					end
				end
			end,
			[var0_0.Mode.OR] = function()
				for iter0_19, iter1_19 in ipairs(var8_12) do
					local var0_19 = var3_12[iter0_19] == arg0_12.contextData.indexDatas[var0_12]
					local var1_19 = findTF(iter1_19, "Image")

					arg0_12:UpdateBtnStyle(iter1_19, var0_19 and var6_12 or arg0_12.greySprite)
				end
			end,
			[var0_0.Mode.NUM] = function()
				for iter0_20, iter1_20 in ipairs(var8_12) do
					local var0_20 = bit.band(arg0_12.contextData.indexDatas[var0_12], var3_12[iter0_20]) > 0
					local var1_20 = findTF(iter1_20, "Image")

					arg0_12:UpdateBtnStyle(iter1_20, var0_20 and var6_12 or arg0_12.greySprite)
				end
			end
		})
		arg0_12:OnDatasChange(var0_12)

		if arg0_12.simpleDropdownDic[var0_12] then
			for iter0_17, iter1_17 in pairs(arg0_12.simpleDropdownDic[var0_12]) do
				iter1_17:UpdateVirtualBtn()
			end
		end
	end

	table.insert(arg0_12.updateList, var7_12)

	if arg1_12.simpleDropdown then
		assert(var4_12 == var0_0.Mode.OR, "simpleDropdown目前只支持OR模式")

		local var10_12 = var2_12:Find("bg"):GetChild(0)

		for iter4_12, iter5_12 in ipairs(arg1_12.simpleDropdown) do
			local var11_12 = arg0_12.contextData.customPanels[iter5_12]
			local var12_12 = cloneTplTo(var10_12, var2_12:Find("bg"))

			var12_12.name = iter5_12 .. "_simple"

			local var13_12 = SimpleDropdown.New(arg0_12.panel, arg0_12.event, arg0_12.contextData, var0_12, var12_12, var11_12, var7_12, arg0_12.greySprite, arg0_12.yellowSprite)

			setActive(arg0_12:findTF("dropdown", var12_12), true)
			onButton(arg0_12, var12_12, function()
				local var0_21 = arg0_12.panel:InverseTransformPoint(var12_12.position)

				if not var13_12:GetLoaded() then
					var13_12:Load()
				end

				var13_12:ActionInvoke("Show", var0_21)
			end)

			arg0_12.simpleDropdownDic[var0_12] = arg0_12.simpleDropdownDic[var0_12] or {}
			arg0_12.simpleDropdownDic[var0_12][iter5_12] = var13_12
		end
	end
end

function var0_0.UpdateBtnStyle(arg0_22, arg1_22, arg2_22)
	setImageSprite(arg1_22, arg2_22)
end

function var0_0.OnDatasChange(arg0_23, arg1_23)
	local var0_23 = arg0_23.contextData.dropdownLimit or {}

	for iter0_23, iter1_23 in pairs(arg0_23.dropdownDic) do
		if var0_23[iter0_23] ~= nil then
			local var1_23 = var0_23[iter0_23].include
			local var2_23 = var0_23[iter0_23].exclude

			if var2_23[arg1_23] ~= nil or var1_23[arg1_23] ~= nil then
				local var3_23 = arg0_23.contextData.indexDatas[arg1_23]
				local var4_23 = false

				if var2_23[arg1_23] ~= nil and var3_23 == var2_23[arg1_23] then
					var4_23 = false
				elseif var1_23[arg1_23] ~= nil then
					var4_23 = bit.band(var3_23, var1_23[arg1_23]) > 0
				end

				setActive(arg0_23.dropdownDic[iter0_23].virtualBtn, var4_23)

				if not arg0_23.onInit then
					arg0_23.contextData.indexDatas[iter0_23] = arg0_23.contextData.customPanels[iter0_23].options[1]
				end

				arg0_23.dropdownDic[iter0_23]:UpdateVirtualBtn()
				arg0_23.dropdownDic[iter0_23]:ActionInvoke("SelectLast")
			end
		end
	end
end

function var0_0.willExit(arg0_24)
	LeanTween.cancel(go(arg0_24.panel))

	for iter0_24, iter1_24 in pairs(arg0_24.dropdownDic) do
		iter1_24:Destroy()
	end

	for iter2_24, iter3_24 in pairs(arg0_24.simpleDropdownDic) do
		for iter4_24, iter5_24 in pairs(iter3_24) do
			iter5_24:Destroy()
		end
	end

	arg0_24.updateList = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0_24._tf)
end

function var0_0.Clone2Full(arg0_25, arg1_25)
	local var0_25 = {}
	local var1_25 = arg0_25:GetChild(0)
	local var2_25 = arg0_25.childCount

	for iter0_25 = 0, var2_25 - 1 do
		table.insert(var0_25, arg0_25:GetChild(iter0_25))
	end

	for iter1_25 = var2_25, arg1_25 - 1 do
		local var3_25 = cloneTplTo(var1_25, arg0_25)

		var3_25.name = iter1_25

		table.insert(var0_25, tf(var3_25))
	end

	local var4_25 = arg0_25.childCount

	for iter2_25 = 0, var4_25 - 1 do
		setActive(arg0_25:GetChild(iter2_25), iter2_25 < arg1_25)
	end

	for iter3_25 = var4_25, arg1_25 + 1, -1 do
		table.remove(var0_25)
	end

	return var0_25
end

return var0_0

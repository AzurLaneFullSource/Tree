local var0 = class("CustomIndexLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "CustomIndexUI"
end

var0.Mode = {
	OR = 2,
	AND = 1,
	NUM = 3
}

function var0.init(arg0)
	arg0.panel = arg0._tf:Find("index_panel")
	arg0.layout = arg0.panel:Find("layout")
	arg0.contianer = arg0.layout:Find("container")

	eachChild(arg0.contianer, function(arg0)
		setActive(arg0, false)
	end)

	arg0.panelTemplate = arg0.layout:Find("container/Template")
	arg0.displayList = {}
	arg0.typeList = {}
	arg0.btnConfirm = arg0:findTF("layout/btns/ok", arg0.panel)
	arg0.btnCancel = arg0:findTF("layout/btns/cancel", arg0.panel)

	setText(arg0:findTF("Image", arg0.btnConfirm), i18n("text_confirm"))
	setText(arg0:findTF("Image", arg0.btnCancel), i18n("text_cancel"))

	arg0.greySprite = arg0:findTF("resource/grey", arg0.panel):GetComponent(typeof(Image)).sprite
	arg0.blueSprite = arg0:findTF("resource/blue", arg0.panel):GetComponent(typeof(Image)).sprite
	arg0.yellowSprite = arg0:findTF("resource/yellow", arg0.panel):GetComponent(typeof(Image)).sprite
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.btnConfirm, function()
		if arg0.contextData.callback then
			arg0.contextData.callback(arg0.contextData.indexDatas)

			arg0.contextData.callback = nil
		end

		arg0:emit(var0.ON_CLOSE)
	end, SFX_CONFIRM)
	onButton(arg0, arg0.btnCancel, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("btn", arg0.panel), function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)

	arg0.panel.localScale = Vector3.zero

	LeanTween.scale(arg0.panel, Vector3(1, 1, 1), 0.2)
	setText(arg0.panel:Find("layout/tip"), arg0.contextData.tip or "")
	arg0:InitGroup()
	arg0:BlurPanel()
end

function var0.BlurPanel(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.InitGroup(arg0)
	arg0.onInit = true
	arg0.contextData.indexDatas = arg0.contextData.indexDatas or {}
	arg0.dropdownDic = {}
	arg0.updateList = {}
	arg0.simpleDropdownDic = {}

	for iter0, iter1 in pairs(arg0.contextData.groupList) do
		if iter1.dropdown then
			arg0:InitDropdown(iter1)
		else
			arg0:InitCustoms(iter1)
		end
	end

	for iter2, iter3 in ipairs(arg0.updateList) do
		iter3()
	end

	if arg0.contextData.customPanels.minHeight then
		GetOrAddComponent(arg0.layout, typeof(LayoutElement)).minHeight = arg0.contextData.customPanels.minHeight
	end

	if arg0.contextData.customPanels.layoutPos then
		setLocalPosition(arg0.layout, arg0.contextData.customPanels.layoutPos)
	end

	arg0.onInit = false
end

function var0.InitDropdown(arg0, arg1)
	local var0 = arg1.tags
	local var1 = tf(Instantiate(arg0.panelTemplate))

	setParent(var1, arg0.contianer, false)
	setActive(var1, true)

	local var2 = var0.Clone2Full(var1:Find("bg"), #var0)

	go(var1).name = arg1.titleTxt

	setText(var1:Find("title/Image"), i18n(arg1.titleTxt))
	setText(var1:Find("title/Image/Image_en"), i18n(arg1.titleENTxt))

	var1:Find("bg"):GetComponent(typeof(ScrollRect)).enabled = false

	for iter0, iter1 in ipairs(var0) do
		local var3 = var2[iter0]

		setActive(arg0:findTF("dropdown", var3), true)

		local var4 = CustomDropdown.New(arg0.panel, arg0.event, arg0.contextData, iter1, var3)

		onButton(arg0, var3, function()
			local var0 = arg0.panel:InverseTransformPoint(var3.position)

			if not var4:GetLoaded() then
				var4:Load()
			end

			var4:ActionInvoke("Show", var0)
		end)

		arg0.dropdownDic[iter1] = var4
	end
end

function var0.InitCustoms(arg0, arg1)
	local var0 = arg1.tags[1]
	local var1 = arg0.contextData.customPanels[var0]
	local var2 = tf(Instantiate(arg0.panelTemplate))

	setParent(var2, arg0.contianer, false)
	setActive(var2, true)

	go(var2).name = arg1.titleTxt

	setText(var2:Find("title/Image"), i18n(arg1.titleTxt))
	setText(var2:Find("title/Image/Image_en"), i18n(arg1.titleENTxt))

	var2:Find("bg"):GetComponent(typeof(ScrollRect)).enabled = false

	local var3 = var1.options
	local var4 = var1.mode or var0.Mode.OR
	local var5 = 0
	local var6 = var1.blueSeleted and arg0.blueSprite or arg0.yellowSprite

	for iter0, iter1 in ipairs(var3) do
		var5 = bit.bor(iter1, var5)
	end

	arg0.contextData.indexDatas[var0] = arg0.contextData.indexDatas[var0] or var3[1]

	local var7
	local var8 = var0.Clone2Full(var2:Find("bg"), #var3)

	for iter2, iter3 in ipairs(var8) do
		local var9 = var3[iter2]

		setText(findTF(iter3, "Image"), i18n(var1.names[iter2]))
		setImageSprite(iter3, arg0.greySprite)
		onButton(arg0, iter3, function()
			switch(var4, {
				[var0.Mode.AND] = function()
					if iter2 == 1 or arg0.contextData.indexDatas[var0] == var3[1] then
						arg0.contextData.indexDatas[var0] = var9
					else
						arg0.contextData.indexDatas[var0] = bit.bxor(arg0.contextData.indexDatas[var0], var9)
					end

					if arg0.contextData.indexDatas[var0] == 0 or arg0.contextData.indexDatas[var0] == var5 then
						arg0.contextData.indexDatas[var0] = var3[1]
					end
				end,
				[var0.Mode.OR] = function()
					if var1.isSort then
						arg0.contextData.indexDatas[var0] = var9
					else
						local var0 = arg0.contextData.indexDatas[var0]

						arg0.contextData.indexDatas[var0] = var9 == var0 and var3[1] or var9
					end
				end,
				[var0.Mode.NUM] = function()
					local var0 = arg0.contextData.indexDatas[var0]
					local var1 = 0

					while var0 > 0 do
						var1 = var1 + 1
						var0 = bit.band(var0, var0 - 1)
					end

					if var1 < var1.num or bit.band(arg0.contextData.indexDatas[var0], var9) > 0 then
						arg0.contextData.indexDatas[var0] = bit.bxor(arg0.contextData.indexDatas[var0], var9)
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_share_exceedlimit"))
					end
				end
			})
			var7()
		end, SFX_UI_TAG)
	end

	function var7()
		switch(var4, {
			[var0.Mode.AND] = function()
				if arg0.contextData.indexDatas[var0] == var3[1] then
					for iter0, iter1 in ipairs(var8) do
						local var0 = var3[iter0] == var3[1]
						local var1 = findTF(iter1, "Image")

						setImageSprite(iter1, var0 and var6 or arg0.greySprite)
					end
				else
					for iter2, iter3 in ipairs(var8) do
						local var2 = var3[iter2] ~= var3[1] and bit.band(arg0.contextData.indexDatas[var0], var3[iter2]) > 0
						local var3 = findTF(iter3, "Image")

						setImageSprite(iter3, var2 and var6 or arg0.greySprite)
					end
				end
			end,
			[var0.Mode.OR] = function()
				for iter0, iter1 in ipairs(var8) do
					local var0 = var3[iter0] == arg0.contextData.indexDatas[var0]
					local var1 = findTF(iter1, "Image")

					setImageSprite(iter1, var0 and var6 or arg0.greySprite)
				end
			end,
			[var0.Mode.NUM] = function()
				for iter0, iter1 in ipairs(var8) do
					local var0 = bit.band(arg0.contextData.indexDatas[var0], var3[iter0]) > 0
					local var1 = findTF(iter1, "Image")

					setImageSprite(iter1, var0 and var6 or arg0.greySprite)
				end
			end
		})
		arg0:OnDatasChange(var0)

		if arg0.simpleDropdownDic[var0] then
			for iter0, iter1 in pairs(arg0.simpleDropdownDic[var0]) do
				iter1:UpdateVirtualBtn()
			end
		end
	end

	table.insert(arg0.updateList, var7)

	if arg1.simpleDropdown then
		assert(var4 == var0.Mode.OR, "simpleDropdown目前只支持OR模式")

		local var10 = var2:Find("bg"):GetChild(0)

		for iter4, iter5 in ipairs(arg1.simpleDropdown) do
			local var11 = arg0.contextData.customPanels[iter5]
			local var12 = cloneTplTo(var10, var2:Find("bg"))

			var12.name = iter5 .. "_simple"

			local var13 = SimpleDropdown.New(arg0.panel, arg0.event, arg0.contextData, var0, var12, var11, var7, arg0.greySprite, arg0.yellowSprite)

			setActive(arg0:findTF("dropdown", var12), true)
			onButton(arg0, var12, function()
				local var0 = arg0.panel:InverseTransformPoint(var12.position)

				if not var13:GetLoaded() then
					var13:Load()
				end

				var13:ActionInvoke("Show", var0)
			end)

			arg0.simpleDropdownDic[var0] = arg0.simpleDropdownDic[var0] or {}
			arg0.simpleDropdownDic[var0][iter5] = var13
		end
	end
end

function var0.OnDatasChange(arg0, arg1)
	local var0 = arg0.contextData.dropdownLimit or {}

	for iter0, iter1 in pairs(arg0.dropdownDic) do
		if var0[iter0] ~= nil then
			local var1 = var0[iter0].include
			local var2 = var0[iter0].exclude

			if var2[arg1] ~= nil or var1[arg1] ~= nil then
				local var3 = arg0.contextData.indexDatas[arg1]
				local var4 = false

				if var2[arg1] ~= nil and var3 == var2[arg1] then
					var4 = false
				elseif var1[arg1] ~= nil then
					var4 = bit.band(var3, var1[arg1]) > 0
				end

				setActive(arg0.dropdownDic[iter0].virtualBtn, var4)

				if not arg0.onInit then
					arg0.contextData.indexDatas[iter0] = arg0.contextData.customPanels[iter0].options[1]
				end

				arg0.dropdownDic[iter0]:UpdateVirtualBtn()
				arg0.dropdownDic[iter0]:ActionInvoke("SelectLast")
			end
		end
	end
end

function var0.willExit(arg0)
	LeanTween.cancel(go(arg0.panel))

	for iter0, iter1 in pairs(arg0.dropdownDic) do
		iter1:Destroy()
	end

	for iter2, iter3 in pairs(arg0.simpleDropdownDic) do
		for iter4, iter5 in pairs(iter3) do
			iter5:Destroy()
		end
	end

	arg0.updateList = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.Clone2Full(arg0, arg1)
	local var0 = {}
	local var1 = arg0:GetChild(0)
	local var2 = arg0.childCount

	for iter0 = 0, var2 - 1 do
		table.insert(var0, arg0:GetChild(iter0))
	end

	for iter1 = var2, arg1 - 1 do
		local var3 = cloneTplTo(var1, arg0)

		var3.name = iter1

		table.insert(var0, tf(var3))
	end

	local var4 = arg0.childCount

	for iter2 = 0, var4 - 1 do
		setActive(arg0:GetChild(iter2), iter2 < arg1)
	end

	for iter3 = var4, arg1 + 1, -1 do
		table.remove(var0)
	end

	return var0
end

return var0

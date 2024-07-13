local var0_0 = class("WorldMediaCollectionFileDetailLayer", import(".WorldMediaCollectionSubLayer"))

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionFileDetailUI"
end

function var0_0.OnInit(arg0_2)
	assert(arg0_2.viewParent, "Need assign ViewParent for " .. arg0_2.__cname)
	onButton(arg0_2, arg0_2._tf:Find("Buttom"), function()
		arg0_2.viewParent:Backward()
	end)

	arg0_2.anim = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.canvasGroup = arg0_2._tf:GetComponent(typeof(CanvasGroup))

	arg0_2:InitDocument()

	local var0_2 = arg0_2._tf:Find("ArchiveList")

	arg0_2.scrollComp = var0_2:GetComponent("LScrollRect")
	arg0_2.fileChild = {}
	arg0_2.fileChildIndex = {}

	function arg0_2.scrollComp.onUpdateItem(arg0_4, ...)
		arg0_2:OnUpdateFile(arg0_4 + 1, ...)
	end

	setActive(var0_2:Find("Item"), false)

	arg0_2.loader = AutoLoader.New()

	setText(arg0_2._tf:Find("ArchiveList/ProgressDesc"), i18n("world_collection_1"))
end

function var0_0.InitDocument(arg0_5)
	arg0_5.document = arg0_5._tf:Find("Document")
	arg0_5.documentContentTF = arg0_5.document:Find("Viewport/Content")
	arg0_5.documentHead = arg0_5.documentContentTF:Find("Head")
	arg0_5.documentBody = arg0_5.documentContentTF:Find("Body")
	arg0_5.documentTitle = arg0_5.documentHead:Find("Title")
	arg0_5.documentRect = arg0_5.documentBody:Find("Rect")
	arg0_5.documentTip = arg0_5.documentRect:Find("SubTitle")
	arg0_5.documentText = arg0_5.documentRect:Find("Text")
	arg0_5.documentImage = arg0_5.documentRect:Find("Image")
	arg0_5.documentStamp = arg0_5.documentImage:Find("ClassifiedStamp")
end

function var0_0.Openning(arg0_6)
	arg0_6.anim:Play("Enter")
	arg0_6:Enter()
end

function var0_0.Enter(arg0_7)
	local function var0_7()
		local var0_8 = nowWorld():GetCollectionProxy()
		local var1_8 = WorldCollectionProxy.GetCollectionFileGroupTemplate(arg0_7.contextData.FileGroupIndex)

		for iter0_8, iter1_8 in ipairs(var1_8.child) do
			if var0_8:IsUnlock(iter1_8) then
				return iter0_8
			end
		end
	end

	local var1_7 = arg0_7.contextData.SelectedFile or var0_7()

	arg0_7.contextData.SelectedFile = nil

	arg0_7:UpdateView()
	arg0_7:SwitchFileIndex(var1_7)
end

function var0_0.Hide(arg0_9)
	arg0_9.canvasGroup.alpha = 1

	var0_0.super.Hide(arg0_9)
end

function var0_0.UpdateView(arg0_10)
	assert(arg0_10.contextData.FileGroupIndex, "Not Initialize FileGroupIndex")

	arg0_10.archiveList = _.map(WorldCollectionProxy.GetCollectionFileGroupTemplate(arg0_10.contextData.FileGroupIndex).child, function(arg0_11)
		return WorldCollectionProxy.GetCollectionTemplate(arg0_11)
	end)

	local var0_10 = nowWorld():GetCollectionProxy()
	local var1_10 = WorldCollectionProxy.GetCollectionFileGroupTemplate(arg0_10.contextData.FileGroupIndex)
	local var2_10 = 0
	local var3_10 = #var1_10.child

	for iter0_10, iter1_10 in ipairs(var1_10.child) do
		if var0_10:IsUnlock(iter1_10) then
			var2_10 = var2_10 + 1
		end
	end

	setText(arg0_10._tf:Find("ArchiveList/ProgressDesc/ProgressText"), var2_10 .. "/" .. var3_10)
	arg0_10.scrollComp:SetTotalCount(#arg0_10.archiveList)
end

local function var1_0(arg0_12)
	return (string.char(226, 133, 160 + (arg0_12 - 1)))
end

function var0_0.OnUpdateFile(arg0_13, arg1_13, arg2_13)
	if arg0_13.exited then
		return
	end

	local var0_13 = arg0_13.archiveList[arg1_13]

	if arg0_13.fileChildIndex[arg2_13] and arg0_13.fileChildIndex[arg2_13] ~= arg1_13 then
		local var1_13 = arg0_13.fileChildIndex[arg2_13]

		arg0_13.fileChild[var1_13] = nil
	end

	arg0_13.fileChildIndex[arg2_13] = arg1_13
	arg0_13.fileChild[arg1_13] = arg2_13

	local var2_13 = nowWorld():GetCollectionProxy()
	local var3_13 = tf(arg2_13)
	local var4_13 = WorldCollectionProxy.GetCollectionFileGroupTemplate(arg0_13.contextData.FileGroupIndex)
	local var5_13 = var2_13:IsUnlock(var0_13.id)
	local var6_13 = arg1_13 == arg0_13.contextData.SelectedFile

	setActive(var3_13:Find("Selected"), var6_13)

	local var7_13 = string.format("%s %s", shortenString(var4_13.name or "", 6), var1_0(var0_13.group_ID))

	setText(var3_13:Find("Desc"), setColorStr(var7_13, var6_13 and "#000" or COLOR_WHITE))
	setActive(var3_13:Find("Desc"), var5_13)
	setActive(var3_13:Find("Icon"), var5_13)
	setActive(var3_13:Find("Cover"), var5_13)
	setActive(var3_13:Find("Locked"), not var5_13)
	arg0_13.loader:GetSprite("ui/WorldMediaCollectionFileDetailUI_atlas", "cover" .. var4_13.type, var3_13:Find("Cover"))
	onButton(arg0_13, var3_13, function()
		if not nowWorld():GetCollectionProxy():IsUnlock(var0_13.id) then
			return
		end

		arg0_13:SwitchFileIndex(arg1_13)
	end, SFX_PANEL)
end

function var0_0.SwitchFileIndex(arg0_15, arg1_15)
	if arg0_15.contextData.SelectedFile and arg0_15.contextData.SelectedFile == arg1_15 then
		return
	end

	local var0_15 = arg1_15 and arg0_15.archiveList[arg1_15]

	if var0_15 and nowWorld():GetCollectionProxy():IsUnlock(var0_15.id) then
		local var1_15 = arg0_15.contextData.SelectedFile
		local var2_15 = arg0_15.fileChild[var1_15]

		arg0_15.contextData.SelectedFile = arg1_15

		if var2_15 then
			arg0_15:OnUpdateFile(var1_15, var2_15)
		end

		if arg0_15.fileChild[arg1_15] then
			arg0_15:OnUpdateFile(arg1_15, arg0_15.fileChild[arg1_15])
		end

		setActive(arg0_15.document, true)
		setText(arg0_15.document:Find("Head/Title"), var0_15.name)
		arg0_15:SetDocument(var0_15)
	else
		setActive(arg0_15.document, false)
	end
end

function var0_0.SetDocument(arg0_16, arg1_16, arg2_16)
	setText(arg0_16.documentTitle, arg1_16.name)

	local var0_16 = arg1_16.pic

	if var0_16 and #var0_16 > 0 then
		local var1_16 = LoadSprite("CollectionFileIllustration/" .. var0_16, "")

		setImageSprite(arg0_16.documentImage, var1_16, true)
		setActive(arg0_16.documentImage, var1_16)

		if var1_16 then
			setActive(arg0_16.documentStamp, arg1_16.is_classified == 1)

			if arg1_16.is_classified == 1 then
				local var2_16 = WorldCollectionProxy.GetCollectionGroup(arg1_16.id)
				local var3_16 = WorldCollectionProxy.GetCollectionFileGroupTemplate(var2_16).type

				arg0_16.loader:GetSprite("ui/WorldMediaCollectionFileDetailUI_atlas", "stamp" .. var3_16, arg0_16.documentStamp)
			end
		end
	else
		setActive(arg0_16.documentImage, false)
	end

	arg0_16:SetDocumentText(arg1_16.content, arg1_16.subTitle, arg2_16)
end

function var0_0.getTextPreferredHeight(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.cachedTextGeneratorForLayout
	local var1_17 = arg0_17:GetGenerationSettings(Vector2(arg1_17, 0))

	return ReflectionHelp.RefCallMethod(typeof("UnityEngine.TextGenerator"), "GetPreferredHeight", var0_17, {
		typeof("System.String"),
		typeof("UnityEngine.TextGenerationSettings")
	}, {
		arg2_17,
		var1_17
	}) / arg0_17.pixelsPerUnit
end

function var0_0.SetDocumentText(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg0_18.documentRect.rect.width
	local var1_18 = isActive(arg0_18.documentImage)
	local var2_18 = var1_18 and arg0_18.documentImage.rect.width or 0
	local var3_18 = math.max(var0_18 - var2_18, 0)
	local var4_18 = arg0_18.documentImage.rect.height
	local var5_18 = var1_18 and var4_18 + 100 or 0
	local var6_18 = arg0_18.documentText:GetComponent(typeof(Text))

	var6_18.text = ""

	local var7_18 = ""

	local function var8_18()
		local var0_19 = 0

		if isActive(arg0_18.documentHead) then
			var0_19 = var0_19 + arg0_18.documentHead:GetComponent(typeof(LayoutElement)).preferredHeight
		end

		local var1_19 = arg0_18.documentBody:GetComponent("LayoutGroup")
		local var2_19 = var0_19 + (var1_19.padding.top + var1_19.padding.bottom)

		setActive(arg0_18.documentTip, arg2_18 and #arg2_18 > 0)

		local var3_19 = 0

		if arg2_18 and #arg2_18 > 0 then
			local var4_19 = arg0_18.documentTip:Find("Text"):GetComponent(typeof(Text))

			var4_19.text = arg2_18
			var3_19 = var0_0.getTextPreferredHeight(var4_19, var0_18, arg2_18)
			var3_19 = var3_19 + arg0_18.documentRect:GetComponent(typeof(VerticalLayoutGroup)).spacing
			var2_19 = var2_19 + var3_19
		end

		if var1_18 then
			arg0_18.documentImage.anchoredPosition = Vector2(0, -50 - var3_19)
		end

		local var5_19 = var0_0.getTextPreferredHeight(var6_18, var0_18, var7_18)
		local var6_19 = var2_19 + var5_19
		local var7_19 = arg0_18.documentContentTF.sizeDelta

		var7_19.y = var6_19
		arg0_18.documentContentTF.sizeDelta = var7_19

		local var8_19 = arg0_18.document:Find("Viewport")
		local var9_19 = arg0_18.document:Find("Arrow")
		local var10_19 = var8_19.rect.height

		setActive(var9_19, var10_19 < var6_19)

		local var11_19 = arg0_18.document:GetComponent(typeof(ScrollRect))

		var11_19.onValueChanged:RemoveAllListeners()

		arg3_18 = arg3_18 or 0

		local var12_19 = math.max(var5_19 - var10_19, 0) * arg3_18

		arg0_18.documentContentTF.anchoredPosition = Vector2(0, var12_19)
		var11_19.velocity = Vector2.zero

		if var10_19 < var6_19 then
			onScroll(arg0_18, arg0_18.document, function(arg0_20)
				setActive(var9_19, arg0_20.y > 0.01)
			end)
		end
	end

	if not var1_18 then
		var7_18 = arg1_18
		var6_18.text = var7_18

		var8_18()

		return
	end

	local var9_18, var10_18 = arg0_18.SplitRichAndLetters(arg1_18)
	local var11_18 = 1
	local var12_18 = 1

	local function var13_18(arg0_21)
		local var0_21 = ""
		local var1_21 = ""
		local var2_21 = {}

		for iter0_21 = arg0_21 and 1 or var12_18, #var10_18 do
			if var10_18[iter0_21].start > var9_18[var11_18].start then
				break
			end

			local var3_21 = var10_18[iter0_21]

			if iter0_21 == var12_18 then
				var12_18 = var12_18 + 1
				var0_21 = var0_21 .. var3_21.value
			end

			if arg0_21 then
				if var3_21.EndTagIndex then
					var2_21[#var2_21 + 1] = var3_21.EndTagIndex
				else
					table.remove(var2_21)
				end
			end
		end

		local var4_21 = ""

		if var11_18 <= #var9_18 then
			var4_21 = var9_18[var11_18].value
		end

		for iter1_21, iter2_21 in ipairs(var2_21) do
			var1_21 = var10_18[iter2_21].value .. var1_21
		end

		var11_18 = var11_18 + 1

		return var4_21, var0_21, var1_21
	end

	local var14_18 = 0

	while var14_18 < var5_18 and var11_18 < #var9_18 do
		local var15_18, var16_18, var17_18 = var13_18(true)
		local var18_18 = var7_18 .. var16_18 .. var15_18 .. var17_18

		var6_18.text = var18_18

		if var3_18 < var6_18.preferredWidth then
			var18_18 = var7_18 .. "\n" .. var16_18 .. var15_18
		else
			var18_18 = var7_18 .. var16_18 .. var15_18
		end

		var7_18 = var18_18
		var6_18.text = var7_18
		var14_18 = var0_0.getTextPreferredHeight(var6_18, var6_18.preferredWidth, var7_18)
	end

	for iter0_18 = var11_18, #var9_18 do
		local var19_18, var20_18 = var13_18(false)

		var7_18 = var7_18 .. var20_18 .. var19_18
	end

	local var21_18, var22_18, var23_18 = var13_18(true)

	var7_18 = var7_18 .. var23_18
	var6_18.text = var7_18

	var8_18()
end

function var0_0.SplitRichAndLetters(arg0_22)
	local var0_22 = 1
	local var1_22 = "<([^>]*)>"
	local var2_22 = {}
	local var3_22 = {}

	while true do
		local var4_22, var5_22 = string.find(arg0_22, var1_22, var0_22)

		if not var5_22 then
			break
		end

		local var6_22 = string.sub(arg0_22, var4_22, var5_22)
		local var7_22 = string.find(var6_22, "=")
		local var8_22 = string.find(var6_22, "/")

		if not var8_22 and not var7_22 then
			var0_22 = var5_22 + 1
		else
			table.insert(var2_22, {
				value = var6_22,
				start = var4_22
			})

			if var7_22 then
				var3_22[#var3_22 + 1] = #var2_22
			elseif var8_22 and #var3_22 > 0 then
				var2_22[table.remove(var3_22)].EndTagIndex = #var2_22
			end

			local var9_22 = string.sub(arg0_22, var5_22 + 1, -1)

			arg0_22 = string.sub(arg0_22, 1, var4_22 - 1) .. var9_22
			var0_22 = var4_22
		end
	end

	local var10_22 = {}
	local var11_22 = 1
	local var12_22 = false
	local var13_22 = 1

	while true do
		local var14_22, var15_22 = string.find(arg0_22, "[\x01-\x7FÂ-ô][€-¿]*", var11_22)

		if not var15_22 then
			var10_22[#var10_22 + 1] = {
				value = string.sub(arg0_22, var13_22, #arg0_22),
				start = var13_22
			}

			break
		end

		local var16_22 = string.sub(arg0_22, var14_22, var15_22)
		local var17_22 = false

		if PLATFORM_CODE == PLATFORM_US then
			local var18_22 = var16_22 == "Â " or var16_22 == " "

			if var12_22 ~= var18_22 then
				var17_22 = var14_22 > 1
			end

			var12_22 = var18_22
		else
			var17_22 = var14_22 > 1
		end

		if var17_22 then
			var10_22[#var10_22 + 1] = {
				value = string.sub(arg0_22, var13_22, var14_22 - 1),
				start = var13_22
			}
			var13_22 = var14_22
		end

		var11_22 = var15_22 + 1
	end

	return var10_22, var2_22
end

return var0_0

local var0 = class("WorldMediaCollectionFileDetailLayer", import(".WorldMediaCollectionSubLayer"))

function var0.getUIName(arg0)
	return "WorldMediaCollectionFileDetailUI"
end

function var0.OnInit(arg0)
	assert(arg0.viewParent, "Need assign ViewParent for " .. arg0.__cname)
	onButton(arg0, arg0._tf:Find("Buttom"), function()
		arg0.viewParent:Backward()
	end)

	arg0.anim = arg0._tf:GetComponent(typeof(Animation))
	arg0.canvasGroup = arg0._tf:GetComponent(typeof(CanvasGroup))

	arg0:InitDocument()

	local var0 = arg0._tf:Find("ArchiveList")

	arg0.scrollComp = var0:GetComponent("LScrollRect")
	arg0.fileChild = {}
	arg0.fileChildIndex = {}

	function arg0.scrollComp.onUpdateItem(arg0, ...)
		arg0:OnUpdateFile(arg0 + 1, ...)
	end

	setActive(var0:Find("Item"), false)

	arg0.loader = AutoLoader.New()

	setText(arg0._tf:Find("ArchiveList/ProgressDesc"), i18n("world_collection_1"))
end

function var0.InitDocument(arg0)
	arg0.document = arg0._tf:Find("Document")
	arg0.documentContentTF = arg0.document:Find("Viewport/Content")
	arg0.documentHead = arg0.documentContentTF:Find("Head")
	arg0.documentBody = arg0.documentContentTF:Find("Body")
	arg0.documentTitle = arg0.documentHead:Find("Title")
	arg0.documentRect = arg0.documentBody:Find("Rect")
	arg0.documentTip = arg0.documentRect:Find("SubTitle")
	arg0.documentText = arg0.documentRect:Find("Text")
	arg0.documentImage = arg0.documentRect:Find("Image")
	arg0.documentStamp = arg0.documentImage:Find("ClassifiedStamp")
end

function var0.Openning(arg0)
	arg0.anim:Play("Enter")
	arg0:Enter()
end

function var0.Enter(arg0)
	local function var0()
		local var0 = nowWorld():GetCollectionProxy()
		local var1 = WorldCollectionProxy.GetCollectionFileGroupTemplate(arg0.contextData.FileGroupIndex)

		for iter0, iter1 in ipairs(var1.child) do
			if var0:IsUnlock(iter1) then
				return iter0
			end
		end
	end

	local var1 = arg0.contextData.SelectedFile or var0()

	arg0.contextData.SelectedFile = nil

	arg0:UpdateView()
	arg0:SwitchFileIndex(var1)
end

function var0.Hide(arg0)
	arg0.canvasGroup.alpha = 1

	var0.super.Hide(arg0)
end

function var0.UpdateView(arg0)
	assert(arg0.contextData.FileGroupIndex, "Not Initialize FileGroupIndex")

	arg0.archiveList = _.map(WorldCollectionProxy.GetCollectionFileGroupTemplate(arg0.contextData.FileGroupIndex).child, function(arg0)
		return WorldCollectionProxy.GetCollectionTemplate(arg0)
	end)

	local var0 = nowWorld():GetCollectionProxy()
	local var1 = WorldCollectionProxy.GetCollectionFileGroupTemplate(arg0.contextData.FileGroupIndex)
	local var2 = 0
	local var3 = #var1.child

	for iter0, iter1 in ipairs(var1.child) do
		if var0:IsUnlock(iter1) then
			var2 = var2 + 1
		end
	end

	setText(arg0._tf:Find("ArchiveList/ProgressDesc/ProgressText"), var2 .. "/" .. var3)
	arg0.scrollComp:SetTotalCount(#arg0.archiveList)
end

local function var1(arg0)
	return (string.char(226, 133, 160 + (arg0 - 1)))
end

function var0.OnUpdateFile(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.archiveList[arg1]

	if arg0.fileChildIndex[arg2] and arg0.fileChildIndex[arg2] ~= arg1 then
		local var1 = arg0.fileChildIndex[arg2]

		arg0.fileChild[var1] = nil
	end

	arg0.fileChildIndex[arg2] = arg1
	arg0.fileChild[arg1] = arg2

	local var2 = nowWorld():GetCollectionProxy()
	local var3 = tf(arg2)
	local var4 = WorldCollectionProxy.GetCollectionFileGroupTemplate(arg0.contextData.FileGroupIndex)
	local var5 = var2:IsUnlock(var0.id)
	local var6 = arg1 == arg0.contextData.SelectedFile

	setActive(var3:Find("Selected"), var6)

	local var7 = string.format("%s %s", shortenString(var4.name or "", 6), var1(var0.group_ID))

	setText(var3:Find("Desc"), setColorStr(var7, var6 and "#000" or COLOR_WHITE))
	setActive(var3:Find("Desc"), var5)
	setActive(var3:Find("Icon"), var5)
	setActive(var3:Find("Cover"), var5)
	setActive(var3:Find("Locked"), not var5)
	arg0.loader:GetSprite("ui/WorldMediaCollectionFileDetailUI_atlas", "cover" .. var4.type, var3:Find("Cover"))
	onButton(arg0, var3, function()
		if not nowWorld():GetCollectionProxy():IsUnlock(var0.id) then
			return
		end

		arg0:SwitchFileIndex(arg1)
	end, SFX_PANEL)
end

function var0.SwitchFileIndex(arg0, arg1)
	if arg0.contextData.SelectedFile and arg0.contextData.SelectedFile == arg1 then
		return
	end

	local var0 = arg1 and arg0.archiveList[arg1]

	if var0 and nowWorld():GetCollectionProxy():IsUnlock(var0.id) then
		local var1 = arg0.contextData.SelectedFile
		local var2 = arg0.fileChild[var1]

		arg0.contextData.SelectedFile = arg1

		if var2 then
			arg0:OnUpdateFile(var1, var2)
		end

		if arg0.fileChild[arg1] then
			arg0:OnUpdateFile(arg1, arg0.fileChild[arg1])
		end

		setActive(arg0.document, true)
		setText(arg0.document:Find("Head/Title"), var0.name)
		arg0:SetDocument(var0)
	else
		setActive(arg0.document, false)
	end
end

function var0.SetDocument(arg0, arg1, arg2)
	setText(arg0.documentTitle, arg1.name)

	local var0 = arg1.pic

	if var0 and #var0 > 0 then
		local var1 = LoadSprite("CollectionFileIllustration/" .. var0, "")

		setImageSprite(arg0.documentImage, var1, true)
		setActive(arg0.documentImage, var1)

		if var1 then
			setActive(arg0.documentStamp, arg1.is_classified == 1)

			if arg1.is_classified == 1 then
				local var2 = WorldCollectionProxy.GetCollectionGroup(arg1.id)
				local var3 = WorldCollectionProxy.GetCollectionFileGroupTemplate(var2).type

				arg0.loader:GetSprite("ui/WorldMediaCollectionFileDetailUI_atlas", "stamp" .. var3, arg0.documentStamp)
			end
		end
	else
		setActive(arg0.documentImage, false)
	end

	arg0:SetDocumentText(arg1.content, arg1.subTitle, arg2)
end

function var0.getTextPreferredHeight(arg0, arg1, arg2)
	local var0 = arg0.cachedTextGeneratorForLayout
	local var1 = arg0:GetGenerationSettings(Vector2(arg1, 0))

	return ReflectionHelp.RefCallMethod(typeof("UnityEngine.TextGenerator"), "GetPreferredHeight", var0, {
		typeof("System.String"),
		typeof("UnityEngine.TextGenerationSettings")
	}, {
		arg2,
		var1
	}) / arg0.pixelsPerUnit
end

function var0.SetDocumentText(arg0, arg1, arg2, arg3)
	local var0 = arg0.documentRect.rect.width
	local var1 = isActive(arg0.documentImage)
	local var2 = var1 and arg0.documentImage.rect.width or 0
	local var3 = math.max(var0 - var2, 0)
	local var4 = arg0.documentImage.rect.height
	local var5 = var1 and var4 + 100 or 0
	local var6 = arg0.documentText:GetComponent(typeof(Text))

	var6.text = ""

	local var7 = ""

	local function var8()
		local var0 = 0

		if isActive(arg0.documentHead) then
			var0 = var0 + arg0.documentHead:GetComponent(typeof(LayoutElement)).preferredHeight
		end

		local var1 = arg0.documentBody:GetComponent("LayoutGroup")
		local var2 = var0 + (var1.padding.top + var1.padding.bottom)

		setActive(arg0.documentTip, arg2 and #arg2 > 0)

		local var3 = 0

		if arg2 and #arg2 > 0 then
			local var4 = arg0.documentTip:Find("Text"):GetComponent(typeof(Text))

			var4.text = arg2
			var3 = var0.getTextPreferredHeight(var4, var0, arg2)
			var3 = var3 + arg0.documentRect:GetComponent(typeof(VerticalLayoutGroup)).spacing
			var2 = var2 + var3
		end

		if var1 then
			arg0.documentImage.anchoredPosition = Vector2(0, -50 - var3)
		end

		local var5 = var0.getTextPreferredHeight(var6, var0, var7)
		local var6 = var2 + var5
		local var7 = arg0.documentContentTF.sizeDelta

		var7.y = var6
		arg0.documentContentTF.sizeDelta = var7

		local var8 = arg0.document:Find("Viewport")
		local var9 = arg0.document:Find("Arrow")
		local var10 = var8.rect.height

		setActive(var9, var10 < var6)

		local var11 = arg0.document:GetComponent(typeof(ScrollRect))

		var11.onValueChanged:RemoveAllListeners()

		arg3 = arg3 or 0

		local var12 = math.max(var5 - var10, 0) * arg3

		arg0.documentContentTF.anchoredPosition = Vector2(0, var12)
		var11.velocity = Vector2.zero

		if var10 < var6 then
			onScroll(arg0, arg0.document, function(arg0)
				setActive(var9, arg0.y > 0.01)
			end)
		end
	end

	if not var1 then
		var7 = arg1
		var6.text = var7

		var8()

		return
	end

	local var9, var10 = arg0.SplitRichAndLetters(arg1)
	local var11 = 1
	local var12 = 1

	local function var13(arg0)
		local var0 = ""
		local var1 = ""
		local var2 = {}

		for iter0 = arg0 and 1 or var12, #var10 do
			if var10[iter0].start > var9[var11].start then
				break
			end

			local var3 = var10[iter0]

			if iter0 == var12 then
				var12 = var12 + 1
				var0 = var0 .. var3.value
			end

			if arg0 then
				if var3.EndTagIndex then
					var2[#var2 + 1] = var3.EndTagIndex
				else
					table.remove(var2)
				end
			end
		end

		local var4 = ""

		if var11 <= #var9 then
			var4 = var9[var11].value
		end

		for iter1, iter2 in ipairs(var2) do
			var1 = var10[iter2].value .. var1
		end

		var11 = var11 + 1

		return var4, var0, var1
	end

	local var14 = 0

	while var14 < var5 and var11 < #var9 do
		local var15, var16, var17 = var13(true)
		local var18 = var7 .. var16 .. var15 .. var17

		var6.text = var18

		if var3 < var6.preferredWidth then
			var18 = var7 .. "\n" .. var16 .. var15
		else
			var18 = var7 .. var16 .. var15
		end

		var7 = var18
		var6.text = var7
		var14 = var0.getTextPreferredHeight(var6, var6.preferredWidth, var7)
	end

	for iter0 = var11, #var9 do
		local var19, var20 = var13(false)

		var7 = var7 .. var20 .. var19
	end

	local var21, var22, var23 = var13(true)

	var7 = var7 .. var23
	var6.text = var7

	var8()
end

function var0.SplitRichAndLetters(arg0)
	local var0 = 1
	local var1 = "<([^>]*)>"
	local var2 = {}
	local var3 = {}

	while true do
		local var4, var5 = string.find(arg0, var1, var0)

		if not var5 then
			break
		end

		local var6 = string.sub(arg0, var4, var5)
		local var7 = string.find(var6, "=")
		local var8 = string.find(var6, "/")

		if not var8 and not var7 then
			var0 = var5 + 1
		else
			table.insert(var2, {
				value = var6,
				start = var4
			})

			if var7 then
				var3[#var3 + 1] = #var2
			elseif var8 and #var3 > 0 then
				var2[table.remove(var3)].EndTagIndex = #var2
			end

			local var9 = string.sub(arg0, var5 + 1, -1)

			arg0 = string.sub(arg0, 1, var4 - 1) .. var9
			var0 = var4
		end
	end

	local var10 = {}
	local var11 = 1
	local var12 = false
	local var13 = 1

	while true do
		local var14, var15 = string.find(arg0, "[\x01-\x7F\xC2-\xF4][\x80-\xBF]*", var11)

		if not var15 then
			var10[#var10 + 1] = {
				value = string.sub(arg0, var13, #arg0),
				start = var13
			}

			break
		end

		local var16 = string.sub(arg0, var14, var15)
		local var17 = false

		if PLATFORM_CODE == PLATFORM_US then
			local var18 = var16 == " " or var16 == " "

			if var12 ~= var18 then
				var17 = var14 > 1
			end

			var12 = var18
		else
			var17 = var14 > 1
		end

		if var17 then
			var10[#var10 + 1] = {
				value = string.sub(arg0, var13, var14 - 1),
				start = var13
			}
			var13 = var14
		end

		var11 = var15 + 1
	end

	return var10, var2
end

return var0

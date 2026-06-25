local var0_0 = class("EmojiLayer", import("..base.BaseUI"))

var0_0.PageEmojiNums = 8
var0_0.Frequently_Used_Emoji_Num = 6
var0_0.True_Emoji_Num_Of_Page = 15

function var0_0.getUIName(arg0_1)
	return "EmojiUI"
end

function var0_0.init(arg0_2)
	arg0_2.emojiGroup = arg0_2._tf:Find("frame/group")
	arg0_2.emojiType = arg0_2.emojiGroup:Find("type")
	arg0_2.emojiEvent = arg0_2._tf:Find("frame/bg/mask/event")
	arg0_2.emojiSnap = arg0_2._tf:Find("frame/bg/mask/event"):GetComponent("HScrollSnap")

	arg0_2.emojiSnap:Init()

	arg0_2.emojiContent = tf(arg0_2.emojiSnap):Find("content")
	arg0_2.emojiItem = tf(arg0_2.emojiSnap):Find("item")
	arg0_2.emojiDots = arg0_2._tf:Find("frame/dots")
	arg0_2.emojiIconDots = arg0_2._tf:Find("frame/emojiDots")
	arg0_2.emojiDot = tf(arg0_2.emojiSnap):Find("dot")

	setText(arg0_2.emojiEvent:Find("null_tpl/Text"), i18n("recently_sticker_placeholder"))
	setActive(arg0_2.emojiItem, false)
	setActive(arg0_2.emojiDot, false)

	arg0_2.emojiIconEvent = arg0_2._tf:Find("frame/bg/mask/emojiicon_event")
	arg0_2.emojiIconSnap = arg0_2._tf:Find("frame/bg/mask/emojiicon_event"):GetComponent("HScrollSnap")

	arg0_2.emojiIconSnap:Init()

	arg0_2.emojiIconContent = tf(arg0_2.emojiIconSnap):Find("content")
	arg0_2.emojiIconItem = tf(arg0_2.emojiIconSnap):Find("item_emojiicon")

	setActive(arg0_2.emojiIconItem, false)

	arg0_2.parentTr = arg0_2._tf.parent
	arg0_2.resource = arg0_2._tf:Find("frame/resource")
	arg0_2.frame = arg0_2._tf:Find("frame")
	arg0_2.frame.position = arg0_2.contextData.pos or Vector3(0, 0, 0)
	arg0_2.frame.localPosition = Vector3(arg0_2.frame.localPosition.x, arg0_2.frame.localPosition.y, 0)
	arg0_2.newTag = arg0_2._tf:Find("newtag")
	arg0_2.emojiProxy = getProxy(EmojiProxy)
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	arg0_3:display()
	arg0_3:OverlayPanel(arg0_3._tf)
end

function var0_0.display(arg0_5)
	local var0_5 = UIItemList.New(arg0_5.emojiGroup, arg0_5.emojiType)

	var0_5:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = ChatConst.EmojiTypes[arg1_6 + 1]

			arg0_5:SetTagText(arg2_6, var0_6)

			if arg0_5.emojiProxy:fliteNewEmojiDataByType()[var0_6] then
				setActive(arg2_6:Find("point"), true)
			else
				setActive(arg2_6:Find("point"), false)
			end

			onToggle(arg0_5, arg2_6, function(arg0_7)
				if arg0_7 then
					setActive(arg0_5.emojiDots, var0_6 ~= ChatConst.EmojiIcon)
					setActive(arg0_5.emojiIconDots, var0_6 == ChatConst.EmojiIcon)
					setActive(arg0_5.emojiEvent, var0_6 ~= ChatConst.EmojiIcon)
					setActive(arg0_5.emojiIconEvent, var0_6 == ChatConst.EmojiIcon)

					if var0_6 ~= ChatConst.EmojiIcon then
						arg0_5:filter(var0_6)
					elseif var0_6 == ChatConst.EmojiIcon then
						arg0_5:emojiIconFliter()
					end

					var0_5:align(#ChatConst.EmojiTypes)
				end
			end, SFX_PANEL)
		end
	end)
	var0_5:align(#ChatConst.EmojiTypes)
	triggerToggle(arg0_5.emojiGroup:GetChild(0), true)
end

function var0_0.SetTagText(arg0_8, arg1_8, arg2_8)
	setText(arg1_8:Find("Text"), i18n("emoji_type_" .. arg2_8))
end

function var0_0.filter(arg0_9, arg1_9)
	local var0_9 = _.map(pg.emoji_template.all, function(arg0_10)
		if pg.emoji_template[arg0_10].achieve == 0 then
			return pg.emoji_template[arg0_10]
		end
	end)
	local var1_9 = arg0_9.emojiProxy:getNewEmojiIDLIst()
	local var2_9 = arg0_9.emojiProxy:fliteNewEmojiDataByType()
	local var3_9 = arg0_9.emojiProxy:getExEmojiDataByType(arg1_9)

	for iter0_9, iter1_9 in pairs(var3_9) do
		table.insert(var0_9, 1, iter1_9)
	end

	table.sort(var0_9, function(arg0_11, arg1_11)
		if arg0_11.index == arg1_11.index then
			return arg0_11.id < arg1_11.id
		end

		return arg0_11.index < arg1_11.index
	end)

	if arg1_9 == ChatConst.EmojiCommon then
		local var4_9 = getProxy(ChatProxy):getUsedEmoji()
		local var5_9 = {}

		for iter2_9, iter3_9 in pairs(var4_9) do
			table.insert(var5_9, {
				id = iter2_9,
				count = iter3_9
			})
		end

		table.sort(var5_9, function(arg0_12, arg1_12)
			if arg0_12.count == arg1_12.count then
				return arg0_12.id < arg1_12.id
			end

			return arg0_12.count > arg1_12.count
		end)

		var0_9 = _.map(var5_9, function(arg0_13)
			return pg.emoji_template[arg0_13.id]
		end)
	else
		var0_9 = _.filter(var0_9, function(arg0_14)
			return table.contains(arg0_14.type, arg1_9)
		end)
	end

	if var2_9[arg1_9] then
		for iter4_9, iter5_9 in pairs(var2_9[arg1_9]) do
			table.insert(var0_9, 1, iter5_9)
		end
	end

	arg0_9.tplCaches = arg0_9.tplCaches or {}

	local var6_9 = math.ceil(#var0_9 / var0_0.PageEmojiNums)

	setActive(arg0_9.emojiEvent:Find("null_tpl"), var6_9 == 0)

	for iter6_9 = arg0_9.emojiContent.childCount - 1, var6_9, -1 do
		Destroy(arg0_9.emojiDots:GetChild(iter6_9))

		local var7_9 = arg0_9.emojiSnap:RemoveChild(iter6_9)

		var7_9.transform.localScale = Vector3.one

		var7_9.transform:SetParent(arg0_9._tf, false)
		setActive(var7_9, false)
		arg0_9:clearItem(var7_9)
		table.insert(arg0_9.tplCaches, var7_9)
	end

	for iter7_9 = arg0_9.emojiContent.childCount + 1, var6_9 do
		local var8_9

		if #arg0_9.tplCaches > 0 then
			var8_9 = table.remove(arg0_9.tplCaches)
		else
			var8_9 = Instantiate(arg0_9.emojiItem)
		end

		setActive(var8_9, true)
		arg0_9.emojiSnap:AddChild(var8_9)
		cloneTplTo(arg0_9.emojiDot, arg0_9.emojiDots)
	end

	if var6_9 > 1 then
		arg0_9.emojiSnap:GoToScreen(0)
	end

	for iter8_9 = 0, arg0_9.emojiContent.childCount - 1 do
		local var9_9 = arg0_9.emojiContent:GetChild(iter8_9)

		arg0_9:clearItem(var9_9)

		local var10_9 = _.slice(var0_9, iter8_9 * var0_0.PageEmojiNums + 1, var0_0.PageEmojiNums)
		local var11_9 = GetComponent(var9_9, typeof(GridLayoutGroup))
		local var12_9 = UIItemList.New(var9_9, var9_9:Find("face"))

		var12_9:make(function(arg0_15, arg1_15, arg2_15)
			local var0_15 = var10_9[arg1_15 + 1]

			if arg0_15 == UIItemList.EventUpdate then
				PoolMgr.GetInstance():GetPrefab("emoji/" .. var0_15.pic, var0_15.pic, true, function(arg0_16)
					if not IsNil(arg2_15) then
						arg0_16.name = var0_15.pic

						local var0_16 = arg0_16:GetComponent(typeof(Image))

						if var0_16 then
							var0_16.preserveAspect = true
						end

						tf(arg0_16).sizeDelta = Vector2(var11_9.cellSize.x, var11_9.cellSize.y)
						tf(arg0_16).anchoredPosition = Vector2.zero

						local var1_16 = arg0_16:GetComponent("Animator")

						if var1_16 then
							var1_16.enabled = false
						end

						local var2_16 = arg0_16:GetComponent("CriManaEffectUI")

						if var2_16 then
							var2_16:Pause(true)
						end

						setParent(arg0_16, arg2_15, false)

						if table.contains(var1_9, var0_15.id) then
							cloneTplTo(arg0_9.newTag, arg2_15, "newtag")
							arg0_9.emojiProxy:removeNewEmojiID(var0_15.id)
						end
					else
						PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0_15.pic, var0_15.pic, arg0_16)
					end
				end)
				onButton(arg0_9, arg2_15, function()
					getProxy(ChatProxy):addUsedEmoji(var0_15.id)
					arg0_9.contextData.callback(var0_15.id)
					triggerButton(arg0_9._tf)
				end, SFX_PANEL)
			end
		end)
		var12_9:align(#var10_9)
	end
end

function var0_0.emojiIconFliter(arg0_18)
	local var0_18 = _.map(pg.emoji_small_template.all, function(arg0_19)
		return pg.emoji_small_template[arg0_19]
	end)
	local var1_18 = {}
	local var2_18 = getProxy(ChatProxy):getUsedEmojiIcon()

	for iter0_18, iter1_18 in ipairs(var2_18) do
		table.insert(var1_18, var0_18[iter1_18])
	end

	local var3_18 = math.min(9, #var0_18)
	local var4_18 = 1 + math.ceil((#var0_18 - var3_18) / var0_0.True_Emoji_Num_Of_Page)

	for iter2_18 = arg0_18.emojiIconContent.childCount + 1, var4_18 do
		cloneTplTo(arg0_18.emojiDot, arg0_18.emojiIconDots)
	end

	for iter3_18 = arg0_18.emojiIconContent.childCount + 1, var4_18 do
		local var5_18 = Instantiate(arg0_18.emojiIconItem)
		local var6_18 = tf(var5_18)
		local var7_18 = var6_18:Find("TitleCommom")
		local var8_18 = var6_18:Find("TitleAll")
		local var9_18 = var6_18:Find("CommomIconContainer")
		local var10_18 = var6_18:Find("AllIconContainer")
		local var11_18 = GetComponent(var10_18, "GridLayoutGroup")

		if iter3_18 == 1 then
			local var12_18 = var9_18:Find("Icon")
			local var13_18 = UIItemList.New(var9_18, var12_18)

			var13_18:make(function(arg0_20, arg1_20, arg2_20)
				local var0_20 = var1_18[arg1_20 + 1]

				if arg0_20 == UIItemList.EventUpdate then
					PoolMgr.GetInstance():GetPrefab("emoji/" .. var0_20.pic, var0_20.pic, true, function(arg0_21)
						if not IsNil(arg2_20) then
							arg0_21.name = var0_20.pic

							setParent(arg0_21, arg2_20, false)
							onButton(arg0_18, arg0_21, function()
								if arg0_18.contextData.emojiIconCallback then
									getProxy(ChatProxy):addUsedEmojiIcon(var0_20.id)
									arg0_18.contextData.emojiIconCallback(var0_20.id)
								end
							end, SFX_PANEL)
						end
					end)
				end
			end)
			var13_18:align(#var1_18)

			var11_18.padding.left = 20

			local var14_18 = var10_18:Find("Icon")
			local var15_18 = UIItemList.New(var10_18, var14_18)

			var15_18:make(function(arg0_23, arg1_23, arg2_23)
				local var0_23 = var0_18[arg1_23 + 1]

				if arg0_23 == UIItemList.EventUpdate then
					PoolMgr.GetInstance():GetPrefab("emoji/" .. var0_23.pic, var0_23.pic, true, function(arg0_24)
						if not IsNil(arg2_23) then
							arg0_24.name = var0_23.pic

							setParent(arg0_24, arg2_23, false)
							onButton(arg0_18, arg0_24, function()
								if arg0_18.contextData.emojiIconCallback then
									getProxy(ChatProxy):addUsedEmojiIcon(var0_23.id)
									arg0_18.contextData.emojiIconCallback(var0_23.id)
								end
							end, SFX_PANEL)
						end
					end)
				end
			end)
			var15_18:align(var3_18)
		else
			local var16_18 = var0_0.True_Emoji_Num_Of_Page - var0_0.Frequently_Used_Emoji_Num
			local var17_18 = _.slice(var0_18, (iter3_18 - 2) * var0_0.True_Emoji_Num_Of_Page + var3_18 + 1, var0_0.True_Emoji_Num_Of_Page)

			var11_18.padding.left = 60

			local var18_18 = var10_18:Find("Icon")
			local var19_18 = UIItemList.New(var10_18, var18_18)

			var19_18:make(function(arg0_26, arg1_26, arg2_26)
				local var0_26 = var17_18[arg1_26 + 1]

				if arg0_26 == UIItemList.EventUpdate then
					PoolMgr.GetInstance():GetPrefab("emoji/" .. var0_26.pic, var0_26.pic, true, function(arg0_27)
						if not IsNil(arg2_26) then
							arg0_27.name = var0_26.pic

							setParent(arg0_27, arg2_26, false)
							onButton(arg0_18, arg0_27, function()
								if arg0_18.contextData.emojiIconCallback then
									getProxy(ChatProxy):addUsedEmojiIcon(var0_26.id)
									arg0_18.contextData.emojiIconCallback(var0_26.id)
								end
							end, SFX_PANEL)
						end
					end)
				end
			end)
			var19_18:align(#var17_18)
		end

		setActive(var7_18, iter3_18 == 1)
		setActive(var8_18, iter3_18 == 1)
		setActive(var9_18, iter3_18 == 1)
		setActive(var5_18, true)
		arg0_18.emojiIconSnap:AddChild(var5_18)
	end
end

function var0_0.onBackPressed(arg0_29)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_29._tf)
end

function var0_0.clearItem(arg0_30, arg1_30)
	eachChild(arg1_30, function(arg0_31)
		if arg0_31.childCount > 0 then
			local var0_31 = arg0_31:Find("newtag")

			if var0_31 then
				Destroy(var0_31)
			end

			local var1_31 = arg0_31:GetChild(0).gameObject

			PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var1_31.name, var1_31.name, var1_31)
		end
	end)
end

function var0_0.willExit(arg0_32)
	eachChild(arg0_32.emojiContent, function(arg0_33)
		arg0_32:clearItem(arg0_33)
	end)
	_.each(arg0_32.tplCaches, function(arg0_34)
		arg0_32:clearItem(arg0_34)
	end)

	arg0_32.tplCaches = {}

	arg0_32:UnOverlayPanel(arg0_32._tf)
end

return var0_0

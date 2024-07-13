local var0_0 = class("EmojiLayer", import("..base.BaseUI"))

var0_0.PageEmojiNums = 8
var0_0.Frequently_Used_Emoji_Num = 6
var0_0.True_Emoji_Num_Of_Page = 15

function var0_0.getUIName(arg0_1)
	return "EmojiUI"
end

function var0_0.init(arg0_2)
	arg0_2.emojiGroup = arg0_2:findTF("frame/group")
	arg0_2.emojiType = arg0_2:findTF("type", arg0_2.emojiGroup)
	arg0_2.emojiEvent = arg0_2:findTF("frame/bg/mask/event")
	arg0_2.emojiSnap = arg0_2:findTF("frame/bg/mask/event"):GetComponent("HScrollSnap")

	arg0_2.emojiSnap:Init()

	arg0_2.emojiContent = arg0_2:findTF("content", arg0_2.emojiSnap)
	arg0_2.emojiItem = arg0_2:findTF("item", arg0_2.emojiSnap)
	arg0_2.emojiDots = arg0_2:findTF("frame/dots")
	arg0_2.emojiIconDots = arg0_2:findTF("frame/emojiDots")
	arg0_2.emojiDot = arg0_2:findTF("dot", arg0_2.emojiSnap)

	setText(arg0_2.emojiEvent:Find("null_tpl/Text"), i18n("recently_sticker_placeholder"))
	setActive(arg0_2.emojiItem, false)
	setActive(arg0_2.emojiDot, false)

	arg0_2.emojiIconEvent = arg0_2:findTF("frame/bg/mask/emojiicon_event")
	arg0_2.emojiIconSnap = arg0_2:findTF("frame/bg/mask/emojiicon_event"):GetComponent("HScrollSnap")

	arg0_2.emojiIconSnap:Init()

	arg0_2.emojiIconContent = arg0_2:findTF("content", arg0_2.emojiIconSnap)
	arg0_2.emojiIconItem = arg0_2:findTF("item_emojiicon", arg0_2.emojiIconSnap)

	setActive(arg0_2.emojiIconItem, false)

	arg0_2.parentTr = arg0_2._tf.parent
	arg0_2.resource = arg0_2:findTF("frame/resource")
	arg0_2.frame = arg0_2:findTF("frame")
	arg0_2.frame.position = arg0_2.contextData.pos or Vector3(0, 0, 0)
	arg0_2.frame.localPosition = Vector3(arg0_2.frame.localPosition.x, arg0_2.frame.localPosition.y, 0)
	arg0_2.newTag = arg0_2:findTF("newtag")
	arg0_2.emojiProxy = getProxy(EmojiProxy)
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	arg0_3:display()

	if getProxy(SettingsProxy):IsMellowStyle() then
		setParent(arg0_3._tf, pg.UIMgr.GetInstance().OverlayMain)
	else
		pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
			groupName = arg0_3:getGroupNameFromData(),
			weight = LayerWeightConst.SECOND_LAYER
		})
	end
end

function var0_0.display(arg0_5)
	local var0_5 = UIItemList.New(arg0_5.emojiGroup, arg0_5.emojiType)

	var0_5:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = ChatConst.EmojiTypes[arg1_6 + 1]

			setText(arg2_6:Find("Text"), i18n("emoji_type_" .. var0_6))

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

function var0_0.filter(arg0_8, arg1_8)
	local var0_8 = _.map(pg.emoji_template.all, function(arg0_9)
		if pg.emoji_template[arg0_9].achieve == 0 then
			return pg.emoji_template[arg0_9]
		end
	end)
	local var1_8 = arg0_8.emojiProxy:getNewEmojiIDLIst()
	local var2_8 = arg0_8.emojiProxy:fliteNewEmojiDataByType()
	local var3_8 = arg0_8.emojiProxy:getExEmojiDataByType(arg1_8)

	for iter0_8, iter1_8 in pairs(var3_8) do
		table.insert(var0_8, 1, iter1_8)
	end

	table.sort(var0_8, function(arg0_10, arg1_10)
		if arg0_10.index == arg1_10.index then
			return arg0_10.id < arg1_10.id
		end

		return arg0_10.index < arg1_10.index
	end)

	if arg1_8 == ChatConst.EmojiCommon then
		local var4_8 = getProxy(ChatProxy):getUsedEmoji()
		local var5_8 = {}

		for iter2_8, iter3_8 in pairs(var4_8) do
			table.insert(var5_8, {
				id = iter2_8,
				count = iter3_8
			})
		end

		table.sort(var5_8, function(arg0_11, arg1_11)
			if arg0_11.count == arg1_11.count then
				return arg0_11.id < arg1_11.id
			end

			return arg0_11.count > arg1_11.count
		end)

		var0_8 = _.map(var5_8, function(arg0_12)
			return pg.emoji_template[arg0_12.id]
		end)
	else
		var0_8 = _.filter(var0_8, function(arg0_13)
			return table.contains(arg0_13.type, arg1_8)
		end)
	end

	if var2_8[arg1_8] then
		for iter4_8, iter5_8 in pairs(var2_8[arg1_8]) do
			table.insert(var0_8, 1, iter5_8)
		end
	end

	arg0_8.tplCaches = arg0_8.tplCaches or {}

	local var6_8 = math.ceil(#var0_8 / var0_0.PageEmojiNums)

	setActive(arg0_8.emojiEvent:Find("null_tpl"), var6_8 == 0)

	for iter6_8 = arg0_8.emojiContent.childCount - 1, var6_8, -1 do
		Destroy(arg0_8.emojiDots:GetChild(iter6_8))

		local var7_8 = arg0_8.emojiSnap:RemoveChild(iter6_8)

		var7_8.transform.localScale = Vector3.one

		var7_8.transform:SetParent(arg0_8._tf, false)
		setActive(var7_8, false)
		arg0_8:clearItem(var7_8)
		table.insert(arg0_8.tplCaches, var7_8)
	end

	for iter7_8 = arg0_8.emojiContent.childCount + 1, var6_8 do
		local var8_8

		if #arg0_8.tplCaches > 0 then
			var8_8 = table.remove(arg0_8.tplCaches)
		else
			var8_8 = Instantiate(arg0_8.emojiItem)
		end

		setActive(var8_8, true)
		arg0_8.emojiSnap:AddChild(var8_8)
		cloneTplTo(arg0_8.emojiDot, arg0_8.emojiDots)
	end

	for iter8_8 = 0, arg0_8.emojiContent.childCount - 1 do
		local var9_8 = arg0_8.emojiContent:GetChild(iter8_8)

		arg0_8:clearItem(var9_8)

		local var10_8 = _.slice(var0_8, iter8_8 * var0_0.PageEmojiNums + 1, var0_0.PageEmojiNums)
		local var11_8 = GetComponent(var9_8, typeof(GridLayoutGroup))
		local var12_8 = UIItemList.New(var9_8, var9_8:Find("face"))

		var12_8:make(function(arg0_14, arg1_14, arg2_14)
			local var0_14 = var10_8[arg1_14 + 1]

			if arg0_14 == UIItemList.EventUpdate then
				PoolMgr.GetInstance():GetPrefab("emoji/" .. var0_14.pic, var0_14.pic, true, function(arg0_15)
					if not IsNil(arg2_14) then
						arg0_15.name = var0_14.pic
						tf(arg0_15).sizeDelta = Vector2(var11_8.cellSize.x, var11_8.cellSize.y)
						tf(arg0_15).anchoredPosition = Vector2.zero

						local var0_15 = arg0_15:GetComponent("Animator")

						if var0_15 then
							var0_15.enabled = false
						end

						local var1_15 = arg0_15:GetComponent("CriManaEffectUI")

						if var1_15 then
							var1_15:Pause(true)
						end

						setParent(arg0_15, arg2_14, false)

						if table.contains(var1_8, var0_14.id) then
							cloneTplTo(arg0_8.newTag, arg2_14, "newtag")
							arg0_8.emojiProxy:removeNewEmojiID(var0_14.id)
						end
					else
						PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0_14.pic, var0_14.pic, arg0_15)
					end
				end)
				onButton(arg0_8, arg2_14, function()
					getProxy(ChatProxy):addUsedEmoji(var0_14.id)
					arg0_8.contextData.callback(var0_14.id)
					triggerButton(arg0_8._tf)
				end, SFX_PANEL)
			end
		end)
		var12_8:align(#var10_8)
	end
end

function var0_0.emojiIconFliter(arg0_17)
	local var0_17 = pg.emoji_small_template
	local var1_17 = {}
	local var2_17 = getProxy(ChatProxy):getUsedEmojiIcon()

	for iter0_17, iter1_17 in ipairs(var2_17) do
		table.insert(var1_17, var0_17[iter1_17])
	end

	local var3_17 = math.ceil((#var0_17 + #var1_17) / var0_0.True_Emoji_Num_Of_Page)

	for iter2_17 = arg0_17.emojiIconContent.childCount + 1, var3_17 do
		cloneTplTo(arg0_17.emojiDot, arg0_17.emojiIconDots)
	end

	for iter3_17 = arg0_17.emojiIconContent.childCount + 1, var3_17 do
		local var4_17 = Instantiate(arg0_17.emojiIconItem)
		local var5_17 = arg0_17:findTF("TitleCommom", var4_17)
		local var6_17 = arg0_17:findTF("TitleAll", var4_17)
		local var7_17 = arg0_17:findTF("CommomIconContainer", var4_17)
		local var8_17 = arg0_17:findTF("AllIconContainer", var4_17)
		local var9_17 = GetComponent(var8_17, "GridLayoutGroup")

		if iter3_17 == 1 then
			local var10_17 = arg0_17:findTF("Icon", var7_17)
			local var11_17 = UIItemList.New(var7_17, var10_17)

			var11_17:make(function(arg0_18, arg1_18, arg2_18)
				local var0_18 = var1_17[arg1_18 + 1]

				if arg0_18 == UIItemList.EventUpdate then
					PoolMgr.GetInstance():GetPrefab("emoji/" .. var0_18.pic, var0_18.pic, true, function(arg0_19)
						if not IsNil(arg2_18) then
							arg0_19.name = var0_18.pic

							setParent(arg0_19, arg2_18, false)
							onButton(arg0_17, arg0_19, function()
								if arg0_17.contextData.emojiIconCallback then
									getProxy(ChatProxy):addUsedEmojiIcon(var0_18.id)
									arg0_17.contextData.emojiIconCallback(var0_18.id)
								end
							end, SFX_PANEL)
						end
					end)
				end
			end)
			var11_17:align(#var1_17)

			var9_17.padding.left = 20

			local var12_17 = arg0_17:findTF("Icon", var8_17)
			local var13_17 = UIItemList.New(var8_17, var12_17)

			var13_17:make(function(arg0_21, arg1_21, arg2_21)
				local var0_21 = var0_17[arg1_21 + 1]

				if arg0_21 == UIItemList.EventUpdate then
					PoolMgr.GetInstance():GetPrefab("emoji/" .. var0_21.pic, var0_21.pic, true, function(arg0_22)
						if not IsNil(arg2_21) then
							arg0_22.name = var0_21.pic

							setParent(arg0_22, arg2_21, false)
							onButton(arg0_17, arg0_22, function()
								if arg0_17.contextData.emojiIconCallback then
									getProxy(ChatProxy):addUsedEmojiIcon(var0_21.id)
									arg0_17.contextData.emojiIconCallback(var0_21.id)
								end
							end, SFX_PANEL)
						end
					end)
				end
			end)
			var13_17:align(var0_0.True_Emoji_Num_Of_Page - var0_0.Frequently_Used_Emoji_Num)
		else
			local var14_17 = var0_0.True_Emoji_Num_Of_Page - var0_0.Frequently_Used_Emoji_Num
			local var15_17 = _.slice(var0_17, (iter3_17 - 2) * var0_0.True_Emoji_Num_Of_Page + 9 + 1, var0_0.True_Emoji_Num_Of_Page)

			var9_17.padding.left = 60

			local var16_17 = arg0_17:findTF("Icon", var8_17)
			local var17_17 = UIItemList.New(var8_17, var16_17)

			var17_17:make(function(arg0_24, arg1_24, arg2_24)
				local var0_24 = var15_17[arg1_24 + 1]

				if arg0_24 == UIItemList.EventUpdate then
					PoolMgr.GetInstance():GetPrefab("emoji/" .. var0_24.pic, var0_24.pic, true, function(arg0_25)
						if not IsNil(arg2_24) then
							arg0_25.name = var0_24.pic

							setParent(arg0_25, arg2_24, false)
							onButton(arg0_17, arg0_25, function()
								if arg0_17.contextData.emojiIconCallback then
									getProxy(ChatProxy):addUsedEmojiIcon(var0_24.id)
									arg0_17.contextData.emojiIconCallback(var0_24.id)
								end
							end, SFX_PANEL)
						end
					end)
				end
			end)
			var17_17:align(#var15_17)
		end

		setActive(var5_17, iter3_17 == 1)
		setActive(var6_17, iter3_17 == 1)
		setActive(var7_17, iter3_17 == 1)
		setActive(var4_17, true)
		arg0_17.emojiIconSnap:AddChild(var4_17)
	end
end

function var0_0.onBackPressed(arg0_27)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_27._tf)
end

function var0_0.clearItem(arg0_28, arg1_28)
	eachChild(arg1_28, function(arg0_29)
		if arg0_29.childCount > 0 then
			local var0_29 = arg0_29:Find("newtag")

			if var0_29 then
				Destroy(var0_29)
			end

			local var1_29 = arg0_29:GetChild(0).gameObject

			PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var1_29.name, var1_29.name, var1_29)
		end
	end)
end

function var0_0.willExit(arg0_30)
	eachChild(arg0_30.emojiContent, function(arg0_31)
		arg0_30:clearItem(arg0_31)
	end)
	_.each(arg0_30.tplCaches, function(arg0_32)
		arg0_30:clearItem(arg0_32)
	end)

	if getProxy(SettingsProxy):IsMellowStyle() then
		setParent(arg0_30._tf, arg0_30.parentTr)
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0_30._tf)
	end
end

return var0_0

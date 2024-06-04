local var0 = class("EmojiLayer", import("..base.BaseUI"))

var0.PageEmojiNums = 8
var0.Frequently_Used_Emoji_Num = 6
var0.True_Emoji_Num_Of_Page = 15

function var0.getUIName(arg0)
	return "EmojiUI"
end

function var0.init(arg0)
	arg0.emojiGroup = arg0:findTF("frame/group")
	arg0.emojiType = arg0:findTF("type", arg0.emojiGroup)
	arg0.emojiEvent = arg0:findTF("frame/bg/mask/event")
	arg0.emojiSnap = arg0:findTF("frame/bg/mask/event"):GetComponent("HScrollSnap")

	arg0.emojiSnap:Init()

	arg0.emojiContent = arg0:findTF("content", arg0.emojiSnap)
	arg0.emojiItem = arg0:findTF("item", arg0.emojiSnap)
	arg0.emojiDots = arg0:findTF("frame/dots")
	arg0.emojiIconDots = arg0:findTF("frame/emojiDots")
	arg0.emojiDot = arg0:findTF("dot", arg0.emojiSnap)

	setText(arg0.emojiEvent:Find("null_tpl/Text"), i18n("recently_sticker_placeholder"))
	setActive(arg0.emojiItem, false)
	setActive(arg0.emojiDot, false)

	arg0.emojiIconEvent = arg0:findTF("frame/bg/mask/emojiicon_event")
	arg0.emojiIconSnap = arg0:findTF("frame/bg/mask/emojiicon_event"):GetComponent("HScrollSnap")

	arg0.emojiIconSnap:Init()

	arg0.emojiIconContent = arg0:findTF("content", arg0.emojiIconSnap)
	arg0.emojiIconItem = arg0:findTF("item_emojiicon", arg0.emojiIconSnap)

	setActive(arg0.emojiIconItem, false)

	arg0.parentTr = arg0._tf.parent
	arg0.resource = arg0:findTF("frame/resource")
	arg0.frame = arg0:findTF("frame")
	arg0.frame.position = arg0.contextData.pos or Vector3(0, 0, 0)
	arg0.frame.localPosition = Vector3(arg0.frame.localPosition.x, arg0.frame.localPosition.y, 0)
	arg0.newTag = arg0:findTF("newtag")
	arg0.emojiProxy = getProxy(EmojiProxy)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	arg0:display()

	if getProxy(SettingsProxy):IsMellowStyle() then
		setParent(arg0._tf, pg.UIMgr.GetInstance().OverlayMain)
	else
		pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
			groupName = arg0:getGroupNameFromData(),
			weight = LayerWeightConst.SECOND_LAYER
		})
	end
end

function var0.display(arg0)
	local var0 = UIItemList.New(arg0.emojiGroup, arg0.emojiType)

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = ChatConst.EmojiTypes[arg1 + 1]

			setText(arg2:Find("Text"), i18n("emoji_type_" .. var0))

			if arg0.emojiProxy:fliteNewEmojiDataByType()[var0] then
				setActive(arg2:Find("point"), true)
			else
				setActive(arg2:Find("point"), false)
			end

			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					setActive(arg0.emojiDots, var0 ~= ChatConst.EmojiIcon)
					setActive(arg0.emojiIconDots, var0 == ChatConst.EmojiIcon)
					setActive(arg0.emojiEvent, var0 ~= ChatConst.EmojiIcon)
					setActive(arg0.emojiIconEvent, var0 == ChatConst.EmojiIcon)

					if var0 ~= ChatConst.EmojiIcon then
						arg0:filter(var0)
					elseif var0 == ChatConst.EmojiIcon then
						arg0:emojiIconFliter()
					end

					var0:align(#ChatConst.EmojiTypes)
				end
			end, SFX_PANEL)
		end
	end)
	var0:align(#ChatConst.EmojiTypes)
	triggerToggle(arg0.emojiGroup:GetChild(0), true)
end

function var0.filter(arg0, arg1)
	local var0 = _.map(pg.emoji_template.all, function(arg0)
		if pg.emoji_template[arg0].achieve == 0 then
			return pg.emoji_template[arg0]
		end
	end)
	local var1 = arg0.emojiProxy:getNewEmojiIDLIst()
	local var2 = arg0.emojiProxy:fliteNewEmojiDataByType()
	local var3 = arg0.emojiProxy:getExEmojiDataByType(arg1)

	for iter0, iter1 in pairs(var3) do
		table.insert(var0, 1, iter1)
	end

	table.sort(var0, function(arg0, arg1)
		if arg0.index == arg1.index then
			return arg0.id < arg1.id
		end

		return arg0.index < arg1.index
	end)

	if arg1 == ChatConst.EmojiCommon then
		local var4 = getProxy(ChatProxy):getUsedEmoji()
		local var5 = {}

		for iter2, iter3 in pairs(var4) do
			table.insert(var5, {
				id = iter2,
				count = iter3
			})
		end

		table.sort(var5, function(arg0, arg1)
			if arg0.count == arg1.count then
				return arg0.id < arg1.id
			end

			return arg0.count > arg1.count
		end)

		var0 = _.map(var5, function(arg0)
			return pg.emoji_template[arg0.id]
		end)
	else
		var0 = _.filter(var0, function(arg0)
			return table.contains(arg0.type, arg1)
		end)
	end

	if var2[arg1] then
		for iter4, iter5 in pairs(var2[arg1]) do
			table.insert(var0, 1, iter5)
		end
	end

	arg0.tplCaches = arg0.tplCaches or {}

	local var6 = math.ceil(#var0 / var0.PageEmojiNums)

	setActive(arg0.emojiEvent:Find("null_tpl"), var6 == 0)

	for iter6 = arg0.emojiContent.childCount - 1, var6, -1 do
		Destroy(arg0.emojiDots:GetChild(iter6))

		local var7 = arg0.emojiSnap:RemoveChild(iter6)

		var7.transform.localScale = Vector3.one

		var7.transform:SetParent(arg0._tf, false)
		setActive(var7, false)
		arg0:clearItem(var7)
		table.insert(arg0.tplCaches, var7)
	end

	for iter7 = arg0.emojiContent.childCount + 1, var6 do
		local var8

		if #arg0.tplCaches > 0 then
			var8 = table.remove(arg0.tplCaches)
		else
			var8 = Instantiate(arg0.emojiItem)
		end

		setActive(var8, true)
		arg0.emojiSnap:AddChild(var8)
		cloneTplTo(arg0.emojiDot, arg0.emojiDots)
	end

	for iter8 = 0, arg0.emojiContent.childCount - 1 do
		local var9 = arg0.emojiContent:GetChild(iter8)

		arg0:clearItem(var9)

		local var10 = _.slice(var0, iter8 * var0.PageEmojiNums + 1, var0.PageEmojiNums)
		local var11 = GetComponent(var9, typeof(GridLayoutGroup))
		local var12 = UIItemList.New(var9, var9:Find("face"))

		var12:make(function(arg0, arg1, arg2)
			local var0 = var10[arg1 + 1]

			if arg0 == UIItemList.EventUpdate then
				PoolMgr.GetInstance():GetPrefab("emoji/" .. var0.pic, var0.pic, true, function(arg0)
					if not IsNil(arg2) then
						arg0.name = var0.pic
						tf(arg0).sizeDelta = Vector2(var11.cellSize.x, var11.cellSize.y)
						tf(arg0).anchoredPosition = Vector2.zero

						local var0 = arg0:GetComponent("Animator")

						if var0 then
							var0.enabled = false
						end

						local var1 = arg0:GetComponent("CriManaEffectUI")

						if var1 then
							var1:Pause(true)
						end

						setParent(arg0, arg2, false)

						if table.contains(var1, var0.id) then
							cloneTplTo(arg0.newTag, arg2, "newtag")
							arg0.emojiProxy:removeNewEmojiID(var0.id)
						end
					else
						PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0.pic, var0.pic, arg0)
					end
				end)
				onButton(arg0, arg2, function()
					getProxy(ChatProxy):addUsedEmoji(var0.id)
					arg0.contextData.callback(var0.id)
					triggerButton(arg0._tf)
				end, SFX_PANEL)
			end
		end)
		var12:align(#var10)
	end
end

function var0.emojiIconFliter(arg0)
	local var0 = pg.emoji_small_template
	local var1 = {}
	local var2 = getProxy(ChatProxy):getUsedEmojiIcon()

	for iter0, iter1 in ipairs(var2) do
		table.insert(var1, var0[iter1])
	end

	local var3 = math.ceil((#var0 + #var1) / var0.True_Emoji_Num_Of_Page)

	for iter2 = arg0.emojiIconContent.childCount + 1, var3 do
		cloneTplTo(arg0.emojiDot, arg0.emojiIconDots)
	end

	for iter3 = arg0.emojiIconContent.childCount + 1, var3 do
		local var4 = Instantiate(arg0.emojiIconItem)
		local var5 = arg0:findTF("TitleCommom", var4)
		local var6 = arg0:findTF("TitleAll", var4)
		local var7 = arg0:findTF("CommomIconContainer", var4)
		local var8 = arg0:findTF("AllIconContainer", var4)
		local var9 = GetComponent(var8, "GridLayoutGroup")

		if iter3 == 1 then
			local var10 = arg0:findTF("Icon", var7)
			local var11 = UIItemList.New(var7, var10)

			var11:make(function(arg0, arg1, arg2)
				local var0 = var1[arg1 + 1]

				if arg0 == UIItemList.EventUpdate then
					PoolMgr.GetInstance():GetPrefab("emoji/" .. var0.pic, var0.pic, true, function(arg0)
						if not IsNil(arg2) then
							arg0.name = var0.pic

							setParent(arg0, arg2, false)
							onButton(arg0, arg0, function()
								if arg0.contextData.emojiIconCallback then
									getProxy(ChatProxy):addUsedEmojiIcon(var0.id)
									arg0.contextData.emojiIconCallback(var0.id)
								end
							end, SFX_PANEL)
						end
					end)
				end
			end)
			var11:align(#var1)

			var9.padding.left = 20

			local var12 = arg0:findTF("Icon", var8)
			local var13 = UIItemList.New(var8, var12)

			var13:make(function(arg0, arg1, arg2)
				local var0 = var0[arg1 + 1]

				if arg0 == UIItemList.EventUpdate then
					PoolMgr.GetInstance():GetPrefab("emoji/" .. var0.pic, var0.pic, true, function(arg0)
						if not IsNil(arg2) then
							arg0.name = var0.pic

							setParent(arg0, arg2, false)
							onButton(arg0, arg0, function()
								if arg0.contextData.emojiIconCallback then
									getProxy(ChatProxy):addUsedEmojiIcon(var0.id)
									arg0.contextData.emojiIconCallback(var0.id)
								end
							end, SFX_PANEL)
						end
					end)
				end
			end)
			var13:align(var0.True_Emoji_Num_Of_Page - var0.Frequently_Used_Emoji_Num)
		else
			local var14 = var0.True_Emoji_Num_Of_Page - var0.Frequently_Used_Emoji_Num
			local var15 = _.slice(var0, (iter3 - 2) * var0.True_Emoji_Num_Of_Page + 9 + 1, var0.True_Emoji_Num_Of_Page)

			var9.padding.left = 60

			local var16 = arg0:findTF("Icon", var8)
			local var17 = UIItemList.New(var8, var16)

			var17:make(function(arg0, arg1, arg2)
				local var0 = var15[arg1 + 1]

				if arg0 == UIItemList.EventUpdate then
					PoolMgr.GetInstance():GetPrefab("emoji/" .. var0.pic, var0.pic, true, function(arg0)
						if not IsNil(arg2) then
							arg0.name = var0.pic

							setParent(arg0, arg2, false)
							onButton(arg0, arg0, function()
								if arg0.contextData.emojiIconCallback then
									getProxy(ChatProxy):addUsedEmojiIcon(var0.id)
									arg0.contextData.emojiIconCallback(var0.id)
								end
							end, SFX_PANEL)
						end
					end)
				end
			end)
			var17:align(#var15)
		end

		setActive(var5, iter3 == 1)
		setActive(var6, iter3 == 1)
		setActive(var7, iter3 == 1)
		setActive(var4, true)
		arg0.emojiIconSnap:AddChild(var4)
	end
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0._tf)
end

function var0.clearItem(arg0, arg1)
	eachChild(arg1, function(arg0)
		if arg0.childCount > 0 then
			local var0 = arg0:Find("newtag")

			if var0 then
				Destroy(var0)
			end

			local var1 = arg0:GetChild(0).gameObject

			PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var1.name, var1.name, var1)
		end
	end)
end

function var0.willExit(arg0)
	eachChild(arg0.emojiContent, function(arg0)
		arg0:clearItem(arg0)
	end)
	_.each(arg0.tplCaches, function(arg0)
		arg0:clearItem(arg0)
	end)

	if getProxy(SettingsProxy):IsMellowStyle() then
		setParent(arg0._tf, arg0.parentTr)
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	end
end

return var0

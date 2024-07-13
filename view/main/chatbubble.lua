local var0_0 = class("ChatBubble")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.tf = tf(arg1_1)
	arg0_1.isLoadChatBg = false

	arg0_1:init()

	arg0_1.chatFrameTr = findTF(arg0_1.tf, "chat_fram")

	if IsNil(arg0_1.chatFrameTr) then
		arg0_1.chatFrameTr = arg0_1.tf
	end
end

function var0_0.init(arg0_2)
	arg0_2.nameTF = findTF(arg0_2.tf, "desc/name"):GetComponent("Text")
	arg0_2.face = findTF(arg0_2.tf, "face/content")
	arg0_2.circle = findTF(arg0_2.tf, "shipicon/frame")
	arg0_2.timeTF = findTF(arg0_2.tf, "time"):GetComponent("Text")
	arg0_2.headTF = findTF(arg0_2.tf, "shipicon/icon"):GetComponent("Image")
	arg0_2.stars = findTF(arg0_2.tf, "shipicon/stars")
	arg0_2.star = findTF(arg0_2.stars, "star")
	arg0_2.dutyTF = findTF(arg0_2.tf, "desc/duty")
	arg0_2.channel = findTF(arg0_2.tf, "desc/channel")
	arg0_2.chatBgWidth = 665
end

function var0_0.update(arg0_3, arg1_3)
	if arg0_3.data == arg1_3 then
		return
	end

	arg0_3.data = arg1_3

	local var0_3 = arg1_3.isSelf
	local var1_3 = arg1_3.player

	if var1_3.icon == 0 then
		var1_3.icon = 101171
	end

	local var2_3 = pg.ship_data_statistics[var1_3.icon]
	local var3_3 = false

	if not var0_3 then
		var3_3 = var1_3.propose
	else
		local var4_3 = var1_3.character

		if var4_3 then
			local var5_3 = getProxy(BayProxy):getShipById(var4_3)

			if var5_3 then
				var3_3 = var5_3:ShowPropose()
			end
		end
	end

	arg0_3.nameTF.text = var1_3.name

	local var6_3 = arg1_3.timestamp
	local var7_3 = getOfflineTimeStamp(var6_3)

	arg0_3.timeTF.text = var7_3

	if arg0_3.dutyTF then
		setActive(arg0_3.dutyTF, var1_3.duty)

		if var1_3.duty then
			local var8_3 = GetSpriteFromAtlas("dutyicon", var1_3.duty)

			setImageSprite(arg0_3.dutyTF, var8_3, true)
		end
	end

	local var9_3 = Ship.New({
		configId = var2_3.id
	})
	local var10_3 = arg0_3.stars.childCount
	local var11_3 = var9_3:getStar()

	for iter0_3 = var10_3, var11_3 - 1 do
		cloneTplTo(arg0_3.star, arg0_3.stars)
	end

	local var12_3 = arg0_3.stars.childCount

	for iter1_3 = 0, var12_3 - 1 do
		arg0_3.stars:GetChild(iter1_3).gameObject:SetActive(iter1_3 < var2_3.star)
	end

	if arg0_3.channel then
		local var13_3 = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(arg1_3.type) .. "_1920")

		setImageSprite(arg0_3.channel, var13_3, true)
	end

	arg0_3.headTF.color = Color.New(1, 1, 1, 0)

	LoadSpriteAsync("qicon/" .. var1_3:getPainting(), function(arg0_4)
		if not IsNil(arg0_3.headTF) then
			arg0_3.headTF.color = Color.white
			arg0_3.headTF.sprite = arg0_4 or LoadSprite("heroicon/unknown")
		end
	end)

	local var14_3 = AttireFrame.attireFrameRes(var1_3, var0_3, AttireConst.TYPE_ICON_FRAME, var3_3)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var14_3, var14_3, true, function(arg0_5)
		if IsNil(arg0_3.tf) then
			return
		end

		if arg0_3.circle and arg0_3.data then
			arg0_5.name = var14_3
			findTF(arg0_5.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0_5, arg0_3.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var14_3, var14_3, arg0_5)
		end
	end)

	if arg1_3.emojiId then
		local var15_3 = pg.emoji_template[arg1_3.emojiId]

		PoolMgr.GetInstance():GetPrefab("emoji/" .. var15_3.pic, var15_3.pic, true, function(arg0_6)
			if IsNil(arg0_3.tf) then
				return
			end

			if arg0_3.face and arg0_3.data then
				arg0_6.name = var15_3.pic

				local var0_6 = arg0_6:GetComponent("Animator")

				if var0_6 then
					var0_6.enabled = true
				end

				setParent(arg0_6, arg0_3.face, false)

				rtf(arg0_6).sizeDelta = Vector2.New(180, 180)
				rtf(arg0_6).localPosition = var0_3 and Vector3(-50, 0, 0) or Vector3(50, 0, 0)
			else
				PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var15_3.pic, var15_3.pic, arg0_6)
			end
		end)
	else
		local var16_3 = AttireFrame.attireFrameRes(var1_3, var0_3, AttireConst.TYPE_CHAT_FRAME, var3_3)

		PoolMgr.GetInstance():GetPrefab("ChatFrame/" .. var16_3, var16_3, true, function(arg0_7)
			if IsNil(arg0_3.tf) then
				return
			end

			if arg0_3.tf and arg0_3.data then
				local var0_7 = tf(arg0_7):Find("Text"):GetComponent("RichText")

				var0_7.supportRichText = false

				eachChild(tf(arg0_7):Find("Text"), function(arg0_8)
					Destroy(arg0_8)
				end)

				local var1_7 = string.gmatch(arg1_3.content, ChatConst.EmojiIconCodeMatch)
				local var2_7 = false

				for iter0_7 in var1_7 do
					if table.contains(pg.emoji_small_template.all, tonumber(iter0_7)) then
						var2_7 = true

						local var3_7 = pg.emoji_small_template[tonumber(iter0_7)]
						local var4_7 = LoadSprite("emoji/" .. var3_7.pic .. "_small", nil)

						var0_7:AddSprite(iter0_7, var4_7)
					end
				end

				local var5_7 = GetComponent(arg0_7, "VerticalLayoutGroup")

				if var2_7 then
					onNextTick(function()
						var5_7.padding.bottom = 30

						Canvas.ForceUpdateCanvases()
					end)
				else
					var5_7.padding.bottom = var5_7.padding.top
				end

				local var6_7 = arg1_3.content

				if arg1_3.needBanRichText then
					var6_7 = SwitchSpecialChar(arg1_3.content)
				end

				var0_7.text = string.gsub(var6_7, ChatConst.EmojiIconCodeMatch, function(arg0_10)
					if table.contains(pg.emoji_small_template.all, tonumber(arg0_10)) then
						return string.format("<icon name=%s w=1 h=1/>", arg0_10)
					end
				end)
				arg0_3.isLoadChatBg = true
				arg0_7:GetComponent(typeof(LayoutElement)).preferredWidth = arg0_3.chatBgWidth
				arg0_7.name = var16_3

				setParent(arg0_7, arg0_3.chatFrameTr, false)
				tf(arg0_7):SetAsFirstSibling()
				Canvas.ForceUpdateCanvases()
				arg0_3:OnChatFrameLoaded(arg0_7)
			else
				PoolMgr.GetInstance():ReturnPrefab("ChatFrame/" .. var16_3, var16_3, arg0_7)
			end
		end)
	end

	setActive(arg0_3.face.parent, arg1_3.emojiId)
end

function var0_0.dispose(arg0_11)
	if arg0_11.face.childCount > 0 then
		local var0_11 = arg0_11.face:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0_11.name, var0_11.name, var0_11)
	end

	if arg0_11.circle.childCount > 0 then
		local var1_11 = arg0_11.circle:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var1_11.name, var1_11.name, var1_11)
	end

	if arg0_11.isLoadChatBg then
		local var2_11 = arg0_11.chatFrameTr:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("ChatFrame/" .. var2_11.name, var2_11.name, var2_11)

		arg0_11.isLoadChatBg = false
	end

	arg0_11.data = nil
end

function var0_0.OnChatFrameLoaded(arg0_12, arg1_12)
	return
end

return var0_0

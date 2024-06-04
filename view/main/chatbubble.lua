local var0 = class("ChatBubble")

function var0.Ctor(arg0, arg1)
	arg0.tf = tf(arg1)
	arg0.isLoadChatBg = false

	arg0:init()

	arg0.chatFrameTr = findTF(arg0.tf, "chat_fram")

	if IsNil(arg0.chatFrameTr) then
		arg0.chatFrameTr = arg0.tf
	end
end

function var0.init(arg0)
	arg0.nameTF = findTF(arg0.tf, "desc/name"):GetComponent("Text")
	arg0.face = findTF(arg0.tf, "face/content")
	arg0.circle = findTF(arg0.tf, "shipicon/frame")
	arg0.timeTF = findTF(arg0.tf, "time"):GetComponent("Text")
	arg0.headTF = findTF(arg0.tf, "shipicon/icon"):GetComponent("Image")
	arg0.stars = findTF(arg0.tf, "shipicon/stars")
	arg0.star = findTF(arg0.stars, "star")
	arg0.dutyTF = findTF(arg0.tf, "desc/duty")
	arg0.channel = findTF(arg0.tf, "desc/channel")
	arg0.chatBgWidth = 665
end

function var0.update(arg0, arg1)
	if arg0.data == arg1 then
		return
	end

	arg0.data = arg1

	local var0 = arg1.isSelf
	local var1 = arg1.player

	if var1.icon == 0 then
		var1.icon = 101171
	end

	local var2 = pg.ship_data_statistics[var1.icon]
	local var3 = false

	if not var0 then
		var3 = var1.propose
	else
		local var4 = var1.character

		if var4 then
			local var5 = getProxy(BayProxy):getShipById(var4)

			if var5 then
				var3 = var5:ShowPropose()
			end
		end
	end

	arg0.nameTF.text = var1.name

	local var6 = arg1.timestamp
	local var7 = getOfflineTimeStamp(var6)

	arg0.timeTF.text = var7

	if arg0.dutyTF then
		setActive(arg0.dutyTF, var1.duty)

		if var1.duty then
			local var8 = GetSpriteFromAtlas("dutyicon", var1.duty)

			setImageSprite(arg0.dutyTF, var8, true)
		end
	end

	local var9 = Ship.New({
		configId = var2.id
	})
	local var10 = arg0.stars.childCount
	local var11 = var9:getStar()

	for iter0 = var10, var11 - 1 do
		cloneTplTo(arg0.star, arg0.stars)
	end

	local var12 = arg0.stars.childCount

	for iter1 = 0, var12 - 1 do
		arg0.stars:GetChild(iter1).gameObject:SetActive(iter1 < var2.star)
	end

	if arg0.channel then
		local var13 = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(arg1.type) .. "_1920")

		setImageSprite(arg0.channel, var13, true)
	end

	arg0.headTF.color = Color.New(1, 1, 1, 0)

	LoadSpriteAsync("qicon/" .. var1:getPainting(), function(arg0)
		if not IsNil(arg0.headTF) then
			arg0.headTF.color = Color.white
			arg0.headTF.sprite = arg0 or LoadSprite("heroicon/unknown")
		end
	end)

	local var14 = AttireFrame.attireFrameRes(var1, var0, AttireConst.TYPE_ICON_FRAME, var3)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var14, var14, true, function(arg0)
		if IsNil(arg0.tf) then
			return
		end

		if arg0.circle and arg0.data then
			arg0.name = var14
			findTF(arg0.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0, arg0.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var14, var14, arg0)
		end
	end)

	if arg1.emojiId then
		local var15 = pg.emoji_template[arg1.emojiId]

		PoolMgr.GetInstance():GetPrefab("emoji/" .. var15.pic, var15.pic, true, function(arg0)
			if IsNil(arg0.tf) then
				return
			end

			if arg0.face and arg0.data then
				arg0.name = var15.pic

				local var0 = arg0:GetComponent("Animator")

				if var0 then
					var0.enabled = true
				end

				setParent(arg0, arg0.face, false)

				rtf(arg0).sizeDelta = Vector2.New(180, 180)
				rtf(arg0).localPosition = var0 and Vector3(-50, 0, 0) or Vector3(50, 0, 0)
			else
				PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var15.pic, var15.pic, arg0)
			end
		end)
	else
		local var16 = AttireFrame.attireFrameRes(var1, var0, AttireConst.TYPE_CHAT_FRAME, var3)

		PoolMgr.GetInstance():GetPrefab("ChatFrame/" .. var16, var16, true, function(arg0)
			if IsNil(arg0.tf) then
				return
			end

			if arg0.tf and arg0.data then
				local var0 = tf(arg0):Find("Text"):GetComponent("RichText")

				var0.supportRichText = false

				eachChild(tf(arg0):Find("Text"), function(arg0)
					Destroy(arg0)
				end)

				local var1 = string.gmatch(arg1.content, ChatConst.EmojiIconCodeMatch)
				local var2 = false

				for iter0 in var1 do
					if table.contains(pg.emoji_small_template.all, tonumber(iter0)) then
						var2 = true

						local var3 = pg.emoji_small_template[tonumber(iter0)]
						local var4 = LoadSprite("emoji/" .. var3.pic .. "_small", nil)

						var0:AddSprite(iter0, var4)
					end
				end

				local var5 = GetComponent(arg0, "VerticalLayoutGroup")

				if var2 then
					onNextTick(function()
						var5.padding.bottom = 30

						Canvas.ForceUpdateCanvases()
					end)
				else
					var5.padding.bottom = var5.padding.top
				end

				local var6 = arg1.content

				if arg1.needBanRichText then
					var6 = SwitchSpecialChar(arg1.content)
				end

				var0.text = string.gsub(var6, ChatConst.EmojiIconCodeMatch, function(arg0)
					if table.contains(pg.emoji_small_template.all, tonumber(arg0)) then
						return string.format("<icon name=%s w=1 h=1/>", arg0)
					end
				end)
				arg0.isLoadChatBg = true
				arg0:GetComponent(typeof(LayoutElement)).preferredWidth = arg0.chatBgWidth
				arg0.name = var16

				setParent(arg0, arg0.chatFrameTr, false)
				tf(arg0):SetAsFirstSibling()
				Canvas.ForceUpdateCanvases()
				arg0:OnChatFrameLoaded(arg0)
			else
				PoolMgr.GetInstance():ReturnPrefab("ChatFrame/" .. var16, var16, arg0)
			end
		end)
	end

	setActive(arg0.face.parent, arg1.emojiId)
end

function var0.dispose(arg0)
	if arg0.face.childCount > 0 then
		local var0 = arg0.face:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0.name, var0.name, var0)
	end

	if arg0.circle.childCount > 0 then
		local var1 = arg0.circle:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var1.name, var1.name, var1)
	end

	if arg0.isLoadChatBg then
		local var2 = arg0.chatFrameTr:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("ChatFrame/" .. var2.name, var2.name, var2)

		arg0.isLoadChatBg = false
	end

	arg0.data = nil
end

function var0.OnChatFrameLoaded(arg0, arg1)
	return
end

return var0

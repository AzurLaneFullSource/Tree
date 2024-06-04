local var0 = class("ChatBubbleWorldBoss")

function var0.Ctor(arg0, arg1, arg2)
	arg0.tf = tf(arg1)
	arg0.interactable = defaultValue(arg2, true)
	arg0.nameTF = findTF(arg0.tf, "desc/name"):GetComponent("Text")
	arg0.face = findTF(arg0.tf, "face/content")
	arg0.circle = findTF(arg0.tf, "shipicon/frame")
	arg0.timeTF = findTF(arg0.tf, "time"):GetComponent("Text")
	arg0.headTF = findTF(arg0.tf, "shipicon/icon"):GetComponent("Image")
	arg0.stars = findTF(arg0.tf, "shipicon/stars")
	arg0.star = findTF(arg0.stars, "star")
	arg0.dutyTF = findTF(arg0.tf, "desc/duty")
	arg0.channel = findTF(arg0.tf, "desc/channel")
	arg0.chatframe = findTF(arg0.tf, "chat_fram")
	arg0.chatContent = findTF(arg0.tf, "chat_fram/Text"):GetComponent("Text")
	arg0.chatframeSel = findTF(arg0.tf, "chat_fram/sel")
	arg0.chatframeUnsel = findTF(arg0.tf, "chat_fram/unsel")

	setActive(arg0.chatframeSel, true)
	setActive(arg0.chatframeUnsel, false)
end

function var0.update(arg0, arg1)
	if arg0.data == arg1 then
		return
	end

	arg0.data = arg1

	local var0 = false
	local var1 = arg1.player

	if var1.icon == 0 then
		var1.icon = 101171
	end

	local var2 = var1.propose

	arg0.nameTF.text = var1.name

	local var3 = arg1.timestamp
	local var4 = getOfflineTimeStamp(var3)

	arg0.timeTF.text = var4

	local var5 = pg.ship_data_statistics[var1.icon]
	local var6 = Ship.New({
		configId = var5.id
	})
	local var7 = arg0.stars.childCount
	local var8 = var6:getStar()

	for iter0 = var7, var8 - 1 do
		cloneTplTo(arg0.star, arg0.stars)
	end

	local var9 = arg0.stars.childCount

	for iter1 = 0, var9 - 1 do
		arg0.stars:GetChild(iter1).gameObject:SetActive(iter1 < var5.star)
	end

	if arg0.channel then
		local var10 = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(arg1.type) .. "_1920")

		setImageSprite(arg0.channel, var10, true)
	end

	arg0.headTF.color = Color.New(1, 1, 1, 0)

	LoadSpriteAsync("qicon/" .. var1:getPainting(), function(arg0)
		if not IsNil(arg0.headTF) then
			arg0.headTF.color = Color.white
			arg0.headTF.sprite = arg0 or LoadSprite("heroicon/unknown")
		end
	end)

	if arg0.dutyTF then
		setActive(arg0.dutyTF, var1.duty)

		if var1.duty then
			local var11 = GetSpriteFromAtlas("dutyicon", var1.duty)

			setImageSprite(arg0.dutyTF, var11, true)
		end
	end

	local var12 = AttireFrame.attireFrameRes(var1, var0, AttireConst.TYPE_ICON_FRAME, var2)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var12, var12, true, function(arg0)
		if IsNil(arg0.tf) then
			return
		end

		if arg0.circle and arg0.data then
			arg0.name = var12
			findTF(arg0.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0, arg0.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var12, var12, arg0)
		end
	end)

	local var13 = arg1.args.wordBossId

	onButton(nil, arg0.chatframe, function()
		if not arg0.interactable then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_inbattle"))

			return
		end

		if arg1.args.isDeath then
			arg0:SetGray()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))

			return
		end

		pg.WorldBossTipMgr.GetInstance():OnClick("", var13, arg1.args.lastTime, function()
			arg0:SetGray()
		end)
	end, SFX_PANEL)

	if arg1.args.isDeath then
		arg0:SetGray()
	end

	arg0.chatContent.text = i18n("world_boss_ad", arg1.args.bossName, arg1.args.level)
end

function var0.SetGray(arg0)
	setActive(arg0.chatframeSel, false)
	setActive(arg0.chatframeUnsel, true)
end

function var0.dispose(arg0)
	removeOnButton(arg0.chatframe)

	if arg0.circle.childCount > 0 then
		local var0 = arg0.circle:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0.name, var0.name, var0)
	end
end

return var0

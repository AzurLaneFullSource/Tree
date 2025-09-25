local var0_0 = class("IslandFriendCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.iconTr = arg1_1.transform:Find("icon"):GetComponent(typeof(Image))
	arg0_1.giftTr = arg1_1.transform:Find("gift")
	arg0_1.nameTr = arg1_1.transform:Find("name"):GetComponent(typeof(Text))
	arg0_1.levelTr = arg1_1.transform:Find("level"):GetComponent(typeof(Text))
	arg0_1.descTxt = arg1_1.transform:Find("Text"):GetComponent(typeof(Text))
	arg0_1.onlineTr = arg1_1.transform:Find("online")
	arg0_1.offlineTr = arg1_1.transform:Find("offline")
	arg0_1.offlineTxt = arg1_1.transform:Find("offline/Text"):GetComponent(typeof(Text))
	arg0_1.visitBtn = arg1_1.transform:Find("visit")
	arg0_1.moreBtn = arg1_1.transform:Find("more")
	arg0_1.cardBtn = arg1_1.transform:Find("icon")

	setText(arg0_1.visitBtn:Find("Text"), i18n("island_btn_label_visit"))
	setText(arg0_1.moreBtn:Find("Text"), i18n("island_btn_label_more"))
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2.player = arg1_2

	local var0_2 = pg.ship_data_statistics[arg1_2.icon]
	local var1_2 = Ship.New({
		configId = arg1_2.icon
	})

	LoadSpriteAsync("qicon/" .. var1_2:getPrefab(), function(arg0_3)
		arg0_2.iconTr.sprite = arg0_3
	end)

	arg0_2.nameTr.text = arg1_2.name
	arg0_2.levelTr.text = "Lv." .. arg1_2.level
	arg0_2.descTxt.text = arg1_2.manifesto

	arg0_2:UpdateOnline(arg1_2)
end

function var0_0.UpdateOnline(arg0_4, arg1_4)
	local var0_4 = getProxy(IslandProxy):GetGiftTagInfoCache(arg1_4.id)

	setActive(arg0_4.giftTr, var0_4 and var0_4:ExistGift())

	local var1_4 = arg1_4:isOnline()

	setActive(arg0_4.onlineTr, var1_4)
	setActive(arg0_4.offlineTr, not var1_4)

	if not var1_4 then
		arg0_4.offlineTxt.text = getOfflineTimeStamp(arg1_4.preOnLineTime)
	end
end

function var0_0.Dispose(arg0_5)
	return
end

return var0_0

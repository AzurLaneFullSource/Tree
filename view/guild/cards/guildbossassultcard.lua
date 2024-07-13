local var0_0 = class("GuildBossAssultCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tr = tf(arg1_1)
	arg0_1._go = arg1_1
	arg0_1.mask = findTF(arg0_1._tr, "mask"):GetComponent(typeof(Image))
	arg0_1.icon = findTF(arg0_1._tr, "icon/icon"):GetComponent(typeof(Image))
	arg0_1.shipNameTxt = findTF(arg0_1._tr, "info/shipname"):GetComponent(typeof(Text))
	arg0_1.userNameTxt = findTF(arg0_1._tr, "info/username"):GetComponent(typeof(Text))
	arg0_1.levelTxt = findTF(arg0_1._tr, "info/lv/Text"):GetComponent(typeof(Text))
	arg0_1.startList = UIItemList.New(findTF(arg0_1._tr, "info/stars"), findTF(arg0_1._tr, "info/stars/star_tpl"))
	arg0_1.recommendBtn = findTF(arg0_1._tr, "info/recom_btn")
	arg0_1.recommendBtnMark = arg0_1.recommendBtn:Find("mark")
	arg0_1.viewEquipmentBtn = findTF(arg0_1._tr, "info/view_equipment")
	arg0_1.tag = findTF(arg0_1._tr, "tag")
end

function var0_0.Flush(arg0_2, arg1_2, arg2_2)
	arg0_2.shipNameTxt.text = arg2_2:getName()
	arg0_2.ship = arg2_2
	arg0_2.member = arg1_2
	arg0_2.levelTxt.text = arg2_2.level

	local var0_2 = arg2_2:getMaxStar()
	local var1_2 = arg2_2:getStar()

	arg0_2.startList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			setActive(arg2_3:Find("star_tpl"), arg1_3 <= var1_2)
		end
	end)
	arg0_2.startList:align(var0_2)

	arg0_2.userNameTxt.text = i18n("guild_ship_from") .. arg1_2.name

	LoadSpriteAsync("shipYardIcon/" .. arg2_2:getPainting(), function(arg0_4)
		if arg0_2._tr then
			arg0_2.icon.sprite = arg0_4
		end
	end)

	local var2_2 = arg2_2:rarity2bgPrint()
	local var3_2 = false

	if #var2_2 > 1 then
		if string.sub(var2_2, 1, 1) == "1" then
			var3_2 = true
		else
			var2_2 = string.sub(var2_2, 2, 1)
		end
	end

	arg0_2:LoadMetaEffect(var3_2)

	arg0_2.mask.sprite = GetSpriteFromAtlas("ui/GuildBossAssultUI_atlas", var2_2)

	setActive(arg0_2.recommendBtnMark, arg2_2.guildRecommand)
	setActive(arg0_2.tag, arg2_2.guildRecommand)

	local var4_2 = getProxy(GuildProxy):getRawData():getSelfDuty()

	setActive(arg0_2.recommendBtn, GuildMember.IsAdministrator(var4_2))
end

local var1_0 = "meta_huoxing"

function var0_0.LoadMetaEffect(arg0_5, arg1_5)
	if arg0_5.loading then
		arg0_5.destoryMetaEffect = not arg1_5

		return
	end

	if arg1_5 and not arg0_5.metaEffect then
		arg0_5.loading = true

		PoolMgr.GetInstance():GetUI(var1_0, true, function(arg0_6)
			arg0_5.loading = nil

			if arg0_5.destoryMetaEffect then
				arg0_5:RemoveMetaEffect()

				arg0_5.destoryMetaEffect = nil
			else
				arg0_5.metaEffect = arg0_6

				SetParent(arg0_5.metaEffect, arg0_5._tr)
				setActive(arg0_6, true)
			end
		end)
	elseif not arg1_5 and arg0_5.metaEffect then
		arg0_5:RemoveMetaEffect()
	elseif arg0_5.metaEffect then
		setActive(arg0_5.metaEffect, true)
	end
end

function var0_0.RemoveMetaEffect(arg0_7)
	if arg0_7.metaEffect then
		PoolMgr.GetInstance():ReturnUI(var1_0, arg0_7.metaEffect)

		arg0_7.metaEffect = nil
	end
end

function var0_0.Dispose(arg0_8)
	arg0_8:RemoveMetaEffect()

	arg0_8.destoryMetaEffect = true
end

return var0_0

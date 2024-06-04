local var0 = class("GuildBossAssultCard")

function var0.Ctor(arg0, arg1)
	arg0._tr = tf(arg1)
	arg0._go = arg1
	arg0.mask = findTF(arg0._tr, "mask"):GetComponent(typeof(Image))
	arg0.icon = findTF(arg0._tr, "icon/icon"):GetComponent(typeof(Image))
	arg0.shipNameTxt = findTF(arg0._tr, "info/shipname"):GetComponent(typeof(Text))
	arg0.userNameTxt = findTF(arg0._tr, "info/username"):GetComponent(typeof(Text))
	arg0.levelTxt = findTF(arg0._tr, "info/lv/Text"):GetComponent(typeof(Text))
	arg0.startList = UIItemList.New(findTF(arg0._tr, "info/stars"), findTF(arg0._tr, "info/stars/star_tpl"))
	arg0.recommendBtn = findTF(arg0._tr, "info/recom_btn")
	arg0.recommendBtnMark = arg0.recommendBtn:Find("mark")
	arg0.viewEquipmentBtn = findTF(arg0._tr, "info/view_equipment")
	arg0.tag = findTF(arg0._tr, "tag")
end

function var0.Flush(arg0, arg1, arg2)
	arg0.shipNameTxt.text = arg2:getName()
	arg0.ship = arg2
	arg0.member = arg1
	arg0.levelTxt.text = arg2.level

	local var0 = arg2:getMaxStar()
	local var1 = arg2:getStar()

	arg0.startList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			setActive(arg2:Find("star_tpl"), arg1 <= var1)
		end
	end)
	arg0.startList:align(var0)

	arg0.userNameTxt.text = i18n("guild_ship_from") .. arg1.name

	LoadSpriteAsync("shipYardIcon/" .. arg2:getPainting(), function(arg0)
		if arg0._tr then
			arg0.icon.sprite = arg0
		end
	end)

	local var2 = arg2:rarity2bgPrint()
	local var3 = false

	if #var2 > 1 then
		if string.sub(var2, 1, 1) == "1" then
			var3 = true
		else
			var2 = string.sub(var2, 2, 1)
		end
	end

	arg0:LoadMetaEffect(var3)

	arg0.mask.sprite = GetSpriteFromAtlas("ui/GuildBossAssultUI_atlas", var2)

	setActive(arg0.recommendBtnMark, arg2.guildRecommand)
	setActive(arg0.tag, arg2.guildRecommand)

	local var4 = getProxy(GuildProxy):getRawData():getSelfDuty()

	setActive(arg0.recommendBtn, GuildMember.IsAdministrator(var4))
end

local var1 = "meta_huoxing"

function var0.LoadMetaEffect(arg0, arg1)
	if arg0.loading then
		arg0.destoryMetaEffect = not arg1

		return
	end

	if arg1 and not arg0.metaEffect then
		arg0.loading = true

		PoolMgr.GetInstance():GetUI(var1, true, function(arg0)
			arg0.loading = nil

			if arg0.destoryMetaEffect then
				arg0:RemoveMetaEffect()

				arg0.destoryMetaEffect = nil
			else
				arg0.metaEffect = arg0

				SetParent(arg0.metaEffect, arg0._tr)
				setActive(arg0, true)
			end
		end)
	elseif not arg1 and arg0.metaEffect then
		arg0:RemoveMetaEffect()
	elseif arg0.metaEffect then
		setActive(arg0.metaEffect, true)
	end
end

function var0.RemoveMetaEffect(arg0)
	if arg0.metaEffect then
		PoolMgr.GetInstance():ReturnUI(var1, arg0.metaEffect)

		arg0.metaEffect = nil
	end
end

function var0.Dispose(arg0)
	arg0:RemoveMetaEffect()

	arg0.destoryMetaEffect = true
end

return var0

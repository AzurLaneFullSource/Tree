local var0 = class("FavoriteCard")

function var0.Ctor(arg0, arg1, arg2)
	arg0.go = arg1
	arg0.tr = tf(arg1)
	arg0.charTpl = arg2
	arg0.charContainer = arg0.tr:Find("char_list")
	arg0.isInitChar = false
	arg0.maxStar = 0
	arg0.nameTF = arg0.tr:Find("bonus/name_bg/Text"):GetComponent(typeof(Text))
	arg0.unfinish = arg0.tr:Find("bonus/item_tpl/unfinish")
	arg0.get = arg0.tr:Find("bonus/item_tpl/get")
	arg0.got = arg0.tr:Find("bonus/item_tpl/got")
	arg0.lock = arg0.tr:Find("bonus/item_tpl/lock")
	arg0.tip = arg0.tr:Find("bonus/item_tpl/tip")
	arg0.starCount = arg0.tr:Find("bonus/process"):GetComponent(typeof(Text))
	arg0.awardTF = arg0.tr:Find("bonus/item_tpl")
	arg0.iconTF = arg0.awardTF:Find("icon_bg")
	arg0.box = arg0.tr:Find("box")
end

local function var1(arg0)
	local var0 = {
		go = arg0,
		tr = tf(arg0)
	}

	var0.icon = var0.tr:Find("icon")
	var0.iconImg = var0.icon:GetComponent(typeof(Image))
	var0.stars = findTF(var0.tr, "stars")
	var0.starTpl = findTF(var0.stars, "star")
	var0.name = findTF(var0.tr, "name"):GetComponent(typeof(Text))
	var0.unkonwn = findTF(var0.tr, "unkonwn")

	function var0.update(arg0, arg1, arg2)
		var0.name.text = arg1:getConfig("name")

		LoadSpriteAsync("shipmodels/" .. Ship.getPaintingName(arg1.configId), function(arg0)
			if arg0 then
				rtf(arg0.icon).pivot = getSpritePivot(arg0)
				var0.iconImg.sprite = arg0

				var0.iconImg:SetNativeSize()

				arg0.icon.localPosition = Vector3(0, -85, 0)

				setActive(var0.iconImg, true)
			end
		end)
		setActive(var0.stars, arg2)

		if arg2 then
			setImageColor(arg0.icon, Color.New(1, 1, 1, 1))

			local var0 = arg1:getMaxStar()

			for iter0 = var0.stars.childCount + 1, var0 do
				cloneTplTo(var0.starTpl, var0.stars)
			end

			local var1 = {
				[4] = {
					1,
					2,
					3,
					4
				},
				[5] = {
					1,
					2,
					5,
					3,
					4
				},
				[6] = {
					1,
					2,
					5,
					6,
					3,
					4
				}
			}

			for iter1 = 1, 6 do
				local var2 = findTF(var0.stars, "star_" .. iter1)

				setActive(var2, iter1 <= var0)
				setActive(var2:Find("startpl"), false)
			end

			local var3 = var1[var0]

			for iter2 = 1, var0 do
				local var4 = findTF(var0.stars, "star_" .. var3[iter2])

				setActive(var4:Find("startpl"), iter2 <= arg2.star)
			end
		else
			setImageColor(arg0.icon, Color.New(0, 0, 0, 0.7))
		end

		setActive(var0.unkonwn, not arg2)
	end

	return var0
end

function var0.update(arg0, arg1, arg2, arg3)
	arg0.favoriteVO = arg1
	arg0.shipGroups = arg2
	arg0.awards = arg3

	local var0 = {}
	local var1 = arg1:getConfig("char_list")

	for iter0 = arg0.charContainer.childCount, #var1 - 1 do
		cloneTplTo(arg0.charTpl, arg0.charContainer)
	end

	for iter1 = 0, arg0.charContainer.childCount - 1 do
		local var2 = arg0.charContainer:GetChild(iter1)

		setActive(var2, iter1 < #var1)

		local var3 = var1[iter1 + 1]

		if iter1 < #var1 then
			var0[var3] = var1(var2)
		end
	end

	local var4 = 0
	local var5 = 0

	for iter2, iter3 in pairs(var0) do
		local var6 = iter2 * 10 + 1
		local var7 = Ship.New({
			configId = var6
		})

		iter3:update(var7, arg2[iter2])

		var4 = var4 + (arg2[iter2] and arg2[iter2].star or 0)
		var5 = var5 + var7:getMaxStar()
	end

	arg0.nameTF.text = arg1:getConfig("name")

	arg0:updateBound()
end

function var0.updateBound(arg0)
	arg0.state = arg0.favoriteVO:getState(arg0.shipGroups, arg0.awards)

	setActive(arg0.unfinish, arg0.state == Favorite.STATE_WAIT)
	setActive(arg0.get, arg0.state == Favorite.STATE_AWARD)
	setActive(arg0.got, arg0.state == Favorite.STATE_FETCHED)
	setActive(arg0.lock, arg0.state == Favorite.STATE_LOCK)
	setActive(arg0.tip, arg0.state == Favorite.STATE_AWARD)

	local var0 = arg0.favoriteVO:getNextAwardIndex(arg0.awards)
	local var1 = arg0.favoriteVO:getConfig("award_display")
	local var2 = var1[var0] and var1[var0] or var1[#var1]

	updateDrop(arg0.awardTF, {
		type = var2[1],
		id = var2[2],
		count = var2[3]
	})

	local var3 = arg0.favoriteVO:getConfig("level")
	local var4 = arg0.favoriteVO:getStarCount(arg0.shipGroups)

	arg0.starCount.text = var4 .. "/" .. (var3[var0] or var3[#var3])
end

return var0

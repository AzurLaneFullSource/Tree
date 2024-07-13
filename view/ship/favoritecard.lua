local var0_0 = class("FavoriteCard")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.go = arg1_1
	arg0_1.tr = tf(arg1_1)
	arg0_1.charTpl = arg2_1
	arg0_1.charContainer = arg0_1.tr:Find("char_list")
	arg0_1.isInitChar = false
	arg0_1.maxStar = 0
	arg0_1.nameTF = arg0_1.tr:Find("bonus/name_bg/Text"):GetComponent(typeof(Text))
	arg0_1.unfinish = arg0_1.tr:Find("bonus/item_tpl/unfinish")
	arg0_1.get = arg0_1.tr:Find("bonus/item_tpl/get")
	arg0_1.got = arg0_1.tr:Find("bonus/item_tpl/got")
	arg0_1.lock = arg0_1.tr:Find("bonus/item_tpl/lock")
	arg0_1.tip = arg0_1.tr:Find("bonus/item_tpl/tip")
	arg0_1.starCount = arg0_1.tr:Find("bonus/process"):GetComponent(typeof(Text))
	arg0_1.awardTF = arg0_1.tr:Find("bonus/item_tpl")
	arg0_1.iconTF = arg0_1.awardTF:Find("icon_bg")
	arg0_1.box = arg0_1.tr:Find("box")
end

local function var1_0(arg0_2)
	local var0_2 = {
		go = arg0_2,
		tr = tf(arg0_2)
	}

	var0_2.icon = var0_2.tr:Find("icon")
	var0_2.iconImg = var0_2.icon:GetComponent(typeof(Image))
	var0_2.stars = findTF(var0_2.tr, "stars")
	var0_2.starTpl = findTF(var0_2.stars, "star")
	var0_2.name = findTF(var0_2.tr, "name"):GetComponent(typeof(Text))
	var0_2.unkonwn = findTF(var0_2.tr, "unkonwn")

	function var0_2.update(arg0_3, arg1_3, arg2_3)
		var0_2.name.text = arg1_3:getConfig("name")

		LoadSpriteAsync("shipmodels/" .. Ship.getPaintingName(arg1_3.configId), function(arg0_4)
			if arg0_4 then
				rtf(arg0_3.icon).pivot = getSpritePivot(arg0_4)
				var0_2.iconImg.sprite = arg0_4

				var0_2.iconImg:SetNativeSize()

				arg0_3.icon.localPosition = Vector3(0, -85, 0)

				setActive(var0_2.iconImg, true)
			end
		end)
		setActive(var0_2.stars, arg2_3)

		if arg2_3 then
			setImageColor(arg0_3.icon, Color.New(1, 1, 1, 1))

			local var0_3 = arg1_3:getMaxStar()

			for iter0_3 = var0_2.stars.childCount + 1, var0_3 do
				cloneTplTo(var0_2.starTpl, var0_2.stars)
			end

			local var1_3 = {
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

			for iter1_3 = 1, 6 do
				local var2_3 = findTF(var0_2.stars, "star_" .. iter1_3)

				setActive(var2_3, iter1_3 <= var0_3)
				setActive(var2_3:Find("startpl"), false)
			end

			local var3_3 = var1_3[var0_3]

			for iter2_3 = 1, var0_3 do
				local var4_3 = findTF(var0_2.stars, "star_" .. var3_3[iter2_3])

				setActive(var4_3:Find("startpl"), iter2_3 <= arg2_3.star)
			end
		else
			setImageColor(arg0_3.icon, Color.New(0, 0, 0, 0.7))
		end

		setActive(var0_2.unkonwn, not arg2_3)
	end

	return var0_2
end

function var0_0.update(arg0_5, arg1_5, arg2_5, arg3_5)
	arg0_5.favoriteVO = arg1_5
	arg0_5.shipGroups = arg2_5
	arg0_5.awards = arg3_5

	local var0_5 = {}
	local var1_5 = arg1_5:getConfig("char_list")

	for iter0_5 = arg0_5.charContainer.childCount, #var1_5 - 1 do
		cloneTplTo(arg0_5.charTpl, arg0_5.charContainer)
	end

	for iter1_5 = 0, arg0_5.charContainer.childCount - 1 do
		local var2_5 = arg0_5.charContainer:GetChild(iter1_5)

		setActive(var2_5, iter1_5 < #var1_5)

		local var3_5 = var1_5[iter1_5 + 1]

		if iter1_5 < #var1_5 then
			var0_5[var3_5] = var1_0(var2_5)
		end
	end

	local var4_5 = 0
	local var5_5 = 0

	for iter2_5, iter3_5 in pairs(var0_5) do
		local var6_5 = iter2_5 * 10 + 1
		local var7_5 = Ship.New({
			configId = var6_5
		})

		iter3_5:update(var7_5, arg2_5[iter2_5])

		var4_5 = var4_5 + (arg2_5[iter2_5] and arg2_5[iter2_5].star or 0)
		var5_5 = var5_5 + var7_5:getMaxStar()
	end

	arg0_5.nameTF.text = arg1_5:getConfig("name")

	arg0_5:updateBound()
end

function var0_0.updateBound(arg0_6)
	arg0_6.state = arg0_6.favoriteVO:getState(arg0_6.shipGroups, arg0_6.awards)

	setActive(arg0_6.unfinish, arg0_6.state == Favorite.STATE_WAIT)
	setActive(arg0_6.get, arg0_6.state == Favorite.STATE_AWARD)
	setActive(arg0_6.got, arg0_6.state == Favorite.STATE_FETCHED)
	setActive(arg0_6.lock, arg0_6.state == Favorite.STATE_LOCK)
	setActive(arg0_6.tip, arg0_6.state == Favorite.STATE_AWARD)

	local var0_6 = arg0_6.favoriteVO:getNextAwardIndex(arg0_6.awards)
	local var1_6 = arg0_6.favoriteVO:getConfig("award_display")
	local var2_6 = var1_6[var0_6] and var1_6[var0_6] or var1_6[#var1_6]

	updateDrop(arg0_6.awardTF, {
		type = var2_6[1],
		id = var2_6[2],
		count = var2_6[3]
	})

	local var3_6 = arg0_6.favoriteVO:getConfig("level")
	local var4_6 = arg0_6.favoriteVO:getStarCount(arg0_6.shipGroups)

	arg0_6.starCount.text = var4_6 .. "/" .. (var3_6[var0_6] or var3_6[#var3_6])
end

return var0_0

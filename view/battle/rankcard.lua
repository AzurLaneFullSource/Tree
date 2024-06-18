local var0_0 = class("RankCard")

var0_0.TYPE_SELF = 1
var0_0.TYPE_OTHER = 2
var0_0.COLORS = {
	"#ffde5c",
	"#95b0f9",
	"#cfc1ba",
	"#797d81"
}

local var1_0 = {
	{
		1,
		0.870588235294118,
		0.36078431372549
	},
	{
		0.584313725490196,
		0.690196078431373,
		0.976470588235294
	},
	{
		0.811764705882353,
		0.756862745098039,
		0.729411764705882
	},
	{
		0.474509803921569,
		0.490196078431373,
		0.505882352941176
	}
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = go(arg1_1)
	arg0_1._tf = arg1_1
	arg0_1._type = arg2_1
	arg0_1.frameTF = findTF(arg0_1._tf, "frame")
	arg0_1.frameBgTF = findTF(arg0_1._tf, "frame/bg"):GetComponent(typeof(Image))
	arg0_1.NumImgTF = findTF(arg0_1._tf, "frame/number_img")
	arg0_1.nameTF = findTF(arg0_1._tf, "frame/name"):GetComponent(typeof(Text))
	arg0_1.numberTF = findTF(arg0_1._tf, "frame/number"):GetComponent(typeof(Text))
	arg0_1.notonlistTF = findTF(arg0_1._tf, "frame/notonlist")
	arg0_1.scoreTF = findTF(arg0_1._tf, "frame/score"):GetComponent(typeof(Text))
	arg0_1.emblemTF = findTF(arg0_1._tf, "frame/emblem")
	arg0_1.scoreIconTF = findTF(arg0_1._tf, "frame/score_icon"):GetComponent(typeof(Image))
	arg0_1.iconTF = findTF(arg0_1._tf, "icon")
	arg0_1.levelTxt = findTF(arg0_1.iconTF, "level_bg/Text"):GetComponent(typeof(Text))

	ClearTweenItemAlphaAndWhite(arg0_1._go)
end

function var0_0.update(arg0_2, arg1_2, arg2_2)
	arg0_2.rankVO = arg1_2
	arg0_2.nameTF.text = arg1_2.name

	local var0_2 = arg1_2.rank

	arg0_2.numberTF.text = var0_2

	local var1_2 = math.min(var0_2 > 0 and var0_2 or 4, 4)

	arg0_2.levelTxt.text = "Lv." .. arg1_2.lv

	setActive(arg0_2.NumImgTF, var1_2 < 4)
	setImageSprite(arg0_2.frameTF, GetSpriteFromAtlas("billboardframe", "bg" .. var1_2))
	setImageSprite(arg0_2.NumImgTF, GetSpriteFromAtlas("billboardframe", "bgn" .. var1_2), true)

	local var2_2 = var1_0[var1_2]

	arg0_2.frameBgTF.color = Color.New(var2_2[1], var2_2[2], var2_2[3])

	if arg0_2._type == var0_0.TYPE_OTHER then
		setActive(arg0_2.numberTF, var1_2 >= 4)

		arg0_2.scoreTF.text = setColorStr(arg1_2:getPowerTxt(), var0_0.COLORS[var1_2])
	elseif arg0_2._type == var0_0.TYPE_SELF then
		setActive(arg0_2.numberTF, var0_2 ~= 0 and var1_2 >= 4)
		setActive(arg0_2.notonlistTF, var0_2 == 0)

		arg0_2.scoreTF.text = arg1_2:getPowerTxt()
	end

	local var3_2 = PowerRank:getScoreIcon(arg1_2.type)

	setActive(arg0_2.scoreIconTF, var3_2)

	if var3_2 then
		if arg1_2.type == PowerRank.TYPE_PT then
			if arg2_2 then
				local var4_2 = getProxy(ActivityProxy):getActivityById(arg2_2):getConfig("config_id")
				local var5_2 = Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = var4_2
				}):getIcon()

				setImageSprite(arg0_2.scoreIconTF, LoadSprite(var5_2))
			end
		else
			setImageSprite(arg0_2.scoreIconTF, GetSpriteFromAtlas(var3_2[1], var3_2[2]), true)
		end
	end

	LoadImageSpriteAsync("emblem/" .. arg1_2.arenaRank, arg0_2.emblemTF)

	if not go(arg0_2.emblemTF).activeSelf then
		setActive(arg0_2.emblemTF, true)
	end

	updateDrop(arg0_2.iconTF, {
		type = DROP_TYPE_SHIP,
		id = arg1_2.icon,
		skinId = arg1_2.skinId,
		remoulded = arg1_2.remoulded,
		propose = arg1_2.proposeTime
	})

	if not go(arg0_2.iconTF).activeSelf then
		setActive(arg0_2.iconTF, true)
	end

	if not go(arg0_2._tf).activeSelf then
		setActive(arg0_2._tf, true)
	end

	TweenItemAlphaAndWhite(arg0_2._go)
end

function var0_0.clear(arg0_3)
	ClearTweenItemAlphaAndWhite(arg0_3._go)

	if not IsNil(arg0_3.notonlistTF) then
		setActive(arg0_3.notonlistTF, false)
	end

	arg0_3.scoreTF.text = 0
	arg0_3.numberTF.text = 0
end

function var0_0.dispose(arg0_4, ...)
	return
end

return var0_0

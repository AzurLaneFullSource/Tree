local var0 = class("RankCard")

var0.TYPE_SELF = 1
var0.TYPE_OTHER = 2
var0.COLORS = {
	"#ffde5c",
	"#95b0f9",
	"#cfc1ba",
	"#797d81"
}

local var1 = {
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

function var0.Ctor(arg0, arg1, arg2)
	arg0._go = go(arg1)
	arg0._tf = arg1
	arg0._type = arg2
	arg0.frameTF = findTF(arg0._tf, "frame")
	arg0.frameBgTF = findTF(arg0._tf, "frame/bg"):GetComponent(typeof(Image))
	arg0.NumImgTF = findTF(arg0._tf, "frame/number_img")
	arg0.nameTF = findTF(arg0._tf, "frame/name"):GetComponent(typeof(Text))
	arg0.numberTF = findTF(arg0._tf, "frame/number"):GetComponent(typeof(Text))
	arg0.notonlistTF = findTF(arg0._tf, "frame/notonlist")
	arg0.scoreTF = findTF(arg0._tf, "frame/score"):GetComponent(typeof(Text))
	arg0.emblemTF = findTF(arg0._tf, "frame/emblem")
	arg0.scoreIconTF = findTF(arg0._tf, "frame/score_icon"):GetComponent(typeof(Image))
	arg0.iconTF = findTF(arg0._tf, "icon")
	arg0.levelTxt = findTF(arg0.iconTF, "level_bg/Text"):GetComponent(typeof(Text))

	ClearTweenItemAlphaAndWhite(arg0._go)
end

function var0.update(arg0, arg1, arg2)
	arg0.rankVO = arg1
	arg0.nameTF.text = arg1.name

	local var0 = arg1.rank

	arg0.numberTF.text = var0

	local var1 = math.min(var0 > 0 and var0 or 4, 4)

	arg0.levelTxt.text = "Lv." .. arg1.lv

	setActive(arg0.NumImgTF, var1 < 4)
	setImageSprite(arg0.frameTF, GetSpriteFromAtlas("billboardframe", "bg" .. var1))
	setImageSprite(arg0.NumImgTF, GetSpriteFromAtlas("billboardframe", "bgn" .. var1), true)

	local var2 = var1[var1]

	arg0.frameBgTF.color = Color.New(var2[1], var2[2], var2[3])

	if arg0._type == var0.TYPE_OTHER then
		setActive(arg0.numberTF, var1 >= 4)

		arg0.scoreTF.text = setColorStr(arg1:getPowerTxt(), var0.COLORS[var1])
	elseif arg0._type == var0.TYPE_SELF then
		setActive(arg0.numberTF, var0 ~= 0 and var1 >= 4)
		setActive(arg0.notonlistTF, var0 == 0)

		arg0.scoreTF.text = arg1:getPowerTxt()
	end

	local var3 = PowerRank:getScoreIcon(arg1.type)

	setActive(arg0.scoreIconTF, var3)

	if var3 then
		if arg1.type == PowerRank.TYPE_PT then
			if arg2 then
				local var4 = getProxy(ActivityProxy):getActivityById(arg2):getConfig("config_id")
				local var5 = Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = var4
				}):getIcon()

				setImageSprite(arg0.scoreIconTF, LoadSprite(var5))
			end
		else
			setImageSprite(arg0.scoreIconTF, GetSpriteFromAtlas(var3[1], var3[2]), true)
		end
	end

	LoadImageSpriteAsync("emblem/" .. arg1.arenaRank, arg0.emblemTF)

	if not go(arg0.emblemTF).activeSelf then
		setActive(arg0.emblemTF, true)
	end

	updateDrop(arg0.iconTF, {
		type = DROP_TYPE_SHIP,
		id = arg1.icon,
		skinId = arg1.skinId,
		remoulded = arg1.remoulded,
		propose = arg1.proposeTime
	})

	if not go(arg0.iconTF).activeSelf then
		setActive(arg0.iconTF, true)
	end

	if not go(arg0._tf).activeSelf then
		setActive(arg0._tf, true)
	end

	TweenItemAlphaAndWhite(arg0._go)
end

function var0.clear(arg0)
	ClearTweenItemAlphaAndWhite(arg0._go)

	if not IsNil(arg0.notonlistTF) then
		setActive(arg0.notonlistTF, false)
	end

	arg0.scoreTF.text = 0
	arg0.numberTF.text = 0
end

function var0.dispose(arg0, ...)
	return
end

return var0

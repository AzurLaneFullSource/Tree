local var0 = class("CardPuzzleCardView")

var0.AFFIX_TYPE = {
	TAG = 0,
	AFFIX = 2,
	SCHOOL = 1
}
var0.CARD_TYPE = {
	ATTACK = 1,
	ABILITY = 3,
	TACTIC = 2
}

local var1 = {
	[0] = "cardBG_white",
	"cardBG_white",
	"cardBG_blue",
	"cardBG_purple",
	"cardBG_yellow"
}

var0.TowerCardType2Color = {
	"red",
	"blue",
	"yellow"
}

function var0.Ctor(arg0, arg1)
	arg0._tf = tf(arg1)
	arg0.bgTF = arg0._tf:Find("BG")
	arg0.iconBG = arg0._tf:Find("IconBG")
	arg0.iconTF = arg0.iconBG:Find("Icon")
	arg0.schoolBG = arg0.iconBG:Find("SchoolBG")
	arg0.schoolIcon = arg0.schoolBG:Find("SchoolIcon")
	arg0.nameTF = arg0._tf:Find("Name")
	arg0.descTF = arg0._tf:Find("Desc")
	arg0.costTF = arg0._tf:Find("Cost")
	arg0.keywordListContainer = arg0._tf:Find("KeywordList")
end

function var0.SetData(arg0, arg1)
	arg0.data = arg1
end

function var0.GetSkillIconBG(arg0, arg1)
	return "icon_bg_" .. var0.TowerCardType2Color[arg1]
end

function var0.GetRarityBG(arg0, arg1)
	return var1[arg1]
end

function var0.GetCardCost(arg0)
	return arg0.data:GetCost()
end

function var0.UpdateView(arg0)
	setImageSprite(arg0.iconTF, LoadSprite(arg0.data:GetIconPath(), ""), true)
	setImageSprite(arg0.iconBG, LoadSprite("ui/CardTowerCardView_atlas", arg0:GetSkillIconBG(arg0.data:GetType())))
	setImageSprite(arg0.bgTF, LoadSprite("ui/CardTowerCardView_atlas", arg0:GetRarityBG(arg0.data:GetRarity())))
	setText(arg0.nameTF, arg0.data:GetName())
	setText(arg0.descTF, arg0.data:GetDesc())
	setText(arg0.costTF, arg0.data:GetCost())

	local var0 = arg0.data:GetKeywords()
	local var1 = _.filter(var0, function(arg0)
		return arg0.affix_type == var0.AFFIX_TYPE.AFFIX and arg0.show == 0
	end)

	UIItemList.StaticAlign(arg0.keywordListContainer, arg0.keywordListContainer:GetChild(0), #var1, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		arg1 = arg1 + 1

		setText(arg2, var1[arg1].name)
	end)

	local var2 = _.detect(var0, function(arg0)
		return arg0.affix_type == var0.AFFIX_TYPE.SCHOOL and arg0.show == 0
	end)

	setActive(arg0.schoolBG, var2)
	setActive(arg0.schoolIcon, var2)

	if var2 then
		setImageSprite(arg0.schoolBG, LoadSprite("ui/CardTowerCardView_atlas", "circle_" .. var0.TowerCardType2Color[arg0.data:GetType()]))
		setImageSprite(arg0.schoolIcon, LoadSprite("ui/RogueCardSchoolIcons_atlas", var2.icon), true)
	end

	TweenItemAlphaAndWhite(go(arg0._tf))
end

function var0.Clear(arg0)
	ClearTweenItemAlphaAndWhite(go(arg0._tf))
end

return var0

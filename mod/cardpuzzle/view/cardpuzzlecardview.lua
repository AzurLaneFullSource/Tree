local var0_0 = class("CardPuzzleCardView")

var0_0.AFFIX_TYPE = {
	TAG = 0,
	AFFIX = 2,
	SCHOOL = 1
}
var0_0.CARD_TYPE = {
	ATTACK = 1,
	ABILITY = 3,
	TACTIC = 2
}

local var1_0 = {
	[0] = "cardBG_white",
	"cardBG_white",
	"cardBG_blue",
	"cardBG_purple",
	"cardBG_yellow"
}

var0_0.TowerCardType2Color = {
	"red",
	"blue",
	"yellow"
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = tf(arg1_1)
	arg0_1.bgTF = arg0_1._tf:Find("BG")
	arg0_1.iconBG = arg0_1._tf:Find("IconBG")
	arg0_1.iconTF = arg0_1.iconBG:Find("Icon")
	arg0_1.schoolBG = arg0_1.iconBG:Find("SchoolBG")
	arg0_1.schoolIcon = arg0_1.schoolBG:Find("SchoolIcon")
	arg0_1.nameTF = arg0_1._tf:Find("Name")
	arg0_1.descTF = arg0_1._tf:Find("Desc")
	arg0_1.costTF = arg0_1._tf:Find("Cost")
	arg0_1.keywordListContainer = arg0_1._tf:Find("KeywordList")
end

function var0_0.SetData(arg0_2, arg1_2)
	arg0_2.data = arg1_2
end

function var0_0.GetSkillIconBG(arg0_3, arg1_3)
	return "icon_bg_" .. var0_0.TowerCardType2Color[arg1_3]
end

function var0_0.GetRarityBG(arg0_4, arg1_4)
	return var1_0[arg1_4]
end

function var0_0.GetCardCost(arg0_5)
	return arg0_5.data:GetCost()
end

function var0_0.UpdateView(arg0_6)
	setImageSprite(arg0_6.iconTF, LoadSprite(arg0_6.data:GetIconPath(), ""), true)
	setImageSprite(arg0_6.iconBG, LoadSprite("ui/CardTowerCardView_atlas", arg0_6:GetSkillIconBG(arg0_6.data:GetType())))
	setImageSprite(arg0_6.bgTF, LoadSprite("ui/CardTowerCardView_atlas", arg0_6:GetRarityBG(arg0_6.data:GetRarity())))
	setText(arg0_6.nameTF, arg0_6.data:GetName())
	setText(arg0_6.descTF, arg0_6.data:GetDesc())
	setText(arg0_6.costTF, arg0_6.data:GetCost())

	local var0_6 = arg0_6.data:GetKeywords()
	local var1_6 = _.filter(var0_6, function(arg0_7)
		return arg0_7.affix_type == var0_0.AFFIX_TYPE.AFFIX and arg0_7.show == 0
	end)

	UIItemList.StaticAlign(arg0_6.keywordListContainer, arg0_6.keywordListContainer:GetChild(0), #var1_6, function(arg0_8, arg1_8, arg2_8)
		if arg0_8 ~= UIItemList.EventUpdate then
			return
		end

		arg1_8 = arg1_8 + 1

		setText(arg2_8, var1_6[arg1_8].name)
	end)

	local var2_6 = _.detect(var0_6, function(arg0_9)
		return arg0_9.affix_type == var0_0.AFFIX_TYPE.SCHOOL and arg0_9.show == 0
	end)

	setActive(arg0_6.schoolBG, var2_6)
	setActive(arg0_6.schoolIcon, var2_6)

	if var2_6 then
		setImageSprite(arg0_6.schoolBG, LoadSprite("ui/CardTowerCardView_atlas", "circle_" .. var0_0.TowerCardType2Color[arg0_6.data:GetType()]))
		setImageSprite(arg0_6.schoolIcon, LoadSprite("ui/RogueCardSchoolIcons_atlas", var2_6.icon), true)
	end

	TweenItemAlphaAndWhite(go(arg0_6._tf))
end

function var0_0.Clear(arg0_10)
	ClearTweenItemAlphaAndWhite(go(arg0_10._tf))
end

return var0_0

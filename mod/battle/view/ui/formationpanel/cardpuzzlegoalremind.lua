ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleCardPuzzleEvent
local var3 = var0.Battle.BattleDataFunction

var0.Battle.CardPuzzleGoalRemind = class("CardPuzzleGoalRemind")

local var4 = var0.Battle.CardPuzzleGoalRemind

var4.__name = "CardPuzzleGoalRemind"

function var4.Ctor(arg0, arg1)
	arg0._go = arg1

	arg0:init()
end

function var4.SetCardPuzzleComponent(arg0, arg1)
	local var0 = arg1:GetPuzzleDungeonID()

	arg0._tmp = var3.GetPuzzleDungeonTemplate(var0)

	setText(arg0._bg:Find("text"), arg0._tmp.description)
end

function var4.init(arg0)
	pg.DelegateInfo.New(arg0)

	arg0._tf = arg0._go.transform
	arg0._bg = arg0._tf:Find("bg")

	setText(arg0._bg:Find("label_ch"), i18n("card_puzzel_goal_ch"))
	setText(arg0._bg:Find("label_en"), i18n("card_puzzel_goal_en"))

	arg0._arrow = arg0._bg:Find("arrow")
	arg0._openFlag = 1

	onButton(arg0, arg0._bg, function()
		local var0 = rtf(arg0._bg).rect
		local var1 = var0.height + arg0._openFlag * 150

		rtf(arg0._bg).sizeDelta = Vector2(var0.width, var1)
		arg0._openFlag = arg0._openFlag * -1
		arg0._arrow.localScale = Vector3(1, arg0._openFlag, 1)
	end)
end

function var4.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)

	arg0._arrow = nil
	arg0._bg = nil
	arg0._tf = nil
end

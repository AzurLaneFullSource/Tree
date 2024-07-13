ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleCardPuzzleEvent
local var3_0 = var0_0.Battle.BattleDataFunction

var0_0.Battle.CardPuzzleGoalRemind = class("CardPuzzleGoalRemind")

local var4_0 = var0_0.Battle.CardPuzzleGoalRemind

var4_0.__name = "CardPuzzleGoalRemind"

function var4_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1

	arg0_1:init()
end

function var4_0.SetCardPuzzleComponent(arg0_2, arg1_2)
	local var0_2 = arg1_2:GetPuzzleDungeonID()

	arg0_2._tmp = var3_0.GetPuzzleDungeonTemplate(var0_2)

	setText(arg0_2._bg:Find("text"), arg0_2._tmp.description)
end

function var4_0.init(arg0_3)
	pg.DelegateInfo.New(arg0_3)

	arg0_3._tf = arg0_3._go.transform
	arg0_3._bg = arg0_3._tf:Find("bg")

	setText(arg0_3._bg:Find("label_ch"), i18n("card_puzzel_goal_ch"))
	setText(arg0_3._bg:Find("label_en"), i18n("card_puzzel_goal_en"))

	arg0_3._arrow = arg0_3._bg:Find("arrow")
	arg0_3._openFlag = 1

	onButton(arg0_3, arg0_3._bg, function()
		local var0_4 = rtf(arg0_3._bg).rect
		local var1_4 = var0_4.height + arg0_3._openFlag * 150

		rtf(arg0_3._bg).sizeDelta = Vector2(var0_4.width, var1_4)
		arg0_3._openFlag = arg0_3._openFlag * -1
		arg0_3._arrow.localScale = Vector3(1, arg0_3._openFlag, 1)
	end)
end

function var4_0.Dispose(arg0_5)
	pg.DelegateInfo.Dispose(arg0_5)

	arg0_5._arrow = nil
	arg0_5._bg = nil
	arg0_5._tf = nil
end

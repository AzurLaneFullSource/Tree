local var0_0 = class("NewGuildResultStatisticsPage", import("..NewBattleResultStatisticsPage"))

function var0_0.UpdateGrade(arg0_1)
	local var0_1 = "battlescore/grade_label_clear"

	LoadImageSpriteAsync(var0_1, arg0_1.gradeTxt, false)
	setActive(arg0_1.gradeIcon, false)
end

function var0_0.UpdatePainting(arg0_2, arg1_2)
	arg0_2:UpdatePaintingPosition()
	arg0_2:UpdateMvpPainting(arg1_2)
end

return var0_0

local var0 = class("NewGuildResultStatisticsPage", import("..NewBattleResultStatisticsPage"))

function var0.UpdateGrade(arg0)
	local var0 = "battlescore/grade_label_clear"

	LoadImageSpriteAsync(var0, arg0.gradeTxt, false)
	setActive(arg0.gradeIcon, false)
end

function var0.UpdatePainting(arg0, arg1)
	arg0:UpdatePaintingPosition()
	arg0:UpdateMvpPainting(arg1)
end

return var0

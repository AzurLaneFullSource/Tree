local var0_0 = class("ActivityBossZhangwuScene", import(".ActivityBossJianwuScene"))

function var0_0.getUIName(arg0_1)
	return "ActivityBossZhangwuUI"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)
	setText(arg0_2.right:Find("1/Image"), i18n("word_easy"))
	setText(arg0_2.right:Find("2/Image"), i18n("word_normal_junhe"))
	setText(arg0_2.right:Find("3/Image"), i18n("word_hard"))
	setText(arg0_2.top:Find("ticket/Desc"), i18n("word_special_challenge_ticket"))
	setAnchoredPosition(arg0_2.left, {
		x = 0
	})
	setAnchoredPosition(arg0_2.right, {
		x = 0
	})
end

return var0_0

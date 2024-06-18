local var0_0 = class("LevelAmbushView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "LevelAmbushView"
end

function var0_0.OnInit(arg0_2)
	arg0_2:InitData()
	arg0_2:InitUI()
	setActive(arg0_2._tf, true)
end

function var0_0.InitData(arg0_3)
	arg0_3.chapter = arg0_3.contextData.chapterVO
	arg0_3.fleet = arg0_3.chapter.fleet

	local var0_3 = arg0_3.chapter:getChapterCell(arg0_3.fleet.line.row, arg0_3.fleet.line.column)

	arg0_3.template = pg.expedition_data_template[var0_3.attachmentId]
end

function var0_0.InitUI(arg0_4)
	local var0_4 = findTF(arg0_4._tf, "window")
	local var1_4 = findTF(arg0_4._tf, "window/ship/lv/Text")
	local var2_4 = findTF(arg0_4._tf, "window/ship/icon")
	local var3_4 = findTF(arg0_4._tf, "window/evade/rate")
	local var4_4 = findTF(arg0_4._tf, "window/fight_button")
	local var5_4 = findTF(arg0_4._tf, "window/dodge_button")

	GetImageSpriteFromAtlasAsync("enemies/" .. arg0_4.template.icon, "", var2_4)
	setText(var1_4, arg0_4.template.level)
	setText(var3_4, math.floor(arg0_4.chapter:getAmbushDodge(arg0_4.fleet) * 100) .. "%")
	onButton(arg0_4, var4_4, function()
		arg0_4:emit(LevelMediator2.ON_OP, {
			arg1 = 0,
			type = ChapterConst.OpAmbush,
			id = arg0_4.fleet.id
		})
		arg0_4:Destroy()
	end, SFX_UI_WEIGHANCHOR_ATTACK)
	onButton(arg0_4, var5_4, function()
		arg0_4:emit(LevelMediator2.ON_OP, {
			arg1 = 1,
			type = ChapterConst.OpAmbush,
			id = arg0_4.fleet.id
		})
		arg0_4:Destroy()
	end, SFX_UI_WEIGHANCHOR_AVOID)

	var0_4.localScale = Vector3(1, 0, 1)

	LeanTween.scaleY(var0_4.gameObject, 1, 0.3):setOnComplete(System.Action(arg0_4.onComplete))
end

function var0_0.OnDestroy(arg0_7)
	return
end

function var0_0.SetFuncOnComplete(arg0_8, arg1_8)
	arg0_8.onComplete = arg1_8
end

return var0_0

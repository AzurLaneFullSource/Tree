local var0 = class("LevelAmbushView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "LevelAmbushView"
end

function var0.OnInit(arg0)
	arg0:InitData()
	arg0:InitUI()
	setActive(arg0._tf, true)
end

function var0.InitData(arg0)
	arg0.chapter = arg0.contextData.chapterVO
	arg0.fleet = arg0.chapter.fleet

	local var0 = arg0.chapter:getChapterCell(arg0.fleet.line.row, arg0.fleet.line.column)

	arg0.template = pg.expedition_data_template[var0.attachmentId]
end

function var0.InitUI(arg0)
	local var0 = findTF(arg0._tf, "window")
	local var1 = findTF(arg0._tf, "window/ship/lv/Text")
	local var2 = findTF(arg0._tf, "window/ship/icon")
	local var3 = findTF(arg0._tf, "window/evade/rate")
	local var4 = findTF(arg0._tf, "window/fight_button")
	local var5 = findTF(arg0._tf, "window/dodge_button")

	GetImageSpriteFromAtlasAsync("enemies/" .. arg0.template.icon, "", var2)
	setText(var1, arg0.template.level)
	setText(var3, math.floor(arg0.chapter:getAmbushDodge(arg0.fleet) * 100) .. "%")
	onButton(arg0, var4, function()
		arg0:emit(LevelMediator2.ON_OP, {
			arg1 = 0,
			type = ChapterConst.OpAmbush,
			id = arg0.fleet.id
		})
		arg0:Destroy()
	end, SFX_UI_WEIGHANCHOR_ATTACK)
	onButton(arg0, var5, function()
		arg0:emit(LevelMediator2.ON_OP, {
			arg1 = 1,
			type = ChapterConst.OpAmbush,
			id = arg0.fleet.id
		})
		arg0:Destroy()
	end, SFX_UI_WEIGHANCHOR_AVOID)

	var0.localScale = Vector3(1, 0, 1)

	LeanTween.scaleY(var0.gameObject, 1, 0.3):setOnComplete(System.Action(arg0.onComplete))
end

function var0.OnDestroy(arg0)
	return
end

function var0.SetFuncOnComplete(arg0, arg1)
	arg0.onComplete = arg1
end

return var0

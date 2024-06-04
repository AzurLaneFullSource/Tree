local var0 = class("SenrankaguraPtPage", import(".TemplatePage.PtTemplatePage"))
local var1 = {
	1,
	9,
	19
}
local var2 = {
	"normal1",
	"normal2",
	"normal3"
}
local var3 = {
	"action1",
	"action2"
}
local var4 = {
	"hudongye_leijiPT_yin",
	"hudongye_leijiPT_jin"
}
local var5 = "ui/activityuipage/senrankaguraptpage_atlas"
local var6 = "ui-faguang2"
local var7 = 0.2

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.maskNode = arg0:findTF("mask", arg0.bg)
	arg0.bgImgTf = arg0:findTF("bg_img", arg0.bg)
	arg0.titleImgTf = arg0:findTF("title_img", arg0.bg)
	arg0.role = arg0:findTF("role", arg0.maskNode)
	arg0.title = arg0:findTF("title", arg0.maskNode)
	arg0.spineAnim = GetComponent(arg0.role, "SpineAnimUI")
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)

	local var0 = arg0.ptData:GetLevelProgress()
	local var1 = arg0:GetBeiBeiStage(var0)

	arg0:SetBgImage(var1)

	local var2 = var2[var1]

	arg0.spineAnim:SetAction(var2, 0)
	onButton(arg0, arg0.getBtn, function()
		local var0 = {}
		local var1 = arg0.ptData:GetAward()
		local var2 = getProxy(PlayerProxy):getRawData()
		local var3 = pg.gameset.urpt_chapter_max.description[1]
		local var4 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3)
		local var5, var6 = Task.StaticJudgeOverflow(var2.gold, var2.oil, var4, true, true, {
			{
				var1.type,
				var1.id,
				var1.count
			}
		})

		if var5 then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6,
					onYes = arg0
				})
			end)
		end

		table.insert(var0, function(arg0)
			arg0:PlayAnim(arg0)
		end)
		seriesAsync(var0, function()
			local var0, var1 = arg0.ptData:GetResProgress()

			arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0.ptData:GetId(),
				arg1 = var1
			})
		end)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
end

function var0.OnDestroy(arg0)
	if arg0.spineAnim then
		arg0.spineAnim:SetActionCallBack(nil)

		arg0.spineAnim = nil
	end
end

function var0.GetBeiBeiStage(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in ipairs(var1) do
		if iter1 <= arg1 then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.PlayAnim(arg0, arg1)
	if arg0.spineAnim then
		local var0 = arg0.ptData:GetLevelProgress()
		local var1 = arg0:GetBeiBeiStage(var0)
		local var2 = var2[var1]

		if arg0.playing then
			return
		end

		local var3 = table.indexof(var1, var0)

		if var3 and var3 > 1 then
			arg0.spineAnim:SetAction(var3[var3 - 1], 0)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var6)
			arg0.spineAnim:SetActionCallBack(function(arg0)
				if arg0 == "action" then
					arg0.playing = true
				end

				if arg0 == "finish" then
					arg0.spineAnim:SetActionCallBack(nil)
					arg0.spineAnim:SetAction(var2, 0)

					arg0.playing = false

					arg0:SetBgImage(var1, var7, arg1)
				end
			end)
		else
			arg1()
		end
	end
end

function var0.SetBgImage(arg0, arg1, arg2, arg3)
	arg2 = arg2 or 0

	for iter0 = 1, 3 do
		local var0 = findTF(arg0.bgImgTf, "img" .. iter0)
		local var1 = findTF(arg0.titleImgTf, "img" .. iter0)
		local var2 = iter0 == arg1 and 1 or 0

		LeanTween.alpha(var0, var2, arg2):setEase(LeanTweenType.easeOutQuad)
		LeanTween.alpha(var1, var2, arg2):setEase(LeanTweenType.easeOutQuad)

		if arg2 > 0 and arg1 > 1 then
			setActive(arg0:findTF(var4[arg1 - 1], arg0.bg), true)

			if arg3 then
				LeanTween.delayedCall(1, System.Action(arg3))
			end
		end
	end
end

return var0

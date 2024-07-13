local var0_0 = class("SenrankaguraPtPage", import(".TemplatePage.PtTemplatePage"))
local var1_0 = {
	1,
	9,
	19
}
local var2_0 = {
	"normal1",
	"normal2",
	"normal3"
}
local var3_0 = {
	"action1",
	"action2"
}
local var4_0 = {
	"hudongye_leijiPT_yin",
	"hudongye_leijiPT_jin"
}
local var5_0 = "ui/activityuipage/senrankaguraptpage_atlas"
local var6_0 = "ui-faguang2"
local var7_0 = 0.2

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.maskNode = arg0_1:findTF("mask", arg0_1.bg)
	arg0_1.bgImgTf = arg0_1:findTF("bg_img", arg0_1.bg)
	arg0_1.titleImgTf = arg0_1:findTF("title_img", arg0_1.bg)
	arg0_1.role = arg0_1:findTF("role", arg0_1.maskNode)
	arg0_1.title = arg0_1:findTF("title", arg0_1.maskNode)
	arg0_1.spineAnim = GetComponent(arg0_1.role, "SpineAnimUI")
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)

	local var0_2 = arg0_2.ptData:GetLevelProgress()
	local var1_2 = arg0_2:GetBeiBeiStage(var0_2)

	arg0_2:SetBgImage(var1_2)

	local var2_2 = var2_0[var1_2]

	arg0_2.spineAnim:SetAction(var2_2, 0)
	onButton(arg0_2, arg0_2.getBtn, function()
		local var0_3 = {}
		local var1_3 = arg0_2.ptData:GetAward()
		local var2_3 = getProxy(PlayerProxy):getRawData()
		local var3_3 = pg.gameset.urpt_chapter_max.description[1]
		local var4_3 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_3)
		local var5_3, var6_3 = Task.StaticJudgeOverflow(var2_3.gold, var2_3.oil, var4_3, true, true, {
			{
				var1_3.type,
				var1_3.id,
				var1_3.count
			}
		})

		if var5_3 then
			table.insert(var0_3, function(arg0_4)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_3,
					onYes = arg0_4
				})
			end)
		end

		table.insert(var0_3, function(arg0_5)
			arg0_2:PlayAnim(arg0_5)
		end)
		seriesAsync(var0_3, function()
			local var0_6, var1_6 = arg0_2.ptData:GetResProgress()

			arg0_2:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_2.ptData:GetId(),
				arg1 = var1_6
			})
		end)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_7)
	var0_0.super.OnUpdateFlush(arg0_7)
end

function var0_0.OnDestroy(arg0_8)
	if arg0_8.spineAnim then
		arg0_8.spineAnim:SetActionCallBack(nil)

		arg0_8.spineAnim = nil
	end
end

function var0_0.GetBeiBeiStage(arg0_9, arg1_9)
	local var0_9 = 0

	for iter0_9, iter1_9 in ipairs(var1_0) do
		if iter1_9 <= arg1_9 then
			var0_9 = var0_9 + 1
		end
	end

	return var0_9
end

function var0_0.PlayAnim(arg0_10, arg1_10)
	if arg0_10.spineAnim then
		local var0_10 = arg0_10.ptData:GetLevelProgress()
		local var1_10 = arg0_10:GetBeiBeiStage(var0_10)
		local var2_10 = var2_0[var1_10]

		if arg0_10.playing then
			return
		end

		local var3_10 = table.indexof(var1_0, var0_10)

		if var3_10 and var3_10 > 1 then
			arg0_10.spineAnim:SetAction(var3_0[var3_10 - 1], 0)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var6_0)
			arg0_10.spineAnim:SetActionCallBack(function(arg0_11)
				if arg0_11 == "action" then
					arg0_10.playing = true
				end

				if arg0_11 == "finish" then
					arg0_10.spineAnim:SetActionCallBack(nil)
					arg0_10.spineAnim:SetAction(var2_10, 0)

					arg0_10.playing = false

					arg0_10:SetBgImage(var1_10, var7_0, arg1_10)
				end
			end)
		else
			arg1_10()
		end
	end
end

function var0_0.SetBgImage(arg0_12, arg1_12, arg2_12, arg3_12)
	arg2_12 = arg2_12 or 0

	for iter0_12 = 1, 3 do
		local var0_12 = findTF(arg0_12.bgImgTf, "img" .. iter0_12)
		local var1_12 = findTF(arg0_12.titleImgTf, "img" .. iter0_12)
		local var2_12 = iter0_12 == arg1_12 and 1 or 0

		LeanTween.alpha(var0_12, var2_12, arg2_12):setEase(LeanTweenType.easeOutQuad)
		LeanTween.alpha(var1_12, var2_12, arg2_12):setEase(LeanTweenType.easeOutQuad)

		if arg2_12 > 0 and arg1_12 > 1 then
			setActive(arg0_12:findTF(var4_0[arg1_12 - 1], arg0_12.bg), true)

			if arg3_12 then
				LeanTween.delayedCall(1, System.Action(arg3_12))
			end
		end
	end
end

return var0_0

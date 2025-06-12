local var0_0 = class("Dorm3dDanceResultSubView", import("..Dorm3dGameBaseSubView"))
local var1_0 = "S"
local var2_0 = "A"
local var3_0 = "B"
local var4_0 = "C"

local function var5_0(arg0_1)
	for iter0_1, iter1_1 in pairs(Dorm3dDanceConst.SCORE_RANGE) do
		if arg0_1 >= iter1_1[1] and arg0_1 <= iter1_1[2] then
			return iter0_1
		end
	end

	return var4_0
end

function var0_0.Init(arg0_2)
	arg0_2.resultCucoloris = arg0_2._tf:Find("top/cucoloris")
	arg0_2.resultScoreText = arg0_2._tf:Find("top/score")
	arg0_2.scoreAnim = arg0_2.resultScoreText:GetComponent(typeof(Animation))
	arg0_2.btnAgain = arg0_2._tf:Find("btn_again")
	arg0_2.btnExit = arg0_2._tf:Find("btn_exit")
	arg0_2.photoContainer = arg0_2._tf:Find("top/photos")
	arg0_2.photoTpl = arg0_2._tf:Find("tpl")
	arg0_2.rank = arg0_2._tf:Find("top/rank")

	setText(arg0_2.btnAgain:Find("Text"), i18n("dorm3d_cafe_minigame4"))
	setText(arg0_2.btnExit:Find("Text"), i18n("dorm3d_cafe_minigame5"))
	onButton(arg0_2, arg0_2.btnAgain, function()
		arg0_2.contextData.onAgain()
	end, SFX_DORM_CLICK)
	onButton(arg0_2, arg0_2.btnExit, function()
		arg0_2.contextData.onExit()
	end, SFX_DORM_BACK)

	arg0_2.LTList = {}
end

function var0_0.Flush(arg0_5)
	arg0_5:ClearLeanTween()
	setActive(arg0_5.btnExit, false)
	setActive(arg0_5.btnAgain, false)

	arg0_5.photoTfs = {}

	local var0_5 = 0
	local var1_5 = {}

	for iter0_5 = 1, #arg0_5.contextData.cucoloris do
		local var2_5 = arg0_5.contextData.cucoloris[iter0_5]
		local var3_5 = arg0_5.contextData.photoData[arg0_5.contextData.match[iter0_5]]
		local var4_5, var5_5 = var2_5:CalcScore(var3_5)

		var0_5 = var0_5 + var4_5

		table.insert(var1_5, {
			score = var0_5,
			rank = var5_0(var0_5),
			match = var5_5
		})
	end

	for iter1_5 = 1, #arg0_5.contextData.cucoloris do
		local var6_5 = arg0_5.resultCucoloris:GetChild(iter1_5 - 1)

		LoadImageSpriteAtlasAsync(arg0_5.contextData.cucoloris[iter1_5]:GetIcon(), "", var6_5:Find("Image"), true)
		LoadImageSpriteAtlasAsync(arg0_5.contextData.cucoloris[iter1_5]:GetOutline(), "", var6_5:Find("outline"), true)
		setText(var6_5:Find("match"), i18n("dorm3d_cafe_minigame6", var1_5[iter1_5].match))
		setActive(var6_5:Find("match"), false)
		setImageAlpha(var6_5:Find("Image"), 1)
	end

	for iter2_5 = 1, #arg0_5.contextData.photoData do
		local var7_5 = arg0_5.photoContainer:GetChild(iter2_5 - 1):Find("photo")

		arg0_5.photoTfs[iter2_5] = var7_5

		local var8_5 = math.random(Dorm3dDanceConst.RESULT_RANDOM_RANGE_POSY[1], Dorm3dDanceConst.RESULT_RANDOM_RANGE_POSY[2])
		local var9_5 = math.random(Dorm3dDanceConst.RESULT_RANDOM_RANGE_ANGLE[1], Dorm3dDanceConst.RESULT_RANDOM_RANGE_ANGLE[2])

		var7_5.localPosition = Vector3(randx, var8_5, 0)
		var7_5.localEulerAngles = Vector3(0, 0, var9_5)
		var7_5.localScale = Vector3.one

		arg0_5.contextData.onShowRealImage(iter2_5, var7_5:Find("mask/Image"), var7_5:Find("mask"))
	end

	setText(arg0_5.resultScoreText, 0)
	arg0_5:ShowRank(var4_0)

	local var10_5 = {}
	local var11_5 = 0
	local var12_5 = #arg0_5.contextData.cucoloris

	local function var13_5(arg0_6, arg1_6)
		var10_5[arg0_6 + var11_5 * var12_5] = arg1_6
		var11_5 = var11_5 + 1
	end

	local function var14_5()
		for iter0_7 = 1, #arg0_5.contextData.cucoloris do
			local var0_7 = arg0_5.contextData.match[iter0_7]
			local var1_7 = arg0_5.resultCucoloris:GetChild(iter0_7 - 1)
			local var2_7 = arg0_5.photoTfs[var0_7]

			var11_5 = 0

			var13_5(iter0_7, function(arg0_8)
				local var0_8 = var1_7.position
				local var1_8 = var2_7.parent:InverseTransformPoint(var0_8)

				table.insert(arg0_5.LTList, LeanTween.move(var2_7, var1_8, Dorm3dDanceConst.PHOTO_MOVE_TIME):setOnComplete(System.Action(arg0_8)).uniqueId)
				table.insert(arg0_5.LTList, LeanTween.rotateZ(go(var2_7), 0, Dorm3dDanceConst.PHOTO_MOVE_TIME).uniqueId)
				table.insert(arg0_5.LTList, LeanTween.scale(var2_7, Dorm3dDanceConst.PHOTO_SCALE, Dorm3dDanceConst.PHOTO_MOVE_TIME).uniqueId)
			end)
			var13_5(iter0_7, function(arg0_9)
				local function var0_9()
					arg0_9()
					table.insert(arg0_5.LTList, LeanTween.alpha(var1_7:Find("Image"), 0, Dorm3dDanceConst.CUCOLORIS_FADE_50_0).uniqueId)
				end

				table.insert(arg0_5.LTList, LeanTween.alpha(var1_7:Find("Image"), 0.5, Dorm3dDanceConst.CUCOLORIS_FADE_100_50):setOnComplete(System.Action(var0_9)).uniqueId)
			end)
			var13_5(iter0_7, function(arg0_11)
				local function var0_11()
					setText(arg0_5.resultScoreText, var1_5[iter0_7].score)
					arg0_5:ShowRank(var1_5[iter0_7].rank)
					table.insert(arg0_5.LTList, LeanTween.delayedCall(Dorm3dDanceConst.RANK_ANIM_TIME, System.Action(arg0_11)).uniqueId)
				end

				local function var1_11()
					arg0_5.scoreAnim:Play("anim_score_enter")
					table.insert(arg0_5.LTList, LeanTween.delayedCall(Dorm3dDanceConst.SCORE_ANIM_TIME, System.Action(var0_11)).uniqueId)
				end

				setActive(var1_7:Find("match"), true)
				table.insert(arg0_5.LTList, LeanTween.delayedCall(Dorm3dDanceConst.MATCH_ANIM_TIME, System.Action(var1_11)).uniqueId)
			end)
		end

		seriesAsync(var10_5, function()
			setActive(arg0_5.btnAgain, true)
			setActive(arg0_5.btnExit, true)
		end)
	end

	arg0_5._tf:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		var14_5()
	end)
end

function var0_0.ShowRank(arg0_16, arg1_16)
	setActive(arg0_16.rank:Find("S"), arg1_16 == var1_0)
	setActive(arg0_16.rank:Find("A"), arg1_16 == var2_0)
	setActive(arg0_16.rank:Find("B"), arg1_16 == var3_0)
	setActive(arg0_16.rank:Find("C"), arg1_16 == var4_0)
end

function var0_0.ClearLeanTween(arg0_17)
	for iter0_17, iter1_17 in ipairs(arg0_17.LTList) do
		LeanTween.cancel(iter1_17)
	end

	arg0_17.LTList = {}
end

function var0_0.Dispose(arg0_18)
	arg0_18:ClearLeanTween()
end

return var0_0
